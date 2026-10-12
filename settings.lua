dofile("data/scripts/lib/mod_settings.lua")

-- To set your module's icon, create a 16x16 sprite and save it as 'module_icon_016.png' in the root of your module folder.
-- (Dani: I vote for ordering this list from (roughly) most to least impactful for the average run.)
local module_data = {
    {
        id      = "phantom_nemesis",
        ui_name = "Phantom Nemesis",
        ui_desc = "A powerful phantom haunts you throughout your run, possessing enemies\n" ..
                  "and giving them buffs that adapt to your strengths.",
    },
    {
        id      = "vanilla_perk_rebalances",
        ui_name = "Vanilla Perk Rebalances",
        ui_desc = "Makes certain vanilla perks - most notably the immunity perks,\n" ..
                  "Tinker With Wands Everywhere and All-Seeing Eye - less powerful\n" ..
                  "or harder to obtain.",
    },
    {
        id      = "nerfed_combat_healing",
        ui_name = "Nerfed Combat Healing",
        ui_desc = "Whenever you take damage, your healing is disabled for up to 1 minute.",
    },
    {
        id      = "cheeseless_triggers",
        ui_name = "Cheeseless Triggers",
        ui_desc = "The cast delay of spells is now also applied when they are part of\n" ..
                  "a trigger payload.",
    },
    {
        id      = "no_more_chainsaw_wrapping",
        ui_name = "No More Chainsaw Wrapping",
        ui_desc = "The Chainsaw spell no longer reduces cast delay to 0.",
    },
    {
        id      = "no_more_max_hp_cheesing",
        ui_name = "Heartless Mage",
        ui_desc = "The heart mage trick no longer works. Neither does worm farming.",
    },
    {
        id      = "worse_hearts",
        ui_name = "Worse Hearts",
        ui_desc = "Temple hearts no longer increase your max health.",
    },
    {
        id      = "trappier_traps",
        ui_name = "Trappier Traps",
        ui_desc = "Makes traps more dangerous.",
    },
}

local mod_id = "noita.hardmod" -- This should match the name of your mod's folder.
mod_settings_version = 1 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings =
{
    {
        -- Leaving this here as a reminder/template for when we start adding settings
        -- 
        -- category_id = "limited_spells_settings",
        -- ui_name = "Truly Limited Spells",
        -- foldable = true,
        -- _folded = true,
        -- settings = {
        --     {
        --         id = "print_indulgence_cost",
        --         ui_name = "Print Indulgence cost",
        --         ui_description = "When enabled, casting the Indulgence spell will print\nits cost at the tip of your wand.",
        --         value_default = true,
        --         scope = MOD_SETTING_SCOPE_RUNTIME,
        --     },
        --     {
        --         id = "spawn_truly_limited_spells_test_package",
        --         ui_name = "[TEMP] Test Mode",
        --         ui_description = "For testing this module. Requires a new game.\n(REMOVE THIS SETTING BEFORE RELEASE)",
        --         value_default = false,
        --         scope = MOD_SETTING_SCOPE_NEW_GAME,
        --     },
        -- }
    },
}

function ModSettingsUpdate(init_scope)
    local old_version = mod_settings_get_version(mod_id)
    mod_settings_update(mod_id, mod_settings, init_scope)
end

function ModSettingsGuiCount()
    return mod_settings_gui_count(mod_id, mod_settings)
end

function HasSettingFlag(name)
    return ModSettingGet(name) or false
end

function AddSettingFlag(name)
    ModSettingSet(name, true)
  --  ModSettingSetNextValue(name, true)
end

function RemoveSettingFlag(name)
    ModSettingRemove(name)
end

function ModSettingsGui( gui, in_main_menu )
    screen_width, screen_height = GuiGetScreenDimensions(gui)

    local id = 46323
    local function new_id() id = id + 1; return id end

    GuiOptionsAdd( gui, GUI_OPTION.NoPositionTween )

    local modules = {}
    for i,module in ipairs( module_data ) do
        if module.force_enable_state == nil then
            table.insert( modules, module )
        end
    end

    GuiLayoutBeginHorizontal( gui, 0, 0, false, 12, 8 )
    GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1 )
    GuiText( gui, 0, 3, GameTextGetTranslatedOrNot( "$hardmod_settings_header_modules" ) )
    GuiLayoutEnd( gui )

    GuiColorSetForNextWidget( gui, 1, 1, 1, 1 )
    for i,module in ipairs( modules ) do
        local module_disabled = "noita.hardmod."..module.id..".disabled"
        GuiLayoutBeginHorizontal( gui, 0, 0, false, 2, 2 )

        -- show the icon 
        local icon = "mods/noita.hardmod/files/modules/"..module.id.."/module_icon_016.png"
        if not ModDoesFileExist( icon ) then
            icon = "data/ui_gfx/gun_actions/unidentified.png"
        end
        local clicked,right_clicked = GuiImageButton( gui, new_id(), 4, 0, "", icon )
        if clicked then
            if HasSettingFlag( module_disabled ) then
                RemoveSettingFlag( module_disabled )
            else
                AddSettingFlag( module_disabled )
            end
        end

        local tooltip_text = GameTextGetTranslatedOrNot( module.ui_desc ) .. "\n "
        if HasSettingFlag( module_disabled ) then
            GuiTooltip( gui, tooltip_text, "[ Click to enable ]" );
        else
            GuiTooltip( gui, tooltip_text, "[ Click to disable]" )
        end

        GuiImage( gui, new_id(), -20.2, -1.2, "mods/noita.hardmod/lib/ui_sprites/settings_content_square.png", 1, 1.2, 0 )
        if HasSettingFlag( module_disabled ) then
            GuiZSetForNextWidget( gui, -80 )
            GuiOptionsAddForNextWidget( gui, GUI_OPTION.NonInteractive )
            GuiImage( gui, new_id(), -20.2, -1.2, "mods/noita.hardmod/lib/ui_sprites/settings_content_disabled_overlay.png", 1, 1.2, 0 )
        end

        if HasSettingFlag( module_disabled ) then
            GuiColorSetForNextWidget( gui, 1, 0.25, 0.25, 1 )
        else
            GuiColorSetForNextWidget( gui, 1, 1, 1, 1 )
        end
        GuiText( gui, 0, 3, GameTextGetTranslatedOrNot( module.ui_name ) )
        GuiLayoutEnd( gui )
    end

    GuiOptionsAdd( gui, GUI_OPTION.NoPositionTween )

    GuiColorSetForNextWidget( gui, 1, 1, 1, 1 )
    for i = 1, 5 do
        GuiText( gui, 0, 0, "" )
    end

    mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )

    -- GuiLayoutEnd(gui)
end
