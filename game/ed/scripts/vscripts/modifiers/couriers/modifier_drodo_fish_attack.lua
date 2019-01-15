modifier_drodo_fish_attack = class({})

function modifier_drodo_fish_attack:IsHidden()
	return false
end

function modifier_drodo_fish_attack:IsPurgable()
	return false
end

function modifier_drodo_fish_attack:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_drodo_fish_attack:RemoveOnDeath()
	return false
end

function modifier_drodo_fish_attack:DeclareBulletFunctions()
	return {
		MODIFIER_BULLET_NAME,
		MODIFIER_BULLET_DONT_DELETE_ON_HIT
	}
end

function modifier_drodo_fish_attack:GetBulletName()
	return "drodo_fish_attack"
end

function modifier_drodo_fish_attack:GetAttackGesture()
	return ACT_DOTA_IDLE_RARE
end

function modifier_drodo_fish_attack:GetBulletDontDeleteOnHit()
	return true
end