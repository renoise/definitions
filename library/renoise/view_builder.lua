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
---## renoise.Views

---@class renoise.Views
renoise.Views = {}


--------------------------------------------------------------------------------
---## renoise.Views.View

---The dimensions of a view has to be larger than 0.
---For nested views you can also specify relative size
---for example `vb:text { width = "80%"}`. The percentage values are
---relative to the view's parent size and will automatically update on size changes.
---@alias ViewDimension integer|string

---A tooltip text that should be shown for this view on mouse hover.
---* Default: "" (no tip will be shown)
---@alias Tooltip string

---Set visible to false to hide a view (make it invisible without removing
---it). Please note that view.visible will also return false when any of its
---parents are invisible (when its implicitly invisible).
---* Default: true
---@alias Visibility boolean

---@class renoise.Views.View
renoise.Views.View = {}
---View is the base class for all child views. All View properties can be
---applied to any of the following specialized views.
---@class renoise.Views.View
---@field visible Visibility
---@field width ViewDimension
---@field height ViewDimension
---@field tooltip Tooltip

---### functions

---Dynamically create view hierarchies.
---@param child renoise.Views.View
function renoise.Views.View:add_child(child) end

---@param child renoise.Views.View
function renoise.Views.View:remove_child(child) end


--------------------------------------------------------------------------------
---## renoise.Views.Control

---Instead of making a control invisible, you can also make it inactive.
---Deactivated controls will still be shown, and will still show their
---currently assigned values, but will not allow changes. Most controls will
---display as "grayed out" to visualize the deactivated state.
---@alias ControlActive boolean

---When set, the control will be highlighted when Renoise's MIDI mapping dialog
---is open. When clicked, it selects the specified string as a MIDI mapping
---target action. This target acton can either be one of the globally available
---mappings in Renoise, or those that were created by the tool itself.
---Target strings are not verified. When they point to nothing, the mapped MIDI
---message will do nothing and no error is fired.
---@alias MidiMappingString string

---@class renoise.Views.Control
renoise.Views.Control = {}
---Control is the base class for all views which let the user change a value or
---some "state" from the UI.
---@class renoise.Views.Control : renoise.Views.View
---@field active ControlActive
---@field midi_mapping MidiMappingString


--------------------------------------------------------------------------------
---## renoise.Views.Rack

---Set the "borders" of a rack (left, right, top and bottom inclusively)
---*  Default: 0 (no borders)
---@alias RackMargin integer

---Set the amount stacked child views are separated by (horizontally in
---rows, vertically in columns).
---*  Default: 0 (no spacing)
---@alias RackSpacing integer

---When set to true, all child views in the rack are automatically resized to
---the max size of all child views (width in ViewBuilder.column, height in
---ViewBuilder.row). This can be useful to automatically align all sub
---columns/panels to the same size. Resizing is done automatically, as soon
---as a child view size changes or new children are added.
---* Default: false
---@alias RackUniformity boolean

---Setup a background style for the rack. Available styles are:
---@alias RackStyle
---| "invisible" # no background (Default)
---| "plain"     # undecorated, single coloured background
---| "border"    # same as plain, but with a bold nested border
---| "body"      # main "background" style, as used in dialog backgrounds
---| "panel"     # alternative "background" style, beveled
---| "group"     # background for "nested" groups within body

---@class renoise.Views.Rack
renoise.Views.Rack = {}
---A Rack has no content on its own. It only stacks child views. Either
---vertically (ViewBuilder.column) or horizontally (ViewBuilder.row). It allows
---you to create view layouts.
---
---@class renoise.Views.Rack : renoise.Views.View
---@field margin RackMargin
---@field spacing RackSpacing
---@field style RackStyle
---@field uniform RackUniformity

---### functions

---Used to manually fit contents. No longer needed. Does nothing.
---@deprecated
function renoise.Views.Rack:resize() end


--------------------------------------------------------------------------------
---## renoise.Views.Aligner

---* Default: "left" (for horizontal_aligner) "top" (for vertical_aligner)
---@alias AlignerMode
---| "left"       # align from left to right (for horizontal_aligner only)
---| "right"      # align from right to left (for horizontal_aligner only)
---| "top"        # align from top to bottom (for vertical_aligner only)
---| "bottom"     # align from bottom to top (for vertical_aligner only)
---| "center"     # center all views
---| "justify"    # keep outer views at the borders, distribute the rest
---| "distribute" # equally distributes views over the aligners width/height

---@class renoise.Views.Aligner
renoise.Views.Aligner = {}
---Just like a Rack, the Aligner shows no content on its own. It just aligns
---child views vertically or horizontally. As soon as children are added, the
---Aligner will expand itself to make sure that all children are visible
---(including spacing & margins).
---To make use of modes like "center", you manually have to setup a size that
---is bigger than the sum of the child sizes.
---
---@class renoise.Views.Aligner : renoise.Views.View
---@field margin RackMargin
---@field spacing RackSpacing
---@field mode AlignerMode


-----------------------------------------------------------------------------
---## renoise.Views.Text

