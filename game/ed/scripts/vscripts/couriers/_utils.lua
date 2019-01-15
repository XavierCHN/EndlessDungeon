-- 信使的工具类
-- 用来处理信使的一些函数

-- "Ability1"			"ed_empty_q"
-- "Ability2"			"ed_empty_w_none" // 这个按钮不被替换，也不显示
-- "Ability3"			"ed_empty_e"
-- "Ability4"			"ed_empty_left"
-- "Ability5"			"ed_empty_right"
-- "Ability6"			"ed_empty_r"
-- "Ability7"			"ed_empty_1"
-- "Ability8"			"ed_empty_2"
-- "Ability9"			"ed_dash"
CourierUtil = {}

local function replaceAbilityByIndex(hero, index, abilityName)
	local oldAbility = hero:GetAbilityByIndex(index)
	local oldName = oldAbility:GetAbilityName()
	hero:AddAbility(abilityName)
	hero:SwapAbilities(abilityName,oldName,true,false)
	local ability = hero:FindAbilityByName(abilityName)
	ability:SetLevel(1)
	hero:RemoveAbility(oldName)
end

function CourierUtil:ReplaceLeftMouseAbilityWith(hero, newAbilityName)
	replaceAbilityByIndex(hero, 12, newAbilityName)
end

function CourierUtil:ReplaceRightMouseAbilityWith(hero, newAbilityName)
	replaceAbilityByIndex(hero, 3, newAbilityName)
end

function CourierUtil:AddAbility(hero, newAbiltyName)
	print("begin to add ability")
	if hero:HasAbility(newAbiltyName) then
        -- ShowError("#ed_hud_error_ability_already_owned", hero:GetPlayerID())
        -- EmitSoundOnClient("General.CastFail_AbilityNotLearned", PlayerResource:GetPlayer(hero:GetPlayerID()))
        local ability = hero:FindAbilityByName(newAbiltyName)
        if ability:GetLevel() < ability:GetMaxLevel() then
        	ability:SetLevel(ability:GetLevel() + 1)
        end
        return
    end

	local possible_abilities = {
		"ed_empty_q", "ed_empty_e", "ed_empty_r" 
	}

	local abilityIndex = nil
	for _, abilityName in pairs(possible_abilities) do
		if hero:HasAbility(abilityName) then
			abilityIndex = hero:FindAbilityByName(abilityName):GetAbilityIndex()
			break;
		end
	end
	if not abilityIndex then
        ShowError("#ed_hud_error_ability_is_full", hero:GetPlayerID())
        EmitSoundOnClient("General.CastFail_AbilityNotLearned", PlayerResource:GetPlayer(hero:GetPlayerID()))
    else
    	replaceAbilityByIndex(hero, abilityIndex, newAbiltyName)
    end
end

function CourierUtil:Replace1AblityWith(hero, newAbilityName)
	replaceAbilityByIndex(hero, 6, newAbilityName)
end

function CourierUtil:Replace2AbilityWith(hero, newAbilityName)
	replaceAbilityByIndex(hero, 7, newAbilityName)
end
function CourierUtil:Replace3AbilityWith(hero, newAbilityName)
	replaceAbilityByIndex(hero, 9, newAbilityName)
end
function CourierUtil:Replace4AbilityWith(hero, newAbilityName)
	replaceAbilityByIndex(hero, 10, newAbilityName)
end
function CourierUtil:Replace11AbilityWith(hero, newAbilityName)
	replaceAbilityByIndex(hero, 11, newAbilityName)
end

function CourierUtil:GetLeftMouseAbility(hero)
	return hero:GetAbilityByIndex(4)
end

function CourierUtil:GetRightMouseAbility(hero)
	return hero:GetAbilityByIndex(12)
end

function CourierUtil:ReplaceFAbilityWith(hero, newAbilityName)
	replaceAbilityByIndex(hero, 4, newAbilityName)
end