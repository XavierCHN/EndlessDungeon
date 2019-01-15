clinkz_fire_arrows = class({})

LinkLuaModifier("modifier_clinkz_fire_arrows_thinker", "modifiers/creatures/modifier_clinkz_fire_arrows_thinker.lua", LUA_MODIFIER_MOTION_NONE)

function clinkz_fire_arrows:OnProjectileHit(target, location)
    if IsServer() and target then
        utilsDamage.DealDamagePercentage(self:GetCaster(), target, 20, self)
    end
end

function clinkz_fire_arrows:GetCooldown()
    if IsServer() then
        local level = GameRules.gamemode:GetCurrentLevel()
        return 30 - 3 * level
    end
end

function clinkz_fire_arrows:OnSpellStart()
    if IsServer() then
        local pid = ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_windwalk.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
        ParticleManager:SetParticleControl(pid, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:SetParticleControl(pid, 1, self:GetCaster():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(pid)

        EmitSoundOn("Hero_Clinkz.WindWalk", self:GetCaster())

        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_clinkz_fire_arrows_thinker", {})
        Timer(1, function()
            local duration = 10
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_clinkz_fire_arrows_thinker", {})
        end)
        self:GetCaster().b_DontAttack = true
        Timer(13, function()
            if IsValidAlive(self:GetCaster()) then
                self:GetCaster().b_DontAttack = false
            end
        end)
    end
end