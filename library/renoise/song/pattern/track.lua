--------------------------------------------------------------------------------
-- renoise.PatternTrack
--------------------------------------------------------------------------------

-------- Functions

-- Deletes all lines & automation.
renoise.song().patterns[].tracks[]:clear()

-- Copy contents from other pattern tracks, including automation when possible.
renoise.song().patterns[].tracks[]:copy_from(
  other renoise.PatternTrack object)

-- Access to a single line by index. Line must be [1-MAX_NUMBER_OF_LINES]). 
-- This is a !lot! more efficient than calling the property: lines[index] to
-- randomly access lines.
renoise.song().patterns[].tracks[]:line(index)
  -> [renoise.PatternLine]

-- Get a specific line range (index must be [1-Pattern.MAX_NUMBER_OF_LINES])
renoise.song().patterns[].tracks[]:lines_in_range(index_from, index_to)
  -> [array of renoise.PatternLine objects]


-- Returns the automation for the given device parameter or nil when there is
-- none.
renoise.song().patterns[].tracks[]:find_automation(parameter)
  -> [renoise.PatternTrackAutomation or nil]

-- Creates a new automation for the given device parameter.
-- Fires an error when an automation for the given parameter already exists.
-- Returns the newly created automation. Passed parameter must be automatable,
-- which can be tested with 'parameter.is_automatable'.
renoise.song().patterns[].tracks[]:create_automation(parameter)
  -> [renoise.PatternTrackAutomation object]

-- Remove an existing automation the given device parameter. Automation
-- must exist.
renoise.song().patterns[].tracks[]:delete_automation(parameter)


-------- Properties

-- Ghosting (aliases)
renoise.song().patterns[].tracks[].is_alias 
  -> [read-only, boolean]
-- Pattern index the pattern track is aliased or 0 when its not aliased.
renoise.song().patterns[].tracks[].alias_pattern_index , _observable
  -> [number, index or 0 when no alias is present]
  
-- Color.
renoise.song().patterns[].tracks[].color, _observable
  -> [table with 3 numbers (0-0xFF, RGB) or nil when no custom slot color is set]

-- Returns true when all the track lines are empty. Does not look at automation.
renoise.song().patterns[].tracks[].is_empty, _observable
  -> [read-only, boolean]

-- Get all lines in range [1, number_of_lines_in_pattern]
renoise.song().patterns[].tracks[].lines[]
  -> [read-only, array of renoise.PatternLine objects]

-- Automation.
renoise.song().patterns[].tracks[].automation[], _observable
  -> [read-only, array of renoise.PatternTrackAutomation objects]


-------- Operators

-- Compares line content and automation. All other properties are ignored.
==(PatternTrack object, PatternTrack object) -> [boolean]
~=(PatternTrack object, PatternTrack object) -> [boolean]

--------------------------------------------------------------------------------
-- renoise.PatternTrackLine
--------------------------------------------------------------------------------

-- DEPRECATED - alias for renoise.PatternLine




