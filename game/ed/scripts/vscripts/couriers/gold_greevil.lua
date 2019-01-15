module(..., package.seeall)

on_select = function(hero)
    print "player selected gold greevil"
    hero:SetOriginalModel("models/courier/greevil/gold_greevil.vmdl")
	hero:SetModel("models/courier/greevil/gold_greevil.vmdl")
end