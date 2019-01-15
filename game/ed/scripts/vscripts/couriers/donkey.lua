module(..., package.seeall)

on_select = function(hero)
    print "player selected donkey"
    hero:SetOriginalModel("models/props_gameplay/donkey.vmdl")
	hero:SetModel("models/props_gameplay/donkey.vmdl")
end
