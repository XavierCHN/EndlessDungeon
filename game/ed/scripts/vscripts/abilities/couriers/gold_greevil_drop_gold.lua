function RegisterGoldGreevil(keys)
	local caster = keys.caster
	if caster.pszFinishRoomEventListener == nil then 
		caster.pszFinishRoomEventListener = EDEventListener:RegisterListener("ed_finish_room", function(keys)
			local room = keys.Room
			if room:GetRoomType() ~= RoomType.Start then
				if RollPercentage(10) then
					utilsBonus.DropLootItem("item_coin", caster:GetOrigin(), 200)
				end
			end
		end)
	end
end