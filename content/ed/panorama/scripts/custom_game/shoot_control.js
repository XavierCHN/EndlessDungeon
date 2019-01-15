// Game.PlayerStartShootUp = function() {
// 	GameEvents.SendCustomGameEventToServer("ed_player_start_shoot", {direction: "up"})
// };

// Game.PlayerStartShootDown = function() {
//     GameEvents.SendCustomGameEventToServer("ed_player_start_shoot", {direction: "down"})
// };

// Game.PlayerStartShootLeft = function() {
//     GameEvents.SendCustomGameEventToServer("ed_player_start_shoot", {direction: "left"})
// };

// Game.PlayerStartShootRight = function() {
//     GameEvents.SendCustomGameEventToServer("ed_player_start_shoot", {direction: "right"})
// };

// Game.PlayerEndShootUp = function() {
//     GameEvents.SendCustomGameEventToServer("ed_player_end_shoot", {direction: "up"})
// };

// Game.PlayerEndShootDown = function() {
//     GameEvents.SendCustomGameEventToServer("ed_player_end_shoot", {direction: "down"})
// };

// Game.PlayerEndShootLeft = function() {
//     GameEvents.SendCustomGameEventToServer("ed_player_end_shoot", {direction: "left"})
// };

// Game.PlayerEndShootRight = function() {
//     GameEvents.SendCustomGameEventToServer("ed_player_end_shoot", {direction: "right"})
// };

function SendMousePositionToServer() {
	var cursor = GameUI.GetCursorPosition();
	var mousePos = Game.ScreenXYToWorld(cursor[0], cursor[1])
	GameEvents.SendCustomGameEventToServer("eum", {
		x: mousePos[0],
		y: mousePos[1],
		z: mousePos[2],
	})
}

function AutoSendMousePositionToServer() {
	SendMousePositionToServer();
	$.Schedule(0.03, AutoSendMousePositionToServer);
}

function LeftDown() {
	// 当左键被按下，开始发送鼠标位置给服务器，同时告知服务器开始射击状态
	// 直到左键松开
	SendMousePositionToServer();
	GameEvents.SendCustomGameEventToServer("eld", {})
}

function LeftUp() {
	SendMousePositionToServer(); // 再发送一次，因为有的技能会需要松开的时候的位置
	GameEvents.SendCustomGameEventToServer("elu", {})
}

function RightDown() {
	// 当右键被按下，发送鼠标位置给服务器，告知服务器右键被按下
	SendMousePositionToServer();
	GameEvents.SendCustomGameEventToServer("erd", {})
}

function RightUp() {
	SendMousePositionToServer();
	GameEvents.SendCustomGameEventToServer("eru", {})
}

(function() {
	AutoSendMousePositionToServer();

	GameUI.SetMouseCallback( function( eventName, arg ) {
		var nMouseButton = arg
		var CONSUME_EVENT = true;
		var CONTINUE_PROCESSING_EVENT = false;
		if ( GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE )
			return CONTINUE_PROCESSING_EVENT;

		if (eventName === "pressed") {
			if ( arg === 0 ) {
				LeftDown();
				return CONSUME_EVENT;
			}

			if ( arg === 1 ) {
				RightDown();
				return CONSUME_EVENT;
			}
		}

		if ( eventName === "released" ) {
			if ( arg === 0) {
				LeftUp();
				return CONSUME_EVENT;
			}

			if ( arg === 1) {
				RightUp();
				return CONSUME_EVENT;
			}
		}
	})
})();