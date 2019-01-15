local Room = class({}, nil, EDRoom)

Room.IsPlayable = true

Room.UniqueName = "gangbei"

Room.SupportPlayers = { 1, 2, 3, 4 }

Room.RoomType = RoomType.FinalBoss

Room._nWeight = 100

Room.LevelRange = { 3, 3 }

function Room:constructor()
end

function Room:OnPrepare()

    local spawnLocation = GetCenter()
    self.hBossBristleBack = utilsCreatures.Create("npc_dota_creature_boss_bristleback", spawnLocation)
    self.hBossHealthBarUnit = self.hBossBristleBack

    -- 不允许刚被攻击
    self.hBossBristleBack:AddNewModifier(self.hBossBristleBack, nil, "modifier_disarmed", {})
    -- 无视施法角度
    self.hBossBristleBack:AddNewModifier(self.hBossBristleBack, nil, "modifier_ignore_cast_angle", {})
    -- 不会被击退
    self.hBossBristleBack.__bCannotKnockback__ = true

end

function Room:CheckFinish()
    if IsValidAlive(self.hBossBristleBack) then
        return false
    end
    return true
end

return Room