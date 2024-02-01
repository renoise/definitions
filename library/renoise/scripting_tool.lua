---@meta
---Do not try to execute this file. It's just a type definition file.
---
---This reference lists Lua functions and classes to manage Renoise XRNX 
---"scripting tool" packages. 
---
---Please read the Introduction.md first to get an overview about the complete
---API, and scripting for Renoise in general...
---
---Also have a look at the com.renoise.ExampleTool.xrnx for guided examples.
---

--------------------------------------------------------------------------------
---## renoise.ScriptingTool

---The scripting tool interface allows your tool to interact with Renoise by
---injecting or creating menu entries and keybindings into Renoise; or by 
---attaching it to some common tool related notifiers.
---@class renoise.ScriptingTool
---
---**READ_ONLY** Full absolute path and name to your tool's bundle directory.
---@field bundle_path string
---
---Invoked when the tool finished loading/initializing and no errors happened.
---When the tool has preferences, they are loaded here as well when the 
---notification fires, but 'renoise.song()' may not yet be available.
---
---See also 'renoise.tool().app_new_document_observable'.
---@field tool_finished_loading_observable renoise.Document.Observable
---
---Invoked right before a tool gets unloaded: either because it got disabled,
---reloaded or the application exists. You can cleanup resources or connections
---to other devices here if necessary.
---@field tool_will_unload_observable renoise.Document.Observable
---
---Invoked as soon as the application becomes the foreground window.
---For example, when you ATL-TAB to it, or activate it with the mouse
---from another app to Renoise.
---@field app_became_active_observable renoise.Document.Observable
---
---Invoked as soon as the application looses focus and another app
---becomes the foreground window.
---@field app_resigned_active_observable renoise.Document.Observable
---
---Invoked periodically in the background, more often when the work load
---is low, less often when Renoise's work load is high.
---The exact interval is undefined and can not be relied on, but will be
---around 10 times per sec.
---You can do stuff in the background without blocking the application here.
---Be gentle and don't do CPU heavy stuff please!
---@field app_idle_observable renoise.Document.Observable
---
---Invoked each time before a new document gets created or loaded: this is the
---last time renoise.song() still points to the old song before a new one arrives.
---You can explicitly release notifiers to the old document here, or do your own
---housekeeping. Also called right before the application exits.
---@field app_release_document_observable renoise.Document.Observable
---
---Invoked each time a new document (song) is created or loaded. In other words:
---each time the result of renoise.song() is changed. Also called when the script
---gets reloaded (only happens with the auto_reload debugging tools), in order
---to connect the new script instance to the already running document.
---@field app_new_document_observable renoise.Document.Observable
---
---Invoked each time the app's document (song) is successfully saved.
---renoise.song().file_name will point to the filename that it was saved to.
---@field app_saved_document_observable renoise.Document.Observable
---
---Get or set an optional renoise.Document.DocumentNode object, which will be
---used as set of persistent "options" or preferences for your tool.
---By default nil. When set, the assigned document object will automatically be
---loaded and saved by Renoise, to retain the tools state.
---The preference XML file is saved/loaded within the tool bundle as
---"com.example.your_tool.xrnx/preferences.xml".
---
---### example:
---```lua
----- create a document via "Document.create"
---my_options = renoise.Document.create("ScriptingToolPreferences") {
--- some_option = true,
--- some_value = "string_value"
---}
---
----- or create a document by inheriting from renoise.Document.DocumentNode
---class "ExampleToolPreferences"(renoise.Document.DocumentNode)
---  function ExampleToolPreferences:__init()
---    renoise.Document.DocumentNode.__init(self)
---    self:add_property("some_option", true)
---    self:add_property("some_value", "string_value")
---  end
---
---  my_options = ExampleToolPreferences()
---  -- values can be accessed (read, written) via
---  my_options.some_option.value = false
---  -- also notifiers can be added to listen to changes to the values
---  -- done by you, or after new values got loaded or a view changed the value:
---  my_options.some_option:add_notifier(function() end)
---
----- and assign it:
---renoise.tool().preferences = my_options
----- 'my_options' will be loaded/saved automatically with the tool now
---```
---@field preferences renoise.Document.DocumentNode?
renoise.ScriptingTool = {}

