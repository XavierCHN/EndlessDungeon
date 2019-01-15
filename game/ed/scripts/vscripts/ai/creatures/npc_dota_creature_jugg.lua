module("AIThink", package.seeall) -- 所有的AI文件都用这一行开头，复制粘贴即可

function npc_dota_creature_jugg(thisEntity)

    if not IsValidAlive(thisEntity) then
        return nil
    end

    local s_CallOfDragon = thisEntity:FindAbilityByName("jugg_call_of_dragon")
    local s_FlyingBlade  = thisEntity:FindAbilityByName("jugg_flying_blade")
    local s_LinearBlade  = thisEntity:FindAbilityByName("jugg_linear_blade")

    if not thisEntity.bInitialized then
        thisEntity.bInitialized = true
        s_FlyingBlade:StartCooldown(10)
        s_LinearBlade:StartCooldown(1)
        s_CallOfDragon:StartCooldown(5)
    end

    -- 飞剑
    if s_FlyingBlade and s_FlyingBlade:IsFullyCastable() then
        thisEntity:CastAbilityNoTarget(s_FlyingBlade, - 1)
        return 2
    end
    -- 召唤神龙
    if s_CallOfDragon and s_CallOfDragon:IsFullyCastable() then
        local enemy = AIUtil:RandomPlayerHero()
        if enemy then
            local position = enemy:GetOrigin()
            thisEntity:CastAbilityOnPosition(position, s_CallOfDragon, - 1)
        end
        return 2
    end
    -- 线性剑
    if s_LinearBlade and s_LinearBlade:IsFullyCastable() then
        local enemy = AIUtil:RandomPlayerHero()
        if enemy then
            local position = enemy:GetOrigin() + RandomVector(400)
            thisEntity:CastAbilityOnPosition(position, s_LinearBlade, - 1)
            return 1
        end
    end

    return 0.03
end