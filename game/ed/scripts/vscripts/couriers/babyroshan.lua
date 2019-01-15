module(..., package.seeall)

on_select = function(hero)
    print "player selected baby roshan"
    hero:SetOriginalModel("models/courier/baby_rosh/babyroshan.vmdl")
	hero:SetModel("models/courier/baby_rosh/babyroshan.vmdl")
end