---The style that the text should be displayed with.
---@alias FontStyle
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
---@alias SingleLineString string

---@class renoise.Views.Text
renoise.Views.Text = {}
---Shows a "static" text string. Static just means that its not linked, bound
---to some value and has no notifiers. The text can not be edited by the user.
---Nevertheless you can of course change the text at run-time with the "text"
---property.
---```md
---  Text, Bla 1
---```
---@see renoise.Views.TextField for texts that can be edited by the user.
---@class renoise.Views.Text : renoise.Views.View
---@field text SingleLineString
---@field font FontStyle
---@field style TextStyle
---@field align TextAlignment


--------------------------------------------------------------------------------
---## renoise.Views.MultiLineText

---The text that should be displayed.
---Newlines (Windows, Mac or Unix styled) in the text can be used to create
---paragraphs.
---@alias MultilineString string

---A table of text lines to be used instead of specifying a single text
---line with newline characters like "text"
---* Default: []
---@alias Paragraphs string[]

---Setup the text view's background:
---@alias TextBackgroundStyle
---| "body"    # simple text color with no background
---| "strong"  # stronger text color with no background
---| "border"  # text on a bordered background

---@class renoise.Views.MultiLineText
renoise.Views.MultiLineText = {}
---Shows multiple lines of text, auto-formatting and auto-wrapping paragraphs
---into lines. Size is not automatically set. As soon as the text no longer fits
---into the view, a vertical scroll bar will be shown.
---
---@see renoise.Views.MultiLineTextField for multiline texts that can be edited
---by the user.
---```md
--- +--------------+-+
--- | Text, Bla 1  |+|
--- | Text, Bla 2  | |
--- | Text, Bla 3  | |
--- | Text, Bla 4  |+|
--- +--------------+-+
---```
---@class renoise.Views.MultiLineText : renoise.Views.View
---@field text MultilineString
---@field paragraphs Paragraphs
---@field font FontStyle
---@field style TextBackgroundStyle Default: "body"

---### functions

---When a scroll bar is visible (needed), scroll the text to show the last line.
function renoise.Views.MultiLineText:scroll_to_last_line() end

---When a scroll bar is visible, scroll the text to show the first line.
function renoise.Views.MultiLineText:scroll_to_first_line() end

---Append text to the existing text. Newlines in the text will create new
---paragraphs, just like in the "text" property.
---@param text string
function renoise.Views.MultiLineText:add_line(text) end

---Clear the whole text, same as multiline_text.text="".
function renoise.Views.MultiLineText:clear() end


--------------------------------------------------------------------------------
---## renoise.Views.TextField

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
---@alias EditMode boolean 

---Set up a notifier for text changes
---@alias StringChangeNotifier StringValueNotifierFunction|StringValueNotifierMethod1|StringValueNotifierMethod2

---@class renoise.Views.TextField
renoise.Views.TextField = {}
---Shows a text string that can be clicked and edited by the user.
---```md
--- +----------------+
--- | Editable Te|xt |
--- +----------------+
---```
---@class renoise.Views.TextField : renoise.Views.View
---@field active TextActive
---@field value TextValue
---@field text TextValueAlias
---@field align TextAlignment Only used when not editing.
---@field edit_mode EditMode

---### functions

---Add value change (text change) notifier
---@param notifier StringValueNotifierFunction
---@overload fun(self, notifier: StringValueNotifierMethod1)
---@overload fun(self, notifier: StringValueNotifierMethod2)
function renoise.Views.TextField:add_notifier(notifier) end

---Remove value change (text change) notifier
---@param notifier StringValueNotifierFunction
---@overload fun(self, notifier: StringValueNotifierMethod1)
---@overload fun(self, notifier: StringValueNotifierMethod2)
function renoise.Views.TextField:remove_notifier(notifier) end


--------------------------------------------------------------------------------
---## renoise.Views.MultiLineTextField

---@class renoise.Views.MultiLineTextField
renoise.Views.MultiLineTextField = {}
---Shows multiple text lines of text, auto-wrapping paragraphs into lines. The
---text can be edited by the user.
---```md
--- +--------------------------+-+
--- | Editable Te|xt.          |+|
--- |                          | |
--- | With multiple paragraphs | |
--- | and auto-wrapping        |+|
--- +--------------------------+-+
---```
---@class renoise.Views.MultiLineTextField : renoise.Views.View
---@field active TextActive
---@field value MultilineString
---@field text TextValueAlias
---@field paragraphs Paragraphs
---@field font FontStyle
---@field style TextBackgroundStyle  Default: "border"
---@field edit_mode EditMode

---### functions

---Add value change (text change) notifier
---@param notifier StringValueNotifierFunction
---@overload fun(self, notifier: StringValueNotifierMethod1)
---@overload fun(self, notifier: StringValueNotifierMethod2)
function renoise.Views.MultiLineTextField:add_notifier(notifier) end

