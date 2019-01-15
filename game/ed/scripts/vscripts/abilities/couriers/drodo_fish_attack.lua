drodo_fish_attack = class({})

LinkLuaModifier("modifier_drodo_fish_attack","modifiers/couriers/modifier_drodo_fish_attack.lua",LUA_MODIFIER_MOTION_NONE)

function drodo_fish_attack:GetIntrinsicModifierName()
	return "modifier_drodo_fish_attack"
end