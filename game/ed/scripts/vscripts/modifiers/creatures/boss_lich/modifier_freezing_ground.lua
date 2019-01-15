modifier_freezing_ground = class({})

function modifier_freezing_ground:IsHidden()
    return true
end

function modifier_freezing_ground:IsPurgable()
    return false
end

function modifier_freezing_ground:OnCreated(kv)
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle("", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(nFXIndex, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl(nFXIndex, 1, Vector(200, 200, 200))
        self:AddParticle(nFXIndex, false, false, - 1, false, false)

        EmitSoundOn("Hero_Ancient_Apparition.ColdFeetCast", self:GetParent())
    end
end

function modifier_freezing_ground:OnDestroy()
    if IsServer() then
        UTIL_Remove(self:GetParent())
    end
end

function modifier_freezing_ground:IsAura()
    return true
end

function modifier_freezing_ground:GetAuraRadius()
    return 200
end

function modifier_freezing_ground:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_freezing_ground:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_freezing_ground:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_freezing_ground:GetModifierAura()
    return "modifeir_freezing_ground_freeze"
end
