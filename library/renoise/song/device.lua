---@meta
---Do not try to execute this file. It's just a type definition file.
---
---This reference lists all available Lua functions and classes that control
---Renoise's main audio effect document in the the song.
---Instruments, Tracks, Patterns, and so on.
---
---Please read the `Introduction.md` in the Renoise scripting Documentation
---folder first to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.AudioDevice
renoise.AudioDevice = {}

---Represents an audio DSP device in tracks or sample device chains.
---@class renoise.AudioDevice
---
---Fixed name of the device.
---@field name string **READ-ONLY** 
---@field short_name string **READ-ONLY** 
---
---Configurable device display name. When empty `name` is displayed.
---@field display_name string
---@field display_name_observable renoise.Document.Observable 
---
---Enable/bypass the device.
---@field is_active boolean !active = bypassed
---@field is_active_observable renoise.Document.Observable
---
---Maximize state in DSP chain.
---@field is_maximized boolean
---@field is_maximized_observable renoise.Document.Observable
---
---Preset handling.
---@field active_preset number 0 when none is active or available
---@field active_preset_observable renoise.Document.Observable
---@field active_preset_data string raw serialized data in XML format of the active preset
---@field presets string[] **READ-ONLY** preset names
---
---Parameters.
---@field is_active_parameter renoise.DeviceParameter **READ-ONLY** 
---@field parameters renoise.DeviceParameter[] **READ-ONLY**
---
---**READ-ONLY** Returns whether or not the device provides its own custom GUI 
---(only available for some plugin devices)
---@field external_editor_available boolean
---
---When the device has no custom GUI an error will be fired (see
---external_editor_available), otherwise the external editor is opened/closed.
---@field external_editor_visible boolean true to show the editor, false to close it
---
---**READ-ONLY** Returns a string that uniquely identifies the device, from 
---`available_devices`. The string can be passed into: 
---`renoise.song().tracks[]:insert_device_at()`
---@field device_path string

---### functions

---Access to a single preset name by index. Use properties 'presets' to iterate 
---over all presets and to query the presets count.
---comment
---@param index integer
---@return string preset_name
function renoise.AudioDevice:preset(index) end

---Access to a single parameter by index. Use properties 'parameters' to iterate 
---over all parameters and to query the parameter count.
---@param index integer
---@return renoise.DeviceParameter
function renoise.AudioDevice:parameter(index) end

--------------------------------------------------------------------------------
---## renoise.DeviceParameter

---### constants

---@enum renoise.DeviceParameter.Polarity
renoise.DeviceParameter = {
  POLARITY_UNIPOLAR = 1,
  POLARITY_BIPOLAR = 2
}

---A single parameter within an audio DSP effect (renoise.AudioDevice)
---@class renoise.DeviceParameter
---
---Device parameters.
---@field name string **READ-ONLY**
---@field polarity renoise.DeviceParameter.Polarity **READ-ONLY**
---
---@field value_min number **READ-ONLY**
---@field value_max number **READ-ONLY**
---@field value_quantum number **READ-ONLY**
---@field value_default number **READ-ONLY**
---
---The minimum interval in pattern lines (as a number) at which a parameter can
---have automation points. It is 1/256 for most parameters, but 1 for e.g. song
---tempo, LPB and TPL which can only be automated once per pattern line.
---@field time_quantum number **READ-ONLY**
---
---Not valid for parameters of instrument devices. Returns true if creating
---envelope automation is possible for the parameter (see also
---renoise.song().patterns[].tracks[]:create_automation)
---@field is_automatable boolean **READ-ONLY**
---
---**READ-ONLY** Is automated. Not valid for parameters of instrument devices.
---@field is_automated boolean
---@field is_automated_observable renoise.Document.Observable
---
---**READ-ONLY** Parameter has a custom MIDI mapping in the current song.
---@field is_midi_mapped boolean
---@field is_midi_mapped_observable renoise.Document.Observable
----
---Show in mixer. Not valid for parameters of instrument devices.
---@field show_in_mixer boolean
---@field show_in_mixer_observable renoise.Document.Observable
---
---Values.
---@field value number value in [value_min - value_max]
---@field value_observable renoise.Document.Observable
---
---@field value_string string
---@field value_string_observable renoise.Document.Observable
---
renoise.DeviceParameter = { }

---### functions

---Set a new value and write automation when the MIDI mapping
---"record to automation" option is set. Only works for parameters
---of track devices, not for instrument devices.
---@param value number
function renoise.DeviceParameter:record_value(value) end
