function LockCamera(){
	// GameUI.SetCameraTargetPosition( [0,-180,0], 1 );
	GameUI.SetCameraPitchMax(70);
	GameUI.SetCameraPitchMin(70);
	// GameUI.SetCameraDistance(1800);
	$.Schedule(1, LockCamera)
}

function SetCameraDistance() {
}


function LockSelection()
{
	var unit = Players.GetLocalPlayerPortraitUnit();
	if (unit !== Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())){
		GameUI.SelectUnit( Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()), false);
	}
	$.Schedule(0.03, LockSelection)
}

(function(){
	LockSelection();
	LockCamera();
	SetCameraDistance();
})();
