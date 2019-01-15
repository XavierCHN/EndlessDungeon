creature_minipudge_rot = class({})
LinkLuaModifier( "modifier_rot_lua", "modifiers/creatures/boss_pudge/modifier_rot_lua.lua", LUA_MODIFIER_MOTION_NONE )

function creature_minipudge_rot:GetIntrinsicModifierName()
    return "modifier_rot_lua"
end