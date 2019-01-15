-- 重构Room的逻辑
-- 重构Room.lua
-- 将之前的RoomLogic和utils.room的代码合并到一起，理顺逻辑
-- XavierCHN@2017.03.15
-- Update 1 @ 2017.06.10
--     取消使用Cell和Prop的方式，使用多个地形来作为地形随机的方式
--

---@class Room
---@field x 这个房间的X坐标（属于Map的）
---@field y 这个房间的Y坐标（属于Map的）
---@field nRoomType 这个房间的房间类型
---@field bFinished 已经完成的标志
---@field bVisited 已经访问过的标志
---@field bIsActive 是否激活的标志
---@field vRoomInstance 房间实例
---@field vDoors 房间内的所有门，包括进入下一层的所有门
---@field vMap 所属的地图（Map）
---@field vItemsInRoom 房间内的所有物品
---@field vUnits 房间内的生物（主要是陷阱之类的（会复生的战斗单位不在此列））
---@field flMinX （四个方向的最大最小坐标）
---@field flMinY
---@field flMaxX
---@field flMaxY
Room                            = class({})

-- 构造函数
---@return Room
function Room:constructor(x, y, type)
    self.x             = x
    self.y             = y
    self.nRoomType     = type
    self.bFinished     = false
    self.bVisited      = false
    self.bIsActive     = false
    self.vRoomInstance = nil
    self.vCells        = {}
    self.vDoors        = {}
    self.vItemsInRoom  = {}
    self.vUnits        = {}
    self.nCellCountX   = 0
    self.nCellCountY   = 0
    self.flMinX        = 0
    self.flMaxX        = 0
    self.flMinY        = 0
    self.flMaxY        = 0
    self.vDoorPositions = {}
end
-- 房间的初始化，
-- 这个函数由Map.lua在所有房间都生成完毕之后调用
function Room:Initialize(map)
    self.vMap = map
    -- 选择房间内容
    self:_SelectRoomInstance()
    -- 初始化房间的尺寸等信息
    self:_SetupRoomPositions()
    -- 生成门
    self:SetupDoors(map)
end
-- 确定房间的四个坐标点的位置和单元格大小
function Room:_SetupRoomPositions()
    -- 房间所在的地形位置
    local terrain = self.vRoomInstance:GetTerrainName()

    if terrain then
        local entLeftBottom = Entities:FindByName(nil, terrain .. "_lb"):GetOrigin()
        local entRightTop = Entities:FindByName(nil, terrain .. "_rt"):GetOrigin()
        self.flMinX = entLeftBottom.x
        self.flMaxX = entRightTop.x
        self.flMinY = entLeftBottom.y
        self.flMaxY = entRightTop.y
        self.flDefaultGroundHeight = entLeftBottom.z

        self.vDoorPositions["up"]    = Entities:FindByName(nil, terrain .. "_dt"):GetOrigin()
        self.vDoorPositions["down"]  = Entities:FindByName(nil, terrain .. "_db"):GetOrigin()
        self.vDoorPositions["left"]  = Entities:FindByName(nil, terrain .. "_dl"):GetOrigin()
        self.vDoorPositions["right"] = Entities:FindByName(nil, terrain .. "_dr"):GetOrigin()
    else
        -- 如果没有顺利找到地形，那么报错
        error("Not valid terrain found in room " .. self.vRoomInstance.UniqueName)
    end
end
-- 为房间创建门，这个由map在所有的房间都创建完成后调用
---@param map Map
function Room:SetupDoors(map)
    for direction, offset in pairs(Directions) do
        local offsetX, offsetY = offset[1], offset[2]
        local roomAtDirection  = map:FindRoomAtCoord(self.x + offsetX, self.y + offsetY)
        -- 创建一个门，根据对面房间的类型确定门的类型
        -- 如果没有门，那么也创建一个空门
        local door = Door(direction, roomAtDirection)
        door:SetOrigin(self:GetDoorPosition(direction))
        table.insert(self.vDoors, door)

        if roomAtDirection then
            -- print(string.format("creating door in room [%2d,%2d] %s %s", self.x, self.y, direction, roomAtDirection:GetRoomType()))
        end
    end
    -- 如果是最终BOSS的房间，那么还有一个进入下一层的门
    if self.nRoomType == RoomType.FinalBoss then
        local door = Door()
        door:SetType(- 1)
        door:SetOrigin(self:GetCenter())
        table.insert(self.vDoors, door)
    end
