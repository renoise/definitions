--------------------------------------------------------------------------------
---## renoise.AudioDevice

-------- Properties

-- Fixed name of the device.
renoise.song().tracks[].devices[].name
  -> [read-only, string]
renoise.song().tracks[].devices[].short_name
  -> [read-only, string]

-- Configurable device display name.
renoise.song().tracks[].devices[].display_name, observable 
  -> [string, long device name or custom name]

-- Enable/bypass the device.
renoise.song().tracks[].devices[].is_active, _observable
  -> [boolean, not active = bypassed]

-- Maximize state in DSP chain.
renoise.song().tracks[].devices[].is_maximized, _observable
  -> [boolean]

-- Preset handling.
renoise.song().tracks[].devices[].active_preset, _observable
  -> [number, 0 when none is active or available]
renoise.song().tracks[].devices[].active_preset_data
  -> [string, raw serialized data in XML format of the active preset]
renoise.song().tracks[].devices[].presets[]
  -> [read-only, array of strings]

-- Parameters.
renoise.song().tracks[].devices[].is_active_parameter
  -> [read-only, renoise.DeviceParameter object]

renoise.song().tracks[].devices[].parameters[]
  -> [read-only, array of renoise.DeviceParameter objects]

-- Returns whether or not the device provides its own custom GUI (only 
-- available for some plugin devices)
renoise.song().tracks[].devices[].external_editor_available
  -> [read-only, boolean]

-- When the device has no custom GUI an error will be fired (see
-- external_editor_available), otherwise the external editor is opened/closed.
renoise.song().tracks[].devices[].external_editor_visible
  -> [boolean, true to show the editor, false to close it]
  
-- Returns a string that uniquely identifies the device, from "available_devices".
-- The string can be passed into: renoise.song().tracks[]:insert_device_at()
renoise.song().tracks[].devices[].device_path
  -> [read-only, string]

-------- Functions

-- Access to a single preset name by index. Use properties 'presets' to iterate 
-- over all presets and to query the presets count.
renoise.song().tracks[].devices[]:preset(index)
  -> [string]

-- Access to a single parameter by index. Use properties 'parameters' to iterate 
-- over all parameters and to query the parameter count.
renoise.song().tracks[].devices[]:parameter(index)
  -> [renoise.DeviceParameter object]


--------------------------------------------------------------------------------
-- renoise.DeviceParameter
--------------------------------------------------------------------------------

-------- Constants

renoise.DeviceParameter.POLARITY_UNIPOLAR
renoise.DeviceParameter.POLARITY_BIPOLAR


-------- Properties

-- Device parameters.
renoise.song().tracks[].devices[].parameters[].name
  -> [read-only, string]

renoise.song().tracks[].devices[].parameters[].polarity
  -> [read-only, enum = POLARITY]

renoise.song().tracks[].devices[].parameters[].value_min
  -> [read-only, number]
renoise.song().tracks[].devices[].parameters[].value_max
  -> [read-only, number]
renoise.song().tracks[].devices[].parameters[].value_quantum
  -> [read-only, number]
renoise.song().tracks[].devices[].parameters[].value_default
  -> [read-only, number]

-- The minimum interval in pattern lines (as a number) at which a parameter can
-- have automation points. It is 1/256 for most parameters, but 1 for e.g. song
-- tempo, LPB and TPL which can only be automated once per pattern line.
renoise.song().tracks[].devices[].parameters[].time_quantum
  -> [read-only, number]

-- Not valid for parameters of instrument devices. Returns true if creating
-- envelope automation is possible for the parameter (see also
-- renoise.song().patterns[].tracks[]:create_automation)
renoise.song().tracks[].devices[].parameters[].is_automatable
  -> [read-only, boolean]

-- Is automated. Not valid for parameters of instrument devices.
renoise.song().tracks[].devices[].parameters[].is_automated, _observable
  -> [read-only, boolean]

-- parameter has a custom MIDI mapping in the current song.
renoise.song().tracks[].devices[].parameters[].is_midi_mapped, _observable 
  -> [read-only, boolean]
  
-- Show in mixer. Not valid for parameters of instrument devices.
renoise.song().tracks[].devices[].parameters[].show_in_mixer, _observable
  -> [boolean]

-- Values.
renoise.song().tracks[].devices[].parameters[].value, _observable
  -> [number]
renoise.song().tracks[].devices[].parameters[].value_string, _observable
  -> [string]

-------- Functions

-- Set a new value and write automation when the MIDI mapping
-- "record to automation" option is set. Only works for parameters
-- of track devices, not for instrument devices.
renoise.song().tracks[].devices[].parameters[]:record_value(value)




