creature_attack = class({})

function creature_attack:OnProjectileHit_ExtraData(target, location, extraData)
    if IsServer() then
        if target then
            if extraData.damage then
                utilsDamage.DealDamageConstant(self:GetCaster(), target, extraData.damage, self)
            else
                self:GetCaster():PerformAttack(target, true, true, true, false, false, false, true)
            end

            if extraData.hitSound then
                EmitSoundOn(extraData.hitSound, target)
            end
        else
            -- 如果没有目标同时触发了hit，那么说明没有命中目标
            if extraData.onProjectileEnd then
                GameRules.CreatureAttackCallback[extraData.onProjectileEnd](self, location, extraData)
            end
        end
    end
end