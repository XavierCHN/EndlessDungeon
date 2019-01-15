ed_dash = class({})

LinkLuaModifier("modifier_ed_dash", "modifiers/characters/modifier_ed_dash.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function ed_dash:GetCooldown(iLevel)
    return 3
end

function ed_dash:IsHiddenAbilityCastable()
    return true
end

function ed_dash:OnSpellStart()
    if IsServer() then
        EmitSoundOn("Hero_Rattletrap.Rocket_Flare.Fire", self:GetCaster())
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ed_dash", {})
    end
end