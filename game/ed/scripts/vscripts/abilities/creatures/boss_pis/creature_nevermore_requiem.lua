creature_nevermore_requiem = class({})

function creature_nevermore_requiem:Launch(target, lineCount)

	local targetPosition = target:GetAbsOrigin()
	local selfOrigin = self:GetCaster():GetAbsOrigin()
	local angleDiff = 360 / lineCount
	local originalDirection = (targetPosition - selfOrigin):Normalized()

	for i = 1, lineCount do

		local direction = RotatePosition(Vector(0,0,0),QAngle(0, i * angleDiff, 0),originalDirection)

		local info       = {
			EffectName       = "",
			Ability          = self,
			vSpawnOrigin     = selfOrigin,
			Source           = self:GetCaster(),
			fDistance        = 2000,
			fStartRadius     = 64,
			fEndRadius       = 64,
			bHasFrontalCone  = true,
			bReplaceExisting = false,
			iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime      = GameRules:GetGameTime() + 10.0,
			vVelocity        = direction * 1000,
		}

		-- DebugDrawLine(selfOrigin,selfOrigin + direction * 800,255,0,0,false,5)

		ProjectileManager:CreateLinearProjectile(info)

		-- 创建一个假的的特效
		local caster = self:GetCaster()
		local requiemPartile = ParticleManager:CreateParticle("particles/creatures/boss_pis/boss_pis_requiem_line.vpcf",PATTACH_WORLDORIGIN,caster)
		ParticleManager:SetParticleControl(requiemPartile,0,selfOrigin)
		ParticleManager:SetParticleControl(requiemPartile,1,direction * 1000)
		Timer(3, function()
			ParticleManager:ReleaseParticleIndex(requiemPartile)
		end)

		-- 如果没有到达上限的话，那么创建对应的小树人
		if caster.vTreants == nil then caster.vTreants = {} end
		local treantCount = 0
		for _, treant in pairs(caster.vTreants) do
			if IsValidAlive(treant) then
				treantCount = treantCount + 1
			end
		end

		local maxTreantCount = math.min(lineCount - 3, 7)
		for i = treantCount, maxTreantCount - 1 do
			local treant = utilsCreatures.Create("npc_dota_nevermore_requiem_treant", selfOrigin + RandomVector(RandomFloat(100, 600)))
			table.insert(caster.vTreants, treant)
		end
	end
end

function creature_nevermore_requiem:OnProjectileHit(target,loc)
	if IsServer() then
		if target then
			--print("projectile hit")
			-- 对目标造成20%伤害
			utilsDamage.DealDamagePercentage(self:GetCaster(), target, 20, nil)
		end
	end
end