---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------

---The current state of the checkbox, expressed as boolean.
---* Default: false
---@alias CheckBoxBoolean boolean

---A notifier for when the checkbox is toggled
---@alias CheckBoxBooleanNotifier BooleanValueNotifierFunction|BooleanValueNotifierMethod1|BooleanValueNotifierMethod2

--------------------------------------------------------------------------------
---## renoise.Views.CheckBox

---A single button with a checkbox bitmap, which can be used to toggle
---something on/off.
---```text
--- +----+
--- | _/ |
--- +----+
---```
---@class renoise.Views.CheckBox : renoise.Views.Control
---@field value CheckBoxBoolean
local CheckBox = {}

---### functions

---Add value change notifier
---@param notifier BooleanValueNotifierFunction
---@overload fun(self, notifier: BooleanValueNotifierMethod1)
---@overload fun(self, notifier: BooleanValueNotifierMethod2)
function CheckBox:add_notifier(notifier) end

---Remove value change notifier
---@param notifier BooleanValueNotifierFunction
---@overload fun(self, notifier: BooleanValueNotifierMethod1)
---@overload fun(self, notifier: BooleanValueNotifierMethod2)
function CheckBox:remove_notifier(notifier) end

--------------------------------------------------------------------------------

---@class CheckBoxProperties : ControlProperties
---@field bind ViewBooleanObservable?
---@field value CheckBoxBoolean?
---@field notifier CheckBoxBooleanNotifier?
