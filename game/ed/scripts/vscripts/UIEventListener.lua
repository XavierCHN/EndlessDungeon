function CEDGameMode:_RegisterCustomGameEventListeners()

    -- 重roll商店物品
    CustomGameEventManager:RegisterListener("ed_player_reroll_shop_items", function(_, keys)
        self:_OnPlayerRerollShopItems(keys)
    end)
    -- 购买商店物品
    CustomGameEventManager:RegisterListener("ed_player_purchase_item", function(_, keys)
        self:_OnPlayerPurchaseItem(keys)
    end)

    -- 客户端获取房间信息（用以显示小地图）
    CustomGameEventManager:RegisterListener("ed_client_request_room_data", function(_, keys)
        self:_OnClientRequestRoomData(keys)
    end)

    CustomGameEventManager:RegisterListener("ed_client_request_inventory_data", function(_, keys)
        self:_OnClientSwitchInventory(keys)
    end)

    -- 当前剩余生命
    CustomGameEventManager:RegisterListener("ed_client_request_lives_left", function()
        self:SendLivesLeftToClient()
    end)

    -- 射击相关
    -- CustomGameEventManager:RegisterListener("ed_player_shoot", function(_, keys)
        -- self:_OnPlayerShoot(keys)
    -- end)
    -- CustomGameEventManager:RegisterListener("ed_update_mouse_position", function(_, keys)
        -- self:_OnPlayerUpdateMousePosition(keys)
    -- end)
    -- CustomGameEventManager:RegisterListener("ed_player_start_shoot", function(_, keys)
    --     self:_OnPlayerStartShoot(keys)
    -- end)
    -- CustomGameEventManager:RegisterListener("ed_player_end_shoot", function(_, keys)
    --     self:_OnPlayerEndShoot(keys)
    -- end)


    -- 移动相关
    CustomGameEventManager:RegisterListener("ed_player_start_move_up", function(_, keys)
        self:On_ed_player_start_move_up(keys)
    end)
    CustomGameEventManager:RegisterListener("ed_player_start_move_down", function(_, keys)
        self:On_ed_player_start_move_down(keys)
    end)
    CustomGameEventManager:RegisterListener("ed_player_start_move_left", function(_, keys)
        self:On_ed_player_start_move_left(keys)
    end)
    CustomGameEventManager:RegisterListener("ed_player_start_move_right", function(_, keys)
        self:On_ed_player_start_move_right(keys)
    end)
    CustomGameEventManager:RegisterListener("ed_player_end_move_up", function(_, keys)
        self:On_ed_player_end_move_up(keys)
    end)
    CustomGameEventManager:RegisterListener("ed_player_end_move_down", function(_, keys)
        self:On_ed_player_end_move_down(keys)
    end)
    CustomGameEventManager:RegisterListener("ed_player_end_move_left", function(_, keys)
        self:On_ed_player_end_move_left(keys)
    end)
    CustomGameEventManager:RegisterListener("ed_player_end_move_right", function(_, keys)
        self:On_ed_player_end_move_right(keys)
    end)
    CustomGameEventManager:RegisterListener("ed_player_dash", function(_, keys)
        self:On_ed_player_dash(keys)
    end)

    -- 拾取物品Z
    CustomGameEventManager:RegisterListener("ed_player_pickup", function(_, keys)
        self:On_ed_player_pickup(keys)
    end)


    -- props editor相关
    CustomGameEventManager:RegisterListener("ed_props_editor_insert", function(_, keys)
        self:On_ed_props_editor_insert(keys)
    end)
    CustomGameEventManager:RegisterListener("ed_props_editor_clear", function(_, keys)
        self:On_ed_props_editor_clear(keys)
    end)
    CustomGameEventManager:RegisterListener("ed_props_editor_save", function(_, keys)
        self:On_ed_props_editor_save(keys)
    end)
    CustomGameEventManager:RegisterListener("ed_props_editor_load", function(_, keys)
        self:On_ed_props_editor_load(keys)
    end)
    CustomGameEventManager:RegisterListener("ed_player_select_courier", function(_, keys)
        self:On_ed_player_select_courier(keys)
    end)

    -- 指令相关
    CustomGameEventManager:RegisterListener("eum", function(_, keys)
        self:On_ed_player_update_mouse_position(keys)
    end)
    CustomGameEventManager:RegisterListener("eld", function(_, keys)
        self:On_ed_player_left_mouse_down(keys)
    end)
    CustomGameEventManager:RegisterListener("elu", function(_, keys)
        self:On_ed_player_left_mouse_up(keys)
    end)
    CustomGameEventManager:RegisterListener("erd", function(_, keys)
        self:On_ed_player_right_mouse_down(keys)
    end)
    CustomGameEventManager:RegisterListener("eru", function(_, keys)
        self:On_ed_player_right_mouse_up(keys)
    end)