---### functions

-------------------------------------------------------------------------------

---Defines a menu entry somewhere in Renoise's existing context menus or the
---global app menu. Insertion can be done during script initialization, but
---can also be done dynamically later on.
---
---You can place your entries in any context menu or any window menu in Renoise.
---To do so, use one of the specified categories in its name:
---```lua
---+ "Window Menu" -- Renoise icon menu in the window caption on Windows/Linux
---+ "Main Menu:XXX" (with XXX = ":File", ":Edit", ":View", ":Tools" or ":Help") -- Main menu
---+ "Scripting Menu:XXX" (with XXX = ":File" or ":Tools") -- Scripting Editor & Terminal
---+ "Disk Browser Directories"
---+ "Disk Browser Files"
---+ "Instrument Box"
---+ "Pattern Sequencer"
---+ "Pattern Editor"
---+ "Pattern Matrix"
---+ "Pattern Matrix Header"
---+ "Phrase Editor"
---+ "Phrase Mappings"
---+ "Phrase Grid"
---+ "Sample Navigator"
---+ "Sample Editor"
---+ "Sample Editor Ruler"
---+ "Sample Editor Slice Markers"
---+ "Sample List"
---+ "Sample Mappings"
---+ "Sample FX Mixer"
---+ "Sample Modulation Matrix"
---+ "Mixer"
---+ "Master Spectrum"
---+ "Track Automation"
---+ "Track Automation List"
---+ "DSP Chain"
---+ "DSP Chain List"
---+ "DSP Device"
---+ "DSP Device Header"
---+ "DSP Device Automation"
---+ "Modulation Set"
---+ "Modulation Set List"
---+ "Tool Browser"
---+ "Script File Browser"
---+ "Script File Tabs"
---```
---Separating entries:
---To divide entries into groups (separate entries with a line), prepend one or
---more dashes to the name, like "--- Main Menu:Tools:My Tool Group Starts Here"
---@class ToolMenuEntry
---Name and 'path' of the entry as shown in the global menus or context menus
---to the user.
---@field name string
---A function that is called as soon as the entry is clicked
---@field invoke fun()
---A function that should return true or false. When returning false, the action
---will not be invoked and will be "greyed out" in menus. This function is always
---called before "invoke", and every time prior to a menu becoming visible.
---@field active fun():boolean?
---A function that should return true or false. When returning true, the entry
---will be marked as "this is a selected option"
---@field selected fun():boolean?

---Returns true if the given entry already exists, otherwise false.
---@param entry_name string The menu entry name e.g. "Main Menu:Tools:My Tool".
---@return boolean
function renoise.ScriptingTool:has_menu_entry(entry_name) end

---Add a new menu entry.
---@param entry ToolMenuEntry
function renoise.ScriptingTool:add_menu_entry(entry) end

---Remove a previously added menu entry by specifying its full name.
---@param entry_name string The menu entry name e.g. "Main Menu:Tools:My Tool".
function renoise.ScriptingTool:remove_menu_entry(entry_name) end

-------------------------------------------------------------------------------

---Register tool key bindings somewhere in Renoise's existing set of bindings.
---
---Please note: there's no way to define default keyboard shortcuts for your
---entries. Users manually have to bind them in the keyboard prefs pane.
---As soon as they do, they'll get saved just like any other key binding in
---Renoise.
---@class ToolKeybindingEntry
---The scope, name and category of the key binding use the form:
---`$scope:$topic_name:$binding_name`:
---
---`$scope` is where the shortcut will be applied, just like those
---in the categories list for the keyboard assignment preference pane.
---Your key binding will only fire, when the scope is currently focused,
---except it's the global scope one.
---Using an unavailable scope will not fire an error, instead it will render
---the binding useless. It will be listed and mappable, but never be invoked.
---
---`$topic_name` is useful when grouping entries in the key assignment pane.
---Use "tool" if you can't come up with something meaningful.
---
---`$binding_name` is the name of the binding.
---
----Currently available scopes are:
---```lua
---+ "Global"
---+ "Automation"
---+ "Disk Browser"
---+ "DSPs Chain"
---+ "Instrument Box"
---+ "Mixer"
---+ "Pattern Editor" 
---+ "Pattern Matrix"
---+ "Pattern Sequencer"
---+ "Sample Editor"
---+ "Sample FX Mixer"
---+ "Sample Keyzones"
---+ "Sample Modulation Matrix"
---```
---@field name string
---A function that is called as soon as the mapped key is pressed.
---The callback parameter "repeated", indicates if its a virtual key repeat.
---@field invoke fun(repeated: boolean)

