local Room = class({}, nil, EDRoom)

Room.IsPlayable = true

Room.UniqueName = "slardar"

Room.SupportPlayers = { 1, 2, 3, 4 }

Room.RoomType = RoomType.FinalBoss

Room._nWeight = 100

Room.LevelRange = { 5, 5 }

function Room:constructor(room)
end

local function launchLightingBall(startingPos)
    local now = GameRules:GetGameTime()
    local center = GetCenter()
    local direction = (center - startingPos):Normalized()
    local length = (center - startingPos):Length2D()

    local pid = ParticleManager:CreateParticle("particles/econ/items/storm_spirit/storm_spirit_orchid_hat/stormspirit_orchid_ball_lightning.vpcf", PATTACH_WORLDORIGIN, nil)

    Timer(0.03, function()
        local _now = GameRules:GetGameTime()
        if _now - now >= 1 then
            ParticleManager:DestroyParticle(pid, true)
            ParticleManager:ReleaseParticleIndex(pid)
            return nil
        end

        local interval = _now - now
        local pos = startingPos + direction * length * interval

        ParticleManager:SetParticleControl(pid, 0, pos)
        ParticleManager:SetParticleControl(pid, 1, pos)
        return 0.03
    end)
end

function Room:OnPrepare()
    self.pszCurrentBossName = "npc_dota_creature_storm_spirit1"
    launchLightingBall(Vector(-128 * 15, -128 * 10, 300))
    Timer(1, function()
        self.hBoss = utilsCreatures.Create(self.pszCurrentBossName, GetCenter())
        EmitSoundOn("Hero_StormSpirit.BallLightning", self.hBoss)
        self.hBossHealthBarUnit = self.hBoss
    end)
end

function Room:CheckFinish()
    if self.pszCurrentBossName == "npc_dota_creature_storm_spirit1" and self.hBoss and not IsValidAlive(self.hBoss) then
        self.pszCurrentBossName = "npc_dota_creature_storm_spirit2"
        self.hBoss = nil
        -- 发射一个子弹
        GameRules:SendCustomMessage("#boss_speech_storm_spirit_buyback",2,-1)
        launchLightingBall(Vector(-128 * 15, 128 * 10, 300))
        Timer(1, function()
            self.hBoss = utilsCreatures.Create(self.pszCurrentBossName, GetCenter())
            EmitSoundOn("Hero_StormSpirit.BallLightning", self.hBoss)
            self.hBossHealthBarUnit = self.hBoss
        end)
        return false
    end
    if self.pszCurrentBossName == "npc_dota_creature_storm_spirit2" and self.hBoss and not IsValidAlive(self.hBoss) then
        self.pszCurrentBossName = "npc_dota_creature_storm_spirit3"
        self.hBoss = nil
        GameRules:SendCustomMessage("#boss_speech_storm_spirit_buyback",2,-1)
        launchLightingBall(Vector(128 * 15, 128 * 10, 300))
        Timer(1, function()
            self.hBoss = utilsCreatures.Create(self.pszCurrentBossName, GetCenter())
            EmitSoundOn("Hero_StormSpirit.BallLightning", self.hBoss)
            self.hBossHealthBarUnit = self.hBoss
        end)
        return false
    end
    if self.pszCurrentBossName == "npc_dota_creature_storm_spirit3" and self.hBoss and not IsValidAlive(self.hBoss) then
        self.pszCurrentBossName = "npc_dota_creature_storm_spirit"
        self.hBoss = nil
        GameRules:SendCustomMessage("#boss_speech_storm_spirit_buyback",2,-1)
        launchLightingBall(Vector(128 * 15, -128 * 10, 300))
        Timer(1, function()
            self.hBoss = utilsCreatures.Create(self.pszCurrentBossName, GetCenter())
            EmitSoundOn("Hero_StormSpirit.BallLightning", self.hBoss)
            self.hBossHealthBarUnit = self.hBoss
        end)
        return false
    end
    if self.pszCurrentBossName == "npc_dota_creature_storm_spirit" and self.hBoss and not IsValidAlive(self.hBoss) then
        self.hBoss = nil
        self.pszCurrentBossName = "brewmaster_three_spirits"
        Timer(2, function()
            self.hBoss1 = utilsCreatures.Create("npc_dota_creature_brewmaster_wind", GetCenter() + Vector(-200,0,0))
            self.hBoss2 = utilsCreatures.Create("npc_dota_creature_brewmaster_fire", GetCenter() + Vector(0,0,0))
            self.hBoss3 = utilsCreatures.Create("npc_dota_creature_brewmaster_earth", GetCenter() + Vector(200,0,0))
        end)
    end
    if self.pszCurrentBossName == "brewmaster_three_spirits" and self.hBoss1 and self.hBoss2 and self.hBoss3 and
    not IsValidAlive(self.hBoss1) and not IsValidAlive(self.hBoss2) and not IsValidAlive(self.hBoss3) then
        self.hBoss = nil
        self.pszCurrentBossName = "npc_dota_creature_slardar"
        Timer(2, function()
            self.hBoss = utilsCreatures.Create(self.pszCurrentBossName, GetCenter())
            self.hBossHealthBarUnit = self.hBoss
        end)
    end
    if self.pszCurrentBossName and self.pszCurrentBossName == "npc_dota_creature_slardar" and self.hBoss and not IsValidAlive(self.hBoss) then
        return true
    end
    return false
end

return Room