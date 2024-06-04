---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------

---The minimum value that can be set using the view
---* Default: 0
---@alias SliderMinValue number

---The maximum value that can be set using the view
---* Default: 1.0
---@alias SliderMaxValue number

---The default value that will be re-applied on double-click
---@alias SliderDefaultValue number

---The current value of the view
---@alias SliderNumberValue number

---A table containing two numbers representing the step amounts for incrementing
---and decrementing by clicking the <> buttons.
---The first value is the small step (applied on left clicks)
---second value is the big step (applied on right clicks)
---@alias SliderStepAmounts {[1] : number, [2] : number}

--------------------------------------------------------------------------------
---## renoise.Views.Slider

---A slider with arrow buttons, which shows and allows editing of values in a
---custom range. A slider can be horizontal or vertical; will flip its
---orientation according to the set width and height. By default horizontal.
---```text
--- +---+---------------+
--- |<|>| --------[]    |
--- +---+---------------+
---```
---@class renoise.Views.Slider : renoise.Views.Control
---@field min SliderMinValue
---@field max SliderMaxValue
---@field steps SliderStepAmounts
---@field default SliderDefaultValue
---@field value SliderNumberValue
local Slider = {}

---### functions

---Add value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function Slider:add_notifier(notifier) end

---Remove value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function Slider:remove_notifier(notifier) end

--------------------------------------------------------------------------------

---@class SliderProperties : ControlProperties
---@field bind ViewNumberObservable?
---@field value SliderNumberValue?
---@field notifier NumberValueNotifier?
---@field min SliderMinValue?
---@field max SliderMaxValue?
---@field steps SliderStepAmounts?
---@field default SliderDefaultValue?
