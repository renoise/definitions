
--------------------------------------------------------------------------------
-- renoise.InstrumentMidiOutputProperties
--------------------------------------------------------------------------------

-------- Constants

renoise.InstrumentMidiOutputProperties.TYPE_EXTERNAL
renoise.InstrumentMidiOutputProperties.TYPE_LINE_IN_RET
renoise.InstrumentMidiOutputProperties.TYPE_INTERNAL -- REWIRE


-------- Properties

-- Note: ReWire device always start with "ReWire: " in the device_name and
-- will always ignore the instrument_type and channel properties. MIDI
-- channels are not configurable for ReWire MIDI, and instrument_type will
-- always be "TYPE_INTERNAL" for ReWire devices.
renoise.song().instruments[].midi_output_properties.instrument_type, _observable
  -> [enum = TYPE]

-- When setting new devices, device names must be one of:
-- renoise.Midi.available_output_devices.
-- Devices are automatically opened when needed. To close a device, set its name
-- to "", e.g. an empty string.
renoise.song().instruments[].midi_output_properties.device_name, _observable
  -> [string]
renoise.song().instruments[].midi_output_properties.channel, _observable
  -> [number, 1-16]
renoise.song().instruments[].midi_output_properties.transpose, _observable
  -> [number, -120-120]
renoise.song().instruments[].midi_output_properties.program, _observable
  -> [number, 1-128, 0 = OFF]
renoise.song().instruments[].midi_output_properties.bank, _observable
  -> [number, 1-65536, 0 = OFF]
renoise.song().instruments[].midi_output_properties.delay, _observable
  -> [number, 0-100]
renoise.song().instruments[].midi_output_properties.duration, _observable
  -> [number, 1-8000, 8000 = INF]
