--------------------------------------------------------------------------------
---General remarks: Phrases do use renoise.PatternLine objects just like the 
---pattern tracks do. When the instrument column is enabled and used, 
---not instruments, but samples are addressed/triggered in phrases.
---@class renoise.InstrumentPhrase
--------------------------------------------------------------------------------
---@class renoise.InstrumentPhrase
---
---### properties
---
---Name of the phrase as visible in the phrase editor and piano mappings.
---@field name string
---@field name_observable renoise.Document.Observable
---
---(Key)Mapping properties of the phrase or nil when no mapping is present.
---@field mapping renoise.InstrumentPhraseMapping?
---
---**READ-ONLY** 
---Quickly check if a phrase has some non empty pattern lines.
---@field is_empty boolean
---@field is_empty_observable renoise.Document.Observable
---
---Number of lines the phrase currently has.
---@field number_of_lines integer Default: 16 Range: (1-renoise.InstrumentPhrase.MAX_NUMBER_OF_LINES)
---@field number_of_lines_observable renoise.Document.Observable
---
---**READ-ONLY** 
---Get all lines in a range [1, number_of_lines_in_pattern]
---@field lines renoise.PatternLine[]
---
---How many note columns are visible in the phrase.
---Range: (MIN_NUMBER_OF_NOTE_COLUMNS-MAX_NUMBER_OF_NOTE_COLUMNS)
---@field visible_note_columns integer 
---@field visible_note_columns_observable  renoise.Document.Observable
---
---How many effect columns are visible in the phrase.
---Range: (MIN_NUMBER_OF_EFFECT_COLUMNS-MAX_NUMBER_OF_EFFECT_COLUMNS)
---@field visible_effect_columns integer
---@field visible_effect_columns_observable renoise.Document.Observable
---
---Phrase's key-tracking mode.
---@field key_tracking renoise.InstrumentPhrase.KeyTrackingMode
---@field key_tracking_observable  renoise.Document.Observable
---
---Phrase's base-note. Only relevant when key_tracking is set to transpose.
---@field base_note integer Range: (0-119) where C-4 is 48
---@field base_note_observable  renoise.Document.Observable
---
---Loop mode. The phrase plays as one-shot when disabled.
---@field looping boolean
---@field looping_observable  renoise.Document.Observable
---
---Loop start. Playback will start from the beginning before entering loop
---@field loop_start integer Range: (1-number_of_lines)
---@field loop_start_observable  renoise.Document.Observable
---
---Loop end. Needs to be > loop_start and <= number_of_lines
---@field loop_end integer Range: (loop_start-number_of_lines)
---@field loop_end_observable  renoise.Document.Observable
---
---Phrase autoseek settings
---@field autoseek boolean
---@field autoseek_observable renoise.Document.Observable
---
---Phrase local lines per beat setting. New phrases get initialized with 
---the song's current LPB setting. TPL can not be configured in phrases.
---@field lpb integer Range: (1-256)
---@field lpb_observable renoise.Document.Observable
---
---Shuffle groove amount for a phrase. 
---0.0 = no shuffle (off), 1.0 = full shuffle 
---@field shuffle number Range: (0-1)
---@field shuffle_observable renoise.Document.Observable
---
---Column visibility.
---@field instrument_column_visible boolean
---@field instrument_column_visible_observable renoise.Document.Observable
---
---@field volume_column_visible boolean
---@field volume_column_visible_observable  renoise.Document.Observable
---
---@field panning_column_visible boolean
---@field panning_column_visible_observable  renoise.Document.Observable
---
---@field delay_column_visible boolean
---@field delay_column_visible_observable  renoise.Document.Observable
---
---@field sample_effects_column_visible boolean
---@field sample_effects_column_visible_observable  renoise.Document.Observable

---### constants

renoise.InstrumentPhrase = {}

---@enum renoise.InstrumentPhrase.KeyTrackingMode
renoise.InstrumentPhrase = {
---Every note plays back the phrase unpitched from line 1.
  KEY_TRACKING_NONE = 1,
---Play the phrase transposed relative to the phrase's base_note.
  KEY_TRACKING_TRANSPOSE = 2,
---Trigger phrase from the beginning (note_range start) up to the end (note_range end).
  KEY_TRACKING_OFFSET = 3,
}

---Maximum number of lines that can be present in a phrase.
renoise.InstrumentPhrase.MAX_NUMBER_OF_LINES = 512

---Min/Maximum number of note columns that can be present in a phrase.
renoise.InstrumentPhrase.MIN_NUMBER_OF_NOTE_COLUMNS = 1
renoise.InstrumentPhrase.MAX_NUMBER_OF_NOTE_COLUMNS = 12

---Min/Maximum number of effect columns that can be present in a phrase.
renoise.InstrumentPhrase.MIN_NUMBER_OF_EFFECT_COLUMNS = 0
renoise.InstrumentPhrase.MAX_NUMBER_OF_EFFECT_COLUMNS = 8

---### functions

---Deletes all lines.
function renoise.InstrumentPhrase:clear() end

---Copy contents from another phrase.
---@param phrase renoise.InstrumentPhrase
function renoise.InstrumentPhrase:copy_from(phrase) end

---Access to a single line by index. Line must be [1-MAX_NUMBER_OF_LINES]). 
---This is a !lot! more efficient than calling the property: lines[index] to
---randomly access lines.
---@param index integer Range:(1-renoise.InstrumentPhrase.MAX_NUMBER_OF_LINES)
---@return renoise.PatternLine
function renoise.InstrumentPhrase:line(index) end