---Returns true when the given keybinging already exists, otherwise false.
---@param keybinding_name string Name of the binding e.g. "Global:My Tool:My Action" 
---@return boolean
function renoise.ScriptingTool:has_keybinding(keybinding_name) end

---Register key bindings somewhere in Renoise's existing set of bindings.
---@param keybinding ToolKeybindingEntry
function renoise.ScriptingTool:add_keybinding(keybinding) end

-- Remove a previously added key binding by specifying its name and path.
---@param keybinding_name string Name of the binding e.g. "Global:My Tool:My Action" 
function renoise.ScriptingTool:remove_keybinding(keybinding_name) end

-------------------------------------------------------------------------------

---MIDI message as passed to the `invoke` callback in tool midi_mappings.
---@class renoise.ScriptingTool.MidiMessage
---[0 - 127] for abs values, [-63 - 63] for relative values
---valid when `is_rel_value()` or `is_abs_value()` returns true, else undefined
---@field int_value integer|nil
-- valid [true OR false] when `is_switch()` returns true, else undefined
---@field boolean_value boolean|nil
renoise.ScriptingTool.MidiMessage = {}

-- returns if action should be invoked
function renoise.ScriptingTool.MidiMessage:is_trigger() end

---check if the boolean_value property is valid
function renoise.ScriptingTool.MidiMessage:is_switch() end

---check if the int_value property is valid
---@return boolean
function renoise.ScriptingTool.MidiMessage:is_rel_value() end

---check if the int_value property is valid
---@return boolean
function renoise.ScriptingTool.MidiMessage:is_abs_value() end

-------------------------------------------------------------------------------

---Extend Renoise's default MIDI mapping set, or add custom MIDI mappings
---for your tool.
---
---A tool's MIDI mapping can be used just like the regular mappings in
---Renoise: Either by manually looking its up the mapping in the MIDI mapping
---list, then binding it to a MIDI message, or when your tool has a custom GUI,
---specifying the mapping via a control's `control.midi_mapping` property.
---Such controls will then get highlighted as soon as the MIDI mapping dialog is
---opened. Then, users simply click on the highlighted control to map MIDI
---messages.
---@class ToolMidiMappingEntry
---The group, name of the midi mapping; as visible to the user.
---
---The scope, name and category of the midi mapping use the form:
---`$topic_name:$optional_sub_topic_name:$name`:
---
---`$topic_name` and `$optional_sub_topic_name` will create new groups in
---the list of MIDI mappings, as seen in Renoise's MIDI mapping dialog.
---If you can't come up with a meaningful string, use your tool's name
---as topic name.
---
---Existing global mappings from Renoise can be overridden. In this case the
---original mappings are no longer called, only your tool's mapping.
---@field name string
---A function that is called to handle a bound MIDI message.
---@field invoke fun(message: renoise.ScriptingTool.MidiMessage)

---Returns true when the given mapping already exists, otherwise false.
---@param midi_mapping_name string Name of the mapping. 
---@return boolean
function renoise.ScriptingTool:has_midi_mapping(midi_mapping_name) end

---Add a new midi_mapping entry.
---@param midi_mapping ToolMidiMappingEntry
function renoise.ScriptingTool:add_midi_mapping(midi_mapping) end

-- Remove a previously added midi mapping by specifying its name.
---@param midi_mapping_name string Name of the mapping. 
function renoise.ScriptingTool:remove_midi_mapping(midi_mapping_name) end

-------------------------------------------------------------------------------

