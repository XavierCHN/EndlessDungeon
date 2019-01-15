function OnPlayerEquipBottle(keys)
	local bottle = keys.ability
	local finish_room_required = bottle:GetSpecialValueFor("room_required")
	bottle.nFinishRoomEventListenerID = EDEventListener:RegisterListener("ed_finish_room", function(keys)
		bottle.nCurrentFinishRoomCount = bottle.nCurrentFinishRoomCount or 0
		bottle.nCurrentFinishRoomCount = bottle.nCurrentFinishRoomCount + 1
		if bottle.nCurrentFinishRoomCount > finish_room_required - 1 then
			bottle:SetCurrentCharges(bottle:GetCurrentCharges() + 1)
			bottle.nCurrentFinishRoomCount = 0
			EmitSoundOn("Bottle.Cork",keys.caster)
		end
	end)
end

function OnPlayerUnequipBottle(keys)
	local bottle = keys.ability
	EDEventListener:UnregisterListener(bottle.nFinishRoomEventListenerID)
end