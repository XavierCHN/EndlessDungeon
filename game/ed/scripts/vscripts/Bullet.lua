---@class Bullet
Bullet = class({})

-- 一个生物的弹道类型
-- 初始化就默认为标准的格式
---@return Bullet
function Bullet:constructor(unit)
    self.vSource = unit
    self.vTargetDirection = nil
    self.vSourcePos = unit:GetOrigin()
    self.flLength = 2000
    self.flSpeed = 800
    self.flStartRadius = 32
    self.flEndRadius = 32
    self.pszStartSound = ""
    self.pszEndSound = ""
    self.pszEffectName = "particles/generic/fail_safe_attack.vpcf"

    self.hAbility = self.vSource:FindAbilityByName("bullet_attack")
    if not self.hAbility then
        self.vSource:AddAbility("bullet_attack")
        self.hAbility = self.vSource:FindAbilityByName("bullet_attack")
        if self.hAbility then
            self.hAbility:SetLevel(1)
        end
    end
end

---@return Bullet
function NewBullet(unit)
    return Bullet(unit)
end

function Bullet:Fire()
    self.hAbility:Fire(self)
end

function Bullet:Clone()
    local bullet = Bullet()
    bullet.vSource = self.vSource
    bullet.vTargetDirection = self.vTargetDirection
    bullet.vSourcePos = self.vSourcePos
    bullet.flLength = self.flLength
    bullet.flSpeed = self.flSpeed
    bullet.flStartRadius = self.flStartRadius
    bullet.flEndRadius = self.flEndRadius
    bullet.pszStartSound = self.pszStartSound
    bullet.pszEndSound = self.pszEndSound
    bullet.pszEffectName = self.pszEffectName
    bullet.hAbility = self.hAbility
    return bullet
end

-- 往多个方向发射
function Bullet:FireAtDirections(firstDirection, directionCount, attackInterval)
    for i = 1, directionCount do
        Timer(attackInterval * (i - 1), function()
            local clone = self:Clone()
            local direction = RotatePosition(self:GetOrigin(), QAngle(0, -(360/directionCount * i), 0), firstDirection)
            clone:SetDirection(direction)
            clone:Fire()
        end)
    end
end

function Bullet:SetEffectName(name)
    self.pszEffectName = name
end

function Bullet:SetDirection(dir)
    self.vTargetDirection = dir
end

function Bullet:SetSourcePos(pos)
    self.vSourcePos = pos
end

function Bullet:SetLength(length)
    self.flLength = length
end

function Bullet:SetSpeed(speed)
    self.flSpeed = speed
end

function Bullet:SetStartRadius(radius)
    self.flStartRadius = radius
end

function Bullet:SetEndRadius(radius)
    self.flEndRadius = radius
end

function Bullet:SetStartSound(name)
    self.pszStartSound = name
end

function Bullet:SetEndSound(name)
    self.pszENdSound = name
end

function Bullet:GetEffectName()
    return self.pszEffectName
end

function Bullet:GetDirection()
    return self.vTargetDirection
end

function Bullet:GetSourcePos()
    return self.vSourcePos
end

function Bullet:GetLength()
    return self.flLength
end

function Bullet:GetSpeed()
    return self.flSpeed
end

function Bullet:SetStartRadius()
    return self.flStartRadius
end

function Bullet:SetEndRadius()
    return self.flEndRadius
end

function Bullet:SetStartSound()
    return self.pszStartSound
end

function Bullet:SetEndSound()
    return self.pszENdSound
end