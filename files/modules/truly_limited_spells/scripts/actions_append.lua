
local function hand_contains( hand, action_id )
	for i,card in ipairs( hand ) do
		if card.id == action_id then
			return true
		end
	end
	return false
end

local function get_actions_lua_data( action_id )
    dofile_once( "data/scripts/gun/gun_actions.lua" )
    for i,action in ipairs( actions ) do
        if action.id == action_id then
            return action
        end
    end
    return nil
end

local function find_action_entity_by_id( action_id )
	local all_cards = EntityGetWithTag( "card_action" )
	for i,card in ipairs( all_cards ) do
		if EntityGetValue( card, "ItemActionComponent", "action_id" ) == action_id then
			return card
		end
	end
	return nil
end

local function trigger_action_ungreeked( data, hand, rec )
	if ( data.uses_remaining ~= 0 ) then
		data.action( rec )
		data.uses_remaining = data.uses_remaining - 1
	-- if the cast contains HARDMOD_SPELL_INFINITY, cast the spell even with 0 uses remaining
	elseif ( data.uses_remaining == 0 ) and hand_contains( hand, "HARDMOD_SPELL_INFINITY" ) then
		data.action( rec )
	end

	local action_eid = find_action_entity_by_id( data.id )
	if action_eid ~= nil then
		local icomp = EntityGetFirstComponentIncludingDisabled( action_eid, "ItemComponent" )
		if icomp ~= nil then
		    uses_remaining = ComponentGetValue2( icomp, "uses_remaining" )
			if uses_remaining > 0 then
				data.action( rec )
				ComponentSetValue2( icomp, "uses_remaining", uses_remaining - 1 )

				if uses_remaining == 1 then
					local x, y = EntityGetTransform( GetUpdatedEntityID() )
					GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/action_consumed", x, y )
				end
			end
		end
	end
end

