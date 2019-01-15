module("AIThink", package.seeall) -- 所有的AI文件都用这一行开头，复制粘贴即可

--- 这个AI会默认给远程单位添加bullet thinker，所以，所有的远程，如果使用了GenericRangedAIThink的话，就会默认从出生的时候开始攻击
function GenericRangedAIThink(thisEntity)

    if not IsValidAlive(thisEntity) then
        return nil
    end

    -- 普通单位如果不给移动能力的，就没有AI了
    -- 如果实在需要，自己实现一个吧
    if not thisEntity:HasMovementCapability() or thisEntity:HasModifier("modifier_rooted") then
        return 0.1
    end

    if thisEntity.__vTargetPosition == nil then
        if not IsValidAlive(thisEntity.__vTarget) then
            thisEntity.__vTarget = AIUtil:RandomPlayerHero()
        end

        local target_origin    = thisEntity.__vTarget:GetOrigin()
        local self_origin      = thisEntity:GetOrigin()
        local attack_range     = thisEntity:GetAttackRange()

        local direction        = (self_origin - target_origin):Normalized()
        local point            = target_origin + direction * (attack_range - 150)
        thisEntity.__vTargetPosition = point + RandomVector(768)
        thisEntity.__flLastOrderTime = GameRules:GetGameTime()

        thisEntity:MoveToPosition(thisEntity.__vTargetPosition)
    end

    local now = GameRules:GetGameTime()

    -- 目标位置的距离不小于攻击距离-100的话，那么就不移动
    if (thisEntity:GetOrigin() - thisEntity.__vTargetPosition):Length2D() < thisEntity:GetAttackRange() - 100
    or (now - thisEntity.__flLastOrderTime) > RandomFloat(2, 3) then
        thisEntity.__vTargetPosition = nil
        thisEntity:AddNewModifier(thisEntity,nil,"modifier_rooted",{Duration = 0.5})
    end

    -- 所有的远程单位，都可以间隔3-level * 0.2的时间发射一个FailSafeBullet
    local target = AIUtil:RandomPlayerHeroInRange(thisEntity, 1200)
    if target then
        local pos = target:GetOrigin()
        local level = GameRules.gamemode:GetCurrentLevel()
        local interval = math.max(1, 3 - level * 0.2)

        local now = GameRules:GetGameTime()
        thisEntity.flLastBulletAttackTime = thisEntity.flLastBulletAttackTime or (now + RandomFloat(0.1, 0.5))

        if now - thisEntity.flLastBulletAttackTime >= interval and not GameRules:IsGamePaused() then
            CreatureAttack({
                source = thisEntity,
                targetPos = pos,
                speed = math.min(600 + level * 100, 1100)
            })
            thisEntity.flLastBulletAttackTime = now
        end
    end

    return RandomFloat(0.03, 0.2)
end