module("AIThink", package.seeall)

-- 钢背兽的AI
-- 钢背兽会有两个形态，猪形态和牛形态，每损失10%血量切换一次形态
-- 猪形态的技能
-- 刚开始的时候不移动，释放八方向的子弹
-- 每次进入猪形态，就会刷新两个保安，向玩家方向发射超快速子弹
-- 保安死亡之后，进入暴走状态，在场地上向玩家方向进行快速冲撞
-- 每次冲撞结束5秒的时间释放八方向的子弹
-- 之后立即进行下一次冲撞

-- 牛形态
-- 进入牛形态的时候，在所有冲撞路径上释放沟壑（最多8条），被沟壑命中的玩家会损失30%血量
-- 往玩家所在的方向进行图腾跳跃，图腾跳跃结束之后释放八方向沟壑
-- 跳跃结束之后5秒的时间8方向子弹

local STATE_PIG = 1
local STATE_CATTLE = 2
local ATTACK_INTERVAL = 0.5
local TOTEM_JUMP_INTERVAL = 10

local CIRCLE_BULLET_TIMES = 3
local CIRCLE_BULLET_COUNT = 10
local CIRCLE_BULLET_DURATION = 7
local CIRCLE_BULLET_INTERVAL = 0.8

GameRules.CreatureAttackCallback = GameRules.CreatureAttackCallback or {}

function GameRules.CreatureAttackCallback.BristlebackGoAndStop(ability, location, data)
    local data = table.shallowcopy(data)
    local attackCount = data.attackCount + 1
    if attackCount < 8 then
        local direction = Vector(data.directionX, data.directionY, data.directionZ)
        direction = RotatePosition(Vector(0, 0, 0), QAngle(0, -18, 0), direction)
        data.source = ability:GetCaster()
        data.sourcePos = location
        data.targetPos = location + direction
        data.attackCount = attackCount
        data.directionX = direction.x
        data.directionY = direction.y
        data.directionZ = direction.z
        CreatureAttack(data)
    end
end

local function onEnterStatePig(self)
    -- 进入猪形态，释放一团鼻涕在地上
    EmitAnnouncerSound("bristleback_bristle_spawn_01")
    self.hGooAbility = self.hGooAbility or self:FindAbilityByName("bristleback_goo")
    self:CastAbilityOnTarget(AIUtil:RandomPlayerHero(), self.hGooAbility, -1)
end

local function pigStateThink(self)
    --猪形态

    local now = GameRules:GetGameTime()
    local origin = self:GetOrigin()

    self.flLastCircleBulletTime = self.flLastCircleBulletTime or now - (CIRCLE_BULLET_INTERVAL + CIRCLE_BULLET_DURATION)

    if now - self.flLastCircleBulletTime >= CIRCLE_BULLET_DURATION then
        self.flLastCircleBulletTime = now

        -- 一圈10个走走停停的弹道
        local function createACircleBullet(circleBulletCount)
            self.flLastCircleBulletTime = now
            for i = 1, circleBulletCount do
                local direction = RotatePosition(Vector(0, 0, 0), QAngle(0, -360 / circleBulletCount * i, 0), Vector(10, 0, 0))
                Timer(CIRCLE_BULLET_INTERVAL / circleBulletCount * i, function()
                    CreatureAttack({
                        source = self,
                        targetPos = origin + direction,
                        effectName = "particles/generic/fail_safe_attack.vpcf",
                        speed = 700,
                        length = 2300,
                    })
                end)
            end
        end

        for i = 1, CIRCLE_BULLET_TIMES do
            Timer(CIRCLE_BULLET_INTERVAL * (i - 1), function()
                createACircleBullet(CIRCLE_BULLET_COUNT)
            end)
        end

        return CIRCLE_BULLET_TIMES * CIRCLE_BULLET_INTERVAL + 0.2
    end

    local charge_length = 1800
    local charge_speed = 900

    if self.flLastChargeTime == nil then
        self.flLastChargeTime = now
    end

    if now - self.flLastChargeTime > CIRCLE_BULLET_TIMES * CIRCLE_BULLET_INTERVAL then

        EmitAnnouncerSound("spirit_breaker_spir_ability_charge_16")

        EmitSoundOn("Hero_Spirit_Breaker.ChargeOfDarkness", self)

        utilsCreatures.Leap(self,self:GetOrigin() + (AIUtil:RandomPlayerHero():GetOrigin() - self:GetOrigin()):Normalized() * charge_length,0, charge_speed)
        Timer(charge_length/charge_speed + 0.1, function()
            self:CastAbilityNoTarget(self.hSquillSprayAbility, -1)
        end)

        return charge_length/charge_speed + 0.15
    end

    return 0.03
