modifier_spike_trap = class({})

function modifier_spike_trap:IsStunDebuff()
    return true
end

function modifier_spike_trap:IsHidden()
    return false
end

function modifier_spike_trap:IsPurgable()
    return false
end

function modifier_spike_trap:OnCreated()
    if IsServer() then
        if not self:ApplyHorizontalMotionController() or not self:ApplyVerticalMotionController() then
            self:Destroy()
            return
        end

        self:SetDuration(0.7, true)

        utilsDamage.DealDamagePercentage(self:GetCaster(), self:GetParent(), 10, self:GetAbility())

        self.vStartPosition    = self:GetParent():GetOrigin()
        self.vOrigin           = self:GetCaster():GetOrigin()

        self.vTargetPosition   = self.vOrigin + ((self.vStartPosition - self.vOrigin):Normalized() * 120)
        -- DebugDrawCircle(self.vOrigin,Vector(255,0,0),255,90,false,5)
        -- DebugDrawCircle(self.vTargetPosition,Vector(0,255,0),255,90,false,5)

        self.flDuration        = 0.7
        self.flHeight          = 200
        self.vDirection        = (self.vTargetPosition - self.vStartPosition):Normalized()
        self.flDistance        = (self.vTargetPosition - self.vStartPosition):Length2D()
        self.flHorizontalSpeed = self.flDistance / self.flDuration

        self:StartIntervalThink(1.0)
    end
end

function modifier_spike_trap:OnIntervalThink()
    if IsServer() then
        utilsDamage.DealDamagePercentage(self:GetCaster(), self:GetParent(), 10, self:GetAbility())
    end
end

function modifier_spike_trap:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveVerticalMotionController(self)
        self:GetParent():RemoveHorizontalMotionController(self)
    end
end

function modifier_spike_trap:DeclareFunctions()
    return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION }
end

function modifier_spike_trap:CheckState()
    return { 
        [MODIFIER_STATE_STUNNED] = true 
    }
end

function modifier_spike_trap:GetOverrideAnimation()
    return ACT_DOTA_RUN
end

function modifier_spike_trap:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        -- 根据速度，设置当前的位置
        local vOldPosition = me:GetOrigin()
        local vNewPos      = vOldPosition + self.vDirection * self.flHorizontalSpeed * dt
        vNewPos.z          = 0
        me:SetOrigin(vNewPos)

        -- 判断是否到达了终点
    end
end

function modifier_spike_trap:UpdateVerticalMotion(me, dt)
    if IsServer() then
        local vOrigin        = me:GetOrigin()
        local vDistance      = (vOrigin - self.vStartPosition):Length2D()
        local vZ             = - 4 * self.flHeight / (self.flDistance * self.flDistance) * (vDistance * vDistance) + 4 * self.flHeight / self.flDistance * vDistance
        vOrigin.z            = vZ
        -- 判断是否到达了终点
        local flGroundHeight = GetGroundHeight( vOrigin, self:GetParent() )
        local bLanded        = false

        if ( vOrigin.z < flGroundHeight and vDistance > self.flDistance / 2 ) then
            vOrigin.z = flGroundHeight
            bLanded   = true
        end

        me:SetOrigin(vOrigin)
        if bLanded == true then
            self:GetParent():RemoveHorizontalMotionController(self)
            self:GetParent():RemoveVerticalMotionController(self)
            self:SetDuration(0.15, true)
        end
    end
end