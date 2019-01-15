GameRules.__vTimerNameTable__ = GameRules.__vTimerNameTable__ or {}
function Timer(delay, callback)
    if callback == nil then
        callback = delay -- 省略了为0的delay参数
        delay = 0
    end

    local timerName = DoUniqueString("timer")

    GameRules:GetGameModeEntity():SetContextThink(timerName,function()
        if GameRules.__vTimerNameTable__[timerName] then
            return callback()
        else
            return nil
        end
    end,delay)

    GameRules.__vTimerNameTable__[timerName] = true

    return timerName
end

function RemoveTimer(timerName)
    GameRules.__vTimerNameTable__[timerName] = nil
end

function ShowError(msg, player_id)
    Notifications:Bottom(PlayerResource:GetPlayer(player_id), { text = msg, duration = 1, style = { color = "red", ["font-size"] = "40px", border = "0px" } })
end

function IncreaseModifierStack(caster, target, ability, modififerName, maxStack)
    local modifier = target:FindModifierByName(modififerName)
    if not modifier then
        target:AddNewModifier(caster, ability, modififerName, {})
        modifier = target:FindModifierByName(modififerName)
    end
    local stackCount = target:GetModifierStackCount(modififerName, caster)
    stackCount       = math.min(maxStack or 999, stackCount + 1)
    target:SetModifierStackCount(modififerName, caster, stackCount)
    if modifier then
        modifier:ForceRefresh()
    end
end

function GetPlayerHero(nPlayerID)
    local player = PlayerResource:GetPlayer(nPlayerID)
    if player then
        return player:GetAssignedHero()
    end
end

-- 根据覆盖关系，获取物品的key
function GetItemKVKey(itemName, key)
    local result
    local kv_item_data = GameRules.Items_KV[itemName] or GameRules.DotaItems_KV[itemName]
    if kv_item_data then
        result = kv_item_data[key]
    end
    if GameRules.OverrideAbility_KV[item] and GameRules.OverrideAbility_KV[item][key] then
        result = GameRules.OverrideAbility_KV[item][key]
    end
    return result
end

function IsValidAlive(entity)
    return entity and IsValidEntity(entity) and entity:IsAlive()
end

-- 击退
function Knockback(caster, target, center, distance, height, duration, should_stun)
    -- local pos1 = origin + direction * 10
    local knockback_data = {
        should_stun        = should_stun,
        knockback_duration = duration,
        duration           = duration,
        distance           = distance,
        knockback_height   = height,
        center_x           = center.x,
        center_y           = center.y,
        center_z           = center.z
    }
    target:AddNewModifier(caster, ability, "modifier_knockback", knockback_data)
end

function RoundOff(num, n)
    n = n or 0
    if n > 0 then
        local scale = math.pow(10, n - 1)
        return math.floor(num / scale + 0.5) * scale
    elseif n < 0 then
        local scale = math.pow(10, n)
        return math.floor(num / scale + 0.5) * scale
    elseif n == 0 then
        return num
    end
end

---在一个数字前面补0
---这是简单写法，最多支持10位就够了
---@param num number
---@param length number
function ZFill(num, length)
    local strNum = "000000000" .. tostring(num)
    return string.sub(strNum, -length, -1)
end

if GameRules then
    return
end

math.randomseed(tostring(os.time()):reverse():sub(1, 7))

function RandomInt(min, max)
    return math.random(min, max)
end

function RandomFloat(min, max)
    return min + math.random() * (max - min)
end