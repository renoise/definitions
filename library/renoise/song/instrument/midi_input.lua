---@meta
---Do not try to execute this file. It's just a type definition file.
---
---Please read the `Introduction.md` in the Renoise scripting Documentation
---folder first to get an overview about the complete API, and scripting for
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
---renoise.Midi.available_input_devices.
---Devices are automatically opened when needed. To close a device, set its
---name to "", e.g. an empty string.
---@field device_name string
---@field device_name_observable renoise.Document.Observable
---@field channel integer Range: (1-16) 0 = Omni
---@field channel_observable renoise.Document.Observable
---Table of two numbers in range (0-119) where C-4 is 48
---@field note_range integer[]
---@field note_range_observable  renoise.Document.Observable
---Range: (1-song.sequencer_track_count) 0 = Current track
---@field assigned_track integer
---@field assigned_track_observable renoise.Document.Observable
