---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------

---A table of the XYPad's current values on each axis
---@alias XYPadValues { x : SliderNumberValue, y : SliderNumberValue }

---A table of allowed minimum values for each axis
---* Default: {x: 0.0, y: 0.0}
---@alias XYPadMinValues { x : SliderMinValue, y : SliderMinValue }

---A table of allowed maximum values for each axis
---* Default: {x: 1.0, y: 1.0}
---@alias XYPadMaxValues { x : SliderMaxValue, y : SliderMaxValue }

---A table of snapback values for each axis
---When snapback is enabled, the pad will revert its values to the specified
---snapback values as soon as the mouse button is released in the pad.
---When disabled, releasing the mouse button will not change the value.
---You can disable snapback at runtime by setting it to nil or an empty table.
---@alias XYPadSnapbackValues { x : number, y : number }

---@alias XYValueNotifierFunction fun(value: XYPadValues)
---@alias XYValueNotifierMemberFunction fun(self: NotifierMemberContext, value: XYPadValues)
---@alias XYValueNotifierMethod1 {[1]:NotifierMemberContext, [2]:XYValueNotifierMemberFunction}
---@alias XYValueNotifierMethod2 {[1]:XYValueNotifierMemberFunction, [2]:NotifierMemberContext}

---Set up a value notifier function that will be used whenever the pad's values change
---@alias XYValueNotifier XYValueNotifierFunction|XYValueNotifierMethod1|XYValueNotifierMethod2
---
---Bind the view's value to a pair of renoise.Document.ObservableNumber objects.
---Automatically keep both values in sync.
---Will change the Observables' values as soon as the view's value changes,
---and change the view's values as soon as the Observable's value changes.
---Notifiers can be added to either the view or the Observable object.
---Just like in the other XYPad properties, a table with the fields X and Y
---is expected here and not a single value. So you have to bind two
---ObservableNumber object to the pad.
---@alias XYPadObservables { x: renoise.Document.ObservableNumber, y: renoise.Document.ObservableNumber }

--------------------------------------------------------------------------------
---## renoise.Views.XYPad

---A slider like pad which allows for controlling two values at once. By default
---it freely moves the XY values, but it can also be configured to snap back to
---a predefined value when releasing the mouse button.
---
---All values, notifiers, current value or min/max properties will act just
---like a slider or a rotary's properties, but nstead of a single number, a
---table with the fields `{x = xvalue, y = yvalue}` is expected, returned.
---```text
--- +-------+
--- |    o  |
--- |   +   |
--- |       |
--- +-------+
---```
---@class renoise.Views.XYPad : renoise.Views.Control
---@field min XYPadMinValues
---@field max XYPadMaxValues
---@field value XYPadValues
---@field snapback XYPadSnapbackValues?
local XYPad = {}

---### functions

---Add value change notifier
---@param notifier XYValueNotifierFunction
---@overload fun(self, notifier: XYValueNotifierMethod1)
---@overload fun(self, notifier: XYValueNotifierMethod2)
function XYPad:add_notifier(notifier) end

---Remove value change notifier
---@param notifier XYValueNotifierFunction
---@overload fun(self, notifier: XYValueNotifierMethod1)
---@overload fun(self, notifier: XYValueNotifierMethod2)
function XYPad:remove_notifier(notifier) end

--------------------------------------------------------------------------------

---@class XYPadProperties : ControlProperties
---@field bind XYPadObservables?
---@field value XYPadValues?
---@field snapback XYPadSnapbackValues?
---@field notifier XYValueNotifier?
---@field min XYPadMinValues?
---@field max XYPadMaxValues?
