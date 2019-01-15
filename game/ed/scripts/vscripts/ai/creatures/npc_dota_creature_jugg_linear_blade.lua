module("AIThink", package.seeall) -- 所有的AI文件都用这一行开头，复制粘贴即可

function npc_dota_creature_jugg_linear_blade(thisEntity)

    if not IsValidAlive(thisEntity) then
        return nil
    end

    if not thisEntity.bInitialized then
        thisEntity.bInitialized = true
        local enemy             = AIUtil:RandomPlayerHero()
        if enemy then
            thisEntity.vTargetDirection = (enemy:GetOrigin() + RandomVector(200) - thisEntity:GetOrigin()):Normalized()
        end
        return 0.03
    end

    if thisEntity.vTargetPosition == nil then
        thisEntity.vTargetPosition = thisEntity.vTargetDirection * 200 + thisEntity:GetOrigin()
        thisEntity:MoveToPosition(thisEntity.vTargetPosition)
    end

    if (thisEntity:GetOrigin() - thisEntity.vTargetPosition):Length2D() < 30 then
        thisEntity.vTargetPosition = nil
    end


    return 0.03
end