---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------

---Setup how the bitmap should be drawn, recolored. Available modes are:
---@alias BitmapMode
---| "plain"        # bitmap is drawn as is, no recoloring is done (Default)
---| "transparent"  # same as plain, but black pixels will be fully transparent
---| "button_color" # recolor the bitmap, using the theme's button color
---| "body_color"   # same as 'button_back' but with body text/back color
---| "main_color"   # same as 'button_back' but with main text/back colors

---You can load an image from your tool's directory,
---or use one from Renoise's built-in icons.  
---* For the built-in icons, use "Icons/ArrowRight.bmp"
---* For custom images, use a path relative to your tool's root folder.
---
---For example "Images/MyBitmap.bmp" will load the image from
---"com.me.MyTool.xrnx/Images/MyBitmap.bmp".  
---If your custom path matches a built-in icon's (like "Icons/ArrowRight.bmp"),
---your image will be loaded instead of the one from Renoise.  
---
---If you want to support high DPI UI scaling with your bitmaps like the built-in Icons,
---include high resolution versions with their filenames ending with "@4x"  
---The following rules will be used when loading bitmaps  
---* When UI scaling is 100%, only the base bitmaps are used.
---* When UI scaling is 125%, the base bitmaps are used, except if there is a `BitmapName@x1.25.bmp` variant.
---* For all other UI scaling > 125% the "@4x" variants are used and downscaled as needed,
---except when there is an exact match for the current UI scaling factor (e.g. `BitmapName@1.5x.bmp` for 150%)
---@alias BitmapImagePath string

---Supported bitmap file formats are *.bmp, *.png or *.tif (no transparency).
---@alias BitmapPath BitmapImagePath

---A click notifier
---@alias ButtonNotifier NotifierFunction|NotifierMethod1|NotifierMethod2

--------------------------------------------------------------------------------
---## renoise.Views.Bitmap

---Draws a bitmap, or a draws a bitmap which acts like a button (as soon as a
---notifier is specified). The notifier is called when clicking the mouse
---somewhere on the bitmap. When using a re-colorable style (see 'mode'), the
---bitmap is automatically recolored to match the current theme's colors. Mouse
---hover is also enabled when notifiers are present, to show that the bitmap can
---be clicked.
---```text
---        *
---       ***
---    +   *
---   / \
---  +---+
---  | O |  o
---  +---+  |
--- ||||||||||||
---```
---@class renoise.Views.Bitmap : renoise.Views.Control
---@field mode BitmapMode
---@field bitmap BitmapPath
local Bitmap = {}

---### functions

---Add mouse click notifier
---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function Bitmap:add_notifier(notifier) end

---Remove mouse click notifier
---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function Bitmap:remove_notifier(notifier) end

--------------------------------------------------------------------------------

---@class BitmapViewProperties : ControlProperties
---@field mode BitmapMode?
---@field bitmap BitmapPath?
---@field notifier ButtonNotifier?
