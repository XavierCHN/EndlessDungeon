---@type CDOTA_Ability_Lua
bearzky_ice_shards = class({})
function bearzky_ice_shards:OnMouseDown()
	-- 根据攻击频率，每个攻击频率都需要
    local hero = self:GetCaster()
    if not hero:HasModifier("modifier_attack_range") then
    	hero:AddNewModifier(hero,self,"modifier_attack_range",{range = 512})
    end

	-- 往鼠标方向发射一枚冰片
	local info = ProjectileInfo.new()
	info.EffectName = "particles/couriers/bearzky/bearzky_ice_shards.vpcf"
	info.Source = hero
	info.vSpawnOrigin = hero:GetOrigin()
	info.vVelocity = (hero.m_MousePosition - info.vSpawnOrigin):Normalized() * 800
    info.vVelocity.z = 0
	info.Ability = self
	info.fDistance = hero:GetAttackRange()
    info.fStartRadius = 80
    info.fEndRadius = 80
	ProjectileManager:CreateLinearProjectile(info)
    self:StartCooldown(4) -- 冷却时间4秒
    hero:EmitSound("Bearzky.IceShardLaunch")
end

function bearzky_ice_shards:OnProjectileHit(target, location)
    if IsServer() then
    	local hero = self:GetCaster()
        local pid = ParticleManager:CreateParticle("particles/couriers/bearzky/bearzky_ice_shards_explode.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(pid, 0, location)
        ParticleManager:SetParticleControl(pid, 3, location)

        local enemies = FindUnitsInRadius(hero:GetTeamNumber(), location, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for _, enemy in pairs(enemies) do
            utilsDamage.DealDamageConstant(hero, enemy, hero:GetAttackDamage(), self)
        end

        EmitSoundOnLocationForAllies(location,"Bearzky.IceShardExplode",hero)

        return true
    end
end


function bearzky_ice_shards:GetManaCost(iLevel)
    return 30
end