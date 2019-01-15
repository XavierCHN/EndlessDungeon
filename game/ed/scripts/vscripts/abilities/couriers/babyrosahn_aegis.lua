---@type CDOTA_Ability_Lua
babyroshan_aegis = class({})

LinkLuaModifier("modifier_babyroshan_aegis", "modifiers/couriers/modifier_babyroshan_aegis.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_babyroshan_aegis_death_counter", "modifiers/couriers/modifier_babyroshan_aegis_death_counter.lua", LUA_MODIFIER_MOTION_NONE)
function babyroshan_aegis:GetIntrinsicModifierName()
    return "modifier_babyroshan_aegis"
end

function babyroshan_aegis:OnOwnerDied()
    if IsServer() then
        local caster = self:GetCaster()

        local stackCount = caster:GetModifierStackCount("modifier_babyroshan_aegis_death_counter", caster) + 1
        caster:SetModifierStackCount("modifier_babyroshan_aegis_death_counter", caster, stackCount)

        if caster:GetModifierStackCount("modifier_babyroshan_aegis_death_counter", caster) > 9 then
            print("defeated")
            GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
        end
    end
end