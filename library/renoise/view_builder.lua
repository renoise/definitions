---@meta
---Do not try to execute this file. It's just a type definition file.
---
---This reference lists all "View" related functions in the API. View means
---classes and functions that are used to build custom GUIs; GUIs for your
---scripts in Renoise.
---
---Please read the `Introduction.md` in the Renoise scripting Documentation
---folder first to get an overview about the complete API, and scripting for
---Renoise in general...
---
---For a small tutorial and more details about how to create and use views,
---have a look at the "com.renoise.ExampleToolGUI.xrnx" tool. This tool is
---included in the scripting dev started pack at <http://scripting.renoise.com>
---

--------------------------------------------------------------------------------
---## introduction

--- Currently there are two ways to to create custom views:
---
---Shows a modal dialog with a title, custom content and custom button labels:
---```lua
---renoise.app():show_custom_prompt(
--- title, content_view, {button_labels} [, key_handler_func, key_handler_options])
--- --> [pressed button]
---```
---
---*(and)* Shows a non modal dialog, a floating tool window, with custom
---content:
---```lua
---renoise.app():show_custom_dialog(
--- title, content_view [, key_handler_func, key_handler_options])
--- --> [dialog object]
---```
---
---key_handler_func is optional. When defined, it should point to a function
---with the signature noted below. "key" is a table with the fields:
---```lua
---key = {
---  name,      -- name of the key, like 'esc' or 'a' - always valid
---  modifiers, -- modifier states. 'shift + control' - always valid
---  character, -- character representation of the key or nil
---  note,      -- virtual keyboard piano key value (starting from 0) or nil
---  state,     -- optional (see below) - is the key getting pressed or released?
---  repeated,  -- optional (see below) - true when the key is soft repeated (held down)
---}
---```
---
---The "repeated" field will not be present when 'send_key_repeat' in the key
---handler options is set to false. The "state" field only is present when the
---'send_key_release' in the key handler options is set to true. So by default only
---key presses are send to the key handler.
---
---key_handler_options is an optional table with the fields:
---```lua
---options = {
---  send_key_repeat=true OR false   -- by default true
---  send_key_release=true OR false  -- by default false
---}
---```
---Returned "dialog" is a reference to the dialog the keyhandler is running on.
---
---`function my_keyhandler_func(dialog, key) end`

---When no key handler is specified, the Escape key is used to close the dialog.
---For prompts, the first character of the button labels is used to invoke
---the corresponding button.
---
---When returning the passed key from the key-handler function, the
---key will be passed back to Renoise's key event chain, in order to allow
---processing global Renoise key-bindings from your dialog. This will not work
---for modal dialogs. This also only applies to global shortcuts in Renoise,
---because your dialog will steal the focus from all other Renoise views such as
---the Pattern Editor, etc.

--------------------------------------------------------------------------------
---## renoise.Views

---@class renoise.Views
renoise.Views = {}

--------------------------------------------------------------------------------
---## renoise.Views.View

---@class renoise.Views.View
renoise.Views.View = {}

---### properties

---View is the base class for all child views. All View properties can be
---applied to any of the following specialized views.
---@class renoise.Views.View
---
---Set visible to false to hide a view (make it invisible without removing
---it). Please note that view.visible will also return false when any of its
---parents are invisible (when its implicitly invisible).
---@field visible boolean Default: true
---
---Get/set a view's size. All views must have a size > 0.
---By default > 0: How much exactly depends on the specialized view type.
---Note: in nested view_builder notations you can also specify relative
---sizes, like for example `vb:text { width = "80%"}`. The percentage values are
---relative to the view's parent size and will automatically update on size
---changes.
---@field width number|string
---
---@field height number|string
---
---Get/set a tooltip text that should be shown for this view.
---@field tooltip string Default: "" (no tip will be shown)

---### functions

---Dynamically create view hierarchies.
---@param child renoise.Views.View
function renoise.Views.View:add_child(child) end

---@param child renoise.Views.View
function renoise.Views.View:remove_child(child) end

--------------------------------------------------------------------------------
---## renoise.Views.Control

---@class renoise.Views.Control
renoise.Views.Control = {}

---### properties

---Control is the base class for all views which let the user change a value or
---some "state" from the UI.
---@class renoise.Views.Control : renoise.Views.View
---
---Instead of making a control invisible, you can also make it inactive.
---Deactivated controls will still be shown, and will still show their
---currently assigned values, but will not allow changes. Most controls will
---display as "grayed out" to visualize the deactivated state.
---@field active boolean
---
---When set, the control will be highlighted when Renoise's MIDI mapping dialog
---is open. When clicked, it selects the specified string as a MIDI mapping
---target action. This target acton can either be one of the globally available
---mappings in Renoise, or those that were created by the tool itself.
---Target strings are not verified. When they point to nothing, the mapped MIDI
---message will do nothing and no error is fired.
---@field midi_mapping string

