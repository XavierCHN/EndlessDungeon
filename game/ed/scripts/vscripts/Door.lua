-- 从地图中获取门的位置


if Door == nil then
    Door = class({})
end

function Door:constructor()
end

-- 门的类型
-- 根据所通向的房间的类型来决定
--
-- 有的房间门是带锁的，需要钥匙来打开
-- 如果所有的玩家都在门的位置集合
-- 同时有玩家使用身上的钥匙，则可以打开房门
-- 要注意的是，通往所有BOSS房间的门都不会带锁
-- 
function Door:constructor(direction, targetRoom)
    self.locked = false
    if targetRoom then
        self.type = targetRoom:GetRoomType() -- 根据要去的目标房间的类型决定门的类型
    end
    self.direction    = direction
    self._bExploded   = false -- 隐藏的门是否已经被探索到
    self._np          = - 1 -- 门的粒子特效

    self._vTargetRoom = targetRoom

    if direction and direction == "up" or direction == "down" then
        self.vWallDirection = Vector(0, 1, 0)
        self.vWallRight     = Vector(128, 0, 0)
    else
        self.vWallDirection = Vector(1, 0, 0)
        self.vWallRight     = Vector(0, 128, 0)
    end
end

function Door:Explode()
    self._bExploded = true
end

function Door:GetDirection()
    return self.direction
end

function Door:SetType(type)
    self.type = type
end

function Door:GetType()
    return self.type
end

function Door:SetOrigin(origin)
    self.origin = origin
end

function Door:Show()
    -- 当玩家进入一个房间，显示出所有的门
    -- 根据不同的门创建不同的粒子特效
    self:_DestroyParticle()
    self:_CreateDoorParticle()

    -- 当一个房间门被显示出来的时候
    -- 如果他没有被锁起来或者不是一个隐藏的门，那么设置为可以进入
    -- type = nil代表这个门是一个空的门

    -- 如果需要移除挡门的石头，那么移除
    if self._bLocked or (self.type == RoomType.Hidden and not self._bExploded ) or self.type == nil then
        -- 否则就挡住
    else
        -- 移除挡门的石头
        -- 挡门的石头用四个实体？
        -- 为了避免出现视觉的错误，是否能进门使用挡门的石头
        -- 是否在堵住门的位置来表示
        -- 暂时不做挡门的了
        --if self.direction then -- 没有direction的门就是进入下一层的门
        --    local blocker = Entities:FindByName(nil,"door_blocker_" .. self.direction)
        --    if not blocker.vOriginalPosition then
        --        blocker.vOriginalPosition = blocker:GetOrigin()
        --    end
        --    blocker:SetOrigin(Vector(9999,9999,0))
        --end
        self._bCanEnter = true
    end
end

function Door:IsUnitEnteringDoor(unit)
    local origin = unit:GetOrigin()
    local x, y = origin.x, origin.y
    local mx, my = self.origin.x, self.origin.y
    local dir = self.direction
    if dir == "up" then
        if math.abs(x - mx) < 128 and y >= my - 64 then
            return true
        end
    end
    if dir == "down" then
        if math.abs(x-mx) < 128 and y <= my + 64 then
            return true
        end
    end
    if dir == "left" then
        if math.abs(y-my) < 128 and x <= mx + 64 then
            return true
        end
    end
    if dir == "right" then
        if math.abs(y-my) < 128 and x >= mx - 64 then
            return true
        end
    end
    return false
end

-- 堵住门
function Door:Block()
    --if self.direction then
    --    local blocker = Entities:FindByName(nil,"door_blocker_" .. self.direction)
    --    blocker.vOriginalPosition = blocker.vOriginalPosition or blocker:GetOrigin()
    --    blocker:SetOrigin(blocker.vOriginalPosition)
    --end
    self:_DestroyParticle()
    self._bCanEnter = false
end

function Door:Unlock()
    self._bLocked = false
    -- 将粒子锁的粒子特效删除
    self:_DestroyParticle()
    self:_CreateDoorParticle()
end

function Door:Lock()
    self._bLocked = true
    self:_DestroyParticle()
    self:_CreateDoorParticle()
end

function Door:_DestroyParticle()
    if self._np then
        ParticleManager:DestroyParticle(self._np, true)
        ParticleManager:ReleaseParticleIndex(self._np)
        self._np = nil
    end
end

function Door:_CreateDoorParticle()
    if self._np then
        self:_DestroyParticle()
    end

    -- 如果是隐藏的门而且没有被探索到，那么不显示
    if (self.type == RoomType.Hidden and not self._bExploded) or self.type == nil then
        return
    end

    local doorParticleNames = {
        [- 1]                = "particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5.vpcf", -- 进入下一层的门
        [RoomType.Normal]    = 'particles/generic/doors/normal_door.vpcf',
        [RoomType.Hidden]    = 'particles/generic/doors/normal_door.vpcf',
        [RoomType.Start]     = 'particles/generic/doors/normal_door.vpcf',
        [RoomType.Bonus]     = 'particles/generic/doors/bonus_dooor.vpcf',
        [RoomType.SemiBoss]  = 'particles/generic/doors/semi_boss_dooor.vpcf',
        [RoomType.FinalBoss] = 'particles/generic/doors/final_boss_dooor.vpcf',
    }
    local doorParticleName  = doorParticleNames[self.type]
    if self._bLocked then
    end

    -- 如果没有特效，那么fallback到普通房间的特效
    if doorParticleName == nil then
        doorParticleName = doorParticleNames[RoomType.Normal]
    end

    if self.type == - 1 then
        -- 进入下一层的门
        self._np = ParticleManager:CreateParticle(doorParticleName, PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(self._np, 0, self.origin)
    else
        -- 创建门的粒子特效
        self._np = ParticleManager:CreateParticle( doorParticleName, PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:SetParticleControlForward( self._np, 0, self.vWallDirection );
        ParticleManager:SetParticleControl( self._np, 0, ( self.origin + self.vWallRight ) );
        ParticleManager:SetParticleControl( self._np, 1, ( self.origin - self.vWallRight ) );
        ParticleManager:SetParticleControl( self._np, 2, self.vWallDirection );
    end

end

function Door:Reveal()
    self._bExploded = true
end

function Door:IsEnterable()
    return self._bCanEnter
end

function Door:GetTargetRoom()
    return self._vTargetRoom
end

function Door:IsDoorToNextLevel()
    return self.type == - 1
end