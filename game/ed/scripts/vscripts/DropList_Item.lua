-- 物品掉落的机制重做
-- 各种等级的物品在各层的掉落概率
--  等级 = {l1,l2,l3,l4,l5,l6,l7}
local l1 = { 60, 20, 10, 05, 05, 00, 00 }
local l2 = { 30, 50, 10, 05, 05, 00, 00 }
local l3 = { 10, 25, 40, 15, 05, 05, 00 }
local l4 = { 05, 10, 25, 40, 15, 05, 05 }
local l5 = { 00, 05, 10, 25, 40, 15, 05 }
local l6 = { 00, 00, 05, 10, 25, 40, 15 }
local l7 = { 00, 00, 00, 05, 15, 25, 45 }

-- 这个是最常规的物品掉落表
-- 如果没有其他任何要求，那么就会按照这个表中的物品的概率进行掉落
-- 物品售价影响的是玩家的金币数量能否购买一个物品
-- 和这里是相互独立的两个系统
DROPPABLE_ITEM_DEFINATION = {
    --===================================================
    -- 自定义的物品
    --===================================================
    item_rotk = { 30, 30, 30, 30, 30, 30, 30 },
    item_family_issue = { 30, 30, 30, 30, 30, 30, 30 },
    item_tatical_pause = { 30, 30, 30, 30, 30, 30, 30 },
    item_water = { 30, 30, 30, 30, 30, 30, 30 },
    item_em = { 30, 30, 30, 30, 30, 30, 30 },

    --===================================================
    -- DOTA中的物品
    --===================================================
    item_ed_aegis = l3,
    item_cheese = l6,
    --=====================================================
    --     "consumables"
    --=====================================================
    -- item_clarity = l1, -- 
    -- item_faerie_fire = l1, -- 
    -- item_enchanted_mango = l1, -- 
    -- item_tango = l1, -- 
    -- item_flask = l1, -- 
    -- item_smoke_of_deceit = l1, -- 
    -- item_tpscroll = l1, -- 
    -- item_dust = l1, -- 
    -- item_courier = l1, -- 
    -- item_flying_courier = l1, -- 
    -- item_ward_observer = l1, -- 
    -- item_ward_sentry = l1, -- 
    -- item_tome_of_knowledge = l1, -- 
    -- item_bottle = l1, -- 
    --=====================================================
    -- "attributes"
    --=====================================================
    item_branches = l1, -- 树枝
    item_gauntlets = l2, -- 力量手套
    item_slippers = l2, -- 敏捷便鞋
    item_mantle = l2, -- 智力斗篷
    item_circlet = l2, -- 圆环
    item_belt_of_strength = l2, -- 力量腰带
    item_boots_of_elves = l2, -- 精灵布带
    item_robe = l2, -- 法师长袍
    item_ogre_axe = l3, -- 食人魔之斧
    item_blade_of_alacrity = l3, -- 欢欣之刃
    item_staff_of_wizardry = l3, -- 魔力法杖
    --=====================================================
    -- "weapons_armor"
    --=====================================================
    item_ring_of_protection = l1, -- 守护指环
    item_stout_shield = l1, -- 圆盾
    item_quelling_blade = l2, -- 补刀斧
    item_infused_raindrop = l1, -- 凝魂之泪
    item_blight_stone = l2, -- 枯萎之石
    item_orb_of_venom = l1, -- 淬毒之珠
    item_blades_of_attack = l1, -- 攻击之爪
    item_chainmail = l1, -- 锁子甲
    item_quarterstaff = l2, -- 短棍
    item_helm_of_iron_will = l2, -- 铁艺头盔
    item_broadsword = l3, -- 阔剑
    item_claymore = l3, -- 大剑
    item_javelin = l3, -- 标枪
    item_mithril_hammer = l3, -- 秘银锤
    --=====================================================
    -- "misc"
    --=====================================================
    item_wind_lace = l1, -- 风灵之纹
    -- item_magic_stick = l1, -- 魔棒
    item_sobi_mask = l1, -- 艺人面罩
    -- item_ring_of_regen = l1, -- 回复戒指
    item_boots = l2, --  速度之靴
    item_gloves = l2, --  加速手套
    item_cloak = l2, -- 抗魔斗篷
    -- item_ring_of_health = l1, -- 治疗之环
    -- item_void_stone = l1, -- 虚无宝石
    -- item_gem = l1, -- 真视宝石
    -- item_lifesteal = l1, -- 吸血面具
    -- item_shadow_amulet = l1, -- 暗影护符
    -- item_ghost = l1, -- 幽魂权杖
    -- item_blink = l1, -- 闪烁匕首
    --=====================================================   
    -- // Level 1 - Green Recipes
    -- "basics"
    --=====================================================       
    -- item_magic_wand = l1, -- 魔棒
    item_null_talisman = l2, -- 无用挂件
    item_wraith_band = l2, -- 怨灵细带
    item_poor_mans_shield = l2, -- 穷鬼盾
    item_bracer = l2, -- 护腕
    -- item_soul_ring = l1, -- 灵魂之戒
    item_phase_boots = l3, -- 相位鞋
    item_power_treads = l3, -- 假腿
    item_oblivion_staff = l4, -- 空明杖
    -- item_pers = l1, -- 坚韧球
    -- item_hand_of_midas = l1, -- 迈达斯之手
    item_travel_boots = l4, -- 远行鞋
    item_moon_shard = l5, -- 银月之晶
    --=====================================================
    -- // Level 2 - Blue Recipes
    -- "support"
    --=====================================================
    item_ring_of_basilius = l2, -- 王者之戒
    item_iron_talon = l2, -- 寒铁钢爪
    -- item_headdress = l1, -- 回复头巾
    item_buckler = l3, -- 玄冥盾牌
    -- item_urn_of_shadows = l1, -- 影之灵龛
    -- item_tranquil_boots = l1, -- 静谧之鞋
    item_ring_of_aquila = l1, -- 天鹰戒
    item_medallion_of_courage = l3, -- 勇气勋章
    item_arcane_boots = l2, -- 秘法鞋
    item_ancient_janggo = l3, -- 战鼓
    -- item_mekansm = l1, -- 梅肯斯姆
    -- item_vladmir = l1, -- 祭品
    -- item_pipe = l1, -- 洞察烟斗
    -- item_guardian_greaves = l1, -- 卫士胫甲
    --=====================================================
    -- "magics"            
    --=====================================================
    -- item_glimmer_cape = l1, -- 微光披风
    -- item_force_staff = l1, -- 推推棒
    -- item_veil_of_discord = l1, -- 纷争面纱
    -- item_aether_lens = l1, -- 以太之镜
    -- item_necronomicon = l1, -- 小人书
    -- item_dagon = l1, -- 大根
    -- item_cyclone = l1, -- 吹风
    item_solar_crest = l4, -- 炎阳纹章
    item_rod_of_atos = l3, -- 阿托斯之棍
    item_orchid = l4, -- 紫怨
    item_ultimate_scepter = l5, -- 蓝杖
    -- item_refresher = l1, -- 刷新球
    -- item_sheepstick = l1, -- 羊刀
    -- item_octarine_core = l6, -- 玲珑心
    --=====================================================
    -- "defense"
    --=====================================================
    -- item_hood_of_defiance = l1, -- 挑战头巾
    -- item_vanguard = l1, -- 先锋盾
    item_blade_mail = l4, -- 刃甲
    item_soul_booster = l3, -- 镇魂石
    -- item_crimson_guard = l1, -- 赤红家
    item_black_king_bar = l5, -- BKB
    -- item_lotus_orb = l1, --莲花
    item_shivas_guard = l6, -- 西瓦守护
    -- item_bloodstone = l1, -- 血精石 
    -- item_manta = l1, -- 幻影斧
    -- item_sphere = l1, -- 林肯
    -- item_hurricane_pike = l1, -- 飓风长戟 
    item_assault = l6, -- 强袭胸甲
    -- item_heart = l1, -- 龙心 
    --=====================================================
    -- "weapons"
    --=====================================================   
    item_lesser_crit = l4, -- 水晶剑
    -- item_armlet = l1, -- 臂章
    -- item_invis_sword = l1, -- 隐刀
    item_basher = l4, -- 碎骨锤
    -- item_bfury = l1, -- 狂战斧
    item_ethereal_blade = l5, -- 虚灵之刃
    -- item_silver_edge = l1, -- 大隐刀 
    item_radiance = l5, --  辉耀
    item_monkey_king_bar = l5, -- 金箍棒
    item_greater_crit = l6, -- 大炮
    item_butterfly = l6, -- 蝴蝶
    item_rapier = l7, -- 圣剑 
    -- item_abyssal_blade = l1, -- 深渊之刃
    item_bloodthorn = l6, -- 血辣
    --=====================================================
    -- // Level 4 - Orange / Orb / Artifacts               
    -- "artifacts"
    --=====================================================   
    -- item_mask_of_madness = l1, -- 疯狂面具
    -- item_helm_of_the_dominator = l1, -- 支配头盔
    -- item_dragon_lance = l1, -- 魔龙枪
    item_sange = l4, -- 散华
    item_yasha = l4, -- 夜叉
    -- item_echo_sabre = l1, -- 回音战刃
    item_maelstrom = l4, -- 旋涡
    item_diffusal_blade = l3, -- 净魂之刃
    item_desolator = l4, -- 暗灭
    -- item_heavens_halberd = l1, -- 天堂之戟
    item_sange_and_yasha = l5, -- 双刀
    item_skadi = l5, -- 冰眼
    item_mjollnir = l6, -- 大雷锤
    -- item_satanic = l1, -- 撒旦
    --=====================================================
    -- "sideshop1"
    --=====================================================
    -- item_tpscroll = l1, -- 
    -- item_magic_stick = l1, -- 
    -- item_orb_of_venom = l1, -- 
    -- item_sobi_mask = l1, -- 
    -- item_ring_of_regen = l1, -- 
    -- item_boots = l1, -- 
    -- item_cloak = l1, -- 
    -- item_ring_of_health = l1, -- 
    item_void_stone = l1, -- 虚无宝石
    -- item_lifesteal = l1, -- 
    -- item_helm_of_iron_will = l1, -- 
    item_energy_booster = l2, -- 能量之球
    -- item_broadsword = l1, -- 阔剑
    --=====================================================
    -- "sideshop2"
    --=====================================================
    -- item_stout_shield = l1, -- 
    -- item_quelling_blade = l1, -- 
    -- item_blades_of_attack = l1, -- 
    -- item_boots_of_elves = l1, -- 
    -- item_belt_of_strength = l1, -- 
    -- item_robe = l1, -- 
    -- item_gloves = l1, -- 
    -- item_chainmail = l1, -- 
    -- item_bottle = l1, -- 
    -- item_quarterstaff = l1, -- 
    item_vitality_booster = l2, -- 活力之球 
    -- item_blink = l1, -- 
    --=====================================================
    -- "secretshop"
    --=====================================================                           
    item_point_booster = l3, -- 
    item_platemail = l2, -- 板甲
    item_talisman_of_evasion = l3, -- 闪避护肤
    item_hyperstone = l3, -- 振奋宝石
    item_ultimate_orb = l2, -- 精气之球
    item_demon_edge = l3, -- 恶魔之锋
    -- item_mystic_staff = l1, -- 神秘法杖
    item_reaver = l4, -- 大斧子
    item_eagle = l4, -- 角鹰弓
    item_relic = l4, -- 圣者遗物

}

function GetRandomDropItem()
	local level = GameRules.gamemode:GetCurrentLevel()
    local randomTable = {}
    for itemname, dropTable in pairs(DROPPABLE_ITEM_DEFINATION) do
        table.insert(randomTable, {
            item = itemname,
            Weight = dropTable[level]
        })
    end

    return table.random_with_weight(randomTable).item
end
