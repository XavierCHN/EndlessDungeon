module ("AIThink", package.seeall)

function npc_dota_creature_broodking(thisEntity)

    if not IsValidAlive(thisEntity) then
        local web = Entities:FindByClassname( nil, "npc_dota_broodmother_web" )
        while web do
            local thisWeb = web
            web           = Entities:FindByClassname( web, "npc_dota_broodmother_web" )
            thisWeb:ForceKill( false )
        end
        return nil
    end

    -- local now = GameRules:GetGameTime()

    -- -- 停止做事
    if thisEntity.b_HatchingEgg then
        thisEntity:Stop()
        return 0.03
    end

    local ABILITY_spawn_eggs = thisEntity:FindAbilityByName("creature_spawn_broodmother_eggs")
    local ABILITY_spin_web   = thisEntity:FindAbilityByName("creature_spin_web")

    -- 如果能放蛋，那么放蛋，然后孵蛋5秒
    if ABILITY_spawn_eggs and ABILITY_spawn_eggs:IsFullyCastable() then
        thisEntity:CastAbilityNoTarget(ABILITY_spawn_eggs, - 1)

        thisEntity.b_HatchingEgg = true

        EmitAnnouncerSound("broodmother_broo_ability_spawn_0" .. RandomInt(2, 6))

        local pid = ParticleManager:CreateParticle("particles/creatures/creature_broodking/broodking_hatching.vpcf", PATTACH_ABSORIGIN_FOLLOW, thisEntity)
        ParticleManager:SetParticleControlEnt(pid, 0, thisEntity, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", thisEntity:GetOrigin(), false)
        Timer(10, function()
            thisEntity.b_HatchingEgg = false
            ParticleManager:DestroyParticle(pid, true)
            ParticleManager:ReleaseParticleIndex(pid)
        end)
        return ABILITY_spawn_eggs:GetCastPoint()
    end

    -- 如果能放网就放网
    if ABILITY_spin_web and ABILITY_spin_web:IsFullyCastable() and not thisEntity.b_CastingWeb then
        thisEntity.b_CastingWeb = true
        thisEntity:CastAbilityOnPosition( GetRandomCellCenter(), ABILITY_spin_web, - 1 )
        EmitAnnouncerSound("broodmother_broo_ability_spin_0" .. RandomInt(1, 6))
    end

    -- 正在前去放网的路上
    if thisEntity.b_CastingWeb then
        if ABILITY_spin_web:IsFullyCastable() then
            return 0.03
        else
            thisEntity.b_CastingWeb = false
        end
    end

    return AIThink.GenericMeleeAIThink(thisEntity)
end