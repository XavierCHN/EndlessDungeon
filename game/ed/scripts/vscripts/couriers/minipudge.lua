module(..., package.seeall)

on_select = function(hero)
    print "player selected mini pudge"
    hero:SetOriginalModel("models/courier/minipudge/minipudge.vmdl")
	hero:SetModel("models/courier/minipudge/minipudge.vmdl")
end