module ("AIThink", package.seeall)
function npc_dota_creature_broodmother(thisEntity)

    if thisEntity.ABILITY_spawn_spider == nil then
        thisEntity.ABILITY_spawn_spider = thisEntity:FindAbilityByName( "creature_spawn_spider" )
    end

    if not thisEntity:IsAlive() then
        return nil
    end

    -- Spawn a broodmother whenever we're able to do so.
    if thisEntity.ABILITY_spawn_spider:IsFullyCastable() then
        thisEntity:CastAbilityImmediately( thisEntity.ABILITY_spawn_spider, - 1 )
        return 1.0
    end

    return AIThink.GenericMeleeAIThink(thisEntity)
end