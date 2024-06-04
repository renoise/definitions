---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

-----------------------------------------------------------------------------

---The style that the text should be displayed with.
---@alias TextFontStyle
---| "normal" # (Default)
---| "big"    # big text
---| "bold"   # bold font
---| "italic" # italic font
---| "mono"   # monospace font

---Get/set the color style the text should be displayed with.
---@alias TextStyle
---| "normal"   # (Default)
---| "strong"   # highlighted color
---| "disabled" # greyed out color

---Setup the text's alignment. Applies only when the view's size is larger than
---the needed size to draw the text
---@alias TextAlignment
---| "left"   # (Default)
---| "right"  # aligned to the right
---| "center" # center text

---The text that should be displayed. Setting a new text will resize
---the view in order to make the text fully visible (expanding only).
---* Default: ""
---@alias TextSingleLineString string

-----------------------------------------------------------------------------
---## renoise.Views.Text

---Shows a "static" text string. Static just means that its not linked, bound
---to some value and has no notifiers. The text can not be edited by the user.
---Nevertheless you can of course change the text at run-time with the "text"
---property.
---```text
---  Text, Bla 1
---```
---@see renoise.Views.TextField for texts that can be edited by the user.
---@class renoise.Views.Text : renoise.Views.View
---@field text TextSingleLineString
---@field font TextFontStyle
---@field style TextStyle
---@field align TextAlignment
local Text = {}

-----------------------------------------------------------------------------

---@class TextViewProperties : ViewProperties
---@field text TextSingleLineString?
---@field font TextFontStyle?
---@field style TextStyle?
---@field align TextAlignment?