end

local function onEnterStateCattle(self)
    -- 进入牛形态，释放一次回音击
    EmitAnnouncerSound("earthshaker_erth_spawn_01")
    Timer(1, function()
        self:CastAbilityNoTarget(self:FindAbilityByName("earthshaker_echo_slam"), -1)
    end)
end

local function cattleStateThink(self)
    -- 牛形态
    local now = GameRules:GetGameTime()
    local origin = self:GetOrigin()

    self.flLastSpeedchTime = self.flLastSpeedchTime or now
    if now - self.flLastSpeedchTime >= RandomFloat(4,6) then
        EmitAnnouncerSound("erth_attack_" .. ZFill(RandomFloat(1,8), 2))
    end

    ----------------------------------------------------------------------------------------------------------------
    -- 牛形态，图腾跳跃！
    ----------------------------------------------------------------------------------------------------------------
    self.flLastTotemJumpTime = self.flLastTotemJumpTime or now
    if now - self.flLastTotemJumpTime >= TOTEM_JUMP_INTERVAL then

        self.flLastTotemJumpTime = now
        self:CastAbilityOnPosition(AIUtil:RandomPlayerHero():GetOrigin(), self.hTotemAbility, -1)

        Timer(1.0, function()
            EmitAnnouncerSound("earthshaker_erth_ability_fissure_" .. ZFill(RandomInt(1, 11), 2))
        end)

        Timer(2, function()

            local firstDirection = Vector(800, 0, 0)
            local randomStartIndex = RandomInt(1, 8)
            for i = 0, 6 do
                Timer(0.1 * i, function()
                    local origin = self:GetOrigin()
                    local pos = RotatePosition(Vector(0, 0, 0), QAngle(0, -60 * (i + randomStartIndex), 0), firstDirection)
                    self:CastAbilityOnPosition(origin + pos, self.hFissureAbility, -1)
                end)
            end
        end)
        return 5
    end

    self.flLastAttackTime = self.flLastAttackTime or now
    if now - self.flLastAttackTime >= ATTACK_INTERVAL then
        self.flLastAttackTime = now
        AttackAt8Directions(self, origin + Vector(500, RandomFloat(-80, 80), 0), {
            speed = 700,
            length = 2200
        })
    end

    return 0.03
end

function npc_dota_creature_boss_bristleback(self)
    if not IsValidAlive(self) then
        return
    end

    if self.hTotemAbility == nil then
        self.hTotemAbility = self:FindAbilityByName("earthshaker_enchant_totem")
    end
    if self.hFissureAbility == nil then
        self.hFissureAbility = self:FindAbilityByName("earthshaker_fissure")
    end
    if self.hSquillSprayAbility == nil then
        self.hSquillSprayAbility = self:FindAbilityByName("bristleback_quill_spray")
    end


    local healthPercentage = self:GetHealthPercent()
    if
    (healthPercentage > 90) or
    (healthPercentage <= 80 and healthPercentage > 70) or
    (healthPercentage <= 60 and healthPercentage > 50) or
    (healthPercentage <= 40 and healthPercentage > 30) or
    (healthPercentage <= 20 and healthPercentage > 10) then

        -- 如果处于进入形态转换
        if self.nState ~= STATE_PIG then
            onEnterStatePig(self)
            self.nState = STATE_PIG
            return 0.03
        end
    end
    if
    (healthPercentage <= 90 and healthPercentage > 80) or
    (healthPercentage <= 70 and healthPercentage > 60) or
    (healthPercentage <= 50 and healthPercentage > 40) or
    (healthPercentage <= 30 and healthPercentage > 20) or
    (healthPercentage <= 10) then
        if self.nState ~= STATE_CATTLE then
            onEnterStateCattle(self)
            self.nState = STATE_CATTLE
            return 1.2
        end
    end

    if self.nState == STATE_PIG then
        return pigStateThink(self)
    end
    if self.nState == STATE_CATTLE then
        return cattleStateThink(self)
    end
end