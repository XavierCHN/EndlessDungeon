-- 生成一个出生N个随机生物的房间
-- unit table为一个定义了单位名称和数量的表
-- 如
--    {
-- unit1 = 3, -- 3个unit1
-- unit2 = 5, -- 5个unit2
-- unit3 = {3,7}, -- 随机3-7个unit3
-- }
-- lvlMin lvlMax 可选，这个房间可能出现的层数

local generatedIndex = 0

function CreateNormalUnitsRoom(unit_table, lvlMin, lvlMax, extraData)
	local room = class({}, nil, EDRoom)
	room.IsPlayable = "true"
	generatedIndex = generatedIndex + 1

    local onlyUnitName
	for unit_name, unit_count in pairs(unit_table) do
		room.UniqueName = unit_name .. "_" .. generatedIndex
        onlyUnitName = unit_name
    end
    if table.count(unit_table) == 1 then
        room.UniqueName = onlyUnitName
    end

    --print("Auto generating unique room ", room.UniqueName)

	function room:constructor()
		self.vEnemies = {}
	end

	function room:OnPrepare()
		-- 如果有双倍的玩家数量，那么就出生双倍的怪物
		local playerCount = GameRules.gamemode:GetPlayerCount()
		local unitSpawnLocationTable = {}
		for unit_name, unit_count in pairs(unit_table) do
			if type(unit_count) == "table" then
				unit_count = RandomInt(unit_count[1], unit_count[2])
			end
			for i = 1, unit_count do
				table.insert(unitSpawnLocationTable, {name = unit_name})
			end
		end

		-- 选定出生位置
		local cellCenters = GetRandomPositionsInRoom(table.count(unitSpawnLocationTable))
		for k,v in pairs(unitSpawnLocationTable) do
			v.spawnLocation = table.remove(cellCenters, 1)
		end

		-- 创建单位
		for _, data in pairs(unitSpawnLocationTable) do
			local unit = utilsCreatures.Create(data.name,data.spawnLocation)
			unit:AddNewModifier(nil,nil,"modifier_phased",{Duration = 0.1})
		end
	end

	function room:OnNpcSpawned(npc)
		if npc:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
            table.insert(self.vEnemies, npc)
        end
	end

	function room:CheckFinish()
		for _, enemy in pairs(self.vEnemies) do
			if IsValidAlive(enemy) then
				return false
			end
		end
		return true
	end

	room.SupportPlayers = {1,2}
	room.RoomType = RoomType.Normal
	if lvlMin and lvlMax then
		room.LevelRange = {lvlMin, lvlMax}
	end

    -- 其他数据
    if extraData then
        if extraData.Weight then
            room._nWeight = extraData.Weight
        end
    end

	return room
end