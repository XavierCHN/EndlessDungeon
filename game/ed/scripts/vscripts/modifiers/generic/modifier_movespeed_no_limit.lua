modifier_movespeed_no_limit = class({})

function modifier_movespeed_no_limit:IsHidden()
    return true
end

function modifier_movespeed_no_limit:IsPurgable()
    return false
end

function modifier_movespeed_no_limit:RemoveOnDeath()
    return false
end

function modifier_movespeed_no_limit:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
    }
end

function modifier_movespeed_no_limit:GetModifierMoveSpeed_Limit()
    return 9999
end

function modifier_movespeed_no_limit:GetModifierMoveSpeed_Max()
    return 9999
end