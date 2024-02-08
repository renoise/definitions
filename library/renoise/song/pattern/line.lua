
--------------------------------------------------------------------------------
-- renoise.PatternLine
--------------------------------------------------------------------------------

-------- Constants

renoise.PatternLine.EMPTY_NOTE
renoise.PatternLine.NOTE_OFF

renoise.PatternLine.EMPTY_INSTRUMENT
renoise.PatternLine.EMPTY_VOLUME
renoise.PatternLine.EMPTY_PANNING
renoise.PatternLine.EMPTY_DELAY

renoise.PatternLine.EMPTY_EFFECT_NUMBER
renoise.PatternLine.EMPTY_EFFECT_AMOUNT


-------- Functions

-- Clear all note and effect columns.
renoise.song().patterns[].tracks[].lines[]:clear()

-- Copy contents from other_line, trashing column content.
renoise.song().patterns[].tracks[].lines[]:copy_from(
  other renoise.PatternLine object)

-- Access to a single note column by index. Use properties 'note_columns' 
-- to iterate over all note columns and to query the note_column count.
-- This is a !lot! more efficient than calling the property: 
-- note_columns[index] to randomly access columns. When iterating over all
-- columns, use pairs(note_columns).
renoise.song().patterns[].tracks[].lines[]:note_column(index)
  -> [renoise.NoteColumn object]

-- Access to a single effect column by index. Use properties 'effect_columns' 
-- to iterate over all effect columns and to query the effect_column count.
-- This is a !lot! more efficient than calling the property: 
-- effect_columns[index] to randomly access columns. When iterating over all
-- columns, use pairs(effect_columns).
renoise.song().patterns[].tracks[].lines[]:effect_column(index)
  -> [renoise.EffectColumn object]


-------- Properties

-- Is empty.
renoise.song().patterns[].tracks[].lines[].is_empty
  -> [boolean]

-- Columns.
renoise.song().patterns[].tracks[].lines[].note_columns[]
  -> [read-only, array of renoise.NoteColumn objects]
renoise.song().patterns[].tracks[].lines[].effect_columns[]
  -> [read-only, array of renoise.EffectColumn objects]


-------- Operators

-- Compares all columns.
==(PatternLine object, PatternLine object) 
  -> [boolean]
~=(PatternLine object, PatternLine object) 
  -> [boolean]

-- Serialize a line.
tostring(PatternLine object) 
  -> [string]


--------------------------------------------------------------------------------
-- renoise.NoteColumn
--------------------------------------------------------------------------------

-- General remarks: instrument columns are available for lines in phrases
-- but are ignored. See renoise.InstrumentPhrase for detail.


-------- Functions

-- Clear the note column.
renoise.song().patterns[].tracks[].lines[].note_columns[]:clear()

-- Copy the column's content from another column.
renoise.song().patterns[].tracks[].lines[].note_columns[]:copy_from(
  other renoise.NoteColumn object)


-------- Properties

-- True, when all note column properties are empty.
renoise.song().patterns[].tracks[].lines[].note_columns[].is_empty
  -> [read-only, boolean]

-- True, when this column is selected in the pattern or phrase 
-- editors current pattern.
renoise.song().patterns[].tracks[].lines[].note_columns[].is_selected
  -> [read-only, boolean]

-- Access note column properties either by values (numbers) or by strings.
-- The string representation uses exactly the same notation as you see
-- them in Renoise's pattern or phrase editor.

renoise.song().patterns[].tracks[].lines[].note_columns[].note_value
  -> [number, 0-119, 120=Off, 121=Empty]
renoise.song().patterns[].tracks[].lines[].note_columns[].note_string
  -> [string, 'C-0'-'G-9', 'OFF' or '---']

renoise.song().patterns[].tracks[].lines[].note_columns[].instrument_value
  -> [number, 0-254, 255==Empty]
renoise.song().patterns[].tracks[].lines[].note_columns[].instrument_string
  -> [string, '00'-'FE' or '..']

renoise.song().patterns[].tracks[].lines[].note_columns[].volume_value
  -> [number, 0-127, 255==Empty when column value is <= 0x80 or is 0xFF,
              i.e. is used to specify volume]
     [number, 0-65535 in the form 0x0000xxyy where
              xx=effect char 1 and yy=effect char 2,
              when column value is > 0x80, i.e. is used to specify an effect]
renoise.song().patterns[].tracks[].lines[].note_columns[].volume_string
  -> [string, '00'-'ZF' or '..']

renoise.song().patterns[].tracks[].lines[].note_columns[].panning_value
  -> [number, 0-127, 255==Empty when column value is <= 0x80 or is 0xFF,
              i.e. is used to specify pan]
     [number, 0-65535 in the form 0x0000xxyy where
              xx=effect char 1 and yy=effect char 2,
              when column value is > 0x80, i.e. is used to specify an effect]
renoise.song().patterns[].tracks[].lines[].note_columns[].panning_string
  -> [string, '00'-'ZF' or '..']

renoise.song().patterns[].tracks[].lines[].note_columns[].delay_value
  -> [number, 0-255]
renoise.song().patterns[].tracks[].lines[].note_columns[].delay_string
  -> [string, '00'-'FF' or '..']

renoise.song().patterns[].tracks[].lines[].note_columns[].effect_number_value
  -> [int, 0-65535 in the form 0x0000xxyy where xx=effect char 1 and yy=effect char 2]
song().patterns[].tracks[].lines[].note_columns[].effect_number_string
  -> [string, '00' - 'ZZ']

renoise.song().patterns[].tracks[].lines[].note_columns[].effect_amount_value 
  -> [int, 0-255]
renoise.song().patterns[].tracks[].lines[].note_columns[].effect_amount_string
  -> [string, '00' - 'FF']


-------- Operators

-- Compares the whole column.
==(NoteColumn object, NoteColumn object) -> [boolean]
~=(NoteColumn object, NoteColumn object) -> [boolean]

-- Serialize a column.
tostring(NoteColumn object) -> [string]


--------------------------------------------------------------------------------
-- renoise.EffectColumn
--------------------------------------------------------------------------------

-------- Functions

-- Clear the effect column.
renoise.song().patterns[].tracks[].lines[].effect_columns[]:clear()

-- Copy the column's content from another column.
renoise.song().patterns[].tracks[].lines[].effect_columns[]:copy_from(
  other renoise.EffectColumn object)


-------- Properties

-- True, when all effect column properties are empty.
renoise.song().patterns[].tracks[].lines[].effect_columns[].is_empty
  -> [read-only, boolean]

-- True, when this column is selected in the pattern or phrase editor.
renoise.song().patterns[].tracks[].lines[].effect_columns[].is_selected
  -> [read-only, boolean]

-- Access effect column properties either by values (numbers) or by strings.
renoise.song().patterns[].tracks[].lines[].effect_columns[].number_value
  -> [number, 0-65535 in the form 0x0000xxyy where xx=effect char 1 and yy=effect char 2]

renoise.song().patterns[].tracks[].lines[].effect_columns[].number_string
  -> [string, '00'-'ZZ']

renoise.song().patterns[].tracks[].lines[].effect_columns[].amount_value
  -> [number, 0-255]
renoise.song().patterns[].tracks[].lines[].effect_columns[].amount_string
  -> [string, '00'-'FF']


-------- Operators

-- Compares the whole column.
==(EffectColumn object, EffectColumn object) 
  -> [boolean]
~=(EffectColumn object, EffectColumn object) 
  -> [boolean]

-- Serialize a column.
tostring(EffectColumn object) -> [string]
