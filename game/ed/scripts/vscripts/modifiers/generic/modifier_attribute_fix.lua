modifier_attribute_fix = class({})

-- 每点力量提升1点生命值
function modifier_attribute_fix:GetModifierHealthBonus()
    if IsServer() then
        return self:GetParent():GetStrength() * -19
    end
end

-- 每点敏捷提升1点移动速度
function modifier_attribute_fix:GetModifierMoveSpeedBonus_Constant()
    if IsServer() then
        return self:GetParent():GetAgility()
    end
    -- 客户端更新
    local attributes = CustomNetTables:GetTableValue("courier_attributes","courier_attributes" .. self:GetParent():GetEntityIndex())
    if attributes and attributes.agi then
        return attributes.agi
    end
end

-- 每点智力提升1点幸运
function modifier_attribute_fix:GetModifierLuckyBonus_Constant()
    if IsServer() then
        return self:GetParent():GetIntellect()
    end
end


function modifier_attribute_fix:IsHidden()
    return true
end

function modifier_attribute_fix:IsPurgable()
    return false
end

function modifier_attribute_fix:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_attribute_fix:DeclareFunctions()
    -- 回血依然禁用掉，转为dota模式之后
    -- 除了回血之外，所有的属性都使用DOTA的
    return {
        -- MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        -- MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        -- MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, 
        -- MODIFIER_PROPERTY_MANA_BONUS,
        -- MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        -- MODIFIER_PROPERTY_HEALTH_BONUS,
        -- MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end

-- 移除我们不需要的那些属性
function modifier_attribute_fix:GetModifierPhysicalArmorBonus()
    if IsServer() then
        return self:GetParent():GetAgility() * - 0.143
    end
    -- 客户端更新
    local attributes = CustomNetTables:GetTableValue("courier_attributes","courier_attributes" .. self:GetParent():GetEntityIndex())
    if attributes and attributes.agi then
        return attributes.agi * -0.143
    end
end

function modifier_attribute_fix:GetModifierConstantHealthRegen()
    if IsServer() then
        -- 如果属性发生了改变，将属性数据发送给客户端
        local parent = self:GetParent()
        parent.vAttributeForClient_modifier_attribute_fix = parent.vAttributeForClient_modifier_attribute_fix or {}
        parent.vAttributeForClient_modifier_attribute_fix.str = parent.vAttributeForClient_modifier_attribute_fix.str or -1
        parent.vAttributeForClient_modifier_attribute_fix.agi = parent.vAttributeForClient_modifier_attribute_fix.agi or -1
        parent.vAttributeForClient_modifier_attribute_fix.int = parent.vAttributeForClient_modifier_attribute_fix or -1
        
        local u = false
        local str, agi, int = parent:GetStrength(), parent:GetAgility(), parent:GetIntellect()

        if str ~= parent.vAttributeForClient_modifier_attribute_fix.str then
            u = true; parent.vAttributeForClient_modifier_attribute_fix.str = str
        end
        if agi ~= parent.vAttributeForClient_modifier_attribute_fix.agi then
            u = true; parent.vAttributeForClient_modifier_attribute_fix.agi = agi
        end
        if int ~= parent.vAttributeForClient_modifier_attribute_fix.int then
            u = true; parent.vAttributeForClient_modifier_attribute_fix.int = int
        end

        CustomNetTables:SetTableValue("courier_attributes","courier_attributes" .. self:GetParent():GetEntityIndex(),parent.vAttributeForClient_modifier_attribute_fix)

        return self:GetParent():GetStrength() * - 0.03
    end
end

function modifier_attribute_fix:GetModifierManaBonus()
    if IsServer() then
        return self:GetParent():GetIntellect() * - 12
    end
end

function modifier_attribute_fix:GetModifierConstantManaRegen()
    if IsServer() then
        return self:GetParent():GetIntellect() * - 0.035
    end
end

function modifier_attribute_fix:GetModifierBaseAttack_BonusDamage()
    if IsServer() then
        return self:GetParent():GetStrength() * -1
    end
end