var m_ItemCostTable;
var m_GoldLabel;

function ShowItemTooltip(index) {
    switch (index){
        case 1:
            $.DispatchEvent("DOTAShowAbilityTooltip", $("#item_image_consumable"), $("#item_image_consumable").itemname);
            break;
        case 2:
            $.DispatchEvent("DOTAShowAbilityTooltip", $("#item_image_basic"), $("#item_image_basic").itemname);
            break;
        case 3:
            $.DispatchEvent("DOTAShowAbilityTooltip", $("#item_image_recipe"), $("#item_image_recipe").itemname );
            break;
        case 4:
            $.DispatchEvent("DOTAShowAbilityTooltip", $("#item_image_meme"), $("#item_image_meme").itemname);
            break;
    }
}

function HideItemTooltip() {
    $.DispatchEvent("DOTAHideAbilityTooltip", $("#item_image_consumable"));
    $.DispatchEvent("DOTAHideAbilityTooltip", $("#item_image_basic"));
    $.DispatchEvent("DOTAHideAbilityTooltip", $("#item_image_recipe"));
    $.DispatchEvent("DOTAHideAbilityTooltip", $("#item_image_meme"));
}

function PlayerPurchaseItem(index) {
    var itemName = "";
    switch( index){
        case 1:
            itemName = $("#item_image_consumable").itemname;
            break;
        case 2:
            itemName = $("#item_image_basic").itemname;
            break;
        case 3:
            itemName = $("#item_image_recipe").itemname;
            break;
        case 4:
            itemName = $("#item_image_meme").itemname;
            break;
    }
    GameEvents.SendCustomGameEventToServer("ed_player_purchase_item", {ItemName: itemName});
}

function RebuildShopPanel(args) {
    var items = args;
    var amp = args.amplify;

    if (m_ItemCostTable === undefined){
        m_ItemCostTable = CustomNetTables.GetTableValue("kv_data", "item_cost_data");
    }
    // 购买之后，不刷新商店物品？
    if ($("#item_image_consumable").itemname !== items.consumable)
        $("#item_image_consumable").itemname = items.consumable;
    if ($("#item_image_recipe").itemname !== items.recipe)
        $("#item_image_recipe").itemname = items.recipe;
    if ($("#item_image_basic").itemname !== items.basic_item)
        $("#item_image_basic").itemname = items.basic_item;
    if ($("#item_image_meme").itemname !== items.meme)
        $("#item_image_meme").itemname = items.meme;

    $("#item_cost_consumable").text = Math.floor(m_ItemCostTable[items.consumable] * (1 + amp));
    $("#item_cost_basic").text = Math.floor(m_ItemCostTable[items.basic_item] * (1 + amp));
    $("#item_cost_recipe").text = Math.floor(m_ItemCostTable[items.recipe] * (1 + amp));
    $("#item_cost_meme").text = Math.floor(m_ItemCostTable[items.meme] * (1 + amp));

    $.GetContextPanel().RemoveClass("NotShowing");
}

function HideShopPanel() {
    $.GetContextPanel().AddClass("NotShowing");
}

function RebuildItemCostTable(){
    m_ItemCostTable = CustomNetTables.GetTableValue("kv_data", "item_cost_data");
}

function ShowRerollTooltip(){
    $.DispatchEvent("DOTAShowTextTooltip", $("#reroll_button"), $.Localize("#reroll_tooltip"));
}

function HideRerollTooltip() {
    $.DispatchEvent("DOTAHideTextTooltip", $("#reroll_button"));
}

function OnPlayerReroll() {
    GameEvents.SendCustomGameEventToServer("ed_player_reroll_shop_items", {});
}


(function () {
    GameEvents.Subscribe("ed_player_start_shopping", RebuildShopPanel);
    GameEvents.Subscribe("ed_player_end_shopping", HideShopPanel);

    CustomNetTables.SubscribeNetTableListener("kv_data", RebuildItemCostTable);
    HideShopPanel();
})();