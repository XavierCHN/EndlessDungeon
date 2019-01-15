--[[
	Endless room defination file
	XavierCHN
	2017.2.,

	你需要自定义房间里面所有出现的东西，生物啊，粒子特效等等

	房间难度制作的要求：
	1. 难度一定要高！ 要折腾死人，最好加上点meme，2333
]]

EDRoom = class({})

-- 房间是否可用
-- 必须手动设置自己的房间为true之后，这个房间才会被引擎载入
-- A room must be set IsPlayable to true to be load to engine.
EDRoom.IsPlayable = false

-- 在测试环境中，默认所有房间都可用
-- In tools mode, all rooms will be loaded.
if IsInToolsMode() then
	EDRoom.IsPlayable = true
end

-- 房间的特殊名字
-- 如果你想要用debug_test_room roomname的指令的话，需要输入的就是roomname
-- the unique name of the room, if you want to load room via debug_test_room
-- you must input this name as the parameter
--     e.g debug_test_room YourUniqueIndentifier_MyRoomName
EDRoom.UniqueName = DoUniqueString("AnEDRoom")

-- 这个房间允许的玩家数量（根据载入的地图）
-- 这个table里面的就是可用的数值类型
-- How many players are supported of this room
-- the value maybe {1,5,10}
-- 
EDRoom.SupportPlayers = {0}

-- 一个房间出现的最大最小层数
-- 这个条件会在WeightInLevel之前满足
-- 如果这个房间的最大最小层数定义了
-- 那么哪怕权重返回了正值，那么房间也不会在这一层出现
-- EDRoom.LevelRange = {1,1}
EDRoom.LevelRange = {}

-- 这个房间所指定的地形
-- 写prop map的文件名
-- 如果定义了这个，那么这个房间将会载入指定的地形
-- 而无论房间类型是什么。也不会到所有地形库中去随机
EDRoom.SpecificPropMap = nil

-- 房间是否支持多次载入
-- 如果定义了这个数值，这个房间在载入了这个数值的次数之后，就再也不会出现了
-- 
EDRoom.MaxLoadTimes = nil

-- 房间的类型
-- 只有这种房间类型的可以载入这个房间
-- 如果你想要有某个房间支持多种房间类型，请新建一个文件之后
-- 再设置他的额外的RoomType
-- This parameter defines what kind of room can load this room instance
-- If you have some room that may support multiple kind of rooms
-- You will need to create a new file, deep copy this and change 
-- its RoomType to what you want.
-- _G.RoomType = {
-- 	Invalid = -1,  -- 不可用
-- 	Start = 0,     -- 起始点
-- 	Normal = 1,    -- 普通房间
-- 	Bonus = 2,     -- 奖励房间
-- 	SemiBoss = 3,  -- 小BOSS房间
-- 	FinalBoss = 4, -- 最终BOSS房间
-- 	Hidden = 5, -- 隐藏房间（特殊奖励）
-- }
EDRoom.RoomType = RoomType.InValid

-- 房间出现的概率（权重）在所有可能的房间中选择一个
-- 默认的room:GetWeight()将会获取这个数值
-- 当然你也可以重写GetWeight函数来实现动态的权重
-- 默认值为100，所有数值为100的房间将会有相同概率出现
-- How ofen does this room may appear, the GetWeight method will return this value
-- you can defined the weight by change this value
-- or override GetWeight method to define this dynamicly
-- this value is default to 100, and rooms with same type and 100 weight will
-- have the same chance to be loaded.
EDRoom._nWeight = 100

-- 房间可能使用的地形
function EDRoom:GetTerrainName()
	local terrainDefinationTable = TerrainDefination[self.UniqueName] or TerrainDefination.Default
	return table.random()
end

-- 房间的构造函数
-- room代表Room.lua中所定义的房间类
-- 储存这个数值用来在房间内调用相关函数
function EDRoom:constructor(room)
end

-- 当玩家第一次进入房间的时候
-- 你可以在这里完成怪物的刷新，奖励房间的物品首次掉落等
-- When player enter this room for the first time
-- 
function EDRoom:OnPrepare()
end

-- 当玩家进入某个房间
-- 如果有之前暂存的东西（例如已经打开/未打开的宝箱），需要重新载入
-- When player enter this room, this method will also be called 
-- right after OnPrepare()
function EDRoom:OnEnter()
end

-- 检查一个房间是否已经被完成
-- 如果这个函数返回过true之后，将不会再调用
-- 这个函数不允许默认返回false，避免出现什么意外情况导致玩家卡在某个房间
-- 你需要列举所有该房间尚未完成的可能情况来return false
-- Check this room is whether finished or not
-- This method will no longer be called for each room instance once returns true
-- This method is not allowed to return a false or nil value by default
-- You need to tell every possible condition what makes this room not finished
function EDRoom:CheckFinish()
	return true
end

-- 当一个房间被完成的时候，这个函数对于一个房间实例，只会被调用一次
-- 适合用来给予玩家奖励
-- 比如在地上创建宝箱之类的东西
-- When this room is finished, this method will also be called once right after CheckFinish returns true
-- You can give players bonus such as create a chest on the ground
function EDRoom:OnFinish()

end

-- 玩家退出这个房间后，清理房间的所有资源，还原到空房间的状态
-- When a player exit this room
-- you may need to clear everything happened 
-- you dont need to take care of dropped item or neutrals
-- all items will be stored temporaryly and restore when players reenter the room
-- all neutrals will be killed and will NOT be revived.
function EDRoom:OnExit()
end

-- 每当有一个生物在这个房间里面出生的时候
-- When an npc is spawned in this room
function EDRoom:OnNpcSpawned(npc)
end

-- 获取权重，你可以重写这个函数来自定义这个权重的属性
-- 也可以返回0，这样这个房间就不会被载入
-- or override GetWeight method to define this dynamicly
-- this value is default to 100, and rooms with same type and 100 weight will
-- have the same chance to be loaded.
-- if this method returns 0 or nil, this room will not be loaded
function EDRoom:GetWeight()
	return self._nWeight
end

-- 用来显示BOSS血量条的单位
-- BOSS房间的进度将会用这个东西返回的实体的血量来显示
-- 这个东西并不一定要返回BOSS，也可以返回其他的东西
-- 但是只要他是个单位，而且血量等于房间进度就可以
-- 默认返回 self.hBossHealthBarUnit 所以，只需要定义这个就可以了
-- 
function EDRoom:GetBossHealthBarEntity()
	return self.hBossHealthBarUnit
end

-- 你一定必须在房间文件的最后return这个房间类
-- 否则会loader将会无法正确运行
-- 你也必须在rooms/_loader.lua中填上到你房间类的路径
-- 否则不会被载入
-- You must return the room class at the eof
-- otherwise the loader will not run properly
-- you also need to insert path/to/your/room file in all_room_files table in rooms/_loader.lua
-- otherwise your file will not be loaded
return EDRoom