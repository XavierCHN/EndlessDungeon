-- 如果你想贡献你自己的房间，请仔细阅读rooms._edroom中的注释
-- If you want to add your own room to this game, please read rooms/_edroom.lua carefully.
require 'rooms._terrain_defination' -- 房间内地形的定义
require 'rooms._edroom' -- 所有房间的基类，所有的房间都应该是EDRoom的子类
require 'rooms._utils'
local dota_imported_rooms = require 'rooms._dota_imported'
local all_rooms    = {
    'xavier.bonus.spike_trap'

    , 'boss/lvl1/huskar'
    , 'boss/lvl2/nevermore'
    , 'boss/lvl3/bristleback'
    , 'boss/lvl5/slardar'
    --, 'boss/lvl1/pudge' -- 屠夫真的不满意

    , 'semiboss/clinkz'
    , 'semiboss/techies'

    -- , 'shops.shop_keeper_1'

    , 'start'
    , 'item' -- 物品奖励房
    , 'props_only'
}

-- 写房间地形定义文件的文件名
local prop_maps    = require 'rooms.props._loader'

GameRules.AllRooms = {}
GameRules.PropMaps = {}

CustomNetTables:SetTableValue("props_data", "all_props", prop_maps)
CustomNetTables:SetTableValue("props_data", "props_defination", PropDefination)

function AppendProps(filename)
    if filename then
        GameRules.PropMaps[filename] = require("rooms/props/" .. filename)
        CustomNetTables:SetTableValue("props_data", "prop_" .. filename, table.safe_table(GameRules.PropMaps[filename]))
    end
end

for _, prop_file_name in pairs(prop_maps) do
    AppendProps(prop_file_name)
end

for _, file_name in pairs(all_rooms) do
    local function errormsg(msg)
        error(debug.traceback(msg .. " => in file " .. file_name))
    end
    local room = require('rooms.' .. file_name)
    if room and getbase(room) == EDRoom then
        -- 必须基类为EDRoom的，才会被认为
        if room.IsPlayable then
            table.insert(GameRules.AllRooms, room)
            --print("Inserting room ->", room.UniqueName)
        else
            print("Ignoring unplayable room ->", room.UniqueName)
        end
    else
        errormsg("not a valid room, invalid or not inherit of EDRoom")
    end
end

for _, room in pairs(dota_imported_rooms) do
    table.insert(GameRules.AllRooms, room)
end

-- 告知载入的房间数量的信息
local totalRoomCount = 0
for name, roomType in pairs(RoomType) do
    local roomCount = 0
    for _, room in pairs(GameRules.AllRooms) do
        if room.RoomType == roomType then
            roomCount = roomCount + 1
        end
    end

    if roomCount == 0 and not roomType == RoomType.Invalid then
        error("No any room found support this room type, this may cause error " .. name)
    else
        --print(string.format("RoomType ->%s<- has %d kinds loaded", name, roomCount))
    end

    totalRoomCount = totalRoomCount + roomCount
end

--print("Room loaded finished, all room count ->", totalRoomCount)
