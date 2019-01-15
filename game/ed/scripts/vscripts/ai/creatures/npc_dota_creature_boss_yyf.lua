--- 当前版本的最终BOSS
--- 胖头鱼！！！
---
--- 胖头鱼有三个形态，击杀上一个形态的BOSS就召唤下一个形态
--- 1. 枫暴之灵（蓝猫）
---    血量5000
---    在场地上不动，发射子弹（8方向+4方向）
---    随机召唤残影，残影发射3方向子弹
---    被击杀后召唤2000血量风暴之灵买活版（显示买活）
---    快速球状闪电+全屏子弹
---    之后发射子弹（8方向+4方向），地上出现往BOSS方向移动的充能球
---    充能球可以被玩家撞掉
---    但是会对玩家造成100点伤害
---    每个充能球给BOSS恢复魔法
---    根据魔法继续开始球状闪电
---
---    以上蓝猫——买活循环三次
---
---    击杀后召唤熊猫酒仙
--- 2. 熊猫酒仙
---    三个分身熊猫
---    每个血量2000
---       1. 风 在场地上召唤风暴，对靠近的敌人造成持续伤害（枭兽的吹风）（5秒一个），往随机的方向移动
---       2. 火 在场地上快速移动（逆时针）（飞行状态）
---       3. 地 随机四方向地刺子弹
---    根据击杀顺序决定第三阶段胖头鱼的的技能状态
---    根据击杀顺序，分别给各自状态200%，100%，50%的效果。
---       1. 风 —— 冲刺阶段的速度提升50
---       2. 火 —— 天火的延迟降低0.2
---       3. 地 —— 子弹的速度提升200
--- 3. 大鱼人（胖头鱼）
---    血量10000
---    1. 高等级天火
---    2. 全屏子弹
---    3. 当血量低于20%，开启EM模式，开始冲刺，快速移动同时全屏子弹


module("AIThink", package.seeall)

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
--- 常量
local STORM_SPIRIT_FIRST_REMANT_TIME = 20
local STORM_SPIRIT_REMANT_INTERVAL = 20
local STORM_SPIRIT_MAX_REMANT_COUNT = 5

local BREWMASTER_WIND_INTERVAL = 10 -- 刮风间隔
local BREWMASTER_FIRE_PROJECTILE_INTERVAL = 4 -- 火焰弹间隔
local BREWMASTER_EARTH_SPLIT_INTERVAL = 3 -- 撕裂大地间隔
local BREWMASTER_FIRST_WIND = 2 -- 首次刮风时间
local BREWMASTER_FIRST_FIRE_PROJECTILE = 4 -- 首次火焰弹时间
local BREWMASTER_FIRST_EARTH_SPLIT = 6 -- 首次撕裂大地时间
local BREW_MASTER_ABILITY_VIRATION = 0.9 -- 间隔时间的偏移
---       1. 风 —— 冲刺阶段的速度提升50
local SLARDAR_CHARGE_SPEED_BONUS = 100
local SLARDAR_CHARGE_SPEED_BONUS_EXTRA = 50
---       2. 火 —— 天火的延迟降低0.2
local SLARDAR_SUNSTRIKE_DELAY = 1.5
local SLARDAR_SUNSTRIKE_DELAY_REDUCE = -0.2
------       3. 地 —— 子弹的速度提升200
local SLARDAR_PROJECTILE_SPEED = 800
local SLARDAR_PROJECTILE_SPEED_BONUS = 200

local SLARDAR_CHARGE_INTERVAL = 10
local SLARDAR_FIRST_CHARGE_TIME = 7

local SLARDAR_SUNSTRIKE_INTERVAL = 10
local SLARDAR_FIRST_SUNSTRIKE_TIME = 5
local SLARDAR_LITTLE_ZOMBIE_SUMMON_INTERVAL = 10
local SLARDAR_FIRST_LITTLE_ZOMBIE_TIME = 3
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------
---本地的函数
local function getAbilityIntervalViration(baseInterval)
    return RandomFloat(baseInterval - BREW_MASTER_ABILITY_VIRATION, baseInterval + BREW_MASTER_ABILITY_VIRATION)
end

-- 随机八方向子弹
local function stormSpiritAttack1(self)
    AttackAt8Directions(self, RandomVector(1) * 2000, {
        effectName = "particles/creatures/boss_yyf/storm_spirit_attack_linear.vpcf",
        startSound = "Hero_StormSpirit.Attack",
        speed = 500,
    })
    return 0.6
