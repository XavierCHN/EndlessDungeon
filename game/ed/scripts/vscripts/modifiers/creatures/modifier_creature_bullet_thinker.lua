modifier_creature_bullet_thinker = class({})

require 'ai.ai_core'

function modifier_creature_bullet_thinker:IsHidden()
    return true
end

function modifier_creature_bullet_thinker:IsPurgable()
    return false
end

function modifier_creature_bullet_thinker:OnCreated()
    if IsServer() then
        self:StartIntervalThink(0.03)
    end
end

function modifier_creature_bullet_thinker:OnIntervalThink()
    if IsServer() then
        local creature         = self:GetParent()
        local flAttackInterval = 1 / creature:GetAttacksPerSecond()
        local attackAbility    = creature:FindAbilityByName("bullet_attack")
        if attackAbility:IsCooldownReady() and IsValidAlive(creature)
        and not creature.b_DontAttack
        then
            local flAttackRange = creature:GetAttackRange()
            local enemy         = AIUtil:RandomPlayerHeroInRange(creature, flAttackRange)
            if enemy then
                -- local fwd = enemy:GetForwardVector()
                -- local range = (creature:GetOrigin() - enemy:GetOrigin()):Length2D()
                creature.m_MousePosition = enemy:GetAbsOrigin() + RandomVector(64)
                attackAbility:ShootABullet()
                attackAbility:StartCooldown(flAttackInterval)
            end
        end
    end
end
