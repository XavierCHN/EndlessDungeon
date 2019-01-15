function OnConsumeFaerieFire(keys)
	local heal = keys.ability:GetSpecialValueFor("heal_on_consume")
	keys.caster:Heal(heal,keys.ability)
end