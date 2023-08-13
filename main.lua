-- add your test snippets and other code here, that you want to quickly
-- try out without writing a full blown 'tool'...

-- dummy: recursively prints all available functions and classes
-- rprint(_G)
--

local scopesFrame = renoise.ApplicationWindow.UPPER_FRAME_TRACK_SCOPES
local masterFrame = renoise.ApplicationWindow.UPPER_FRAME_MASTER_SPECTRUM

local patEdFrame = renoise.ApplicationWindow.MIDDLE_FRAME_PATTERN_EDITOR
local mixerFrame = renoise.ApplicationWindow.MIDDLE_FRAME_MIXER
local phraseFrame = renoise.ApplicationWindow.MIDDLE_FRAME_INSTRUMENT_PHRASE_EDITOR
local smpKeyZoneFrame = renoise.ApplicationWindow.MIDDLE_FRAME_INSTRUMENT_SAMPLE_KEYZONES
local smpEdFrame = renoise.ApplicationWindow.MIDDLE_FRAME_INSTRUMENT_SAMPLE_EDITOR
local smpModFrame = renoise.ApplicationWindow.MIDDLE_FRAME_INSTRUMENT_SAMPLE_MODULATION
local smpFxFrame = renoise.ApplicationWindow.MIDDLE_FRAME_INSTRUMENT_SAMPLE_EFFECTS
local smpPluginFrame = renoise.ApplicationWindow.MIDDLE_FRAME_INSTRUMENT_PLUGIN_EDITOR
local smpMidiFrame = renoise.ApplicationWindow.MIDDLE_FRAME_INSTRUMENT_MIDI_EDITOR

local dspFrame = renoise.ApplicationWindow.LOWER_FRAME_TRACK_DSPS
local autoFrame = renoise.ApplicationWindow.LOWER_FRAME_TRACK_AUTOMATION

local CurrentPreset = -1
local LastRight = 3

SetPreset = function(preset)
    if preset > -1 then
        renoise.app().window:select_preset(preset)
    end

    CurrentPreset = preset
end

SetPreset(-1)

-- Presets:
-- 1 - Pat: Matrix view
-- 2 - Pat: Instrument Select view
-- 3 - Pat: Browser view
-- 4 - Samp/Plugin: Matrix view
-- 5 - Samp/Plugin: Instrument Select view
-- 6 - Samp/Plugin: Browser view
--
-- -1 - In main view of tab

local function focusLeft()
    if renoise.app().window.active_middle_frame == patEdFrame then
        if CurrentPreset == -1 then
            SetPreset(1)
            return
        end

        if CurrentPreset == 1 then
            return
        end

        if CurrentPreset == 2 or CurrentPreset == 3 then
            LastRight = CurrentPreset

            SetPreset(-1)

            renoise.app().window.active_middle_frame = renoise.app().window.active_middle_frame
            return
        end
    end
end

local function focusRight()
    if renoise.app().window.active_middle_frame == patEdFrame then -- {{{
        if CurrentPreset == -1 then
            SetPreset(LastRight)
            return
        end

        if CurrentPreset == 2 then
            return
        end

        if CurrentPreset == 1 then
            SetPreset(-1)
            renoise.app().window.active_middle_frame = renoise.app().window.active_middle_frame
            return
        end
    end -- }}}
    if renoise.app().window.active_middle_frame == mixerFrame then
        if CurrentPreset == -1 then
            SetPreset(LastRight)
            return
        end

        if CurrentPreset == 2 then
            return
        end

        if CurrentPreset == 1 then
            SetPreset(-1)
            renoise.app().window.active_middle_frame = renoise.app().window.active_middle_frame
            return
        end
    end
end

local function focusUp()
    if CurrentPreset == 3 then
        SetPreset(2)
        return
    end

    if renoise.app().window.active_middle_frame == dspFrame or
        renoise.app().window.active_middle_frame == autoFrame then
        SetPreset(-1)
        renoise.app().window.active_middle_frame = renoise.app().window.active_middle_frame
        return
    end

    if CurrentPreset == -1 or CurrentPreset == 1 or CurrentPreset == 2 then
        return
    end
end

local function focusDown()
    if CurrentPreset == 2 then
        SetPreset(3)
        return
    end

    if renoise.app().window.active_middle_frame == dspFrame or
        renoise.app().window.active_middle_frame == autoFrame or
        CurrentPreset == 3 then
        return
    end

    if CurrentPreset == -1 or CurrentPreset == 1 then
        renoise.app().window.active_middle_frame = dspFrame
        return
    end
end

renoise.tool():add_keybinding {
    name = "Global:View:Focus Left...",
    invoke = function()
        focusLeft()
    end
}
renoise.tool():add_keybinding {
    name = "Global:View:Focus Right...",
    invoke = function()
        focusRight()
    end
}
renoise.tool():add_keybinding {
    name = "Global:View:Focus Up...",
    invoke = function()
        focusUp()
    end
}
renoise.tool():add_keybinding {
    name = "Global:View:Focus Down...",
    invoke = function()
        focusDown()
    end
}
