---@meta
---Do not try to execute this file. It's just a type definition file.
---
---This reference lists all available Lua functions and classes that control
---the Renoise application window. 
---
---Please read the `Introduction.md` in the Renoise scripting Documentation
---folder first to get an overview about the complete API, and scripting for 
---Renoise in general...
---

--------------------------------------------------------------------------------
--- ## renoise.ApplicationWindow

---@class renoise.ApplicationWindow
renoise.ApplicationWindow = {}

---## constants

---@enum renoise.ApplicationWindow.UpperFrame
renoise.ApplicationWindow = {
  UPPER_FRAME_TRACK_SCOPES = 1,
  UPPER_FRAME_MASTER_SPECTRUM = 2
}

---@enum renoise.ApplicationWindow.MiddleFrame
renoise.ApplicationWindow = {
  MIDDLE_FRAME_PATTERN_EDITOR = 1,
  MIDDLE_FRAME_MIXER = 2,
  MIDDLE_FRAME_INSTRUMENT_PHRASE_EDITOR = 3,
  MIDDLE_FRAME_INSTRUMENT_SAMPLE_KEYZONES = 4,
  MIDDLE_FRAME_INSTRUMENT_SAMPLE_EDITOR = 5,
  MIDDLE_FRAME_INSTRUMENT_SAMPLE_MODULATION = 6,
  MIDDLE_FRAME_INSTRUMENT_SAMPLE_EFFECTS = 7,
  MIDDLE_FRAME_INSTRUMENT_PLUGIN_EDITOR = 8,
  MIDDLE_FRAME_INSTRUMENT_MIDI_EDITOR = 9,
}

---@enum renoise.ApplicationWindow.LowerFrame
renoise.ApplicationWindow = {
  LOWER_FRAME_TRACK_DSPS = 1,
  LOWER_FRAME_TRACK_AUTOMATION = 2,
}

---@enum renoise.ApplicationWindow.MixerFader
renoise.ApplicationWindow = {
  MIXER_FADER_TYPE_24DB = 1,
  MIXER_FADER_TYPE_48DB = 2,
  MIXER_FADER_TYPE_96DB = 3,
  MIXER_FADER_TYPE_LINEAR = 4,
}

---### properties

---@class renoise.ApplicationWindow
---
---Get/set if the application is running fullscreen.
---@field fullscreen boolean
---
---**READ-ONLY**. Window status flag.
---@field is_maximized boolean
---
---**READ-ONLY**. Window status flag.
---@field is_minimized boolean
---
---When true, the middle frame views (like the pattern editor) will
---stay focused unless alt or middle mouse is clicked.
---@field lock_keyboard_focus boolean
---
---Dialog for recording new samples, floating above the main window.
---@field sample_record_dialog_is_visible boolean
---
---Diskbrowser Panel.
---@field disk_browser_is_visible boolean
---@field disk_browser_is_visible_observable renoise.Document.Observable
---
---InstrumentBox
---@field instrument_box_is_visible boolean
---@field instrument_box_is_visible_observable renoise.Document.Observable
---
---Instrument Editor detaching.
---@field instrument_editor_is_detached boolean
---@field instrument_editor_is_detached_observable renoise.Document.Observable
---
---Mixer View detaching.
---@field mixer_view_is_detached boolean
---@field mixer_view_is_detached_observable renoise.Document.Observable
---
---Frame with the scopes/master spectrum...
---@field upper_frame_is_visible boolean
---@field upper_frame_is_visible_observable renoise.Document.Observable
---@field active_upper_frame renoise.ApplicationWindow.UpperFrame
---@field active_upper_frame_observable renoise.Document.Observable
---
--Frame with the pattern editor, mixer...
---@field active_middle_frame renoise.ApplicationWindow.MiddleFrame
---@field active_middle_frame_observable renoise.Document.Observable
---
---Frame with the DSP chain view, automation, etc.
---@field lower_frame_is_visible boolean
---@field lower_frame_is_visible_observable renoise.Document.Observable
---@field active_lower_frame renoise.ApplicationWindow.LowerFrame
---@field active_lower_frame_observable renoise.Document.Observable
---
---Pattern matrix, visible in pattern editor and mixer only...
---@field pattern_matrix_is_visible boolean
---@field pattern_matrix_is_visible_observable renoise.Document.Observable
---
---Pattern advanced edit, visible in pattern editor only...
---@field pattern_advanced_edit_is_visible boolean
---@field pattern_advanced_edit_is_visible_observable renoise.Document.Observable
---
---Mixer views Pre/Post volume setting.
---@field mixer_view_post_fx boolean
---@field mixer_view_post_fx_observable renoise.Document.Observable
---
---Mixer fader type setting.
---@field mixer_fader_type renoise.ApplicationWindow.MixerFader
---@field mixer_fader_type_observable renoise.Document.Observable


---### functions

---Expand the window over the entire screen, without hiding menu bars,
---docks and so on.
function renoise.ApplicationWindow:maximize() end

---Minimize the window to the dock or taskbar, depending on the OS.
function renoise.ApplicationWindow:minimize() end

---"un-maximize" or "un-minimize" the window, or just bring it to front.
function renoise.ApplicationWindow:restore() end

---Select/activate one of the global view presets, to memorize/restore
---the user interface layout.
---@param preset_index integer
function renoise.ApplicationWindow:select_preset(preset_index) end
