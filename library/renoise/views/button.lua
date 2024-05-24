---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------

---The text label of the button
---* Default: ""
---@alias ButtonLabel string

---If set, existing text is removed and the loaded image is displayed instead.
---Supported bitmap file formats are ".bmp", ".png" and ".tiff".
---Colors in bitmaps will be overridden by the button's theme color, using black
---as the transparent color for BMPs and TIFFS, and the alpha channel for PNGs.
---All other colors are mapped to the theme color according to their grey value,
---so plain white is the target theme color, and all other colors blend into the
---button's background color of the theme.
---@alias ButtonBitmapPath BitmapImagePath

---Setup the buttons text's or bitmap's alignment within the button.
---@alias ButtonAlignment
---| "left"   # aligned to the left
---| "right"  # aligned to the right
---| "center" # center (default)

---When set, the unpressed button's background will be drawn in the specified color.
---A text color is automatically selected unless explicitly set, to make sure its
---always visible.
---Set color {0,0,0} to enable the theme colors for the button again.
---@alias ButtonColor RGBColor|ThemeColor

---When set, the unpressed button's background text or bitmap will be drawn in the
---specified color.
---Set color {0,0,0} to enable the theme colors for the button again.
---@alias ButtonSecondaryColor RGBColor|ThemeColor

---Get/set the style a button should be displayed with.
---@alias ButtonStyle
---| "normal"   # (Default)
---| "rounded"   # rounded corners on all sides
---| "rounded_left" # rounded left side
---| "rounded_right" # rounded right side
---| "rounded_top" # rounded left side
---| "rounded_bottom" # rounded right side

--------------------------------------------------------------------------------
---## renoise.Views.Button

---A simple button that calls a custom notifier function when clicked.
---Supports text or bitmap labels.
---```text
--- +--------+
--- | Button |
--- +--------+
---```
---@class renoise.Views.Button : renoise.Views.Control
---@field text ButtonLabel
---@field bitmap ButtonBitmapPath
---@field align ButtonAlignment
---@field font TextFontStyle
---@field color ButtonColor
---@field secondary_color ButtonSecondaryColor
---@field style ButtonStyle
local Button = {}

---### functions

---Add/remove button hit/release notifier functions.
---When a "pressed" notifier is set, the release notifier is guaranteed to be
---called as soon as the mouse is released, either over your button or anywhere
---else. When a "release" notifier is set, it is only called when the mouse
---button is pressed !and! released over your button.
---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function Button:add_pressed_notifier(notifier) end

---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function Button:add_released_notifier(notifier) end

---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function Button:remove_pressed_notifier(notifier) end

---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function Button:remove_released_notifier(notifier) end

--------------------------------------------------------------------------------

---@class ButtonProperties : ControlProperties
---@field text ButtonLabel?
---@field bitmap ButtonBitmapPath?
---@field align ButtonAlignment?
---@field font TextFontStyle?
---@field color ButtonColor?
---@field secondary_color ButtonColor?
---@field style ButtonStyle?
---@field notifier ButtonNotifier?
---@field pressed ButtonNotifier?
---@field released ButtonNotifier?
