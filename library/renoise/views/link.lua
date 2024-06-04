---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

-----------------------------------------------------------------------------
---## renoise.Views.TextLink

---Shows a text string which is highlighted when hovering with the mouse,
---and which can be clicked to perform some action.
---To create a hyperlink alike text, add a notifier which opens an url via:
---`renoise.app():open_url("https://some.url.com")`
---property.
---```text
---  *Text, *
---```
---@class renoise.Views.TextLink : renoise.Views.Text
---@field active ControlActive
---@field midi_mapping ControlMidiMappingString?
local TextLink = {}

---### functions

---Add/remove text link hit/release notifier functions.
---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function TextLink:add_pressed_notifier(notifier) end

---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function TextLink:add_released_notifier(notifier) end

---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function TextLink:remove_pressed_notifier(notifier) end

---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function TextLink:remove_released_notifier(notifier) end

-----------------------------------------------------------------------------

---@class TextLinkViewProperties : TextViewProperties
---@field active ControlActive?
---@field midi_mapping ControlMidiMappingString?
---@field notifier ButtonNotifier?
---@field pressed ButtonNotifier?
---@field released ButtonNotifier?
