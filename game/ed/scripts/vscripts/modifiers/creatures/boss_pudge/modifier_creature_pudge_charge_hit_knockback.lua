modifier_creature_pudge_charge_hit_knockback = class({})

function modifier_creature_pudge_charge_hit_knockback:OnCreated(kv)
    -- 造成伤害
    if IsServer() then
        local caster = self:GetCaster()
        local target = self:GetParent()
        utilsDamage.DealDamagePercentage(caster, target, 20, self)

        EmitSoundOn("Hero_Spirit_Breaker.Charge.Impact", target)

        Knockback(caster, target, caster:GetOrigin(), 300, 10, 1)
        target:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", { duration = 3 })
    end
end