--------------------------------------------------------------------------------
---## renoise.Views.Rack

---@class renoise.Views.Rack
renoise.Views.Rack = {}

---### properties

---@see renoise.ViewBuilder.column
---@see renoise.ViewBuilder.row
---A Rack has no content on its own. It only stacks child views. Either
---vertically (ViewBuilder.column) or horizontally (ViewBuilder.row). It allows
---you to create view layouts.
---
---@class renoise.Views.Rack : renoise.Views.View
---
---Set the "borders" of the rack (left, right, top and bottom inclusively)
---@field margin number Default: 0 (no borders)
---
---Setup the amount stacked child views are separated by (horizontally in
---rows, vertically in columns).
---@field spacing number Default: 0 (no spacing)
---
---Setup a background style for the rack. Available styles are:
---@alias RackStyle
---| "invisible" # no background
---| "plain"     # undecorated, single coloured background
---| "border"    # same as plain, but with a bold nested border
---| "body"      # main "background" style, as used in dialog backgrounds
---| "panel"     # alternative "background" style, beveled
---| "group"     # background for "nested" groups within body
---
---@field style RackStyle Default: "invisible"
---
---When set to true, all child views in the rack are automatically resized to
---the max size of all child views (width in ViewBuilder.column, height in
---ViewBuilder.row). This can be useful to automatically align all sub
---columns/panels to the same size. Resizing is done automatically, as soon
---as a child view size changes or new children are added.
---@field uniform boolean Default: false

--------------------------------------------------------------------------------
---## renoise.Views.Aligner

---@class renoise.Views.Aligner
renoise.Views.Aligner = {}

---### properties

---@see renoise.ViewBuilder.horizontal_aligner
---@see renoise.ViewBuilder.vertical_aligner
---Just like a Rack, the Aligner shows no content on its own. It just aligns
---child views vertically or horizontally. As soon as children are added, the
---Aligner will expand itself to make sure that all children are visible
---(including spacing & margins).
---To make use of modes like "center", you manually have to setup a size that
---is bigger than the sum of the child sizes.
---
---@class renoise.Views.Aligner : renoise.Views.View
---
---Setup "borders" for the aligner (left, right, top and bottom inclusively)
---@field margin number Default: 0 (no borders)
---
---Setup the amount child views are separated by (horizontally in rows,
---vertically in columns).
---@field spacing number Default: 0 (no spacing)
---
---@alias AlignerAlignment
---| "left"       # align from left to right (for horizontal_aligner only)
---| "right"      # align from right to left (for horizontal_aligner only)
---| "top"        # align from top to bottom (for vertical_aligner only)
---| "bottom"     # align from bottom to top (for vertical_aligner only)
---| "center"     # center all views
---| "justify"    # keep outer views at the borders, distribute the rest
---| "distribute" # equally distributes views over the aligners width/height
---
---Default: "left" (for horizontal_aligner) "top" (for vertical_aligner)
---@field mode AlignerAlignment


-----------------------------------------------------------------------------
---## renoise.Views.Text

---@class renoise.Views.Text
renoise.Views.Text = {}

---### properties

---@see renoise.ViewBuilder.text
---Shows a "static" text string. Static just means that its not linked, bound
---to some value and has no notifiers. The text can not be edited by the user.
---Nevertheless you can of course change the text at run-time with the "text"
---property.
---```md
---  Text, Bla 1
---```
---@see renoise.Views.TextField for texts that can be edited by the user.
---@class renoise.Views.Text : renoise.Views.View
---
---Get/set the text that should be displayed. Setting a new text will resize
---the view in order to make the text fully visible (expanding only).
---@field text string Default: ""
---
---Get/set the style that the text should be displayed with.
---@alias FontStyle
---| "normal"
---| "big"
---| "bold"
---| "italic"
---| "mono"
---
---@field font FontStyle Default: "normal"
---
---Get/set the color style the text should be displayed with.
---@alias TextStyle
---| "normal"
---| "strong"
---| "disabled"
---
---@field style TextStyle Default: "normal"
---
---Setup the text's alignment. Applies only when the view's size is larger than
---the needed size to draw the text
---@alias TextAlignment
---| "left"
---| "right"
---| "center"
---
---@field align TextAlignment Default: "left"


--------------------------------------------------------------------------------
---## renoise.Views.MultiLineText

---@class renoise.Views.MultiLineText
renoise.Views.MultiLineText = {}

---### properties

---@see renoise.ViewBuilder.multiline_textfield
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
---
---Get/set the text that should be displayed on a single line. Newlines
---(Windows, Mac or Unix styled newlines) in the text can be used to create
---paragraphs.
---@field text string Default: ""
---
---Get/set an array (table) of text lines, instead of specifying a single text
---line with newline characters like "text" does.
---@field paragraphs string Default: ""
---
---@field font FontStyle
---
---Setup the text view's background:
---@alias TextBackgroundStyle
---| "body"    # simple text color with no background
---| "strong"  # stronger text color with no background
---| "border"  # text on a bordered background
---
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

