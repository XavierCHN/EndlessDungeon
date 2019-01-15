--EffectName       = caster.psz_BulletParticle,
--Ability          = self,
--vSpawnOrigin     = origin,
--Source           = caster,
--fDistance        = distance,
--fStartRadius     = start_radius,
--fEndRadius       = end_radius,
--bHasFrontalCone  = false,
--bReplaceExisting = false,
--iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_ENEMY,
--iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
--iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
--fExpireTime      = GameRules:GetGameTime() + 10.0,
--vVelocity        = direction * speed,

---@class ProjectileInfo
---@field EffectName string
---@field Ability CDOTA_Ability
---@field vSpawnOrigin Vector
---@field Source CDOTA_BaseNPC
---@field fDistance float
---@field fStartRadius float
---@field fEndRadius float
---@field bHasFrontalCone bool
---@field bReplaceExisting bool
---@field iUnitTargetTeam number
---@field iUnitTargetFlags number
---@field iUnitTargetType number
---@field fExpireTime float
---@field vVelocity Vector
---@field ExtraData table
ProjectileInfo = {}

---@return ProjectileInfo
function ProjectileInfo.new()

    return {
        EffectName       = "",
        Ability          = nil,
        vSpawnOrigin     = Vector(0,0,0),
        Source           = nil,
        fDistance        = 1000,
        fStartRadius     = 32,
        fEndRadius       = 32,
        bHasFrontalCone  = false,
        bReplaceExisting = false,
        iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime      = GameRules:GetGameTime() + 10.0,
        vVelocity        = Vector(500, 500, 0),
    }
end