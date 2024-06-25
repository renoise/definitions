---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## PluginInfo

---@class PluginInfo
---@field path string The plugin's path used by load_plugin()
---@field name string The plugin's name
---@field short_name string The plugin's name as displayed in shortened lists
---@field favorite_name string The plugin's name as displayed in favorites
---@field is_favorite string true if the plugin is a favorite
---@field is_bridged string true if the plugin is a bridged plugin

--------------------------------------------------------------------------------
---## renoise.InstrumentPluginProperties

---### properties

---@class renoise.InstrumentPluginProperties
---
---**READ-ONLY** List of all currently available plugins. This is a list of
---unique plugin names which also contains the plugin's type (VST/AU/DSSI/...),
---not including the vendor names as visible in Renoise's GUI. So its an
---identifier, and not the name as visible in the GUI. When no plugin is loaded,
---the identifier is an empty string.
---@field available_plugins string[]
---
---**READ-ONLY** Returns a list of tables containing more information about the plugins.
---@field available_plugin_infos PluginInfo[]
---
---**READ-ONLY** Returns true when a plugin is present; loaded successfully.
---@see renoise.PluginProperties.plugin_device_observable for related notifications.
---@field plugin_loaded boolean
---
---Valid object for successfully loaded plugins, otherwise nil. Alias plugin
---instruments of FX will return the resolved device, will link to the device
---the alias points to.
---The observable is fired when the device changes: when a plugin gets loaded or
---unloaded or a plugin alias is assigned or unassigned.
---@field plugin_device (renoise.InstrumentPluginDevice|renoise.AudioDevice)?
---@field plugin_device_observable renoise.Document.Observable
---
---**READ-ONLY** Valid for loaded and unloaded plugins.
---@field alias_instrument_index integer 0 when no alias instrument is set
---@field alias_instrument_index_observable renoise.Document.Observable
---**READ-ONLY** 0 when no alias FX is set
---@field alias_fx_track_index integer
---@field alias_fx_track_index_observable renoise.Document.Observable
---**READ-ONLY** 0 when no alias FX is set
---@field alias_fx_device_index integer
---@field alias_fx_device_index_observable renoise.Document.Observable
---
---**READ-ONLY** Valid for loaded and unloaded plugins.
---target instrument index of the plugin's MIDI output (when present)
---@field midi_output_routing_index integer 0 when no routing is set
---@field midi_output_routing_index_observable renoise.Document.Observable
---
---Valid for loaded and unloaded plugins.
---@field channel integer Range: (1 - 16)
---@field channel_observable renoise.Document.Observable
---@field transpose integer Range: (-120 - 120)
---@field transpose_observable renoise.Document.Observable
---
---Valid for loaded and unloaded plugins.
---@field volume number Range: (0.0 - 4.0) linear gain
---@field volume_observable renoise.Document.Observable
---
---Valid for loaded and unloaded plugins.
---@field auto_suspend boolean
---@field auto_suspend_observable renoise.Document.Observable
renoise.InstrumentPluginProperties = {}

---### functions

---Load an existing, new, non aliased plugin. Pass an empty string to unload
---an already assigned plugin. plugin_path must be one of the available plugins
---@see renoise.InstrumentPluginProperties.available_plugins
---@param plugin_path string
---@return boolean success
function renoise.IntrumentPluginProperties:load_plugin(plugin_path) end

--------------------------------------------------------------------------------
---## renoise.InstrumentDevice

---@deprecated - alias for InstrumentPluginDevice
---@see renoise.InstrumentPluginDevice
---
---@class renoise.InstrumentDevice

--------------------------------------------------------------------------------
---## renoise.InstrumentPluginDevice

---### properties

---@class renoise.InstrumentPluginDevice
---
---**READ-ONLY** Device name.
---@field name string
---**READ-ONLY**
---@field short_name string
---
---**READ-ONLY**
---@field presets string[]
---Preset handling. 0 when when none is active (or available)
---@field active_preset integer
---@field active_preset_observable renoise.Document.Observable
---raw XML data of the active preset
---@field active_preset_data string
---
---**READ-ONLY**
---@field parameters renoise.DeviceParameter[]
---
---**READ-ONLY** Returns whether or not the plugin provides its own custom GUI.
---
---@field external_editor_available boolean
---
---When the plugin has no custom GUI, Renoise will create a dummy editor for it which
---lists the plugin parameters.
---set to true to show the editor, false to close it
---@field external_editor_visible boolean
---
---**READ-ONLY** Returns a string that uniquely identifies the plugin
---@see renoise.InstrumentPluginProperties.available_plugins for the list of valid paths
---The string can be passed into: renoise.InstrumentPluginProperties:load_plugin()
---@field device_path string
renoise.InstrumentPluginDevice = {}

---### functions

---Access to a single preset name by index. Use properties 'presets' to iterate
---over all presets and to query the presets count.
---@param index integer
---@return string
function renoise.InstrumentPluginDevice:preset(index) end

---Access to a single parameter by index. Use properties 'parameters' to iterate
---over all parameters and to query the parameter count.
---@param index integer
---@return renoise.DeviceParameter
function renoise.InstrumentPluginDevice:parameter(index) end