---@class renoise.Views.TextField
renoise.Views.TextField = {}

---### properties

---@see renoise.ViewBuilder.textfield
---Shows a text string that can be clicked and edited by the user.
---```md
--- +----------------+
--- | Editable Te|xt |
--- +----------------+
---```
---@class renoise.Views.TextField : renoise.Views.View
---
---When false, text is displayed but can not be entered/modified by the user.
---@field active boolean Default: true
---
---The currently shown value / text. The text will not be updated when editing,
---rather only after editing is complete (return is pressed, or focus is lost).
---@field value string Default: ""
---
---Exactly the same as "value"; provided for consistency.
---@field text string Default: ""
---
---Setup the text field's text alignment, when not editing.
---@field align TextAlignment Default: "left"
---
---True when the text field is focused. setting the edit_mode programatically
---will focus the text field or remove the focus (focus the dialog) accordingly.
---@field edit_mode boolean Default: false
---
---Valid in the construction table only: Set up a notifier for text changes.
---@see renoise.Views.TextField.add_notifier
---@see renoise.Views.TextField.remove_notifier
---@field notifier function
---
---Valid in the construction table only: Bind the view's value to a
---renoise.Document.ObservableString object. Will change the Observable
---value as soon as the views value changes, and change the view's value as
---soon as the Observable's value changes - automatically keeps both values
---in sync.
---Notifiers can be added to either the view or the Observable object.
---@field bind renoise.Document.ObservableString?

---### functions

---Add value change (text change) notifier
---@param notifier fun(text : string)
function renoise.Views.TextField:add_notifier(notifier) end

---Remove value change (text change) notifier
---@param notifier fun(text : string)
function renoise.Views.TextField:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Views.MultiLineTextField

---@class renoise.Views.MultiLineTextField
renoise.Views.MultiLineTextField = {}

---### properties

---@see renoise.ViewBuilder.multiline_textfield
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
---
---When false, text is displayed but can not be entered/modified by the user.
---@field active boolean Default: true
---
---The current text as a single line, uses newline characters to specify
---paragraphs.
---@field value string Default: ""
---
---Exactly the same as "value"; provided for consistency.
---@field text string  Default: ""
---
---Get/set a list/table of text lines instead of specifying the newlines as
---characters.
---@field paragraphs string Default: ""
---
---@field font FontStyle  Default: "normal"
---
---@field style TextBackgroundStyle  Default: "border"
---
---Valid in the construction table only: Set up a notifier for text changes.
---@see renoise.Views.MutlilineTextField.add_notifier
---@see renoise.Views.MutlilineTextField.remove_notifier
---@field notifier function
---
---Valid in the construction table only: Bind the view's value to a
---renoise.Document.ObservableStringList object. Will change the Observable
---value as soon as the view's value changes, and change the view's value as
---soon as the Observable's value changes - automatically keeps both values
---in sync.
---Notifiers can be added to either the View or the Observable object.
---@field bind renoise.Document.ObservableStringList?
---
---True when the text field is focused. setting the edit_mode programatically
---will focus the text field or remove the focus (focus the dialog) accordingly.
---@field edit_mode boolean Default: false

---### functions

---Add value change (text change) notifier
---@param notifier fun(text : string)
function renoise.Views.MultiLineTextField:add_notifier(notifier) end

---Remove value change (text change) notifier
---@param notifier fun(text : string)
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

---@class renoise.Views.Bitmap
renoise.Views.Bitmap = {}

---### properties

---@see renoise.ViewBuilder.bitmap
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
---
---Setup how the bitmap should be drawn, recolored. Available modes are:
---@alias View.Bitmap.Mode
---| "plain"        # bitmap is drawn as is, no recoloring is done
---| "transparent"  # same as plain, but black pixels will be fully transparent
---| "button_color" # recolor the bitmap, using the theme's button color
---| "body_color"   # same as 'button_back' but with body text/back color
---| "main_color"   # same as 'button_back' but with main text/back colors
---
---@field mode string Default: "plain"
---
---Bitmap name and path. You should use a relative path that uses  Renoise's
---default resource folder as base (like "Icons/ArrowRight.bmp"). Or specify a
---file relative from your XRNX tool bundle:
---Lets say your tool is called "com.foo.MyTool.xrnx" and you pass
---"MyBitmap.bmp" as the name. Then the bitmap is loaded from
---"PATH_TO/com.foo.MyTool.xrnx/MyBitmap.bmp".
---Supported bitmap file formats are *.bmp, *.png or *.tif (no transparency).
---@field bitmap string
---
---Valid in the construction table only: Set up a click notifier. See
---add_notifier/remove_notifier above.
---@field notifier function
---

---### functions

---Add mouse click notifier
---@param notifier function
function renoise.Views.Bitmap:add_notifier(notifier) end

