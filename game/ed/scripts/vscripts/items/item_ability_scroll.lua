---
--- Created by Xavier.
--- DateTime: 2017/3/20 16:57
---

---当玩家使用物品卷轴
---将ed_empty1,ed_empty2,ed_empty3替换成要更换的技能
---如果没有这三个技能了，那么不允许更换
---@param keys table
function OnPlayerUseAbilityScroll(keys)
    local item             = keys.ability
    local caster           = keys.caster
    local itemName         = item:GetAbilityName()
    --item_antimage_mana_break
    local abilityNameToAdd = string.sub(itemName, 6)

    CourierUtil:AddAbility(caster, abilityNameToAdd)
end