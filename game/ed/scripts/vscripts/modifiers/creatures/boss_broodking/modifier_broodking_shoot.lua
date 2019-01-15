modifier_broodking_shoot = class({})

require 'ai.ai_util'

function modifier_broodking_shoot:OnCreated(kv)
    if IsServer() then

        local ability              = self:GetAbility()
        self.flThinkInterval       = ability:GetSpecialValueFor("shoot_interval")
        self.flProjectileCount     = ability:GetSpecialValueFor("bullet_count")
        self.flStartLocationRadius = ability:GetSpecialValueFor("bullet_start_location_radius")
        self.flEndLocationRadius   = ability:GetSpecialValueFor("bullet_end_location_radius")
        self.flProjectileSpeed     = ability:GetSpecialValueFor("projectile_speed")
        self:StartIntervalThink(self.flThinkInterval)
    end
end

function modifier_broodking_shoot:OnIntervalThink()
    if IsServer() then
        local brood = self:GetParent()
        brood:StartGesture(ACT_DOTA_ATTACK)

        Timer(0.5, function()
            local randomTarget = AIUtil:RandomPlayerHero()

            EmitSoundOn("Hero_Broodmother.SpawnSpiderlingsCast", brood)

            for i = 1, self.flProjectileCount do
                local randomOrigin         = brood:GetOrigin() + RandomVector(self.flStartLocationRadius)
                local randomTargetPosition = randomTarget:GetOrigin() + RandomVector(self.flEndLocationRadius)
                local randomDirection      = (randomTargetPosition - randomOrigin):Normalized()
                local info                 = {
                    EffectName       = "particles/creatures/semi_boss/broodking/broodking_projectile.vpcf",
                    Ability          = self:GetAbility(),
                    vSpawnOrigin     = randomOrigin,
                    Source           = brood,
                    fDistance        = 10000,
                    fStartRadius     = 64,
                    fEndRadius       = 64,
                    bHasFrontalCone  = true,
                    bReplaceExisting = false,
                    iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_ENEMY,
                    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                    iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                    fExpireTime      = GameRules:GetGameTime() + 10.0,
                    vVelocity        = randomDirection * self.flProjectileSpeed,
                }

                ProjectileManager:CreateLinearProjectile(info)
            end
        end)
    end
end

function modifier_broodking_shoot:IsHidden()
    return true
end

function modifier_broodking_shoot:IsPurgable()
    return false
end