---Remove mouse click notifier
---@param notifier function
function renoise.Views.Bitmap:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Views.Button

---@class renoise.Views.Button : renoise.Views.Control
renoise.Views.Button = {}

---### properties

---@see renoise.ViewBuilder.button
---A simple button that calls a custom notifier function when clicked.
---Supports text or bitmap labels.
---```md
--- +--------+
--- | Button |
--- +--------+
---```
---@class renoise.Views.Button : renoise.Views.Control
---
---The text label of the button
---@field text string Default: ""
---
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
---@field bitmap string
---
---Table of RGB values like {0xff,0xff,0xff} -> white. When set, the
---unpressed button's background will be drawn in the specified color.
---A text color is automatically selected to make sure its always visible.
---Set color {0,0,0} to enable the theme colors for the button again.
---@field color RGBColor Range: (0-255)
---
---Valid in the construction table only: set up a click notifier.
---@field pressed function
---Valid in the construction table only: set up a click release notifier.
---@field released function
---
---synonymous for 'released'.
---@field notifier function

---### functions

---Add/remove button hit/release notifier functions.
---When a "pressed" notifier is set, the release notifier is guaranteed to be
---called as soon as the mouse is released, either over your button or anywhere
---else. When a "release" notifier is set, it is only called when the mouse
---button is pressed !and! released over your button.
---@param notifier function
function renoise.Views.Button:add_pressed_notifier(notifier) end

---@param notifier function
function renoise.Views.Button:add_released_notifier(notifier) end

---@param notifier function
function renoise.Views.Button:remove_pressed_notifier(notifier) end

---@param notifier function
function renoise.Views.Button:remove_released_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Views.CheckBox

---@class renoise.Views.CheckBox
renoise.Views.CheckBox = {}

---### properties

---@see renoise.ViewBuilder.checkbox
---A single button with a checkbox bitmap, which can be used to toggle
---something on/off.
---```md
--- +----+
--- | _/ |
--- +----+
---```
---@class renoise.Views.CheckBox : renoise.Views.Control
---
---The current state of the checkbox, expressed as boolean.
---@field value boolean Default: false
---
---Valid in the construction table only: Set up a value notifier.
---@field notifier fun(value : boolean)
---
---Valid in the construction table only: Bind the view's value to a
---renoise.Document.ObservableBoolean object. Will change the Observable
---value as soon as the views value changes, and change the view's value as
---soon as the Observable's value changes - automatically keeps both values
---in sync.
---Notifiers can be added to either the view or the Observable object.
---@field bind renoise.Document.ObservableBoolean?

---### functions

---Add value change notifier
---@param notifier fun(enabled : boolean)
function renoise.Views.CheckBox:add_notifier(notifier) end

---Remove value change notifier
---@param notifier fun(enabled : boolean)
function renoise.Views.CheckBox:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Views.Switch

---@class renoise.Views.Switch : renoise.Views.Control
renoise.Views.Switch = {}

---### properties

---@see renoise.ViewBuilder.switch
---A set of horizontally aligned buttons, where only one button can be enabled
---at the same time. Select one of multiple choices, indices.
---```md
--- +-----------+------------+----------+
--- | Button A  | +Button+B+ | Button C |
--- +-----------+------------+----------+
---```
---@class renoise.Views.Switch : renoise.Views.Control
---
---Get/set the currently shown button labels.
---@field items string[] size must be >= 2
---
---Get/set the currently pressed button index.
---@field value integer
---
---Valid in the construction table only: Set up a value notifier.
---@field notifier fun(index : integer)
---
---Valid in the construction table only: Bind the view's value to a
---renoise.Document.ObservableNumber object. Will change the Observable
---value as soon as the views value changes, and change the view's value as
---soon as the Observable's value changes - automatically keeps both values
---in sync.
---Notifiers can be added to either the view or the Observable object.
---@field bind renoise.Document.ObservableNumber?

---### functions

---Add index change notifier
---@param notifier fun(index: integer)
function renoise.Views.Switch:add_notifier(notifier) end

---Remove index change notifier
---@param notifier fun(index: integer)
function renoise.Views.Switch:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Views.Popup

---@class renoise.Views.Popup
renoise.Views.Popup = {}

---### properties

---@see renoise.ViewBuilder.popup
---A drop-down menu which shows the currently selected value when closed.
---When clicked, it pops up a list of all available items.
---```md
--- +--------------++---+
--- | Current Item || ^ |
--- +--------------++---+
---```
---@class renoise.Views.Popup : renoise.Views.Control
---
---Get/set the currently shown items. Item list can be empty, then "None" is
---displayed and the value won't change.
---@field items string[]
---
---Get/set the currently selected item index.
---@field value integer
---
---Valid in the construction table only: Set up a value notifier.
---@field notifier fun(index: integer)
---
---Valid in the construction table only: Bind the view's value to a
---renoise.Document.ObservableNumber object. Will change the Observable
---value as soon as the views value changes, and change the view's value as
---soon as the Observable's value changes - automatically keeps both values
---in sync.
---Notifiers can be added to either the view or the Observable object.
---@field bind renoise.Document.ObservableNumber?

