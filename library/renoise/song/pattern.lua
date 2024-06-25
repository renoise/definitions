---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Pattern

---### constants

---Maximum number of lines that can be present in a pattern.
renoise.Pattern.MAX_NUMBER_OF_LINES = 512

---### properties

---@class renoise.Pattern
---
---Quickly check if any track in a pattern has some non empty pattern lines.
---This does not look at track automation.
---@field is_empty boolean
---
---Name of the pattern, as visible in the pattern sequencer.
---@field name string
---@field name_observable renoise.Document.Observable
---
---Number of lines the pattern currently has. 64 by default. Max is
---renoise.Pattern.MAX_NUMBER_OF_LINES, min is 1.
---@field number_of_lines integer
---@field number_of_lines_observable renoise.Document.Observable
---
---**READ-ONLY** Access to the pattern tracks. Each pattern has
---#renoise.song().tracks amount of tracks.
---@field tracks renoise.PatternTrack[]
renoise.Pattern = {}

---### functions

---Deletes all lines & automation.
function renoise.Pattern:clear() end

---Copy contents from other patterns, including automation, when possible.
---@param other renoise.Pattern
function renoise.Pattern:copy_from(other) end

---Access to a single pattern track by index. Use properties 'tracks' to
---iterate over all tracks and to query the track count.
---@param index integer
---@return renoise.PatternTrack
function renoise.Pattern:track(index) end

---@alias PatternLineChangeCallback fun(pos: PatternLinePosition)
---@alias PatternLineChangeCallbackWithContext fun(obj: table|userdata, pos: PatternLinePosition)

---Check/add/remove notifier functions or methods, which are called by Renoise
---as soon as any of the pattern's lines have changed.
---The notifiers are called as soon as a new line is added, an existing line
---is cleared, or existing lines are somehow changed (notes, effects, anything)
--
---A single argument is passed to the notifier function: "pos", a table with the
---fields "pattern", "track" and "line", which defines where the change has
---happened.
---### example:
---```lua
---function my_pattern_line_notifier(pos)
---  -- check pos.pattern, pos.track, pos.line (all are indices)
---end
---```
---Please be gentle with these notifiers, don't do too much stuff in there.
---Ideally just set a flag like "pattern_dirty" which then gets picked up by
---an app_idle notifier: The danger here is that line change notifiers can
---be called hundreds of times when, for example, simply clearing a pattern.
--
---If you are only interested in changes that are made to the currently edited
---pattern, dynamically attach and detach to the selected pattern's line
---notifiers by listening to "renoise.song().selected_pattern_observable".
---@param func PatternLineChangeCallbackWithContext
---@param obj table|userdata
---@return boolean
---@overload fun(self, func: PatternLineChangeCallback): boolean
function renoise.Pattern:has_line_notifier(func, obj) end

---@param func PatternLineChangeCallbackWithContext
---@param obj table|userdata
---@overload fun(self, func: PatternLineChangeCallback): boolean
function renoise.Pattern:add_line_notifier(func, obj) end

---@param func PatternLineChangeCallbackWithContext
---@param obj table|userdata
---@overload fun(self, func: PatternLineChangeCallback): boolean
function renoise.Pattern:remove_line_notifier(func, obj) end

---Same as `line_notifier`, but the notifier only fires when the user
---added, changed or deleted a line with the computer or MIDI keyboard.
---@param func PatternLineChangeCallbackWithContext
---@param obj table|userdata
---@overload fun(self, func: PatternLineChangeCallback): boolean
---@return boolean
function renoise.Pattern:has_line_edited_notifier(func, obj) end

---@param func PatternLineChangeCallbackWithContext
---@param obj table|userdata
---@overload fun(self, func: PatternLineChangeCallback): boolean
function renoise.Pattern:add_line_edited_notifier(func, obj) end

---@param func PatternLineChangeCallbackWithContext
---@param obj table|userdata
---@overload fun(self, func: PatternLineChangeCallback): boolean
function renoise.Pattern:remove_line_edited_notifier(func, obj) end

---### operators

---Compares all tracks and lines, including automation.
---operator==(pattern, pattern): boolean
---operator~=(pattern, pattern): boolean
