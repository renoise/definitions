--------------------------------------------------------------------------------
-- renoise.SampleModulationSet
--------------------------------------------------------------------------------

-------- Functions

-- Reset all chain back to default initial state. Removing all devices too.
renoise.song().instruments[].sample_modulation_sets[]:init()

-- Copy all devices from another SampleModulationSet object.
renoise.song().instruments[].sample_modulation_sets[]:copy_from(
  other renoise.SampleModulationSet object)

-- Insert a new device at the given position. "device_path" must be one of
-- renoise.song().instruments[].sample_modulation_sets[].available_devices.
renoise.song().instruments[].sample_modulation_sets[]:insert_device_at(device_path, index) 
  -> [returns new renoise.SampleModulationDevice object]
-- Delete a device at the given index.
renoise.song().instruments[].sample_modulation_sets[]:delete_device_at(index)
-- Access a single device by index.  
renoise.song().instruments[].sample_modulation_sets[]:device(index) 
 -> [renoise.SampleModulationDevice object]

 -- upgrade filter type to the latest version. Tries to find a somewhat matching
 -- filter in the new version, but things quite likely won't sound the same.
renoise.song().instruments[].sample_modulation_sets[]:upgrade_filter_version()
  

-------- Properties

-- Name of the modulation set.
renoise.song().instruments[].sample_modulation_sets[].name, _observable
  -> [string]
  
-- Input value for the volume domain
renoise.song().instruments[].sample_modulation_sets[].volume_input
  -> [renoise.DeviceParameter object]

-- Input value for the panning domain
renoise.song().instruments[].sample_modulation_sets[].panning_input
  -> [renoise.DeviceParameter object]

-- Input value for the pitch domain
renoise.song().instruments[].sample_modulation_sets[].pitch_input
  -> [renoise.DeviceParameter object]

-- Input value for the cutoff domain
renoise.song().instruments[].sample_modulation_sets[].cutoff_input
  -> [renoise.DeviceParameter object]

-- Input value for the resonance domain
renoise.song().instruments[].sample_modulation_sets[].resonance_input
  -> [renoise.DeviceParameter object]

-- Input value for the drive domain
renoise.song().instruments[].sample_modulation_sets[].drive_input
  -> [renoise.DeviceParameter object]

-- Pitch range in semitones
renoise.song().instruments[].sample_modulation_sets[].pitch_range, _observable 
  -> [number, 1 - 96]


-- All available devices, to be used in 'insert_device_at'.
renoise.song().instruments[].sample_modulation_sets[].available_devices[] 
  -> [read-only, array of strings]

-- Device list access.
renoise.song().instruments[].sample_modulation_sets[].devices[], observable 
  -> [read-only, array of renoise.SampleModulationDevice objects]

-- Filter version. See also function 'upgrade_filter_version'
renoise.song().instruments[].sample_modulation_sets[].filter_version, observable
  -> [read-only, number - 1,2 or 3 which is the latest version]

-- Filter type.
renoise.song().instruments[].sample_modulation_sets[].available_filter_types
  -> [read-only, list of strings]
renoise.song().instruments[].sample_modulation_sets[].filter_type, _observable
  -> [string, one of 'available_filter_types']

--------------------------------------------------------------------------------
-- renoise.SampleModulationDevice
--------------------------------------------------------------------------------

--------- Constants

renoise.SampleModulationDevice.TARGET_VOLUME
renoise.SampleModulationDevice.TARGET_PANNING
renoise.SampleModulationDevice.TARGET_PITCH
renoise.SampleModulationDevice.TARGET_CUTOFF
renoise.SampleModulationDevice.TARGET_RESONANCE
renoise.SampleModulationDevice.TARGET_DRIVE

renoise.SampleModulationDevice.OPERATOR_ADD
renoise.SampleModulationDevice.OPERATOR_SUB
renoise.SampleModulationDevice.OPERATOR_MUL
renoise.SampleModulationDevice.OPERATOR_DIV

  
--------- functions

