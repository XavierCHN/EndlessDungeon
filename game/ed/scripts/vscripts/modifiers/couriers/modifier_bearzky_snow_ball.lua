modifier_bearzky_snow_ball = class({})

function modifier_bearzky_snow_ball:IsHidden()
    return false
end

function modifier_bearzky_snow_ball:IsPurgable()
    return false
end

function modifier_bearzky_snow_ball:OnCreated(kv)

end

function modifier_bearzky_snow_ball:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_bearzky_snow_ball:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end

function modifier_bearzky_snow_ball:RemoveOnDeath()
    return false
end

function modifier_bearzky_snow_ball:GetModifierMoveSpeedBonus_Constant()
    return 20
end

function modifier_bearzky_snow_ball:DeclareBulletFunctions()
    return {
        MODIFIER_BULLET_START_SOUND,
        MODIFIER_BULLET_END_SOUND,
        MODIFIER_BULLET_PARTICLE,
        MODIFIER_BULLET_IMPACT_PARTICLE,
        MODIFIER_BULLET_SPEED_BONUS,
        MODIFIER_BULLET_SPECIAL_EFFECT,
    }
end

function modifier_bearzky_snow_ball:GetBulletSpecialEffect()
    return "modifier_bearzky_snow_ball_slow"
end

function modifier_bearzky_snow_ball:GetBulletStartSound()
    return "Hero_ChaosKnight.idle_throw"
end

function modifier_bearzky_snow_ball:GetBulletEndSound()
    return "Hero_Tusk.Snowball.ProjectileHit"
end

function modifier_bearzky_snow_ball:GetBulletParticle()
    return "particles/creatures/bearzky/bearzky_snow_ball.vpcf"
end

function modifier_bearzky_snow_ball:GetBulletImpactParticle()
    return "particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_blur_impact.vpcf"
end

function modifier_bearzky_snow_ball:GetBulletSpeedBonus()
    return -200
end

function modifier_bearzky_snow_ball:GetTexture()
    return "couriers/bearzky_snow_ball"
end