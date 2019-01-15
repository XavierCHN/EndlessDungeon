MusicPlayer = class({})

EDMusicState = {}
EDMusicState.Battle = 1 -- 1
EDMusicState.Boss = 2 -- 1
EDMusicState.Select = 3
EDMusicState.StartUp = 4
EDMusicState.BattleEnd = 5 -- 1
EDMusicState.Resting = 6 -- 1
EDMusicState.Killed = 7

-- 音乐列表
-- yaskar_01.music.ui_startup
-- yaskar_01.music.ui_main
-- yaskar_01.music.ui_hero_select
-- yaskar_01.music.countdown
-- yaskar_01.music.battle_end_countdown
-- yaskar_01.music.laning_01_layer_01
-- yaskar_01.music.laning_01_layer_02
-- yaskar_01.music.laning_01_layer_03
-- yaskar_01.music.laning_02_layer_01
-- yaskar_01.music.laning_02_layer_02
-- yaskar_01.music.laning_02_layer_03
-- yaskar_01.music.laning_03_layer_01
-- yaskar_01.music.laning_03_layer_02
-- yaskar_01.music.laning_03_layer_03
-- yaskar_01.music.battle_01
-- yaskar_01.music.battle_02
-- yaskar_01.music.battle_03
-- yaskar_01.music.battle_01_end
-- yaskar_01.music.battle_02_end
-- yaskar_01.music.battle_03_end
-- yaskar_01.music.roshan
-- yaskar_01.music.roshan_end
-- yaskar_01.music.smoke
-- yaskar_01.music.smoke_end_hero
-- yaskar_01.music.smoke_end_tower
-- yaskar_01.music.smoke_end_creep
-- yaskar_01.music.ganked_sml
-- yaskar_01.music.ganked_med
-- yaskar_01.music.ganked_lg
-- yaskar_01.music.killed

-- @param musicState 音乐状态
-- 可能是哪些值？
--    battle -- 进入了一个Normal房间
--    boss -- 进入了一个BOSS房间
--    select -- 信使选择状态
--    startup -- 信使选择完成之后
-- 如果state不发生改变，则不更换音乐
-- @param bForceStart 如果这个值设置为true，则会强制开始一首新音乐
-- 如果当前乐曲播放结束，也是使用这个参数来开始一首新音乐
function MusicPlayer:SetMusicState(musicState, bForceStart)
	if (self.musicState == musicState -- 状态一样，不显示
		or (musicState == EDMusicState.Battle and self.musicState == EDMusicState.StartUp) -- Battle不中断StartUp
		) and not bForceStart then
		return
	end
	
	local musicName
	self.musicState = musicState
	if musicState == EDMusicState.Battle then
		musicName = table.random({
			"battle_01",
			"battle_02",
			"battle_03",
		})
	end
	if musicState == EDMusicState.Boss then
		musicName = "roshan"
	end
	if musicState == EDMusicState.StartUp then
		musicName = "ui_startup"
	end
	if musicState == EDMusicState.Select then
		musicName = "ui_main"
	end
	if musicState == EDMusicState.Killed then
		musicName = "killed"
	end
	if musicState == EDMusicState.BattleEnd then
		if self.pszCurrentTrack == "battle_01" or 
			self.pszCurrentTrack == "battle_02" or
			self.pszCurrentTrack == "battle_03" then
			musicName = self.pszCurrentTrack .. "_end"
		end 
	end
	if musicState == EDMusicState.Resting then
		musicName = table.random({
			"laning_01_layer_01",
			"laning_01_layer_02",
			"laning_01_layer_03",
			"laning_02_layer_01",
			"laning_02_layer_02",
			"laning_02_layer_03",
			"laning_03_layer_01",
			"laning_03_layer_02",
			"laning_03_layer_03",
		})
	end

	print("music player begin to play music" , musicName)
	local musicPlayer = GameRules:GetGameModeEntity()
	if self.pszCurrentTrack ~= nil then 
		musicPlayer:StopSound("Rock." .. self.pszCurrentTrack)
	end
	if musicName ~= nil then
		-- 直接开始播放音乐
		-- 播放完成之后，递归播放
		musicPlayer:EmitSound("Rock." .. musicName)
		self.pszCurrentTrack = musicName
	end
	
	musicPlayer:SetContextThink(DoUniqueString("small_delay"),function()
		local duration = 0
		if musicName ~= nil then
			duration = musicPlayer:GetSoundDuration("Rock." .. musicName,nil) or 0
		end
		musicPlayer:SetContextThink(DoUniqueString(""),function()
			if musicState == EDMusicState.StartUp then
				musicState = EDMusicState.Battle
			end
			if musicState == EDMusicState.BattleEnd then
				musicState = EDMusicState.Resting
			end

			print(self.pszCurrentTrack, musicName)
			if self.pszCurrentTrack == musicName then
				self:SetMusicState(musicState, true)
			end
		end,duration)
	end,1)
end

GameRules.MusicPlayer = MusicPlayer()