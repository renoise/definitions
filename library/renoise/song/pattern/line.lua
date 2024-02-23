---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.PatternLine

---@class renoise.PatternLine
renoise.PatternLine = {}

---### constants

renoise.PatternLine.EMPTY_NOTE = 121
renoise.PatternLine.NOTE_OFF = 120

renoise.PatternLine.EMPTY_INSTRUMENT = 255
renoise.PatternLine.EMPTY_VOLUME = 255
renoise.PatternLine.EMPTY_PANNING = 255
renoise.PatternLine.EMPTY_DELAY = 0

renoise.PatternLine.EMPTY_EFFECT_NUMBER = 0
renoise.PatternLine.EMPTY_EFFECT_AMOUNT = 0

---### properties

---@class renoise.PatternLine
---
---Is empty.
---@field is_empty boolean **READ-ONLY**
---
---Columns.
---@field note_columns renoise.NoteColumn[] **READ-ONLY**
---@field effect_columns renoise.EffectColumn[] **READ-ONLY**

---### functions

---Clear all note and effect columns.
function renoise.PatternLine:clear() end

---Copy contents from other_line, trashing column content.
---@param other renoise.PatternLine
function renoise.PatternLine:copy_from(other) end

---Access to a single note column by index. Use properties 'note_columns'
---to iterate over all note columns and to query the note_column count.
---This is a !lot! more efficient than calling the property:
---note_columns[index] to randomly access columns. When iterating over all
---columns, use pairs(note_columns).
---@param index integer
---@return renoise.NoteColumn
function renoise.PatternLine:note_column(index) end

---Access to a single effect column by index. Use properties 'effect_columns'
---to iterate over all effect columns and to query the effect_column count.
---This is a !lot! more efficient than calling the property:
---effect_columns[index] to randomly access columns. When iterating over all
---columns, use pairs(effect_columns).
---@param index integer
---@return renoise.EffectColumn
function renoise.PatternLine:effect_column(index) end

---### operators

---Compares all columns.
---operator==(PatternLine object, PatternLine object): boolean
---operator~=(PatternLine object, PatternLine object): boolean

---Serialize a line.
---@param pattern_line renoise.PatternLine
---@return string
function tostring(pattern_line) end

--------------------------------------------------------------------------------
---renoise.NoteColumn

---A single note column in a pattern line.
---
---General remarks: instrument columns are available for lines in phrases
---but are ignored. See renoise.InstrumentPhrase for detail.
---
---Access note column properties either by values (numbers) or by strings.
---The string representation uses exactly the same notation as you see
---them in Renoise's pattern or phrase editor.
---@class renoise.NoteColumn
renoise.NoteColumn = {}

---### properties

---@class renoise.NoteColumn
---
---**READ-ONLY** True, when all note column properties are empty.
---@field is_empty boolean
---
---**READ-ONLY** True, when this column is selected in the pattern or phrase
---editors current pattern.
---@field is_selected boolean
---
---@field note_value integer 0-119, 120=Off, 121=Empty
---@field note_string string 'C-0'-'G-9', 'OFF' or '---'
---
---@field instrument_value integer 0-254, 255==Empty
---@field instrument_string string '00'-'FE' or '..'
---
---0-127 or 255==Empty when column value is <= 0x80 or is 0xFF,
---i.e. to specify a volume value.
---
---0-65535 in the form 0x0000xxyy where xx=effect char 1 and yy=effect char 2,
---when column value is > 0x80, i.e. to specify an effect.
---@field volume_value integer
---@field volume_string string '00'-'ZF' or '..'
---
---0-127, 255==Empty when column value is <= 0x80 or is 0xFF,
---i.e. to specify a pan value.
---
---0-65535 in the form 0x0000xxyy where xx=effect char 1 and yy=effect char 2,
---when column value is > 0x80, i.e. to specify an effect.
---@field panning_value integer
---@field panning_string string, '00'-'ZF' or '..'
---
---@field delay_value integer 0-255
---@field delay_string string '00'-'FF' or '..'
---
---0-65535 in the form 0x0000xxyy where xx=effect char 1 and yy=effect char 2
---@field effect_number_value integer
---@field effect_number_string string '00' - 'ZZ'
---
---@field effect_amount_value integer 0-255
---@field effect_amount_string string '00' - 'FF'

---### functions

---Clear the note column.
function renoise.NoteColumn:clear() end

---Copy the column's content from another column.
---@param other renoise.NoteColumn
function renoise.NoteColumn:copy_from(other) end

---### operators

---Compares the whole column.
---operator==(note_column, note_column): boolean
---operator~=(note_column, note_column): boolean

---Serialize a column.
---@param note_column renoise.NoteColumn
function tostring(note_column) end

--------------------------------------------------------------------------------
---## renoise.EffectColumn

---A single effect column in a pattern line.
---
---Access effect column properties either by values (numbers) or by strings.
---The string representation uses exactly the same notation as you see
---them in Renoise's pattern or phrase editor.
---@class renoise.EffectColumn
renoise.EffectColumn = {}

---### properties

---@class renoise.EffectColumn
---
---**READ-ONLY** True, when all effect column properties are empty.
---@field is_empty boolean
---
---**READ-ONLY** True, when this column is selected in the pattern or phrase editor.
---@field is_selected boolean
---
---0-65535 in the form 0x0000xxyy where xx=effect char 1 and yy=effect char 2
---@field number_value integer
---@field number_string string Range: ('00' - 'ZZ')
---
---@field amount_value integer Range: (0 - 255)
---@field amount_string string Range: ('00' - 'FF')

---### functions

---Clear the effect column.
function renoise.EffectColumn:clear() end

---Copy the column's content from another column.
---@param other renoise.EffectColumn
function renoise.EffectColumn:copy_from(other) end

---### operators

---Compares the whole column.
---operator==(EffectColumn object, EffectColumn object): boolean
---operator~=(EffectColumn object, EffectColumn object): boolean

---Serialize a column.
---@param effect_column renoise.EffectColumn
---@return string
function tostring(effect_column) end
