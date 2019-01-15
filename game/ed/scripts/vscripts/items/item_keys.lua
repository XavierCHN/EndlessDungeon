local all_keys_targets = {
	-- 需要用钥匙打开的石头
	prop_key_stone = function(caster, target)
		target:SetOrigin(Vector(99999,99999,0))
		target:ForceKill(false)
		return true
	end,
}

function OnPlayerUseKey(keys)
	local caster = keys.caster
	local target = keys.target

	local key = keys.ability

	local success = false
	-- 几种可能用钥匙打开的东西，分别写好效果
	for name, func in pairs(all_keys_targets) do
		if name == target:GetUnitName() then
			-- 使用了这个钥匙
			success = func(caster, target)
		end
	end

	-- 消耗钥匙
	if success then
		local charges = key:GetCurrentCharges()
		charges = charges - 1
		if charges <= 0 then
			UTIL_RemoveImmediate(key)
		else
			key:SetCurrentCharges(charges)
		end
	end
end