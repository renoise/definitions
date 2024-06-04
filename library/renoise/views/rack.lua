---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

-------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------
---## renoise.Views.Rack

---A Rack has no content on its own. It only stacks child views. Either
---vertically (ViewBuilder.column) or horizontally (ViewBuilder.row). It allows
---you to create view layouts.
---@class renoise.Views.Rack : renoise.Views.View
---@field margin RackMargin
---@field spacing RackSpacing
---@field style ViewBackgroundStyle
---@field uniform RackUniformity
local Rack = {}

-------------------------------------------------------------------------------

---@class RackViewProperties : ViewProperties
---@field margin RackMargin?
---@field spacing RackSpacing?
---@field style ViewBackgroundStyle?
---@field uniform RackUniformity?
