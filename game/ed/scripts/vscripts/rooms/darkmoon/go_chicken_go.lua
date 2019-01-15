-- 奖励房间
--     小鸡快跑
-- 在房间中生成一个小鸡，小鸡会每隔3秒往随机方向跑，持续一分钟
-- 小鸡每次受到伤害就会掉落一个金袋，金袋将会给每个玩家7块钱

GoChickenGo = class({}, nil, EDRoom)

GoChickenGo.UniqueName = "DarkMoon_ChickenBonus" 

GoChickenGo.SupportPlayers = {1,5,10,25}

GoChickenGo.RoomType = RoomType.Bonus

GoChickenGo.IsPlayable = true

GoChickenGo._nWeight = 100

function GoChickenGo:constructor()
end

function GoChickenGo:OnPrepare()
	self.flChickenSpawnTime = GameRules:GetDOTATime(false,false)
	self.firstEntered = true
	self.hChicken = CreateUnitByName("npc_dota_creature_bonus_chicken",Vector(0,0,0),true,nil,nil,DOTA_TEAM_NEUTRALS)
end

function GoChickenGo:CheckFinish()
	local now = GameRules:GetDOTATime(false, false)
	if now - self.flChickenSpawnTime > 60 then
		return true
	end

	if not self.hChicken or not(IsValidEntity(self.hChicken) and self.hChicken:IsAlive()) then
		return true
	end

	return false
end

LinkLuaModifier("modifier_xavier_explosion_bomb","modifiers/generic/modifier_xavier_explosion_bomb.lua",LUA_MODIFIER_MOTION_NONE)

function GoChickenGo:OnFinish()
	-- 我是个坏人 xD
	-- 有30%概率会在移走的时候造一个炸弹并在0.5秒之后爆炸，对300范围内的生物造成当前层数*500的伤害
	if RollPercentage(30) then
		CreateModifierThinker(self.hChicken,nil,"modifier_xavier_explosion_bomb",{fuse_time = 0.5, radius = 800, damage = GameRules.gamemode:GetCurrentLevel() * 500},self.hChicken:GetAbsOrigin(),DOTA_TEAM_NEUTRALS,false)
	end
end

function GoChickenGo:OnEnter()
	-- 当玩家第二次进入出现过小鸡的房间时，有1%的概率再来一次
	-- 这个机会只有一次
	if not self.firstEntered then return end
	if self.secondEntered then
		return
	else
		self.secondEntered = true
	end

	if not RollPercentage(1) then return end
	
	self:OnPrepare() -- 让我们再来一只小鸡玩玩看吧！

	-- 这里手动开始之后，需要手动结束
	-- 这里就需要关门了
	Timer(60, function()
		self:OnFinish()
	end)
end

function GoChickenGo:OnExit()
	-- 这个为了避免的问题是，出现了第二只小鸡之后
	-- 玩家不打了，需要清除掉
	if self.hChicken and IsValidEntity(self.hChicken) and self.hChicken:IsAlive() then
		self.hChicken:ForceKill(false)
	end
end

return GoChickenGo