if actions ~= nil then
	new_actions = {
		{
			id					= "HARDMOD_SPELL_INDULGENCE",
			name				= "$hardmod_spell_indulgence_name",
			description			= "$hardmod_spell_indulgence_desc",
			sprite				= "mods/noita.hardmod/files/modules/truly_limited_spells/gfx/ui_gfx/spells/indulgence.png",
			type				= ACTION_TYPE_OTHER,
			recursive 			= true,
			spawn_level			= "10",
			spawn_probability	= "1",
			price				= 500,
			mana				= 40,
			action				= function()
									-- c.fire_rate_wait = c.fire_rate_wait + 15

									local data = {}
									if ( #deck > 0 ) then
										data = deck[1]
									elseif ( #hand > 0 ) then
										data = hand[1]
									else
										data = nil
									end

									local rec = check_recursion( data, recursion_level )
									
									if ( data ~= nil ) and ( rec > -1 ) and ( data.uses_remaining == 0 ) then

										-- determine the spell's max uses
										local max_uses = -1
										local lua_data = get_actions_lua_data( data.id )
										if lua_data.max_uses then
											max_uses = lua_data.max_uses
										end

										-- how much money does the player have?
										local player = GetUpdatedEntityID()
										local wcomp = EntityGetFirstComponent( player, "WalletComponent" )
										if wcomp == nil then return end
										local money = ComponentGetValue2( wcomp, "money" )

										-- determine the cost for this spell
										local cast_price
										if data.id == "DIVIDE_10" then
											cast_price = 1000
										elseif max_uses <= 2 or lua_data.recursive then -- i.e. Circle of Vigour, Greek letters
											cast_price = 500
										elseif max_uses <= 5 then -- i.e. Black Hole
											cast_price = 250
										elseif max_uses <= 10 then
											cast_price = 100
										elseif max_uses <= 20 then
											cast_price = 50
										else
											cast_price = 25
										end
										-- if lua_data.never_unlimited then cast_price = cast_price * 2 end
										-- cast_price = math.floor( cast_price * ( 1.0 + ( money_spent * 0.00001 ) ) )

										if money >= cast_price then
											ComponentSetValue2( wcomp, "money", money - cast_price )
											GamePrint( "-" .. cast_price .. " gold" )
											GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/goldnugget/create", x, y )

											data.action( rec )
											mana = mana - data.mana
										end
									else
										draw_actions( 1, true )
									end

									-- draw_actions( 1, true )
								end,
		},
		{
			id					= "HARDMOD_SPELL_INFINITY",
			name				= "$hardmod_spell_infinity_name",
			description			= "$hardmod_spell_infinity_desc",
			sprite				= "mods/noita.hardmod/files/modules/truly_limited_spells/gfx/ui_gfx/spells/infinity.png",
			type				= ACTION_TYPE_OTHER,
			recursive 			= true,
			spawn_level			= "10",
			spawn_probability	= "0.4",
			price				= 500,
			mana				= 80,
			action				= function()
									c.fire_rate_wait = c.fire_rate_wait + 15
									if reflecting then return end

									local data = {}
									if ( #deck > 0 ) then
										data = deck[1]
									elseif ( #hand > 0 ) then
										data = hand[1]
									else
										data = nil
									end

									local rec = check_recursion( data, recursion_level )
									
									if ( data ~= nil ) and ( rec > -1 ) and ( data.uses_remaining == 0 ) then
										data.action( rec )
										mana = mana - data.mana
									else
										c.fire_rate_wait = c.fire_rate_wait - 15
										mana = mana + 100
										draw_actions( 1, true )
									end

									-- draw_actions( 1, true )
								end,
		},
	}

	reworked_actions = {
		-- ["ALPHA"] = {
		-- 	action 				= function( recursion_level, iteration )
		-- 							c.fire_rate_wait = c.fire_rate_wait + 15
									
		-- 							local data = {}
									
		-- 							if ( #discarded > 0 ) then
		-- 								data = discarded[1]
		-- 							elseif ( #hand > 0 ) then
		-- 								data = hand[1]
		-- 							elseif ( #deck > 0 ) then
		-- 								data = deck[1]
		-- 							else
		-- 								data = nil
		-- 							end
									
		-- 							local rec = check_recursion( data, recursion_level )
									
		-- 							if ( data ~= nil ) and ( rec > -1 ) and ( data.uses_remaining ~= 0 ) then
		-- 								trigger_action_ungreeked( data, hand, rec )
		-- 								-- data.action( rec )
		-- 								-- data.uses_remaining = data.uses_remaining - 1
		-- 								-- GamePrint( "USES REMAINING: " .. data.uses_remaining )
		-- 							end
		-- 						end,
		-- },
		-- ["GAMMA"] = {
		-- 	action 				= function( recursion_level, iteration )
		-- 							c.fire_rate_wait = c.fire_rate_wait + 15
									
		-- 							local data = {}
									
		-- 							if ( #deck > 0 ) then
		-- 								data = deck[#deck]
		-- 							elseif ( #hand > 0 ) then
		-- 								data = hand[#hand]
		-- 							else
		-- 								data = nil
		-- 							end
									
		-- 							local rec = check_recursion( data, recursion_level )
									
		-- 							if ( data ~= nil ) and ( rec > -1 ) then
		-- 								trigger_action_ungreeked( data, hand, rec )
		-- 							end
		-- 						end,
		-- },
	    ["ALPHA"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["GAMMA"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["TAU"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["OMEGA"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["MU"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["PHI"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["SIGMA"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["APOTHEOSIS_CHI"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["APOTHEOSIS_KAPPA"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["D2D_DELTA"] = {
	    	max_uses = 30,
	    	never_unlimited = true,
	    },

	    ["ZETA"] = {
			max_uses = 30,
			never_unlimited = true,
	    },
	}

	for i=1, #new_actions do
		table.insert( actions, new_actions[i] )
	end

	for i=1,#actions do
        if reworked_actions[actions[i].id] then
            for key, value in pairs( reworked_actions[actions[i].id] ) do
                actions[i][key] = value
            end
            actions[i]['hardmod_reworked'] = true
        end
    end
end
