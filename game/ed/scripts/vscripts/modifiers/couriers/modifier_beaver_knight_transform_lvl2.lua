modifier_beaver_knight_transform_lvl2 = class({})

function modifier_beaver_knight_transform_lvl2:IsHidden()
	return false
end

function modifier_beaver_knight_transform_lvl2:IsPurgable()
	return false
end

function modifier_beaver_knight_transform_lvl2:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_beaver_knight_transform_lvl2:RemoveOnDeath()
	return false
end

function modifier_beaver_knight_transform_lvl2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_beaver_knight_transform_lvl2:GetModifierModelChange()
	return "models/items/courier/beaverknight_s2/beaverknight_s2.vmdl"
end

function modifier_beaver_knight_transform_lvl2:GetModifierModelScale()
	return 4
end

function modifier_beaver_knight_transform_lvl2:GetModifierDamageOutgoing_Percentage()
	return 40
end

function modifier_beaver_knight_transform_lvl2:GetTexture()
	return "couriers/modifier_beaver_knight_transform_lvl2"
end