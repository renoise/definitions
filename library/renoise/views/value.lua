---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Views.Value

---A static text view. Shows a string representation of a number and
---allows custom "number to string" conversion.
---@see renoise.Views.ValueField for a value text field that can be edited by the user.
---```text
--- +---+-------+
--- | 12.1 dB   |
--- +---+-------+
---```
---@class renoise.Views.Value : renoise.Views.View
---@field value SliderNumberValue
---@field font TextFontStyle
---@field align TextAlignment
local Value = {}

---### functions

---Add value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function Value:add_notifier(notifier) end

---Remove value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function Value:remove_notifier(notifier) end

--------------------------------------------------------------------------------

---@class ValueViewProperties : ViewProperties
---@field bind ViewNumberObservable?
---@field value SliderNumberValue?
---@field notifier NumberValueNotifier?
---@field align TextAlignment?
---@field font TextFontStyle?
---@field tostring ShowNumberAsString?
