modifier_ed_continous_damage = class({})

function modifier_ed_continous_damage:IsHidden()
    return false
end

function modifier_ed_continous_damage:IsPurgable()
    return false
end

function modifier_ed_continous_damage:OnCreated(kv)
    if IsServer() then
        self.type = kv.type
        self.damage = kv.damage
        local damageInterval = kv.interval
        self:StartIntervalThink(damageInterval)
    end
end

function modifier_ed_continous_damage:GetAttributes()
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_ed_continous_damage:OnIntervalThink()
    if IsServer() then
        if self.type == "percentage" then
            utilsDamage.DealDamagePercentage(self:GetCaster(), self:GetParent(), self.damage, nil)
        end
        if self.type == "constant" then
            utilsDamage.DealDamageConstant(self:GetCaster(), self:GetParent(), self.damage, nil)
        end
    end
end