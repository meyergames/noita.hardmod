local hooks = {}
-- local nxml = dofile_once("mods/noita.hardmod/lib/nxml/nxml.lua") ---@type nxml

ModMaterialsFileAdd( "mods/noita.hardmod/files/modules/truly_limited_spells/materials.xml")

hooks.mod_post_init = function()
	ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/noita.hardmod/files/modules/truly_limited_spells/scripts/perks_append.lua" )
	ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/noita.hardmod/files/modules/truly_limited_spells/scripts/actions_append.lua" )
	ModLuaFileAppend( "data/entities/animals/boss_wizard/death.lua", "mods/noita.hardmod/files/modules/truly_limited_spells/scripts/boss_wizard_death_append.lua" )
end

return hooks --Don't forget to do this if you want your changes to apply!!!!