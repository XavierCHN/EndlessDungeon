modifier_hooded_fang_slow = class({})

function modifier_hooded_fang_slow:DeclareFunctions()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT }
end

function modifier_hooded_fang_slow:GetModifierMoveSpeedBonus_Constant()
    return - 100
end

function modifier_hooded_fang_slow:OnCreated(kv)
    if IsServer() then
        local debuff_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_gale_poison_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(debuff_particle, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "follow_origin", self:GetParent():GetOrigin(), true)
        self:AddParticle(debuff_particle, true, true, 0, true, false)
    end
end

function modifier_hooded_fang_slow:GetTexture()
    return "modifiers/props/hood_fang_slow"
end