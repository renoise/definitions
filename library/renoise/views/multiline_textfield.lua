---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Views.MultiLineTextField

---Shows multiple text lines of text, auto-wrapping paragraphs into lines. The
---text can be edited by the user.
---```text
--- +--------------------------+-+
--- | Editable Te|xt.          |+|
--- |                          | |
--- | With multiple paragraphs | |
--- | and auto-wrapping        |+|
--- +--------------------------+-+
---```
---@class renoise.Views.MultiLineTextField : renoise.Views.View
---@field active TextActive
---@field value TextMultilineString
---@field text TextValueAlias
---@field selected_text TextMultilineSelectedString
---@field paragraphs TextParagraphs
---@field font TextFontStyle
---@field style TextBackgroundStyle  Default: "border"
---@field edit_mode TextEditMode
local MultiLineTextField = {}

---### functions

---Add value change (text change) notifier
---@param notifier StringValueNotifierFunction
---@overload fun(self, notifier: StringValueNotifierMethod1)
---@overload fun(self, notifier: StringValueNotifierMethod2)
function MultiLineTextField:add_notifier(notifier) end

---Remove value change (text change) notifier
---@param notifier StringValueNotifierFunction
---@overload fun(self, notifier: StringValueNotifierMethod1)
---@overload fun(self, notifier: StringValueNotifierMethod2)
function MultiLineTextField:remove_notifier(notifier) end

---When a scroll bar is visible, scroll the text to show the last line.
function MultiLineTextField:scroll_to_last_line() end

---When a scroll bar is visible, scroll the text to show the first line.
function MultiLineTextField:scroll_to_first_line() end

---Append a new text to the existing text. Newline characters in the string will
---create new paragraphs, otherwise a single paragraph is appended.
---@param text string
function MultiLineTextField:add_line(text) end

---Clear the whole text.
function MultiLineTextField:clear() end

--------------------------------------------------------------------------------

---@class MultilineTextFieldProperties : ViewProperties
---@field bind ViewStringListObservable?
---@field active TextActive?
---@field value TextMultilineString?
---@field notifier StringChangeNotifier?
---@field text TextValueAlias?
---@field paragraphs TextParagraphs?
---@field font TextFontStyle?
---@field style TextBackgroundStyle?
---@field edit_mode TextEditMode?