end

function CEDGameMode:_OnClientRequestRoomData(keys)
    if self:GetCurrentMap() then
        self:GetCurrentMap():SendMapMessageToClient()
    end
end

function CEDGameMode:_OnClientSwitchInventory(keys)
    local playerID = keys.PlayerID
    local hero     = PlayerResource:GetPlayer(playerID):GetAssignedHero()
    if not hero then
        return
    end

    local inventoryIndex = keys.InventoryIndex
    if not hero._vInventoryData then
        local kv = {
            HeroName = hero:GetUnitName(),
            SteamID  = PlayerResource:GetSteamAccountID(playerID)
        }
        CreatePostRequest("GetInventoryItem", kv, function(result)
            if result.StatusCode == 200 then
                --@todo完成物品的解包和赋予
            end
        end)
    end
end

function CEDGameMode:SendLivesLeftToClient()
    CustomGameEventManager:Send_ServerToAllClients("ed_lives_changed", {
        LivesLeft = self.nLivesLeft,
    })
end

function CEDGameMode:On_ed_props_editor_insert(keys)
    if not IsInToolsMode() then
        return
    end

    local x, y, name = keys.x, keys.y, keys.name

    ---@type Room
    local room       = GameRules.gamemode:GetCurrentRoom()
    local props      = room.vPropEntities
    for _, prop in pairs(props) do
        if prop.nPropX == x and prop.nPropY == y then
            if IsValidAlive(prop) then
                prop:SetOrigin(Vector(9999, 9999, 0))
                prop:ForceKill(false)
            end
        end
    end

    if table.findkey(PropDefination, name) then
        room:InsertProp(name, x, y)
    elseif name == "invalid" then
        room.vCells[x][y].nCellType = 99
    elseif GameRules.Items_KV[name] then
        -- 物品
        --那么塞到物品里面去
        room.vCells[x][y].nCellType = 99
        room:InsertPropItem(name, x, y)
    else
        room.vCells[x][y].nCellType = 0
    end
    room:UpdatePropsDataToUI()
end

function CEDGameMode:On_ed_props_editor_clear(keys)
    if not IsInToolsMode() then
        return
    end

    local room = GameRules.gamemode:GetCurrentRoom()
    room:_ClearProps()

    room:UpdatePropsDataToUI()
end

function CEDGameMode:On_ed_props_editor_save(keys)
    if not IsInToolsMode() then
        return
    end
    local room = GameRules.gamemode:GetCurrentRoom()
    local name = keys.name
    if not name or name == "" then
        -- 尝试require，然后依次新增
        local index = 1
        while not require(string.format("rooms.props.%03d", index)) and index < 40 do
            index = index + 1
        end
        name = string.format("%03d", index)
    end
    local file = io.open("../../dota_addons/ed/scripts/vscripts/rooms/props/" .. name .. ".lua", "w")
    file:write("module(..., package.seeall)\n")
    local data = ""
    for y = 13, 1, - 1 do
        line = ""
        for x = 1, 21 do
            if x ~= 21 then
                local pszCellItemName = nil
                if room.vCells[x][y].pszCellItemName then
                    pszCellItemName = '"' .. room.vCells[x][y].pszCellItemName .. '"'
                end
                line = line .. (pszCellItemName or room.vCells[x][y].nCellType) .. ','
            else
                line = line .. room.vCells[x][y].nCellType
            end
        end
        data = data .. string.format("[%d] = {%s},\n", y, line)
    end
    file:write(string.format("Map = {\n%s}\n", data))
    local DontWorryAboutDoors = keys.DontWorryAboutDoors
    local u, d, l, r          = keys.U, keys.D, keys.L, keys.R
    u = u == 1 and 1 or 0;    d = d == 1 and 1 or 0;    l = l == 1 and 1 or 0;    r = r == 1 and 1 or 0
    if DontWorryAboutDoors == 1 then
        u, d, l, r = 2, 2, 2, 2
    end
    file:write(string.format("RequiredDoor = { U = %d, D = %d, L = %d, R = %d}\n", u, d, l, r))
    local Specific = keys.Specific == 1
    file:write("Specific     = " .. tostring(Specific))
    file:flush()
    file:close()