end

-- 
local function stormSpiritAttack2(self)
    local targetPos = Vector(2000, 0, 0)
    for i = 0, 5 do
        Timer(0.1 * i, function()
            targetPos = RotatePosition(Vector(0, 0, 0), QAngle(0, -16, 0), targetPos)
            AttackAt4Directions(self, targetPos, {
                effectName = "particles/creatures/boss_yyf/storm_spirit_attack_linear.vpcf",
                startSound = "Hero_StormSpirit.Attack",
                speed = 300,
            })
        end)
    end
    targetPos = Vector(2000, 0, 0)
    targetPos = RotatePosition(Vector(0, 0, 0), QAngle(0, 8, 0), targetPos)
    Timer(0.5, function()
        for i = 0, 5 do
            Timer(0.1 * i, function()
                targetPos = RotatePosition(Vector(0, 0, 0), QAngle(0, -16, 0), targetPos)
                AttackAt4Directions(self, targetPos, {
                    effectName = "particles/creatures/boss_yyf/storm_spirit_attack_linear.vpcf",
                    startSound = "Hero_StormSpirit.Attack",
                    speed = 500,
                })
            end)
        end
    end)

    return 3
end

local function stormSpiritAttack3(self)
    -- 往玩家方向的八个密集子弹
    local enemy = AIUtil:RandomPlayerHero()
    local originalDirection = (enemy:GetOrigin() - self:GetOrigin()):Normalized()
    for i = -2, 3 do
        local direction = RotatePosition(Vector(0, 0, 0), QAngle(0, -25 + 10 * i, 0), originalDirection)
        DebugDrawCircle(self:GetOrigin() + direction * 800, Vector(255, 0, 0), 64, 64, false, 1)
        self:BulletAttack(self:GetOrigin() + direction * 2000, 600, {
            effectName = "particles/creatures/boss_yyf/storm_spirit_attack_linear.vpcf",
            startSound = "Hero_StormSpirit.Attack",
        })
    end
    return 0.6
end

-- 三个正方向旋转
local function stormSpiritAttack4(self)
    local origins = {
        Vector(0, 300, 0),
        Vector(-250, -100, 0),
        Vector(250, -100, 0)
    }

    for _, origin in pairs(origins) do
        for i = 1, 24 do
            Timer(0.03 * i, function()
                local targetPos = RotatePosition(origin, QAngle(0, -15*i, 0), origin + Vector(2000, 0, 0))
                self:BulletAttack(targetPos, 400, {
                    effectName = "particles/creatures/boss_yyf/storm_spirit_attack_linear.vpcf",
                    startSound = "Hero_StormSpirit.Attack",
                    sourcePos = origin,
                })
            end)
        end
    end
    return 3
