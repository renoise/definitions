---@meta
---Do not try to execute this file. It's just a type definition file.
---
---This reference lists all available Lua functions and classes that control
---Renoise's pattern track document.
---
---Please read the `Introduction.md` in the Renoise scripting Documentation
---folder first to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.PatternTrack

---@class renoise.PatternTrack
renoise.PatternTrack = {}

---### properties

---@class renoise.PatternTrack
---
---Ghosting (aliases)
---@field is_alias boolean **READ-ONLY**
---
---Pattern index the pattern track is aliased or 0 when its not aliased.
---@field alias_pattern_index number index or 0 when no alias is present
---@field alias_pattern_index_observable renoise.Document.Observable
----
---@field color RGBColor? slot color of the pattern in the matrix, nil when no slot color is set
---@field color_observable renoise.Document.Observable
---
---Returns true when all the track lines are empty. Does not look at automation.
---@field is_empty boolean
---@field is_empty_observable renoise.Document.Observable
---
---**READ-ONLY** Get all lines in range [1, number_of_lines_in_pattern].
---Use `renoise.Pattern:add/remove_line_notifier` for change notifications.
---@field lines renoise.PatternLine[]
---
---Automation.
---@field automation renoise.PatternTrackAutomation[]
---@field automation_observable renoise.Document.ObservableList

---### functions

---Deletes all lines & automation.
function renoise.PatternTrack:clear() end

---Copy contents from other pattern tracks, including automation when possible.
---@param other renoise.PatternTrack
function renoise.PatternTrack:copy_from(other) end

---Access to a single line by index. Line must be [1-MAX_NUMBER_OF_LINES]).
---This is a !lot! more efficient than calling the property: lines[index] to
---randomly access lines.
---@param index integer
---@return renoise.PatternLine
function renoise.PatternTrack:line(index) end

---Get a specific line range (index must be [1-Pattern.MAX_NUMBER_OF_LINES])
---@param index_from integer
---@param index_to integer
---@return renoise.PatternLine[]
function renoise.PatternTrack:lines_in_range(index_from, index_to) end

---Returns the automation for the given device parameter or nil when there is
---none.
---@param parameter renoise.DeviceParameter
---@return renoise.PatternTrackAutomation|nil
function renoise.PatternTrack:find_automation(parameter) end

---Creates a new automation for the given device parameter.
---Fires an error when an automation for the given parameter already exists.
---Returns the newly created automation. Passed parameter must be automatable,
---which can be tested with 'parameter.is_automatable'.
---@param parameter renoise.DeviceParameter
---@return renoise.PatternTrackAutomation
function renoise.PatternTrack:create_automation(parameter) end

---Remove an existing automation the given device parameter. Automation
---must exist.
---@param parameter renoise.DeviceParameter
function renoise.PatternTrack:delete_automation(parameter) end

---### operators

---Compares line content and automation. All other properties are ignored.
---operator==(pattern_track, pattern_track): boolean
---operator~=(pattern_track, pattern_trac): boolean

--------------------------------------------------------------------------------
---### renoise.PatternTrackLine

---@deprecated - alias for renoise.PatternLine
---@alias renoise.PatternTrackLine renoise.PatternLine
