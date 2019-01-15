modifier_babyroshan_aegis_death_counter = class({})

function modifier_babyroshan_aegis_death_counter:IsHidden()
    return false
end

function modifier_babyroshan_aegis_death_counter:IsPurgable()
    return false
end

function modifier_babyroshan_aegis_death_counter:OnCreated(kv)

end

function modifier_babyroshan_aegis_death_counter:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_babyroshan_aegis_death_counter:DeclareFunctions()
    return {}
end

function modifier_babyroshan_aegis_death_counter:GetTexture()
    return "couriers/babyroshan_aegis"
end

function modifier_babyroshan_aegis_death_counter:RemoveOnDeath()
    return false
end