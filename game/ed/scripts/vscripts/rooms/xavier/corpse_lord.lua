local Room          = class({}, nil, EDRoom)

Room.IsPlayable     = true

Room.UniqueName     = "corpse"

Room.SupportPlayers = { 1, 2, 3, 4 }

Room.RoomType       = RoomType.Normal

Room._nWeight       = 100

Room.LevelRange = {2,3}

function Room:constructor()
    self.vEnemies     = {}
    self.vCorpseLords = {}
end

function Room:OnPrepare()
    local sps = GetRandomSpawnPositionsAroundCoord(11, 7, 2)
    for _, sp in pairs(sps) do
        local cl = utilsCreatures.Create("npc_dota_creature_corpselord", sp)
    end
end

function Room:OnNpcSpawned(npc)
    if npc:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
        table.insert(self.vEnemies, npc)
    end
end

function Room:CheckFinish()
    for _, enemy in pairs(self.vEnemies) do
        if IsValidAlive(enemy) then
            return false
        end
    end

    return true
end

return Room