end
-- 将玩家移动到这个房间内
function Room:_MovePlayerIntoRoom(direction)
    -- 移动玩家到目标房间
    local nPlayerMoved = 0
    local soundPlayed  = false
    for _, hero in pairs(GameRules.gamemode:GetAllHeroes()) do

        local door_origin = self:GetDoorPosition(direction)
        local dir         = Directions[direction]
        -- print(dir)
        -- 放到比检测范围更大的位置，避免回去一个已经完成的房间又回来了
        local offset      = -100 * Vector(dir[1], dir[2], 0)
        local origin      = door_origin + offset
        local vPositionOffset
        if dir[1] == 0 then
            vPositionOffset = Vector(128 * nPlayerMoved, 0, 0)
        else
            vPositionOffset = Vector(0, 128 * nPlayerMoved, 0)
        end

        -- 移动英雄，跟随镜头
        FindClearSpaceForUnit(hero, origin + vPositionOffset, true)

        PlayerResource:SetCameraTarget(hero:GetPlayerID(), hero)
        hero:Stop()

        Timer(0.3, function()
            PlayerResource:SetCameraTarget(hero:GetPlayerID(), nil)
        end)

        -- 播放声音
        if not soundPlayed then
            EmitSoundOnLocationForAllies(door_origin, "DOTA_Item.PhaseBoots.Activate", hero)
            soundPlayed = true
        end
        hero:AddNewModifier(hero, nil, "modifier_phased", {Duration=0.1})
    end
end

-- 开始进入这个房间
function Room:EnterRoom(direction)

    -- 以下东西的步骤不要轻易调换！！

    -- 设置当前房间为这个房间(方便其他地方调用)
    GameRules.gamemode:SetCurrentRoom(self)

    -- 如果尚未确定随机的房间内容，选择一个房间内容
    if not self.vRoomInstance then
        self:_SelectRoomInstance()
    end

    -- 将玩家移动到这个房间
    if direction then
        self:_MovePlayerIntoRoom(direction)
    end

    -- 设置为已经访问过
    self.bVisited = true

    -- 如果有房间内的物品（玩家之前丢弃的，重新创建之）
    if self.vItemsInRoom then
        for _, itemMsg in pairs(self.vItemsInRoom) do
            local item = utilsBonus.DropLootItem(itemMsg.itemName, itemMsg.position, 0, 0)
            item:SetCurrentCharges(itemMsg.charges)
        end
    end

    -- 监听房间内生物出生（当玩家退出房间的时候停止）
    self.nNpcSpawnedListener   = ListenToGameEvent("npc_spawned", Dynamic_Wrap(Room, "OnNpcSpawned"), self)

    -- 监听房间内生物死亡（当玩家退出房间的时候停止）
    self.nEntityKilledListener = ListenToGameEvent("entity_killed", Dynamic_Wrap(Room, "OnEntityKilled"), self)

    -- 设置为激活的房间
    self.bIsActive             = true

    -- 启动是否已经完成的检查器
    self:_StartFinishChecker()

    -- 启动是否团灭的检查器
    self:_StartAllDeadCheker()

    -- 调用进入这个房间的回调
    self.vRoomInstance:OnEnter()

    -- 如果这个房间不是初始房间，那么设置玩家已经进入过其他房间了（不允许再调换信使）
    if self:GetRoomType() ~= RoomType.Start and not GameRules.bPlayerEnteredNoneStartRoom then
        GameRules.bPlayerEnteredNoneStartRoom = true
        -- 开始游戏计时器
        GameRules.flGameStartTime = Time()
        CustomNetTables:SetTableValue("game_state","game_start_time",{value = GameRules.flGameStartTime})
    end

    -- 发送信息到客户端，更新小地图
    GameRules.gamemode:GetCurrentMap():SendMapMessageToClient()
    CustomGameEventManager:Send_ServerToAllClients("ed_current_room_changed",{
        x = self.x, y = self.y
    })
