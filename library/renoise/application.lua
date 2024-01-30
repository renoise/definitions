---@meta
---Do not try to execute this file. It's just a type definition file.
---
---This reference lists all available Lua functions and classes that control
---the Renoise application. The Application is the Lua interface to Renoise's main
---GUI and window (Application and ApplicationWindow).
---
---Please read the INTRODUCTION.txt first to get an overview about the complete
---API, and scripting for Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Application

---@class renoise.Application
renoise.Application = {}

---### properties

---@class renoise.Application 
---**READ-ONLY** Access to the application's full log filename and path. Will already be 
---opened for writing, but you nevertheless should be able to read from it.
---@field log_filename string 
---**READ-ONLY** Get the apps main document, the song. The global "renoise.song()" function 
---is, in fact, a shortcut to this property.
---@field current_song renoise.Song
---**READ-ONLY** List of recently loaded song files.
---@field recently_loaded_song_files string[]
---**READ-ONLY** List of recently saved song files.
---@field recently_saved_song_files string[]
---**READ-ONLY** Returns information about all currently installed tools.
---@field installed_tools table<string, string>
---**READ-ONLY** Access keyboard modifier states.
---@field key_modifier_states table<string, string>
---**READ-ONLY** Access to the application's window.
---@field window renoise.ApplicationWindow
---Get or set globally used clipboard "slots" in the application.
---@field active_clipboard_index number [1-4]

---### functions

---Shows an info message dialog to the user.
---@param message string
function renoise.Application:show_message(message) end

---Shows an error dialog to the user.
---@param message string
function renoise.Application:show_error(message) end

---Shows a warning dialog to the user.
---@param message string
function renoise.Application:show_warning(message) end

---Shows a message in Renoise's status bar to the user.
---@param message string
function renoise.Application:show_status(message) end


---Opens a modal dialog with a title, text and custom button labels.
---Returns the pressed button label or an empty string when canceled.
---@param title string Message box title.
---@param message string Message box content text.
---@param button_labels string[]? Default: {"Ok"}
---@return string label
function renoise.Application:show_prompt(title, message, button_labels) end

---@class KeyHandlerOptions
---@field send_key_repeat boolean Default: true
---@field send_key_release boolean Default: false

---Opens a modal dialog with a title, custom content and custom button labels.
---
---See Renoise.ViewBuilder.API for more info. 
---@param title string Message box title.
---@param content_view renoise.View Message box content view.
---@param button_labels string[]? Default: {"Ok"}
---Optional notifier function for keyboard events in the dialog. 
---@param key_handler fun(key)? 
---Optional table with the fields:
---```{ "send_key_repeat": true/false, "send_key_release": true/false }```
---@param key_handler_options KeyHandlerOptions? 
---@return string label
function renoise.Application:show_custom_prompt( title, content_view, button_labels,
  key_handler, key_handler_options) end

---Shows a non modal dialog (a floating tool window) with custom content.
---
---See Renoise.ViewBuilder.API for more info about custom views.
---@param title string Dialog title.
---@param content_view renoise.View Dialog content view.
---Optional notifier function for keyboard events in the dialog. 
---@param key_handler fun(key)? 
---Optional table with the fields:
---```{ "send_key_repeat": true/false, "send_key_release": true/false }```
---@param key_handler_options KeyHandlerOptions? 
---@return renoise.Dialog
function renoise.Application:show_custom_dialog(title, content_view,
  key_handler, key_handler_options) end

---Opens a modal dialog to query an existing directory from the user.
---@param title string Dialog title.
---@return string path Valid path or empty string when canceled.
function renoise.Application:prompt_for_path(title) end

---Opens a modal dialog to query a filename and path to read from a file.
---@param file_extensions string[] File extension list, e.g. ```{"wav", "aif", "*"}```.
---@param title string Dialog title.
---@return string path Valid path or empty string when canceled.
function renoise.Application:prompt_for_filename_to_read(file_extensions, title) end

---Same as 'prompt_for_filename_to_read' but allows the user to select
---more than one file.
---@param file_extensions string[] File extension list, e.g. ```{"wav", "aif", "*"}```.
---@param title string Dialog title.
---@return string[] paths Valid paths or empty table when canceled.
function renoise.Application:prompt_for_multiple_filenames_to_read(file_extensions, title) end

