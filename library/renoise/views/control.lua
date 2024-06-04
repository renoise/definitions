---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------

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
---@alias ControlMidiMappingString string

--------------------------------------------------------------------------------

---Bind the view's value to a renoise.Document.ObservableBoolean object.
---Automatically keep them in sync.
---The view will change the Observable value as soon as its value changes
---and change the view's value as soon as the Observable's value changes.
---Notifiers can be added to either the view or the Observable object.
---@alias ViewBooleanObservable renoise.Document.ObservableBoolean

---Bind the view's value to a renoise.Document.ObservableNumber object.
---Automatically keep them in sync.
---The view will change the Observable value as soon as its value changes
---and change the view's value as soon as the Observable's value changes.
---Notifiers can be added to either the view or the Observable object.
---@alias ViewNumberObservable renoise.Document.ObservableNumber

---Bind the view's value to a renoise.Document.ObservableString object.
---Automatically keep them in sync.
---The view will change the Observable value as soon as its value changes
---and change the view's value as soon as the Observable's value changes.
---Notifiers can be added to either the view or the Observable object.
---@alias ViewStringObservable renoise.Document.ObservableString

---Bind the view's value to a renoise.Document.ObservableStringList object.
---Automatically keep them in sync.
---The view will change the Observable value as soon as its value changes
---and change the view's value as soon as the Observable's value changes.
---Notifiers can be added to either the view or the Observable object.
---@alias ViewStringListObservable renoise.Document.ObservableStringList

--------------------------------------------------------------------------------
---## renoise.Views.Control

---Control is the base class for all views which let the user change a value or
---some "state" from the UI.
---@class renoise.Views.Control : renoise.Views.View
---@field active ControlActive
---@field midi_mapping ControlMidiMappingString
local Control = {}

--------------------------------------------------------------------------------

---@class ControlProperties : ViewProperties
---@field active ControlActive?
---@field midi_mapping ControlMidiMappingString?
