---@class AIUtil
_G.AIUtil = {}

function AIUtil:RandomPlayerHero()
    return table.random(GameRules.gamemode:GetAllHeroes())
end

function AIUtil:AllPlayerHero()
    return GameRules.gamemode:GetAllHeroes()
end

---RandomPlayerHeroInRange
---@param entity CDOTA_BaseNPC
---@param range number
function AIUtil:RandomPlayerHeroInRange(entity, range)
    local o = entity:GetOrigin()
    local r = {}
    for _, hero in pairs(GameRules.gamemode:GetAllHeroes()) do
        if (o - hero:GetOrigin()):Length2D() <= range then
            table.insert(r, hero)
        end
    end
    return table.random(r)
end

---ClosestPlayerHeroInRange
---@param entity CDOTA_BaseNPC
---@param range number
function AIUtil:ClosestPlayerHeroInRange( entity, range )
    local enemies   = GameRules.gamemode:GetAllHeroes()
    local min_range = 10000
    local idx
    for k, enemy in pairs(enemies) do
        local range = (enemy:GetOrigin() - entity:GetOrigin()):Length2D()
        if range < min_range then
            min_range = range
            idx       = k
        end
    end
    if idx then
        return enemies[idx]
    end
    return nil
end

---WeakestEnemyHeroInRange
---@param entity CDOTA_BaseNPC
---@param range number
function AIUtil:WeakestEnemyHeroInRange( entity, range )
    local enemies = GameRules.gamemode:GetAllHeroes()
    local minHP   = nil
    local target  = nil

    for _, enemy in pairs(enemies) do
        local distanceToEnemy = (entity:GetOrigin() - enemy:GetOrigin()):Length()
        local HP              = enemy:GetHealth()
        if enemy:IsAlive() and (minHP == nil or HP < minHP) and distanceToEnemy < range then
            minHP  = HP
            target = enemy
        end
    end

    return target
end

---FindUnitsByName
---@param name string
function AIUtil:FindUnitsByName(name)
    local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, GetRoomCenter(), nil, 8000, DOTA_UNIT_TARGET_TEAM_BOTH,
                                    DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
    local r     = {}
    for _, unit in pairs(units) do
        if unit:GetUnitName() == name then
            table.insert(r, unit)
        end
    end
    return r
end

---OrderToAttackNearestPlayerHero
---@param unit CDOTA_BaseNPC
function AIUtil:OrderToAttackNearestPlayerHero(unit)
    local enemy = AIUtil:ClosestPlayerHeroInRange(unit, 9999)
    if enemy then
        ExecuteOrderFromTable({
                                  UnitIndex = unit:entindex(),
                                  OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                                  Position  = enemy:GetOrigin(),
                              })
    end
end

function AIUtil:NearestEnemyInRange(unit, radius)
    radius = radius or 3000
    local units = FindUnitsInRadius(unit:GetTeamNumber(),unit:GetOrigin(),nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NONE,FIND_CLOSEST,false)
    for i = 1, table.count(units) do
        if not string.startswith(unit:GetUnitName(), "prop") then
            return units[i]
        end
    end
end