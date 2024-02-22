---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.InstrumentMidiOutputProperties

---@class renoise.InstrumentMidiOutputProperties
renoise.InstrumentMidiOutputProperties = {}

---### constants

---@enum renoise.InstrumentMidiOutputProperties.Type
renoise.InstrumentMidiOutputProperties = {
  TYPE_EXTERNAL = 1,
  TYPE_LINE_IN_RET = 2,
  TYPE_INTERNAL = 3, -- REWIRE
}

---### properties

---@class renoise.InstrumentMidiOutputProperties
---
-- Note: ReWire device always start with "ReWire: " in the device_name and
-- will always ignore the instrument_type and channel properties. MIDI
-- channels are not configurable for ReWire MIDI, and instrument_type will
-- always be "TYPE_INTERNAL" for ReWire devices.
---@field instrument_type renoise.InstrumentMidiOutputProperties.Type
---@field instrument_type_observable renoise.Document.Observable
---
-- When setting new devices, device names must be one of:
-- renoise.Midi.available_output_devices.
-- Devices are automatically opened when needed. To close a device, set its name
-- to "", e.g. an empty string.
---@field device_name string
---@field device_name_observable renoise.Document.Observable
---
---@field channel number Range: (1 - 16)
---@field channel_observable renoise.Document.Observable
---
---@field transpose number Range: (-120 - 120)
---@field transpose_observable renoise.Document.Observable
---
---@field program number Range: (1 - 128) 0 = OFF
---@field program_observable renoise.Document.Observable
---
---@field bank number Range: (1 - 65536) 0 = OFF
---@field bank_observable renoise.Document.Observable
---
---@field delay number Range: (0 - 100)
---@field delay_observable renoise.Document.Observable
---
---@field duration number Range: (1 - 8000) 8000 = INF
---@field duration_observable renoise.Document.Observable