---### functions

---Add index change notifier
---@param notifier fun(index : integer)
function renoise.Views.Popup:add_notifier(notifier) end

---Remove index change notifier
---@param notifier fun(index : integer)
function renoise.Views.Popup:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Views.Chooser

---@class renoise.Views.Chooser
renoise.Views.Chooser = {}

---### properties

---@see renoise.ViewBuilder.chooser
---A radio button like set of vertically stacked items. Only one value can be
---selected at a time.
---```md
--- . Item A
--- o Item B
--- . Item C
---```
---@class renoise.Views.Chooser : renoise.Views.Control
---
---Get/set the currently shown items. Item list size must be >= 2.
---@field items string[]
---
---Get/set the currently selected items index.
---@field value integer
---
---Valid in the construction table only: Set up a value notifier.
---@field notifier fun(index : integer)
---
---Valid in the construction table only: Bind the view's value to a
---renoise.Document.ObservableNumber object. Will change the Observable
---value as soon as the views value changes, and change the view's value as
---soon as the Observable's value changes - automatically keeps both values
---in sync.
---Notifiers can be added to either the view or the Observable object.
---@field bind renoise.Document.ObservableNumber?

---### functions

---Add index change notifier
---@param notifier fun(index : integer)
function renoise.Views.Chooser:add_notifier(notifier) end

---Remove index change notifier
---@param notifier fun(index : integer)
function renoise.Views.Chooser:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Views.ValueBox

---@class renoise.Views.ValueBox
renoise.Views.ValueBox = {}

---### properties

---@see renoise.ViewBuilder.valuebox
---A box with arrow buttons and a text field that can be edited by the user.
---Allows showing and editing natural numbers in a custom range.
---```md
--- +---+-------+
--- |<|>|  12   |
--- +---+-------+
---```
---@class renoise.Views.ValueBox : renoise.Views.Control
---
---Get/set the min value that is expected, allowed.
---@field min number Default: 0
---
---Get/set the max value that is expected, allowed.
---@field max number Default: 100
---
---Get/set inc/dec step amounts when clicking the <> buttons.
---First value is the small step (applied on left clicks), second value is the
---big step (applied on right clicks)
---@field steps number[] <small step, big step>
---
---Get/set the current value
---@field value number
---
---Valid in the construction table only: Setup custom rules on how the number
---should be displayed. Both 'tostring' and  'tonumber' must be set, or neither.
---If none are set, a default string/number conversion is done, which
---simply reads/writes the number as integer value.
---
---When defined, 'tostring' must be a function with one parameter, the
---conversion procedure, and must return a string or nil.
---'tonumber' must be a function with one parameter, also the conversion
---procedure, and return a a number or nil. When returning nil, no conversion is
---done and the value is not changed.
---
---Note: when any of the callbacks fail with an error, both will be disabled
---to avoid a flood of error messages.
---@field tostring fun(value : number) : string?
---
---@field tonumber fun(value : string) : number?
---
---Valid in the construction table only: Set up a value notifier.
---@field notifier fun(value : number)
---
---Valid in the construction table only: Bind the view's value to a
---renoise.Document.ObservableNumber object. Will change the Observable
---value as soon as the views value changes, and change the view's value as
---soon as the Observable's value changes - automatically keeps both values
---in sync.
---Notifiers can be added to either the view or the Observable object.
---@field bind renoise.Document.ObservableNumber?

---### functions

---Add value change notifier
---@param notifier fun(value : number)
function renoise.Views.ValueBox:add_notifier(notifier) end

---Remove value change notifier
---@param notifier fun(value : number)
function renoise.Views.ValueBox:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Views.Value

---@class renoise.Views.Value
renoise.Views.Value = {}

---### properties

---@see renoise.ViewBuilder.value
---A static text view. Shows a string representation of a number and
---allows custom "number to string" conversion.
---@see renoise.Views.ValueField for a value text field that can be edited by the user.
---```md
--- +---+-------+
--- | 12.1 dB   |
--- +---+-------+
---```
---@class renoise.Views.Value : renoise.Views.View
---
---Get/set the current value.
---@field value number
---
---@field font FontStyle Default: "normal"
---
---@field align TextAlignment Default: "left"
---
---Valid in the construction table only: Setup a custom rule on how the
---number should be displayed. When defined, 'tostring' must be a function
---with one parameter, the conversion procedure, and must return a string
---or nil.
---
---Note: When the callback fails with an error, it will be disabled to avoid
---a flood of error messages.
---@field tostring fun(input : number) : string?
---
---Valid in the construction table only: Set up a value notifier.
---@field notifier fun(input : number)
---
---Valid in the construction table only: Bind the views value to a
---renoise.Document.ObservableNumber object. Will change the Observable
---value as soon as the views value changes, and change the view's value as
---soon as the Observable's value changes - automatically keeps both values
---in sync.
---Notifiers can be added to either the view or the Observable object.
---@field bind renoise.Document.ObservableNumber?

