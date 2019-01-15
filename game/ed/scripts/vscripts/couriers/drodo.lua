module(..., package.seeall)

on_select = function(hero)
    print "player selected drodo"
    hero:SetOriginalModel("models/courier/drodo/drodo.vmdl")
	hero:SetModel("models/courier/drodo/drodo.vmdl")
end