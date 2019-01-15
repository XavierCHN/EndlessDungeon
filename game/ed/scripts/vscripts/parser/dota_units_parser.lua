do return end -- disable this!

local seperators = {
	"Ability1", "ArmorPhysical", "AttackCapabilities", "BountyXP", "BoundsHullName",
	"MovementCapabilities", "StatusHealth", "VisionDaytimeRange",
}

local all_possible_classes = {
	"npc_dota_creep_neutral",
	"npc_dota_creep_lane",
	"npc_dota_creep",
}

local ignore_units = {
	"npc_dota_neutral_mud_golem_split_doom",

}

local unit_value_table_melee = {}
local unit_value_table_ranged = {}

local function save_unit(unit, unit_name)

	if not table.contains(ignore_units, unit_name) then

		unit.BaseClass = "npc_dota_creature"
		-- 计算这个生物的战斗力
		-- 一般来说，我们不考虑这个生物的技能
		-- 只计算他的攻击力乘以血量
		local health = unit.StatusHealth
		local damage = (unit.AttackDamageMin + unit.AttackDamageMax) / 2

		-- 把所有的怪物导出
		if unit.AttackCapabilities == "DOTA_UNIT_CAP_RANGED_ATTACK" then
			table.insert(unit_value_table_ranged, {name = unit_name, value = health * damage, health = health, damage = damage})
		else
			table.insert(unit_value_table_melee, {name = unit_name, value = health * damage, health = health, damage = damage})
		end

		-- 修正攻击力
		unit.AttackDamageMin = tonumber(unit.AttackDamageMin)
		unit.AttackDamageMax = tonumber(unit.AttackDamageMax)
		unit.MovementSpeed = math.floor(tonumber(unit.MovementSpeed))

		-- 注意顺序！
		local unit_keys = {
			"BaseClass",
			"Model",
			"SoundSet",
			"ModelScale",
			"Level",
			"Ability1",
			"Ability2",
			"Ability3",
			"Ability4",
			"Ability5",
			"Ability6",
			"Ability7",
			"Ability8",
			"ArmorPhysical",
			"MagicalResistance",
			"AttackCapabilities",
			"AttackDamageMin",
			"AttackDamageMax",
			"AttackDamageType",
			"AttackRate",
			"AttackAnimationPoint",
			"AttackAcquisitionRange",
			"AttackRange",
			"BountyXP",
			"BountyGoldMin",
			"BountyGoldMax",
			"BoundsHullName",
			"HealthBarOffset",
			"MovementCapabilities",
			"MovementSpeed",
			"MovementTurnRate",
			"StatusHealth",
			"StatusHealthRegen",
			"StatusMana",
			"StatusManaRegen",
			"VisionDaytimeRange",
			"VisionNighttimeRange",
		}

		local file = io.open("../../dota_addons/ed/scripts/npc/creatures/dota_imported/" .. unit_name .. "_ed.txt", "w")
		file:write("\"DOTAUnits\"\n{\n")
		file:write("\t\"" .. unit_name .. "_ed\"\n\t{\n")
		
		-- 写入弹道模型，但是先注释掉，如果有必要的单位，再给他们添加特殊的弹道
		if unit.ProjectileModel then
			file:write(string.format("\t\t//\"ProjectileModel\"\t\t\"%s\"\n", string.gsub(unit.ProjectileModel, ".vpcf", "_ed.vpcf")))
		end

		for i = 1, #unit_keys do
			local key = unit_keys[i]

			if table.contains(seperators, key) then
				file:write("\n\t\t// " .. key .. "\n")
				file:write("\t\t//========================================================================\n\n")
			end

			if unit[key] then
				file:write(string.format("\t\t\"%s\"\t\t\"%s\"\n", key, unit[key]))
				unit[key] = nil
			end
		end


		file:write("\t}\n")
		file:write("}\n")
		file:flush()
		file:close()
	end
end

-- 写入独立的文件
local all_dota_units = LoadKeyValues("scripts/npc/npc_units.txt")
local all_unit_names = {}
for unit_name, unit in pairs(all_dota_units) do
	-- print("trying to load", unit_name)
	if type(unit) == 'table' then
		if table.contains(all_possible_classes, unit.BaseClass) then
			save_unit(unit,unit_name)
			table.insert(all_unit_names, unit_name)
			--print("saving unit", unit_name)
		end
	end
end

-- 写入载入的文件
local file = io.open("../../dota_addons/ed/scripts/npc/dota_imported_units.txt", "w")
for _, name in pairs(all_unit_names) do
	file:write("#base creatures/dota_imported/" .. name .. "_ed.txt\n")
end

file:flush()
file:close()

table.sort(unit_value_table_melee, function(a, b) return a.value < b.value end)
table.sort(unit_value_table_ranged, function(a, b) return a.value < b.value end)
local dota_imported_lua_file = io.open("../../dota_addons/ed/scripts/vscripts/rooms/dota_imported_definations.lua", "w")
dota_imported_lua_file:write("melee = {\n")
for k,v in pairs(unit_value_table_melee) do
	dota_imported_lua_file:write(string.format("\t[%d] = \"%s_ed\", -- %s H %s D %s\n", k, v.name, v.value, v.health, v.damage))
end
dota_imported_lua_file:write("}\n\n\n")
dota_imported_lua_file:write("ranged = {\n")
for k,v in pairs(unit_value_table_ranged) do
	dota_imported_lua_file:write(string.format("\t[%d] = \"%s_ed\", -- %s H %s D %s\n", k, v.name, v.value, v.health, v.damage))
end
dota_imported_lua_file:write("}\n\n\n")
dota_imported_lua_file:flush()
dota_imported_lua_file:close()
-- -- 均分成7份
-- local dota_imported_lua_file = io.open("../../dota_addons/ed/scripts/vscripts/rooms/dota_imported_definations.lua", "w")
-- local unit_per_level = math.floor(table.count(unit_v) / 7)
-- for i = 1, 7 do
-- 	-- print(unit_per_level)
	
-- 	local unit_names = {}
-- 	for j = 1, unit_per_level do
-- 		local index = (i-1) * unit_per_level + j
-- 		local unit = unit_v[index]
-- 		table.insert(unit_names, "\"" .. unit.name .. "\"")
-- 	end
-- 	dota_imported_lua_file:write(string.format("DOTAImported[%d] = {\n%s\n}\n", i, table.concat(unit_names, ",\n")))
-- end

-- for i = 7 * unit_per_level + 1, table.count(unit_v) do
-- 	local unit = unit_v[i]
-- 	dota_imported_lua_file:write(string.format("table.insert(DOTAImported[7], \"%s\"", unit.name))
-- end

-- dota_imported_lua_file:flush()
-- dota_imported_lua_file:close()