modifier_creature_leap = class({})

function modifier_creature_leap:IsHidden()
    return false
end

function modifier_creature_leap:IsPurgable()
    return false
end

function modifier_creature_leap:IsStunDebuff()
    return true
end

function modifier_creature_leap:OnCreated(kv)
    if IsServer() then
        local x = kv.target_x
        local y = kv.target_y
        local z = kv.target_z
        local speed = kv.speed
        local height = kv.height

        local jumper = self:GetParent()

        self.vStartPos = jumper:GetOrigin()
        self.vDirection = (Vector(x, y, z) - self.vStartPos):Normalized()
        self:GetParent():SetForwardVector(self.vDirection)
        self.flSpeed = speed
        self.flHeight = height
        self.flDistance = (Vector(x, y, z) - self.vStartPos):Length2D()
        if self:ApplyVerticalMotionController() == false then print("failed to apply motion controller") self:Destroy() end
        if self:ApplyHorizontalMotionController() == false then self:Destroy() end

        -- 如果有特效，那么添加特效
        --if kv.EffectName then
        --    local pid = ParticleManager:CreateParticle(kv.EffectName, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        --    ParticleManager:SetParticleControlEnt(pid, 0, jumper, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", jumper:GetOrigin(), true)
        --    self:AddParticle(pid, true, true, 0, true, false)
        --end
    end
end

function modifier_creature_leap:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        local vNewPos = self:GetParent():GetOrigin() + self.vDirection * self.flSpeed * dt
        vNewPos.z = 0
        me:SetOrigin(vNewPos)
    end
end

function modifier_creature_leap:UpdateVerticalMotion(me, dt)
    if IsServer() then
        local origin = me:GetOrigin()
        local distance = (origin - self.vStartPos):Length2D()
        local z = -4 * self.flHeight / (self.flDistance * self.flDistance) * (distance * distance) + 4 * self.flHeight / self.flDistance * distance + self.vStartPos.z
        origin.z = z
        local groundHeight = GetGroundHeight(origin, self:GetParent())
        local landed = false
        if (origin.z < groundHeight and distance >= self.flDistance) then
            origin.z = groundHeight
            landed = true
        end

        me:SetOrigin(origin)

        if landed then
            self:GetParent():RemoveHorizontalMotionController(self)
            self:GetParent():RemoveVerticalMotionController(self)
            self:SetDuration(0.15, true)
        end
    end
end

function modifier_creature_leap:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():RemoveVerticalMotionController(self)

        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_phased", {Duration = 0.2})

    end
end

function modifier_creature_leap:GetAttributes()
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_creature_leap:DeclareFunctions()
    return {}
end

