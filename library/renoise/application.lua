---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Application

---The Renoise application.
---@class renoise.Application
renoise.Application = {}

---### properties

---@class renoise.Application
---
---**READ-ONLY** Access to the application's full log filename and path. Will
---already be opened for writing, but you nevertheless should be able to read
---from it.
---@field log_filename string
---
---**READ-ONLY** Get the apps main document, the song.
---The global "renoise.song()" function is, in fact, a shortcut to this property.
---@field current_song renoise.Song?
---
---**READ-ONLY** List of recently loaded song files.
---@field recently_loaded_song_files string[]
---
---**READ-ONLY** List of recently saved song files.
---@field recently_saved_song_files string[]
---
---**READ-ONLY** Returns information about all currently installed tools.
---@field installed_tools table<string, string>
---
---**READ-ONLY** Access keyboard modifier states.
---@deprecated Use `key_modifier_flags` instead
---@field key_modifier_states table<string, string>
---**READ-ONLY** Access keyboard modifier states.
---@field key_modifier_flags ModifierFlags
---
---**READ-ONLY** Access to the application's window.
---@field window renoise.ApplicationWindow
---
---**READ-ONLY** Access to the application's color theme.
---@field theme renoise.ApplicationTheme
---Fired, when *any* theme color changed. e.g. when a new theme got loaded
---or when theme colors got edited in the theme preferences.
---@field theme_observable renoise.Document.Observable
---
---Range: (1 - 4) Get or set globally used clipboard "slots" in the application.
---@field active_clipboard_index 1|2|3|4

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

---The title that shows up at the title-bar of the dialog.
---@alias DialogTitle string

---Opens a modal dialog with a title, text and custom button labels.
---Returns the pressed button label or an empty string when canceled.
---@param title string Message box title.
---@param message string Message box content text.
---@param button_labels string[]? Default: {"Ok"}
---@return string label
function renoise.Application:show_prompt(title, message, button_labels) end

---The modifier keys will be provided as a string.  
---Possible keys are dependent on the platform
--- * Windows : "shift", "alt", "control", "winkey"
--- * Linux : "shift", "alt", "control", "meta"
--- * Mac : "shift", "option", "control", "command"
---If multiple modifiers are held down, the string will be formatted as  
---"<key> + <key>"
---Their order will correspond to the following precedence
---`shift + alt/option + control + winkey/meta/command`  
---If no modifier is pressed, this will be an empty string.
---@deprecated use ModifierFlags instead.
---@alias ModifierStates string

---The currently pressed/release key's modifiers as platform independent flags.
---On macOS "control" is their "Command" key and the "meta" keyboard is the "Control" key.
---On Windows the "meta" key is the "Windows" key and on Linux the "Super" key.
---@alias ModifierFlags { shift: boolean, control: boolean, alt: boolean, meta: boolean }

---@class KeyEvent
---@field name string name of the key, like 'esc' or 'a'
---**READ-ONLY** the held down modifiers as a string
---@deprecated use `modifier_flags` instead
---@field modifiers ModifierStates
---**READ-ONLY** the held down modifiers as flags
---@field modifier_flags ModifierFlags
---possible character representation of the key
---@field character string?
---virtual keyboard piano key value (starting from 0)
---@field note integer? 
---only present if `send_key_release` was set to true
---@field state ("released"|"pressed")?
---only present if `send_key_repeat` was set to true
---@field repeated boolean?

---Optional keyhandler to process key events on a custom dialog.  
---When returning the passed key from the key-handler function, the
---key will be passed back to Renoise's key event chain, in order to allow
---processing global Renoise key-bindings from your dialog. This will not work
---for modal dialogs. This also only applies to global shortcuts in Renoise,
---because your dialog will steal the focus from all other Renoise views such as
---the Pattern Editor, etc.
---@alias KeyHandler fun(dialog : renoise.Dialog, key_event : KeyEvent) : KeyEvent?
---@alias KeyHandlerMemberFunction fun(self: NotifierMemberContext, dialog: renoise.Dialog, key: KeyEvent): KeyEvent?
---@alias KeyHandlerMethod1 {[1]:NotifierMemberContext, [2]:KeyHandlerMemberFunction}
---@alias KeyHandlerMethod2 {[1]:KeyHandlerMemberFunction, [2]:NotifierMemberContext}

