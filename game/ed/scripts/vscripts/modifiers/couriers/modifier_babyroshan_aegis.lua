---@type CDOTA_Modifier_Lua
modifier_babyroshan_aegis = class({})

function modifier_babyroshan_aegis:IsHidden()
    return true
end

function modifier_babyroshan_aegis:IsPurgable()
    return false
end

function modifier_babyroshan_aegis:OnCreated(kv)
    if IsServer() then
        if not self:GetParent():HasModifier("modifier_babyroshan_aegis_death_counter") then
            self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_babyroshan_aegis_death_counter", {})
        end
        self:StartIntervalThink(0.03)
    end
end

function modifier_babyroshan_aegis:OnIntervalThink()
    if IsServer() then
        if self:GetParent():GetMaxHealth() > 10 then
            self:GetParent():SetMaxHealth(10)
        end
        if self:GetParent():GetHealth() > 10 then
            self:GetParent():SetHealth(10)
        end
    end
end

function modifier_babyroshan_aegis:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_babyroshan_aegis:RemoveOnDeath()
    return false
end