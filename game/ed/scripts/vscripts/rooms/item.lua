local Room = class({}, nil, EDRoom)

Room.UniqueName = "Item"

Room.RoomType = RoomType.Item

Room.IsPlayable = true

Room.SupportPlayers = {}
for i = 1, 100 do
	table.insert(Room.SupportPlayers, i)
end

function Room:OnPrepare()
	-- 在房间中间创建一个物品

    local item = GetRandomDropItem()
	utilsBonus.DropLootItem(item, GetCenter(), 0)
end

function Room:OnEnter()
end

function Room:CheckFinish()
	return true
end

function Room:OnExit()
end

return Room