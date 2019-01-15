bullet_attack = class({})

local function initializeHeroData(caster)
    caster.flLastShootTime = 0
    local kv               = GameRules.Heroes_KV
    if not caster:IsHero() then
        kv = GameRules.Units_KV
    end

    caster.psz_BulletName           = caster.psz_BulletName or kv[caster:GetUnitName()].BulletName or "FailSafeBullet"
    local m_BulletDefination        = GameRules.Bullets_KV[caster.psz_BulletName] or GameRules.Bullets_KV['FailSafeBullet']
    caster.psz_BulletParticle       = caster.psz_BulletParticle or m_BulletDefination.BulletParticle
    caster.psz_BulletImpactParticle = caster.psz_BulletImpactParticle or m_BulletDefination.BulletImpactParticle or GameRules.Bullets_KV['FailSafeBullet'].BulletImpactParticle
    caster.psz_BulletStartSound     = caster.psz_BulletStartSound or m_BulletDefination.BulletStartSound
    caster.psz_BulletEndSound       = caster.psz_BulletEndSound or m_BulletDefination.BulletEndSound
    caster.flBulletStartRadius = caster.flBulletStartRadius or tonumber(kv[caster:GetUnitName()].BulletStartRadius) or 48
    caster.flBulletEndRadius = caster.flBulletEndRadius or tonumber(kv[caster:GetUnitName()].BulletEndRadius) or 48
    caster.flBulletSpeed            = caster.flBulletSpeed or tonumber(kv[caster:GetUnitName()].BulletSpeed) or 1000
    caster.flBulletAngle            = caster.flBulletAngle or tonumber(kv[caster:GetUnitName()].BulletAngle) or 0
    caster.nBulletCount             = caster.nBulletCount or tonumber(kv[caster:GetUnitName()].BulletCount) or 1
    caster.flBulletDistance         = caster.flBulletDistance or tonumber(kv[caster:GetUnitName()].BulletDistance) or 2000

    caster.b_ShootingDataSet        = true
end