-- Reset the device to its default state.
renoise.song().instruments[].sample_modulation_sets[].devices[]:init()

-- Copy a device's state from another device. 'other_device' must be of the
-- same type.
renoise.song().instruments[].sample_modulation_sets[].devices[]:copy_from(
  other renoise.SampleModulationDevice object)

-- Access to a single parameter by index. Use properties 'parameters' to iterate 
-- over all parameters and to query the parameter count.
renoise.song().instruments[].sample_modulation_sets[].devices[]:parameter(index)
  -> [renoise.DeviceParameter object]

--------- properties

-- Fixed name of the device.
renoise.song().instruments[].sample_modulation_sets[].devices[].name
  -> [read-only, string]
renoise.song().instruments[].sample_modulation_sets[].devices[].short_name
  -> [read-only, string]

-- Configurable device display name.
renoise.song().instruments[].sample_modulation_sets[].devices[].display_name, observable 
  -> [string]

-- DEPRECATED: use 'is_active' instead
renoise.song().instruments[].sample_modulation_sets[].devices[].enabled, _observable
  -> [boolean]
-- Enable/bypass the device.
renoise.song().instruments[].sample_modulation_sets[].devices[].is_active, _observable
  -> [boolean, not active = bypassed]

-- Maximize state in modulation chain.
renoise.song().instruments[].sample_modulation_sets[].devices[].is_maximized, _observable
  -> [boolean]

-- Where the modulation gets applied (Volume, Pan, Pitch, Cutoff, Resonance).
renoise.song().instruments[].sample_modulation_sets[].devices[].target 
  -> [read-only, enum = TARGET]

-- Modulation operator: how the device applies.
renoise.song().instruments[].sample_modulation_sets[].devices[].operator, _observable
  -> [enum = OPERATOR]

-- Modulation polarity: when bipolar, the device applies it's values in a -1 to 1 range,
-- when unipolar in a 0 to 1 range.
renoise.song().instruments[].sample_modulation_sets[].devices[].bipolar, observable
  -> [boolean]

-- When true, the device has one of more time parameters, which can be switched to operate
-- in synced or unsynced mode (see tempo_synced)
renoise.song().instruments[].sample_modulation_sets[].devices[].tempo_sync_switching_allowed
  -> [read-only, boolean]
-- When true and the device supports sync switching (see 'tempo_sync_switching_allowed'),
-- the device operates in wall-clock (ms) instead of beat times.
renoise.song().instruments[].sample_modulation_sets[].devices[].tempo_synced, observable
  -> [boolean]
  
-- Generic access to all parameters of this device.
renoise.song().instruments[].sample_modulation_sets[].devices[].is_active_parameter
  -> [read-only, renoise.DeviceParameter object]

renoise.song().instruments[].sample_modulation_sets[].devices[].parameters[]
  -> [read-only, array of renoise.DeviceParameter objects]


--------------------------------------------------------------------------------
-- renoise.SampleOperandModulationDevice (inherits from renoise.SampleModulationDevice)
--------------------------------------------------------------------------------

-------- Properties

-- Operand value.
renoise.song().instruments[].sample_modulation_sets[].devices[].value 
  -> [renoise.DeviceParameter object, -1-1]


--------------------------------------------------------------------------------
-- renoise.SampleFaderModulationDevice (inherits from renoise.SampleModulationDevice)
--------------------------------------------------------------------------------

--------- Constants

renoise.SampleFaderModulationDevice.SCALING_LOG_FAST
renoise.SampleFaderModulationDevice.SCALING_LOG_SLOW
renoise.SampleFaderModulationDevice.SCALING_LINEAR
renoise.SampleFaderModulationDevice.SCALING_EXP_SLOW
renoise.SampleFaderModulationDevice.SCALING_EXP_FAST


-------- Properties

-- Scaling mode.
renoise.song().instruments[].sample_modulation_sets[].devices[].scaling, _observable 
  -> [enum = SCALING]

