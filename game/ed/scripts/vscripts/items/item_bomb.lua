---
--- Created by Xavier.
--- DateTime: 2017/3/20 10:39
---

LinkLuaModifier("modifier_bomb_fuse", "modifiers/items/modifier_bomb_fuse.lua", LUA_MODIFIER_MOTION_NONE)

-- 炸弹放置
-- 我们需要让炸弹放置在距离最近的坐标位置
-- @param keys
--- FuseTime 爆炸延迟
---
function BombSet(keys)
    local caster       = keys.caster
    local ability      = keys.ability

    local cellPosition = GetCellCenterOfPosition(caster:GetOrigin())

    local bomb         = CreateUnitByName("npc_dota_bomb", cellPosition, false, caster, caster, caster:GetTeamNumber())

    -- 不储存炸弹的位置，因为炸弹位置可能会有其他机制来移动他，在爆炸的时候再获取一次炸弹位置好了

    bomb:AddNewModifier(caster, ability, "modifier_bomb_fuse", {
        fuse_time = keys.FuseTime,
        damage_radius = keys.DamageRadius or 1,
        damage = keys.Damage or BOMB_DAMAGE,
        damage_good_guys = keys.DamageGoodGuys or 1, -- 默认对玩家造成一颗心的伤害
    })

    bomb:AddNewModifier(bomb, ability, "modifier_no_unit_collision", {})
    bomb:AddNewModifier(bomb, ability, "modifier_creature_invulnerable", {})
end