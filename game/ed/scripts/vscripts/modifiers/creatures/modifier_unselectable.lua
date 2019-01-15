modifier_unselectable = class({})

function modifier_unselectable:CheckState()
    return { [MODIFIER_STATE_UNSELECTABLE] = true }
end

function modifier_unselectable:IsHidden()
    return false
end

function modifier_unselectable:IsPurgable()
    return false
end