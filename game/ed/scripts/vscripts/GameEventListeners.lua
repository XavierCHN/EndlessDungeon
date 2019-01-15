function CEDGameMode:OnGameRulesStateChange()
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		Timer(0.5, function()
			-- GameRules.MusicPlayer:SetMusicState(EDMusicState.Select)
		end)
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

	end
end


function CEDGameMode:OnNpcSpawned(event)
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:GetClassname() == 'npc_dota_thinker' or spawnedUnit:IsPhantom() then
		return
	end

	spawnedUnit:AddNewModifier(spawnedUnit,nil,'modifier_movespeed_no_limit',{}) -- 移动速度无限制

	if spawnedUnit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		spawnedUnit:SetForwardVector(Vector(0,-1,0))

		-- 所有单位不允许攻击	
		if spawnedUnit:IsRangedAttacker() then
			spawnedUnit:AddNewModifier(spawnedUnit,nil,'modifier_disarmed',{})
		end
		-- 受到伤害的检测
		spawnedUnit:AddNewModifier(spawnedUnit,nil,"modifier_creature_damage_tracker",{})

		-- 远程使用弹道
		if spawnedUnit:IsRangedAttacker() then
			if not spawnedUnit:FindAbilityByName('creature_attack') then
				spawnedUnit:AddAbility('creature_attack')
				local a = spawnedUnit:FindAbilityByName('creature_attack')
				if a then a:SetLevel(1) end
			end
		end
	end

	-- 启动AI，自己方的小怪只要有AI的也可以启动
	local unitName = spawnedUnit:GetUnitName()
	if AIThink[unitName] then
		spawnedUnit.AIThink = AIThink[unitName]
	else
		if spawnedUnit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
			if spawnedUnit:IsRangedAttacker() then
				spawnedUnit.AIThink = AIThink.GenericRangedAIThink
			else
				spawnedUnit.AIThink = AIThink.GenericMeleeAIThink
			end
		end
	end
	if spawnedUnit.AIThink then
		spawnedUnit:SetContextThink(unitName,function()
			return spawnedUnit:AIThink()
		end,RandomFloat(0,1))
	end

	

	-- 英雄相位状态
	if spawnedUnit:IsRealHero() then
		-- 2017.03.06 为了制作trap方便，觉得还是不要给相位状态好
		-- spawnedUnit:AddNewModifier(spawnedUnit,nil,'modifier_no_unit_collision',{}) -- 相位状态
		spawnedUnit:AddNewModifier(spawnedUnit,nil,'modifier_ignore_cast_angle',{}) -- 无视施法角度
	end
end

function CEDGameMode:OnHeroInGame(hero)
	if not hero._bInited then
		hero._bInited = true

		-- 初始化英雄

		-- 升级
		while (hero:GetLevel() < 25) do
			hero:HeroLevelUp(false)
		end

		-- 设置技能等级
		for i = 0, 15 do
			local ability = hero:GetAbilityByIndex(i)
			if ability then
				ability:SetLevel(1)
			end
		end

		-- 取消技能点
		hero:SetAbilityPoints(0)

		-- 修正属性附加值
		hero:AddNewModifier(hero,nil,'modifier_attribute_fix',{})
	end
end

function CEDGameMode:OnEntityKilled(keys)

	local entityKilled = EntIndexToHScript(keys.entindex_killed)
	if entityKilled and entityKilled:IsRealHero() and entityKilled:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
	end
end
