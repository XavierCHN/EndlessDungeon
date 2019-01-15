modifier_generic_invunerable = class({})

function modifier_generic_invunerable:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_INVISIBLE]    = false
    }
end

function modifier_generic_invunerable:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL
    }

    return funcs
end

function modifier_generic_invunerable:GetModifierInvisibilityLevel()
    return 0.3
end

function modifier_generic_invunerable:IsHidden()
    return true
end