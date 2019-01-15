modifier_burning_forged_spirit_passive = class({})

function modifier_burning_forged_spirit_passive:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end

function modifier_burning_forged_spirit_passive:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.3)
	end
end

function modifier_burning_forged_spirit_passive:OnIntervalThink()
	if IsServer() then
		local owner = self:GetParent()
		owner:SetHealth(owner:GetMaxHealth()) -- 始终保持为满血
	end
end
