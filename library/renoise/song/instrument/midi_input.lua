---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.InstrumentMidiInputProperties

---@class renoise.InstrumentMidiInputProperties
renoise.InstrumentMidiInputProperties = {}

---### properties

---@class renoise.InstrumentMidiInputProperties
---
---When setting new devices, device names must be one of
---`renoise.Midi.available_input_devices()` or "Renoise OSC Device".
---To close a device and disconnect it from the instrument, assign
---an empty string.
---@field device_name string
---@field device_name_observable renoise.Document.Observable
---@field channel integer Range: (1 - 16) 0 = Omni
---@field channel_observable renoise.Document.Observable
---Range: (0-119) where C-4 is 48
---@field note_range {[1]: integer, [2]: integer}
---@field note_range_observable  renoise.Document.Observable
---Range: (1 - song.sequencer_track_count) 0 = Current track
---@field assigned_track integer
---@field assigned_track_observable renoise.Document.Observable
