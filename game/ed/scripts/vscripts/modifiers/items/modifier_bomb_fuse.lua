---
--- Created by Xavier.
--- DateTime: 2017/3/20 12:19
---

---@type CDOTA_Modifier_Lua
modifier_bomb_fuse = class({})

function modifier_bomb_fuse:IsPurgable()
    return false
end

--- Damage: 对Neutral team造成的伤害，默认100(由常亮规定)
--- DamageGoodGuys: 对自己(Team GoodGuys)造成的伤害，因为炸弹也有可能由怪物方释放，因此要留这个
--- DontDamageProps: 不炸props
--- Radius： 爆炸范围，默认为1
function modifier_bomb_fuse:OnCreated(kv)
    if IsServer() then

        local bomb = self:GetParent()

        self.flFuseTime = kv.fuse_time
        self.nDamageRadius = kv.damage_radius
        self.flDamage = kv.damage
        self.nDamageGoodGuys = kv.damage_good_guys or 1
        self:SetDuration(self.flFuseTime, true)

        self.nFusePID = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_homing_missile_fuse.vpcf", PATTACH_WORLDORIGIN, bomb)
        ParticleManager:SetParticleControl(self.nFusePID, 0, bomb:GetOrigin() + Vector(0, - 20, 75))
        ParticleManager:SetParticleControl(self.nFusePID, 1, Vector(self.flFuseTime, 0, 0))

        EmitSoundOn("Techies.Bomb.Fuse", bomb)
    end
end

function modifier_bomb_fuse:OnDestroy()
    if IsServer() then
        self:BlowUp()

        ParticleManager:DestroyParticle(self.nFusePID, true)
        ParticleManager:ReleaseParticleIndex(self.nFusePID)

        self:GetParent():ForceKill(false)
    end
end

-- 炸弹爆炸
function modifier_bomb_fuse:BlowUp()
    local bomb = self:GetParent()
    local point = bomb:GetOrigin()
    local ability = self:GetAbility()
    local cell_x, cell_y = GetCellCoordAtPosition(point)

    local damageRadius = self.nDamageRadius
    local damageNeutrals = self.flDamage
    local team = bomb:GetTeamNumber()

    for x = cell_x - damageRadius, cell_x + damageRadius do
        for y = cell_y - damageRadius, cell_y + damageRadius do
            local units = FindUnitsInCell(x, y, team, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER)
            for _, unit in pairs(units) do
                if unit ~= bomb then
                    -- 如果是怪物
                    if unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
                        -- 如果是Props，除非说定义了UnExplodable，否则就杀死
                        if unit.bIsProp then
                            if GameRules.Units_KV[unit:GetUnitName()].UnExplodable then
                            else
                                -- 杀死
                                unit:SetOrigin(Vector(9999,9999,9))
                                unit:ForceKill(false)
                            end
                        else
                            utilsDamage.DealDamageConstant(bomb, unit, damageNeutrals, ability)
                        end
                    elseif unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
                        utilsDamage.DealDamagePercentage(bomb, unit, 100, ability)
                    end
                end
            end

            -- 在这些位置制造爆炸
            local center = GetCellCenterAtCoord(x, y)
            local pid = ParticleManager:CreateParticle("particles/creatures/boss_techies/techies_bomb_explode.vpcf", PATTACH_WORLDORIGIN, bomb)
            ParticleManager:SetParticleControl(pid, 0, center)
            ParticleManager:ReleaseParticleIndex(pid)

            -- 声音
            EmitSoundOn("Hero_TemplarAssassin.Trap.Explode", bomb)
        end
    end
    -- 根据当前的CellX和CellY，确定是否是在炸门的范围内
    GameRules.gamemode:GetCurrentRoom():OnBombExplodeAtCoord(cell_x, cell_y)
end