---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Views.ValueField

---A text view, which shows a string representation of a number and allows
---custom "number to string" conversion. The value's text can be edited by the
---user.
---```lua
--- +---+-------+
--- | 12.1 dB   |
--- +---+-------+
---```
---@class renoise.Views.ValueField : renoise.Views.Control
---@field min SliderMinValue
---@field max SliderMaxValue
---@field value SliderNumberValue
---@field align TextAlignment
local ValueField = {}

---### functions

---Add value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function ValueField:add_notifier(notifier) end

---Remove value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function ValueField:remove_notifier(notifier) end

--------------------------------------------------------------------------------

---@class ValueFieldProperties : ControlProperties
---@field bind ViewNumberObservable?
---@field value SliderNumberValue?
---@field notifier NumberValueNotifier?
---@field min SliderMinValue?
---@field max SliderMaxValue?
---@field align TextAlignment?
---@field tostring PairedShowNumberAsString?
---@field tonumber PairedParseStringAsNumber?
