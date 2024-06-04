---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Views.Chooser

---A radio button like set of vertically stacked items. Only one value can be
---selected at a time.
---```text
--- . Item A
--- o Item B
--- . Item C
---```
---@class renoise.Views.Chooser : renoise.Views.Control
---@field items ItemLabels
---@field value SelectedItem
local Chooser = {}

---### functions

---Add index change notifier
---@param notifier IntegerValueNotifierFunction
---@overload fun(self, notifier: IntegerValueNotifierMethod1)
---@overload fun(self, notifier: IntegerValueNotifierMethod2)
function Chooser:add_notifier(notifier) end

---Remove index change notifier
---@param notifier IntegerValueNotifierFunction
---@overload fun(self, notifier: IntegerValueNotifierMethod1)
---@overload fun(self, notifier: IntegerValueNotifierMethod2)
function Chooser:remove_notifier(notifier) end

--------------------------------------------------------------------------------

---@class ChooserProperties : ControlProperties
---@field bind ViewNumberObservable?
---@field value SelectedItem?
---@field notifier IntegerNotifier?
---@field items ItemLabels?
