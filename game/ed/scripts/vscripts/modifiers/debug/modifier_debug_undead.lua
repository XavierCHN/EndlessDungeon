modifier_debug_undead = class({})

function modifier_debug_undead:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MIN_HEALTH,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }

    return funcs
end

function modifier_debug_undead:IsPurgable()
    return false
end

function modifier_debug_undead:GetMinHealth( params )
    return 1
end

function modifier_debug_undead:GetModifierHealthBonus()
    return 10000
end

function modifier_debug_undead:GetModifierConstantHealthRegen()
    return 0
end