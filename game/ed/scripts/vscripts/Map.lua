-- 用来生成一张随机地图
-- 
-- XavierCHN

if not class then require 'utils.class' end

---@class Map
if Map == nil then Map = class({}) end -- 地图

-- 随机生成一张地图
-- size 地图的尺寸（总共的房间数）
function Map:constructor(size)

	local size
	local level = GameRules.gamemode:GetCurrentLevel()
	if level <= 8 then
		size = RandomInt(NORMAL_ROOM_COUNT[level].min, NORMAL_ROOM_COUNT[level].max)
	else
		size = RandomInt(6, 12)
	end

	self._nNormalRoomCount = size

	local possibleCoords = table.shallowcopy(Directions)

	self.rooms = {[0] = {}}
	self.rooms[0][0] = Room(0, 0, RoomType.Start) -- 生成开始的房间


	-- 需要穿插的额外房间
	-- 1. 每一层至少有1个商店房间
	-- 2. 每一层有40%的概率出现小游戏房间
	-- 3. 每一层有20%的概率出现银行房间
	-- 4. 每一层有size/4的props only房，这个房间里面除了props
	--    没有其他的东西，就只是一个过渡
	local extraRooms = {}

	local itemRoomCount = math.normal_distribution(1, 1.3, 1, 5)
	for i = 1, itemRoomCount do
		table.insert(extraRooms, RoomType.Item)
	end
	if RollPercentage(20) then
		table.insert(extraRooms, RoomType.Shop)
	end

	if RollPercentage(20) then
		table.insert(extraRooms, RoomType.Arcade)
	end
	if RollPercentage(20) then
		table.insert(extraRooms, RoomType.Bank)
	end
	for i = 1, math.floor(size / 4) do
		table.insert(extraRooms, RoomType.PropsOnly)
	end

	local totalRoomsToGenerate = size + #extraRooms

	for i = 1, totalRoomsToGenerate do
		local chosen, idx = table.random(possibleCoords)
		possibleCoords[idx] = nil -- 生成之后将这个房间移除
		local x, y = chosen[1], chosen[2]

		for _, m in pairs(Directions) do
			local mx, my = m[1], m[2]
			if not self:_RoomHasAlreadyExists(x + mx, y + my) then
				table.insert(possibleCoords, {x + mx, y + my})
			end
		end

		self.rooms[x] = self.rooms[x] or {}

		-- 如果剩余的房间数量大于额外房间的剩余数量，那么随机
		-- 如果小于等于了，强制为额外房间
		local _roomType = RoomType.Normal
		local roll = RollPercentage((#extraRooms / (totalRoomsToGenerate - i)) * 100)
		-- print(#extraRooms, i, totalRoomsToGenerate, (#extraRooms / totalRoomsToGenerate - i) * 100, roll)
		if totalRoomsToGenerate - i < #extraRooms or roll then
			local typ, key = table.random(extraRooms)
			_roomType = table.remove(extraRooms, key)
		end
		self.rooms[x][y] = Room(chosen[1], chosen[2], _roomType)
		--print(string.format("[Map] generating room: [%02d,%02d] %d", chosen[1], chosen[2], _roomType))
	end

	-- 优先保证大BOSS房间必须存在
	-- 大BOSS房间固定1个，只与一个相连
	local someRooms = self:_FindEmptyPossibleRooms(possibleCoords)
	local possibleFinalBossRooms = {}
	for _, room in pairs(someRooms) do
		if room[2] == 1 then
			table.insert(possibleFinalBossRooms, room[1])
		end
	end
	local coord = table.random(possibleFinalBossRooms)
	self.rooms[coord[1]] = self.rooms[coord[1]] or {}
	self.rooms[coord[1]][coord[2]] = Room(coord[1], coord[2], RoomType.FinalBoss)

	-- 小BOSS房间
	if RollPercentage(SEMI_BOSS_ROOM_CHANCE) then
		local someRooms = self:_FindEmptyPossibleRooms(possibleCoords)
		local possibleSemiBossRoom = {}
		for _, room in pairs(someRooms) do
			if room[2] == 1 then
				table.insert(possibleSemiBossRoom, room[1])
			end
		end
		if table.count(possibleSemiBossRoom) > 0 then
			local coord = table.random(possibleSemiBossRoom)
			self.rooms[coord[1]] = self.rooms[coord[1]] or {}
			self.rooms[coord[1]][coord[2]] = Room(coord[1], coord[2], RoomType.SemiBoss)
		end
	end

	-- 隐藏房间，毎一层一个，只与一个房间相连
	local someRooms = self:_FindEmptyPossibleRooms(possibleCoords)
	local possibleHiddenRooms = {}
	for _, room in pairs(someRooms) do
		if room[2] == 1 then
			table.insert(possibleHiddenRooms, room[1])
		end
	end
	if table.count(possibleHiddenRooms) > 0 then
		local coord = table.random(possibleHiddenRooms)
		self.rooms[coord[1]] = self.rooms[coord[1]] or {}
		self.rooms[coord[1]][coord[2]] = Room(coord[1], coord[2], RoomType.Hidden)
	end

	-- 生成奖励房间（这个房间是有概率出现的）
	local chance = GameRules.nBonusRoomAppearChance or BONUS_ROOM_CHANCE
	if RollPercentage(chance) then
		local someRooms = self:_FindEmptyPossibleRooms(possibleCoords)
		local possibleHiddenRooms = {}
		for _, room in pairs(someRooms) do
			if room[2] == 1 then
				table.insert(possibleHiddenRooms, room[1])
			end
		end
		if table.count(possibleHiddenRooms) > 0 then
			local coord = table.random(possibleHiddenRooms)
			self.rooms[coord[1]] = self.rooms[coord[1]] or {}
			self.rooms[coord[1]][coord[2]] = Room(coord[1], coord[2], RoomType.Bonus)
		end
	end

	-- 计算所有房间的数量
	local totalRoomCount = 0
	for x, _d in pairs(self.rooms) do
		for y, room in pairs(_d) do
			totalRoomCount = totalRoomCount + 1
		end
	end
	self._nTotalRoomCount = totalRoomCount

	self:_ShowRoomMessage()

	-- 所有的房间的初始化（做生成门，选择房间实体等操作）
	for _, room in pairs(self:GetAllRooms()) do
		room:Initialize(self)
	end

	self:SendMapMessageToClient()
end

function Map:SendMapMessageToClient()
	-- 房间的信息，为了发送到客户端
	local roomMessageForClient = {}

	-- 计算所有房间的数量
	local totalRoomCount = 0
	for _, room in pairs(self:GetAllRooms()) do
		local roomType = room:GetRoomType()
		local visited = room:IsVisited()
		if roomType == RoomType.Hidden and not visited then
		else
			local roomMsg = {
				x = room.x,
				y = room.y,
				roomType = roomType,
				visited = visited,
			}
			table.insert(roomMessageForClient, roomMsg)
		end
	end

	-- 发送信息到客户端
	CustomNetTables:SetTableValue("map_data","all_rooms_data",roomMessageForClient)
end

function Map:GetAllRooms()
	local r = {}
	for x, _d in pairs(self.rooms) do
		for y, room in pairs(_d) do
			table.insert(r, room)
		end
	end
	return r
end

function Map:_ShowRoomMessage()
	-- 打印生成的房间信息

	if not IsInToolsMode() then return end

	print("Current level is ->", GameRules.gamemode:GetCurrentLevel())

	local ix, iy, mx, my = 0, 0, 0, 0
	for x, rooms in pairs(self.rooms) do
		for y, _ in pairs(rooms) do
			if x < ix then ix = x end
			if x > mx then mx = x end
			if y < iy then iy = y end
			if y > my then my = y end
		end
	end
	for y = my, iy, -1 do
		local line = ""
		for x = ix, mx do
			if self:_RoomHasAlreadyExists(x,y) then
				line = line .. self.rooms[x][y]:GetRoomType()
			else
				line = line .. "-"
			end
		end
		print(line)
	end
end

function Map:GetRoomAtCoord(x, y)
	if self.rooms[x] then return self.rooms[x][y] end
end

function Map:GetStartRoom()
	return self.rooms[0][0]
end

function Map:_RoomHasAlreadyExists(x, y)
	return self.rooms[x] and self.rooms[x][y]
end

function Map:_FindEmptyPossibleRooms(possibleCoords)
	-- 在地图中寻找所有可以成为房间的点

	local result = {}
	for _, coord in pairs(possibleCoords) do
		local x, y = coord[1], coord[2]
		if not self:_RoomHasAlreadyExists(x, y) then
			local count = 0
			for _, m in pairs(Directions) do
				local mx, my = m[1], m[2]
				if self:_RoomHasAlreadyExists(x + mx, y + my) then
					count = count + 1
				end
			end
			table.insert(result, {coord, count}) -- 返回房间的序号和与这个房间相连的房间数
		end
	end

	return result
end

function Map:FindRoomAtCoord(x, y)
	if self.rooms[x] then
		return self.rooms[x][y]
	end
end

function Map:GetTotalRoomCount()
	return self._nTotalRoomCount
end