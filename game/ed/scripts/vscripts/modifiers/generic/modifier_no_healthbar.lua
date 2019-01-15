modifier_no_healthbar = class({})

function modifier_no_healthbar:IsHidden()
    return true
end

function modifier_no_healthbar:CheckState()
    return {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
end