---@class KeyHandlerOptions
---@field send_key_repeat boolean? Default: true
---@field send_key_release boolean? Default: false

---Optional focus change notifier for a custom dialog.  
---Will be called when the dialog gains of loses key focus. You maybe want to initialize 
---your dloag's (modifier) keyboard states here.
---@alias FocusHandler fun(dialogs: renoise.Dialog, focused: boolean) : KeyEvent?
---@alias FocusHandlerMemberFunction fun(self: NotifierMemberContext, dialog: renoise.Dialog, focused: boolean): KeyEvent?
---@alias FocusHandlerMethod1 {[1]:NotifierMemberContext, [2]:FocusHandlerMemberFunction}
---@alias FocusHandlerMethod2 {[1]:FocusHandlerMemberFunction, [2]:NotifierMemberContext}

---Opens a modal dialog with a title, custom content and custom button labels.  
---
---@see renoise.ViewBuilder for more info about custom views.
---@param title string Message box title.
---@param content_view renoise.Views.View Message box content view.
---@param button_labels string[]
---@param key_handler KeyHandler?
---@param key_handler_options KeyHandlerOptions?
---@param focus_handler FocusHandler?
---@overload fun(title: string, content_view: renoise.Views.View, button_labels: string[], key_handler: KeyHandlerMethod1?, key_handler_options: KeyHandlerOptions?, focus_handler: FocusHandlerMethod1?): string
---@overload fun(title: string, content_view: renoise.Views.View, button_labels: string[], key_handler: KeyHandlerMethod2?, key_handler_options: KeyHandlerOptions?, focus_handler: FocusHandlerMethod2?): string
---@return string label
function renoise.Application:show_custom_prompt(title, content_view, button_labels, key_handler, key_handler_options, focus_handler) end


---Shows a non modal dialog (a floating tool window) with custom content.  
---When no key_handler is provided, the Escape key is used to close the dialog.
---
---@see renoise.ViewBuilder for more info about custom views.
---@param title DialogTitle
---@param content_view renoise.Views.View dialog content view.
---@param key_handler KeyHandler?
---@param key_handler_options KeyHandlerOptions?
---@param focus_handler FocusHandler?
---@overload fun(title: string, content_view: renoise.Views.View, key_handler: KeyHandlerMethod1?, key_handler_options: KeyHandlerOptions?, focus_handler: FocusHandlerMethod1?): renoise.Dialog
---@overload fun(title: string, content_view: renoise.Views.View, key_handler: KeyHandlerMethod2?, key_handler_options: KeyHandlerOptions?, focus_handler: FocusHandlerMethod2?): renoise.Dialog
---@return renoise.Dialog
function renoise.Application:show_custom_dialog(title, content_view, key_handler, key_handler_options, focus_handler) end

---Defines a custom menu entry, shown in custom dialog windows.
---
---Separating entries:
---To divide entries into groups prepend one or more dashes to the name:
---```md
------First Group Item
---Regular item
---```
---
---To create sub menus, define entries with a common path, using a colon as separator:
---```md
---Main Menu Item
---Sub Menu:Sub Menu Item 1
---Sub Menu:Sub Menu Item 2
---```
---
---To insert a script menu entry into an existing context menu, see `ToolMenuEntry`.
---@see ToolMenuEntry
---
---@class DialogMenuEntry
---Name and optional path of the menu entry
---@field name string
---A function that is called as soon as the entry is clicked
---@field invoke fun()
---Default: true. When false, the action will not be invoked and will be "greyed out".
---@field active boolean?
---Default: false. When true, the entry will be marked as "this is a selected option"
---@field selected boolean?

