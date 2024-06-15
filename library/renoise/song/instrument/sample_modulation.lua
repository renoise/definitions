---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.SampleModulationSet

---Available filter types when filter_version = 1
---@alias FilterTypes1
---| "None"
---| "LP -12 dB"
---| "LP -24 dB"
---| "LP -48 dB"
---| "Moog LP"
---| "Single Pole"
---| "HP -12 dB"
---| "HP -24 dB"
---| "Moog HP"
---| "Band Reject"
---| "Band Pass"
---| "EQ -15 dB"
---| "EQ -6 dB"
---| "EQ +6 dB"
---| "EQ +15 dB"
---| "Peaking EQ"
---| "Dist. Low"
---| "Dist. Mid"
---| "Dist. High"
---| "Dist."
---| "AMod"

---Available filter types when filter_version = 2
---@alias FilterTypes2
---| "None"
---| "LP 2x2 Pole"
---| "LP 2 Pole"
---| "LP Biquad"
---| "LP Moog"
---| "LP Single"
---| "HP 2x2 Pole"
---| "HP 2 Pole"
---| "HP Moog"
---| "Band Reject"
---| "Band Pass"
---| "EQ -15 dB"
---| "EQ -6 dB"
---| "EQ +6 dB"
---| "EQ +15 dB"
---| "EQ Peaking"
---| "Dist. Low"
---| "Dist. Mid"
---| "Dist. High"
---| "Dist."
---| "RingMod"

---Available filter types when filter_version = 3
---@alias FilterTypes3 
---| "None"
---| "LP Clean"
---| "LP K35"
---| "LP Moog"
---| "LP Diode"
---| "HP Clean"
---| "HP K35"
---| "HP Moog"
---| "BP Clean"
---| "BP K35"
---| "BP Moog"
---| "BandPass"
---| "BandStop"
---| "Vowel"
---| "Comb"
---| "Decimator"
---| "Dist Shape"
---| "Dist Fold"
---| "AM Sine"
---| "AM Triangle"
---| "AM Saw"
---| "AM Pulse"

---@alias FilterTypes FilterTypes3 | FilterTypes2 | FilterTypes1

---@class renoise.SampleModulationSet
renoise.SampleModulationSet = {}

---### properties

---@class renoise.SampleModulationSet
---
---Name of the modulation set.
---@field name string
---@field name_observable renoise.Document.Observable
---
---Input value for the volume domain
---@field volume_input renoise.DeviceParameter
---
---Input value for the panning domain
---@field panning_input renoise.DeviceParameter
---
---Input value for the pitch domain
---@field pitch_input renoise.DeviceParameter
---
---Input value for the cutoff domain
---@field cutoff_input renoise.DeviceParameter
---
---Input value for the resonance domain
---@field resonance_input renoise.DeviceParameter
---
---Input value for the drive domain
---@field drive_input renoise.DeviceParameter
---
---Pitch range in semitones
---@field pitch_range integer Range: (1 - 96)
---@field pitch_range_observable renoise.Document.Observable
---
---**READ-ONLY** All available devices, to be used in 'insert_device_at'.
---@field available_devices string[]
---
---**READ-ONLY** Device list access.
---@field devices renoise.SampleModulationDevice[]
---@field devices_observable renoise.Document.ObservableList
---
---**READ-ONLY** Filter version, 3 is the latest.
---@see renoise.SampleModulationSet.upgrade_filter_version
---@field filter_version 1 | 2 | 3
---@field filter_version_observable renoise.Document.Observable
---
---**READ-ONLY** List of available filter types depending on the filter_version.
---@field available_filter_types FilterTypes[]
---
---The type of the filter selected for the modulation set. 
---Songs made with previous versions of Renoise may use old filter types. 
---@see renoise.SampleModulationSet.available_filter_types
---@field filter_type FilterTypes
---@field filter_type_observable renoise.Document.Observable

---### functions

---Reset all chain back to default initial state. Removing all devices too.
function renoise.SampleModulationSet:init() end

