var nCurrentRoomX = 0;
var nCurrentRoomY = 0;
var m_MapData = {};

function UpdateMap(){
	m_MapData = CustomNetTables.GetTableValue("map_data", "all_rooms_data");

	var minimapArea = $("#minimap");
	minimapArea.RemoveAndDeleteChildren();

	// 只显示-1和+1的房间
	for( var offsetX = -2; offsetX <= 2; offsetX ++){
		var roomColumn = $.CreatePanel("Panel", minimapArea, "");

		roomColumn.AddClass("MinimapColumn");
		for( var offsetY = 2; offsetY >= -2; offsetY-- ){
			var roomMsg = null;
			for (var index in m_MapData){
				var room = m_MapData[index];
				if (room.x === nCurrentRoomX + offsetX && room.y === nCurrentRoomY + offsetY){
					roomMsg = room;
				}
			}

			var roomCell = $.CreatePanel("Panel", roomColumn, "MinimapCell_" + offsetX + "/" + offsetY);
			roomCell.AddClass("MinimapCell");

			if (roomMsg === null
                || (
					((Math.abs(offsetX) === 2 || Math.abs(offsetY) === 2 ) ||
                	(Math.abs(offsetX) === 1 && Math.abs(offsetY) === 1 ))
                	&& roomMsg.visited === 0)
                || (roomMsg.roomType === 5 && roomMsg.visited === 0)
            ){
				roomCell.AddClass("EmptyCell")
			}else{
				roomCell.AddClass("MinimapRoomType" + roomMsg.roomType);
			}

			if(offsetX == 0 && offsetY == 0){
				roomCell.AddClass("CurrentCell");
			}else{
				roomCell.RemoveClass("CurrentCell");
			}
		}
	}
}

function OnCurrentRoomChanged(args){
	
	nCurrentRoomX = args.x;
	nCurrentRoomY = args.y;

	UpdateMap();
}

(function(){
	UpdateMap();
	CustomNetTables.SubscribeNetTableListener("map_data", UpdateMap);
	GameEvents.Subscribe("ed_current_room_changed", OnCurrentRoomChanged)
})();