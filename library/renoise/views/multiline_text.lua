---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------

---The text that should be displayed.
---Newlines (Windows, Mac or Unix styled) in the text can be used to create
---paragraphs.
---@alias TextMultilineString string

---A table of text lines to be used instead of specifying a single text
---line with newline characters like "text"
---* Default: []
---@alias TextParagraphs string[]

---Setup the text view's background:
---@alias TextBackgroundStyle
---| "body"    # simple text color with no background
---| "strong"  # stronger text color with no background
---| "border"  # text on a bordered background

--------------------------------------------------------------------------------
---## renoise.Views.MultiLineText

---Shows multiple lines of text, auto-formatting and auto-wrapping paragraphs
---into lines. Size is not automatically set. As soon as the text no longer fits
---into the view, a vertical scroll bar will be shown.
---
---@see renoise.Views.MultiLineTextField for multiline texts that can be edited
---by the user.
---```text
--- +--------------+-+
--- | Text, Bla 1  |+|
--- | Text, Bla 2  | |
--- | Text, Bla 3  | |
--- | Text, Bla 4  |+|
--- +--------------+-+
---```
---@class renoise.Views.MultiLineText : renoise.Views.View
---@field text TextMultilineString
---@field paragraphs TextParagraphs
---@field font TextFontStyle
---@field style TextBackgroundStyle Default: "body"
local MultiLineText = {}

---### functions

---When a scroll bar is visible (needed), scroll the text to show the last line.
function MultiLineText:scroll_to_last_line() end

---When a scroll bar is visible, scroll the text to show the first line.
function MultiLineText:scroll_to_first_line() end

---Append text to the existing text. Newlines in the text will create new
---paragraphs, just like in the "text" property.
---@param text string
function MultiLineText:add_line(text) end

---Clear the whole text, same as multiline_text.text="".
function MultiLineText:clear() end

--------------------------------------------------------------------------------

---@class MultilineTextViewProperties : ViewProperties
---@field text TextMultilineString?
---@field paragraphs TextParagraphs?
---@field font TextFontStyle?
---@field style TextBackgroundStyle?
