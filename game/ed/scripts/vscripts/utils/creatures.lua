utilsCreatures = {}

function utilsCreatures.Leap(creature, targetPos, height, speed)
    creature:AddNewModifier(creature, nil, "modifier_creature_leap", {
        target_x = targetPos.x,
        target_y = targetPos.y,
        target_z = targetPos.z,
        speed = speed,
        height = height
    })
end

-- 和leap的区别是，这个modifier不会把单位的面向转向目标点位置
function utilsCreatures.CreatureKnockback(creature, targetPos, height, speed)
    creature:AddNewModifier(creature, nil, "modifier_creature_knockback", {
        target_x = targetPos.x,
        target_y = targetPos.y,
        target_z = targetPos.z,
        speed = speed,
        height = height
    })
end

function utilsCreatures.Create(name, pos)
    print("trying to create unit ", name)
    local unit = CreateUnitByName(name, pos, false, nil, nil, DOTA_TEAM_NEUTRALS)
    -- 加入碰撞伤害
    if GameRules.Units_KV[name] and GameRules.Units_KV[name].TouchDamage == 0 then
    else
        unit:AddNewModifier(unit, nil, "modifier_touch_damage", {})
    end

    unit.__bDisplayDamage__ = true

    unit:AddNewModifier(unit, nil, "modifier_phased", {Duration = 0.03})

    return unit
end

function utilsCreatures.CreateAsync(name, pos, callback)
    CreateUnitByNameAsync(name, pos, false, nil, nil, DOTA_TEAM_NEUTRALS, function(_unit)
        if callback then callback(_unit) end

        -- 加入碰撞伤害
        if GameRules.Units_KV[name] and GameRules.Units_KV[name].TouchDamage == 0 then
        else
            _unit.__bDisplayDamage__ = true
            _unit:AddNewModifier(_unit, nil, "modifier_touch_damage", {})
        end
        _unit:AddNewModifier(unit, nil, "modifier_phased", {Duration = 0.03})
    end)
end

-- 用来给KV调用的创建单位的接口，必须使用这个接口来创建敌方单位
function CreateEnemyKV(keys)
    local name = keys.UnitName
    local pos = keys.caster:GetOrigin()
    local unitCount = keys.UnitCount or 1
    local spawnRadius = keys.SpawnRadius or 50

    if keys.target_points then
        pos = keys.target_points[1]
    end

    for i = 1, unitCount do
        utilsCreatures.Create(name, pos + RandomVector(spawnRadius))
    end
end