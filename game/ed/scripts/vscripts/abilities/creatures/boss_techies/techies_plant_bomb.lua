techies_plant_bomb = class({})

LinkLuaModifier("modifier_techies_bomb_fuse", "modifiers/creatures/boss_techies/modifier_techies_bomb_fuse.lua", LUA_MODIFIER_MOTION_NONE)

function techies_plant_bomb:GetCooldown()
    if IsServer() then
        local caster             = self:GetCaster()
        caster.nSuicideLeapCount = caster.nSuicideLeapCount or 0
        return math.max(5 - caster.nSuicideLeapCount * 0.5, 3)
    end
end

function techies_plant_bomb:OnSpellStart()
    if IsServer() then

        local room   = GameRules.gamemode:GetCurrentRoom()

        local caster = self:GetCaster()

        local enemy  = AIUtil:RandomPlayerHero()

        if not enemy then
            return
        end

        -- 基础的炸弹数量
        local bomb_count_basic           = 2
        local bomb_explode_range         = 3
        -- 炸弹人毎进行过一次自杀攻击，炸弹的数量提升1，最多7个炸弹
        -- 毎进行过一次自杀攻击，炸弹的距离提升1，最多10距离
        local techies_suicide_leap_count = caster.nSuicideLeapCount
        local bomb_count                 = math.min(bomb_count_basic + techies_suicide_leap_count, 7)
        local explode_range              = math.min(bomb_explode_range + techies_suicide_leap_count, 10)
        local fuse_time                  = math.max(3 - techies_suicide_leap_count * 0.2, 2)

        -- 从敌人周围的25个网格中选择几个来放炸弹
        local coord_x, coord_y           = room:GetCellCoordAtPosition(enemy:GetOrigin())
        coord_x                          = (math.floor(coord_x / 2)) * 2
        coord_y                          = (math.floor(coord_y / 2)) * 2
        local random_coords              = {}
        for x = 2, 20, 2 do
            for y = 2, 12, 2 do
                if math.abs(coord_x - x) < 3 and math.abs(coord_y - y) < 3 then
                    table.insert(random_coords, { x, y })
                end
            end
        end

        local random_cells  = table.random_some(random_coords, bomb_count)
        local caster_origin = caster:GetOrigin()


        for _, cell in pairs(random_cells) do

            -- 创建炸弹并抛到对应的位置
            local target = room:GetCellCenterAtCoord(cell[1], cell[2])
            local bomb   = CreateUnitByName("npc_dota_creature_boss_techies_bomb", target, false, caster, caster, caster:GetTeamNumber())
            bomb:AddNewModifier(bomb, self, "modifier_techies_bomb_fuse", {
                fuse_time     = fuse_time,
                explode_range = explode_range
            })

            -- EmitSoundOn("Hero_Techies.RemoteMine.Plant",bomb)
            EmitSoundOn("Hero_Techies.RemoteMine.Detonate", bomb)
            bomb:AddNewModifier(bomb, self, "modifier_no_unit_collision", hModifierTable)
        end
    end
end