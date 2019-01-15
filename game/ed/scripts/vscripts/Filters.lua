function CEDGameMode:DamageFilter(damageTable)
    if not damageTable.entindex_attacker_const and damageTable.entindex_victim_const then
        return
    end

    local attacker = EntIndexToHScript(damageTable.entindex_attacker_const)
    local victim = EntIndexToHScript(damageTable.entindex_victim_const)
    local damage = damageTable.damage

    if victim:GetTeamNumber() == DOTA_TEAM_GOODGUYS or
    (victim:GetTeamNumber() == DOTA_TEAM_NEUTRALS and victim.__bDisplayDamage__) then
        utilsPupups.ShowCriticalDamage(victim, math.floor(damage))
    end
    return true
end
