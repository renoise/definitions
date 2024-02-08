--------------------------------------------------------------------------------
-- renoise.Pattern
--------------------------------------------------------------------------------

-------- Constants

-- Maximum number of lines that can be present in a pattern.
renoise.Pattern.MAX_NUMBER_OF_LINES


-------- Functions

-- Deletes all lines & automation.
renoise.song().patterns[]:clear()

-- Copy contents from other patterns, including automation, when possible.
renoise.song().patterns[]:copy_from(
  other renoise.Pattern object)

-- Access to a single pattern track by index. Use properties 'tracks' to
-- iterate over all tracks and to query the track count.
renoise.song().patterns[]:track(index)
  -> [renoise.PatternTrack object]

-- Check/add/remove notifier functions or methods, which are called by Renoise
-- as soon as any of the pattern's lines have changed.
-- The notifiers are called as soon as a new line is added, an existing line
-- is cleared, or existing lines are somehow changed (notes, effects, anything)
--
-- A single argument is passed to the notifier function: "pos", a table with the
-- fields "pattern", "track" and "line", which defines where the change has
-- happened, e.g:
--
--     function my_pattern_line_notifier(pos)
--       -- check pos.pattern, pos.track, pos.line (all are indices)
--     end
--
-- Please be gentle with these notifiers, don't do too much stuff in there.
-- Ideally just set a flag like "pattern_dirty" which then gets picked up by
-- an app_idle notifier: The danger here is that line change notifiers can
-- be called hundreds of times when, for example, simply clearing a pattern.
--
-- If you are only interested in changes that are made to the currently edited
-- pattern, dynamically attach and detach to the selected pattern's line
-- notifiers by listening to "renoise.song().selected_pattern_observable".
renoise.song().patterns[]:has_line_notifier(func [, obj])
  -> [boolean]
renoise.song().patterns[]:add_line_notifier(func [, obj])
renoise.song().patterns[]:remove_line_notifier(func [, obj])

-- Same as line_notifier above, but the notifier only fires when the user
-- added, changed or deleted a line with the computer or MIDI keyboard.
renoise.song().patterns[]:has_line_edited_notifier(func [, obj])
  -> [boolean]
renoise.song().patterns[]:add_line_edited_notifier(func [, obj])
renoise.song().patterns[]:remove_line_edited_notifier(func [, obj])


-------- Properties

-- Quickly check if any track in a pattern has some non empty pattern lines. 
-- This does not look at track automation.
renoise.song().patterns[].is_empty
  -> [read-only, boolean]

-- Name of the pattern, as visible in the pattern sequencer.
renoise.song().patterns[].name, _observable
  -> [string]

-- Number of lines the pattern currently has. 64 by default. Max is
-- renoise.Pattern.MAX_NUMBER_OF_LINES, min is 1.
renoise.song().patterns[].number_of_lines, _observable
  -> [number]

-- Access to the pattern tracks. Each pattern has #renoise.song().tracks amount
-- of tracks.
renoise.song().patterns[].tracks[]
  -> [read-only, array of renoise.PatternTrack]


-------- Operators

-- Compares all tracks and lines, including automation.
==(Pattern object, Pattern object) -> [boolean]
~=(Pattern object, Pattern object) -> [boolean]
