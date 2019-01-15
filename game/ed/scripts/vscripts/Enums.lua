_G.PropDefination                              = {
    [01] = "prop_random_rock", -- 随机石头
    [02] = "prop_static_rock", -- 固定石头
    [03] = "prop_spikes", -- 尖刺
    [04] = "prop_spike_trap", -- 尖刺陷阱
    [05] = "prop_barrel" , -- 木桶
    [06] = "prop_barrel_empty", -- 空木桶
    [07] = "prop_barking_dog", -- 喷火陷阱
    [08] = "prop_hooded_fang", -- 剧毒陷阱
    [09] = "prop_chest", -- 宝箱
    [10] = "prop_chest_box", -- 方箱子
    [11] = "prop_chest_golden", -- 金箱子
    -- 其他待定
}

_G.RoomType                                    = {}
RoomType.Invalid                               = - 1  -- 不可用
RoomType.Start                                 = 0     -- 起始点
RoomType.Normal                                = 1    -- 普通房间
RoomType.Bonus                                 = 2     -- 奖励房间
RoomType.SemiBoss                              = 3  -- 小BOSS房间
RoomType.FinalBoss                             = 4 -- 最终BOSS房间
RoomType.Hidden                                = 5 -- 隐藏房间（特殊奖励）
RoomType.Shop                                  = 6 -- 商店房间
RoomType.Arcade                                = 7 -- 小游戏房间
RoomType.PropsOnly                             = 8 -- 小游戏房间
RoomType.Bank                                  = 9 -- 银行
RoomType.Challenage                            = 10 -- 挑战
RoomType.Cursed                                = 11 -- 受诅咒的房间
RoomType.Item = 12 -- 物品房，房间中间有一个物品

_G.Directions                                  = {}
Directions.up                                  = { 0, 1 }
Directions.down                                = { 0, - 1 }
Directions.right                               = { 1, 0 }
Directions.left                               = { -1, 0 }

EnumsLoaded                                    = true