end
---------------------------------------------------------------------------------------------------------
---AI 蓝猫
---------------------------------------------------------------------------------------------------------
function npc_dota_creature_storm_spirit(self)

    if not IsValidAlive(self) then
        return nil
    end

    if GameRules.nStormSpiritBuybackCount == nil then
        GameRules.nStormSpiritBuybackCount = 0
    end

    local now = GameRules:GetGameTime()
    if self.flLastRemantTime == nil then
        self.flLastRemantTime = now - STORM_SPIRIT_REMANT_INTERVAL + STORM_SPIRIT_FIRST_REMANT_TIME
    end

    GameRules.gamemode:GetCurrentRoom().hBossHealthBarUnit = self

    if GameRules.nYYFRemantCount == nil then
        GameRules.nYYFRemantCount = 0
    end

    if now - self.flLastRemantTime > STORM_SPIRIT_REMANT_INTERVAL and GameRules.nYYFRemantCount < STORM_SPIRIT_MAX_REMANT_COUNT then
        GameRules.nYYFRemantCount = GameRules.nYYFRemantCount + 1
        self.flLastRemantTime = now
        -- 创建一个残影
        local cellCenter = GetRandomCellCenter()
        local remant = utilsCreatures.Create("npc_dota_creature_storm_spirit_remant", cellCenter)
        return 0.3
    end

    -- 买活之后才会执行以下操作
    if GameRules.nStormSpiritBuybackCount > 0 then

        -- 如果魔法量大于500，那么进行一次滚动
        -- 往玩家方向，距离1200的滚动
        -- 两次滚动之间至少间隔3秒
        if self.flLastBallLightingTime == nil then
            self.flLastBallLightingTime = now - 2
        end
        if now - self.flLastBallLightingTime > 3 then
            local ballLightingAbility = self:FindAbilityByName("storm_spirit_ball_lightning")
            local randomEnemy = AIUtil:RandomPlayerHero()
            if randomEnemy then
                local targetPos = self:GetOrigin() + (randomEnemy:GetOrigin() - self:GetOrigin()):Normalized() * 1200
                self:CastAbilityOnPosition(targetPos, ballLightingAbility, -1)
                return 1
            end
        end

        if self.flLastChargeBallTime == nil then
            self.flLastChargeBallTime = now - 4
        end
        if now - self.flLastChargeBallTime > 20 then
            self.flLastChargeBallTime = now

            -- 毎过20秒，刷新N个闪电球，往蓝猫方向滚动
            -- 初始为3个，每次增加1个，最多6个
            if self.nChargeBallCount == nil then
                self.nChargeBallCount = 3
            end

            for i = 1, self.nChargeBallCount do
                local ballPosition = GetRandomCellCenter()
                local origin = self:GetOrigin()
                while (ballPosition - origin):Length2D() < 1200 do
                    ballPosition = GetRandomCellCenter()
                end

                local direction = (origin - ballPosition):Normalized()

                -- 创建一个Projectile
                local chargeBallAbility = self:FindAbilityByName("storm_spirit_charge_ball")
                local info = {
                    EffectName = "particles/creatures/boss_yyf/storm_spirit_charge_ball.vpcf", -- todo chargeball effect
                    Ability = chargeBallAbility,
                    vSpawnOrigin = origin,
                    Source = self,
                    fDistance = 1500,
                    fStartRadius = 64,
                    fEndRadius = 64,
                    bHasFrontalCone = false,
                    bReplaceExisting = false,
                    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
                    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
                    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                    fExpireTime = GameRules:GetGameTime() + 10.0,
                    vVelocity = direction * 600,
                }

                local projectile = ProjectileManager:CreateLinearProjectile(info)
            end

            self:AddNewModifier(self, nil, "modifier_rooted", { Duration = 5 })
            return 5
        end
    end

    -- 随机选择一种方式进行攻击
    local randomAttackMethod = table.random({
        stormSpiritAttack1,
        stormSpiritAttack2,
        stormSpiritAttack3,
        stormSpiritAttack4,
    })
    --print("storm is thinking")
    return randomAttackMethod(self)
end

npc_dota_creature_storm_spirit1 = npc_dota_creature_storm_spirit
npc_dota_creature_storm_spirit2 = npc_dota_creature_storm_spirit
npc_dota_creature_storm_spirit3 = npc_dota_creature_storm_spirit

---------------------------------------------------------------------------------------------------------
---AI 残影——蓝猫召唤的残影
---------------------------------------------------------------------------------------------------------
function npc_dota_creature_storm_spirit_remant(self)
    if not IsValidAlive(self) then
        GameRules.nYYFRemantCount = GameRules.nYYFRemantCount - 1
        ParticleManager:DestroyParticle(self.nStaticRemantParticle, false)
        self.nStaticRemantParticle = nil
        return
    end

    if not self.nStaticRemantParticle then
        self.nStaticRemantParticle = ParticleManager:CreateParticle("particles/creatures/boss_yyf/stormspirit_remant_effect.vpcf", PATTACH_WORLDORIGIN, self)
        ParticleManager:SetParticleControl(self.nStaticRemantParticle, 0, self:GetOrigin())
    end

    local now = GameRules:GetGameTime()

    -- 往玩家方向发射3个子弹
    CreatureAttack({
        source = self,
        effectName = "particles/creatures/boss_yyf/storm_spirit_attack_linear.vpcf",
        startSound = "Hero_StormSpirit.Attack",
        targetPos = AIUtil:RandomPlayerHero():GetOrigin(),
        speed = 400,
    })

    return RandomFloat(1.2, 1.8)
end
---------------------------------------------------------------------------------------------------------
---AI 风酒仙
---------------------------------------------------------------------------------------------------------
function npc_dota_creature_brewmaster_wind(self)
    if not IsValidAlive(self) then
        GameRules.vYYFSpiritKilledSquence = GameRules.vYYFSpiritKilledSquence or {}
        if not table.contains(GameRules.vYYFSpiritKilledSquence, "wind") then
            table.insert(GameRules.vYYFSpiritKilledSquence, "wind")
        end
        return nil
    end
    local now = GameRules:GetGameTime()

    if self.flLastWindTime == nil then
        self.flLastWindTime = now - BREWMASTER_WIND_INTERVAL + BREWMASTER_FIRST_WIND
    end
    if now - self.flLastWindTime >= getAbilityIntervalViration(BREWMASTER_WIND_INTERVAL) then
        self.flLastWindTime = now
        -- WIND!
    end

    return 0.1
