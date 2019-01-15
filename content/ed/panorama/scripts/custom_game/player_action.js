Game.PlayerMoveUp = function() {
	GameEvents.SendCustomGameEventToServer("ed_player_start_move_up", {})
};
Game.PlayerMoveDown = function() {
	GameEvents.SendCustomGameEventToServer("ed_player_start_move_down", {})
};
Game.PlayerMoveLeft = function() {
	GameEvents.SendCustomGameEventToServer("ed_player_start_move_left", {})
};
Game.PlayerMoveRight = function() {
	GameEvents.SendCustomGameEventToServer("ed_player_start_move_right", {})
};

Game.PlayerMoveUp_End = function() {
	GameEvents.SendCustomGameEventToServer("ed_player_end_move_up", {})
};
Game.PlayerMoveDown_End = function() {
	GameEvents.SendCustomGameEventToServer("ed_player_end_move_down", {})
};
Game.PlayerMoveLeft_End = function() {
	GameEvents.SendCustomGameEventToServer("ed_player_end_move_left", {})
};
Game.PlayerMoveRight_End = function() {
	GameEvents.SendCustomGameEventToServer("ed_player_end_move_right", {})
};
Game.PlayerDash = function() {
	// GameEvents.SendCustomGameEventToServer("ed_player_dash", {})
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	if (!Entities.IsControllableByPlayer(queryUnit, Players.GetLocalPlayer())) { return ;}
	var ability = Entities.GetAbility(queryUnit, 8);
	Abilities.ExecuteAbility(ability, queryUnit, false);
};

Game.PlayerExecute1 = function() {
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	if (!Entities.IsControllableByPlayer(queryUnit, Players.GetLocalPlayer())) { return ;}

	var ability = Entities.GetAbility(queryUnit, 6);
	if (ability === -1){ return; }
	Abilities.ExecuteAbility(ability, queryUnit, false);
};

Game.PlayerExecute2 = function() {
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	if (!Entities.IsControllableByPlayer(queryUnit, Players.GetLocalPlayer())) { return ;}

	var ability = Entities.GetAbility(queryUnit, 7);
	if (ability === -1){ return; }
	Abilities.ExecuteAbility(ability, queryUnit, false);
};

Game.EmptyCallback = function(){};


Game.PlayerPickUp = function(){
    GameEvents.SendCustomGameEventToServer("ed_player_pickup", {})
};

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