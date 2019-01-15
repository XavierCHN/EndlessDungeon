modifier_creature_invulnerable = class({})

function modifier_creature_invulnerable:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true
    }
end