spikes_static = class({})

LinkLuaModifier("modifier_spikes_static", "modifiers/props/modifier_spikes_static.lua", LUA_MODIFIER_MOTION_NONE)

function spikes_static:GetIntrinsicModifierName()
    return "modifier_spikes_static"
end