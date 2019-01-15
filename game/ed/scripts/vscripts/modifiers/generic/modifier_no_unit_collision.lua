modifier_no_unit_collision = class({})

function modifier_no_unit_collision:IsHidden()
    return true
end

function modifier_no_unit_collision:IsPurgable()
    return false
end

function modifier_no_unit_collision:RemoveOnDeath()
    return false
end

function modifier_no_unit_collision:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
    }
end