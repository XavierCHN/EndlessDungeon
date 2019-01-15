module("AIThink", package.seeall)

function npc_dota_creature_huskar(thisEntity)

    if not IsValidAlive(thisEntity) then
        return
    end

    -- 设置当前的等级，用来处理技能当中的问题
    if thisEntity.nCurrentLevel == nil then
        thisEntity.nCurrentLevel = 1
        return RandomFloat(0.5, 1) -- 不要一进门就开始射
    end

    -- 释放毒奶不打断
    if thisEntity:HasModifier("modifier_huskar_poison_milk_channel") then
        -- print("has the modifier")
        return 0.03
    end

    local Ability_creature_huskar_burning_spear  = thisEntity:FindAbilityByName("creature_huskar_burning_spear")
    local Ability_creature_huskar_poison_milk    = thisEntity:FindAbilityByName("creature_huskar_poison_milk")
    local Ability_creature_huskar_inner_vatility = thisEntity:FindAbilityByName("creature_huskar_inner_vatility")

    --- 逻辑 毎20秒1次毒奶，转一圈
    --- 毎3秒一发火矛，冷却时间逐步降低到1.5秒（根据血量的多少）
    --- 在血量低于30%的时候，毎隔20秒释放一次回血，但是从那个时候开始移除无敌
    -- 所有技能的冷却时间都为0，我们都使用AI文件来控制循环时间

    if thisEntity:GetHealthPercent() < 30 then
        if thisEntity:HasAbility("creature_huskar_invulnerable") then
            thisEntity:RemoveAbility("creature_huskar_invulnerable")
        end
    end

    local now = GameRules:GetGameTime()
    thisEntity.flLastPoisonMilkTime = thisEntity.flLastPoisonMilkTime or now

    local poisonMilkInterval = math.max(9, 15 - thisEntity.nCurrentLevel * 0.5)

    if Ability_creature_huskar_poison_milk and Ability_creature_huskar_poison_milk:IsFullyCastable() 
        and now - thisEntity.flLastPoisonMilkTime >= poisonMilkInterval
        then
        thisEntity:CastAbilityNoTarget(Ability_creature_huskar_poison_milk, -1)
        thisEntity.nCurrentLevel = thisEntity.nCurrentLevel + 1
        thisEntity.flLastPoisonMilkTime = now
        -- print("trying to poison milk")
        -- Ability_creature_huskar_poison_milk:StartCooldown(15-thisEntity.nCurrentLevel)
        return 4
    end

    local enemy = AIUtil:RandomPlayerHero()
    -- 一支指向敌方玩家，其他N支随意指向
    CreatureAttack({
        source = thisEntity,
        effectName = "particles/creatures/boss_huskar/huskar_attack.vpcf",
        targetPos = enemy:GetOrigin(),
        speed = 500 + thisEntity.nCurrentLevel * 100
    })
    local spearCount = 0
    Timer(function()
        CreatureAttack({
            source = thisEntity,
            effectName = "particles/creatures/boss_huskar/huskar_attack.vpcf",
            targetPos = thisEntity:GetOrigin() + RandomVector(20),
            speed = 500 + thisEntity.nCurrentLevel * 100,
            startSound = "Hero_Huskar.PreAttack",
            endSound = "Hero_Huskar.PreAttack",
        })
        spearCount = spearCount + 1
        if spearCount >= thisEntity.nCurrentLevel + 5 then return nil end
        return 0.1
    end)

    return 2 - thisEntity.nCurrentLevel * 0.1
end