---Copy all devices from another SampleModulationSet object.
---@param other_set renoise.SampleModulationSet
function renoise.SampleModulationSet:copy_from(other_set) end

---Insert a new device at the given position. "device_path" must be one of
---renoise.song().instruments[].sample_modulation_sets[].available_devices.
---@param device_path string
---@param target_type renoise.SampleModulationDevice.TargetType
---@param index integer
---@return renoise.SampleModulationDevice new_sample_modulation_device
function renoise.SampleModulationSet:insert_device_at(device_path, target_type, index) end

---Delete a device at the given index.
---@param index integer
function renoise.SampleModulationSet:delete_device_at(index) end

---Access a single device by index.
---@param index integer
---@return renoise.SampleModulationDevice
function renoise.SampleModulationSet:device(index) end

---Upgrade filter to the latest version. Tries to find a somewhat matching
---filter in the new version, but things quite likely won't sound the same.
function renoise.SampleModulationSet:upgrade_filter_version() end

--------------------------------------------------------------------------------
---## renoise.SampleModulationDevice

---@class renoise.SampleModulationDevice
renoise.SampleModulationDevice = {}

---### constants

---@enum renoise.SampleModulationDevice.TargetType
renoise.SampleModulationDevice = {
  TARGET_VOLUME = 1,
  TARGET_PANNING = 2,
  TARGET_PITCH = 3,
  TARGET_CUTOFF = 4,
  TARGET_RESONANCE = 5,
  TARGET_DRIVE = 6,
}

---@enum renoise.SampleModulationDevice.OperatorType
renoise.SampleModulationDevice = {
  OPERATOR_ADD = 1,
  OPERATOR_SUB = 2,
  OPERATOR_MUL = 3,
  OPERATOR_DIV = 4,
}

---### properties

---@class renoise.SampleModulationDevice
---
---**READ-ONLY** Fixed name of the device.
---@field name string
---
---**READ-ONLY**
---@field short_name string
---
---Configurable device display name.
---@field display_name  string
---@field display_name_observable renoise.Document.Observable
---
---@deprecated use 'is_active' instead
---@see renoise.SampleModulationSet.is_active
---@field enabled boolean
---@field enabled_observable renoise.Document.Observable
---
---Enable/bypass the device.
---@field is_active boolean not active = bypassed
---@field is_active_observable renoise.Document.Observable
---
---Maximize state in modulation chain.
---@field is_maximized boolean
---@field is_maximized_observable renoise.Document.Observable
---
---**READ-ONLY** Where the modulation gets applied (Volume,
---Pan, Pitch, Cutoff, Resonance).
---@field target renoise.SampleModulationDevice.TargetType
---
---Modulation operator: how the device applies.
---@field operator renoise.SampleModulationDevice.OperatorType
---@field operator_observable renoise.Document.Observable
---
---Modulation polarity:
---when bipolar, the device applies it's values in a -1 to 1 range,
---when unipolar in a 0 to 1 range.
---@field bipolar boolean
---@field bipolar_observable renoise.Document.Observable
---
---**READ-ONLY** When true, the device has one of more time parameters,
---which can be switched to operate in synced or unsynced mode.
--- see also field tempo_synced.
---@field tempo_sync_switching_allowed boolean
---
---When true and the device supports sync switching the device operates
---in wall-clock (ms) instead of beat times.
---see also property 'tempo_sync_switching_allowed'
---@field tempo_synced boolean
---@field tempo_synced_observable renoise.Document.Observable
---
---**READ-ONLY** Generic access to all parameters of this device.
---@field is_active_parameter renoise.DeviceParameter
---
---**READ-ONLY**
---@field parameters renoise.DeviceParameter[]

---### functions

---Reset the device to its default state.
function renoise.SampleModulationDevice:init() end

---Copy a device's state from another device. 'other_device' must be of the
---same type.
---@param other_device renoise.SampleModulationDevice
function renoise.SampleModulationDevice:copy_from(other_device) end

---Access to a single parameter by index. Use properties 'parameters' to iterate
---over all parameters and to query the parameter count.
---@param index integer
---@return renoise.DeviceParameter
function renoise.SampleModulationDevice:parameter(index) end

