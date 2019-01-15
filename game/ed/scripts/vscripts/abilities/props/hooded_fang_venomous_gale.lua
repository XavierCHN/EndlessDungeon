hooded_fang_venomous_gale = class({})

LinkLuaModifier("modifier_hooded_fang_slow", "modifiers/props/modifier_hooded_fang_slow.lua", LUA_MODIFIER_MOTION_NONE)

function hooded_fang_venomous_gale:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        local fw     = caster:GetForwardVector()
        local info   = {
            EffectName       = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
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
        EmitSoundOn("Hero_Venomancer.VenomousGale", caster)
    end
end

function hooded_fang_venomous_gale:OnProjectileHit(target, position)
    if IsServer() and target then
        utilsDamage.DealDamagePercentage(self:GetCaster(), target, 10, self)

        -- 持续5秒的减速
        target:AddNewModifier(self:GetCaster(), self, "modifier_hooded_fang_slow", { Duration = 3 })
    end
    return false
end

function hooded_fang_venomous_gale:GetCastAnimation()
    return ACT_DOTA_ATTACK
end