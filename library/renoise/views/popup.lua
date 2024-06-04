---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

-------------------------------------------------------------------------------

---A list of buttons labels to show in order
---The list can be empty, then "None" is displayed and the value won't change.
---@alias PopupItemLabels string[]

--------------------------------------------------------------------------------
---## renoise.Views.Popup

---A drop-down menu which shows the currently selected value when closed.
---When clicked, it pops up a list of all available items.
---```text
--- +--------------++---+
--- | Current Item || ^ |
--- +--------------++---+
---```
---@class renoise.Views.Popup : renoise.Views.Control
---@field items PopupItemLabels
---@field value SelectedItem
local Popup = {}

---### functions

---Add index change notifier
---@param notifier IntegerValueNotifierFunction
---@overload fun(self, notifier: IntegerValueNotifierMethod1)
---@overload fun(self, notifier: IntegerValueNotifierMethod2)
function Popup:add_notifier(notifier) end

---Remove index change notifier
---@param notifier IntegerValueNotifierFunction
---@overload fun(self, notifier: IntegerValueNotifierMethod1)
---@overload fun(self, notifier: IntegerValueNotifierMethod2)
function Popup:remove_notifier(notifier) end

--------------------------------------------------------------------------------

---@class PopUpMenuProperties : ControlProperties
---@field bind ViewNumberObservable?
---@field value SelectedItem?
---@field notifier IntegerNotifier?
---@field items PopupItemLabels?
