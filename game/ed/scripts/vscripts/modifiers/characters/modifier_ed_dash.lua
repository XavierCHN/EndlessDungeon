modifier_ed_dash = class({})

function modifier_ed_dash:IsStunDebuff()
    return true
end

function modifier_ed_dash:IsHidden()
    return true
end

function modifier_ed_dash:IsPurgable()
    return false
end

function modifier_ed_dash:RemoveOnDeath()
    return false
end

function modifier_ed_dash:OnCreated(kv)
    if IsServer() then
        if self:ApplyHorizontalMotionController() == false then
            self:Destroy()
            return
        end
        local owner         = self:GetParent()
        self.vStartPosition = GetGroundPosition(owner:GetOrigin(), owner)
        self.flDuration     = self:GetAbility():GetSpecialValueFor("duration")
        self.flSpeed        = self:GetAbility():GetSpecialValueFor("speed")
        self:SetDuration(self.flDuration, true)
        self:GetParent().b_HasMotionController = true

        local nFXIndex                         = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_blast_off_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        self:AddParticle( nFXIndex, false, false, - 1, false, false )
    end
end

function modifier_ed_dash:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent().b_HasMotionController = false
    end
end

function modifier_ed_dash:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }
end

function modifier_ed_dash:CheckState()
    return {
        [MODIFIER_STATE_STUNNED]      = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
    }
end

function modifier_ed_dash:GetOverrideAnimation( params )
    return ACT_DOTA_OVERRIDE_ABILITY_4
end

function modifier_ed_dash:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        local owner   = self:GetParent()
        local fw      = owner:GetForwardVector()
        local origin  = owner:GetOrigin()
        local vNewPos = origin + fw * self.flSpeed * dt
        me:SetOrigin(vNewPos)
    end
end