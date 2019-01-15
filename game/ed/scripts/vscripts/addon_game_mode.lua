--------------------------------------------------------------
--------------------------------------------------------------
---       谨以此作，纪念那些年玩过的的DOTA和逝去的青春            ---
---               2017.05.17 XavierCHN                     ---
--------------------------------------------------------------
--------------------------------------------------------------

print("Loading all your memories of dota...")

local _print = print
function print(...)
	if IsInToolsMode() then
		_print(...)
	end
end

-------------------------------------------------------------------------------------------------------------
-- 初始化游戏模式
-------------------------------------------------------------------------------------------------------------
if CEDGameMode == nil then
	_G.CEDGameMode = class({})
end

-------------------------------------------------------------------------------------------------------------
-- 载入KV数据
-------------------------------------------------------------------------------------------------------------
GameRules.Heroes_KV = LoadKeyValues('scripts/npc/npc_heroes_custom.txt')
GameRules.Items_KV = LoadKeyValues('scripts/npc/npc_items_custom.txt')
GameRules.Units_KV = LoadKeyValues('scripts/npc/npc_units_custom.txt')
GameRules.Abilities_KV = LoadKeyValues('scripts/npc/npc_abilities_custom.txt')
GameRules.Bullets_KV = LoadKeyValues('scripts/npc/bullet_defination.txt')
GameRules.DotaItems_KV = LoadKeyValues("scripts/npc/items.txt")
GameRules.OverrideAbility_KV = LoadKeyValues("scripts/npc/npc_abilities_override.txt")

-------------------------------------------------------------------------------------------------------------
-- 类似于python中的文件载入机制
-- 使用一个文件夹中的_loader载入文件夹中的所有需要载入的文件
-- 这个函数当然会同时运行_loader中的所有语句
-- path表示文件夹
-------------------------------------------------------------------------------------------------------------
function xrequire(path)
	local files = require(path .. '._loader')
	if not files then
		error('xrequire Failed to load' .. path)
	end

	if files and type(files) == 'table' then
		for _, file in pairs(files) do
			-- print('xrequire loading', path .. '.' .. file)
			require(path .. '.' .. file)
		end
	elseif files and not type(files) == 'table' then
		print(path, 'doesnt return a table contains files to require, ignoring!!!!')
	end
end

-------------------------------------------------------------------------------------------------------------
-- 载入所有的模块
-------------------------------------------------------------------------------------------------------------
require 'Enums' -- 枚举
require 'Constants' -- 常量
require 'libraries.notifications' -- 提醒
require 'DropList_Item' -- 物品掉落列表
require 'DropList_Ability' -- 技能掉落列表
require 'Precache'
require 'Bullet'
require 'MusicPlayer'
require 'Disconnect'

xrequire 'utils' -- 各种工具模块
xrequire 'ai' -- 各种AI模块
xrequire 'rooms' -- 所有的随机房间
xrequire 'couriers' -- 各种信使
xrequire 'econ' -- 与金钱有关的模块

xrequire 'modifiers' -- 所有的modifier

require 'Debug' -- 调试模块
require 'GameEventListeners' -- 官方事件监听
require 'Filters'
require 'UIEventListener' -- UI事件监听
require 'EDEventListener' -- 自定义事件监听
require 'GeneralBonus' -- 技能掉落列表
require 'PlayerActions' -- 处理左右键和WASD移动


if IsInToolsMode() then
	local msg, ok = pcall(require, 'test')
	print('Test', msg, ok)
end

-------------------------------------------------------------------------------------------------------------
-- Activate
-------------------------------------------------------------------------------------------------------------
function Activate()
	-- 和实体有关的东西，或者不需要经常重载的
	require 'Door' -- 门
	require 'Room' -- 房间
	require 'Map' -- 地图

	GameRules.gamemode = CEDGameMode()
	GameRules.gamemode:InitGameMode()
end

function Precache( context )
	PrecacheEverythingFromKV(context)
	for _,Item in pairs( g_ItemPrecache ) do
		PrecacheItemByNameSync( Item, context )
	end
	for _,Unit in pairs( g_UnitPrecache ) do
		PrecacheUnitByNameAsync( Unit, function( unit ) end )
	end
	for _,Model in pairs( g_ModelPrecache ) do
		PrecacheResource( "model", Model, context  )
	end
	for _,Particle in pairs( g_ParticlePrecache ) do
		PrecacheResource( "particle", Particle, context  )
	end
	for _,ParticleFolder in pairs( g_ParticleFolderPrecache ) do
		PrecacheResource( "particle_folder", ParticleFolder, context )
	end
	for _,Sound in pairs( g_SoundPrecache ) do
		PrecacheResource( "soundfile", Sound, context )
	end
end

