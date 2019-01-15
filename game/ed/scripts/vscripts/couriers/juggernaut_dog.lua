module(..., package.seeall)

on_select = function(hero)
    print "player selected jugg dog"
    hero:SetOriginalModel("models/courier/juggernaut_dog/juggernaut_dog.vmdl")
	hero:SetModel("models/courier/juggernaut_dog/juggernaut_dog.vmdl")
end