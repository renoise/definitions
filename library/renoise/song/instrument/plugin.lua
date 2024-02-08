

--------------------------------------------------------------------------------
-- renoise.InstrumentPluginProperties
--------------------------------------------------------------------------------

-------- Functions

-- Load an existing, new, non aliased plugin. Pass an empty string to unload
-- an already assigned plugin. plugin_path must be one of:
-- plugin_properties.available_plugins.
renoise.song().instruments[].plugin_properties:load_plugin(plugin_path)
  -> [boolean, success]


-------- Properties

-- List of all currently available plugins. This is a list of unique plugin
-- names which also contains the plugin's type (VST/AU/DSSI/...), not including
-- the vendor names as visible in Renoise's GUI. Aka, its an identifier, and not
-- the name as visible in the GUI. When no plugin is loaded, the identifier is
-- an empty string.
renoise.song().instruments[].plugin_properties.available_plugins[]
  -> [read_only, array of strings]

-- Returns a list of tables containing more information about the plugins. 
-- Each table has the following fields:
--  {
--    path,           -- The plugin's path used by load_plugin()
--    name,           -- The plugin's name
--    short_name,     -- The plugin's name as displayed in shortened lists
--    favorite_name,  -- The plugin's name as displayed in favorites
--    is_favorite,    -- true if the plugin is a favorite
--    is_bridged      -- true if the plugin is a bridged plugin
--  }
renoise.song().instruments[].plugin_properties.available_plugin_infos[]
  -> [read-only, array of plugin info tables]
  
-- Returns true when a plugin is present; loaded successfully.
-- see 'plugin_properties.plugin_device_observable' for related notifications.
renoise.song().instruments[].plugin_properties.plugin_loaded
  -> [read-only, boolean]

-- Valid object for successfully loaded plugins, otherwise nil. Alias plugin
-- instruments of FX will return the resolved device, will link to the device
-- the alias points to.
-- The observable is fired when the device changes: when a plugin gets loaded or
-- unloaded or a plugin alias is assigned or unassigned.
renoise.song().instruments[].plugin_properties.plugin_device, _observable
 -> [renoise.InstrumentPluginDevice object or renoise.AudioDevice object or nil]

-- Valid for loaded and unloaded plugins.
renoise.song().instruments[].plugin_properties.alias_instrument_index, _observable
  -> [read-only, number or 0 (when no alias instrument is set)]
renoise.song().instruments[].plugin_properties.alias_fx_track_index, _observable
  -> [read-only, number or 0 (when no alias FX is set)]
renoise.song().instruments[].plugin_properties.alias_fx_device_index, _observable
  -> [read-only, number or 0 (when no alias FX is set)]

-- Valid for loaded and unloaded plugins. target instrument index or 0 of the 
-- plugin's MIDI output (when present)
renoise.song().instruments[].plugin_properties.midi_output_routing_index, _observable
  -> [read-only, number. 0 when no routing is set]
  
-- Valid for loaded and unloaded plugins.
renoise.song().instruments[].plugin_properties.channel, _observable
  -> [number, 1-16]
renoise.song().instruments[].plugin_properties.transpose, _observable
  -> [number, -120-120]

-- Valid for loaded and unloaded plugins.
renoise.song().instruments[].plugin_properties.volume, _observable
  -> [number, linear gain, 0-4]

-- Valid for loaded and unloaded plugins.
renoise.song().instruments[].plugin_properties.auto_suspend, _observable
  -> [boolean]


--------------------------------------------------------------------------------
-- renoise.InstrumentDevice
--------------------------------------------------------------------------------

-- DEPRECATED - alias for renoise.InstrumentPluginDevice


--------------------------------------------------------------------------------
-- renoise.InstrumentPluginDevice
--------------------------------------------------------------------------------

-------- Functions

-- Access to a single preset name by index. Use properties 'presets' to iterate 
-- over all presets and to query the presets count.
renoise.song().instruments[].plugin_properties.plugin_device:preset(index)
  -> [string]

-- Access to a single parameter by index. Use properties 'parameters' to iterate 
-- over all parameters and to query the parameter count.
renoise.song().instruments[].plugin_properties.plugin_device:parameter(index)
  -> [renoise.DeviceParameter object]


-------- Properties

-- Device name.
renoise.song().instruments[].plugin_properties.plugin_device.name
  -> [read-only, string]
renoise.song().instruments[].plugin_properties.plugin_device.short_name
  -> [read-only, string]

-- Preset handling.
renoise.song().instruments[].plugin_properties.plugin_device.active_preset, _observable
  -> [number, 0 when none is active or available]
  
renoise.song().instruments[].plugin_properties.plugin_device.active_preset_data
  -> [string, raw XML data of the active preset]

renoise.song().instruments[].plugin_properties.plugin_device.presets[]
  -> [read-only, array of strings]

-- Parameters.
renoise.song().instruments[].plugin_properties.plugin_device.parameters[]
  -> [read-only, array of renoise.DeviceParameter objects]

-- Returns whether or not the plugin provides its own custom GUI.
renoise.song().instruments[].plugin_properties.plugin_device.external_editor_available
  -> [read-only, boolean]

-- When the plugin has no custom GUI, Renoise will create a dummy editor for it which
-- lists the plugin parameters.
renoise.song().instruments[].plugin_properties.plugin_device.external_editor_visible
  -> [boolean, set to true to show the editor, false to close it]

-- Returns a string that uniquely identifies the plugin, from "available_plugins".
-- The string can be passed into: plugin_properties:load_plugin()
renoise.song().instruments[].plugin_properties.plugin_device.device_path
  -> [read_only, string]


