var m_AllCouriers = [];
var m_CurrentIndex = 0;
var m_ParticlePanels = {};

var psz_CourierName = "donkey";
var psz_ParticleName = "";

function len(obj){
    var length = 0;
    for (var key in obj) length++;
    return length;
}

function SetCurrentCourier(courierData){
    $.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'courier_selection_scene', 'camera_' + courierData.name, 0.5);
    $("#courier_name").text = $.Localize("#courier_name_" + courierData.name);
    $("#courier_subtitle").text = $.Localize("#courier_subtitle_" + courierData.name);
    $("#courier_lore").text = $.Localize("#courier_lore_" + courierData.name);
    $("#courier_ability_name").text = $.Localize("#passive_ability") + " · " + $.Localize("#DOTA_Tooltip_Ability_"+ courierData.ability);
    $("#courier_ability").abilityname = courierData.ability;
    $("#courier_ability_description").text = $.Localize("#DOTA_Tooltip_Ability_" + courierData.ability + "_Description");
    psz_CourierName = courierData.name;
}

function SelectPrevCourier(){
    m_AllCouriers = CustomNetTables.GetTableValue("couriers_data" , "couriers_data");
    m_CurrentIndex --;
    if (m_CurrentIndex <= 0) m_CurrentIndex = len(m_AllCouriers);

    SetCurrentCourier(m_AllCouriers[m_CurrentIndex]);

    var m_PrevCourier = m_CurrentIndex - 1; if (m_PrevCourier <= 0)  m_PrevCourier = len(m_AllCouriers);
    var m_NextCourier = m_CurrentIndex + 1; if (m_NextCourier > len(m_AllCouriers))  m_NextCourier = 1;
    $("#prev_courier_label").text = $.Localize("#courier_name_" + m_AllCouriers[m_PrevCourier].name);
    $("#next_courier_label").text = $.Localize("#courier_name_" + m_AllCouriers[m_NextCourier].name);
}

function SelectNextCourier(){
    m_AllCouriers = CustomNetTables.GetTableValue("couriers_data" , "couriers_data");
    m_CurrentIndex ++;
    if (m_CurrentIndex > len(m_AllCouriers)) m_CurrentIndex = 1;

    SetCurrentCourier(m_AllCouriers[m_CurrentIndex]);

    var m_PrevCourier = m_CurrentIndex - 1; if (m_PrevCourier <= 0)  m_PrevCourier = len(m_AllCouriers);
    var m_NextCourier = m_CurrentIndex + 1; if (m_NextCourier > len(m_AllCouriers))  m_NextCourier = 1;
    $("#prev_courier_label").text = $.Localize("#courier_name_" + m_AllCouriers[m_PrevCourier].name);
    $("#next_courier_label").text = $.Localize("#courier_name_" + m_AllCouriers[m_NextCourier].name);
}

function SelectCourier(){
    var m_DataForServer = {
        CourierName: psz_CourierName,
        ParticleName: psz_ParticleName
    };
    GameEvents.SendCustomGameEventToServer("ed_player_select_courier", m_DataForServer);
    ToggleCourierPanel();
}

function ToggleCourierPanel(){
    var courierPanel = $("#courier_selection_panel");
    courierPanel.ToggleClass("Hidden");
}

function Close(){
    ToggleCourierPanel();
}

function ShowCourierSelection() {
    $("#courier_selection_panel").AddClass("CourierSelection");
    $("#courier_selection_panel").RemoveClass("ParticleSelection");
}

function ShowParticleSelection() {
    $("#courier_selection_panel").AddClass("ParticleSelection");
    $("#courier_selection_panel").RemoveClass("CourierSelection");
}

(function(){
    ToggleCourierPanel();
    $.Schedule(0.2, SelectNextCourier);
})();
