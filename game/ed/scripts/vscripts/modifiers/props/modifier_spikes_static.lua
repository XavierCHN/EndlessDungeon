modifier_spikes_static   = class({})

local SPIKE_LAUNCH_DELAY = 1.2
local SPIKE_DURATION     = 2.4

LinkLuaModifier("modifier_spike_trap", "modifiers/props/modifier_spike_trap.lua", LUA_MODIFIER_MOTION_BOTH)

function modifier_spikes_static:OnCreated()
end

function modifier_spikes_static:IsAura()
    return true
end

function modifier_spikes_static:GetAuraRadius()
    return 90
end

function modifier_spikes_static:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_spikes_static:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_spikes_static:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_spikes_static:GetModifierAura()
    return "modifier_spike_trap"
end

function modifier_spikes_static:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR]     = true,
        [MODIFIER_STATE_INVULNERABLE]      = true,
    }
end