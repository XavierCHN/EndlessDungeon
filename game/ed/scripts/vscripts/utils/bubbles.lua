utilsBubbles = {}

function utilsBubbles.Show(unit, text, duration)
    CustomGameEventManager:Send_ServerToAllClients("avalon_display_bubble", {
        unit = unit:GetEntityIndex(),
        text = text,
        duration = duration,
    })
end

function utilsBubbles.ShowOnClient(player, unit, text, duration)
    CustomGameEventManager:Send_ServerToPlayer(player, "avalon_display_bubble", {
        unit = unit:GetEntityIndex(),
        text = text,
        duration = duration,
    })
end