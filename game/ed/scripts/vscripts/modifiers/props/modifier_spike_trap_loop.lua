modifier_spike_trap_loop = class({})

local SPIKE_LAUNCH_DELAY = 1.2
local SPIKE_DURATION     = 2.4

LinkLuaModifier("modifier_spike_trap", "modifiers/props/modifier_spike_trap.lua", LUA_MODIFIER_MOTION_BOTH)

function modifier_spike_trap_loop:OnCreated()
    if IsServer() then
        self:GetParent():StartGesture(ACT_DOTA_DISABLED)
        self:StartIntervalThink(4)
    end
end

function modifier_spike_trap_loop:IsAura()
    if IsServer() and self.b_SpikeOut then
        return true
    end
    return false
end

function modifier_spike_trap_loop:GetAuraRadius()
    return 90
end

function modifier_spike_trap_loop:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_spike_trap_loop:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_spike_trap_loop:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_spike_trap_loop:GetModifierAura()
    if IsServer() then
        if self.b_SpikeOut then
            return "modifier_spike_trap"
        end
    end
    return ""
end

function modifier_spike_trap_loop:OnIntervalThink()
    if IsServer() then
        self:GetParent():StartGesture(ACT_DOTA_ATTACK)
        self.b_SpikeOut        = false
        local time_spike_delay = 0.65

        Timer(SPIKE_LAUNCH_DELAY, function()

            EmitSoundOn("Hero_NyxAssassin.SpikedCarapace", self:GetParent())

            self.b_SpikeOut = true

            Timer(SPIKE_DURATION, function()
                self.b_SpikeOut = false
            end)
        end)
    end
end

function modifier_spike_trap_loop:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR]     = true,
        [MODIFIER_STATE_INVULNERABLE]      = true,
    }
end