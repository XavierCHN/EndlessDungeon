function OnCastFamilyIssue(keys)
	local hero        = keys.caster
	local x           = 0
    local y           = 0
    local currentRoom = GameRules.gamemode:GetCurrentRoom()
    if currentRoom then
        currentRoom:ExitRoom()
    end
    local room = GameRules.gamemode:GetCurrentMap():GetRoomAtCoord(x, y)
    if room then
        room:EnterRoom()
        hero:SetOrigin(GetCenter())

        PlayerResource:SetCameraTarget(hero:GetPlayerID(),hero)
       	Timer(0.03, function()
       		PlayerResource:SetCameraTarget(hero:GetPlayerID(),nil)
       	end)
    end
end