---### functions

---Add value change notifier
---@param notifier fun(value : number)
function renoise.Views.Value:add_notifier(notifier) end

---Remove value change notifier
---@param notifier fun(value : number)
function renoise.Views.Value:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Views.ValueField

---@class renoise.Views.ValueField
renoise.Views.ValueField = {}

---### properties

---@see renoise.ViewBuilder.valuefield
---A text view, which shows a string representation of a number and allows
---custom "number to string" conversion. The value's text can be edited by the
---user.
---```lua
--- +---+-------+
--- | 12.1 dB   |
--- +---+-------+
---```
---@class renoise.Views.ValueField : renoise.Views.Control
---
---Get/set the min value that is expected, allowed.
---@field min number Default: 0.0
---
---Get/set the max value that is expected, allowed.
---@field max number Default: 1.0
---
---Get/set the current value.
---@field value number
---
---Setup the text alignment.
---@field align TextAlignment Default: "left"
---
---Valid in the construction table only: setup custom rules on how the number
---should be displayed. Both, 'tostring' and  'tonumber' must be set, or none
---of them. If none are set, a default string/number conversion is done, which
---simply shows the number with 3 digits after the decimal point.
---
---When defined, 'tostring' must be a function with one parameter, the to be
---converted number, and must return a string or nil.
---'tonumber' must be a function with one parameter and gets the to be
---converted string passed, returning a a number or nil. When returning nil,
---no conversion will be done and the value is not changed.
---
---Note: when any of the callbacks fail with an error, both will be disabled
---to avoid a flood of error messages.
---@field tostring fun(input : number) : string?
---
---@field tonumber fun(input : string) : number?
---
---Valid in the construction table only: Set up a value notifier function.
---@field notifier fun(input : number)
---
---Valid in the construction table only: Bind the view's value to a
---renoise.Document.ObservableNumber object. Will change the Observable
---value as soon as the views value changes, and change the view's value as
---soon as the Observable's value changes - automatically keeps both values
---in sync.
---Notifiers can be added to either the view or the Observable object.
---@field bind renoise.Document.ObservableNumber?

---### functions

---Add value change notifier
---@param notifier fun(value : number)
function renoise.Views.ValueField:add_notifier(notifier) end

---Remove value change notifier
---@param notifier fun(value : number)
function renoise.Views.ValueField:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Views.Slider

---@class renoise.Views.Slider
renoise.Views.Slider = {}

---### properties

---@see renoise.ViewBuilder.slider
---A slider with arrow buttons, which shows and allows editing of values in a
---custom range. A slider can be horizontal or vertical; will flip its
---orientation according to the set width and height. By default horizontal.
---```md
--- +---+---------------+
--- |<|>| --------[]    |
--- +---+---------------+
---```
---@class renoise.Views.Slider : renoise.Views.Control
---
---Get/set the min value that is expected, allowed.
---@field min number Default: 0.0
---
---Get/set the max value that is expected, allowed.
---@field max number Default: 1.0
---
---Get/set inc/dec step amounts when clicking the <> buttons.
---First value is the small step (applied on left clicks), second value is the
---big step (applied on right clicks)
---@field steps number[] <small step, big step>
---
---Get/set the default value (applied on double-click).
---@field default number
---
---Get/set the current value.
---@field value number
---
---Valid in the construction table only: Set up a value notifier function.
---@field notifier fun(input : number)
---
---Valid in the construction table only: Bind the view's value to a
---renoise.Document.ObservableNumber object. Will change the Observable
---value as soon as the views value changes, and change the view's value as
---soon as the Observable's value changes - automatically keeps both values
---in sync.
---Notifiers can be added to either the view or the Observable object.
---@field bind renoise.Document.ObservableNumber?

---### functions

---Add value change notifier
---@param notifier fun(value : number)
function renoise.Views.Slider:add_notifier(notifier) end

---Remove value change notifier
---@param notifier fun(value : number)
function renoise.Views.Slider:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Views.MiniSlider

---@class renoise.Views.MiniSlider
renoise.Views.MiniSlider = {}

---### properties