function bullet_attack:ShootABullet()
    if IsServer() then
        local caster = self:GetCaster()
        if not caster.b_ShootingDataSet then
            initializeHeroData(caster)
        end

        -- 初始化用于Modifier加成的数据
        caster.flBulletSpeedBonus             = 0
        caster.nBulletCountBonus              = 0
        caster.m_BulletSpecialEffect          = {}
        caster.flBulletCriticalStrikeChance   = 0
        caster.flBulletCriticalStrikeMultiple = 0
        caster.flBulletAngleBonus             = 0
        caster.flBulletDistanceBonus          = 0
        caster.flBulletStartRadiusBonus       = 0
        caster.flBulletEndRadiusBonus         = 0
        caster.bBulletDeleteOnHit             = true
        caster.flManaBonus                    = 1
        caster.flBulletDamageBonus            = 0
        caster.flBulletDamageBonusPercentage  = 0
        caster.psz_BulletStartSound_Override  = nil
        caster.psz_BulletEndSound_Override    = nil
        caster.nAttackGesture                 = nil
        self.vProjectileIDs                   = {}

        local modifierCount                   = caster:GetModifierCount()
        for i = 0, modifierCount - 1 do
            local mn       = caster:GetModifierNameByIndex(i)
            local modifier = caster:FindModifierByName(mn)
            if modifier and modifier.DeclareBulletFunctions then
                local modifierFuctions = modifier:DeclareBulletFunctions()
                for _, enum in pairs(modifierFuctions) do
                    local funcName = BulletModifierDefination[enum].FunctionName
                    local callback = BulletModifierDefination[enum].callback
                    local func     = modifier[funcName]
                    if not func then
                        print(string.format("Modifier %s have bullet property defined but %s method not found", mn, funcName))
                    else
                        local value = func(modifier, self)
                        -- 调用回调函数来处理数据
                        if value then
                            callback(caster, value)
                        else
                            print(string.format("Modifier %s method %s return a nil value", mn, funcName))
                        end
                    end
                end
            end

            -- 其他不需要声明的Custom Modifier Function
            if modifier and modifier.GetAttackGesture then
                caster.nAttackGesture = modifier:GetAttackGesture()
            end
        end

        local origin    = caster:GetAbsOrigin()
        local direction = ((caster.m_MousePosition or Vector(0, 0, 0)) - origin):Normalized()
        -- local direction = caster:GetForwardVector()
        direction.z     = 0

        -- 从origin开始，往一个方向，在angle范围内发射count个弹道，最多前进distance距离
        local function launchBullets(angle, count, distance, start_radius, end_radius, speed)
            local directions
            if count <= 1 then
                directions = { direction }
            else
                -- 最左侧
                local mostLeftDirection = RotatePosition(Vector(0, 0, 0), QAngle(0, angle / 2, 0), direction)
                directions              = { mostLeftDirection }
                for i = 1, count - 1 do
                    local newDirection = RotatePosition(Vector(0, 0, 0), QAngle(0, - angle / (count - 1)), mostLeftDirection)
                    mostLeftDirection  = newDirection
                    table.insert(directions, newDirection)
                end
            end

            for _, direction in pairs(directions) do
                local info       = {
                    EffectName       = caster.psz_BulletParticle,
                    Ability          = self,
                    vSpawnOrigin     = origin,
                    Source           = caster,
                    fDistance        = distance,
                    fStartRadius     = start_radius,
                    fEndRadius       = end_radius,
                    bHasFrontalCone  = false,
                    bReplaceExisting = false,
                    iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_ENEMY,
                    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                    iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                    fExpireTime      = GameRules:GetGameTime() + 10.0,
                    vVelocity        = direction * speed,
                }

                local projectile = ProjectileManager:CreateLinearProjectile(info)
                table.insert(self.vProjectileIDs, projectile)

                for i = 0, caster:GetModifierCount() - 1 do
                    local mn       = caster:GetModifierNameByIndex(i)
                    local modifier = caster:FindModifierByName(mn)
                    if modifier and modifier.OnBulletProjectileLaunch then
                        modifier:OnBulletProjectileLaunch(self, {})
                    end
                end
            end
        end

        -- 根据计算的结果，来确定最终的数值
        launchBullets(
        caster.flBulletAngle + caster.flBulletAngleBonus, -- angle
        caster.nBulletCount + caster.nBulletCountBonus, -- count
        caster.flBulletDistance + caster.flBulletDistanceBonus, -- distance
        caster.flBulletStartRadius + caster.flBulletStartRadiusBonus, -- start_radius
        caster.flBulletEndRadius + caster.flBulletEndRadiusBonus, -- end_radius
        caster.flBulletSpeed + caster.flBulletSpeedBonus -- speed
        )

        caster:StartGestureWithPlaybackRate((caster.nAttackGesture or ACT_DOTA_ATTACK), 3)

        EmitSoundOn(caster.psz_BulletStartSound_Override or caster.psz_BulletStartSound, caster)
    end
end

function bullet_attack:OnProjectileHit(target, position)
    if IsServer() then
        if not target then
            return
        end

        local caster        = self:GetCaster()

        -- PerformAttack(hTarget,bUseCastAttackOrb,bProcessProcs,bSkipCooldown,bIgnoreInvis,bUseProjectile,bFakeAttack,bNeverMiss)
        caster:PerformAttack(target,true,true,true,false,false,false,false)

        -- 击退效果
        -- 只有对有移动能力的单位有效
        -- 如何才能让击退对某个单位无效？
        -- 手动加吧！
        -- 拥有 __bCannotKnockback__ 属性的单位不会被击退
        -- 要注意，击退是一个眩晕
        -- 会打断大多数技能
        -- 如果你的英雄具有持续施法类的技能，最好给他加上不可以被击退的效果

        if target:HasMovementCapability() and not target.__bCannotKnockback__ then
            local direction = (target:GetOrigin() - caster:GetOrigin()):Normalized()
            utilsCreatures.CreatureKnockback(target, target:GetOrigin() + direction * 32, 0, 500)
        end

        -- 发出声音
        EmitSoundOn(caster.psz_BulletEndSound_Override or caster.psz_BulletEndSound, target)

        return caster.bBulletDeleteOnHit -- 默认为true，只能命中第一个目标
    end
end