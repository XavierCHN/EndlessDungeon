module("AIThink", package.seeall)

function npc_dota_creature_clinkz(thisEntity)

    if not IsValidAlive(thisEntity) then
        return
    end

    if thisEntity.level == nil then
        thisEntity.level = 1
        return RandomFloat(1,2)
    end
    
    if thisEntity:IsChanneling() then
        return 0.1
    end

    if thisEntity:HasModifier("modifier_clinkz_fire_arrows_thinker") then
        return 0.1
    end

    local s_FireArrows = thisEntity:FindAbilityByName("clinkz_fire_arrows")
    if s_FireArrows:IsFullyCastable() then
        thisEntity:CastAbilityNoTarget(s_FireArrows, - 1)
        
        thisEntity.level = thisEntity.level + 1
        return 10
    end
    
    -- 三个弹道的攻击，并且随着时间的推移增加速度
    -- 
    local target = AIUtil:RandomPlayerHero()
    local pos = target:GetOrigin()
    local level = thisEntity.level
    CreatureAttack({
        source = thisEntity,
        effectName = "particles/creatures/clinkz/clinkz_searing_arrow.vpcf",
        targetPos = pos,
        speed = 800 + level * 100
    })
    pos = RotatePosition(thisEntity:GetOrigin(),QAngle(0, -30, 0), pos)
    CreatureAttack({
        source = thisEntity,
        effectName = "particles/creatures/clinkz/clinkz_searing_arrow.vpcf",
        targetPos = pos,
        speed = 800 + level * 100
    })
    pos = RotatePosition(thisEntity:GetOrigin(),QAngle(0, 60, 0), pos)
    CreatureAttack({
        source = thisEntity,
        effectName = "particles/creatures/clinkz/clinkz_searing_arrow.vpcf",
        targetPos = pos,
        speed = 800 + level * 100
    })
    return 2 - level * 0.1
end