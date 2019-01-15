local Room           = class({}, nil, EDRoom)

Room.IsPlayable      = true

Room.UniqueName      = "sf"

Room.SupportPlayers  = { 1, 2, 3, 4 }

Room.RoomType        = RoomType.FinalBoss

Room._nWeight        = 100

Room.LevelRange = {2,2}

function Room:constructor()
end

function Room:OnPrepare()
    local spawnLocation = GetCenter()
    self.hBossNevermore        = utilsCreatures.Create("npc_dota_creature_boss_nevermore", spawnLocation)
    self.hBossHealthBarUnit = self.hBossNevermore
    self.hBossNevermore:SetRenderColor(0,255,0)
    self.hBossNevermore.__bCannotKnockback__ = true
end

function Room:CheckFinish()
    if IsValidAlive(self.hBossNevermore) then
        return false
    end
    return true
end

return Room