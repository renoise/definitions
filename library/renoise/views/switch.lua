---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------

---A list of buttons labels to show in order. Must have more than one item.
---@alias ItemLabels string[]

---The currently selected item's index
---@alias SelectedItem integer

---Set up a notifier that will be called whenever a new item is picked
---@alias IntegerNotifier IntegerValueNotifierFunction|IntegerValueNotifierMethod1|IntegerValueNotifierMethod2

--------------------------------------------------------------------------------
---## renoise.Views.Switch

---A set of horizontally aligned buttons, where only one button can be enabled
---at the same time. Select one of multiple choices, indices.
---```text
--- +-----------+------------+----------+
--- | Button A  | +Button+B+ | Button C |
--- +-----------+------------+----------+
---```
---@class renoise.Views.Switch : renoise.Views.Control
---@field items ItemLabels
---@field value SelectedItem
local Switch = {}

---### functions

---Add index change notifier
---@param notifier IntegerValueNotifierFunction
---@overload fun(self, notifier: IntegerValueNotifierMethod1)
---@overload fun(self, notifier: IntegerValueNotifierMethod2)
function Switch:add_notifier(notifier) end

---Remove index change notifier
---@param notifier IntegerValueNotifierFunction
---@overload fun(self, notifier: IntegerValueNotifierMethod1)
---@overload fun(self, notifier: IntegerValueNotifierMethod2)
function Switch:remove_notifier(notifier) end

--------------------------------------------------------------------------------

---@class ButtonSwitchProperties : ControlProperties
---@field bind ViewNumberObservable?
---@field value SelectedItem?
---@field notifier IntegerNotifier?
---@field items ItemLabels?
