---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---
---For a small tutorial and more details about how to create and use views,
---have a look at the "com.renoise.ExampleToolGUI.xrnx" tool.
---This tool is included in the scripting dev started pack at
---https://github.com/renoise/xrnx/
---

--------------------------------------------------------------------------------
---## renoise.ViewBuilder

---@class renoise.ViewBuilder
renoise.ViewBuilder = {}

---### constants

---Default sizes for views and view layouts. Should be used instead of magic
---numbers, also useful to inherit global changes from the main app.

---The default margin for all control views
renoise.ViewBuilder.DEFAULT_CONTROL_MARGIN = 4
---The default spacing for all control views
renoise.ViewBuilder.DEFAULT_CONTROL_SPACING = 2
---The default height for control views
renoise.ViewBuilder.DEFAULT_CONTROL_HEIGHT = 18
---The default height for mini-sliders
renoise.ViewBuilder.DEFAULT_MINI_CONTROL_HEIGHT = 14
---The default margin for dialogs
renoise.ViewBuilder.DEFAULT_DIALOG_MARGIN = 8
---The default spacing for dialogs
renoise.ViewBuilder.DEFAULT_DIALOG_SPACING = 8
---The default height for buttons
renoise.ViewBuilder.DEFAULT_DIALOG_BUTTON_HEIGHT = 22

--------------------------------------------------------------------------------

---Class which is used to construct new views. All view properties can optionally
---be in-lined in a passed construction table:
---```lua
---local vb = renoise.ViewBuilder() -- create a new ViewBuilder
---vb:button { text = "ButtonText" } -- is the same as
---my_button = vb:button(); my_button.text = "ButtonText"
---```
---Besides the listed class properties, you can also specify the following
---"extra" properties in the passed table:
---
---* id = "SomeString": Can be use to resolve the view later on, e.g.
---  `vb.views.SomeString` or `vb.views["SomeString"]`
---
---* Nested child views: Add child views to the currently specified view.
---
---### examples:
---Creates a column view with `margin = 1` and adds two text views to the column.
---```lua
---vb:column {
---  margin = 1,
---  vb:text {
---    text = "Text1"
---  },
---  vb:text {
---    text = "Text1"
---  }
---}
---```
---@class renoise.ViewBuilder
---
---Table of views, which got registered via the "id" property
---View id is the table key, the table's value is the view's object.
---
---### examples:
---```lua
---vb:text { id="my_view", text="some_text"}
---vb.views.my_view.visible = false
-----or
---vb.views["my_view"].visible = false
---```
---@field views table<string, renoise.Views.View>
renoise.ViewBuilder = {}

---Construct a new viewbuilder instance you can use to create views.
---@return renoise.ViewBuilder
function renoise.ViewBuilder() end

--------------------------------------------------------------------------------

---You can add nested child views when constructing a column or row
---by including them in the constructor table in the views property.
---
---### examples:
---```lua
---vb:column {
---  margin = 1,
---  vb:text {
---    text = "Text1"
---  },
---  vb:text {
---    text = "Text2"
---  }
---}
---```
---@see renoise.Views.Rack
---@alias RackConstructor fun(self : renoise.ViewBuilder, properties : RackViewProperties?) : renoise.Views.Rack

---@type RackConstructor
function renoise.ViewBuilder:column(properties) end

---@type RackConstructor
function renoise.ViewBuilder:row(properties) end

---You can add nested child views when constructing aligners by including them
---in the constructor table.
---
---### examples:
---```lua
---vb:horizontal_aligner {
---   mode = "center",
---   vb:text {
---     text = "Text1"
---   },
---   vb:text {
---     text = "Text2"
---   }
---}
---```
---@see renoise.Views.Aligner
---@alias AlignerConstructor fun(self : renoise.ViewBuilder, properties : AlignerViewProperties?) : renoise.Views.Aligner

---@type AlignerConstructor
function renoise.ViewBuilder:horizontal_aligner(properties) end

---@type AlignerConstructor
function renoise.ViewBuilder:vertical_aligner(properties) end

---You can create an empty space in layouts with a space.
---
---### examples:
---```lua
-----Empty space in layouts
---vb:row {
---  vb:button {
---    text = "Some Button"
---  },
---  vb:space { -- extra spacing between buttons
---    width = 8
---  },
---  vb:button {
---    text = "Another Button"
---  },
---}
---```
---@see renoise.Views.View
---@alias SpaceConstructor fun(self : renoise.ViewBuilder, properties : ViewProperties?) : renoise.Views.View

---@type SpaceConstructor
function renoise.ViewBuilder:space(properties) end

---@see renoise.Views.Text
---@param properties TextViewProperties?
---@return renoise.Views.Text
function renoise.ViewBuilder:text(properties) end

---@see renoise.Views.MultiLineText
---@param properties MultilineTextViewProperties?
---@return renoise.Views.MultiLineText
function renoise.ViewBuilder:multiline_text(properties) end

---@see renoise.Views.TextField
---@param properties TextFieldProperties?
---@return renoise.Views.TextField
function renoise.ViewBuilder:textfield(properties) end

---@see renoise.Views.MultiLineTextField
---@param properties MultilineTextFieldProperties?
---@return renoise.Views.MultiLineTextField
function renoise.ViewBuilder:multiline_textfield(properties) end

---@see renoise.Views.Bitmap
---@param properties BitmapViewProperties?
---@return renoise.Views.Bitmap
function renoise.ViewBuilder:bitmap(properties) end

---@see renoise.Views.Button
---@param properties ButtonProperties?
---@return renoise.Views.Button
function renoise.ViewBuilder:button(properties) end

---@see renoise.Views.CheckBox
---@param properties CheckBoxProperties?
---@return renoise.Views.CheckBox
function renoise.ViewBuilder:checkbox(properties) end

---@see renoise.Views.Switch
---@param properties ButtonSwitchProperties?
---@return renoise.Views.Switch
function renoise.ViewBuilder:switch(properties) end

---@see renoise.Views.Popup
---@param properties PopUpMenuProperties?
---@return renoise.Views.Popup
function renoise.ViewBuilder:popup(properties) end

---@see renoise.Views.Chooser
---@param properties ChooserProperties?
---@return renoise.Views.Chooser
function renoise.ViewBuilder:chooser(properties) end

---@see renoise.Views.ValueBox
---@param properties ValueBoxProperties?
---@return renoise.Views.ValueBox
function renoise.ViewBuilder:valuebox(properties) end

---@see renoise.Views.Value
---@param properties ValueViewProperties?
---@return renoise.Views.Value
function renoise.ViewBuilder:value(properties) end

---@see renoise.Views.ValueField
---@param properties ValueFieldProperties?
---@return renoise.Views.ValueField
function renoise.ViewBuilder:valuefield(properties) end

---@see renoise.Views.Slider
---@param properties SliderProperties?
---@return renoise.Views.Slider
function renoise.ViewBuilder:slider(properties) end

---@see renoise.Views.MiniSlider
---@param properties MiniSliderProperties?
---@return renoise.Views.MiniSlider
function renoise.ViewBuilder:minislider(properties) end

---@see renoise.Views.RotaryEncoder
---@param properties RotaryEncoderProperties?
---@return renoise.Views.RotaryEncoder
function renoise.ViewBuilder:rotary(properties) end

---@see renoise.Views.XYPad
---@param properties XYPadProperties?
---@return renoise.Views.XYPad
function renoise.ViewBuilder:xypad(properties) end
