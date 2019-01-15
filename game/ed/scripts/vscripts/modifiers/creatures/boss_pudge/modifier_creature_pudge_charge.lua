modifier_creature_pudge_charge = class({})

function modifier_creature_pudge_charge:IsStunDebuff()
    return true
end

function modifier_creature_pudge_charge:IsPurgable()
    return false
end

function modifier_creature_pudge_charge:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
    }
end

function modifier_creature_pudge_charge:IsAura()
    return true
end

function modifier_creature_pudge_charge:GetModifierAura()
    if IsServer() then
        return "modifier_creature_pudge_charge_hit_knockback"
    end
    return ""
end

function modifier_creature_pudge_charge:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_creature_pudge_charge:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_creature_pudge_charge:GetAuraRadius()
    return 300
end

function modifier_creature_pudge_charge:OnCreated(kv)
    if IsServer() then

        if self:ApplyHorizontalMotionController() == false then
            self:Destroy()
        end

        self.vDirection                        = self:GetParent():GetForwardVector()
        self:GetParent().b_HasMotionController = true -- 这个东西是必须的
    end
end

function modifier_creature_pudge_charge:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        local vNewPos = self:GetParent():GetOrigin() + self.vDirection * 1000 * dt
        if GridNav:IsTraversable(vNewPos) then
            me:SetOrigin(vNewPos)
        else
            self:Destroy()
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = 3 })
        end

    end
end

function modifier_creature_pudge_charge:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent().b_HasMotionController = false
    end
end

function modifier_creature_pudge_charge:DeclareFunctions()
    return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION }
end

function modifier_creature_pudge_charge:GetOverrideAnimation()
    return ACT_DOTA_CAST_ABILITY_ROT
end

