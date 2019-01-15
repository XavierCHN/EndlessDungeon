---@type CDOTA_Modifier_Lua
modifier_huskar_poison_milk_channel = class({})


function modifier_huskar_poison_milk_channel:OnCreated(kv)
    if IsServer() then
        local owner = self:GetParent()
        self.flDuration = math.max(8 - owner.nCurrentLevel * 0.5, 5)
        self:SetDuration(self.flDuration, false)
        self:StartIntervalThink(0.03)
        local caster = self:GetParent()
        self.nParticleID = ParticleManager:CreateParticle("particles/creatures/boss_huskar/huskar_poison_milk.vpcf", PATTACH_ABSORIGIN, caster)
        ParticleManager:SetParticleControl(self.nParticleID, 0, caster:GetOrigin() + Vector(0,0,160))
        self.vStartPosition = self:GetParent():GetAbsOrigin() + Vector(0, -1000, 0)
        self.flStartTime = GameRules:GetDOTATime(false, false)

        self:AddParticle(self.nParticleID, true, false, 0, false, false)

        StartSoundEvent("Hero_Phoenix.SunRay.Loop", self:GetParent())
    end
end

function modifier_huskar_poison_milk_channel:OnIntervalThink()
    if IsServer() then
        local angle = 360 * (GameRules:GetDOTATime(false, false) - self.flStartTime) / self.flDuration
        local target_position = RotatePosition(self:GetParent():GetOrigin(), QAngle(0, -angle, 0), self.vStartPosition)
        local forward = (target_position - self:GetParent():GetOrigin()):Normalized()
        forward.z = 0
        self:GetParent():SetForwardVector(forward)

        target_position.z = 160

        --DebugDrawCircle(target_position, Vector(255,0,0), 62, 62, false, 0.03)
        ParticleManager:SetParticleControl(self.nParticleID, 1, target_position)

        local units = FindUnitsInLine(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), target_position, nil, 128, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, FIND_ANY_ORDER)

        for _, unit in pairs(units) do
            utilsDamage.DealDamagePercentage(self:GetParent(), unit, 10, self:GetAbility())
        end
    end
end

function modifier_huskar_poison_milk_channel:OnDestroy()
    if IsServer() then
        ParticleManager:DestroyParticle(self.nParticleID, true)
        StopSoundEvent("Hero_Phoenix.SunRay.Loop", self:GetParent())
    end
end

function modifier_huskar_poison_milk_channel:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }
end

function modifier_huskar_poison_milk_channel:GetOverrideAnimation()
    return ACT_DOTA_VICTORY
end

function modifier_huskar_poison_milk_channel:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end