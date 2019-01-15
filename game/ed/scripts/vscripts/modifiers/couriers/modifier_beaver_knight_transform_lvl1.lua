modifier_beaver_knight_transform_lvl1 = class({})

function modifier_beaver_knight_transform_lvl1:IsHidden()
	return false
end

function modifier_beaver_knight_transform_lvl1:IsPurgable()
	return false
end

function modifier_beaver_knight_transform_lvl1:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_beaver_knight_transform_lvl1:RemoveOnDeath()
	return false
end

function modifier_beaver_knight_transform_lvl1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_beaver_knight_transform_lvl1:GetModifierModelChange()
	return "models/items/courier/beaverknight_s1/beaverknight_s1.vmdl"
end

function modifier_beaver_knight_transform_lvl1:GetModifierModelScale()
	return 2
end

function modifier_beaver_knight_transform_lvl1:GetModifierDamageOutgoing_Percentage()
	return 20
end

function modifier_beaver_knight_transform_lvl1:GetTexture()
	return "couriers/modifier_beaver_knight_transform_lvl1"
end