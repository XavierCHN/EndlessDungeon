broodking_shoot = class({})

LinkLuaModifier("modifier_broodking_shoot", "modifiers/creatures/boss_broodking/modifier_broodking_shoot.lua", LUA_MODIFIER_MOTION_NONE)

function broodking_shoot:GetIntrinsicModifierName()
    return "modifier_broodking_shoot"
end

function broodking_shoot:OnProjectileHit(target, location)
    if IsServer() and target then
        utilsDamage.DealDamagePercentage(self:GetCaster(), target, 20, self)

        local pid = ParticleManager:CreateParticle("particles/units/heroes/hero_broodmother/broodmother_spiderlings_spawn.vpcf", PATTACH_ABSORIGIN, target)
        ParticleManager:SetParticleControl(pid, 0, target:GetOrigin())
        ParticleManager:ReleaseParticleIndex(pid)

        EmitSoundOn("Hero_Broodmother.SpawnSpiderlingsImpact", target)
    end
    return false
end