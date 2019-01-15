-- 投石车环节
-- 单人在2个投石车
-- 5人在5个投石车
-- 10人在10个投石车的火力下存活60秒

local SURVIVE_TIME = 60

local Room = class({}, nil, EDRoom)

Room.RoomType = RoomType.Normal

Room.IsPlayable = true

Room.UniqueName = "DarkMoon_Catapult"

Room.SupportPlayers = {1,5,10}

Room._nWeight = 100

function Room:constructor()
end

function Room:OnPrepare()
	local catapultCount = 2
	local gamemode = GameRules.gamemode
	if gamemode:Is5Man() then catapultCount = 5
	elseif gamemode:Is10Man() then catapultCount = 10 end

	self._catapults = {}
	for i = 1, catapultCount do
		local catapult = CreateUnitByName("npc_xavier_catapult",GetRandomPositionInRoom(),true,nil,nil,DOTA_TEAM_NEUTRALS)
		table.insert(self._catapults, catapult)
	end
end

function Room:OnEnter()
	self._flSurviveStartTime = GameRules:GetDOTATime(true, true)

	for hero, _ in pairs(GameRules.gamemode:GetAllHeroes()) do
		FindClearSpaceForUnit(hero,GetRandomPositionInRoom(),true)
	end
end

function Room:OnExit()
end

function Room:CheckFinish()
	if GameRules:GetDOTATime() - self._flSurviveStartTime > SURVIVE_TIME then
		return true
	end
	return false
end

function Room:OnFinish()
end

return Room