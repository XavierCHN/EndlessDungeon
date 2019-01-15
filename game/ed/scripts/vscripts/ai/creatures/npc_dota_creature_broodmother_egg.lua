module("AIThink", package.seeall)

function npc_dota_creature_broodmother_egg(thisEntity)

    if not IsValidAlive(thisEntity) then
        local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_ABSORIGIN, thisEntity )
        ParticleManager:SetParticleControl( nFXIndex, 0, thisEntity:GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        return
    end

    ABILITY_hatch_broodmother = thisEntity:FindAbilityByName( "creature_hatch_broodmother")
    if thisEntity.flTimeToHatch == nil then
        thisEntity.flTimeToHatch = GameRules:GetGameTime() + ABILITY_hatch_broodmother:GetCooldown( 0 )
    end

    local now = GameRules:GetGameTime()

    if now < thisEntity.flTimeToHatch then
        return RandomFloat( 0.1, 0.3 )
    end

    ExecuteOrderFromTable({
                              UnitIndex    = thisEntity:entindex(),
                              OrderType    = DOTA_UNIT_ORDER_CAST_NO_TARGET,
                              AbilityIndex = ABILITY_hatch_broodmother:entindex()
                          })
end
