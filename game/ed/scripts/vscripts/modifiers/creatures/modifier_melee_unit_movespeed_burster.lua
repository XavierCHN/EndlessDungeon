modifier_melee_unit_movespeed_burster = class({})

function modifier_melee_unit_movespeed_burster:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_melee_unit_movespeed_burster:GetModifierMoveSpeedBonus_Constant()
	return 150
end

function modifier_melee_unit_movespeed_burster:OnCreated()
	if IsServer() then
		local pid = ParticleManager:CreateParticle("particles/items2_fx/mask_of_madness.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
		ParticleManager:SetParticleControlEnt(pid,0,self:GetParent(),PATTACH_ABSORIGIN_FOLLOW,"follow_origin",self:GetParent():GetOrigin(),false)
		self:AddParticle(pid,true,false,0,false,false)

		self:SetDuration(3, true)
	end
end

function modifier_melee_unit_movespeed_burster:OnTakeDamage(keys)
	if IsServer() then
		local owner = self:GetParent()
		if keys.unit == owner and keys.attacker:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			owner.__modifier_melee_unit_movespeed_burster_counter__ = 
			owner.__modifier_melee_unit_movespeed_burster_counter__ or 0
			owner.__modifier_melee_unit_movespeed_burster_counter__ = 
			owner.__modifier_melee_unit_movespeed_burster_counter__ + 1
			if owner.__modifier_melee_unit_movespeed_burster_counter__ > 1 then

				-- 不再移除modifier
				-- print("removing modifier")
				-- self:Destroy()
			end
		end
	end
end

function modifier_melee_unit_movespeed_burster:OnDestroy()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_rooted", {Duration = 0.5})
	end
end