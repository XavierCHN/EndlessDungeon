function OnShadowRaze(keys)
    local caster               = keys.caster
    local forward              = caster:GetForwardVector()
    local shadow_raze_distance = 200
    local shadow_raze_point    = caster:GetAbsOrigin() + forward * shadow_raze_distance

    local shadow_raze_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(shadow_raze_particle, 0, shadow_raze_point)
    ParticleManager:ReleaseParticleIndex(shadow_raze_particle)

    EmitSoundOnLocationWithCaster(shadow_raze_point, "Hero_Nevermore.Shadowraze", caster)

    local units = FindUnitsInRadius(caster:GetTeamNumber(), shadow_raze_point, nil, 275, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
    for _, unit in pairs(units) do
        if unit:GetUnitName() == "npc_dota_creature_huskar" then
            ApplyDamage({
                            attacker     = caster,
                            victim       = unit,
                            damage       = 100,
                            damage_type  = DAMAGE_TYPE_PURE,
                            damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY,
                            ability      = keys.ability,
                        })

        end
    end

end

