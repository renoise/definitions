---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------

---Unique identifier to resolve the view later on in the viewbuilder, 
---e.g. `vb.views.SomeString` or `vb.views["Some String"]`
---View ids must be unique within a single view builder instance. 
---@alias ViewId string

---The dimensions of a view has to be larger than 0.
---For nested views you can also specify relative size
---for example `vb:text { width = "80%"}`. The percentage values are
---relative to the view's parent size and will automatically update on size changes.
---@alias ViewDimension integer|string

---A tooltip text that should be shown for this view on mouse hover.
---* Default: "" (no tip will be shown)
---@alias ViewTooltip string

---Set visible to false to hide a view (make it invisible without removing
---it). Please note that view.visible will also return false when any of its
---parents are invisible (when its implicitly invisible).
---* Default: true
---@alias ViewVisibility boolean

---Setup a background style for the view. 
---@alias ViewBackgroundStyle
---| "invisible" # no background (Default)
---| "plain"     # undecorated, single coloured background
---| "border"    # same as plain, but with a bold nested border
---| "body"      # main "background" style, as used in dialog backgrounds
---| "panel"     # alternative "background" style, beveled
---| "group"     # background for "nested" groups within body

--------------------------------------------------------------------------------

---Event type of a `MouseEvent`.
---@alias MouseEventType
---|"enter"
---|"exit"
---|"move"
---|"down"
---|"up"
---|"double"
---|"drag"
---|"wheel"

---Mouse button of a `MouseEvent` of type "up"|"down"|"double"|"drag".
---@alias MouseEventButton
---|"left"
---|"right"
---|"middle"

---Mouse wheel direction in a `MouseEvent` of type "wheel".
---@alias MouseEventWheelDirection
---|"up"
---|"down"
---|"left"
---|"right"

---Mouse event as passed to a layout view's "mouse_handler" function.
---@class MouseEvent
---Mouse event type. Only enabled types are passed to the handler.
---@field type MouseEventType
---For "up"|"down"|"double"|"drag" events, the mouse button which got pressed,
---nil for all other events.
---@field button MouseEventButton?
---For "wheel" events, the wheel's direction, nil for all other events.
---@field direction MouseEventWheelDirection?
---Mouse cursor position in relative coordinates to the layout.
---@field position { x: number, y: number }
---Currently pressed (held down) keyboard modifier buttons.
---@field modifier_flags { shift: boolean, control: boolean, alt: boolean, meta: boolean }
---Currently pressed (held down) mouse buttons.
---@field button_flags { left: boolean, right: boolean, middle: boolean }
---List of sub views and possible layout subview's subviews, that are located below
---the mouse cursor. In other words: all views that are located below the mouse cursor.
---The list is orderd by containing the top-most visible view first, so you usually will
---need to check the first table entry only.
---
---NB: Only views that got created with the same view builder instance as the layout,
---and only subviews with valid viewbuilder "id"s will show up here!
---@field hover_views { id: string, view: renoise.Views.View }[]

---@alias MouseHandlerNotifierFunction fun(event: MouseEvent): MouseEvent?
---@alias MouseHandlerNotifierMemberFunction fun(self: NotifierMemberContext, event: MouseEvent): MouseEvent?
---@alias MouseHandlerNotifierMethod1 {[1]:NotifierMemberContext, [2]:MouseHandlerNotifierMemberFunction}
---@alias MouseHandlerNotifierMethod2 {[1]:MouseHandlerNotifierMemberFunction, [2]:NotifierMemberContext}
---Optional mouse event handler for a view. return nil when the event got handled
---to stop propagating the event. return the event instance, as passed, to pass it
---to the next view in the view hirarchy.
---@alias MouseHandler MouseHandlerNotifierFunction|MouseHandlerNotifierMethod1|MouseHandlerNotifierMethod2

---The mouse event types that should be passed to your `mouse_handler` function.
---By default: `{ "down", "up", "double" }`
---Avoid adding event types that you don't use, especially "move" events as they do
---create quite some overhead. Also note that when enabling "drag", sub view controls
---can no longer handle drag events, even when you pass back the event in the handler,
---so only enable it when you want to completely override mouse drag behavior of
---*all* your content views.
---@alias MouseEventTypes (MouseEventType[])

--------------------------------------------------------------------------------

---TODO
---inheriting from 'table' is workaround here to allow up casting views to
---other views via e.g. @type or @cast

---View is the base class for all child views. All View properties can be
---applied to any of the following specialized views.
---@class renoise.Views.View : table
---@field visible ViewVisibility
---@field height ViewDimension
---@field tooltip ViewTooltip
---**READ-ONLY** Empty for all controls, for layout views this contains the
---layout child views in the order they got added
---@field views renoise.Views.View[]
local View = {}

---### functions

---Add a new child view to this view.
---@param child renoise.Views.View
function View:add_child(child) end

---Remove a child view from this view.
---@param child renoise.Views.View
function View:remove_child(child) end

--------------------------------------------------------------------------------

--- Base for all View constructor tables in the viewbuilder.
---@class ViewProperties
---@field id ViewId?
---@field width ViewDimension?
---@field height ViewDimension?
---@field visible ViewVisibility?
---@field tooltip ViewTooltip?