---Shows a custom context menu on top of the given dialog.
---
---When specifying a view, the menu will be shown below the given view instance.
---The view instance must be part of the dialog that shows the menu and must be visible.
---By default the menu will be shown at the current mouse cursor position.
---@param dialog renoise.Dialog
---@param menu_entries DialogMenuEntry[]
---@param below_view? renoise.Views.View
function renoise.Application:show_menu(dialog, menu_entries, below_view) end

---Opens a modal dialog to query an existing directory from the user.
---@param title DialogTitle
---@return string path Valid path or empty string when canceled.
function renoise.Application:prompt_for_path(title) end

---Opens a modal dialog to query a filename and path to read from a file.
---@param file_extensions string[] File extension list, e.g. ```{"wav", "aif", "*"}```.
---@param title DialogTitle
---@return string path Valid path or empty string when canceled.
function renoise.Application:prompt_for_filename_to_read(file_extensions, title) end

---Same as 'prompt_for_filename_to_read' but allows the user to select
---more than one file.
---@param file_extensions string[] File extension list, e.g. ```{"wav", "aif", "*"}```.
---@param title DialogTitle
---@return string[] paths Valid paths or empty table when canceled.
function renoise.Application:prompt_for_multiple_filenames_to_read(file_extensions, title) end

---Open a modal dialog to get a filename and path for writing.
---When an existing file is selected, the dialog will ask whether or not to
---overwrite it, so you don't have to take care of this on your own.
---@param file_extension string File extension, e.g. ```"wav"```.
---@param title DialogTitle
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
---When no device chain is selected an error is raised. returns success.
---@param filename string
---@return boolean success
function renoise.Application:save_track_device_chain(filename) end

---Save a currently selected instrument to a file with the given name.
---When no instruemnt is selected an error is raised. returns success.
---@param filename string
---@return boolean success
function renoise.Application:save_instrument(filename) end

---Save a currently selected instrument multi sample file to a file with the given name.
---When no instrument is selected an error is raised. returns success.
---@param filename string
---@return boolean success
function renoise.Application:save_instrument_multi_sample(filename) end

---Save a currently selected instrument's device chain to a file with the given name.
---When no chain is selected an error is raised. returns success.
---@param filename string
---@return boolean success
function renoise.Application:save_instrument_device_chain(filename) end

---Save a currently selected instrument's modulation set to a file with the given name.
---When no modulation is selected an error is raised. returns success.
---@param filename string
---@return boolean success
function renoise.Application:save_instrument_modulation_set(filename) end

---Save a currently selected instrument's phrase to a file with the given name.
---When no phrase is selected an error is raised. returns success.
---@param filename string
---@return boolean success
function renoise.Application:save_instrument_phrase(filename) end

---Save a currently selected instrument's sample to a file with the given name.
---When no sample is selected an error is raised. returns success.
---@param filename string
---@return boolean success
function renoise.Application:save_instrument_sample(filename) end

---Save a current theme to a file with the given name. returns success.
---@param filename string
---@return boolean success
function renoise.Application:save_theme(filename) end

--------------------------------------------------------------------------------
---## renoise.Dialog

---A custom dialog created via the scripting API. Dialogs can be created
---via `renoise.app():show_custom_dialog`.
---
---See `create custom views` on top of the renoise.ViewBuilder docs on how to
---create views for the dialog.
---@class renoise.Dialog
---
--- **READ-ONLY** Check if a dialog is alive and visible.
---@field visible boolean
--- **READ-ONLY** Check if a dialog is visible and is the key window.
---@field focused boolean
renoise.Dialog = {}

---### functions

-- Bring an already visible dialog to front and make it the key window.
function renoise.Dialog:show() end

-- Close a visible dialog.
function renoise.Dialog:close() end
