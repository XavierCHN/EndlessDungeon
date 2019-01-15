module(..., package.seeall)

model = 

cost_p = 6400
cost_g = 188

passive = "frog_1_s"

on_select = function(hero)
	hero:SetOriginalModel("models/courier/frog/frog.vmdl")
	hero:SetModel("models/courier/frog/frog.vmdl")
end