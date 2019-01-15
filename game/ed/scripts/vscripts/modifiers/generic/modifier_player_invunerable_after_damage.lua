modifier_player_invunerable_after_damage = class({})

function modifier_player_invunerable_after_damage:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_INVISIBLE]    = false
    }
end

function modifier_player_invunerable_after_damage:IsHidden()
    return true
end

function modifier_player_invunerable_after_damage:OnCreated(kv)
    if IsServer() then
        
    end
end

function modifier_player_invunerable_after_damage:GetStatusEffectName()
    return "particles/status_fx/status_effect_illusion.vpcf"
end