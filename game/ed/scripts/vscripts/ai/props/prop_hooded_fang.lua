module("AIThink", package.seeall)

function prop_hooded_fang(thisEntity)
    local enemy = AIUtil:RandomPlayerHeroInRange(thisEntity, 300)

    if enemy then
        -- 判断敌方所在的方向（四个方向之一）
        local eo = enemy:GetOrigin()
        local so = thisEntity:GetOrigin()
        local dx = (eo.x - so.x)
        local dy = (eo.y - so.y)
        local fw
        if (math.abs(dx) > math.abs(dy)) then
            -- 左右
            if dx >= 0 then
                fw = Vector(1, 0, 0)
            else
                fw = Vector(- 1, 0, 0)
            end
        else
            if dy >= 0 then
                fw = Vector(0, 1, 0)
            else
                fw = Vector(0, - 1, 0)
            end
        end

        thisEntity:SetForwardVector(fw)

        thisEntity.b_PreparedToFirebreath = true

        local fire_breath                 = thisEntity:FindAbilityByName("hooded_fang_venomous_gale")
        thisEntity:CastAbilityNoTarget(fire_breath, - 1)
        return RandomFloat(2, 3)
    end

    return 0.1
end