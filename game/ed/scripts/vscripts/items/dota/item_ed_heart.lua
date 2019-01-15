LinkLuaModifier("modifier_flask_health_bonus","modifiers/items/dota/modifier_flask_health_bonus.lua",LUA_MODIFIER_MOTION_NONE)

function OnEquipHeart(keys)
	local caster = keys.caster
	local amount = keys.Amount
	caster:AddNewModifier(caster,nil,"modifier_flask_health_bonus",{Amount = amount})
	caster:Heal(amount,caster)
end