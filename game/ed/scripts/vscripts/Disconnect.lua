LinkLuaModifier("modifier_eda_disconnect", "modifiers/modifier_eda_disconnect.lua", LUA_MODIFIER_MOTION_NONE)

function CEDGameMode:OnDisconnect(keys)
    if (GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME) or (GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME) then
        return nil
    else
        local player_id   = keys.PlayerID
        local player_name = keys.name
        local player      = PlayerResource:GetPlayer(player_id)
        local hero        = player:GetAssignedHero()
        if not hero then
            print("player disconnected without hero picked")
            return
        end
        local hero_name     = PlayerResource:GetPickedHeroName(player_id)
        local line_duration = 7

        -- 如果一个玩家掉线，告知掉线的信息
        Notifications:BottomToAll({ hero = hero_name, duration = line_duration })
        Notifications:BottomToAll({ text = player_name .. " ", duration = line_duration, continue = true })
        Notifications:BottomToAll({ text = "#ed_player_disconnect", duration = line_duration, style = { color = "DodgerBlue" }, continue = true })
        PlayerResource:SetHasAbandonedDueToLongDisconnect(player_id, true)
        print("player " .. player_id .. " has left the game.")

        -- 从地图上移除英雄
        hero:SetAbsOrigin(Vector(9999, 9999, 9999))
        hero:AddNewModifier(hero, nil, "modifier_eda_disconnect", {})
        hero._bIsDisconnected = true

        Timer(1, function()
            if PlayerResource:GetConnectionState(player_id) == 2 then
                -- 如果玩家已经重新连接了
                -- 停止跟踪，恢复英雄
                -- 将英雄放到地图中央
                FindClearSpaceForUnit(hero, Vector(0, 0, 0), true)
                hero:RemoveModifierByName("modifier_eda_disconnect")
                hero._bIsDisconnected = false
            else
                --
                print("tracking player " .. player_id .. "'s connection state, disconnected for " .. disconnect_time .. " seconds.")
                return 1
            end
        end)
    end
end

function CEDGameMode:OnPlayerReconnect(keys)
end