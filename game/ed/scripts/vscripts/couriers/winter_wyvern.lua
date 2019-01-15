module(..., package.seeall)

model = "models/courier/baby_winter_wyvern/baby_winter_wyvern.vmdl"

cost_p = 6400
cost_g = 188

passive = "winter_wyvern_arctic_burn"

on_select = function(hero)
    print "player selected winter wyvern"
    hero:SetOriginalModel()
	hero:SetModel()
end