---Remove value change (text change) notifier
---@param notifier StringValueNotifierFunction
---@overload fun(self, notifier: StringValueNotifierMethod1)
---@overload fun(self, notifier: StringValueNotifierMethod2)
function renoise.Views.MultiLineTextField:remove_notifier(notifier) end

---When a scroll bar is visible, scroll the text to show the last line.
function renoise.Views.MultiLineTextField:scroll_to_last_line() end

---When a scroll bar is visible, scroll the text to show the first line.
function renoise.Views.MultiLineTextField:scroll_to_first_line() end

---Append a new text to the existing text. Newline characters in the string will
---create new paragraphs, othwerise a single paragraph is appended.
---@param text string
function renoise.Views.MultiLineTextField:add_line(text) end

---Clear the whole text.
function renoise.Views.MultiLineTextField:clear() end


--------------------------------------------------------------------------------
---## renoise.Views.Bitmap

---Setup how the bitmap should be drawn, recolored. Available modes are:
---@alias BitmapMode
---| "plain"        # bitmap is drawn as is, no recoloring is done (Default)
---| "transparent"  # same as plain, but black pixels will be fully transparent
---| "button_color" # recolor the bitmap, using the theme's button color
---| "body_color"   # same as 'button_back' but with body text/back color
---| "main_color"   # same as 'button_back' but with main text/back colors

---Bitmap name and path. You should use a relative path that uses  Renoise's
---default resource folder as base (like "Icons/ArrowRight.bmp"). Or specify a
---file relative from your XRNX tool bundle:
---Lets say your tool is called "com.foo.MyTool.xrnx" and you pass
---"MyBitmap.bmp" as the name. Then the bitmap is loaded from
---"PATH_TO/com.foo.MyTool.xrnx/MyBitmap.bmp".
---Supported bitmap file formats are *.bmp, *.png or *.tif (no transparency).
---@alias BitmapPath string

---A click notifier
---@alias Notifier NotifierFunction|NotifierMethod1|NotifierMethod2

