utilsBonus = {}

local auto_use_items = {
    "item_coin",
}

-- 掉落物品
function utilsBonus.DropLootItem(itemname, position, radius)
    --print("creating item ", itemname)
    local newItem = CreateItem(itemname, nil, nil)

    if not newItem then 
        print("ERROR: FAILED TO CREATE ITEM!!!!!")
        return 
    end

    newItem:SetPurchaseTime(0)
    radius = radius or 0
    local drop       = CreateItemOnPositionSync(position, newItem)
    local dropTarget = position + RandomVector(RandomFloat(0, radius))
    local autouse    = false

    -- 黑心
    if itemname == "item_heart_black" then
        drop:SetRenderColor(0,0,0)
    end

    -- 各种自动拾取的东西（就是不需要选择，都可以捡起来的，不会有任何坏处的）
    if table.contains(auto_use_items, itemname) then
        autouse = true
    end

    local height, time = 200, 0.75
    if radius < 10 then
        height, time = 0, 0.05
    end
    newItem:LaunchLoot(autouse, height, time, dropTarget)
    return newItem, drop
end