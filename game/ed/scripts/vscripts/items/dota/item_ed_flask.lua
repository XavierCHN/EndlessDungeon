function OnEquipFlask(keys)
	local caster = keys.caster
	local amount = keys.Amount
	caster:Heal(amount,caster)
end

