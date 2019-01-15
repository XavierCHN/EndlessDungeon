LinkLuaModifier("modifier_beaver_knight_transform_lvl1", "modifiers/couriers/modifier_beaver_knight_transform_lvl1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_beaver_knight_transform_lvl2", "modifiers/couriers/modifier_beaver_knight_transform_lvl2.lua", LUA_MODIFIER_MOTION_NONE)

function OnBeaverKnightKill(keys)
	local caster = keys.caster

	caster.nKillStreak = caster.nKillStreak or 0
	caster.nKillStreak = caster.nKillStreak + 1

	if caster.nKillStreak > 15 and caster.nKillStreak < 30 then
		caster:AddNewModifier(caster,keys.ability,"modifier_beaver_knight_transform_lvl1",{})
	elseif caster.nKillStreak >= 30 then
		caster:RemoveModifierByName("modifier_beaver_knight_transform_lvl1")
		caster:AddNewModifier(caster,keys.ability,"modifier_beaver_knight_transform_lvl2",{})
	end
end

function OnBeaverKnightTakeDamage(keys)
	local caster = keys.caster
	caster.nKillStreak = 0
	caster:RemoveModifierByName("modifier_beaver_knight_transform_lvl1")
	caster:RemoveModifierByName("modifier_beaver_knight_transform_lvl2")
end