-- Start & Target value.
renoise.song().instruments[].sample_modulation_sets[].devices[].from
  -> [renoise.DeviceParameter object, 0-1]
renoise.song().instruments[].sample_modulation_sets[].devices[].to
  -> [renoise.DeviceParameter object, 0-1]

-- Duration.
renoise.song().instruments[].sample_modulation_sets[].devices[].duration
  -> [renoise.DeviceParameter object, 0-1]

-- Delay.
renoise.song().instruments[].sample_modulation_sets[].devices[].delay
  -> [renoise.DeviceParameter object, 0-1]


--------------------------------------------------------------------------------
-- renoise.SampleAhdrsModulationDevice (inherits from renoise.SampleModulationDevice)
--------------------------------------------------------------------------------

-------- Properties

-- Attack duration.
renoise.song().instruments[].sample_modulation_sets[].devices[].attack
  -> [renoise.DeviceParameter object, 0-1]
  
-- Hold duration.
renoise.song().instruments[].sample_modulation_sets[].devices[].hold
  -> [renoise.DeviceParameter object, 0-1]

-- Duration.
renoise.song().instruments[].sample_modulation_sets[].devices[].duration
  -> [renoise.DeviceParameter object, 0-1]

-- Sustain amount.
renoise.song().instruments[].sample_modulation_sets[].devices[].sustain
  -> [renoise.DeviceParameter object, 0-1]

-- Release duration.
renoise.song().instruments[].sample_modulation_sets[].devices[].release
  -> [renoise.DeviceParameter object, 0-1]


--------------------------------------------------------------------------------
-- renoise.SampleKeyTrackingModulationDevice (inherits from renoise.SampleModulationDevice)
--------------------------------------------------------------------------------

-------- Properties

-- Min/Max key value.
renoise.song().instruments[].sample_modulation_sets[].devices[].min
  -> [renoise.DeviceParameter object, 0-119]
renoise.song().instruments[].sample_modulation_sets[].devices[].max
  -> [renoise.DeviceParameter object, 0-119]


--------------------------------------------------------------------------------
-- renoise.SampleVelocityTrackingModulationDevice (inherits from renoise.SampleModulationDevice)
--------------------------------------------------------------------------------

--------- Constants

renoise.SampleVelocityTrackingModulationDevice.MODE_CLAMP
renoise.SampleVelocityTrackingModulationDevice.MODE_SCALE


-------- Properties

-- Mode.
renoise.song().instruments[].sample_modulation_sets[].devices[].mode, _observable 
  -> [enum = MODE]

-- Min/Max velocity.
renoise.song().instruments[].sample_modulation_sets[].devices[].min
  -> [renoise.DeviceParameter object, 0-127]
renoise.song().instruments[].sample_modulation_sets[].devices[].max
  -> [renoise.DeviceParameter object, 0-127]


--------------------------------------------------------------------------------
-- renoise.SampleEnvelopeModulationDevice (inherits from renoise.SampleModulationDevice)
--------------------------------------------------------------------------------

--------- Constants

renoise.SampleEnvelopeModulationDevice.PLAYMODE_POINTS
renoise.SampleEnvelopeModulationDevice.PLAYMODE_LINES
renoise.SampleEnvelopeModulationDevice.PLAYMODE_CURVES

renoise.SampleEnvelopeModulationDevice.LOOP_MODE_OFF
renoise.SampleEnvelopeModulationDevice.LOOP_MODE_FORWARD
renoise.SampleEnvelopeModulationDevice.LOOP_MODE_REVERSE
renoise.SampleEnvelopeModulationDevice.LOOP_MODE_PING_PONG

renoise.SampleEnvelopeModulationDevice.MIN_NUMBER_OF_POINTS
renoise.SampleEnvelopeModulationDevice.MAX_NUMBER_OF_POINTS


-------- Functions

-- Reset the envelope back to its default initial state.
renoise.song().instruments[].sample_modulation_sets[].devices[]:init()

