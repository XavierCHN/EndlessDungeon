var n_CurrentIndex = 0;
var fl_LastJumpTime = 0;
var b_Deleted = false;

function ShowNextPage(){
	fl_LastJumpTime = Game.Time()
	n_CurrentIndex += 1;
	if (n_CurrentIndex > 6){ return; }
	$("#lore_image").SetImage("file://{resources}/images/lore/page" + n_CurrentIndex + ".png");
	$("#lore_text").text=$.Localize("#lore_text_page" + n_CurrentIndex);
}

function OnClickNextPage(){
	ShowNextPage();
}

function OnClickClose(){
	$.GetContextPanel().RemoveAndDeleteChildren();
	$.GetContextPanel().style.visibility = "collapse";
	b_Deleted = true;
}

function AutoJumpToNextPage()
{
	if (b_Deleted){ return; }
	var now = Game.Time();
	if ((now - fl_LastJumpTime) > 5 ){
		ShowNextPage();
	}
	$.Schedule(1, AutoJumpToNextPage);
}

AutoJumpToNextPage();