--------------------------------------------------------------------------------
---## renoise.SampleOperandModulationDevice

---@class renoise.SampleOperandModulationDevice
renoise.SampleOperandModulationDevice = {}

---### properties

---@class renoise.SampleOperandModulationDevice : renoise.SampleModulationDevice
---
---Operand value.
---@field value renoise.DeviceParameter

--------------------------------------------------------------------------------
---## renoise.SampleFaderModulationDevice

---@class renoise.SampleFaderModulationDevice
renoise.SampleFaderModulationDevice = {}

---### constants

---@enum renoise.SampleFaderModulationDevice.ScalingType
renoise.SampleFaderModulationDevice = {
  SCALING_LOG_FAST = 1,
  SCALING_LOG_SLOW = 2,
  SCALING_LINEAR = 3,
  SCALING_EXP_SLOW = 4,
  SCALING_EXP_FAST = 5,
}

---### properties

---@class renoise.SampleFaderModulationDevice : renoise.SampleModulationDevice
---
---Scaling mode.
---@field scaling renoise.SampleFaderModulationDevice.ScalingType
---@field scaling_observable renoise.Document.Observable
---
---Start value.
---@field from renoise.DeviceParameter
---Target value.
---@field to renoise.DeviceParameter
---Duration.
---@field duration renoise.DeviceParameter
---Delay.
---@field delay renoise.DeviceParameter
---

--------------------------------------------------------------------------------
---## renoise.SampleAhdrsModulationDevice

---@class renoise.SampleAhdrsModulationDevice
renoise.SampleAhdrsModulationDevice = {}

---### properties

---@class renoise.SampleAhdrsModulationDevice : renoise.SampleModulationDevice
---
---Attack duration.
---@field attack renoise.DeviceParameter with range (0-1)
---Hold duration.
---@field hold renoise.DeviceParameter with range (0-1)
---Duration.
---@field duration renoise.DeviceParameter with range (0-1)
---Sustain amount.
---@field sustain renoise.DeviceParameter with range (0-1)
---Release duration.
---@field release renoise.DeviceParameter with range (0-1)

--------------------------------------------------------------------------------
---### renoise.SampleKeyTrackingModulationDevice

---@class renoise.SampleKeyTrackingModulationDevice
renoise.SampleKeyTrackingModulationDevice = {}

---### properties

---@class renoise.SampleKeyTrackingModulationDevice : renoise.SampleModulationDevice
---
---Min/Max key value.
---@field min renoise.DeviceParameter with range (0-119)
---@field max renoise.DeviceParameter with range (0-119)


--------------------------------------------------------------------------------
---## renoise.SampleVelocityTrackingModulationDevice

---@class renoise.SampleVelocityTrackingModulationDevice
renoise.SampleVelocityTrackingModulationDevice = {}

---### constants

---@enum renoise.SampleVelocityTrackingModulationDevice.Mode
renoise.SampleVelocityTrackingModulationDevice = {
  MODE_CLAMP = 1,
  MODE_SCALE = 2,
}

---### properties

---@class renoise.SampleVelocityTrackingModulationDevice : renoise.SampleModulationDevice
---
---Mode.
---@field mode renoise.SampleVelocityTrackingModulationDevice.Mode
---@field mode_observable renoise.Document.Observable
---
---
---Min/Max velocity.
---@field min renoise.DeviceParameter with range (0-127)
---@field max renoise.DeviceParameter with range (0-127)

--------------------------------------------------------------------------------
---## renoise.SampleEnvelopeModulationDevice

---@class renoise.SampleEnvelopeModulationDevice
renoise.SampleEnvelopeModulationDevice = {}

---### constants

renoise.SampleEnvelopeModulationDevice.MIN_NUMBER_OF_POINTS = 6
renoise.SampleEnvelopeModulationDevice.MAX_NUMBER_OF_POINTS = 6144