end
-- 退出这个房间
function Room:ExitRoom()
    for _, door in pairs(self.vDoors) do
        door:Block()
    end

    -- 调用退出房间的回调
    self.vRoomInstance:OnExit()

    -- 设置为非激活的房间
    self.bIsActive = false

    -- 暂停生物击杀和死亡的监听器
    StopListeningToGameEvent(self.nEntityKilledListener)
    StopListeningToGameEvent(self.nNpcSpawnedListener)

    -- 杀死所有的生物
    local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
    if # units > 0 then
        for _, unit in pairs(units) do
            unit:SetAbsOrigin(Vector(9999, 9999, 0))
            unit:ForceKill(false)
        end
    end

    -- 储存所有的物品
    self.vItemsInRoom = {}
    for _, item in pairs( Entities:FindAllByClassname( "dota_item_drop")) do
        local containedItem = item:GetContainedItem()
        local itemMsg = {
            itemName = containedItem:GetAbilityName(),
            position = item:GetAbsOrigin(),
            charges  = item:GetContainedItem():GetCurrentCharges(),
        }

        -- 储存
        table.insert(self.vItemsInRoom, itemMsg)

        -- 移除
        if containedItem then
            UTIL_RemoveImmediate(containedItem)
        end
        UTIL_Remove(item)
    end
end
-- 选择一个随机的房间内容
function Room:_SelectRoomInstance()
    if not GameRules then
        return
    end

    if not GameRules.AllRooms then
        error("no any room found, check your code")
    end

    local possibleRooms = {}
    local playerCount   = GameRules.gamemode:GetPlayerCount()
    local level = GameRules.gamemode:GetCurrentLevel()

    for _, room in pairs(GameRules.AllRooms) do
        -- 要求满足的几个要求
        local fit = true

        -- 满足房间类型
        if room.RoomType ~= self.nRoomType then
            fit = false
        end
        -- 满足玩家数量要求
        if not table.contains(room.SupportPlayers, playerCount) then
            fit = false
        end
        -- 满足层数要求
        local lvlRangeMin, lvlRangeMax = room.LevelRange[1], room.LevelRange[2]
        if (lvlRangeMin and level < lvlRangeMin) or
        (lvlRangeMax and level > lvlRangeMax) then
            fit = false
        end

        -- 最大载入次数的限制
        if room.MaxLoadTimes then
            room.__nLoadTimes__ = room.__nLoadTimes__  or 0
            if room.__nLoadTimes__ >= room.MaxLoadTimes then
                fit = false
            end
        end

        -- 所有的BOSS房间默认只载入一次
        if room.RoomType == RoomType.FinalBoss or room.RoomType == RoomType.SemiBoss then
            if room.__nLoadTimes__ and room.__nLoadTimes__ > 0 then
                fit = false
            end
        end

        if fit then
            table.insert(possibleRooms, room)
        end
    end

    local randomRoom = table.random_with_weight(possibleRooms)

    if randomRoom then

        -- 记录这个房间已经载入的次数
        randomRoom.__nLoadTimes__ = randomRoom.__nLoadTimes__ or 0
        randomRoom.__nLoadTimes__ = 1

        -- 载入的概率降低40%；
        randomRoom._nWeight = randomRoom._nWeight * 0.6

        print("Loading room at level", GameRules.gamemode:GetCurrentLevel(), randomRoom.LevelRange[1], randomRoom.LevelRange[2])

        self.vRoomInstance = randomRoom( self )
    else
        print("ERROR! room instance create failed! room type ->", self.RoomType)

        -- 如果没有正常的房间，那么载入默认的空房间
        --
        Say(nil,"Loading fail safe room instance",true)
        self.vRoomInstance = EDRoom(self)
    end
