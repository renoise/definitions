---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------

---When false, text is displayed but can not be entered/modified by the user.
---* Default: true
---@alias TextActive boolean

---The currently shown text. The text will not be updated when editing,
---rather only after editing is complete (return is pressed, or focus is lost).
---* Default: ""
---@alias TextValue string

---Exactly the same as "value"; provided for consistency.
---* Default: ""
---@alias TextValueAlias string

---True when the text field is focused. setting it at run-time programatically
---will focus the text field or remove the focus (focus the dialog) accordingly.
---* Default: false
---@alias TextEditMode boolean

---Set up a notifier for text changes
---@alias StringChangeNotifier StringValueNotifierFunction|StringValueNotifierMethod1|StringValueNotifierMethod2

--------------------------------------------------------------------------------
---## renoise.Views.TextField

---Shows a text string that can be clicked and edited by the user.
---```text
--- +----------------+
--- | Editable Te|xt |
--- +----------------+
---```
---@class renoise.Views.TextField : renoise.Views.View
---@field active TextActive
---@field value TextValue
---@field text TextValueAlias
---@field align TextAlignment Only used when not editing.
---@field edit_mode TextEditMode
local TextField = {}

---### functions

---Add value change (text change) notifier
---@param notifier StringValueNotifierFunction
---@overload fun(self, notifier: StringValueNotifierMethod1)
---@overload fun(self, notifier: StringValueNotifierMethod2)
function TextField:add_notifier(notifier) end

---Remove value change (text change) notifier
---@param notifier StringValueNotifierFunction
---@overload fun(self, notifier: StringValueNotifierMethod1)
---@overload fun(self, notifier: StringValueNotifierMethod2)
function TextField:remove_notifier(notifier) end

--------------------------------------------------------------------------------

---@class TextFieldProperties : ViewProperties
---@field bind ViewStringObservable?
---@field active TextActive?
---@field value TextValue?
---@field notifier StringChangeNotifier?
---@field text TextValueAlias?
---@field align TextAlignment?
---@field edit_mode TextEditMode?
