modifier_creature_knockback = class({})

function modifier_creature_knockback:IsHidden()
    return false
end

function modifier_creature_knockback:IsPurgable()
    return false
end

function modifier_creature_knockback:IsStunDebuff()
    return true
end

function modifier_creature_knockback:OnCreated(kv)
    if IsServer() then
        local x = kv.target_x
        local y = kv.target_y
        local z = kv.target_z
        local speed = kv.speed
        local height = kv.height

        local jumper = self:GetParent()

        self.vStartPos = jumper:GetOrigin()
        self.vDirection = (Vector(x, y, z) - self.vStartPos):Normalized()
        self.flSpeed = speed
        self.flHeight = height
        self.flDistance = (Vector(x, y, z) - self.vStartPos):Length2D()
        if self:ApplyVerticalMotionController() == false then
            self:Destroy()
        end
        if self:ApplyHorizontalMotionController() == false then
            self:Destroy()
        end
    end
end

function modifier_creature_knockback:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        local vNewPos = self:GetParent():GetOrigin() + self.vDirection * self.flSpeed * dt
        vNewPos.z = 0
        me:SetOrigin(vNewPos)
    end
end

function modifier_creature_knockback:UpdateVerticalMotion(me, dt)
    if IsServer() then
        local origin = me:GetOrigin()
        local distance = (origin - self.vStartPos):Length2D()
        local z = -4 * self.flHeight / (self.flDistance * self.flDistance) * (distance * distance) + 4 * self.flHeight / self.flDistance * distance
        origin.z = z
        local groundHeight = GetGroundHeight(origin, self:GetParent())
        local landed = false
        if (origin.z < groundHeight and distance > self.flDistance / 2) then
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

function modifier_creature_knockback:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():RemoveVerticalMotionController(self)

        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_phased", { Duration = 0.2 })

    end
end

function modifier_creature_knockback:GetAttributes()
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_creature_knockback:DeclareFunctions()
    return {}
end

