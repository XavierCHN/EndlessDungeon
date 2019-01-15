modifier_bearzky_snow_ball_slow = class({})

function modifier_bearzky_snow_ball_slow:IsHidden()
    return false
end

function modifier_bearzky_snow_ball_slow:IsPurgable()
    return false
end

function modifier_bearzky_snow_ball_slow:OnCreated(kv)
    if IsServer() then
        self:SetDuration(1.5, true)
    end
end

function modifier_bearzky_snow_ball_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end

function modifier_bearzky_snow_ball_slow:GetModifierMoveSpeedBonus_Constant()
    return -20
end

function modifier_bearzky_snow_ball_slow:GetEffectName( void )
    return "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf"
end

function modifier_bearzky_snow_ball_slow:GetStatusEffectName( void )
    return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_bearzky_snow_ball_slow:IsDebuff()
    return true
end

function modifier_bearzky_snow_ball_slow:GetTexture()
    return "couriers/bearzky_snow_ball"
end