---@alias FileHookCategory "song"|"instrument"|"effect chain"|"effect preset"|"modulation set"|"phrase"|"sample"|"theme"

---Add support for new filetypes in Renoise. Registered file types will show up
---in Renoise's disk browser and can also be loaded by drag and dropping the
---files onto the Renoise window. When adding hooks for files which Renoise
---already supports, your tool's import functions will override the internal
---import functions.
---
---Always load the file into the currently selected component, like
---'renoise.song().selected_track','selected_instrument','selected_sample'.
---
---Preloading/prehearing sample files is not supported via tools.
---
---@class ToolFileImportHook
---In which disk browser category the file type shows up.
---One of 
---@field category FileHookCategory
--- A list of strings, file extensions, that will invoke your hook, like for
---example {"txt", "s_wave"}
---@field extensions string[]
---function that is called to do the import. return true when the import
---succeeded, else false.
---@field invoke fun(file_name: string): boolean

---Returns true when the given hook already exists, otherwise false.
---@param category FileHookCategory
---@param extensions_table string[]
---@return boolean
function renoise.ScriptingTool:has_file_import_hook(category, extensions_table) end

---Add a new file import hook as described above.
---@param file_import_hook ToolFileImportHook
function renoise.ScriptingTool:add_file_import_hook(file_import_hook) end

---Remove a previously added file import hook by specifying its category
---and extension(s)
---@param category FileHookCategory
---@param extensions_table string[]
function renoise.ScriptingTool:remove_file_import_hook(category, extensions_table) end

-------------------------------------------------------------------------------

---@alias TimerFunction fun()
---@alias TimerMemberContext table|userdata
---@alias TimerMemberFunction fun(self: NotifierMemberContext)
---@alias TimerMethod1 {[1]:NotifierMemberContext, [2]:NotifierMemberFunction}
---@alias TimerMethod2 {[1]:NotifierMemberFunction, [2]:NotifierMemberContext}

---Returns true when the given function or method was registered as a timer.
---@return boolean
---@param timer TimerFunction
---@overload fun(self, timer_method: TimerMethod1)
---@overload fun(self, timer_method: TimerMethod2)
function renoise.ScriptingTool:has_timer(timer) end

---Register a timer function or table with a function and context (a method)
---that periodically gets called by the `app_idle_observable` for your tool.
---
---Modal dialogs will avoid that timers are called. To create a one-shot timer,
---simply call remove_timer at the end of your timer function.
---
---`interval_in_ms` must be > 0. The exact interval your function is called
---will vary a bit, depending on workload; e.g. when enough CPU time is available
---the rounding error will be around +/- 5 ms.
---@param timer TimerFunction
---@param interval_in_ms number
---@overload fun(self, timer_method: TimerMethod1, interval_in_ms: number)
---@overload fun(self, timer_method: TimerMethod2, interval_in_ms: number)
function renoise.ScriptingTool:add_timer(timer, interval_in_ms) end

-- Remove a previously registered timer.
---@param timer TimerFunction
---@overload fun(self, timer_method: TimerMethod1)
---@overload fun(self, timer_method: TimerMethod2)
function renoise.ScriptingTool:remove_timer(timer) end

--------------------------------------------------------------------------------
--- ## globals

---When working with Renoise's Scripting Editor, saving a script will
---automatically reload the tool that belongs to the file. This way you can
---simply change your files and immediately see/test the changes within Renoise.
---
---When working with an external text editor, you can enable the following debug
---option somewhere in the tool's main.lua file:
---```lua
---_AUTO_RELOAD_DEBUG = function()
---  -- do tests like showing a dialog, prompts whatever, or simply do nothing
---end
---```
---Now, as soon as you save your script outside of Renoise, and then focus Renoise
---again (alt-tab to Renoise, for example), your script will instantly get reloaded
---and the notifier is called.
---
---If you don't need a notifier function to be called each time the script reloads,
---you can also simply set `_AUTO_RELOAD_DEBUG = true` to enable the automatic
---reloading of your tool.
---@type nil|true|fun()
_AUTO_RELOAD_DEBUG = nil;
