local Room          = class({}, nil, EDRoom)

Room.IsPlayable     = true

Room.UniqueName     = "Zombies"

Room.SupportPlayers = { 1, 2, 3, 4 }

Room.RoomType       = RoomType.Normal

Room._nWeight       = 100

Room.LevelRange = {1,1}

function Room:constructor(room)
    self.room     = room
    self.vEnemies = {}
end

function Room:OnPrepare()
    local sps = self.room:GetRandomSpawnPositions(8)
    for i = 1, 4 do
        utilsCreatures.Create("npc_dota_creature_basic_zombie_exploding", sps[i])
    end
    for i = 5, 8 do
        utilsCreatures.Create("npc_dota_creature_basic_zombie", sps[i])
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