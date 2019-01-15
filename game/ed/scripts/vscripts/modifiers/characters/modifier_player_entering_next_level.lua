---@type CDOTA_Modifier_Lua
modifier_player_entering_next_level = class({})

function modifier_player_entering_next_level:CheckState()
    return {
        [MODIFIER_STATE_STUNNED]      = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_ROOTED]       = true,
        [MODIFIER_STATE_SILENCED]     = true,
    }
end

function modifier_player_entering_next_level:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_MODEL_SCALE,
    }
end

function modifier_player_entering_next_level:OnDestroy()
    if IsServer() then
        self:GetParent().b_HasMotionController = false
        self:GetParent():RemoveHorizontalMotionController(self)
    end
end

function modifier_player_entering_next_level:GetModifierModelScale()
    if IsServer() then
        return (- 0.5 * self.flTimeExpired) / self:GetDuration() + 1
    end
end

function modifier_player_entering_next_level:OnCreated(kv)
    if IsServer() then

        local success                          = self:ApplyHorizontalMotionController()
        local owner                            = self:GetParent()

        self.vStartingPosition                 = owner:GetOrigin()
        self.vStartingForwardVector            = owner:GetForwardVector()
        self.vStartingLength                   = (self.vStartingPosition - GetCenter()):Length2D()
        self.flTimeExpired                     = 0

        self:GetParent().b_HasMotionController = true
    end
end

function modifier_player_entering_next_level:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end

function modifier_player_entering_next_level:UpdateHorizontalMotion(me, dt)
    if IsServer() then

        self.flTimeExpired  = self.flTimeExpired + dt
        -- 转两圈
        local totalDuration = self:GetDuration()
        local progress      = self.flTimeExpired / totalDuration * - 720
        local newPosition   = RotatePosition(GetCenter(), QAngle(0, - progress, 0), self.vStartingPosition)
        local newDirection  = (newPosition - GetCenter()):Normalized()
        local newLength     = (totalDuration - self.flTimeExpired) / totalDuration * self.vStartingLength
        local newForward    = RotatePosition(Vector(0, 0, 0), QAngle(0, progress, 0), self.vStartingForwardVector)
        local newOrigin     = newDirection * newLength
        me:SetOrigin(newOrigin)
    end
end