---@class renoise.Views.Bitmap
renoise.Views.Bitmap = {}
---Draws a bitmap, or a draws a bitmap which acts like a button (as soon as a
---notifier is specified). The notifier is called when clicking the mouse
---somewhere on the bitmap. When using a re-colorable style (see 'mode'), the
---bitmap is automatically recolored to match the current theme's colors. Mouse
---hover is also enabled when notifies are present, to show that the bitmap can
---be clicked.
---```md
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

---### functions

---Add mouse click notifier
---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function renoise.Views.Bitmap:add_notifier(notifier) end

---Remove mouse click notifier
---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function renoise.Views.Bitmap:remove_notifier(notifier) end


--------------------------------------------------------------------------------
---## renoise.Views.Button

---The text label of the button
---* Default: ""
---@alias ButtonLabel string

---When set, existing text is cleared. You should use a relative path
---that either assumes Renoises default resource folder as base (like
---"Icons/ArrowRight.bmp"). Or specify a file relative from your XRNX tool
---bundle:
---Lets say your tool is called "com.foo.MyTool.xrnx" and you pass
---"MyBitmap.bmp" as name. Then the bitmap is loaded from
---"PATH_TO/com.foo.MyTool.xrnx/MyBitmap.bmp".
---The only supported bitmap format is ".bmp" (Windows bitmap) right now.
---Colors will be overridden by the theme colors, using black as transparent
---color, white is the full theme color. All colors in between are mapped
---according to their gray value.
---@alias ButtonBitmapPath string

---When set, the unpressed button's background will be drawn in the specified color.
---A text color is automatically selected to make sure its always visible.
---Set color {0,0,0} to enable the theme colors for the button again.
---@alias ButtonColor RGBColor

---@class renoise.Views.Button : renoise.Views.Control
renoise.Views.Button = {}
---A simple button that calls a custom notifier function when clicked.
---Supports text or bitmap labels.
---```md
--- +--------+
--- | Button |
--- +--------+
---```
---@class renoise.Views.Button : renoise.Views.Control
---@field text ButtonLabel
---@field bitmap ButtonBitmapPath
---@field color ButtonColor

---### functions

---Add/remove button hit/release notifier functions.
---When a "pressed" notifier is set, the release notifier is guaranteed to be
---called as soon as the mouse is released, either over your button or anywhere
---else. When a "release" notifier is set, it is only called when the mouse
---button is pressed !and! released over your button.
---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function renoise.Views.Button:add_pressed_notifier(notifier) end

---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function renoise.Views.Button:add_released_notifier(notifier) end

---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function renoise.Views.Button:remove_pressed_notifier(notifier) end

---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function renoise.Views.Button:remove_released_notifier(notifier) end


--------------------------------------------------------------------------------
---## renoise.Views.CheckBox

---The current state of the checkbox, expressed as boolean.
---* Default: false
---@alias CheckBoxBoolean boolean

---A notifier for when the checkbox is toggled
---@alias BooleanNotifier BooleanValueNotifierFunction|BooleanValueNotifierMethod1|BooleanValueNotifierMethod2

---@class renoise.Views.CheckBox
renoise.Views.CheckBox = {}
---A single button with a checkbox bitmap, which can be used to toggle
---something on/off.
---```md
--- +----+
--- | _/ |
--- +----+
---```
---@class renoise.Views.CheckBox : renoise.Views.Control
---@field value CheckBoxBoolean

---### functions

---Add value change notifier
---@param notifier BooleanValueNotifierFunction
---@overload fun(self, notifier: BooleanValueNotifierMethod1)
---@overload fun(self, notifier: BooleanValueNotifierMethod2)
function renoise.Views.CheckBox:add_notifier(notifier) end

---Remove value change notifier
---@param notifier BooleanValueNotifierFunction
---@overload fun(self, notifier: BooleanValueNotifierMethod1)
---@overload fun(self, notifier: BooleanValueNotifierMethod2)
function renoise.Views.CheckBox:remove_notifier(notifier) end


--------------------------------------------------------------------------------
---## renoise.Views.Switch

---A list of buttons labels to show in order
---must have more than one item
---@alias ItemLabels string[]

---The currently selected item's index
---@alias SelectedItem integer

---Set up a notifier that will be called whenever a new item is picked
---@alias IntegerNotifier IntegerValueNotifierFunction|IntegerValueNotifierMethod1|IntegerValueNotifierMethod2

---@class renoise.Views.Switch : renoise.Views.Control
renoise.Views.Switch = {}
---A set of horizontally aligned buttons, where only one button can be enabled
---at the same time. Select one of multiple choices, indices.
---```md
--- +-----------+------------+----------+
--- | Button A  | +Button+B+ | Button C |
--- +-----------+------------+----------+
---```
---@class renoise.Views.Switch : renoise.Views.Control
---@field items ItemLabels
---@field value SelectedItem

---### functions

---Add index change notifier
---@param notifier IntegerValueNotifierFunction
---@overload fun(self, notifier: IntegerValueNotifierMethod1)
---@overload fun(self, notifier: IntegerValueNotifierMethod2)
function renoise.Views.Switch:add_notifier(notifier) end

---Remove index change notifier
---@param notifier IntegerValueNotifierFunction
---@overload fun(self, notifier: IntegerValueNotifierMethod1)
---@overload fun(self, notifier: IntegerValueNotifierMethod2)
function renoise.Views.Switch:remove_notifier(notifier) end


--------------------------------------------------------------------------------
---## renoise.Views.Popup

---A list of buttons labels to show in order
---The list can be empty, then "None" is displayed and the value won't change.
---@alias PopupItemLabels string[]

---@class renoise.Views.Popup
renoise.Views.Popup = {}
---A drop-down menu which shows the currently selected value when closed.
---When clicked, it pops up a list of all available items.
---```md
--- +--------------++---+
--- | Current Item || ^ |
--- +--------------++---+
---```
---@class renoise.Views.Popup : renoise.Views.Control
---@field items PopupItemLabels
---@field value SelectedItem

---### functions

---Add index change notifier
---@param notifier IntegerValueNotifierFunction
---@overload fun(self, notifier: IntegerValueNotifierMethod1)
---@overload fun(self, notifier: IntegerValueNotifierMethod2)
function renoise.Views.Popup:add_notifier(notifier) end

---Remove index change notifier
---@param notifier IntegerValueNotifierFunction
---@overload fun(self, notifier: IntegerValueNotifierMethod1)
---@overload fun(self, notifier: IntegerValueNotifierMethod2)
function renoise.Views.Popup:remove_notifier(notifier) end


--------------------------------------------------------------------------------
---## renoise.Views.Chooser

---@class renoise.Views.Chooser
renoise.Views.Chooser = {}
---A radio button like set of vertically stacked items. Only one value can be
---selected at a time.
---```md
--- . Item A
--- o Item B
--- . Item C
---```
---@class renoise.Views.Chooser : renoise.Views.Control
---@field items ItemLabels
---@field value SelectedItem

---### functions

---Add index change notifier
---@param notifier IntegerValueNotifierFunction
---@overload fun(self, notifier: IntegerValueNotifierMethod1)
---@overload fun(self, notifier: IntegerValueNotifierMethod2)
function renoise.Views.Chooser:add_notifier(notifier) end

---Remove index change notifier
---@param notifier IntegerValueNotifierFunction
---@overload fun(self, notifier: IntegerValueNotifierMethod1)
---@overload fun(self, notifier: IntegerValueNotifierMethod2)
function renoise.Views.Chooser:remove_notifier(notifier) end



--------------------------------------------------------------------------------
---## renoise.Views.ValueBox

---The minimum value that can be set using the view
---* Default: 0
---@alias MinValue number

---The maximum value that can be set using the view
---* Default: 1.0
---@alias MaxValue number

---The maximum value that can be set using the view
---* Default: 100
---@alias ValueBoxMaxValue number

---The default value that will be re-applied on double-click
---@alias DefaultValue number

---The current value of the view
---@alias NumberValue number

---A table containing two numbers representing the step amounts for incrementing
---and decrementing by clicking the <> buttons.
---The first value is the small step (applied on left clicks)
---second value is the big step (applied on right clicks)
---@alias StepAmounts {[1] : number, [2] : number}

---Set a custom rule on how a number value should be displayed.
---Useful for showing units like decibel or note values etc.
---If none are set, a default string/number conversion is done, which
---simply shows the number with 3 digits after the decimal point.
---Note: When the callback fails with an error, it will be disabled to avoid
---a flood of error messages.
---@alias ShowNumberAsString fun(value : number) : string?

---Make sure to also set `tonumber` if you set this.
---@alias PairedShowNumberAsString ShowNumberAsString

---Set a custom function to parse a number value from a user-provided string.
---When returning nil, no conversion will be done and the value will not change.
---Note: When the callback fails with an error, it will be disabled to avoid
---a flood of error messages.
---@alias ParseStringAsNumber fun(value : string) : number?

---Make sure to also set `tostring` if you set this.
---@alias PairedParseStringAsNumber fun(value : string) : number?

---Set up a value notifier that will be called whenever the value changes
---@alias NumberValueNotifier NumberValueNotifierFunction|NumberValueNotifierMethod1|NumberValueNotifierMethod2

---@class renoise.Views.ValueBox
renoise.Views.ValueBox = {}
---A box with arrow buttons and a text field that can be edited by the user.
---Allows showing and editing natural numbers in a custom range.
---```md
--- +---+-------+
--- |<|>|  12   |
--- +---+-------+
---```
---@class renoise.Views.ValueBox : renoise.Views.Control
---@field min MinValue
---@field max ValueBoxMaxValue
---@field steps StepAmounts
---@field value NumberValue

---### functions

---Add value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function renoise.Views.ValueBox:add_notifier(notifier) end

---Remove value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function renoise.Views.ValueBox:remove_notifier(notifier) end


--------------------------------------------------------------------------------
---## renoise.Views.Value

---@class renoise.Views.Value
renoise.Views.Value = {}
---A static text view. Shows a string representation of a number and
---allows custom "number to string" conversion.
---@see renoise.Views.ValueField for a value text field that can be edited by the user.
---```md
--- +---+-------+
--- | 12.1 dB   |
--- +---+-------+
---```
---@class renoise.Views.Value : renoise.Views.View
---@field value NumberValue
---@field font FontStyle
---@field align TextAlignment

---### functions

---Add value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function renoise.Views.Value:add_notifier(notifier) end

---Remove value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function renoise.Views.Value:remove_notifier(notifier) end


--------------------------------------------------------------------------------
---## renoise.Views.ValueField

---@class renoise.Views.ValueField
renoise.Views.ValueField = {}
---A text view, which shows a string representation of a number and allows
---custom "number to string" conversion. The value's text can be edited by the
---user.
---```lua
--- +---+-------+
--- | 12.1 dB   |
--- +---+-------+
---```
---@class renoise.Views.ValueField : renoise.Views.Control
---@field min MinValue
---@field max MaxValue
---@field value NumberValue
---@field align TextAlignment

---### functions

---Add value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function renoise.Views.ValueField:add_notifier(notifier) end

---Remove value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function renoise.Views.ValueField:remove_notifier(notifier) end


--------------------------------------------------------------------------------
---## renoise.Views.Slider

---@class renoise.Views.Slider
renoise.Views.Slider = {}
---A slider with arrow buttons, which shows and allows editing of values in a
---custom range. A slider can be horizontal or vertical; will flip its
---orientation according to the set width and height. By default horizontal.
---```md
--- +---+---------------+
--- |<|>| --------[]    |
--- +---+---------------+
---```
---@class renoise.Views.Slider : renoise.Views.Control
---@field min MinValue
---@field max MaxValue
---@field steps StepAmounts
---@field default DefaultValue
---@field value NumberValue

---### functions

---Add value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function renoise.Views.Slider:add_notifier(notifier) end

---Remove value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function renoise.Views.Slider:remove_notifier(notifier) end


--------------------------------------------------------------------------------
---## renoise.Views.MiniSlider

---@class renoise.Views.MiniSlider
renoise.Views.MiniSlider = {}
---Same as a slider, but without arrow buttons and a really tiny height. Just
---like the slider, a mini slider can be horizontal or vertical. It will flip
---its orientation according to the set width and height. By default horizontal.
---```md
--- --------[]
---```
---@class renoise.Views.MiniSlider : renoise.Views.Control
---@field min MinValue
---@field max MaxValue
---@field default DefaultValue
---@field value NumberValue

---### functions

---Add value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function renoise.Views.MiniSlider:add_notifier(notifier) end

---Remove value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function renoise.Views.MiniSlider:remove_notifier(notifier) end


--------------------------------------------------------------------------------
---## renoise.Views.RotaryEncoder

---@class renoise.Views.RotaryEncoder
renoise.Views.RotaryEncoder = {}
---A slider which looks like a potentiometer.
---Note: when changing the size, the minimum of either width or height will be
---used to draw and control the rotary, therefor you should always set both
---equally when possible.
---```md
---    +-+
---  / \   \
--- |   o   |
---  \  |  /
---    +-+
---```
---@class renoise.Views.RotaryEncoder : renoise.Views.Control
---@field min MinValue
---@field max MaxValue
---@field default DefaultValue
---@field value NumberValue

---### functions

---Add value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function renoise.Views.RotaryEncoder:add_notifier(notifier) end

---Remove value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function renoise.Views.RotaryEncoder:remove_notifier(notifier) end


--------------------------------------------------------------------------------
---## renoise.Views.XYPad

---A table of the XYPad's current values on each axis
---@alias XYPadValues { x : NumberValue, y : NumberValue }

---A table of allowed minimum values for each axis
---* Default: {x: 0.0, y: 0.0}
---@alias XYPadMinValues { x : MinValue, y : MinValue }

---A table of allowed maximum values for each axis
---* Default: {x: 1.0, y: 1.0}
---@alias XYPadMaxValues { x : MaxValue, y : MaxValue }

---A table of snapback values for each axis
---When snapback is enabled, the pad will revert its values to the specified
---snapback values as soon as the mouse button is released in the pad. 
---When disabled, releasing the mouse button will not change the value.
---You can disable snapback at runtime by setting it to nil or an empty table.
---@alias XYPadSnapbackValues { x : number, y : number }

---@alias XYValueNotifierFunction fun(value: XYPadValues)
---@alias XYValueNotifierMemberFunction fun(self: NotifierMemberContext, value: XYPadValues)
---@alias XYValueNotifierMethod1 {[1]:NotifierMemberContext, [2]:XYValueNotifierMemberFunction}
---@alias XYValueNotifierMethod2 {[1]:XYValueNotifierMemberFunction, [2]:NotifierMemberContext}

---Set up a value notifier function that will be used whenever the pad's values change
---@alias XYValueNotifier XYValueNotifierFunction|XYValueNotifierMethod1|XYValueNotifierMethod2
---
---Bind the view's value to a pair of renoise.Document.ObservableNumber objects. 
---Automatically keep both values in sync.
---Will change the Observables' values as soon as the view's value changes, 
---and change the view's values as soon as the Observable's value changes.
---Notifiers can be added to either the view or the Observable object.
---Just like in the other XYPad properties, a table with the fields X and Y
---is expected here and not a single value. So you have to bind two
---ObservableNumber object to the pad.
---@alias XYPadObservables { x: renoise.Document.ObservableNumber, y: renoise.Document.ObservableNumber }

---@class renoise.Views.XYPad
renoise.Views.XYPad = {}
---A slider like pad which allows for controlling two values at once. By default
---it freely moves the XY values, but it can also be configured to snap back to
---a predefined value when releasing the mouse button.
---
---All values, notifiers, current value or min/max properties will act just
---like a slider or a rotary's properties, but nstead of a single number, a
---table with the fields `{x = xvalue, y = yvalue}` is expected, returned.
---```md
--- +-------+
--- |    o  |
--- |   +   |
--- |       |
--- +-------+
---```
---@class renoise.Views.XYPad : renoise.Views.Control
---@field min XYPadMinValues
---@field max XYPadMaxValues
---@field value XYPadValues
---@field snapback XYPadSnapbackValues?

---### functions

---Add value change notifier
---@param notifier XYValueNotifierFunction
---@overload fun(self, notifier: XYValueNotifierMethod1)
---@overload fun(self, notifier: XYValueNotifierMethod2)
function renoise.Views.XYPad:add_notifier(notifier) end

---Remove value change notifier
---@param notifier XYValueNotifierFunction
---@overload fun(self, notifier: XYValueNotifierMethod1)
---@overload fun(self, notifier: XYValueNotifierMethod2)
function renoise.Views.XYPad:remove_notifier(notifier) end


--------------------------------------------------------------------------------
---## ViewBuilderInstance

---@class ViewBuilderInstance
local ViewBuilderInstance = {}


---Class which is used to construct new views. All view properties can optionally be in-lined in a passed construction table:
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
---* Nested child views: Add a child view to the currently specified view.
---  For example:
---```lua
---vb:column {
---   margin = 1,
---   vb:text {
---     text = "Text1"
---   },
---   vb:text {
---     text = "Text1"
---   }
---}
---```
---Creates a column view with `margin = 1` and adds two text views to the column.
---@class ViewBuilderInstance
---
---Table of views, which got registered via the "id" property
---View id is the table key, the table's value is the view's object.
---
---### example
---```lua
---vb:text { id="my_view", text="some_text"}
---vb.views.my_view.visible = false
-----or
---vb.views["my_view"].visible = false
---```
---@field views table<string, renoise.Views.View>

---Construct a new viewbuilder instance you can use to create views
---@return ViewBuilderInstance
function renoise.ViewBuilder() end

--------------------------------------------------------------------------------
---## classes for constructor tables

---Bind the view's value to a renoise.Document.ObservableBoolean object.
---Automatically keep them in sync.
---The view will change the Observable value as soon as its value changes
---and change the view's value as soon as the Observable's value changes.
---Notifiers can be added to either the view or the Observable object.
---@alias BooleanObservable renoise.Document.ObservableBoolean

---Bind the view's value to a renoise.Document.ObservableString object.
---Automatically keep them in sync.
---The view will change the Observable value as soon as its value changes
---and change the view's value as soon as the Observable's value changes.
---Notifiers can be added to either the view or the Observable object.
---@alias StringObservable renoise.Document.ObservableString

---Bind the view's value to a renoise.Document.ObservableStringList object.
---Automatically keep them in sync.
---The view will change the Observable value as soon as its value changes
---and change the view's value as soon as the Observable's value changes.
---Notifiers can be added to either the view or the Observable object.
---@alias StringListObservable renoise.Document.ObservableStringList

---Bind the view's value to a renoise.Document.ObservableNumber object.
---Automatically keep them in sync.
---The view will change the Observable value as soon as its value changes
---and change the view's value as soon as the Observable's value changes.
---Notifiers can be added to either the view or the Observable object.
---@alias NumberObservable renoise.Document.ObservableNumber

--- base for all View constructor tables
---@class ViewProperties
---@field id string?
---@field width ViewDimension?
---@field height ViewDimension?
---@field visible Visibility?
---@field tooltip Tooltip?

---@class ControlProperties : ViewProperties
---@field active ControlActive?
---@field midi_mapping MidiMappingString?

---@class RackViewProperties : ViewProperties
---@field margin RackMargin?
---@field spacing RackSpacing?
---@field style RackStyle?
---@field uniform RackUniformity?

---@class AlignmentRackViewProperties : ViewProperties
---@field margin RackMargin?
---@field spacing RackSpacing?
---@field mode AlignerMode?

---@class TextViewProperties : ViewProperties
---@field text SingleLineString?
---@field font FontStyle?
---@field style TextStyle?
---@field align TextAlignment?

---@class MultilineTextViewProperties : ViewProperties
---@field text MultilineString?
---@field paragraphs Paragraphs?
---@field font FontStyle?
---@field style TextBackgroundStyle?

---@class TextFieldProperties : ViewProperties
---@field bind StringObservable?
---@field active TextActive?
---@field value TextValue?
---@field notifier StringChangeNotifier?
---@field text TextValueAlias?
---@field align TextAlignment?
---@field edit_mode EditMode?

---@class MultilineTextFieldProperties : ViewProperties
---@field bind StringListObservable?
---@field active TextActive?
---@field value MultilineString?
---@field notifier StringChangeNotifier?
---@field text TextValueAlias?
---@field paragraphs Paragraphs?
---@field font FontStyle?
---@field style TextBackgroundStyle?
---@field edit_mode EditMode?

---@class ButtonProperties : ControlProperties
---@field text ButtonLabel?
---@field bitmap ButtonBitmapPath?
---@field color ButtonColor?
---@field notifier Notifier?
---@field pressed Notifier?
---@field released Notifier?

---@class BitmapViewProperties : ControlProperties
---@field mode BitmapMode?
---@field bitmap BitmapPath?
---@field notifier Notifier?

---@class CheckBoxProperties : ControlProperties
---@field bind BooleanObservable?
---@field value CheckBoxBoolean?
---@field notifier BooleanNotifier?

---@class ButtonSwitchProperties : ControlProperties
---@field bind NumberObservable?
---@field value SelectedItem?
---@field notifier IntegerNotifier?
---@field items ItemLabels?

---@class PopUpMenuProperties : ControlProperties
---@field bind NumberObservable?
---@field value SelectedItem?
---@field notifier IntegerNotifier?
---@field items PopupItemLabels?

---@class ChooserProperties : ControlProperties
---@field bind NumberObservable?
---@field value SelectedItem?
---@field notifier IntegerNotifier?
---@field items ItemLabels?

---@class ValueViewProperties : ViewProperties
---@field bind NumberObservable?
---@field value NumberValue?
---@field notifier NumberValueNotifier?
---@field align TextAlignment?
---@field font FontStyle?
---@field tostring ShowNumberAsString?

---@class ValueBoxProperties : ControlProperties
---@field bind NumberObservable?
---@field value NumberValue?
---@field notifier NumberValueNotifier?
---@field min MinValue?
---@field max ValueBoxMaxValue?
---@field steps StepAmounts?
---@field tostring PairedShowNumberAsString?
---@field tonumber PairedParseStringAsNumber?

---@class ValueFieldProperties : ControlProperties
---@field bind NumberObservable?
---@field value NumberValue?
---@field notifier NumberValueNotifier?
---@field min MinValue?
---@field max MaxValue?
---@field align TextAlignment?
---@field tostring PairedShowNumberAsString?
---@field tonumber PairedParseStringAsNumber?

---@class SliderProperties : ControlProperties
---@field bind NumberObservable?
---@field value NumberValue?
---@field notifier NumberValueNotifier?
---@field min MinValue?
---@field max MaxValue?
---@field steps StepAmounts?
---@field default DefaultValue?

---@class MiniSliderProperties : ControlProperties
---@field bind NumberObservable?
---@field value NumberValue?
---@field notifier NumberValueNotifier?
---@field min MinValue?
---@field max MaxValue?
---@field default DefaultValue?

---@class RotaryEncoderProperties : ControlProperties
---@field bind NumberObservable?
---@field value NumberValue?
---@field notifier NumberValueNotifier?
---@field min MinValue?
---@field max MaxValue?
---@field default DefaultValue?

---@class XYPadProperties : ControlProperties
---@field bind XYPadObservables?
---@field value XYPadValues?
---@field snapback XYPadSnapbackValues?
---@field notifier XYValueNotifier?
---@field min XYPadMinValues?
---@field max XYPadMaxValues?

---### constructor functions

---You can add nested child views when constructing a column or row 
---by including them in the constructor table.  
---For example:  
---```lua
---vb:column {
---   margin = 1,
---   vb:text {
---     text = "Text1"
---   },
---   vb:text {
---     text = "Text2"
---   }
---}
---```
---@see renoise.Views.Rack
---@alias RackConstructor fun(self : ViewBuilderInstance, properties : RackViewProperties) : renoise.Views.Rack

---You can add nested child views when constructing aligners by including them
---in the constructor table.  
---For example:  
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
---@alias AlignerConstructor fun(self : ViewBuilderInstance, properties : AlignmentRackViewProperties) : renoise.Views.Aligner

---You can add nested child views by including them in the constructor table.  
---For example:  
---```lua
---vb:space {
---   vb:text {
---     text = "Text1"
---   },
---   vb:text {
---     text = "Text2"
---   }
---}
---```
---@see renoise.Views.View
---@alias SpaceConstructor fun(self : ViewBuilderInstance, properties : ViewProperties) : renoise.Views.View

---@type RackConstructor
function ViewBuilderInstance:column(properties) end

---@type RackConstructor
function ViewBuilderInstance:row(properties) end

---@type AlignerConstructor
function ViewBuilderInstance:horizontal_aligner(properties) end

---@type AlignerConstructor
function ViewBuilderInstance:vertical_aligner(properties) end

---@type SpaceConstructor
function ViewBuilderInstance:space(properties) end

---@see renoise.Views.Text
---@param properties TextViewProperties
---@return renoise.Views.Text
function ViewBuilderInstance:text(properties) end

---@see renoise.Views.MultiLineText
---@param properties MultilineTextViewProperties
---@return renoise.Views.MultiLineText
function ViewBuilderInstance:multiline_text(properties) end

---@see renoise.Views.TextField
---@param properties TextFieldProperties
---@return renoise.Views.TextField
function ViewBuilderInstance:textfield(properties) end

---@see renoise.Views.MultiLineTextField
---@param properties MultilineTextFieldProperties
---@return renoise.Views.MultiLineTextField
function ViewBuilderInstance:multiline_textfield(properties) end

---@see renoise.Views.Bitmap
---@param properties BitmapViewProperties
---@return renoise.Views.Bitmap
function ViewBuilderInstance:bitmap(properties) end

---@see renoise.Views.Button
---@param properties ButtonProperties
---@return renoise.Views.Button
function ViewBuilderInstance:button(properties) end

---@see renoise.Views.CheckBox
---@param properties CheckBoxProperties
---@return renoise.Views.CheckBox
function ViewBuilderInstance:checkbox(properties) end

---@see renoise.Views.Switch
---@param properties ButtonSwitchProperties
---@return renoise.Views.Switch
function ViewBuilderInstance:switch(properties) end

---@see renoise.Views.Popup
---@param properties PopUpMenuProperties
---@return renoise.Views.Popup
function ViewBuilderInstance:popup(properties) end

---@see renoise.Views.Chooser
---@param properties ChooserProperties
---@return renoise.Views.Chooser
function ViewBuilderInstance:chooser(properties) end

---@see renoise.Views.ValueBox
---@param properties ValueBoxProperties
---@return renoise.Views.ValueBox
function ViewBuilderInstance:valuebox(properties) end

---@see renoise.Views.Value
---@param properties ValueViewProperties
---@return renoise.Views.Value
function ViewBuilderInstance:value(properties) end

---@see renoise.Views.ValueField
---@param properties ValueFieldProperties
---@return renoise.Views.ValueField
function ViewBuilderInstance:valuefield(properties) end

---@see renoise.Views.Slider
---@param properties SliderProperties
---@return renoise.Views.Slider
function ViewBuilderInstance:slider(properties) end

---@see renoise.Views.MiniSlider
---@param properties MiniSliderProperties
---@return renoise.Views.MiniSlider
function ViewBuilderInstance:minislider(properties) end

---@see renoise.Views.RotaryEncoder
---@param properties RotaryEncoderProperties
---@return renoise.Views.RotaryEncoder
function ViewBuilderInstance:rotary(properties) end

---@see renoise.Views.XYPad
---@param properties XYPadProperties
---@return renoise.Views.XYPad
function ViewBuilderInstance:xypad(properties) end
