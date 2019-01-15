modifier_techies_bomb_fuse = class({})

function modifier_techies_bomb_fuse:OnCreated(kv)
    if IsServer() then
        local bomb         = self:GetParent()
        self.flFuseTime    = kv.fuse_time
        self.nExplodeRange = kv.explode_range

        self:SetDuration(self.flFuseTime, false)

        local fuse_pid = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_homing_missile_fuse.vpcf", PATTACH_WORLDORIGIN, bomb)
        ParticleManager:SetParticleControl(fuse_pid, 0, bomb:GetOrigin() + Vector(0, - 20, 75))
        ParticleManager:SetParticleControl(fuse_pid, 1, Vector(self.flFuseTime, 0, 0))
        ParticleManager:ReleaseParticleIndex(fuse_pid)

        EmitSoundOn("Techies.Bomb.Fuse", bomb)
    end
end

function modifier_techies_bomb_fuse:OnDestroy()
    if IsServer() then

        local room             = GameRules.gamemode:GetCurrentRoom()

        local bomb             = self:GetParent()
        local origin           = bomb:GetOrigin()
        local ability          = self:GetAbility()
        local x, y             = room:GetCellCoordAtPosition(origin)

        local effected_enemies = {}

        local function fireEffectAndDealDamageToEnmiesAroundPoint(center)
            local pid = ParticleManager:CreateParticle("particles/creatures/boss_techies/techies_bomb_explode.vpcf", PATTACH_WORLDORIGIN, bomb)
            ParticleManager:SetParticleControl(pid, 0, center)
            ParticleManager:ReleaseParticleIndex(pid)

            local enemies = FindUnitsInRadius(bomb:GetTeamNumber(), center, nil, 65, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            for _, enemy in pairs(enemies) do
                utilsDamage.DealDamagePercentage(bomb, enemy, 40, ability)
            end
        end

        -- 中心点
        if room:IsValidCell(x, y ) then
            fireEffectAndDealDamageToEnmiesAroundPoint(room:GetCellCenterAtCoord(x, y))
        end

        -- 四周扩展
        local range = 1

        Timer(0, function()
            if room:IsValidCell(x + range, y ) then
                fireEffectAndDealDamageToEnmiesAroundPoint(room:GetCellCenterAtCoord(x + range, y ))
            end
            if room:IsValidCell(x - range, y ) then
                fireEffectAndDealDamageToEnmiesAroundPoint(room:GetCellCenterAtCoord(x - range, y ))
            end
            if room:IsValidCell(x, y + range) then
                fireEffectAndDealDamageToEnmiesAroundPoint(room:GetCellCenterAtCoord(x, y + range))
            end
            if room:IsValidCell(x, y - range) then
                fireEffectAndDealDamageToEnmiesAroundPoint(room:GetCellCenterAtCoord(x, y - range))
            end
            range = range + 1
            if range < self.nExplodeRange then
                return 0
            end
            return nil
        end)

        EmitSoundOn("Hero_TemplarAssassin.Trap.Explode", bomb)

        bomb:ForceKill(false)
    end
end