var hud = $.GetContextPanel().GetParent().GetParent();

function MoveAbilityPositions() {
	var abilities = hud.FindChildTraverse("abilities");

	if (abilities === null || abilities.FindChildTraverse("Ability1") === null ){
		$.Schedule(0.1, MoveAbilityPositions);
		return;
	}


	// 移除天赋面板和按钮
	hud.FindChildTraverse("StatBranch").FindChildTraverse("StatBranchGraphics").FindChildTraverse("StatBranchChannel").style.visibility = "collapse";
	hud.FindChildTraverse("StatBranch").FindChildTraverse("StatBranchBG").style.visibility = "collapse";
	hud.FindChildTraverse("StatBranch").SetPanelEvent("onactivate", function(){});
	hud.FindChildTraverse("StatBranch").SetPanelEvent("onmouseover", function(){});
	hud.FindChildTraverse("StatBranch").style.width = "0px";

	// 移除动态头像
	// hud.FindChildTraverse("stats_container").style.visibility = "collapse";
	hud.FindChildTraverse("PortraitContainer").style.visibility = "collapse";
	// hud.FindChildTraverse("PortraitBackerColor").style.width = "40px";
	// hud.FindChildTraverse("PortraitBackerColor").style.visibility = "collapse";
	// hud.FindChildTraverse("PortraitBacker").style.visibility = "collapse";
	// hud.FindChildTraverse("AbilityInsetShadowLeft").style.marginLeft = "40px";
	// var abilityLefts = hud.FindChildrenWithClassTraverse("AbilityInsetShadowLeft");
	// for (var panel in abilityLefts){
	// 	abilityLefts[panel].style.marginLeft = "52px";
	// }
	// hud.FindChildTraverse("center_bg").style.marginLeft = "52px";
	// hud.FindChildTraverse("AbilitiesAndStatBranch").style.marginLeft = "52px";
	// hud.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").style.marginLeft = "52px";


	// 移除等级和经验
	hud.FindChildTraverse("center_block").FindChildTraverse("xp").style.visibility = "collapse";

	// 修改技能的位置
	abilities.FindChildTraverse("Ability1").style.visibility = "collapse";

	var lButton = abilities.FindChildTraverse("Ability4");
	var rButton = abilities.FindChildTraverse("Ability5");
	var shiftButton = abilities.FindChildTraverse("Ability8");

	abilities.MoveChildBefore(shiftButton, abilities.FindChildTraverse("Ability0"));
	abilities.MoveChildBefore(rButton, shiftButton);
	abilities.MoveChildBefore(lButton, rButton);


	lButton.FindChildTraverse("AbilityLevelContainer").style.visibility = "collapse";
	rButton.FindChildTraverse("AbilityLevelContainer").style.visibility = "collapse";
	shiftButton.FindChildTraverse("AbilityLevelContainer").style.visibility = "collapse";

	var leftButton = lButton.FindChildTraverse("ButtonWithLevelUpTab");
	if (leftButton.FindChildTraverse("leftButtonImage") === null) {
		$.CreatePanel("Image", leftButton, "leftButtonImage");
	}
	var leftButtonImage = leftButton.FindChildTraverse("leftButtonImage")
	leftButtonImage.SetImage("file://{resources}/images/ui/controller/mouse_l.png");
	leftButtonImage.style.verticalAlign = "bottom";
	leftButtonImage.style.horizontalAlign = "center";
	leftButtonImage.style.marginBottom = "-10px";

	var rightButton = rButton.FindChildTraverse("ButtonWithLevelUpTab");
	if (rightButton.FindChildTraverse("leftButtonImage") === null) {
		$.CreatePanel("Image", rightButton, "rightButtonImage");
	}
	
	var rightButtonImage = rightButton.FindChildTraverse("rightButtonImage")
	rightButtonImage.SetImage("file://{resources}/images/ui/controller/mouse_r.png");
	rightButtonImage.style.verticalAlign = "bottom";
	rightButtonImage.style.horizontalAlign = "center";
	rightButtonImage.style.marginBottom = "-10px";


	var buttonImage;
	if (shiftButton.FindChildTraverse("ButtonWithLevelUpTab").FindChildTraverse("buttonImage") === null) {
		$.CreatePanel("Image", shiftButton.FindChildTraverse("ButtonWithLevelUpTab"), "buttonImage");
	}
	buttonImage = shiftButton.FindChildTraverse("ButtonWithLevelUpTab").FindChildTraverse("buttonImage");
	buttonImage.SetImage("file://{resources}/images/ui/controller/button_shift.png")
	buttonImage.style.verticalAlign = "bottom";
	buttonImage.style.horizontalAlign = "center";
	buttonImage.style.opacity = "0.6";
	buttonImage.style.marginBottom = "10px";
	buttonImage.hittest = false;

	for(var i = 0; i< 12; i++){
		var button = abilities.FindChildTraverse("Ability" + i);
		button.FindChildTraverse("HotkeyContainer").style.visibility = "collapse";

		var _parent = button.FindChildTraverse("ButtonWithLevelUpTab");
		var hotkeyPanel;
		var hotkey;
		if ((i == 0 || i == 2 || i == 5 || i == 6 || i == 7 || i == 9 || i == 10 || i == 11) && (_parent.FindChildTraverse("MHotkeyContainer") == null)) {
			
			hotkeyPanel = $.CreatePanel("Panel", _parent, "MHotkeyContainer");
			hotkeyPanel.style.verticalAlign = "bottom";
			hotkeyPanel.style.horizontalAlign = "center";
			hotkeyPanel.hittest = false;
			hotkey = $.CreatePanel("Label", hotkeyPanel, "MHotkey");
			hotkey.hittest = false;
			if (i == 0){
				hotkey.text = "Q";
			}
			if (i == 2){
				hotkey.text = "E";
			}
			if (i == 5){
				hotkey.text = "R";
			}
			if (i == 6){
				hotkey.text = "1";
			}
			if (i == 7){
				hotkey.text = "2";
			}
			if (i == 9){
				hotkey.text = "3";
			}
			if (i == 10){
				hotkey.text = "4";
			}
			if (i == 11){
				hotkey.text = "5";
			}
		}
		hotkeyPanel = _parent.FindChildTraverse("MHotkeyContainer");
		if (hotkeyPanel !== null){
			hotkeyPanel.style.verticalAlign = "bottom";
			hotkeyPanel.style.horizontalAlign = "center";
			hotkeyPanel.style.marginBottom = "10px";
			hotkeyPanel.style.opacity = "0.3";
			hotkey = hotkeyPanel.FindChildTraverse("MHotkey");
			hotkey.style.fontSize = "30px";

		}
	}
}

(function() {
	MoveAbilityPositions();
})();