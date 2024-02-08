--------------------------------------------------------------------------------
-- renoise.InstrumentMidiInputProperties
--------------------------------------------------------------------------------

-------- Properties

-- When setting new devices, device names must be one of
-- renoise.Midi.available_input_devices.
-- Devices are automatically opened when needed. To close a device, set its 
-- name to "", e.g. an empty string.
renoise.song().instruments[].midi_input_properties.device_name, _observable
  -> [string]
renoise.song().instruments[].midi_input_properties.channel, _observable
  -> [number, 1-16, 0=Omni]
renoise.song().instruments[].midi_input_properties.note_range, _observable 
  -> [table with two numbers (0-119, c-4=48)]
renoise.song().instruments[].midi_input_properties.assigned_track, _observable
  -> [number, 1-renoise.song().sequencer_track_count, 0 = Current track]
