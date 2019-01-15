function PlayRotkEffect(keys)
	local caster = keys.caster
	-- 0,0.8,1.8
	local function fireEffect()
		local origin = caster:GetOrigin()
		local forward = caster:GetForwardVector()
		local pid = ParticleManager:CreateParticle("particles/items/rotk_roar.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
		ParticleManager:SetParticleControl(pid,0,origin)
		ParticleManager:SetParticleControl(pid,1,origin + forward * 200)
		ParticleManager:ReleaseParticleIndex(pid)
	end

	fireEffect()

	local n = 1
	Timer(0.1, function()
		fireEffect()
		n = n + 1
		if n >= 22 then
			return nil 
		end
		return 0.1
	end)
end