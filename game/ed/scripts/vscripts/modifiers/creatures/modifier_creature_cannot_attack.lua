modifier_disarmed = class({})

function modifier_disarmed:CheckState()
    return { [MODIFIER_STATE_DISARMED] = true }
end

function modifier_disarmed:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_disarmed:IsHidden()
    return true
end

function modifier_disarmed:IsPurgable()
    return false
end