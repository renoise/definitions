---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Views.MiniSlider

---Same as a slider, but without arrow buttons and a really tiny height. Just
---like the slider, a mini slider can be horizontal or vertical. It will flip
---its orientation according to the set width and height. By default horizontal.
---```text
--- --------[]
---```
---@class renoise.Views.MiniSlider : renoise.Views.Control
---@field min SliderMinValue
---@field max SliderMaxValue
---@field default SliderDefaultValue
---@field value SliderNumberValue
local MiniSlider = {}

---### functions

---Add value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function MiniSlider:add_notifier(notifier) end

---Remove value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function MiniSlider:remove_notifier(notifier) end

--------------------------------------------------------------------------------

---@class MiniSliderProperties : ControlProperties
---@field bind ViewNumberObservable?
---@field value SliderNumberValue?
---@field notifier NumberValueNotifier?
---@field min SliderMinValue?
---@field max SliderMaxValue?
---@field default SliderDefaultValue?
