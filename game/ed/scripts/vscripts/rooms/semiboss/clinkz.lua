local Room           = class({}, nil, EDRoom)

Room.IsPlayable      = true

Room.UniqueName      = "Clinkz"

Room.SupportPlayers  = { 1, 2, 3, 4 }

Room.RoomType        = RoomType.SemiBoss

Room._nWeight        = 100

Room.SpecificPropMap = "clinkz_prop"

Room.LevelRange = {1,3}

function Room:constructor(room)
    self.room    = room
    self.hClinkz = nil
end

function Room:OnPrepare()

    -- 在房间正中间刷新一个clinkz
    local spawnLocation = GetCenter()
    self.hClinkz        = utilsCreatures.Create("npc_dota_creature_clinkz", spawnLocation)
    self.hClinkz:FindAbilityByName("clinkz_fire_arrows"):StartCooldown(5)
    self.hBossHealthBarUnit = self.hClinkz

end

function Room:CheckFinish()
    if IsValidAlive(self.hClinkz) then
        return false
    end
    return true
end

return Room