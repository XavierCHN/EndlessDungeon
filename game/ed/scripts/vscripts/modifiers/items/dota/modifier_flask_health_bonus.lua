modifier_flask_health_bonus = class({})

function modifier_flask_health_bonus:IsHidden()
	return true
end

function modifier_flask_health_bonus:IsPurgable()
	return false
end

function modifier_flask_health_bonus:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_flask_health_bonus:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(kv.Amount)
	end
end

function modifier_flask_health_bonus:DeclareFunctions()
	return {MODIFIER_PROPERTY_HEALTH_BONUS}
end

function modifier_flask_health_bonus:GetModifierHealthBonus()
	return self:GetStackCount()
end