end
---------------------------------------------------------------------------------------------------------
---AI 火焰酒仙
---------------------------------------------------------------------------------------------------------
function npc_dota_creature_brewmaster_fire(self)
    if not IsValidAlive(self) then
        GameRules.vYYFSpiritKilledSquence = GameRules.vYYFSpiritKilledSquence or {}
        if not table.contains(GameRules.vYYFSpiritKilledSquence, "fire") then
            table.insert(GameRules.vYYFSpiritKilledSquence, "fire")
        end
        return nil
    end
    local now = GameRules:GetGameTime()
    if self.flLastFireTime == nil then
        self.flLastFireTime = now - BREWMASTER_FIRE_PROJECTILE_INTERVAL + BREWMASTER_FIRST_FIRE_PROJECTILE
    end
    if now - self.flLastFireTime >= getAbilityIntervalViration(BREWMASTER_FIRE_PROJECTILE_INTERVAL) then
        self.flLastFireTime = now
        -- FIRE!
    end
    return 0.1
end
---------------------------------------------------------------------------------------------------------
---AI 大地酒仙
---------------------------------------------------------------------------------------------------------
function npc_dota_creature_brewmaster_earth(self)
    if not IsValidAlive(self) then
        GameRules.vYYFSpiritKilledSquence = GameRules.vYYFSpiritKilledSquence or {}
        if not table.contains(GameRules.vYYFSpiritKilledSquence, "earth") then
            table.insert(GameRules.vYYFSpiritKilledSquence, "earth")
        end
        return nil
    end
    local now = GameRules:GetGameTime()
    if self.flLastEarthTime == nil then
        self.flLastEarthTime = now - BREWMASTER_EARTH_SPLIT_INTERVAL + BREWMASTER_FIRST_EARTH_SPLIT
    end
    if now - self.flLastEarthTime >= getAbilityIntervalViration(BREWMASTER_EARTH_SPLIT_INTERVAL) then
        self.flLastEarthTime = now
        -- EARTH!
    end
    return 0.1