end

function CEDGameMode:On_ed_props_editor_load(keys)
    if not IsInToolsMode() then return end

    local room = GameRules.gamemode:GetCurrentRoom()
    if not GameRules.PropMaps[keys.name] then
        print("Load specific failed, file not exist")
        return
    end
    room.vPropsMap = GameRules.PropMaps[keys.name].Map
    room:_ClearProps()
    room:_SetupCells()
    room:_CreateProps()
    room:UpdatePropsDataToUI()
end

function CEDGameMode:On_ed_player_select_courier(keys)
    local nPlayerID = keys.PlayerID
    local hero = GetPlayerHero(nPlayerID)

    if not hero then return end

    if not IsInToolsMode() and GameRules.bPlayerEnteredNoneStartRoom then
        return
    end

    local pszCourierName = keys.CourierName

    -- todo econ check
    -- if not Econ:PlayerOwnedCourier(pszCourierName) and Econ:PlayerOwnedParticle(pszParticleName) then return end

    local vCourierDefination = GameRules.AllCouriers[pszCourierName]
    if not vCourierDefination then
        print(debug.traceback("courier defination not found " .. pszCourierName))
    end

    -- 调用信使的 on_select
    if vCourierDefination.on_select then
        vCourierDefination.on_select(hero)
    end

    -- 以防万一
    if not GameRules.bHasGameInited then
        GameRules.bHasGameInited = true
        Timer(1, function()
            self:EnterNextLevel()
            return nil
        end)
    end
end

function CEDGameMode:On_ed_player_pickup(keys)
    local nPlayerID = keys.PlayerID
    local hero = GetPlayerHero(nPlayerID)
    if not hero and IsValidAlive(hero) then return end

    -- 寻找最近的物品
    local vItemDrops = Entities:FindAllByClassname("dota_item_drop")
    local vNearestItem
    local nearestDistance = 999999
    local hero_origin = hero:GetOrigin()
    for _, item in pairs(vItemDrops) do
        local origin = item:GetOrigin()
        local distance = (hero_origin - origin):Length2D()
        if distance < nearestDistance then
            nearestDistance = distance
            vNearestItem = item
        end
    end

    -- 发出去拾取最近的物品的指令
    -- 如果最近的物品的距离大于200，不发指令
    hero:PickupDroppedItem(vNearestItem)
end

function CEDGameMode:_OnPlayerRerollShopItems(keys)
    local nPlayerID = keys.PlayerID

    -- 获取当前房间，并记录当前房间的重roll次数，计算价格指数
    local room = GameRules.gamemode:GetCurrentRoom()
    room.flShopItemRerollAmplify = room.flShopItemRerollAmplify or 0
    room.flShopItemRerollAmplify = room.flShopItemRerollAmplify + 0.2

    -- 重新定义房间的 vShopItems
    room.vShopItems = SelectShopRandomItems()
    OpenShopAtClient(nPlayerID)
end

function CEDGameMode:_OnPlayerPurchaseItem(keys)
    local nPlayerID = keys.PlayerID
    local player = PlayerResource:GetPlayer(nPlayerID)
    local hero = player:GetAssignedHero()
    if not hero then return end

    local itemName = keys.ItemName

    local itemCost = GetItemKVKey(itemName, "ItemCost") or 9999

    local room = GameRules.gamemode:GetCurrentRoom()
    itemCost = math.floor(itemCost * (1 + (room.flShopItemRerollAmplify or 0)))

    -- if hero:GetGold() < itemCost and not IsInToolsMode() then
    if hero:GetGold() < itemCost then
        ShowError("ed_hud_error_not_enough_gold", nPlayerID)
        return 
    end

    -- 扣钱，给玩家东西
    PlayerResource:ModifyGold(nPlayerID, -itemCost, true, DOTA_ModifyGold_PurchaseItem)

    -- 直接掉在地上
    utilsBonus.DropLootItem(itemName, GetCenter() + Vector(0, -200, 0), 100)

    room.vShopItems[table.findkey(room.vShopItems, itemName)] = "item_empty"
    OpenShopAtClient(nPlayerID) -- 购买之后，重新刷新信息到客户端
end