---@see renoise.ViewBuilder.minislider
---Same as a slider, but without arrow buttons and a really tiny height. Just
---like the slider, a mini slider can be horizontal or vertical. It will flip
---its orientation according to the set width and height. By default horizontal.
---```md
--- --------[]
---```
---@class renoise.Views.MiniSlider : renoise.Views.Control
---
---Get/set the min value that is expected, allowed.
---@field min number Default: 0.0
---
---Get/set the max value that is expected, allowed.
---@field max number Default: 1.0
---
---Get/set the default value (applied on double-click).
---@field default number
---
---Get/set the current value.
---@field value number
---
---Valid in the construction table only: Set up a value notifier.
---@field notifier fun(input : number)
---
---Valid in the construction table only: Bind the view's value to a
---renoise.Document.ObservableNumber object. Will change the Observable
---value as soon as the views value changes, and change the view's value as
---soon as the Observable's value changes - automatically keeps both values
---in sync.
---Notifiers can be added to either the view or the Observable object.
---@field bind renoise.Document.ObservableNumber?

---### functions

---Add value change notifier
---@param notifier fun(value: number)
function renoise.Views.MiniSlider:add_notifier(notifier) end

---Remove value change notifier
---@param notifier fun(value: number)
function renoise.Views.MiniSlider:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Views.RotaryEncoder

---@class renoise.Views.RotaryEncoder
renoise.Views.RotaryEncoder = {}

---### properties

---@see renoise.ViewBuilder.rotary
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
---
---Get/set the min value that is expected, allowed.
---@field min number Default: 0.0
---
---Get/set the max value that is expected, allowed.
---@field max number Default: 1.0.
---
---Get/set the default value (applied on double-click).
---@field default number
---
---Get/set the current value.
---@field value number
---
---Valid in the construction table only: Set up a value notifier function.
---@field notifier fun(input : number)
---
---Valid in the construction table only: Bind the view's value to a
---renoise.Document.ObservableNumber object. Will change the Observable
---value as soon as the view's value changes, and change the view's value as
---soon as the Observable's value changes - automatically keeps both values
---in sync.
---Notifiers can be added to either the view or the Observable object.
---@field bind renoise.Document.ObservableNumber?

---### functions

---Add value change notifier
---@param notifier fun(value : number)
function renoise.Views.RotaryEncoder:add_notifier(notifier) end

---Remove value change notifier
---@param notifier fun(value : number)
function renoise.Views.RotaryEncoder:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Views.XYPad

---@class renoise.Views.XYPad
renoise.Views.XYPad = {}

---### properties

---@see renoise.ViewBuilder.xypad
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
---
---@class XYPadValues
---@field x number
---@field y number
---
---Get/set a table of allowed min values.
---@field min XYPadValues Default: {x: 0.0, y: 0.0}
---
---Get/set a table of allowed maxvalues.
---@field max XYPadValues Default: {x: 1.0, y: 1.0}
---
---Get/set the pad's current value in a table.
---@field value XYPadValues
---
---When snapback is enabled an XY table is returned, else nil. To enable
---snapback, pass an XY table with desired values. Pass nil or an empty table
---to disable snapback.
---When snapback is enabled, the pad will revert its values to the specified
---snapback values as soon as the mouse button is released in the pad. When
---disabled, releasing the mouse button will not change the value.
---@field snapback XYPadValues?
---
---Valid in the construction table only: Set up a value notifier function.
---@field notifier fun( input : XYPadValues)
---
---Valid in the construction table only: Bind the view's value to a pair of
---renoise.Document.ObservableNumber objects. Will change the Observable
---values as soon as the views value changes, and change the view's values as
---soon as the Observable's value changes - automatically keeps both values
---in sync.
---Notifiers can be added to either the view or the Observable object.
---Just like in the other XYPad properties, a table with the fields X and Y
---is expected here and not a single value. So you have to bind two
---ObservableNumber object to the pad.
---@field bind { x : renoise.Document.ObservableNumber, y : renoise.Document.ObservableNumber }?

---### functions

---Add value change notifier
---@param notifier fun(values : XYPadValues)
function renoise.Views.XYPad:add_notifier(notifier) end

---Remove value change notifier
---@param notifier fun(values : XYPadValues)
function renoise.Views.XYPad:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.ViewBuilder

---@class renoise.ViewBuilder
renoise.ViewBuilder = {}

---### constants

---Default sizes for views and view layouts. Should be used instead of magic
---numbers, also useful to inherit global changes from the main app.
renoise.ViewBuilder.DEFAULT_CONTROL_MARGIN = 4
renoise.ViewBuilder.DEFAULT_CONTROL_SPACING = 2
renoise.ViewBuilder.DEFAULT_CONTROL_HEIGHT = 18
renoise.ViewBuilder.DEFAULT_MINI_CONTROL_HEIGHT = 14
renoise.ViewBuilder.DEFAULT_DIALOG_MARGIN = 8
renoise.ViewBuilder.DEFAULT_DIALOG_SPACING = 8
renoise.ViewBuilder.DEFAULT_DIALOG_BUTTON_HEIGHT = 22

---### properties