end
-- 当玩家进入一个房间之后，检查这个房间是否已经完成
function Room:_StartFinishChecker()
    -- 已经是处于完成状态了
    if self.bFinished then
        -- 显示出门，并启动进入门的检查器
        self:_ShowDoorsAndStartEnterDoorChecker()
    end

    -- 如果尚未进入完成状态
    if not self.bFinished then

        -- 调用房间的准备工作
        self.vRoomInstance:OnPrepare()

        -- 设置音乐状态
        -- for _, player in pairs(GameRules.gamemode:GetAllPlayers()) do
        -- player:SetMusicStatus(DOTA_MUSIC_STATUS_BATTLE, 1)
        -- end
        if self.nRoomType == RoomType.Start
        then
            -- GameRules.MusicPlayer:SetMusicState(EDMusicState.StartUp)
        elseif self.nRoomType == RoomType.Normal
        then
            -- GameRules.MusicPlayer:SetMusicState(EDMusicState.Battle)
        elseif self.nRoomType == RoomType.FinalBoss
        or self.nRoomType == RoomType.SemiBoss
        then
            -- GameRules.MusicPlayer:SetMusicState(EDMusicState.Boss)
        end

        -- 如果有需要房间内AI循环的，启动房间内AI循环
        if self.vRoomInstance.OnAIThink then
            Timer(0, function()
                return self.vRoomInstance:OnAIThink()
            end)
        end

        -- 开始循环检查是否已经完成
        Timer(0, function()

            if not self.bIsActive then
                return nil
            end

            -- 如果有需要显示BOSS血条的，显示BOSS血条
            local boss = self.vRoomInstance:GetBossHealthBarEntity()
            GameRules.nBossHealthBarEntity = nil
            if boss and IsValidAlive(boss) and GameRules.nBossHealthBarEntity ~= boss:GetEntityIndex() then
                GameRules.nBossHealthBarEntity = boss:GetEntityIndex()
                boss:AddNewModifier(boss, nil, "modifier_no_healthbar", {})
                CustomGameEventManager:Send_ServerToAllClients("ed_show_boss_health_bar", {
                    EntityIndex = tostring(boss:GetEntityIndex())
                })
            end

            -- 如果检查已经完成了的
            if self.vRoomInstance:CheckFinish() or self.bForceFinished then

                self.bFinished = true

                -- 调用只调用一次的OnFinish
                self.vRoomInstance:OnFinish()

                -- 设置音乐状态
                -- GameRules.MusicPlayer:SetMusicState(EDMusicState.BattleEnd)

                -- 触发完成房间的事件，只有需要战斗的房间才能触发完成
                -- todo，之后的挑战房之类的东西也需要触发这个
                if self.nRoomType == RoomType.Normal or
                self.nRoomType == RoomType.SemiBoss or
                self.nRoomType == RoomType.FinalBoss then

                    EDEventListener:Trigger("ed_finish_room", {
                        Room = self
                    })
                end

                -- 显示出门，并启动进入门的检查器
                self:_ShowDoorsAndStartEnterDoorChecker()

                return nil
            end
            return 0.1
        end)
    end
