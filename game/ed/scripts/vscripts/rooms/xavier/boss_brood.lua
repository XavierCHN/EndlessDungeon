local Room          = class({}, nil, EDRoom)

Room.IsPlayable     = true

Room.UniqueName     = "Brood"

Room.SupportPlayers = { 1, 2, 3, 4 }

Room.RoomType       = RoomType.FinalBoss

Room._nWeight       = 100

Room.LevelRange = {3,3}

function Room:constructor(room)
    self.room     = room
    self.vEnemies = {}
end

function Room:OnPrepare()
    local spawnLocation1    = self.room:GetCenter()
    local spider            = utilsCreatures.Create("npc_dota_creature_broodking", spawnLocation1)
    self.hBossHealthBarUnit = spider
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