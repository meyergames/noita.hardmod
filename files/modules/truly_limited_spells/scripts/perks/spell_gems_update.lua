dofile_once( "mods/noita.hardmod/lib/utilities.lua" )

local MAX_EFFECT_DISTANCE = 100

local perk_entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( perk_entity_id )

local prev_max_eid = GetInternalInt( perk_entity_id, "prev_max_eid", true )
local new_max = EntitiesGetMaxID()
for entity_id = prev_max_eid + 1, new_max do
	if EntityHasTag( entity_id, "homing_target" ) and GetInternalInt( entity_id, "hardmod_spell_gems_script_added", true ) == 0 then
		EntityAddComponent2( entity_id, "LuaComponent",
		{
			script_source_file = "mods/noita.hardmod/files/modules/truly_limited_spells/scripts/animals/try_drop_spell_gems_on_death.lua",
			execute_every_n_frame = -1,
			execute_on_removed = true,
		} )
		SetInternalInt( entity_id, "hardmod_spell_gems_script_added", 1 )
		GamePrint( "NEW ENTITY CHECKED" )

		SetInternalInt( perk_entity_id, "prev_max_eid", new_max )
	end
end

-- local spawned_creatures = EntityGetWithTag( "homing_target" )
-- if #spawned_creatures > 0 then
--     for i,creature_id in ipairs( spawned_creatures ) do
--     	if GetInternalInt( creature_id, "hardmod_spell_gems_script_added", true ) == 0 then
--     		EntityAddComponent2( creature_id, "LuaComponent",
-- 			{
-- 				script_source_file = "mods/noita.hardmod/files/modules/truly_limited_spells/scripts/animals/try_drop_spell_gems_on_death.lua",
-- 				execute_every_n_frame = -1,
-- 				execute_on_removed = true,
-- 			} )
-- 			SetInternalInt( creature_id, "hardmod_spell_gems_script_added", 1 )
--     	end
--     end
-- end
