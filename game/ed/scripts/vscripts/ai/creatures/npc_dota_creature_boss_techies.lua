module("AIThink", package.seeall) -- 所有的AI文件都用这一行开头，复制粘贴即可

function npc_dota_creature_boss_techies(thisEntity)
    if not IsValidAlive(thisEntity) then
        return
    end

    if thisEntity:HasModifier("modifier_creature_techies_suicide_leap") then
        return 0.1
    end

    -- 能放炸弹就放炸弹

    local s_PlantBomb = thisEntity:FindAbilityByName("techies_plant_bomb")

    if s_PlantBomb and s_PlantBomb:IsFullyCastable() then
        EmitAnnouncerSound("techies_tech_setmine_" .. string.format("%02d", RandomInt(1, 45)))
        thisEntity:CastAbilityNoTarget(s_PlantBomb, - 1)
        return 0.5
    end

    -- 能放自爆就放自爆
    local s_SuicideLeap = thisEntity:FindAbilityByName("creature_techies_suicide")
    if s_SuicideLeap and s_SuicideLeap:IsFullyCastable() then
        local enemy = AIUtil:RandomPlayerHeroInRange(thisEntity, 1000)
        if enemy then
            EmitAnnouncerSound("techies_tech_suicidesquad_" .. string.format("%02d", RandomInt(1, 13)))
            thisEntity:CastAbilityOnPosition(enemy:GetOrigin(), s_SuicideLeap, - 1)
            return s_SuicideLeap:GetCastPoint() + 0.3
        end
    end

    -- 往随机目标地点移动
    if thisEntity.vCurrentTargetPosition == nil then
        thisEntity.vCurrentTargetPosition = GameRules.gamemode:GetCurrentRoom():GetRandomSpawnPosition()
        DebugDrawCircle(thisEntity.vCurrentTargetPosition, Vector(255, 0, 0), 255, 100, false, 5)
    end

    local origin = thisEntity:GetOrigin()
    if (origin - thisEntity.vCurrentTargetPosition):Length2D() < 128 then
        thisEntity.vCurrentTargetPosition = nil
        return 0.1
    else
        thisEntity:MoveToPosition(thisEntity.vCurrentTargetPosition)
        return 0.1
    end

    return 0.1

end