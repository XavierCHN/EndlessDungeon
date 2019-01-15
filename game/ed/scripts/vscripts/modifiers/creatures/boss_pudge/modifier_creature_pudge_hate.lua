modifier_creature_pudge_hate = class({})

function modifier_creature_pudge_hate:OnCreated(kv)
end

function modifier_creature_pudge_hate:DeclareFunctions()
    return { MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end

function modifier_creature_pudge_hate:GetModifierDamageOutgoing_Percentage()
    if IsServer() then
        return self:GetStackCount() * 20
    end
end

function modifier_creature_pudge_hate:GetModifierMoveSpeedBonus_Constant()
    if IsServer() then
        return self:GetStackCount() * 20
    end
end