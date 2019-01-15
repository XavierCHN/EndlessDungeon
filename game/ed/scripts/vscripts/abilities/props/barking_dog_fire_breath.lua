barking_dog_fire_breath = class({})

function barking_dog_fire_breath:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        local fw     = caster:GetForwardVector()
        local info   = {
            EffectName       = "particles/props/barking_dog_fire_breath.vpcf",
            Ability          = self,
            vSpawnOrigin     = caster:GetOrigin(),
            Source           = caster,
            fDistance        = 300,
            fStartRadius     = 64,
            fEndRadius       = 128,
            bHasFrontalCone  = true,
            bReplaceExisting = false,
            iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            fExpireTime      = GameRules:GetGameTime() + 10.0,
            vVelocity        = fw * 800,
        }

        ProjectileManager:CreateLinearProjectile(info)
        EmitSoundOn("Hero_DragonKnight.BreathFire", caster)
    end
end

function barking_dog_fire_breath:OnProjectileHit(target, position)
    if IsServer() and target then
        utilsDamage.DealDamagePercentage(self:GetCaster(), target, 20, self)
    end
    return false
end

function barking_dog_fire_breath:GetCastAnimation()
    return ACT_DOTA_ATTACK
end