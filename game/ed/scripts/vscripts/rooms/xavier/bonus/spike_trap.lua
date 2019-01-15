local Room           = class({}, nil, EDRoom)

Room.IsPlayable      = true

Room.UniqueName      = "BonusSpikeTrap"

Room.SupportPlayers  = { 1, 2, 3, 4 }

Room.RoomType        = RoomType.Bonus

Room._nWeight        = 100

Room.SpecificPropMap = "spike_trap_lul"

function Room:constructor(room)
    self.room    = room
    self.hHuskar = nil
end

function Room:OnPrepare()
    if not self.bItemSpawned then
        self.bItemSpawned = true

        -- 在允许出生的位置刷N个物品
        -- 3-5个
        local positions = GetRandomSpawnPositions(RandomInt(3,5))
        for _, pos in pairs(positions) do
            -- 每个随机，金币80%，炸弹10%，钥匙10%
            local rand = table.random_with_weight({
                {item = "item_coin", Weight = 80},    
                {item = "item_bomb", Weight = 10},    
                {item = "item_key", Weight = 10},    
            })
            item = rand.item
            -- 极低的概率出现rotk
            if RollPercentage(0.1) then
                item = "item_rotk"
            end

            utilsBonus.DropLootItem(item, pos)
        end
    end
end

function Room:CheckFinish()
    return true
end

function Room:OnEnter()
end

function Room:OnExit()
end



return Room