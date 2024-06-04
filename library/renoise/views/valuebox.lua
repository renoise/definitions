---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------

---The minimum value that can be set using the view
---* Default: 0
---@alias ValueBoxMinValue number
---The maximum value that can be set using the view
---* Default: 100
---@alias ValueBoxMaxValue number

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

--------------------------------------------------------------------------------
---## renoise.Views.ValueBox

---A box with arrow buttons and a text field that can be edited by the user.
---Allows showing and editing natural numbers in a custom range.
---```text
--- +---+-------+
--- |<|>|  12   |
--- +---+-------+
---```
---@class renoise.Views.ValueBox : renoise.Views.Control
---@field min ValueBoxMinValue
---@field max ValueBoxMaxValue
---@field steps SliderStepAmounts
---@field value SliderNumberValue
local ValueBox = {}

---### functions

---Add value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function ValueBox:add_notifier(notifier) end

---Remove value change notifier
---@param notifier NumberValueNotifierFunction
---@overload fun(self, notifier: NumberValueNotifierMethod1)
---@overload fun(self, notifier: NumberValueNotifierMethod2)
function ValueBox:remove_notifier(notifier) end

--------------------------------------------------------------------------------

---@class ValueBoxProperties : ControlProperties
---@field bind ViewNumberObservable?
---@field value SliderNumberValue?
---@field notifier NumberValueNotifier?
---@field min ValueBoxMinValue?
---@field max ValueBoxMaxValue?
---@field steps SliderStepAmounts?
---@field tostring PairedShowNumberAsString?
---@field tonumber PairedParseStringAsNumber?
