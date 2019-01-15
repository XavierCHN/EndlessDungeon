modifier_rtz = class({})

function modifier_rtz:DeclareBulletFunctions()
    return {
        MODIFIER_BULLET_ANGLE,
        MODIFIER_BULLET_BULLET_COUNT_BONUS,
        MODIFIER_BULLET_PARTICLE
    }
end

function modifier_rtz:DeclareFunctions()
    return {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}
end

function modifier_rtz:GetBulletAngle()
    return 20
end

function modifier_rtz:GetModifierBaseAttack_BonusDamage()
    return -20
end

function modifier_rtz:GetBulletCountBonus()
    return 1
end

function modifier_rtz:GetBulletStartSound()
    return "Hero_Sniper.ShrapnelShoot"
end

function modifier_rtz:GetBulletParticle()
	return "particles/items/memes/rtz/2ez.vpcf"
end

function modifier_rtz:IsPurgable()
	return false
end

function modifier_rtz:IsHidden()
	return true
end