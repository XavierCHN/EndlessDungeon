modifier_gtmdace = class({})

function modifier_gtmdace:DeclareBulletFunctions()
    return {
        MODIFIER_BULLET_PARTICLE,
        MODIFIER_BULLET_START_RADIUS,
        MODIFIER_BULLET_END_RADIUS,
        MODIFIER_BULLET_SPEED_BONUS,
        MODIFIER_BULLET_END_SOUND,
        MODIFIER_BULLET_START_SOUND,
    }
end

function modifier_gtmdace:GetBulletStartRadius()
    return 72
end

function modifier_gtmdace:GetBulletEndRadius()
    return 72
end

function modifier_gtmdace:GetBulletSpeedBonus()
    return -200
end

function modifier_gtmdace:GetBulletStartSound()
    return "GTMDACE.PoopStart"
end

function modifier_gtmdace:GetBulletEndSound()
    return "GTMDACE.PoopEnd"
end

function modifier_gtmdace:GetBulletParticle()
	return "particles/items/memes/item_ace_shit.vpcf"
end

function modifier_gtmdace:IsPurgable()
	return false
end

function modifier_gtmdace:IsHidden()
	return true
end