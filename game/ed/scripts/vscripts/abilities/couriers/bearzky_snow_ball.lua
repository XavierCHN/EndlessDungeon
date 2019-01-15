bearzky_snow_ball = class({})

LinkLuaModifier("modifier_bearzky_snow_ball", "modifiers/couriers/modifier_bearzky_snow_ball.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bearzky_snow_ball_slow", "modifiers/couriers/modifier_bearzky_snow_ball_slow.lua", LUA_MODIFIER_MOTION_NONE)

function bearzky_snow_ball:GetIntrinsicModifierName()
    return "modifier_bearzky_snow_ball"
end