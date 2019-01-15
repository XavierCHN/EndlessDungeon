spike_trap_action = class({})

LinkLuaModifier("modifier_spike_trap_loop", "modifiers/props/modifier_spike_trap_loop.lua", LUA_MODIFIER_MOTION_NONE)

function spike_trap_action:GetIntrinsicModifierName()
    return "modifier_spike_trap_loop"
end