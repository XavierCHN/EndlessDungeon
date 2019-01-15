module("AIThink", package.seeall) -- 所有的AI文件都用这一行开头，复制粘贴即可

function npc_dota_hero_boss_pudge_minipudge(thisEntity)
    if not IsValidAlive(unit) then
        return nil
    end

    -- 设置目标点位置
    if unit.__vTargetPosition == nil then
        if not IsValidAlive(unit.__vTarget) then
            unit.__vTarget = AIUtil:RandomPlayerHero()
        end
        unit.__vTargetPosition = unit.__vTarget:GetOrigin()
        unit.__flLastOrderTime = GameRules:GetGameTime()
        unit:MoveToPosition(unit.__vTargetPosition)
    end

    local now = GameRules:GetGameTime()
    -- 重置目标位置
    if (unit:GetOrigin() - unit.__vTargetPosition):Length2D() < 50
    or (now - unit.__flLastOrderTime) > RandomFloat(1, 2) then
        unit.__vTargetPosition = nil
        unit:AddNewModifier(unit,nil,"modifier_rooted",{Duration = 0.5})
    end

    return RandomFloat(0.03, 0.2)
end