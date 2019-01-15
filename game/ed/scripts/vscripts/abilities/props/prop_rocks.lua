local rock_models = {
    { "models/props_rock/riveredge_rock006a.vmdl", 0.55 },
    { "models/props_rock/riveredge_rock007a.vmdl", 0.55 },
    { "models/props_rock/riveredge_rock008a.vmdl", 0.55 },
    { "models/props_rock/riveredge_rock010a.vmdl", 0.40 },
    { "models/props_rock/stalagmite_03.vmdl", 0.55 },
    { "models/props_rock/stalagmite_02.vmdl", 0.55 },
}

function SetRockRandomModel(keys)
    local rock  = keys.caster
    local model = table.random(rock_models)
    -- model = rock_models[4]
    rock:SetOriginalModel(model[1])
    rock:SetModel(model[1])
    rock:SetModelScale(model[2])
end

