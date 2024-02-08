
--------------------------------------------------------------------------------
-- renoise.InstrumentMacro
--------------------------------------------------------------------------------

-------- Functions

-- Access to a single attached parameter mapping by index. Use property
-- 'mappings' to query mapping count.
renoise.song().instruments[].macros[]:mapping(index) 
  -> [renoise.InstrumentMacroMapping object]
  

-------- Properties

-- Macro name as visible in the GUI when mappings are presents.
renoise.song().instruments[].macros[].name, _observable 
  -> [string]

-- Macro value.
renoise.song().instruments[].macros[].value, _observable 
  -> [number, 0-1]
-- Macro value string (0-100).
renoise.song().instruments[].macros[].value_string, _observable 
  -> [string]

-- Macro mappings, target parameters.
renoise.song().instruments[].macros[].mappings[], _observable
  -> [read-only, array of renoise.InstrumentMacroMapping objects]


--------------------------------------------------------------------------------
-- renoise.InstrumentMacroMapping
--------------------------------------------------------------------------------

-------- Constants

renoise.InstrumentMacroMapping.SCALING_LOG_FAST
renoise.InstrumentMacroMapping.SCALING_LOG_SLOW
renoise.InstrumentMacroMapping.SCALING_LINEAR
renoise.InstrumentMacroMapping.SCALING_EXP_SLOW
renoise.InstrumentMacroMapping.SCALING_EXP_FAST


-------- Properties

-- Linked parameter. Can be a sample FX- or modulation parameter. Never nil.
renoise.song().instruments[].macros[].mappings[].parameter
  -> [read-only, renoise.DeviceParameter]

-- Min/max range in which the macro applies its value to the target parameter.
-- Max can be < than Min. Mapping is then flipped.
renoise.song().instruments[].macros[].mappings[].parameter_min, _observable
  -> [number, 0-1]
renoise.song().instruments[].macros[].mappings[].parameter_max, _observable
  -> [number, 0-1]
  
-- Scaling which gets applied within the min/max range to set the dest value.
renoise.song().instruments[].macros[].mappings[].parameter_scaling, _observable
  -> [enum = SCALING]

  