-- Copy all properties from another SampleEnvelopeModulation object.
renoise.song().instruments[].sample_modulation_sets[].devices[]:copy_from(
  other renoise.SampleEnvelopeModulationDevice object)

-- Remove all points from the envelope.
renoise.song().instruments[].sample_modulation_sets[].devices[]:clear_points()
-- Remove points in the given [from, to) time range from the envelope.
renoise.song().instruments[].sample_modulation_sets[].devices[]:clear_points_in_range(
--  from_time, to_time)

-- Copy all points from another SampleEnvelopeModulation object.
renoise.song().instruments[].sample_modulation_sets[].devices[]:copy_points_from(
  other SampleEnvelopeModulationDevice object)

-- Test if a point exists at the given time.
renoise.song().instruments[].sample_modulation_sets[].devices[]:has_point_at(time)
  -> [boolean]
-- Add a new point value (or replace any existing value) at time. 
renoise.song().instruments[].sample_modulation_sets[].devices[]:add_point_at(
  time, value [, scaling])
-- Removes a point at the given time. Point must exist.
renoise.song().instruments[].sample_modulation_sets[].devices[]:remove_point_at(time)


-------- Properties

-- External editor visibility.
renoise.song().instruments[].sample_modulation_sets[].devices[].external_editor_visible
 -> [boolean, set to true to show he editor, false to close it]

-- Play mode (interpolation mode).
renoise.song().instruments[].sample_modulation_sets[].devices[].play_mode, _observable
  -> [enum = PLAYMODE]

-- Envelope length.
renoise.song().instruments[].sample_modulation_sets[].devices[].length, _observable
  -> [number, 6-1000]

-- Loop.
renoise.song().instruments[].sample_modulation_sets[].devices[].loop_mode, _observable
  -> [enum = LOOP_MODE]
renoise.song().instruments[].sample_modulation_sets[].devices[].loop_start, _observable
  -> [number, 1-envelope.length]
renoise.song().instruments[].sample_modulation_sets[].devices[].loop_end, _observable
  -> [number, 1-envelope.length]

-- Sustain.
renoise.song().instruments[].sample_modulation_sets[].devices[].sustain_enabled, _observable
  -> [boolean]
renoise.song().instruments[].sample_modulation_sets[].devices[].sustain_position, _observable
  -> [number, 1-envelope.length]

-- Fade amount. (Only applies to volume envelopes)
renoise.song().instruments[].sample_modulation_sets[].devices[].fade_amount, _observable
  -> [number, 0-4095]

-- Get all points of the envelope. When setting a new list of points,
-- items may be unsorted by time, but there may not be multiple points
-- for the same time. Returns a copy of the list, so changing
-- `points[1].value` will not do anything. Instead, change them via
-- `points = { something }` instead.
renoise.song().instruments[].sample_modulation_sets[].devices[].points[], _observable
  -> [array of {time, value} tables]

-- An envelope point's time.
renoise.song().instruments[].sample_modulation_sets[].devices[].points[].time
  -> [number, 1 - envelope.length]
-- An envelope point's value.
renoise.song().instruments[].sample_modulation_sets[].devices[].points[].value
  -> [number, 0.0 - 1.0]
-- An envelope point's scaling (used in 'lines' playback mode only - 0.0 is linear).
renoise.song().instruments[].sample_modulation_sets[].devices[].points[].scaling
  -> [number, -1.0 - 1.0]


--------------------------------------------------------------------------------
-- renoise.SampleStepperModulationDevice  (inherits from renoise.SampleModulationDevice)
--------------------------------------------------------------------------------

--------- Constants

renoise.SampleStepperModulationDevice.PLAYMODE_POINTS
renoise.SampleStepperModulationDevice.PLAYMODE_LINES
renoise.SampleStepperModulationDevice.PLAYMODE_CURVES

renoise.SampleStepperModulationDevice.MIN_NUMBER_OF_POINTS
renoise.SampleStepperModulationDevice.MAX_NUMBER_OF_POINTS


-------- Functions

