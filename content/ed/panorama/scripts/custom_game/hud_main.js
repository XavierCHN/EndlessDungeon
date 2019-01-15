var m_BossHealthBarEntityIndex = -1;
var flGameStartTime;
var n_CurrentLevel = 1;
var m_GoldLabel;

function AutoCheckBossHealthBar() {

    var hpPanel = $("#boss_hp_panel");

    if (m_BossHealthBarEntityIndex !== -1 && Entities.IsValidEntity(m_BossHealthBarEntityIndex) && Entities.IsAlive(m_BossHealthBarEntityIndex) ) {
        hpPanel.SetHasClass("Hidden", false);
        $("#boss_name").text = $.Localize(Entities.GetUnitName(m_BossHealthBarEntityIndex));
        // 显示当前血量
        var hpp = Entities.GetHealthPercent(m_BossHealthBarEntityIndex) / 100;
        if (hpp > 0) {
            $("#BossHPProgress").value = hpp;
            $("#hp_burner_container").style.width = hpp * 561 + "px";
        }

        // 修改数值
        var hpm = Entities.GetMaxHealth(m_BossHealthBarEntityIndex);
        var hp = Entities.GetHealth(m_BossHealthBarEntityIndex);
    } else {
        hpPanel.SetHasClass("Hidden", true);
    }

    $.Schedule(0.03, AutoCheckBossHealthBar);
}

function OnShowBossHealthBar(args) {
    m_BossHealthBarEntityIndex = parseInt(args.EntityIndex);
}

function PrefixInteger(num, n) {
    return (Array(n).join(0) + num).slice(-n);
}

function AutoUpdateGameClock(){
    var data = CustomNetTables.GetTableValue("game_state", "game_start_time")
    if (data === undefined) {
        $.Schedule(0.03, AutoUpdateGameClock);
        return;
    }
    flGameStartTime = data.value;
    var now = Game.Time();
    var timeExpired = (now - flGameStartTime);
    // 调整为标准时间
    var hrs = Math.floor(timeExpired / 3600);
    var mins = PrefixInteger(Math.floor(timeExpired / 60) - hrs * 60, 2);
    var secs = PrefixInteger(Math.floor(timeExpired) - mins * 60 - hrs * 3600, 2);
    var msecs = (Math.floor((timeExpired - Math.floor(timeExpired)) * 100) + "00").substring(0,2);
    $("#game_clock").text = (hrs !== 0 ? hrs + ":" : "") + mins + ":" + secs + "." + msecs + Math.floor(Math.random() * 10);

    $.Schedule(0.03, AutoUpdateGameClock);
}

function OnPlayerEnterNewLevel(keys){
    n_CurrentLevel = keys.NewLevel;

    $("#new_level_label").SetDialogVariableInt("new_level", n_CurrentLevel);
    $("#new_level_overlay").RemoveClass("NotShowing");
    $.Schedule(1, function(){
        $("#new_level_overlay").AddClass("EaseingOut");
    });
    $.Schedule(2, function(){
        $("#new_level_overlay").AddClass("NotShowing");
        $("#new_level_overlay").RemoveClass("EaseingOut");
        $("#new_level_msg").RemoveClass("NotShowing");
    });
    $.Schedule(4, function(){
        $("#new_level_msg").AddClass("EaseingOut");
    });
    $.Schedule(5, function(){
        $("#new_level_msg").AddClass("NotShowing");
        $("#new_level_msg").RemoveClass("EaseingOut");
    });
}

function FixGoldNotShow(){

    var pid = Players.GetLocalPlayer();

    if (pid == -1){
        $.Schedule(0.03, FixGoldNotShow);
        return;
    }
    if (m_GoldLabel === undefined) {
        m_GoldLabel = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("ShopButton").FindChildTraverse("GoldLabel");
        $.Schedule(0.03, FixGoldNotShow);
        return;
    }
    m_GoldLabel.text = Players.GetGold(pid);
    $.Schedule(0.03, FixGoldNotShow)
}

(function () {

    GameEvents.Subscribe("ed_show_boss_health_bar", OnShowBossHealthBar);
    GameEvents.Subscribe("ed_player_entering_new_level", OnPlayerEnterNewLevel);

    // 移除默认的quickstats，用来放秒表
    $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("quickstats").visible = false;

    // 秒表的更新器
    AutoUpdateGameClock();

    // BOSS血量的更新
    AutoCheckBossHealthBar()

    // 修正GoldLabel显示不正确的问题
    FixGoldNotShow();
})();