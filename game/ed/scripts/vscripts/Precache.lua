g_ParticlePrecache = {
     "particles/items2_fx/veil_of_discord.vpcf"
    ,"particles/phantom_assassin_linear_dagger.vpcf"
    ,"particles/econ/events/darkmoon_2017/darkmoon_generic_aoe.vpcf"
    ,"particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf"
    ,"particles/units/heroes/hero_bloodseeker/bloodseeker_vision.vpcf"
    ,"particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf"
    ,"particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf"
    ,"particles/frostivus_gameplay/drow_linear_arrow.vpcf"
    ,"particles/frostivus_gameplay/drow_linear_frost_arrow.vpcf"
    ,"particles/frostivus_gameplay/legion_gladiators_ring.vpcf"
    ,"particles/frostivus_herofx/juggernaut_omnislash_ascension.vpcf"
    ,"particles/frostivus_gameplay/holdout_juggernaut_omnislash_image.vpcf"
    ,"particles/frostivus_herofx/juggernaut_fs_omnislash_slashers.vpcf"
    ,"particles/frostivus_herofx/juggernaut_fs_omnislash_tgt.vpcf"
    ,"particles/hw_fx/rosh_dismember_impact_droplets.vpcf"
    ,"particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_blur_impact.vpcf"
    ,"particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf"
    ,"particles/status_fx/status_effect_frost.vpcf"
    ,"particles/units/heroes/hero_techies/techies_blast_off_trail.vpcf"
    ,"particles/units/heroes/hero_clinkz/clinkz_windwalk.vpcf"
    ,"particles/creatures/clinkz/clinkz_searing_arrow.vpcf"
    ,"particles/econ/items/pudge/pudge_scorching_talon/pudge_scorching_talon_meathook.vpcf"
    ,"particles/econ/items/pudge/pudge_ti6_immortal/pudge_meathook_witness_impact_ti6.vpcf"
    ,"particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_loadout_char_fire.vpcf"
    ,"particles/creatures/boss_pudge/boss_pudge_fire_hell.vpcf"
    ,"particles/holdout_lina/holdout_wildfire_start.vpcf"
    ,"particles/creatures/creature_broodking/broodking_hatching.vpcf"
    ,"particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact.vpcf"
    ,"particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5.vpcf"
    ,"particles/creatures/boss_pis/pis_raze_pre.vpcf"
    ,"particles/creatures/boss_pis/boss_pis_shadow_raze.vpcf"
    ,"particles/creatures/boss_pis/boss_pis_requiem_line.vpcf"
    ,"particles/creatures/boss_yyf/storm_spirit_attack_linear.vpcf"
    ,"particles/creatures/boss_yyf/storm_spirit_charge_ball.vpcf"
}

g_SoundPrecache = {
    "soundevents/custom_game_sounds.vsndevts"
    ,"soundevents/custom_courier_sound.vsndevts"
    ,"soundevents/custom_voices.vsndevts"
    ,"soundevents/rock.vsndevts"
    ,"soundevents/game_sounds_heroes/game_sounds_spirit_breaker.vsndevts"
    ,"soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts"
    ,"soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts"
    ,"soundevents/creatures/techies_sounds.vsndevts"
    ,"soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts"
    ,"soundevents/voscripts/game_sounds_vo_pudge.vsndevts"
    ,"soundevents/voscripts/game_sounds_vo_broodmother.vsndevts"
    ,"soundevents/voscripts/game_sounds_vo_mirana.vsndevts"
    ,"soundevents/voscripts/game_sounds_vo_puck.vsndevts"
    ,"soundevents/voscripts/game_sounds_vo_techies.vsndevts"
}

g_UnitPrecache = {
    "npc_dota_hero_bristleback"
    ,"npc_dota_hero_earthshaker"
    ,"npc_dota_hero_wisp"
    ,"npc_dota_hero_spirit_breaker"
    ,"npc_dota_hero_nevermore"
    ,"npc_dota_hero_invoker"
    ,"npc_dota_hero_storm_spirit"
    ,"npc_dota_hero_tusk"
}

g_ItemPrecache = {

}

g_ModelPrecache = {

}

g_ParticleFolderPrecache = {

}

local function PrecacheEverythingFromTable( context, kvtable)
    for key, value in pairs(kvtable) do
        if type(value) == "table" then
            PrecacheEverythingFromTable( context, value )
        else
            if string.find(value, "vpcf") then
                PrecacheResource( "particle", value, context)
                -- print("PRECACHE PARTICLE RESOURCE", value)
            end
            if string.find(value, "vmdl") then
                PrecacheResource( "model", value, context)
                -- print("PRECACHE MODEL RESOURCE", value)
            end
            if string.find(value, "vsndevts") then
                PrecacheResource( "soundfile", value, context)
                -- print("PRECACHE SOUND RESOURCE", value)
            end
        end
    end
end

function PrecacheEverythingFromKV( context )
    local kv_files = {
        "scripts/npc/npc_units_custom.txt",
        "scripts/npc/npc_abilities_custom.txt",
        "scripts/npc/npc_heroes_custom.txt",
        "scripts/npc/npc_abilities_override.txt",
        "scripts/npc/npc_items_custom.txt",
        "scripts/npc/bullet_defination.txt"
    }
    for _, kv in pairs(kv_files) do
        local kvs = LoadKeyValues(kv)
        if kvs then
            -- print("BEGIN TO PRECACHE RESOURCE FROM: ", kv)
            PrecacheEverythingFromTable( context, kvs)
        end
    end
end