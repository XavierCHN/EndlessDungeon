module("AIThink", package.seeall)

function npc_dota_burning_forged_spirit(thisEntity)
	if not IsValidAlive(thisEntity) then return nil end

	local hero = thisEntity.hOwner

	if not hero then
		return 0.1
	end

	-- 总是想要移动到玩家前面，或者挡在最近的怪物之间
	local pos
	local origin = hero:GetOrigin()

	local enemy = AIUtil:NearestEnemyInRange(thisEntity)
	if enemy then
		-- local direction = (enemy:GetOrigin() - hero:GetOrigin()):Normalized()
		-- pos = origin + direction * 256
	end
	if not pos then
		local forward = hero:GetForwardVector()
		pos = forward * 256 + origin
	end

	if (thisEntity:GetOrigin() - origin):Length2D() > 1000 then
		thisEntity:SetOrigin(origin + hero:GetRightVector() + 200)
	else
		if (pos - thisEntity:GetOrigin()):Length2D() > 32 then
			thisEntity:MoveToPosition(pos)
		end
	end

	return 0.1
end