---@enum renoise.SampleEnvelopeModulationDevice.PlayMode
renoise.SampleEnvelopeModulationDevice = {
  PLAYMODE_POINTS = 1,
  PLAYMODE_LINES = 2,
  PLAYMODE_CURVES = 3,
}

---@enum renoise.SampleEnvelopeModulationDevice.LoopMode
renoise.SampleEnvelopeModulationDevice = {
  LOOP_MODE_OFF = 1,
  LOOP_MODE_FORWARD = 2,
  LOOP_MODE_REVERSE = 3,
  LOOP_MODE_PING_PONG = 4,
}

---### properties

---@class renoise.SampleEnvelopeModulationDevice : renoise.SampleModulationDevice
---
---External editor visibility.
--- set to true to show the editor, false to close it
---@field external_editor_visible boolean
---
---Play mode (interpolation mode).
---@field play_mode renoise.SampleEnvelopeModulationDevice.PlayMode
---@field play_mode_observable renoise.Document.Observable
---
---Envelope length.
---@field length integer Range: (6 - 1000)
---@field length_observable renoise.Document.Observable
---
---Loop.
---@field loop_mode renoise.SampleEnvelopeModulationDevice.LoopMode
---@field loop_mode_observable renoise.Document.Observable
---
---@field loop_start integer Range: (1 - envelope.length)
---@field loop_start_observable renoise.Document.Observable
---
---@field loop_end integer Range: (1 - envelope.length)
---@field loop_end_observable renoise.Document.Observable
---
---Sustain.
---@field sustain_enabled boolean
---@field sustain_enabled_observable renoise.Document.Observable
---
---@field sustain_position integer Range: (1 - envelope.length)
---@field sustain_position_observable renoise.Document.Observable
---
---Fade amount. (Only applies to volume envelopes)
---@field fade_amount integer Range: (0 - 4095)
---@field fade_amount_observable renoise.Document.Observable
---
---Get all points of the envelope. When setting a new list of points,
---items may be unsorted by time, but there may not be multiple points
---for the same time. Returns a copy of the list, so changing
---`points[1].value` will not do anything. Instead, change them via
---`points = { something }` instead.
---@field points SampleEnvelopeModulationDevice.Point[]
---@field points_observable renoise.Document.ObservableList
---
---@class SampleEnvelopeModulationDevice.Point
---An envelope point's time.
---@field time integer Range: (1 - envelope.length)
---An envelope point's value.
---@field value number Range: (0.0 - 1.0)
---An envelope point's scaling (used in 'lines' playback mode only - 0.0 is linear).
---@field scaling number Range: (-1.0 - 1.0)

---### functions

---Reset the envelope back to its default initial state.
function renoise.SampleEnvelopeModulationDevice:init() end

---Copy all properties from another SampleEnvelopeModulation object.
---@param other_device renoise.SampleEnvelopeModulationDevice
function renoise.SampleEnvelopeModulationDevice:copy_from(other_device) end

---Remove all points from the envelope.
function renoise.SampleEnvelopeModulationDevice:clear_points() end

---Remove points in the given [from, to) time range from the envelope.
---@param from_time integer
---@param to_time integer
function renoise.SampleEnvelopeModulationDevice:clear_points_in_range(from_time, to_time) end

---Copy all points from another SampleEnvelopeModulation object.
---@param other_device renoise.SampleEnvelopeModulationDevice
function renoise.SampleEnvelopeModulationDevice:copy_points_from(other_device) end

---Test if a point exists at the given time.
---@param time integer
---@return boolean
function renoise.SampleEnvelopeModulationDevice:has_point_at(time) end

---@param time integer Range: (1 - envelope.length)
---@param value number Range: (0.0 - 1.0)
---@param scaling number? Range: (-1.0 - 1.0)
---Add a new point value (or replace any existing value) at time.
function renoise.SampleEnvelopeModulationDevice:add_point_at(time, value, scaling) end

---Removes a point at the given time. Point must exist.
---@param time integer
function renoise.SampleEnvelopeModulationDevice:remove_point_at(time) end

--------------------------------------------------------------------------------
---## renoise.SampleStepperModulationDevice

