module(..., package.seeall)

on_select = function(hero)
    hero:SetOriginalModel("models/items/courier/bearzky_v2/bearzky_v2.vmdl")
    hero:SetModel("models/items/courier/bearzky_v2/bearzky_v2.vmdl")
    CourierUtil:ReplaceRightMouseAbilityWith(hero, "bearzky_ice_shards")
end