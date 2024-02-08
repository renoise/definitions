--------------------------------------------------------------------------------
-- renoise.PatternTrackAutomation
--------------------------------------------------------------------------------

-- General remarks: Automation "time" is specified in lines + optional 1/256 
-- line fraction for the sub line grid. The sub line grid has 256 units per 
-- line. All times are internally quantized to this sub line grid.
-- For example a time of 1.5 means: line 1 with a note column delay of 128

-------- Constants

renoise.PatternTrackAutomation.PLAYMODE_POINTS
renoise.PatternTrackAutomation.PLAYMODE_LINES
renoise.PatternTrackAutomation.PLAYMODE_CURVES


-------- Functions

-- Removes all points from the automation. Will not delete the automation
-- from tracks[]:automation, instead the resulting automation will not do
-- anything at all.
renoise.song().patterns[].tracks[].automation[]:clear()
-- Remove all existing points in the given [from, to) time range from the 
-- automation.
renoise.song().patterns[].tracks[].automation[]:clear_range(from_time, to_time)

-- Copy all points and playback settings from another track automation.
renoise.song().patterns[].tracks[].automation[]:copy_from(
  other renoise.PatternTrackAutomation object)

-- Test if a point exists at the given time (in lines 
renoise.song().patterns[].tracks[].automation[]:has_point_at(time)
   -> [boolean]
-- Insert a new point, or change an existing one, if a point in
-- time already exists.
renoise.song().patterns[].tracks[].automation[]:add_point_at(
  time, value [, scaling])
-- Removes a point at the given time. Point must exist.
renoise.song().patterns[].tracks[].automation[]:remove_point_at(time)


-------- Properties

-- Destination device. Can in some rare circumstances be nil, i.e. when 
-- a device or track is about to be deleted.
renoise.song().patterns[].tracks[].automation[].dest_device
  -> [renoise.AudioDevice or nil]

-- Destination device's parameter. Can in some rare circumstances be nil, 
-- i.e. when a device or track is about to be deleted.
renoise.song().patterns[].tracks[].automation[].dest_parameter
  -> [renoise.DeviceParameter or nil]

-- play-mode (interpolation mode).
renoise.song().patterns[].tracks[].automation[].playmode, _observable
  -> [enum = PLAYMODE]

-- Max length (time in lines) of the automation. Will always fit the patterns length.
renoise.song().patterns[].tracks[].automation[].length
  -> [number, 1-NUM_LINES_IN_PATTERN]

-- Selection range as visible in the automation editor. always valid. 
-- returns the automation range no selection is present in the UI.
renoise.song().patterns[].tracks[].automation[].selection_start, _observable
  -> [number >= 1 <= automation.length+1]
renoise.song().patterns[].tracks[].automation[].selection_end, _observable
  -> [number >= 1 <= automation.length+1]
-- Get or set selection range. when setting an empty table, the existing 
-- selection, if any, will be cleared.
renoise.song().patterns[].tracks[].automation[].selection_range[], _observable
  -> [array of two numbers, 1-automation.length+1]

-- Get all points of the automation. When setting a new list of points,
-- items may be unsorted by time, but there may not be multiple points
-- for the same time. Returns a copy of the list, so changing
-- `points[1].value` will not do anything. Instead, change them via
-- `points = { something }` instead.
renoise.song().patterns[].tracks[].automation[].points[], _observable
  -> [array of {time, value} tables]

-- An automation point's time in pattern lines.
renoise.song().patterns[].tracks[].automation[].points[].time
  -> [number, 1 - NUM_LINES_IN_PATTERN]
-- An automation point's value [0-1.0]
renoise.song().patterns[].tracks[].automation[].points[].value
  -> [number, 0 - 1.0]
-- An envelope point's scaling (used in 'lines' playback mode only - 0.0 is linear).
renoise.song().patterns[].tracks[].automation[].points[].scaling
  -> [number, -1.0 - 1.0]


-------- Operators

-- Compares automation content only, ignoring dest parameters.
==(PatternTrackAutomation object, PatternTrackAutomation object) 
  -> [boolean]
~=(PatternTrackAutomation object, PatternTrackAutomation object) 
  -> [boolean]
