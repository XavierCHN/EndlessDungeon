modifier_ed_prop = class({})

function modifier_ed_prop:IsHidden()
	return true
end

function modifier_ed_prop:IsPurgable()
	return false
end

function modifier_ed_prop:DeclareFuctions()
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
end

function modifier_ed_prop:GetModifierEvasion_Constant()
    return 1000
end

function modifier_ed_prop:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end

function modifier_ed_prop:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end