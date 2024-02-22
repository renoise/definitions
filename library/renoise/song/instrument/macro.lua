--------------------------------------------------------------------------------
---@class renoise.InstrumentMacro
--------------------------------------------------------------------------------
---
---### properties
---
---Macro name as visible in the GUI when mappings are presents.
---@field name string
---@field name_observable renoise.Document.Observable
---
---Macro value
---@field value number Range: (0-1)
---@field value_observable renoise.Document.Observable
---
---Macro value string
---@field value_string string Range: (0-100)
---@field value_string_observable renoise.Document.Observable
---
---**READ-ONLY** Macro mappings, target parameters
---@field mappings renoise.InstrumentMacroMapping[]
---@field mappings_observable renoise.Document.Observable

---### functions

---Access to a single attached parameter mapping by index. Use property
---'mappings' to query mapping count.
---@param index integer
---@return renoise.InstrumentMacroMapping
function renoise.InstrumentMacro:mapping(index) end

--------------------------------------------------------------------------------
---@class renoise.InstrumentMacroMapping
--------------------------------------------------------------------------------
---
---### properties
---
---**READ-ONLY**
---Linked parameter. Can be a sample FX- or modulation parameter. Never nil.
---@field parameter renoise.DeviceParameter
---
---Min/max range in which the macro applies its value to the target parameter.
---Max can be < than Min. Mapping is then flipped.
---@field parameter_min number Range: (0-1)
---@field parameter_min_observable renoise.Document.Observable
---
---@field parameter_max number Range: (0-1)
---@field parameter_max_observable renoise.Document.Observable
---
---Scaling which gets applied within the min/max range to set the dest value.
---@field parameter_scaling renoise.InstrumentMacroMapping.Scaling
---@field parameter_scaling_observable renoise.Document.Observable

---### constants

---@enum renoise.InstrumentMacroMapping.Scaling
renoise.InstrumentMacroMapping = {
  SCALING_LOG_FAST = 1,
  SCALING_LOG_SLOW = 2,
  SCALING_LINEAR = 3,
  SCALING_EXP_SLOW = 4,
  SCALING_EXP_FAST = 5,
}