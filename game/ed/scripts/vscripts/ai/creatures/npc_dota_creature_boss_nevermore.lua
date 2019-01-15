module("AIThink", package.seeall) -- 所有的AI文件都用这一行开头，复制粘贴即可

-- local level  = GameRules.gamemode:GetCurrentLevel()
local SHADOW_RAZE_DELAY = 0.8
local SHADOW_RAZE_INTERVAL = 3
local SHADOW_RAZE_COUNT = 20
local REQUIEM_INTERVAL = 15

local function shadowRazeAtPosition(thisEntity, pos)
	local self = thisEntity
	local preParticle = ParticleManager:CreateParticle("particles/creatures/boss_pis/pis_raze_pre.vpcf",PATTACH_WORLDORIGIN,self)
	ParticleManager:SetParticleControl(preParticle, 0, pos)
	ParticleManager:ReleaseParticleIndex(preParticle)
	thisEntity:SetContextThink(DoUniqueString("raze"),function()
		local razeParticle = ParticleManager:CreateParticle("particles/creatures/boss_pis/boss_pis_shadow_raze.vpcf",PATTACH_WORLDORIGIN,self)
		ParticleManager:SetParticleControl(razeParticle, 0, pos)
		ParticleManager:ReleaseParticleIndex(razeParticle)

		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), pos, nil, 125, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, unit in pairs(units) do
			utilsDamage.DealDamagePercentage(thisEntity, unit, 20, nil)
		end

	end,SHADOW_RAZE_DELAY)
end

local function shadowRaze(thisEntity)

	local self = thisEntity

	self:StartGesture(ACT_DOTA_RAZE_3)

	self:SetContextThink(DoUniqueString("raze"),function()
		EmitSoundOn("Hero_Nevermore.Shadowraze",thisEntity)
	end,SHADOW_RAZE_DELAY)


	-- 随机位置的影压
	for i = 1, SHADOW_RAZE_COUNT do
		local randomPos = GetRandomPosition()
		-- 创建预警特效
		shadowRazeAtPosition(thisEntity, randomPos)
	end
	-- 必定在玩家脚下的影压
	local pos = AIUtil:RandomPlayerHero():GetOrigin()
	shadowRazeAtPosition(thisEntity, pos)
end

local function requiem(thisEntity)
	-- print("pis attempt to cast requiem")
	local self = thisEntity

	EmitSoundOn("Hero_Nevermore.RequiemOfSoulsCast",self)
	if self.nRequiemCount == nil then self.nRequiemCount = 5 end
	self.nRequiemCount = self.nRequiemCount + 1
	if self.nRequiemCount > 10 then self.nRequiemCount = 10 end

	if self.hRequiemAbility == nil then self.hRequiemAbility = self:FindAbilityByName("creature_nevermore_requiem") end
	self:StartGesture(ACT_DOTA_CAST_ABILITY_6)
	Timer(1.67, function()
		local target = AIUtil:RandomPlayerHero()
		EmitSoundOn("Hero_Nevermore.RequiemOfSouls",self)
		self.hRequiemAbility:Launch(target, self.nRequiemCount)
	end)
end

function npc_dota_creature_boss_nevermore(thisEntity)

	-- 影压，随机范围内，每0.5S一次，

	if not IsValidAlive(thisEntity) then return end

	local now = GameRules:GetGameTime()
	local self = thisEntity

	-- 如果可以放魂之挽歌，那么放魂之挽歌
	if self.flLastRequiemTime == nil then self.flLastRequiemTime = now - REQUIEM_INTERVAL end

	if now - self.flLastRequiemTime >= REQUIEM_INTERVAL then
		requiem(thisEntity)
		self.flLastRequiemTime = now
		return 2.67
	end

	if self.flLastShadowRazeTime == nil then self.flLastShadowRazeTime = now - 2 end

	if now - self.flLastShadowRazeTime >= SHADOW_RAZE_INTERVAL then
		shadowRaze(thisEntity)
		self.flLastShadowRazeTime = now
	end

	return 0.03
end