---Class which is used to construct new views. All view properties, as listed
---above, can optionally be in-lined in a passed construction table:
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
---* notifier = some_function or notifier = {some_obj, some_function} to
---  register value change notifiers in controls (views which represent values)
---
---* bind = a_document_value (Observable) to bind a view's value directly
---  to an Observable object. Notifiers can be added to the Observable or
---  the view. After binding a value to a view, the view will automatically
---  update its value as soon as the Observable's value changes, and the
---  Observable's value will automatically be updated as soon as the view's
---  value changes.
---  See "Renoise.Document.API.lua" for more general info about Documents &
---  Observables.
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
---@class renoise.ViewBuilder
---
---Construct a new view builder object.
---@overload fun():renoise.ViewBuilder
---
---Table of views, which got registered via the "id" property
---View id is the table key, the table's value is the view's object.
---
---### example
---```lua
---vb:text{ id="my_view", text="some_text"}
---vb.views.my_view.visible = false _(or)_
---vb.views["my_view"].visible = false
---```
---@field views table<string, renoise.Views.View>

---### functions

---Construct a new viewbuilder instance.
---@return renoise.ViewBuilder
function renoise.ViewBuilder() end

---{ Rack Properties and/or child views }
---@param properties renoise.Views.Rack?
---@return renoise.Views.Rack rack
function renoise.ViewBuilder:column(properties) end

---{ Rack Properties and/or child views }
---@param properties renoise.Views.Rack?
---@return renoise.Views.Rack rack
function renoise.ViewBuilder:row(properties) end

---{ Aligner Properties and/or child views }
---@param properties renoise.Views.Aligner?
---@return renoise.Views.Aligner aligner
function renoise.ViewBuilder:horizontal_aligner(properties) end

---{ Aligner Properties and/or child views }
---@param properties renoise.Views.Aligner?
---@return renoise.Views.Aligner aligner
function renoise.ViewBuilder:vertical_aligner(properties) end

---{ View Properties and/or child views }
---@param properties renoise.Views.View?
---@return renoise.Views.View view
function renoise.ViewBuilder:space(properties) end

---{ Text Properties }
---@param properties renoise.Views.Text?
---@return renoise.Views.Text text
function renoise.ViewBuilder:text(properties) end

---{ MultiLineText Properties }
---@param properties renoise.Views.MultiLineText?
---@return renoise.Views.MultiLineText multilinetext
function renoise.ViewBuilder:multiline_text(properties) end

---{ TextField Properties }
---@param properties renoise.Views.TextField?
---@return renoise.Views.TextField textfield
function renoise.ViewBuilder:textfield(properties) end

---{ MultiLineText Properties }
---@param properties renoise.Views.MultiLineTextField?
---@return renoise.Views.MultiLineTextField multilinetextfield
function renoise.ViewBuilder:multiline_textfield(properties) end

---{ Bitmap Properties }
---@param properties renoise.Views.Bitmap?
---@return renoise.Views.Bitmap bitmap
function renoise.ViewBuilder:bitmap(properties) end

---{ Button Properties }
---@param properties renoise.Views.Button?
---@return renoise.Views.Button button
function renoise.ViewBuilder:button(properties) end

---{ Rack Properties }
---@param properties renoise.Views.CheckBox?
---@return renoise.Views.CheckBox checkbox
function renoise.ViewBuilder:checkbox(properties) end

---{ Switch Properties }
---@param properties renoise.Views.Switch?
---@return renoise.Views.Switch switch
function renoise.ViewBuilder:switch(properties) end

---{ Popup Properties }
---@param properties renoise.Views.Popup?
---@return renoise.Views.Popup popup
function renoise.ViewBuilder:popup(properties) end

---{ Chooser Properties }
---@param properties renoise.Views.Chooser?
---@return renoise.Views.Chooser chooser
function renoise.ViewBuilder:chooser(properties) end

---{ ValueBox Properties }
---@param properties renoise.Views.ValueBox?
---@return renoise.Views.ValueBox valuebox
function renoise.ViewBuilder:valuebox(properties) end

---{ Value Properties }
---@param properties renoise.Views.Value?
---@return renoise.Views.Value value
function renoise.ViewBuilder:value(properties) end

---{ ValueField Properties }
---@param properties renoise.Views.ValueField?
---@return renoise.Views.ValueField valuefield
function renoise.ViewBuilder:valuefield(properties) end

---{ Slider Properties }
---@param properties renoise.Views.Slider?
---@return renoise.Views.Slider slider
function renoise.ViewBuilder:slider(properties) end

---{ MiniSlider Properties }
---@param properties renoise.Views.MiniSlider?
---@return renoise.Views.MiniSlider minislider
function renoise.ViewBuilder:minislider(properties) end

---{ RotaryEncoder Properties }
---@param properties renoise.Views.RotaryEncoder?
---@return renoise.Views.RotaryEncoder rotaryencoder
function renoise.ViewBuilder:rotary(properties) end

---{ XYPad Properties }
---@param properties renoise.Views.XYPad?
---@return renoise.Views.XYPad xypad
function renoise.ViewBuilder:xypad(properties) end