end
-- 检查是否已经团灭
function Room:_StartAllDeadCheker()
    Timer(0, function()

        if not self.bIsActive then
            return nil
        end

        -- 检查是否团灭
        local bAllDead   = true
        local vAllHeroes = GameRules.gamemode:GetAllHeroes()
        for _, hero in pairs(vAllHeroes) do
            if not hero._bIsDisconnected then
                if IsValidEntity(hero) and (hero:IsAlive() or hero:HasItemInInventory("item_ed_aegis"))  then
                    bAllDead = false
                end
            end
        end

        -- 如果已经全死了
        if bAllDead then

            -- 启动复活倒计时
            for _, hero in pairs(vAllHeroes) do
                hero:SetTimeUntilRespawn(HERO_RESPAWN_DELAY)
            end

            Timer(HERO_RESPAWN_DELAY, function()

                -- 退出房间
                self:ExitRoom()

                -- 进入初始房间
                local startingRoom = GameRules.gamemode:GetCurrentMap():GetStartRoom()

                -- 复活英雄
                for _, hero in pairs(vAllHeroes) do
                    hero:RespawnHero(false, false, false)
                end

                -- 进入初始房间
                startingRoom:EnterRoom()

                -- 显示是否重新开始
                -- 还是要结束游戏
                CustomNetTables:SetTableValue("game_state","current_state",{state="waiting_for_retry"})
            end)

            return nil
        end

        return 0.1
    end)
end
-- 当一个房间已经完成了，显示出门，之后启动进入门的检查
function Room:_ShowDoorsAndStartEnterDoorChecker()

    -- 显示普通门
    for _, door in pairs(self.vDoors) do
        door:Show()
    end

    Timer(0, function()

        if not self.bIsActive then
            return nil
        end

        -- 所有普通的门
        for _, door in pairs(self.vDoors) do
            if door:IsEnterable() then
                local bAllHere = true
                for _, hero in pairs(GameRules.gamemode:GetAllHeroes()) do
                    if not door:IsUnitEnteringDoor(hero) then
                        bAllHere = false
                        break
                    end
                end

                if bAllHere then
                    -- 如果是进入下一层的门，那么直接进入下一层
                    if door:IsDoorToNextLevel() then
                        -- 播放进入下一层的动画
                        local animationTime = 2
                        for _, hero in pairs(GameRules.gamemode:GetAllHeroes()) do
                            hero:AddNewModifier(hero, nil, "modifier_player_entering_next_level", { Duration = animationTime })
                            Timer(animationTime, function()
                                -- 退出这个房间
                                self:ExitRoom()
                                GameRules.gamemode:EnterNextLevel()
                            end)
                        end
                        return
                    end

                    -- 退出这个房间
                    self:ExitRoom()

                    local targetRoom = door:GetTargetRoom()

                    local direction
                    local dx         = self.x - targetRoom.x
                    local dy         = self.y - targetRoom.y
                    for name, offset in pairs(Directions) do
                        local _x, _y = offset[1], offset[2]
                        if _x == dx and _y == dy then
                            direction = name
                        end
                    end
                    targetRoom:EnterRoom(direction)
                end
            end
        end

        return 0.1
    end)
end

-- 当生物出生
---@param args table
function Room:OnNpcSpawned(args)
    local npcSpawned = EntIndexToHScript(args.entindex)

    if not npcSpawned
    or npcSpawned:GetClassname() == "npc_dota_thinker"
    or npcSpawned:IsPhantom()
    then
        return
    end

    if self.vRoomInstance.OnNpcSpawned then
        self.vRoomInstance:OnNpcSpawned(npcSpawned)
    end
end
-- 当生物死亡
---@param args table
function Room:OnEntityKilled(args)
    local entityKilled = EntIndexToHScript(args.entindex_killed)
    if entityKilled then
        -- 给金币
        if (entityKilled:GetTeamNumber() == DOTA_TEAM_NEUTRALS
        and self:GetRoomType() == RoomType.Normal
        ) then
            if RollPercentage(COIN_DROP_CHANCE) then
                self.nTotalCoinsDropped = self.nTotalCoinsDropped or 0
                if self.nTotalCoinsDropped <= self.nMaxCoinDrop then
                    self.nTotalCoinsDropped = self.nTotalCoinsDropped + 1
                    utilsBonus.DropLootItem("item_coin", entityKilled:GetAbsOrigin(), 30)
                end
            end
        end
    end
end
-- 获取房门的位置
---@param direction Directions
function Room:GetDoorPosition(direction)
    return self.vDoorPositions[direction]
end

