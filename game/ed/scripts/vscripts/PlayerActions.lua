local upVector    = Vector(0, 1, 0)
local downVector  = Vector(0, - 1, 0)
local leftVector  = Vector(- 1, 0, 0)
local rightVector = Vector(1, 0, 0)
local function createMovingTimer(hero)
    if hero.m_MovingTimer then
        return
    end
    hero.m_MovingTimer = Timer(function()

        if not (IsValidEntity(hero) and hero:IsAlive()) then
            hero.bMovingUp    = false
            hero.bMovingDown  = false
            hero.bMovingLeft  = false
            hero.bMovingRight = false
            return 0.03
        end

        local movingVector = Vector(0, 0, 0)
        if hero.bMovingUp then
            movingVector = movingVector + upVector
        end
        if hero.bMovingDown then
            movingVector = movingVector + downVector
        end
        if hero.bMovingLeft then
            movingVector = movingVector + leftVector
        end
        if hero.bMovingRight then
            movingVector = movingVector + rightVector
        end
        movingVector = movingVector:Normalized()

        if movingVector.x == 0 and movingVector.y == 0 then
        else
            if not hero.b_HasMotionController
            and not hero:IsStunned()
            then
                hero:SetForwardVector(movingVector)
                ExecuteOrderFromTable({
                                          UnitIndex = hero:entindex(),
                                          OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                                          Position  = hero:GetOrigin() + movingVector * 32
                                      })
            else
                hero:Stop()
            end
        end
        return 0.03
    end)
end

function CEDGameMode:On_ed_player_start_move_up(keys)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    if not player then
        return
    end
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end

    if not (IsValidEntity(hero) and hero:IsAlive()) then
        hero.bMovingUp = false
        ShowError("ed_hud_error_cannot_move", keys.PlayerID)
        return
    end

    if not hero.m_MovingTimer then
        createMovingTimer(hero)
    end

    hero.bMovingUp = true
end
function CEDGameMode:On_ed_player_start_move_down(keys)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    if not player then
        return
    end
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end

    if not (IsValidEntity(hero) and hero:IsAlive()) then
        hero.bMovingDown = false
        ShowError("ed_hud_error_cannot_move", keys.PlayerID)
        return
    end

    if not hero.m_MovingTimer then
        createMovingTimer(hero)
    end

    hero.bMovingDown = true
end
function CEDGameMode:On_ed_player_start_move_left(keys)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    if not player then
        return
    end
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end

    if not (IsValidEntity(hero) and hero:IsAlive()) then
        hero.bMovingLeft = false
        ShowError("ed_hud_error_cannot_move", keys.PlayerID)
        return
    end

    if not hero.m_MovingTimer then
        createMovingTimer(hero)
    end

    hero.bMovingLeft = true
end
function CEDGameMode:On_ed_player_start_move_right(keys)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    if not player then
        return
    end
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end

    if not (IsValidEntity(hero) and hero:IsAlive()) then
        hero.bMovingRight = false
        ShowError("ed_hud_error_cannot_move", keys.PlayerID)
        return
    end

    if not hero.m_MovingTimer then
        createMovingTimer(hero)
    end

    hero.bMovingRight = true
end
function CEDGameMode:On_ed_player_end_move_up(keys)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    if not player then
        return
    end
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end

    if not (IsValidEntity(hero) and hero:IsAlive()) then
        hero.bMovingUp = false
        ShowError("ed_hud_error_cannot_move", keys.PlayerID)
        return
    end

    if not hero.m_MovingTimer then
        createMovingTimer(hero)
    end

    hero.bMovingUp = false
end
function CEDGameMode:On_ed_player_end_move_down(keys)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    if not player then
        return
    end
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end

    if not (IsValidEntity(hero) and hero:IsAlive()) then
        hero.bMovingDown = false
        ShowError("ed_hud_error_cannot_move", keys.PlayerID)
        return
    end

    if not hero.m_MovingTimer then
        createMovingTimer(hero)
    end

    hero.bMovingDown = false
end
function CEDGameMode:On_ed_player_end_move_left(keys)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    if not player then
        return
    end
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end

    if not (IsValidEntity(hero) and hero:IsAlive()) then
        hero.bMovingLeft = false
        ShowError("ed_hud_error_cannot_move", keys.PlayerID)
        return
    end

    if not hero.m_MovingTimer then
        createMovingTimer(hero)
    end

    hero.bMovingLeft = false
end
function CEDGameMode:On_ed_player_end_move_right(keys)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    if not player then
        return
    end
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end

    if not (IsValidEntity(hero) and hero:IsAlive()) then
        hero.bMovingRight = false
        ShowError("ed_hud_error_cannot_move", keys.PlayerID)
        return
    end

    if not hero.m_MovingTimer then
        createMovingTimer(hero)
    end

    hero.bMovingRight = false
end

function CEDGameMode:On_ed_player_update_mouse_position(keys)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    if not player then
        return
    end
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end

    hero.m_MousePosition = Vector(keys.x, keys.y, keys.z)
end

local function _createHeroMouseAbilityTimer(hero)
    Timer(0, function()
        if IsValidAlive(hero) then
            if hero.bLeftMouseDown then
                local leftMouseAbility = CourierUtil:GetLeftMouseAbility(hero)
                if leftMouseAbility and leftMouseAbility.OnMouseDown and leftMouseAbility:IsFullyCastable() then
                    leftMouseAbility:OnMouseDown()
                end
            end
            if hero.bRightMouseDown then
                local rightMouseAbility = CourierUtil:GetRightMouseAbility(hero)
                if rightMouseAbility and rightMouseAbility.OnMouseDown and rightMouseAbility:IsFullyCastable() then
                    rightMouseAbility:OnMouseDown()
                end
            end
        end
        return 0.03
    end)
end

function CEDGameMode:On_ed_player_left_mouse_down(keys)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    if not player then
        return
    end
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end

    hero.bLeftMouseDown = true

    if not hero.bMouseAbilityTimerCreated then
        hero.bMouseAbilityTimerCreated = true
        _createHeroMouseAbilityTimer(hero)
    end
end
function CEDGameMode:On_ed_player_left_mouse_up(keys)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    if not player then
        return
    end
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end

    hero.bLeftMouseDown = false
end
function CEDGameMode:On_ed_player_right_mouse_down(keys)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    if not player then
        return
    end
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end

    hero.bRightMouseDown = true
    if not hero.bMouseAbilityTimerCreated then
        hero.bMouseAbilityTimerCreated = true
        _createHeroMouseAbilityTimer(hero)
    end
end
function CEDGameMode:On_ed_player_right_mouse_up(keys)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    if not player then
        return
    end
    local hero = player:GetAssignedHero()
    if not hero then
        return
    end

    hero.bRightMouseDown = false
end