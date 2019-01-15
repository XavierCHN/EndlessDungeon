creature_pudge_jump = class({})

LinkLuaModifier("modifier_creature_pudge_jump", "modifiers/creatures/boss_pudge/modifier_creature_pudge_jump.lua", LUA_MODIFIER_MOTION_BOTH)

function creature_pudge_jump:GetCooldown()
    return 10
end

function creature_pudge_jump:OnSpellStart()
    if IsServer() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creature_pudge_jump", {
            TargetPosition = self:GetCursorPosition(),
        })
    end
end