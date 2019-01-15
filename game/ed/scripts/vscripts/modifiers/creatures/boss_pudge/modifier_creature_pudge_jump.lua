modifier_creature_pudge_jump = class({})

function modifier_creature_pudge_jump:IsStunDebuff()
    return true
end

function modifier_creature_pudge_jump:IsHidden()
    return true
end

function modifier_creature_pudge_jump:IsPurgable()
    return false
end

function modifier_creature_pudge_jump:RemoveOnDeath()
    return false
end

function modifier_creature_pudge_jump:OnCreated(kv)
    if IsServer() then
        if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then
            self:Destroy()
            return
        end

        self.vStartPosition    = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )

        self.vTargetPosition   = self:GetAbility():GetCursorPosition()
        self.flDuration        = 1.7
        self.flHeight          = 4000

        self.vDirection        = (self.vTargetPosition - self.vStartPosition):Normalized()
        self.flDistance        = (self.vTargetPosition - self.vStartPosition):Length2D()
        self.flHorizontalSpeed = self.flDistance / self.flDuration

        -- 创建开始的特效和音效
        EmitSoundOnLocationWithCaster(self.vStartPosition, "Ability.TossThrow", self:GetParent())

    end
end

function modifier_creature_pudge_jump:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():RemoveVerticalMotionController(self)
    end
end

function modifier_creature_pudge_jump:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function modifier_creature_pudge_jump:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

function modifier_creature_pudge_jump:GetOverrideAnimation()
    return ACT_DOTA_CAST_ABILITY_ROT
end

function modifier_creature_pudge_jump:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        -- 根据速度，设置当前的位置
        local vOldPosition = me:GetOrigin()
        local vNewPos      = vOldPosition + self.vDirection * self.flHorizontalSpeed * dt
        vNewPos.z          = 0
        me:SetOrigin(vNewPos)

        -- 判断是否到达了终点
    end
end

function modifier_creature_pudge_jump:UpdateVerticalMotion(me, dt)
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
            -- ApplyDamage
            local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 275, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            for _, unit in pairs(units) do
                utilsDamage.DealDamagePercentage(self:GetParent(), unit, 20, self)
            end

            -- Particle
            local pid = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
            ParticleManager:SetParticleControl(pid, 0, me:GetOrigin())
            ParticleManager:ReleaseParticleIndex(pid)

            EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), "Ability.TossImpact", self:GetParent())

            for i = 1, 18 do
                CreatureAttack({
                    source    = self:GetParent(),
                    sourcePos = self:GetParent():GetOrigin(),
                    targetPos = GetRandomPosition(),
                    speed     = 800,
                    length = 1200,
                })
            end

            local enemy = AIUtil:RandomPlayerHero()
            CreatureAttack({
                source    = self:GetParent(),
                sourcePos = self:GetParent():GetOrigin(),
                targetPos = enemy:GetOrigin(),
                speed     = 800,
                length = 1200,
            })

            self:GetParent():RemoveHorizontalMotionController(self)
            self:GetParent():RemoveVerticalMotionController(self)
            self:SetDuration(0.15, true)
        end
    end
end