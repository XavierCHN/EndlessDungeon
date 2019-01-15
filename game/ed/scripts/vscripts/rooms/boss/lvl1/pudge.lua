local Room          = class({}, nil, EDRoom)

Room.IsPlayable     = true

Room.UniqueName     = "pudge"

Room.SupportPlayers = { 1, 2, 3, 4 }

Room.RoomType       = RoomType.FinalBoss

Room._nWeight       = 100

Room.LevelRange = {1,1}

function Room:constructor(room)
    self.room     = room
    self.vEnemies = {}
end

function Room:OnPrepare()
    local pudge             = utilsCreatures.Create("npc_dota_creature_boss_pudge", self.room:GetCenter())
    self.hBossHealthBarUnit = pudge

    --local minipudge         = CreateUnitByName("npc_dota_creature_boss_pudge_minipudge", pudge:GetOrigin() + RandomVector(300), true, nil, nil, DOTA_TEAM_NEUTRALS)
    --minipudge:AddNewModifier(minipudge, nil, "modifier_no_unit_collision", {})
    --local add_interlock = false

    --Timers:CreateTimer(function()
    --    if not IsValidAlive(pudge) then
    --        return
    --    end
    --
    --    -- 检查小屠夫是否还活着
    --    if not IsValidAlive(minipudge) then
    --
    --        if not add_interlock then
    --            add_interlock = true
    --
    --            EmitAnnouncerSound("pudge_pud_lose_08")
    --
    --            local pid = ParticleManager:CreateParticle("particles/holdout_lina/holdout_wildfire_start.vpcf", PATTACH_WORLDORIGIN, pudge)
    --            ParticleManager:SetParticleControl(pid, 0, pudge:GetOrigin())
    --            ParticleManager:ReleaseParticleIndex(pid)
    --
    --            -- 再招一个
    --            Timers:CreateTimer(20, function()
    --                if IsValidAlive(pudge) then
    --                    local pos        = pudge:GetOrigin() + RandomVector(300)
    --                    local pid_summon = ParticleManager:CreateParticle("particles/generic_aoe_persistent_circle_1/generic_aoe_persist_summon_1.vpcf", PATTACH_WORLDORIGIN, pudge)
    --                    ParticleManager:SetParticleControl(pid_summon, 0, pos)
    --                    pudge:AddNewModifier(pudge, nil, "modifier_rooted", { Duration = 2 })
    --                    EmitAnnouncerSound("pudge_pud_rival_14") -- 敢吃我的肉，这就是你的下场
    --
    --                    pudge:StartGesture(ACT_DOTA_CAST_ABILITY_ROT)
    --
    --                    Timers:CreateTimer(2, function()
    --                        minipudge = CreateUnitByName("npc_dota_creature_boss_pudge_minipudge", pos, true, nil, nil, DOTA_TEAM_NEUTRALS)
    --                        minipudge:AddNewModifier(minipudge, nil, "modifier_no_unit_collision", {})
    --                        pudge:RemoveModifierByName("modifier_rooted")
    --                        FindClearSpaceForUnit(minipudge, pos, true)
    --                        ParticleManager:DestroyParticle(pid_summon, true)
    --                        add_interlock = false
    --                    end)
    --                end
    --            end)
    --
    --            if not pudge:HasModifier("modifier_creature_pudge_hate") then
    --                pudge:AddNewModifier(pudge, nil, "modifier_creature_pudge_hate", {})
    --            end
    --
    --            local stack = pudge:GetModifierStackCount("modifier_creature_pudge_hate", pudge)
    --            pudge:SetModifierStackCount("modifier_creature_pudge_hate", pudge, stack + 1)
    --        end
    --    end
    --
    --    return 1
    --end)
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