-------------------------------------------------------------------------------------------------------------
-- Init
-------------------------------------------------------------------------------------------------------------
function CEDGameMode:InitGameMode()

	self._nCurrentLevel = 0 -- 当前的层数

	SendToServerConsole('dota_max_physical_items_purchase_limit 9999')
	SendToServerConsole('dota_music_battle_enable 0')

	GameRules:SetCustomGameSetupTimeout(0)
	GameRules:SetCustomGameSetupAutoLaunchDelay(0)
	GameRules:SetHeroRespawnEnabled(false)
	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetUseUniversalShopMode(true)
	GameRules:SetStrategyTime(0)
	GameRules:SetShowcaseTime(0)
	GameRules:SetPreGameTime(15)
	GameRules:SetPostGameTime(30)
	GameRules:SetTreeRegrowTime(300)
	GameRules:SetHeroMinimapIconScale(0.7)
	GameRules:SetCreepMinimapIconScale(0.7)
	GameRules:SetRuneMinimapIconScale(0.7)
	GameRules:SetGoldTickTime(60)
	GameRules:SetGoldPerTick(0)
	GameRules:SetStartingGold(100)

	local gamemode = GameRules:GetGameModeEntity()
	gamemode:SetRemoveIllusionsOnDeath(true)
	gamemode:SetDaynightCycleDisabled(true)
	gamemode:SetFogOfWarDisabled(true)
	gamemode:SetCameraDistanceOverride(1800)
	gamemode:SetAnnouncerDisabled(true)
	gamemode:SetCustomGameForceHero('npc_dota_hero_sniper')
	gamemode:SetThink( 'OnThink', self, 0.25 )
	gamemode:SetDamageFilter(Dynamic_Wrap(CEDGameMode, "DamageFilter"), self)

	gamemode:SetUnseenFogOfWarEnabled(true)

	-- 加快debug进度
	if IsInToolsMode() then
		self:EnterDebugMode()
	end

	-- 根据地图的不同，设置玩家的数量
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)

	self._vAllPlayers = {}
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 4)
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		PlayerResource:SetCustomTeamAssignment( nPlayerID, DOTA_TEAM_GOODGUYS )
	end

	-- 事件监听
	ListenToGameEvent('game_rules_state_change',Dynamic_Wrap(CEDGameMode, 'OnGameRulesStateChange'),self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(CEDGameMode, 'OnDisconnect'), self)
	ListenToGameEvent('player_reconnected', Dynamic_Wrap(CEDGameMode, 'OnPlayerReconnect'), self)
	ListenToGameEvent('player_chat', Dynamic_Wrap(CEDGameMode, '_DebugChatCommand'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(CEDGameMode, 'OnNpcSpawned') ,self)
	ListenToGameEvent('entity_killed',Dynamic_Wrap(CEDGameMode, 'OnEntityKilled'),self)

	-- 一些自定义的参数
	self._vAllHeroes = {}
	self._vAllPlayers = {}

	-- PUI方面的事件监听
	self:_RegisterCustomGameEventListeners()

end

-------------------------------------------------------------------------------------------------------------
-- 创建大地图并进入第一个房间（位于坐标0，0）
-------------------------------------------------------------------------------------------------------------
function CEDGameMode:EnterNextLevel()
	self._nCurrentLevel = self._nCurrentLevel + 1
	self._vCurrentMap = Map()
	self._vCurrentMap:GetStartRoom():EnterRoom()

	if self._nCurrentLevel ~= 1 then
		CustomGameEventManager:Send_ServerToAllClients('ed_player_entering_new_level',{NewLevel = self._nCurrentLevel})
	end
end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
function CEDGameMode:GetPlayerCount()
	return table.count(self._vAllHeroes)
end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
function CEDGameMode:OnThink()
	if GameRules:IsDaytime() then
		GameRules:SetTimeOfDay(0.751)
	end

	-- 检测英雄并储存
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			-- if PlayerResource:HasSelectedHero( nPlayerID ) then
			local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hero then
				self._vAllHeroes[hero] = self._vAllHeroes[hero] or {}
				self:OnHeroInGame(hero)
			end
			-- end
		end

		local player = PlayerResource:GetPlayer(nPlayerID)
		if player then
			self._vAllPlayers[player] = true
			-- Timers:CreateTimer(0.03, function()
			-- 	player:SetMusicStatus(0,1)
			-- 	return 0.03
			-- end)
		end
	end

	return 0.25
end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
function CEDGameMode:_RefreshPlayers()
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if not hero:IsAlive() then
					local vLocation = hero:GetOrigin()
					hero:RespawnHero( false, false, false )
					FindClearSpaceForUnit( hero, vLocation, true )
				end
				hero:SetHealth( hero:GetMaxHealth() )
				hero:SetMana( hero:GetMaxMana() )
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
function CEDGameMode:_PlacePlayersAroundPosition(pos)
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				FindClearSpaceForUnit(hero,pos + RandomVector(RandomFloat(0, 300)),true)
			end
		end
	end
end


-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
function CEDGameMode:_DebugShowDoor(cmdName)
	local room = self._vCurrentRoom
	local doors = room:GetDoors()
	for _, door in pairs(doors) do
		door:Show()
		Timer(10, function()
			door:Hide()
		end)
	end
end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
function CEDGameMode:GetCurrentLevel()
	return self._nCurrentLevel
end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
function CEDGameMode:GetCurrentMap()
	return self._vCurrentMap
end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
function CEDGameMode:GetCurrentRoom()
	return self._vCurrentRoom
end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
function CEDGameMode:SetCurrentRoom(room)
	self._vCurrentRoom = room
end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
function CEDGameMode:GetAllHeroes()
	local heroes = {}
	for hero in pairs(self._vAllHeroes) do
		if not hero._bIsDisconnected then
			table.insert(heroes, hero)
		end
	end
	return heroes
end

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
function CEDGameMode:GetAllPlayers()
	return table.make_key_table(self._vAllPlayers)
end