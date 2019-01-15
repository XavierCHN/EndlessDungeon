utilsParticle = {}

function utilsParticle.CreateParticleOnHitLoc(particle, target)
	local pid = ParticleManager:CreateParticle(particle,PATTACH_POINT_FOLLOW,target)
	for i = 1, 15 do
		ParticleManager:SetParticleControlEnt(pid, i, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
	end
	ParticleManager:ReleaseParticleIndex(pid)
end

function utilsParticle.CreateParticleOverhead(particle, target)
	local pid = ParticleManager:CreateParticle(particle,PATTACH_OVERHEAD_FOLLOW,target)
	for i = 1, 15 do
		ParticleManager:SetParticleControlEnt(pid, i, target, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", target:GetAbsOrigin(), false)
	end
	ParticleManager:ReleaseParticleIndex(pid)
end

function utilsParticle.CreateCourierParticle(courier, particle, attach, attach_str , color_cp, color_vec)
	print("creating particle on unit", courier:GetName())
	if courier.nEconParticleID then
		ParticleManager:DestroyParticle(courier.nEconParticleID, true)
		ParticleManager:ReleaseParticleIndex(courier.nEconParticleID)
	end

	local pid = ParticleManager:CreateParticle(particle,attach,courier)
	ParticleManager:SetParticleControlEnt(pid,0,courier,attach,attach_str,courier:GetAbsOrigin(),true)
	if color_cp and color_vec then
		ParticleManager:SetParticleControl(pid,color_cp,color_vec)
	end
	courier.nEconParticleID = pid
end