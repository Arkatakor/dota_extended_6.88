-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('statcollection/init')
require('internal/util')
require('internal/funcs')
require('player_resource')
require('extended')
require('hero_selection')

function Precache( context )
--[[
	This function is used to precache resources/units/items/abilities that will be needed
	for sure in your game and that will not be precached by hero selection.  When a hero
	is selected from the hero selection screen, the game will precache that hero's assets,
	any equipped cosmetics, and perform the data-driven precaching defined in that hero's
	precache{} block, as well as the precache{} block for any equipped abilities.

	See GameMode:PostLoadPrecache() in gamemode.lua for more information
	]]

	DebugPrint("[EXTENDED] Performing pre-load precache")

	-- Particles can be precached individually or by folder
	-- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed

	-- Lua modifiers activation
	LinkLuaModifier("modifier_extended_speed_limit_break", "modifier/modifier_extended_speed_limit_break.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_extended_contributor_statue", "modifier/modifier_extended_contributor_statue.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_extended_haste_rune_speed_limit_break", "modifier/modifier_extended_haste_rune_speed_limit_break.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_extended_haste_boots_speed_break", "modifier/modifier_extended_haste_boots_speed_break.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_extended_chronosphere_ally_slow", "modifier/modifier_extended_chronosphere_ally_slow.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_extended_prevent_actions_game_start", "modifier/modifier_extended_prevent_actions_game_start.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_extended_arena_passive_gold_thinker", "modifier/modifier_extended_arena_passive_gold_thinker.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_extended_range_indicator", "modifier/modifier_extended_range_indicator.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_extended_war_veteran", "modifier/modifier_extended_war_veteran.lua", LUA_MODIFIER_MOTION_NONE )

	-- Generic talent modifiers
	LinkLuaModifier("modifier_extended_generic_talents_handler", "modifier/generic_talents/modifier_extended_generic_talents_handler.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_damage", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_all_stats", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_strength", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_agility", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_intelligence", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_armor", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_magic_resistance", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_evasion", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_move_speed", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_attack_speed", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_hp", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_hp_regen", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_mp", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_mp_regen", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_attack_range", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_cast_range", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_attack_life_steal", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_spell_life_steal", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_spell_power", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_cd_reduction", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_bonus_xp", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_extended_generic_talent_respawn_reduction", "modifier/generic_talents/modifier_extended_generic_talents.lua", LUA_MODIFIER_MOTION_NONE )

	-- Invoker lua modifiers
	LinkLuaModifier("modifier_extended_invoke_buff", "modifier/modifier_extended_invoke_buff.lua", LUA_MODIFIER_MOTION_NONE )

	-- Silencer lua modifiers
	LinkLuaModifier("modifier_extended_arcane_curse_debuff", "modifier/modifier_extended_arcane_curse_debuff.lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier("modifier_extended_silencer_int_steal", "modifier/modifier_extended_silencer_int_steal.lua", LUA_MODIFIER_MOTION_NONE )

	-- Items
	PrecacheResource("particle", "particles/econ/items/effigies/status_fx_effigies/gold_effigy_ambient_dire_lvl2.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/extended_soundevents.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/extended_item_soundevents.vsndevts", context)

	-- Roshan
	PrecacheResource("particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf", context)
	PrecacheResource("particle", "particles/neutral_fx/roshan_slam.vpcf", context)

	-- Fountain
	PrecacheResource("particle", "particles/units/heroes/hero_ursa/ursa_fury_swipes.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", context)
	PrecacheResource("particle", "particles/ambient/fountain_danger_circle.vpcf", context)

	-- Towers
	PrecacheResource("particle", "particles/units/heroes/hero_tinker/tinker_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_centaur/centaur_return.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_pudge/pudge_rot_radius.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_treant/treant_livingarmor.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ui.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context)

	-- Ancients
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_press.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace_hit.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_beserkers_call.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tidehunter.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context)

    -- Radiant Hulk (Behemoth)
    PrecacheResource("particle", "particles/creeps/lane_creeps/creep_radiant_hulk_ambient.vpcf", context)
    PrecacheResource("particle", "particles/creeps/lane_creeps/creep_radiant_hulk_ambient_energy.vpcf", context)
    PrecacheResource("particle", "particles/creeps/lane_creeps/creep_radiant_hulk_ambient_flakes.vpcf", context)
    PrecacheResource("particle", "particles/creeps/lane_creeps/creep_radiant_hulk_swipe.vpcf", context)
    PrecacheResource("particle", "particles/creeps/lane_creeps/creep_radiant_hulk_swipe_glow.vpcf", context)
    PrecacheResource("particle", "particles/creeps/lane_creeps/creep_radiant_hulk_swipe_left.vpcf", context)
    PrecacheResource("particle", "particles/creeps/lane_creeps/creep_radiant_hulk_swipe_right.vpcf", context)    

    -- Dire Hulk (Behemoth)
    PrecacheResource("particle", "particles/creeps/lane_creeps/creep_dire_hulk_ambient_core.vpcf", context)
    PrecacheResource("particle", "particles/creeps/lane_creeps/creep_dire_hulk_flames.vpcf", context)
    PrecacheResource("particle", "particles/creeps/lane_creeps/creep_dire_hulk_rays.vpcf", context)
    PrecacheResource("particle", "particles/creeps/lane_creeps/creep_dire_hulk_swipe.vpcf", context)
    PrecacheResource("particle", "particles/creeps/lane_creeps/creep_dire_hulk_swipe_glow.vpcf", context)
    PrecacheResource("particle", "particles/creeps/lane_creeps/creep_dire_hulk_swipe_left.vpcf", context)
    PrecacheResource("particle", "particles/creeps/lane_creeps/creep_dire_hulk_swipe_right.vpcf", context)    


	-- Stuff
	PrecacheResource("particle_folder", "particles/hero", context)
	PrecacheResource("particle_folder", "particles/ambient", context)
	PrecacheResource("particle_folder", "particles/generic_gameplay", context)
	PrecacheResource("particle_folder", "particles/status_fx/", context)
	PrecacheResource("particle_folder", "particles/item", context)
	PrecacheResource("particle_folder", "particles/items_fx", context)
	PrecacheResource("particle_folder", "particles/items2_fx", context)
	PrecacheResource("particle_folder", "particles/items3_fx", context)
	PrecacheResource("particle_folder", "particles/creeps/lane_creeps/", context)
	PrecacheResource("particle_folder", "particles/customgames/capturepoints/", context)
	PrecacheResource("particle", "particles/range_indicator.vpcf", context)

	-- Models can also be precached by folder or individually
	PrecacheResource("model_folder", "models/development", context)
	PrecacheResource("model_folder", "models/creeps", context)
	PrecacheResource("model_folder", "models/props_gameplay", context)

  	-- Sounds can precached here like anything else
  	PrecacheResource("soundfile", "sounds/weapons/creep/roshan/slam.vsnd", context)
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_items.vsndevts", context)
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_lancer.vsndevts", context)
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_spirit_breaker.vsndevts", context)
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context)
  	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_roshan_halloween.vsndevts", context)
	
  	-- Rapier sounds
  	--PrecacheResource("sound", "sounds/vo/announcer_dlc_bastion/announcer_event_store_rapier.vsnd", context)
  	--PrecacheResource("sound", "sounds/vo/announcer_dlc_pflax/announcer_divine_rapier_one.vsnd", context)
  	--PrecacheResource("sound", "sounds/vo/announcer_dlc_stanleyparable/announcer_purchase_divinerapier_02.vsnd", context)
  	--PrecacheResource("sound", "sounds/vo/announcer_dlc_pflax/announcer_divine_rapier_two.vsnd", context)
  	--PrecacheResource("sound", "sounds/physics/items/weapon_drop_common_02.vsnd", context)
  	--PrecacheResource("sound", "sounds/ui/inventory/metalblade_equip_01.vsnd", context)

	-- Entire items can be precached by name
	-- Abilities can also be precached in this way despite the name
	--PrecacheItemByNameSync("example_ability", context)
	--PrecacheItemByNameSync("item_example_item", context)

	-- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
	-- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
	--PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
	--PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end