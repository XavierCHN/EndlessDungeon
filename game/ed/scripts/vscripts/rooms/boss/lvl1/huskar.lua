local Room           = class({}, nil, EDRoom)

Room.IsPlayable      = true

Room.UniqueName      = "Huskar"

Room.SupportPlayers  = { 1, 2, 3, 4 }

Room.RoomType        = RoomType.FinalBoss

Room._nWeight        = 100

Room.LevelRange = {1,1}

function Room:constructor(room)
    self.room    = room
    self.hBossHuskar = nil
end

function Room:OnPrepare()

    -- 在房间正中间刷新一个clinkz
    local spawnLocation = GetCenter()
    self.hBossHuskar        = utilsCreatures.Create("npc_dota_creature_huskar", spawnLocation)
    self.hBossHealthBarUnit = self.hBossHuskar
    self.hBossHuskar.__bCannotKnockback__ = true
end

function Room:CheckFinish()
    if IsValidAlive(self.hBossHuskar) then
        return false
    end
    return true
end

function Room:OnEnter()
    for _, hero in pairs(GameRules.gamemode:GetAllHeroes()) do
        hero:AddAbility("huskar_shadow_raze")
        hero:FindAbilityByName("huskar_shadow_raze"):SetLevel(1)
        hero:SwapAbilities("huskar_shadow_raze", "ed_empty4", true, false)
        hero:FindAbilityByName("ed_empty4"):SetHidden(true)
    end
end

function Room:OnExit()
    for _, hero in pairs(GameRules.gamemode:GetAllHeroes()) do
        hero:SwapAbilities("ed_empty4","huskar_shadow_raze", true, false)
        hero:FindAbilityByName("ed_empty4"):SetHidden(false)
        hero:RemoveAbility("huskar_shadow_raze")
    end
end

return Room