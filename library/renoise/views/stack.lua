---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Views.Stack

---When set to true, the width and height of the stack will be automatically
---calculated and updated from the stack's child views, to ensure all views fit
---into the stack.
---When disabled, the width and height must be set manually.
---* Default: true
---@alias StackAutoSize boolean

---The stack view's optional child views.
---Views can later on also be added and removed dynamically after construction via
---`stack:add_view(child)` and `stack:remove_view(child)`
---@alias StackChildViews renoise.Views.View[]

---A Stack has no content on its own. It only *stacks* it's child views.
---The position of the child views in the stack can be freely set by using
---the `origin` property of the views.
---@class renoise.Views.Stack : renoise.Views.View
---@field autosize StackAutoSize
---@field background ViewBackgroundStyle
local Stack = {}

--------------------------------------------------------------------------------

---@class StackViewProperties : ViewProperties
---@field autosize StackAutoSize?
---@field background ViewBackgroundStyle?
---@field mouse_handler MouseHandler?
---@field mouse_events MouseEventTypes?
---@field views StackChildViews?
