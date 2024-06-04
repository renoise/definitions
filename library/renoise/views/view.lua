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

---TODO
---inheriting from 'table' is workaround here to allow up casting views to
---other views via e.g. @type or @cast

---View is the base class for all child views. All View properties can be
---applied to any of the following specialized views.
---@class renoise.Views.View : table
---@field visible ViewVisibility
---@field width ViewDimension
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
