function OnCallOfDragonOut(keys)
    local caster  = keys.caster
    local ability = keys.ability

    local point   = keys.target_points[1]

    local pid     = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_crit_tgt.vpcf", PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pid, 0, point)
    ParticleManager:SetParticleControl(pid, 1, point)
    ParticleManager:ReleaseParticleIndex(pid)

    EmitSoundOnLocationWithCaster(point, "Hero_Juggernaut.ArcanaTrigger", caster)

    local radius        = ability:GetSpecialValueFor("damage_radius")
    local damage_amount = ability:GetSpecialValueFor("damage_amount")

    Timer(0.4, function()
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for _, enemy in pairs(enemies) do
            utilsDamage.DealDamagePercentage(caster, enemy, damage_amount, ability)
        end
    end)
end

function OnCallOfDragonPrecast(keys)
    local caster = keys.caster

    -- todo 播放音效等等
    --EmitSoundOn("", caster)
end

