---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------

---Default 0. Minimum offset value.
---@alias ScrollbarMin integer
---Default 100. Maximum offset value.
---@alias ScrollbarMax integer
---Default 0. Offset value in range `min to max - pagestep`.
---@alias ScrollbarValue integer

---Default 100. Size of the currently visible area.
---@alias ScrollbarPagestep integer

---Default: false. When true, view gets automatically hidden when no scrolling is needed
---@alias ScrollbarAutoHide boolean

--------------------------------------------------------------------------------
---## renoise.Views.ScrollBar

---A special slider alike control to scroll through some content.
---
---`min` and `max` define to the scrollable area's range. `pagesize` is the
---currently visible area within that range and `values` is the offset from
--`min` to `max - pagestep` within the whole scrollable area:
---
---```text
---min   offset                     max
--- |      [xxxxxxxxxxxxxx]          |
---        <---pagestep--->
--- <---------scroll-area------------>
---```
---
---Note that the *minimum offset value* is `min` and the *maximum offset
---value* is `max - pagestep`.
---
---A scrollbar can be horizontal or vertical. It will flip its orientation
---according to the set width and height. By default it's horizontal.
---@class renoise.Views.ScrollBar : renoise.Views.Control
---@field min ScrollbarMin
---@field max ScrollbarMax
---@field value ScrollbarValue
---@field pagestep ScrollbarPagestep
---@field background ViewBackgroundStyle
---@field autohide ScrollbarAutoHide
local ScrollBar = {}

---### functions

---Add offset value change notifier
---@param notifier IntegerValueNotifierFunction
---@overload fun(self, notifier: IntegerValueNotifierMethod1)
---@overload fun(self, notifier: IntegerValueNotifierMethod2)
function ScrollBar:add_notifier(notifier) end

---Remove offset value change notifier
---@param notifier IntegerValueNotifierFunction
---@overload fun(self, notifier: IntegerValueNotifierMethod1)
---@overload fun(self, notifier: IntegerValueNotifierMethod2)
function ScrollBar:remove_notifier(notifier) end

--------------------------------------------------------------------------------

---@class ScrollBarProperties : ControlProperties
---@field bind ViewNumberObservable?
---@field value ScrollbarValue?
---@field notifier NumberValueNotifier?
---@field min ScrollbarMin?
---@field max ScrollbarMax?
---@field pagestep ScrollbarPagestep?
---@field background ViewBackgroundStyle?
---@field autohide ScrollbarAutoHide?
