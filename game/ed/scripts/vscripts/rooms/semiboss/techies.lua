local Room           = class({}, nil, EDRoom)

Room.IsPlayable      = true

Room.UniqueName      = "Techies"

Room.SupportPlayers  = { 1, 2, 3, 4 }

Room.RoomType        = RoomType.SemiBoss

Room._nWeight        = 100

Room.SpecificPropMap = "techies_bomber_man"

Room.LevelRange = {1,2}

function Room:constructor(room)
    self.room     = room
    self.hTechies = nil
end

function Room:OnPrepare()

    -- 在房间正中间刷新一个clinkz
    local spawnLocation     = GetCenter()
    self.hTechies           = utilsCreatures.Create("npc_dota_creature_boss_techies", spawnLocation)
    self.hBossHealthBarUnit = self.hTechies
end

function Room:CheckFinish()
    if IsValidAlive(self.hTechies) then
        return false
    end
    return true
end

return Room