-- 判断这个房间是否已经访问过
function Room:IsVisited()
    return self.bVisited
end
-- 判断这个房间是否应被判定完成
function Room:IsFinished()
    return self.bFinished
end
function Room:GetRoomType()
    return self.nRoomType
end
function Room:GetMaxX()
    return self.flMaxX
end
function Room:GetMinX()
    return self.flMinX
end
function Room:GetMaxY()
    return self.flMaxY
end
function Room:GetMinY()
    return self.flMinY
end
function Room:GetCenter()
    local x = (self.flMinX + self.flMaxX) / 2
    local y = (self.flMinY + self.flMaxY) / 2
    return Vector(x, y, self.flDefaultGroundHeight)
end
function Room:GetRandomPositionInRoom()
    return Vector(RandomFloat(self.flMinX, self.flMaxX), RandomFloat(self.flMinY, self.flMaxY), self.flDefaultGroundHeight)
end
function Room:GetCorners()
    local cs = {}
    cs[1]    = Vector(self.flMinX, self.flMinY, self.flDefaultGroundHeight)
    cs[2]    = Vector(self.flMinX, self.flMinY, self.flDefaultGroundHeight)
    cs[3]    = Vector(self.flMinX, self.flMaxY, self.flDefaultGroundHeight)
    cs[4]    = Vector(self.flMaxX, self.flMaxY, self.flDefaultGroundHeight)
    return cs
end
function Room:GetRandomCorner()
    return table.random(self:GetCorners())
end
function Room:GetRandomPositionsInRoom(count)
    local r = {}
    for i = 1, count do
        -- 随机在房间内获取N个随机的位置
        table.insert(r, self:GetRandomPositionInRoom())
    end
    return r
end
function Room:GetRandomTopPosition()
    return Vector(RandomFloat(self.flMinX, self.flMaxX), self.flMaxY, self.flDefaultGroundHeight)
end
function Room:GetRandomBottomPosition()
    return Vector(RandomFloat(self.flMinX, self.flMaxX), self.flMinY, self.flDefaultGroundHeight)
end
function Room:GetRandomLeftPosition()
    return Vector(self.flMinX, RandomFloat(self.flMinY, self.flMaxY), self.flDefaultGroundHeight)
end
function Room:GetRandomRightPosition()
    return Vector(self.flMaxX, RandomFloat(self.flMinY, self.flMaxY), self.flDefaultGroundHeight)
end


---=======================================================================================================
-- 加入全局函数
function GetMaxX()
    return GameRules.gamemode:GetCurrentRoom():GetMaxX()
end
function GetMinX()
    return GameRules.gamemode:GetCurrentRoom():GetMinX()
end
function GetMaxY()
    return GameRules.gamemode:GetCurrentRoom():GetMaxY()
end
function GetMinY()
    return GameRules.gamemode:GetCurrentRoom():GetMinY()
end
function GetCenter()
    return GameRules.gamemode:GetCurrentRoom():GetCenter()
end
function GetCorners()
    return GameRules.gamemode:GetCurrentRoom():GetCorners()
end
function GetRandomCorner()
    return GameRules.gamemode:GetCurrentRoom():GetRandomCorner()
end
function GetRandomPositionInRoom()
    return GameRules.gamemode:GetCurrentRoom():GetRandomPositionInRoom()
end
function GetRandomPositionsInRoom(count)
    count = count or 1
    return GameRules.gamemode:GetCurrentRoom():GetRandomPositionsInRoom(count)
end
function GetRandomTopPosition()
    return GameRules.gamemode:GetCurrentRoom():GetRandomTopPosition()
end
function GetRandomBottomPosition()
    return GameRules.gamemode:GetCurrentRoom():GetRandomBottomPosition()
end
function GetRandomLeftPosition()
    return GameRules.gamemode:GetCurrentRoom():GetRandomLeftPosition()
end
function GetRandomRightPosition()
    return GameRules.gamemode:GetCurrentRoom():GetRandomRightPosition()
end
---=======================================================================================================