---Get a specific line range 
---@param index_from integer Range: (1-renoise.InstrumentPhrase.MAX_NUMBER_OF_LINES)
---@param index_to integer Range: (1-renoise.InstrumentPhrase.MAX_NUMBER_OF_LINES)
---@return renoise.PatternLine[]
function renoise.InstrumentPhrase:lines_in_range(index_from, index_to) end

--TODO annotate notifier function inputs

---Check/add/remove notifier functions or methods, which are called by 
---Renoise as soon as any of the phrases's lines have changed.
---@see renoise.Pattern.has_line_notifier for more details.
---@param func function
---@return boolean
function renoise.InstrumentPhrase:has_line_notifier(func) end

---@param func function
function renoise.InstrumentPhrase:add_line_notifier(func) end

---@param func function
function renoise.InstrumentPhrase:remove_line_notifier(func) end

---Same as line_notifier above, but the notifier only fires when the user
---added, changed or deleted a line with the computer keyboard.
---@param func function
---@return boolean
function renoise.InstrumentPhrase:has_line_edited_notifier(func) end

---@param func function
function renoise.InstrumentPhrase:add_line_edited_notifier(func) end

---@param func function
function renoise.InstrumentPhrase:remove_line_edited_notifier(func) end

---Note column mute states. 
---@param column integer Range: (1-renoise.InstrumentPhrase.MAX_NUMBER_OF_NOTE_COLUMNS)
---@return boolean
function renoise.InstrumentPhrase:column_is_muted(column) end

---@param column integer Range: (1-renoise.InstrumentPhrase.MAX_NUMBER_OF_NOTE_COLUMNS)
---@return renoise.Document.Observable
function renoise.InstrumentPhrase:column_is_muted_observable(column) end

---@param column integer Range: (1-renoise.InstrumentPhrase.MAX_NUMBER_OF_NOTE_COLUMNS)
---@param muted boolean
function renoise.InstrumentPhrase:set_column_is_muted(column, muted) end

---Note column names. 
---@param column integer Range: (1-renoise.InstrumentPhrase.MAX_NUMBER_OF_NOTE_COLUMNS)
---@return string
function renoise.InstrumentPhrase:column_name(column) end

---@param column integer Range: (1-renoise.InstrumentPhrase.MAX_NUMBER_OF_NOTE_COLUMNS)
---@return renoise.Document.Observable
function renoise.InstrumentPhrase:column_name_observable(column) end

---@param column integer Range: (1-renoise.InstrumentPhrase.MAX_NUMBER_OF_NOTE_COLUMNS)
---@param name string
function renoise.InstrumentPhrase:set_column_name(column, name) end

---Swap the positions of two note columns within a phrase.
---@param index1 integer Range: (1-renoise.InstrumentPhrase.MAX_NUMBER_OF_NOTE_COLUMNS)
---@param index2 integer Range: (1-renoise.InstrumentPhrase.MAX_NUMBER_OF_NOTE_COLUMNS)
function renoise.InstrumentPhrase:swap_note_columns_at(index1, index2) end

---Swap the positions of two effect columns within a phrase.
---@param index1 integer Range: (1-renoise.InstrumentPhrase.MAX_NUMBER_OF_NOTE_COLUMNS)
---@param index2 integer Range: (1-renoise.InstrumentPhrase.MAX_NUMBER_OF_NOTE_COLUMNS)
function renoise.InstrumentPhrase:swap_effect_columns_at(index1, index2) end


--TODO once comparison operators get implemented in lua-ls
--### operators
--Compares line content. All other properties are ignored.
-- ==(InstrumentPhrase object, InstrumentPhrase object) 
-- -> [boolean]
-- ~=(InstrumentPhrase object, InstrumentPhrase object) 
-- -> [boolean]


--------------------------------------------------------------------------------
---@class renoise.InstrumentPhraseMapping
--------------------------------------------------------------------------------
---
---### properties
---
---Linked phrase.
---@field phrase renoise.InstrumentPhrase
---
---Phrase's key-tracking mode.
---@field key_tracking renoise.InstrumentPhraseMapping.KeyTrackingMode
---@field key_tracking_observable  renoise.Document.Observable
---
---Phrase's base-note. Only relevant when key_tracking is set to transpose.
---@field base_note integer Range:(0-119) where C-4 is 48
---@field base_note_observable  renoise.Document.Observable
---
---Note range the mapping is triggered at. Phrases may not overlap, so
---note_range start can only be set behind previous's (if any) end and
---note_range end can only be set before next mapping's (if any) start.
---@field note_range integer[] Range: (0-119) where C-4 is 48
---@field note_range_observable  renoise.Document.Observable
---
---Loop mode. The phrase plays as one-shot when disabled.
---@field looping boolean
---@field looping_observable  renoise.Document.Observable
---
---@field loop_start integer
---@field loop_start_observable  renoise.Document.Observable
---
---@field loop_end integer
---@field loop_end_observable  renoise.Document.Observable

---### constants

---@enum renoise.InstrumentPhraseMapping.KeyTrackingMode
renoise.InstrumentPhraseMapping = {
---Every note plays back the phrase unpitched from line 1.
  KEY_TRACKING_NONE = 1,
---Play the phrase transposed relative to the phrase's base_note.
  KEY_TRACKING_TRANSPOSE = 2,
---Trigger phrase from the beginning (note_range start) up to the end (note_range end).
  KEY_TRACKING_OFFSET = 3,
}
