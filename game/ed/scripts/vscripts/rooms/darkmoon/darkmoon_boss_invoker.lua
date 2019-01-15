-- 暗月来袭的最终BOSS的房间
--

local Room = class({}, nil, EDRoom)

Room.UniqueName = "DarkMoon_BossInvoker"

Room.SupportPlayers = {5,10} -- 支持5人和10人

Room.RoomType = RoomType.FinalBoss

Room.IsPlayable = false -- 暂时禁用这个房间

Room._nWeight = 100

function Room:OnPrepare()
	-- 创建对应的BOSS
	self._hBossInvoker = CreateUnitByName("npc_dota_creature_boss_invoker", Vector(0,0,0),true, nil, nil, DOTA_TEAM_NEUTRALS)
	Timer(function()
		-- 根据人数的不同，决定不同的难度
		-- 5人,10人
		-- 默认的血量是5人的血量，如果是10人的应该改为4倍
		-- 并每层增加10%
		local maxHealth = self._hBossInvoker:GetBaseMaxHealth()
		local damageMin = self._hBossInvoker:GetBaseDamageMin()
		local damageMax = self._hBossInvoker:GetBaseDamageMax()
		local currentLevel = GameRules.gamemode:GetCurrentLevel()
		local multipler = 1.2 ^ (currentLevel - 3)
		local atkMultipler = multipler
		if GameRules.gamemode:Is5Man() then
			multipler = multipler
		elseif GameRules.gamemode:Is10Man() then
			multipler = multipler * 4
		end

		self._hBossInvoker:SetBaseMaxHealth(maxHealth * multipler)
		self._hBossInvoker:SetHealth(maxHealth * multipler)

		-- 攻击力不应该增长为4倍，避免出现直接秒人的情况
		self._hBossInvoker:SetBaseDamageMax(damageMin * atkMultipler)
		self._hBossInvoker:SetBaseDamageMin(damageMin * atkMultipler)

		-- 显示BOSS的头像和血量条
		CustomGameEventManager:Send_ServerToAllClients("ed_show_boss_healthbar",{
			EntityIndex = self._hBossInvoker:GetEntityIndex(),
		})
	end)
end

function Room:GetWeight()
	-- 不会再第三层之前出现
	if GameRules.gamemode:GetCurrentLevel() < 3 then return 0 end
	return 100
end

function Room:CheckFinish()
	local boss = self._hBossInvoker
	if boss and not boss:IsNull() and boss:IsAlive() then
		return false
	else
		return true
	end
end

function Room:OnFinish()
	-- 给予奖励
end

return Room