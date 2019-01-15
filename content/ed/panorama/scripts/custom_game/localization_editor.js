var m_PanoramaEnglish;
var m_PanoramaSchiense;
var m_LoadedTokens = [];

function contains(arr, obj) {
    var i = arr.length;
    while (i--) {
        if (arr[i] === obj) {
            return true;
        }
    }
    return false;
}

function BuildPanoramaTokensScreen() {
    var parent = $("#panorama_content_panel");
    parent.RemoveAndDeleteChildren();
    var sortedKeys = Object.keys(m_PanoramaEnglish).sort();
    for(var i = 0; i<sortedKeys.length; i++){
        var tokenName = sortedKeys[i];
        var line = $.CreatePanel("Panel", parent, "");
        line.BLoadLayoutSnippet("LocalizationLine");
        line.FindChildTraverse("token").text = tokenName;
        line.FindChildTraverse("token_english").text = m_PanoramaEnglish[tokenName];
        line.FindChildTraverse("token_schinese").text = m_PanoramaSchiense[tokenName] || "";
        m_LoadedTokens.push(tokenName);
    }

    for(var tokenName in m_PanoramaSchiense){
        if(!contains(m_LoadedTokens, tokenName)){
            var line = $.CreatePanel("Panel", parent, "");
            line.BLoadLayoutSnippet("LocalizationLine");
            line.FindChildTraverse("token").text = tokenName;
            line.FindChildTraverse("token_schinese").text = m_PanoramaSchiense[tokenName];
            line.FindChildTraverse("token_english").text = m_PanoramaEnglish[tokenName] || "";
        }
    }
}

function TogglePanoramaPanel(){
    $("#panorama_panel").ToggleClass("Hidden");
}

function SavePanoramaToken(){
    var parent = $("#panorama_content_panel");
    var childCount = parent.GetChildCount();
    var data = {};
    for (var i = 0; i < childCount; i++){
        var line = parent.GetChild(i);
        var token = line.FindChildTraverse("token").text;
        var token_english = line.FindChildTraverse("token_english").text;
        var token_schinese = line.FindChildTraverse("token_schinese").text;
        if (token !== ""){
            data[token+"e"] = token_english;
            data[token+"s"] = token_schinese;
        }
    }
    GameEvents.SendCustomGameEventToServer("ed_save_panorama_string", {data:JSON.stringify(data)});
}

function AddPanoramaToken() {
    var parent = $("#panorama_content_panel");
    var line = $.CreatePanel("Panel", parent, "");
    line.BLoadLayoutSnippet("LocalizationLine");
    parent.MoveChildBefore(line, parent.GetChild(0))
}

function Reload() {
    BuildPanoramaTokensScreen();
}

(function(){
    if (!Game.IsInToolsMode()){
        return;
    }

    $.GetContextPanel().RemoveClass("Hidden");

    m_PanoramaEnglish = CustomNetTables.GetTableValue("panorama_string", "panorama_english");
    m_PanoramaSchiense = CustomNetTables.GetTableValue("panorama_string", "panorama_schinese");

    BuildPanoramaTokensScreen();
})();