-- Reset the envelope back to its default initial state.
renoise.song().instruments[].sample_modulation_sets[].devices[]:init()

-- Copy all properties from another SampleStepperModulation object.
renoise.song().instruments[].sample_modulation_sets[].devices[]:copy_from(
  other renoise.SampleStepperModulationDevice object)

-- Remove all points from the envelope.
renoise.song().instruments[].sample_modulation_sets[].devices[]:clear_points()
-- Remove points in the given [from, to) time range from the envelope.
renoise.song().instruments[].sample_modulation_sets[].devices[]:clear_points_in_range(
--  from_time, to_time)

-- Copy all points from another SampleStepperModulation object.
renoise.song().instruments[].sample_modulation_sets[].devices[]:copy_points_from(
  other SampleStepperModulationDevice object)

-- Test if a point exists at the given time.
renoise.song().instruments[].sample_modulation_sets[].devices[]:has_point_at(time)
  -> [boolean]
-- Add a new point value (or replace any existing value) at time. 
renoise.song().instruments[].sample_modulation_sets[].devices[]:add_point_at(
  time, value [, scaling])
-- Removes a point at the given time. Point must exist.
renoise.song().instruments[].sample_modulation_sets[].devices[]:remove_point_at(time)


-------- Properties

-- External editor visibility.
renoise.song().instruments[].sample_modulation_sets[].devices[].external_editor_visible
 -> [boolean, set to true to show he editor, false to close it]
  
-- Play mode (interpolation mode).
renoise.song().instruments[].sample_modulation_sets[].devices[].play_mode, _observable
  -> [enum = PLAYMODE]

-- Step size. -1 is the same as choosing RANDOM
renoise.song().instruments[].sample_modulation_sets[].devices[].play_step, _observable
  -> [number, -1-16]

-- Envelope length.
renoise.song().instruments[].sample_modulation_sets[].devices[].length, _observable
  -> [number, 1-256]

-- Get all points of the envelope. When setting a new list of points,
-- items may be unsorted by time, but there may not be multiple points
-- for the same time. Returns a copy of the list, so changing
-- `points[1].value` will not do anything. Instead, change them via
-- `points = { something }`.
renoise.song().instruments[].sample_modulation_sets[].devices[].points[], _observable
  -> [array of {time, value} tables]

-- An envelope point's time.
renoise.song().instruments[].sample_modulation_sets[].devices[].points[].time
  -> [number, 1 - envelope.length]
-- An envelope point's value.
renoise.song().instruments[].sample_modulation_sets[].devices[].points[].value
  -> [number, 0.0 - 1.0]
-- An envelope point's scaling (used in 'lines' playback mode only - 0.0 is linear).
renoise.song().instruments[].sample_modulation_sets[].devices[].points[].scaling
  -> [number, -1.0 - 1.0]


--------------------------------------------------------------------------------
-- renoise.SampleLfoModulationDevice (inherits from renoise.SampleModulationDevice)
--------------------------------------------------------------------------------

-------- Constants

renoise.SampleLfoModulationDevice.MODE_SIN
renoise.SampleLfoModulationDevice.MODE_SAW
renoise.SampleLfoModulationDevice.MODE_PULSE
renoise.SampleLfoModulationDevice.MODE_RANDOM


-------- Properties

-- LFO mode.
renoise.song().instruments[].sample_modulation_sets[].devices[].mode
  -> [enum = MODE]

-- Phase.
renoise.song().instruments[].sample_modulation_sets[].devices[].phase
  -> [renoise.DeviceParameter object, 0-360]

-- Frequency.
renoise.song().instruments[].sample_modulation_sets[].devices[].frequency
  -> [renoise.DeviceParameter object, 0-1]

-- Amount.
renoise.song().instruments[].sample_modulation_sets[].devices[].amount
  -> [renoise.DeviceParameter object, 0-1]

-- Delay.
renoise.song().instruments[].sample_modulation_sets[].devices[].delay
-> [renoise.DeviceParameter object, 0-1]
