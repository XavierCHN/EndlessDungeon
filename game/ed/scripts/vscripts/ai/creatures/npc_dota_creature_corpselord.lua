module("AIThink", package.seeall)


---@param thisEntity CDOTA_BaseNPC_Creature
function npc_dota_creature_corpselord(thisEntity)
    if not IsValidAlive(thisEntity) then return nil end

    local s_SummonUndead = thisEntity:FindAbilityByName("creature_summon_undead")


    if not thisEntity.bInitialized then
        thisEntity.bInitialized = true
        s_SummonUndead:StartCooldown(RandomFloat(1,3))
    end

    if s_SummonUndead and s_SummonUndead:IsFullyCastable() then
        thisEntity:CastAbilityNoTarget(s_SummonUndead, -1)
        return s_SummonUndead:GetChannelTime() + 1
    end

    return GenericMeleeAIThink(thisEntity)
end