modifier_creature_damage_tracker = class({})

function modifier_creature_damage_tracker:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_creature_damage_tracker:OnTakeDamage(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			keys.unit.__bDamagedByPlayer__ = true
		end
	end
end