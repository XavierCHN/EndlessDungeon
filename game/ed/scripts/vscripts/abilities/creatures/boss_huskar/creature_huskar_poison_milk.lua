creature_huskar_poison_milk = class({})

LinkLuaModifier("modifier_huskar_poison_milk_channel", "modifiers/creatures/boss_huskar/modifier_huskar_poison_milk_channel.lua", LUA_MODIFIER_MOTION_NONE)

function creature_huskar_poison_milk:OnSpellStart()
    -- 在5秒之内转一圈
    if IsServer() then
        local caster = self:GetCaster()
        caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
        
        local randText = RandomInt(1, 5)
        utilsBubbles.Show(caster, "#boss_speech_huskar_poison_milk_text_" .. randText, 5)

        -- 发送语音
        EmitSoundOn("Huskar.PoisonMilk" .. randText, caster)

        Timer(1, function()
            caster:AddNewModifier(caster, self, "modifier_huskar_poison_milk_channel", {})
        end)
    end
end