
local _death = death
function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	_death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )

	local cards = EntityGetWithTag( "card_action" )
	if cards ~= nil then
		for i,card in ipairs( cards ) do
			local ia_comp = EntityGetFirstComponentIncludingDisabled( card, "ItemActionComponent" )
			if ia_comp ~= nil then
				local action_id = ComponentGetValue2( ia_comp, "action_id" )
				if action_id ~= nil and action_id == "RESET" then
					local cx, cy = EntityGetTransform( card )
					CreateItemActionEntity( "HARDMOD_ALT_FIRE_ANYTHING", cx, cy )
					EntityKill( card )
				end
			end
		end
	end
end
