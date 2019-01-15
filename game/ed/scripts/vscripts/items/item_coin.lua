function OnPlayerPickupCoin(keys)
	local caster = keys.caster
	caster.vPlayerResource = caster.vPlayerResource or {}
	caster.vPlayerResource.Coins = caster.vPlayerResource.Coins or 0
	-- caster.vPlayerResource.Coins = caster.vPlayerResource.Coins + 1
	
	-- 根据当前层数决定给予玩家的金币数量
	-- 这个数值根据平衡性常数来确定
	local level = GameRules.gamemode:GetCurrentLevel()

	local goldAmount = RandomInt(GOLD_COIN_PER_LEVEL[level][1],GOLD_COIN_PER_LEVEL[level][2])
	PlayerResource:ModifyGold(caster:GetPlayerID(), goldAmount,true,DOTA_ModifyGold_Unspecified)

	UTIL_RemoveImmediate(keys.ability)
	EmitSoundOn("General.Coins",caster)
end