end
---------------------------------------------------------------------------------------------------------
---AI 胖头鱼
---------------------------------------------------------------------------------------------------------
function npc_dota_creature_slardar(self)
    if not IsValidAlive(self) then
        GameRules.bYYFRoomFinished = true
        return
    end

    GameRules.gamemode:GetCurrentRoom().hBossHealthBarUnit = self

    if not self.bDataSet or self.nChargeSpeedBonus == nil then
        self.bDataSet = true
        local wind_index = table.findkey(GameRules.vYYFSpiritKilledSquence, "wind") - 2
        local fire_index = table.findkey(GameRules.vYYFSpiritKilledSquence, "fire") - 2
        local earth_index = table.findkey(GameRules.vYYFSpiritKilledSquence, "earth") - 2
        self.nChargeSpeedBonus = SLARDAR_CHARGE_SPEED_BONUS + (2 ^ wind_index) * SLARDAR_CHARGE_SPEED_BONUS_EXTRA
        self.flSunstrikeDelay = SLARDAR_SUNSTRIKE_DELAY + (2 ^ fire_index) * SLARDAR_SUNSTRIKE_DELAY_REDUCE
        self.nProjectileSpeed = SLARDAR_PROJECTILE_SPEED + (2 ^ earth_index) * SLARDAR_PROJECTILE_SPEED_BONUS
    end

    if not self.nChargeSpeedBonus then
        return 0.03
    end

    local now = GameRules:GetGameTime()

    --高等级天火
    --boss_speech_slardar_i_have_high_level_sun_strike

    if self.flLastSunstrikeTime == nil then
        self.flLastSunstrikeTime = now - SLARDAR_SUNSTRIKE_INTERVAL + SLARDAR_FIRST_SUNSTRIKE_TIME
    end

    if now - self.flLastSunstrikeTime >= SLARDAR_SUNSTRIKE_INTERVAL then
        self.flLastSunstrikeTime = now
        utilsBubbles.Show(self, "#boss_speech_slardar_i_have_high_level_sun_strike", 3)

        local enemy = AIUtil:RandomPlayerHero()
        EmitSoundOnLocationForAllies(Vector(0, 0, 0), "Hero_Invoker.SunStrike.Charge", enemy)

        if self.nSunstrikeBonus == nil then
            self.nSunstrikeBonus = 0
        end
        self.nSunstrikeBonus = self.nSunstrikeBonus + 3
        if self.nSunstrikeBonus > 30 then
            self.nSunstrikeBonus = 30
        end
        local sunStrikePositions = table.random_some(GetAllCellCenters(), 50 + self.nSunstrikeBonus)
        for _, pos in pairs(sunStrikePositions) do
            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_WORLDORIGIN, nil )
            ParticleManager:SetParticleControl( nFXIndex, 0, pos)
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 50, 1, 1 ) )
            ParticleManager:ReleaseParticleIndex( nFXIndex )
        end
        Timer(self.flSunstrikeDelay, function()
            EmitSoundOn("Hero_Invoker.SunStrike.Ignite", self)
            for _, pos in pairs(sunStrikePositions) do
                local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_WORLDORIGIN, nil)
                ParticleManager:SetParticleControl(effect, 0, pos)
                ParticleManager:ReleaseParticleIndex(effect)

                local heroes = AIUtil:AllPlayerHero()
                for _, hero in pairs(heroes) do
                    local origin = hero:GetOrigin()
                    local x, y = GetCellCoordAtPosition(pos)
                    if IsPositionInCell(origin, x, y) then
                        utilsDamage.DealDamageConstant(self, hero, 200, nil)
                    end
                end
            end
        end)
        return 2
    end

    --boss_speech_slardar_rua
    -- 召唤一大波小僵尸冲锋
    --连续10波，毎波8个

    if self.flLastLittleZombieTime == nil then
        self.flLastLittleZombieTime = now - SLARDAR_LITTLE_ZOMBIE_SUMMON_INTERVAL + SLARDAR_FIRST_LITTLE_ZOMBIE_TIME
    end
    if now - self.flLastLittleZombieTime > SLARDAR_LITTLE_ZOMBIE_SUMMON_INTERVAL then
        self.flLastLittleZombieTime = now
        utilsBubbles.Show(self, "#boss_speech_slardar_very_anxious_very_critical", 5)
        for i = 1, 6 do
            Timer(i * 0.4, function()
                local rand = table.random_some({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 }, 5)
                for _, y in pairs(rand) do
                    local little_zombie = utilsCreatures.Create("npc_dota_creature_slardar_little_zombie", GetCellCenterAtCoord(1, y))
                    Timer(0.1, function()
                        little_zombie:StartGesture(ACT_DOTA_RUN)
                        local targetPos = GetCellCenterAtCoord(21, y)
                        utilsCreatures.Leap(little_zombie, targetPos, 20, 800)
                        Timer(0.03, function()
                            if (little_zombie:GetOrigin() - targetPos):Length2D() < 32 then
                                little_zombie:SetOrigin(Vector(9999, 9999, 0))
                                little_zombie:ForceKill(false)
                                return nil
                            end
                            --little_zombie:SetForwardVector(Vector(1,0,0))
                            return 0.03
                        end)
                    end)
                end
            end)
        end
        return 6 * 0.4 + 2
    end


    --boss_speech_slardar_very_anxious_very_critical
    if self.flLastChargeTime == nil then
        self.flLastChargeTime = now - SLARDAR_CHARGE_INTERVAL + SLARDAR_FIRST_CHARGE_TIME
    end
    if now - self.flLastChargeTime > SLARDAR_CHARGE_INTERVAL then

        -- 往玩家的方向冲锋，连续3次
        local length = 1200
        local speed = 1500
        local chargeCount = 3

        for i = 1, chargeCount do
            utilsBubbles.Show(self, "#boss_speech_slardar_rua", length / speed)
            Timer((length / speed + 0.2) * (i - 1), function()
                local enemy = AIUtil:RandomPlayerHero()
                local eo = enemy:GetOrigin()
                local so = self:GetOrigin()
                local dir = (eo - so):Normalized()
                utilsCreatures.Leap(self, so + dir * length, 0, speed, "particles/units/heroes/hero_slardar/slardar_sprint.vpcf")
            end)
        end
        return (length / speed + 0.2) * chargeCount
    end

    return 0.03
end

