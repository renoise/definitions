---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.PatternTrackAutomation

---Graphical automation of a device parameter within a pattern track.
---
---General remarks: Automation "time" is specified in lines + optional 1/256
---line fraction for the sub line grid. The sub line grid has 256 units per
---line. All times are internally quantized to this sub line grid.
---For example a time of 1.5 means: line 1 with a note column delay of 128
---@class renoise.PatternTrackAutomation
renoise.PatternTrackAutomation = {}

---### constants

---@enum renoise.PatternTrackAutomation.Playmode
renoise.PatternTrackAutomation = {
  PLAYMODE_POINTS = 1,
  PLAYMODE_LINES = 2,
  PLAYMODE_CURVES = 3
}

---### properties

---Single point within a pattern track automation envelope.
---@class EnvelopePoint
---Automation point's time in pattern lines [1 - NUM_LINES_IN_PATTERN].
---@field time number
---Automation point value [0 - 1.0]
---@field value number
---Automation point scaling. Used in 'lines' playback mode only - 0.0 is linear.
---@field scaling number

---@class renoise.PatternTrackAutomation
---
---Destination device. Can in some rare circumstances be nil, i.e. when
---a device or track is about to be deleted.
---@field dest_device renoise.AudioDevice|nil
---
---Destination device's parameter. Can in some rare circumstances be nil,
---i.e. when a device or track is about to be deleted.
---@field dest_parameter renoise.DeviceParameter|nil
---
---play-mode (interpolation mode).
---@field playmode renoise.PatternTrackAutomation.Playmode
---@field playmode_observable renoise.Document.Observable
---
---**READ-ONLY** Max length (time in lines) of the automation.
---Will always fit the patterns length.
---@field length integer [1 - NUM_LINES_IN_PATTERN]
---
---Selection range as visible in the automation editor. always valid.
---returns the automation range no selection is present in the UI.
---@field selection_start integer [1 - automation.length + 1]
---@field selection_start_observable renoise.Document.Observable
---@field selection_end integer [1 - automation.length + 1]
---@field selection_end_observable renoise.Document.Observable
---
---Get or set selection range. when setting an empty table, the existing
---selection, if any, will be cleared.
---array of two numbers [] OR [1 - automation.length + 1]
---@field selection_range number[]
---@field selection_range_observable renoise.Document.Observable
---
---Get all points of the automation. When setting a new list of points,
---items may be unsorted by time, but there may not be multiple points
---for the same time. Returns a copy of the list, so changing
---`points[1].value` will not do anything. Instead, change them via
---`points = { modified_points }`.
---@field points EnvelopePoint[]
---@field points_observable renoise.Document.ObservableList

---### functions

---Removes all points from the automation. Will not delete the automation
---from tracks[]:automation, instead the resulting automation will not do
---anything at all.
function renoise.PatternTrackAutomation:clear() end

---Remove all existing points in the given [from, to) time range from the
---automation.
---@param from_time number
---@param to_time number
function renoise.PatternTrackAutomation:clear_range(from_time, to_time) end

---Copy all points and playback settings from another track automation.
---@param other renoise.PatternTrackAutomation
function renoise.PatternTrackAutomation:copy_from(other) end

---Test if a point exists at the given time (in lines
---@param time number
---@return boolean
function renoise.PatternTrackAutomation:has_point_at(time) end

---Insert a new point, or change an existing one, if a point in
---time already exists.
---@param time number
---@param value number
---@param scaling number?
function renoise.PatternTrackAutomation:add_point_at(time, value, scaling) end

---Removes a point at the given time. Point must exist.
---@param time number
function renoise.PatternTrackAutomation:remove_point_at(time) end

---### operators

---Compares automation content only, ignoring dest parameters.
---operator==(pattern_automation, pattern_automation): boolean
---operator~=(pattern_automation, pattern_automation): boolean
