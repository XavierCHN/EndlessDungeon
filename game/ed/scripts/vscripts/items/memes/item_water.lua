LinkLuaModifier("modifier_burning_forged_spirit_passive","modifiers/items/memes/modifier_burning_forged_spirit_passive.lua",LUA_MODIFIER_MOTION_NONE)

function OnBurningForgedSpiritSpawned(keys)
	local forged_spirit = keys.target
	local caster = keys.caster
	forged_spirit:AddNewModifier(forged_spirit,nil,"modifier_burning_forged_spirit_passive",{})
	-- 那就开始你我之间的羁绊吧！
	forged_spirit.hOwner = caster
	caster.hBurningForgedSpirit = forged_spirit
end

function OnBurningWaterUnEquipted(keys)
	local caster = keys.caster
	if caster.hBurningForgedSpirit then
		caster.hBurningForgedSpirit:ForceKill(false)
	end
end