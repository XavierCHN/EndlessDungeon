local Room = class({}, nil, EDRoom)

Room.UniqueName = "Standard.Normal"

Room.RoomType = RoomType.Normal

-- Room.SupportPlayers = {1,5,10}
-- 支持1-100人
Room.SupportPlayers = {}
for i = 1, 100 do
	table.insert(Room.SupportPlayers, i)
end

-- 玩家进入房间前的准备阶段，从空房间加载所有这个房间的资源
-- 所有房间的房门之类的信息都将会由核心代码加载，不需要额外处理
function Room:OnPrepare()
	--print "Creating standard normal room"
	-- 开始房间，显示战斗提示信息吗？
	-- 还是不显示了
end

function Room:OnEnter()
	--print "Entering standard normal room"
end

function Room:CheckFinish()
	-- 不需要做出任何操作，默认已经完成
	-- 进入房间将会默认锁定传送操作，直到房间完成后，才再开放门
	--
	return true
end

function Room:OnExit()
	print "Exiting standard normal room"
end

return Room