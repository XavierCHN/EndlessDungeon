module("AIThink", package.seeall) -- 所有的AI文件都用这一行开头，复制粘贴即可

function GenericMeleeAIThink(unit)

    if not IsValidAlive(unit) then
        return nil
    end

    -- 普通单位如果不给移动能力的，就没有AI了
    -- 如果实在需要，自己实现一个吧
    if not unit:HasMovementCapability() or unit:HasModifier("modifier_rooted") then
        return 0.1
    end

    -- 设置目标点位置
    if unit.__vTargetPosition == nil and not unit.__bChasingHero then
        if not IsValidAlive(unit.__vTarget) then
            unit.__vTarget = AIUtil:RandomPlayerHero()
        end

        -- 512范围内会直接攻击玩家，被玩家攻击的生物也会直接攻击玩家
        local origin = unit:GetOrigin()
        if not unit.__bDamagedByPlayer__ and (origin - unit.__vTarget:GetOrigin()):Length2D() > 512 then
            if RollPercentage(80) then
                unit.__vTargetPosition = origin + (unit.__vTarget:GetOrigin() - origin):Normalized() * 512
            else
                unit.__vTargetPosition = origin + RandomVector(512)
            end
        else
            unit:AddNewModifier(unit,nil,"modifier_melee_unit_movespeed_burster",{})
            unit.__vTargetPosition = origin + (unit.__vTarget:GetOrigin() - origin):Normalized() * 512
            unit.__bChasingHero = true
        end

        -- 移动到目标位置
        unit:MoveToPosition(unit.__vTargetPosition)

        unit.__flLastOrderTime = GameRules:GetGameTime()
    end

    local now = GameRules:GetGameTime()
    -- 重置目标位置
    if (not unit.__bChasingHero and (unit:GetOrigin() - unit.__vTargetPosition):Length2D() < 50)
    or (now - unit.__flLastOrderTime) > RandomFloat(1, 2) then
        unit.__bChasingHero = false
        unit.__vTargetPosition = nil
    end

    if not unit.__bChasingHero and (unit.__bDamagedByPlayer__ or AIUtil:RandomPlayerHeroInRange(unit, 512) ~= nil )then
        unit.__vTargetPosition = nil -- 如果最近受了伤害，那么直接重新选择一个目标
    end

    return RandomFloat(0.03, 0.2)
end