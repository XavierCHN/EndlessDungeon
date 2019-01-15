module("AIThink", package.seeall)

function GenericLycanWolfAIThink(thisEntity)
    if not IsValidAlive(thisEntity) then return nil end
    if not thisEntity:HasModifier("modifier_disarmed") then thisEntity:AddNewModifier(thisEntity, nil, "modifier_disarmed", {}) end

    -- 随机跳跃，速度和等级有关
    local level = GameRules.gamemode:GetCurrentLevel()
    local length = 768 + level * 64
    local height = 500
    local speed = 800 + level * 32

    local targetPos = GetRandomPosition()
    local selfOrigin = thisEntity:GetOrigin()

    -- 如果512范围内有敌方英雄，且上一次不是往敌方英雄方向跳跃，那么此次一定往英雄方向跳跃
    local enemy = AIUtil:RandomPlayerHeroInRange(thisEntity, length)

    if enemy and ((not thisEntity.__bLastTimeJumpToHero__) or RollPercentage(20)) then
        thisEntity.__bLastTimeJumpToHero__ = true
        targetPos = enemy:GetOrigin()
    end

    if thisEntity.__bLastTimeJumpToHero__ == true then
        thisEntity.__bLastTimeJumpToHero__ = false
    end

    --DebugDrawCircle(targetPos, Vector(0,0,0), 255, 128, false, 1)

    local direction = (targetPos - selfOrigin):Normalized()

    thisEntity:Stop()
    thisEntity:SetForwardVector(direction)
    thisEntity:ForcePlayActivityOnce(ACT_DOTA_RUN)

    Timer(0, function()
        utilsCreatures.Leap(thisEntity, selfOrigin + direction * length, height, speed)
    end)

    thisEntity:AddNewModifier(thisEntity, nil, "modifier_rooted", {Duration = 1})

    return length / speed + 1
end