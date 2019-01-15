function OnAegieHolderDead(keys)
	local caster = keys.caster
	caster:SetTimeUntilRespawn(3)
	local aegis = keys.ability

	Timer(2.9, function() 
		caster:RespawnHero(false,false,false)
	end)
	Timer(3, function()
		UTIL_RemoveImmediate(aegis)
	end)
end