-- 对碰到的敌人造成半颗心的伤害
modifier_touch_damage = class({})

function modifier_touch_damage:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.03)
	end
end

function modifier_touch_damage:IsPurgable()
	return false
end

function modifier_touch_damage:IsHidden()
	return true
end

function modifier_touch_damage:IsDebuff()
	if self:GetParent() ~= self:GetCaster() then
		return true
	end
	return false
end

function modifier_touch_damage:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_touch_damage:OnIntervalThink()
	local owner = self:GetParent()
	DebugDrawCircle(owner:GetOrigin(), Vector(255, 0, 0), 120, 64, false, 0.03)

	local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, owner:GetOrigin(), nil, 64, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _, unit in pairs(units) do
		if not unit:HasModifier("modifier_player_invunerable_after_damage") then
			owner:PerformAttack(unit, true, true, true, false, false, false, true)
			owner:ForcePlayActivityOnce(ACT_DOTA_ATTACK)
			unit:AddNewModifier(unit, nil, "modifier_player_invunerable_after_damage", { Duration = 0.3 })
		end
	end
end