---Open a modal dialog to get a filename and path for writing.
---When an existing file is selected, the dialog will ask whether or not to 
---overwrite it, so you don't have to take care of this on your own.
---@param file_extension string File extension, e.g. ```"wav"```.
---@param title string Dialog title.
---@return string path Valid path or empty string when canceled.
function renoise.Application:prompt_for_filename_to_write(file_extension, title) end


---Opens the default internet browser with the given URL. The URL can also be
---a file that browsers can open (like xml, html files...).
---@param url string
function renoise.Application:open_url(url) end
---Opens the default file browser (explorer, finder...) with the given path.
---@param file_path string
function renoise.Application:open_path(file_path) end


---Install order update a tool. Any errors are shown to the user 
---during installation. Installing an already existing tool will upgrade 
---the tool without confirmation. Upgraded tools will automatically be
---re-enabled, if necessary.
---@param file_path string File path to the xrnx directory.
function renoise.Application:install_tool(file_path) end
---Uninstall an existing tool. Any errors are shown to the user 
---during uninstallation. 
---@param file_path string File path to the xrnx directory.
function renoise.Application:uninstall_tool(file_path) end


---Create a new song document (will ask the user to save changes if needed).
---The song is not created immediately, but soon after the call was made and 
---the user did not aborted the operation. In order to continue execution 
---with the new song, attach a notifier to 'renoise.app().new_document_observable'
---
--- @see renoise.ScriptingTool for more info.
function renoise.Application:new_song() end
---Create a new song document, avoiding template XRNS songs (when present) to be loaded. 
---The song is not created immediately, but soon after the call was made and 
---the user did not aborted the operation. In order to continue execution 
---with the new song, attach a notifier to 'renoise.app().new_document_observable'
---
--- @see renoise.ScriptingTool for more info.
function renoise.Application:new_song_no_template() end

---Load a new song document from the given filename (will ask to save
---changes if needed, any errors are shown to the user).
---Just like new_song(), the song is not loaded immediately, but soon after 
---the call was made. See 'renoise.app():new_song()' for details.
---@param filename string
function renoise.Application:load_song(filename) end
---Load a track device chains into the currently selected track. 
---Any errors during the export are shown to the user.
---@param filename string
---@return boolean success
function renoise.Application:load_track_device_chain(filename) end
---Load a track device devices into the currently selected track.
---When no device is selected a new device will be created. 
---Any errors during the export are shown to the user.
---@param filename string
---@return boolean success
function renoise.Application:load_track_device_preset(filename) end 
---Load an instrument into the currently selected instrument. 
---Any errors during the export are shown to the user.
---@param filename string
---@return boolean success
function renoise.Application:load_instrument(filename) end
---@param filename string
---@return boolean success
---Load an instrument multi sample into the currently selected instrument. 
---Any errors during the export are shown to the user.
function renoise.Application:load_instrument_multi_sample(filename) end
---@param filename string
---@return boolean success
---Load an instrument device chain into the currently selected instrument's 
---device chain. When no device chain is selected, a new one will be created. 
---Any errors during the export are shown to the user.
function renoise.Application:load_instrument_device_chain(filename) end
---@param filename string
---@return boolean success
---Load an instrument device into the currently selected instrument's device 
---chain's device. When no device is selected, a new one will be created. 
---Any errors during the export are shown to the user.
function renoise.Application:load_instrument_device_preset(filename) end
---@param filename string
---@return boolean success
---Load an instrument modulation chain into the currently selected instrument's 
---modulation chain. When no device is selected, a new one will be created. 
---Any errors during the export are shown to the user.
function renoise.Application:load_instrument_modulation_set(filename) end
---@param filename string
---@return boolean success
---Load an instrument phrase into the currently selected instrument's 
---phrases. When no phrase is selected, a new one will be created. 
---Any errors during the export are shown to the user.
function renoise.Application:load_instrument_phrase(filename) end
---@param filename string
---@return boolean success
---Load an instrument sample into the currently selected instrument's 
---sample lists. When no sample is selected, a new one will be created. 
---Any errors during the export are shown to the user.
function renoise.Application:load_instrument_sample(filename) end
---@param filename string
---@return boolean success
---Load a new theme file and apply it.
---Any errors during the export are shown to the user.
function renoise.Application:load_theme(filename) end

