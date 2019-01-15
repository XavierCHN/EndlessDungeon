modifier_clinkz_fire_arrows_thinker = class({})

function modifier_clinkz_fire_arrows_thinker:CheckState()
    return {
        [MODIFIER_STATE_ROOTED]       = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
    }
end

function modifier_clinkz_fire_arrows_thinker:DeclareFunctions()
    return { MODIFIER_PROPERTY_INVISIBILITY_LEVEL }
end

function modifier_clinkz_fire_arrows_thinker:GetModifierInvisibilityLevel()
    return 1
end

function modifier_clinkz_fire_arrows_thinker:ShootArrows()
    if IsServer() then
        local direction = self.nCurrentShootDirection
        for i = 1, self.nArrowPerShoot do
            local pos = GetRandomTopPosition()
            local os
            if direction == 1 then
                os   = Vector(pos.x, pos.y, pos.z)
                os.y = GetMinY()
            elseif direction == 2 then
                pos  = GetRandomLeftPosition()
                os   = Vector(pos.x, pos.y, pos.z)
                os.x = GetMaxX()
            elseif direction == 3 then
                pos  = GetRandomBottomPosition()
                os   = Vector(pos.x, pos.y, pos.z)
                os.y = GetMaxY()
            elseif direction == 4 then
                pos  = GetRandomRightPosition()
                os   = Vector(pos.x, pos.y, pos.z)
                os.x = GetMinX()
            end

            local direction = (os - pos):Normalized()
            local speed     = self.flArrowSpeed

            local info      = {
                EffectName       = "particles/creatures/clinkz/clinkz_searing_arrow.vpcf",
                Ability          = self:GetAbility(),
                vSpawnOrigin     = pos,
                Source           = self:GetParent(),
                fDistance        = 3000,
                fStartRadius     = 64,
                fEndRadius       = 64,
                bHasFrontalCone  = false,
                bReplaceExisting = false,
                iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_ENEMY,
                iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                fExpireTime      = GameRules:GetGameTime() + 10.0,
                vVelocity        = direction * speed,
            }

            ProjectileManager:CreateLinearProjectile(info)
            EmitSoundOnLocationWithCaster(pos, "Hero_Clinkz.SearingArrows", self:GetParent())
        end
    end
end

-- 

function modifier_clinkz_fire_arrows_thinker:OnCreated(kv)
    if IsServer() then
        local level          = GameRules.gamemode:GetCurrentLevel()
        self.flThinkInterval = 1
        self:StartIntervalThink(self.flThinkInterval)
        self:SetDuration(6, false)
        self.nArrowPerShoot         = 8 + level * 1
        self.flArrowSpeed           = 600 + level * 20
        self.nCurrentShootDirection = 1
    end
end

function modifier_clinkz_fire_arrows_thinker:OnIntervalThink()
    if IsServer() then
        self.nCurrentShootDirection = self.nCurrentShootDirection + 1
        if self.nCurrentShootDirection > 4 then
            self.nCurrentShootDirection = 1
        end
        self:ShootArrows()
    end
end