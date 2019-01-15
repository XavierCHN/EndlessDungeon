creature_pudge_charge = class({})

LinkLuaModifier("modifier_creature_pudge_charge", "modifiers/creatures/boss_pudge/modifier_creature_pudge_charge.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_creature_pudge_charge_hit_knockback", "modifiers/creatures/boss_pudge/modifier_creature_pudge_charge_hit_knockback.lua", LUA_MODIFIER_MOTION_NONE)

function creature_pudge_charge:OnAbilityPhaseStart()
    if IsServer() then
        EmitAnnouncerSound("pudge_pud_ability_hook_miss_06") -- 都给我让开
        self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_ROT)
    end

    return true
end

function creature_pudge_charge:OnSpellStart()
    if IsServer() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creature_pudge_charge", {})
    end
end