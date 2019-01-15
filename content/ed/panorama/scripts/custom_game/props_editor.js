var psz_CurrentPropName = "";
var m_Props_Data = [];
var m_RoomPropsData = [];

function RebuildPropsTemplates(propsDefinations) {
    //
    var propsTeamplatePanel = $("#props_templates");

    propsTeamplatePanel.RemoveAndDeleteChildren();
    for( var index in propsDefinations){
        var propName = propsDefinations[index];
        propsTeamplatePanel.BCreateChildren("<DOTAScenePanel class=\"PropTemplate\" unit=\"" + propName + "\" particleonly='false' onactivate='OnPlayerSelectProp(\"" + propName + "\")'/>");
    }
}

function Remove(){
    SetCurrentProp("");
}

function UpdatePropName() {
    psz_CurrentPropName = $("#current_prop").text;
}

function RebuildPropsGrid(){
    var propsGrid = $("#props_grid");

    propsGrid.RemoveAndDeleteChildren();

    for( var y = 13; y >= 1; y--){
        m_Props_Data[y] = [];
        var line = $.CreatePanel("Panel", propsGrid, "");
        line.AddClass("PropsLine");
        for (var x = 1; x <= 21; x++){
            var panel = $.CreatePanel("Panel", line, "prop_" + x + "_" + "y");
            panel.AddClass("PropsCell");
            m_Props_Data[y][x] = panel;

            if (m_RoomPropsData[x] !== undefined && m_RoomPropsData[x][y] !== undefined){
                // panel.AddClass("Prop_" + m_RoomPropsData[x][y]);
                var label = $.CreatePanel("Label", panel, "");
                label.text = m_RoomPropsData[x][y];
                label.style.verticalAlign = "center";
                label.style.horizontalAlign = "center";
                label.style.fontSize = "15px";
                label.style.fontWeight = "bold";
            }

            (function(_x, _y){
                m_Props_Data[_y][_x].SetPanelEvent("onactivate", function(){
                    GameEvents.SendCustomGameEventToServer("ed_props_editor_insert", {
                        x: _x,
                        y: _y,
                        name: psz_CurrentPropName
                    })
                });
                m_Props_Data[_y][_x].SetPanelEvent("onmouseover", function(){
                    $("#current_coord").text = _x + "," + _y
                })
            })(x, y);
        }
    }
}

function LoadProps() {
    GameEvents.SendCustomGameEventToServer("ed_props_editor_load", {
        name:$("#props_file_name").text
    })
}

function SaveProps(){
    GameEvents.SendCustomGameEventToServer("ed_props_editor_save", {
        name:$("#props_file_name").text,
        U:$("#DoorU").checked,
        D:$("#DoorD").checked,
        L:$("#DoorL").checked,
        R:$("#DoorR").checked,
        DontWorryAboutDoors: $("#DontCareAbountDoor").checked,
        Specific: $("#Specific").checked
    })
}

function ClearProps(){
    GameEvents.SendCustomGameEventToServer("ed_props_editor_clear", {})
}

function OnPropsDataChanged(){
    // 重新创建所有的模板
    var propsDefinations = CustomNetTables.GetTableValue("props_data", "props_defination");
    if (propsDefinations !== propsDefinations)
    {
        RebuildPropsTemplates(propsDefinations);
    }

    m_RoomPropsData = CustomNetTables.GetTableValue("props_data", "room_props");
    RebuildPropsGrid();
}

function OnPlayerSelectProp(name){
    SetCurrentProp(name);
}

function SetCurrentProp(name){
    psz_CurrentPropName = name;
    $("#current_prop").text = psz_CurrentPropName;
}

function Disable() {
    SetCurrentProp("invalid");
}

function ShowPropsEditorPanel(){
    // 显示出props editor
    var propsEditorPanel = $("#props_editor_panel");
    var bHidden = propsEditorPanel.BHasClass("Hidden");
    propsEditorPanel.SetHasClass("Hidden", !bHidden);
    $("#props_grid").SetHasClass("Hidden", !bHidden);
    $("#current_prop").SetHasClass("Hidden", !bHidden);
    $("#current_coord").SetHasClass("Hidden", !bHidden);
}

(function(){
    if (Game.IsInToolsMode()){
        $.GetContextPanel().RemoveClass("Hidden");
    }

    CustomNetTables.SubscribeNetTableListener("props_data", OnPropsDataChanged);

    var allProps = CustomNetTables.GetTableValue("props_data", "all_props");

    var propsDefinations = CustomNetTables.GetTableValue("props_data", "props_defination");

    RebuildPropsTemplates(propsDefinations);

    RebuildPropsGrid();

    $("#DontCareAbountDoor").checked = true;
    $("#DoorU").checked = true;
    $("#DoorD").checked = true;
    $("#DoorL").checked = true;
    $("#DoorR").checked = true;

    ShowPropsEditorPanel();
})();