---@class renoise.SampleStepperModulationDevice
renoise.SampleStepperModulationDevice = {}

---### constants

renoise.SampleStepperModulationDevice.MIN_NUMBER_OF_POINTS = 1
renoise.SampleStepperModulationDevice.MAX_NUMBER_OF_POINTS = 256

---@enum renoise.SampleStepperModulationDevice.PlayMode
renoise.SampleStepperModulationDevice = {
  PLAYMODE_POINTS = 1,
  PLAYMODE_LINES = 2,
  PLAYMODE_CURVES = 3,
}

---### properties

---@class renoise.SampleStepperModulationDevice :  renoise.SampleModulationDevice
---
---External editor visibility.
---set to true to show the editor, false to close it
---@field external_editor_visible boolean
---
---Play mode (interpolation mode).
---@field play_mode renoise.SampleStepperModulationDevice.PlayMode
---@field play_mode_observable renoise.Document.Observable
---
---Step size. -1 is the same as choosing RANDOM
---@field play_step integer Range: (-1 - 16)
---@field play_step_observable renoise.Document.Observable
---
---Envelope length.
---@field length integer Range: (1 - 256)
---@field length_observable renoise.Document.Observable
---
---Get all points of the envelope. When setting a new list of points,
---items may be unsorted by time, but there may not be multiple points
---for the same time. Returns a copy of the list, so changing
---`points[1].value` will not do anything. Instead, change them via
---`points = { something }`.
---@field points SampleStepperModulationDevice.Point[]
---@field points_observable renoise.Document.ObservableList
---
---@class SampleStepperModulationDevice.Point
---An envelope point's time.
---@field time integer Range: (1 - envelope.length)
---An envelope point's value.
---@field value number Range: (0.0 - 1.0)
---An envelope point's scaling (used in 'lines' playback mode only - 0.0 is linear).
---@field scaling number Range: (-1.0 - 1.0)

---### functions

---Reset the envelope back to its default initial state.
function renoise.SampleStepperModulationDevice:init() end

---Copy all properties from another SampleStepperModulation object.
---@param other_device renoise.SampleStepperModulationDevice
function renoise.SampleStepperModulationDevice:copy_from(other_device) end

---Remove all points from the envelope.
function renoise.SampleStepperModulationDevice:clear_points() end

---Remove points in the given [from, to) time range from the envelope.
---@param from_time integer
---@param to_time integer
function renoise.SampleStepperModulationDevice:clear_points_in_range(from_time, to_time) end

---Copy all points from another SampleStepperModulation object.
---@param other_device renoise.SampleStepperModulationDevice
function renoise.SampleStepperModulationDevice:copy_points_from(other_device) end

---Test if a point exists at the given time.
---@param time integer
---@return boolean
function renoise.SampleStepperModulationDevice:has_point_at(time) end

---Add a new point value (or replace any existing value) at time.
---@param time integer
---@param value number
---@param scaling number?
function renoise.SampleStepperModulationDevice:add_point_at(time, value, scaling) end

---Removes a point at the given time. Point must exist.
---@param time integer
function renoise.SampleStepperModulationDevice:remove_point_at(time) end

--------------------------------------------------------------------------------
---## renoise.SampleLfoModulationDevice

---@class renoise.SampleLfoModulationDevice
renoise.SampleLfoModulationDevice = {}

---### constants

---@enum renoise.SampleLfoModulationDevice.Mode
renoise.SampleLfoModulationDevice = {
  MODE_SIN = 1,
  MODE_SAW = 2,
  MODE_PULSE = 3,
  MODE_RANDOM = 4,
}

---### properties

---@class renoise.SampleLfoModulationDevice : renoise.SampleModulationDevice
---
---LFO mode.
---@field mode renoise.SampleLfoModulationDevice.Mode
---
---Phase.
---@field phase renoise.DeviceParameter with range (0-360)
--
---Frequency.
---@field frequency renoise.DeviceParameter with range (0-1)
---
---Amount.
---@field amount renoise.DeviceParameter with range (0-1)
---
---Delay.
---@field delay renoise.DeviceParameter
