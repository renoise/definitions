--------------------------------------------------------------------------------
-- renoise.InstrumentPhrase
--------------------------------------------------------------------------------

-- General remarks: Phrases do use renoise.PatternLine objects just like the 
-- pattern tracks do. When the instrument column is enabled and used, 
-- not instruments, but samples are addressed/triggered in phrases.


-------- Constants

-- Maximum number of lines that can be present in a phrase.
renoise.InstrumentPhrase.MAX_NUMBER_OF_LINES

-- Min/Maximum number of note columns that can be present in a phrase.
renoise.InstrumentPhrase.MIN_NUMBER_OF_NOTE_COLUMNS
renoise.InstrumentPhrase.MAX_NUMBER_OF_NOTE_COLUMNS

-- Min/Maximum number of effect columns that can be present in a phrase.
renoise.InstrumentPhrase.MIN_NUMBER_OF_EFFECT_COLUMNS
renoise.InstrumentPhrase.MAX_NUMBER_OF_EFFECT_COLUMNS

-- See InstrumentPhraseMapping KEY_TRACKING
renoise.InstrumentPhrase.KEY_TRACKING_NONE
renoise.InstrumentPhrase.KEY_TRACKING_TRANSPOSE
renoise.InstrumentPhrase.KEY_TRACKING_OFFSET


-------- Functions

-- Deletes all lines.
renoise.song().instruments[].phrases[]:clear()

-- Copy contents from another phrase.
renoise.song().instruments[].phrases[]:copy_from(
  other renoise.InstrumentPhrase object)

-- Access to a single line by index. Line must be [1-MAX_NUMBER_OF_LINES]). 
-- This is a !lot! more efficient than calling the property: lines[index] to
-- randomly access lines.
renoise.song().instruments[].phrases[]:line(index)
  -> [renoise.PatternLine object]
-- Get a specific line range (index must be [1-MAX_NUMBER_OF_LINES])
renoise.song().instruments[].phrases[]:lines_in_range(index_from, index_to)
  -> [array of renoise.PatternLine objects]

-- Check/add/remove notifier functions or methods, which are called by 
-- Renoise as soon as any of the phrases's lines have changed.
-- See renoise.song().patterns[]:has_line_notifier for more details.
renoise.song().instruments[].phrases[]:has_line_notifier(func [, obj])
  -> [boolean]
renoise.song().instruments[].phrases[]:add_line_notifier(func [, obj])
renoise.song().instruments[].phrases[]:remove_line_notifier(func [, obj])

-- Same as line_notifier above, but the notifier only fires when the user
-- added, changed or deleted a line with the computer keyboard.
renoise.song().instruments[].phrases[]:has_line_edited_notifier(func [, obj])
  -> [boolean]
renoise.song().instruments[].phrases[]:add_line_edited_notifier(func [, obj])
renoise.song().instruments[].phrases[]:remove_line_edited_notifier(func [, obj])

-- Note column mute states. Only valid within (1-MAX_NUMBER_OF_NOTE_COLUMNS)
renoise.song().instruments[].phrases[]:column_is_muted(column)
  -> [boolean]
renoise.song().instruments[].phrases[]:column_is_muted_observable(column)
  -> [Observable object]
renoise.song().instruments[].phrases[]:set_column_is_muted(column, muted)

-- Note column names. Only valid within (1-MAX_NUMBER_OF_NOTE_COLUMNS)
renoise.song().instruments[].phrases[]:column_name(column)
  -> [string]
renoise.song().instruments[].phrases[]:column_name_observable(column)
  -> [Observable object]
renoise.song().instruments[].phrases[]:set_column_name(column, name)

-- Swap the positions of two note or effect columns within a phrase.
renoise.song().instruments[].phrases[]:swap_note_columns_at(index1, index2)
renoise.song().instruments[].phrases[]:swap_effect_columns_at(index1, index2)


-------- Properties

-- Name of the phrase as visible in the phrase editor and piano mappings.
renoise.song().instruments[].phrases[].name, _observable
  -> [string]

-- (Key)Mapping properties of the phrase or nil when no mapping is present.
renoise.song().instruments[].phrases[].mapping
  -> [renoise.InstrumentPhraseMapping object or nil]

-- Quickly check if a phrase has some non empty pattern lines.
renoise.song().instruments[].phrases[].is_empty, _observable
  -> [read-only, boolean]

-- Number of lines the phrase currently has. 16 by default. Max is
-- renoise.InstrumentPhrase.MAX_NUMBER_OF_LINES, min is 1.
renoise.song().instruments[].phrases[].number_of_lines, _observable
  -> [number, 1-MAX_NUMBER_OF_LINES]

