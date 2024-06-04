---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Views.RotaryEncoder

---A slider which looks like a potentiometer.
---Note: when changing the size, the minimum of either width or height will be
---used to draw and control the rotary, therefore you should always set both
---equally when possible.
---```text
---    +-+
---  / \   \
--- |   o   |
---  \  |  /
---    +-+
---```
---@class renoise.Views.RotaryEncoder : renoise.Views.Control
---@field min SliderMinValue
---@field max SliderMaxValue
---@field default SliderDefaultValue
---@field value SliderNumberValue
local RotaryEncoder = {}

---### functions

---Add value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function RotaryEncoder:add_notifier(notifier) end

---Remove value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function RotaryEncoder:remove_notifier(notifier) end

--------------------------------------------------------------------------------

---@class RotaryEncoderProperties : ControlProperties
---@field bind ViewNumberObservable?
---@field value SliderNumberValue?
---@field notifier NumberValueNotifier?
---@field min SliderMinValue?
---@field max SliderMaxValue?
---@field default SliderDefaultValue?
