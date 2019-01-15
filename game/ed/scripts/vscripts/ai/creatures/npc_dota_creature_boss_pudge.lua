module("AIThink", package.seeall) -- 所有的AI文件都用这一行开头，复制粘贴即可

local pudge_taunt_sounds     = {
    "pudge_pud_laugh_01"
    , "pudge_pud_laugh_02"
    , "pudge_pud_laugh_03"
    , "pudge_pud_laugh_04"
    , "pudge_pud_laugh_05"
    , "pudge_pud_laugh_06"
    , "pudge_pud_laugh_07"
}

local FIRE_RESELECT_INTERVAL = 10
local FIRE_DAMAGE_INTERVAL   = 0.5
local FIRE_DAMAGE_PERCENTAGE = 10
local JUMP_INTERVAL          = 10
local CHARGE_INTERVAL        = 15
local HOOK_INTERVAL          = 15

LinkLuaModifier("modifier_pudge_ground_fire", "modifiers/creatures/boss_pudge/modifier_pudge_ground_fire.lua", LUA_MODIFIER_MOTION_NONE)

function npc_dota_creature_boss_pudge(self)
    if not IsValidAlive(self) then
        return
    end

    local now             = GameRules:GetGameTime()

    self.vFirePids        = {}

    self.flLastFireTime   = self.flLastFireTime or now - RandomFloat(FIRE_RESELECT_INTERVAL - 2, FIRE_RESELECT_INTERVAL - 3)
    self.flLastHookTime   = self.flLastHookTime or now - RandomFloat(HOOK_INTERVAL - 3, HOOK_INTERVAL - 7)
    self.flLastJumpTime   = self.flLastJumpTime or now + RandomFloat(JUMP_INTERVAL - 4, JUMP_INTERVAL - 8)
    self.flLastChargeTime = self.flLastChargeTime or now + RandomFloat(CHARGE_INTERVAL - 3, CHARGE_INTERVAL - 5)

    self.hJumpAbility     = self:FindAbilityByName("creature_pudge_jump")
    self.hChargeAbility   = self:FindAbilityByName("creature_pudge_charge")
    self.hHookAbility     = self:FindAbilityByName("creature_pudge_meat_hook")

    ---- 放火和造成伤害
    if now - self.flLastFireTime > FIRE_RESELECT_INTERVAL then

        if not self.bFireDamageTimer then
            self.bFireDamageTimer = true
            Timer(function()

                local allHeroes         = GameRules.gamemode:GetAllHeroes()
                local fireDamagedHeroes = {}
                for _, pos in pairs(self.vFirePositions) do
                    for _, hero in pairs(allHeroes) do
                        if (pos - hero:GetOrigin()):Length2D() < 200 then
                            if not hero:HasModifier("modifier_ed_continous_damage") then
                                --print("adding continous damage modifier to player")
                                hero:AddNewModifier(self, nil, "modifier_ed_continous_damage", {
                                    type     = "percentage",
                                    damage   = FIRE_DAMAGE_PERCENTAGE,
                                    interval = FIRE_DAMAGE_INTERVAL
                                })
                            end
                            fireDamagedHeroes[hero] = true
                        end
                    end
                end

                for _, hero in pairs(allHeroes) do
                    if not fireDamagedHeroes[hero] and hero:HasModifier("modifier_ed_continous_damage") then
                        hero:RemoveModifierByNameAndCaster("modifier_ed_continous_damage", self)
                    end
                end

                if not IsValidAlive(self) then
                    return nil
                end
                return 0.1
            end)
        end

        self.vFirePositions = {}
        self.flLastFireTime = now

        for _, pid in pairs(self.vFirePids) do
            ParticleManager:DestroyParticle(pid, true)
            ParticleManager:ReleaseParticleIndex(pid)
        end

        local randomPos = table.random_some(GetAllCellCenters(), 15)
        for _, pos in pairs(randomPos) do
            self.vFirePositions = {}
            local pid           = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_loadout_char_fire.vpcf",
            PATTACH_WORLDORIGIN, self)
            ParticleManager:SetParticleControl(pid, 0, pos)
            ParticleManager:ReleaseParticleIndex(pid)
        end

        Timer(2, function()
            for _, pos in pairs(randomPos) do
                local pid = ParticleManager:CreateParticle("particles/creatures/boss_pudge/boss_pudge_fire_hell.vpcf",
                PATTACH_WORLDORIGIN, self)
                ParticleManager:SetParticleControl(pid, 0, pos)
                ParticleManager:SetParticleControl(pid, 1, pos)
                ParticleManager:SetParticleControl(pid, 2, Vector(10, 0, 0))

                table.insert(self.vFirePositions, pos)
                table.insert(self.vFirePids, pid)
            end
        end)
    end

    local enemy       = AIUtil:RandomPlayerHero()
    local enemyOrigin = enemy:GetOrigin()
    -- 肉钩
    if now - self.flLastHookTime > HOOK_INTERVAL then
        self.flLastHookTime = now
        self:CastAbilityOnPosition(enemyOrigin, self.hHookAbility, - 1)
        return 2
    end

    -- 跳跃
    if now - self.flLastJumpTime > JUMP_INTERVAL then
        self.flLastJumpTime = now
        self:CastAbilityOnPosition(enemyOrigin, self.hJumpAbility, - 1)
        return 2
    end

    -- 冲锋
    if now - self.flLastChargeTime > CHARGE_INTERVAL then
        self.flLastChargeTime = now
        self:CastAbilityOnPosition(enemyOrigin, self.hChargeAbility, - 1)
        return 4
    end

    -- 小跳跃什么的
    local selfOrigin = self:GetOrigin()
    local direction  = (enemyOrigin - selfOrigin):Normalized()
    local length     = (enemyOrigin - selfOrigin):Length2D()
    local speed = 600

    self:SetForwardVector(direction)
    self:StartGesture(ACT_DOTA_CAST_ABILITY_ROT)

    Timer(0.1, function()
        length = math.max(math.min(length, 1024), 512)
        utilsCreatures.Leap(self, selfOrigin + direction * length, 600, speed)
    end)




    return length / speed + 2
end