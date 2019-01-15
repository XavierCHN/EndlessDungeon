--- 毎完成一个房间的掉率（普通）
local ITEM_DROP_RATE =    { 2, 3, 3, 4, 5, 5, 6}
local CHEST_APPEAR_RATE = { 2, 3, 3, 4, 5, 5, 6}
local BOMB_APPEAR_RATE =  { 2, 3, 3, 4, 5, 5, 6}
local KEY_APPEAR_RATE =   { 2, 3, 3, 4, 5, 5, 6}
local ABILITY_DROP_RATE = { 1, 2, 2, 3, 3, 4, 4}

-- 当一个玩家完成了一个房间
EDEventListener:RegisterListener("ed_finish_room", function(args)
    local room = args.Room
    local level = GameRules.gamemode:GetCurrentLevel()
    local randomValidSpawnLocations = GetRandomSpawnPositionsAroundCoord(11, 7, 5)
    -- 普通房间
    if room:GetRoomType() == RoomType.Normal then
        if RollPercentage(CHEST_APPEAR_RATE[level]) then
            local x, y = GetCellCoordAtPosition(randomValidSpawnLocations[1])
            room:InsertProp("prop_chest", x, y)
        end
        if RollPercentage(ITEM_DROP_RATE[level]) then
            local item = GetRandomDropItem()
            utilsBonus.DropLootItem(item, randomValidSpawnLocations[2], 0)
        end
        if RollPercentage(BOMB_APPEAR_RATE[level]) then
            utilsBonus.DropLootItem("item_bomb", randomValidSpawnLocations[3], 0)
        end
        if RollPercentage(KEY_APPEAR_RATE[level]) then
            utilsBonus.DropLootItem("item_key", randomValidSpawnLocations[4], 0)
        end
        if RollPercentage(ABILITY_DROP_RATE[level]) then
            local heroAbilityRecipe = GetRandomDropAbility()
            utilsBonus.DropLootItem(heroAbilityRecipe, randomValidSpawnLocations[4], 0)
        end
    end
    -- 小BOSS房间(必定掉落一个物品或者技能)
    if room:GetRoomType() == RoomType.SemiBoss then
        local item
        if RollPercentage(80) then
            item = GetRandomDropItem()
        else
            item = GetRandomDropAbility()
        end
        utilsBonus.DropLootItem(item, randomValidSpawnLocations[4], 0)
    end

    -- 大BOSS房间，必定掉落一个物品或技能
    if room:GetRoomType() == RoomType.FinalBoss then
        local item
        if RollPercentage(50) then
            item = GetRandomDropItem()
        else
            item = GetRandomDropAbility()
        end
        utilsBonus.DropLootItem(item, randomValidSpawnLocations[4], 0)
    end
end)