-- Get all lines in a range [1, number_of_lines_in_pattern]
renoise.song().instruments[].phrases[].lines[]
  -> [read-only, array of renoise.PatternLine objects]

-- How many note columns are visible in the phrase.
renoise.song().instruments[].phrases[].visible_note_columns, _observable 
  -> [number, MIN_NUMBER_OF_NOTE_COLUMNS-MAX_NUMBER_OF_NOTE_COLUMNS]
-- How many effect columns are visible in the phrase.
renoise.song().instruments[].phrases[].visible_effect_columns, _observable
  -> [number, MIN_NUMBER_OF_EFFECT_COLUMNS-MAX_NUMBER_OF_EFFECT_COLUMNS]

-- Phrase's key-tracking mode.
renoise.song().instruments[].phrases[].key_tracking, _observable 
  -> [enum = KEY_TRACKING]

-- Phrase's base-note. Only relevant when key_tracking is set to transpose.
renoise.song().instruments[].phrases[].base_note, _observable 
  -> [number, 0-119, c-4=48]

-- Loop mode. The phrase plays as one-shot when disabled.
renoise.song().instruments[].phrases[].looping, _observable 
  -> [boolean]

-- Loop start. Playback will start from the beginning before entering loop
renoise.song().instruments[].phrases[].loop_start, _observable 
  -> [number, 1-number_of_lines]
-- Loop end. Needs to be > loop_start and <= number_of_lines
renoise.song().instruments[].phrases[].loop_end, _observable 
  -> [number, loop_start-number_of_lines]

-- Phrase autoseek settings.
renoise.song().instruments[].phrases[].autoseek, _observable
  -> [boolean]

-- Phrase local lines per beat setting. New phrases get initialized with 
-- the song's current LPB setting. TPL can not be configured in phrases.
renoise.song().instruments[].phrases[].lpb, _observable
  -> [number, 1-256]
  
-- Shuffle groove amount for a phrase. 
-- 0.0 = no shuffle (off), 1.0 = full shuffle 
renoise.song().instruments[].phrases[].shuffle, _observable
  -> [number, 0-1]

-- Column visibility.
renoise.song().instruments[].phrases[].instrument_column_visible, _observable
  -> [boolean]
renoise.song().instruments[].phrases[].volume_column_visible, _observable 
  -> [boolean]
renoise.song().instruments[].phrases[].panning_column_visible, _observable 
  -> [boolean]
renoise.song().instruments[].phrases[].delay_column_visible, _observable 
  -> [boolean]
renoise.song().instruments[].phrases[].sample_effects_column_visible, _observable 
  -> [boolean]

-------- Operators

-- Compares line content. All other properties are ignored.
==(InstrumentPhrase object, InstrumentPhrase object) 
  -> [boolean]
~=(InstrumentPhrase object, InstrumentPhrase object) 
  -> [boolean]


--------------------------------------------------------------------------------
-- renoise.InstrumentPhraseMapping
--------------------------------------------------------------------------------

-------- Constants

-- Every note plays back the phrase unpitched from line 1.
renoise.InstrumentPhraseMapping.KEY_TRACKING_NONE
-- Play the phrase transposed relative to the phrase's base_note.
renoise.InstrumentPhraseMapping.KEY_TRACKING_TRANSPOSE
-- Trigger phrase from the beginning (note_range start) up to the end (note_range end).
renoise.InstrumentPhraseMapping.KEY_TRACKING_OFFSET


-------- Properties

-- Linked phrase.
renoise.song().instruments[].phrases[].mapping.phrase
  -> [renoise.InstrumentPhrase object]

-- Phrase's key-tracking mode.
renoise.song().instruments[].phrases[].mapping.key_tracking, _observable 
  -> [enum = KEY_TRACKING]

-- Phrase's base-note. Only relevant when key_tracking is set to transpose.
renoise.song().instruments[].phrases[].mapping.base_note, _observable 
  -> [number, 0-119, c-4=48]

-- Note range the mapping is triggered at. Phrases may not overlap, so
-- note_range start can only be set behind previous's (if any) end and
-- note_range end can only be set before next mapping's (if any) start.
renoise.song().instruments[].phrases[].mapping.note_range, _observable 
  -> [table with two numbers (0-119, c-4=48)]

-- Loop mode. The phrase plays as one-shot when disabled.
renoise.song().instruments[].phrases[].mapping.looping, _observable 
  -> [boolean]
renoise.song().instruments[].phrases[].mapping.loop_start, _observable 
  -> [number]
renoise.song().instruments[].phrases[].mapping.loop_end, _observable 
  -> [number]


