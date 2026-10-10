perk_reworks = {
	{
		id = "UNLIMITED_SPELLS",
		not_in_default_perk_pool = true,
	},
}

new_perks = {
	{
		id = "D2D_SPELL_GEMS",
		ui_name = "$hardmod_perk_spell_gems_name",
		ui_description = "$hardmod_perk_spell_gems_desc",
		ui_icon = "mods/noita.hardmod/files/modules/truly_limited_spells/gfx/ui_gfx/perks/spell_gems_016.png",
		perk_icon = "mods/noita.hardmod/files/modules/truly_limited_spells/gfx/ui_gfx/perks/spell_gems.png",
		stackable = STACKABLE_NO,
		one_off_effect = false,
		usable_by_enemies = false,
        func = function( entity_perk_item, entity_who_picked, item_name )
            EntityAddChild( entity_who_picked, EntityLoad( "mods/noita.hardmod/files/modules/truly_limited_spells/entities/perks/spell_gems.xml" ) )
        end,
        func_remove = function( entity_who_picked )
        	local perk_entity = EntityGetAllChildren( entity_who_picked, "hardmod_spell_gems_perk_entity" )[1]
			if perk_entity ~= nil then
				EntityKill( perk_entity )
			end
        end,
	},
}

local function modify_perk( rework_data )
	for i = 1, #perk_list do
		local perk = perk_list[i]
		if perk.id == rework_data.id then
			for k, v in pairs( rework_data ) do
                if k ~= "id" then
                    perk[k] = v
                end
            end
            if rework_data.clear_original_game_effect then
            	perk.game_effect = nil
            end
            if rework_data.clear_original_game_effect2 then
            	perk.game_effect2 = nil
            end
        end
	end
end

if ( perk_list ~= nil ) then
	for k, v in pairs( perk_reworks ) do
		modify_perk( v )
	end

	for k, v in pairs( new_perks ) do
		table.insert( perk_list, v )
	end
end
