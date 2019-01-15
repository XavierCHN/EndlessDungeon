require 'couriers._utils'

local couriers = {
    -- "donkey", -- 1
    "bearzky", -- 1
    "babyroshan", -- 1
    "drodo", -- 1
    "gold_greevil", -- 1
    "beaver_knight", -- 9
    -- "winter_wyvern", -- 1
    -- "frog", -- 1
    -- "minipudge", -- 1
    -- "juggernaut_dog", -- 8
}

GameRules.AllCouriers = {}

local data = {}

for _, file in pairs(couriers) do
    local d = {}
    local courier = require("couriers." .. file)
    GameRules.AllCouriers[file] = courier
    d.cost_g = courier.cost_g
    d.cost_p = courier.cost_p
    d.ability = courier.passive
    d.name = file
    table.insert(data, d)
end

-- 客户端显示多少信使，是由这个talbe决定的
CustomNetTables:SetTableValue("couriers_data", "couriers_data", data)