---Quicksave or save the current song under a new name. Any errors
---during the export are shown to the user.
function renoise.Application:save_song() end
---Save the current song under a new name. Any errors
---during the export are shown to the user.
---@param filename string
function renoise.Application:save_song_as(filename) end
---Save a currently selected track device chain to a file with the given name. 
---When no device chain is selected an error is raised. returns success
---@param filename string
---@return boolean success
function renoise.Application:save_track_device_chain(filename) end
---Save a currently selected instrument to a file with the given name. 
---When no instruemnt is selected an error is raised. returns success
---@param filename string
---@return boolean success
function renoise.Application:save_instrument(filename) end
---Save a currently selected instrument multi sample file to a file with the given name. 
---When no instrument is selected an error is raised. returns success
---@param filename string
---@return boolean success
function renoise.Application:save_instrument_multi_sample(filename) end
---Save a currently selected instrument's device chain to a file with the given name. 
---When no chain is selected an error is raised. returns success
---@param filename string
---@return boolean success
function renoise.Application:save_instrument_device_chain(filename) end
---Save a currently selected instrument's modulation set to a file with the given name. 
---When no modulation is selected an error is raised. returns success
---@param filename string
---@return boolean success
function renoise.Application:save_instrument_modulation_set(filename) end
---Save a currently selected instrument's phrase to a file with the given name. 
---When no phrase is selected an error is raised. returns success
---@param filename string
---@return boolean success
function renoise.Application:save_instrument_phrase(filename) end
---Save a currently selected instrument's sample to a file with the given name. 
---When no sample is selected an error is raised. returns success
---@param filename string
---@return boolean success
function renoise.Application:save_instrument_sample(filename) end
---Save a current theme to a file with the given name. returns success
---@param filename string
---@return boolean success
function renoise.Application:save_theme(filename) end


--------------------------------------------------------------------------------
-- renoise.ApplicationWindow

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
---Get/set if the application is running fullscreen.
---@field fullscreen boolean
---**READ-ONLY**. Window status flag.
---@field is_maximized boolean
-- **READ-ONLY**. Window status flag.
---@field is_minimized boolean
---When true, the middle frame views (like the pattern editor) will
---stay focused unless alt or middle mouse is clicked.
---@field lock_keyboard_focus boolean
-- Dialog for recording new samples, floating above the main window.
---@field sample_record_dialog_is_visible boolean
---Diskbrowser Panel.
---@field disk_browser_is_visible boolean
---@field disk_browser_is_visible_observable renoise.Document.Observable
---InstrumentBox
---@field instrument_box_is_visible boolean
---@field instrument_box_is_visible_observable renoise.Document.Observable
---Instrument Editor detaching.
---@field instrument_editor_is_detached boolean
---@field instrument_editor_is_detached_observable renoise.Document.Observable
---Mixer View detaching.
---@field mixer_view_is_detached boolean
---@field mixer_view_is_detached_observable renoise.Document.Observable
--Frame with the scopes/master spectrum...
---@field upper_frame_is_visible boolean
---@field upper_frame_is_visible_observable renoise.Document.Observable
---@field active_upper_frame renoise.ApplicationWindow.UpperFrame
---@field active_upper_frame_observable renoise.Document.Observable
--Frame with the pattern editor, mixer...
---@field active_middle_frame renoise.ApplicationWindow.MiddleFrame
---@field active_middle_frame_observable renoise.Document.Observable
-- Frame with the DSP chain view, automation, etc.
---@field lower_frame_is_visible boolean
---@field lower_frame_is_visible_observable renoise.Document.Observable
---@field active_lower_frame renoise.ApplicationWindow.LowerFrame
---@field active_lower_frame_observable renoise.Document.Observable
---Pattern matrix, visible in pattern editor and mixer only...
---@field pattern_matrix_is_visible boolean
---@field pattern_matrix_is_visible_observable renoise.Document.Observable
---Pattern advanced edit, visible in pattern editor only...
---@field pattern_advanced_edit_is_visible boolean
---@field pattern_advanced_edit_is_visible_observable renoise.Document.Observable
---Mixer views Pre/Post volume setting.
---@field mixer_view_post_fx boolean
---@field mixer_view_post_fx_observable renoise.Document.Observable
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
