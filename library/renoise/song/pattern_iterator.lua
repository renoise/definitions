---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.PatternIterator

---Lua pairs/ipairs alike iterator functions to walk through all lines or columns
---in the entire song, track or a single pattern.
---
---General remarks: Iterators can only be use in "for" loops like you would use
---"pairs" in Lua.
---
---### examples:
---```lua
---for pos,line in renoise.song().pattern_iterator:lines_in_song() do [...] end
---```
---The returned `pos` is a table with "pattern", "track", "line" fields, and an
---additional "column" field for the note/effect columns.
---
---The `visible_only` flag controls if all content should be traversed, or only
---the currently used patterns, columns, and so on. Patterns are traversed in the
---order they are referenced in the pattern sequence, but each pattern is accessed
---only once.
---
---@class renoise.PatternIterator
renoise.PatternIterator = {}

---Line iterator position.
---@class PatternLinePosition
---@field pattern integer
---@field track integer
---@field line integer

---Note/Effect column iterator position.
---@class PatternColumnPosition : PatternLinePosition
---@field column integer

---### song

-- Iterate over all pattern lines in the song.
---@param visible_only boolean? Default: true
---@return fun(context: unknown):PatternLinePosition, renoise.PatternLine
---@return renoise.PatternLine line
---@return PatternLinePosition pos
function renoise.PatternIterator:lines_in_song(visible_only) end

-- Iterate over all note columns in the song.
---@param visible_only boolean? Default: true
---@return fun(context: unknown):PatternColumnPosition, renoise.NoteColumn
---@return renoise.NoteColumn column
---@return PatternColumnPosition pos
function renoise.PatternIterator:note_columns_in_song(visible_only) end

-- Iterate over all effect columns in the song.
---@param visible_only boolean? Default: true
---@return fun(context: unknown):PatternColumnPosition, renoise.EffectColumn
---@return renoise.EffectColumn column
---@return PatternColumnPosition pos
function renoise.PatternIterator:effect_columns_in_song(visible_only) end

---### pattern

-- Iterate over all lines in the given pattern only.
---@param pattern_index integer
---@return fun(context: unknown):PatternLinePosition, renoise.PatternLine
---@return renoise.PatternLine line
---@return PatternLinePosition pos
function renoise.PatternIterator:lines_in_pattern(pattern_index) end

-- Iterate over all note columns in the specified pattern.
---@param pattern_index integer
---@param visible_only boolean? Default: true
---@return fun(context: unknown):PatternColumnPosition, renoise.NoteColumn
---@return renoise.NoteColumn column
---@return PatternColumnPosition pos
function renoise.PatternIterator:note_columns_in_pattern(pattern_index, visible_only) end

-- Iterate over all note columns in the specified pattern.
---@param pattern_index integer
---@param visible_only boolean? Default: true
---@return fun(context: unknown):PatternColumnPosition, renoise.EffectColumn
---@return renoise.EffectColumn column
---@return PatternColumnPosition pos
function renoise.PatternIterator:effect_columns_in_pattern(pattern_index, visible_only) end

---### track

-- Iterate over all lines in the given track only.
---@param track_index integer
---@param visible_only boolean? Default: true
---@return fun(context: unknown):PatternLinePosition, renoise.PatternLine
---@return renoise.PatternLine line
---@return PatternLinePosition pos
function renoise.PatternIterator:lines_in_track(track_index, visible_only) end

-- Iterate over all note/effect columns in the specified track.
---@param track_index integer
---@param visible_only boolean? Default: true
---@return fun(context: unknown):PatternColumnPosition, renoise.NoteColumn
---@return renoise.NoteColumn column
---@return PatternColumnPosition pos
function renoise.PatternIterator:note_columns_in_track(track_index, visible_only) end

---@param track_index integer
---@param visible_only boolean? Default: true
---@return fun(context: unknown):PatternColumnPosition, renoise.EffectColumn
---@return renoise.EffectColumn column
---@return PatternColumnPosition pos
function renoise.PatternIterator:effect_columns_in_track(track_index, visible_only) end

------- Track in Pattern

-- Iterate over all lines in the given pattern, track only.
---@param pattern_index integer
---@param track_index integer
---@return fun(context: unknown):PatternLinePosition, renoise.PatternLine
---@return renoise.PatternLine line
---@return PatternLinePosition pos
function renoise.PatternIterator:lines_in_pattern_track(pattern_index, track_index) end

-- Iterate over all note/effect columns in the specified pattern track.
---@param pattern_index integer
---@param track_index integer
---@param visible_only boolean? Default: true
---@return fun(context: unknown):PatternColumnPosition, renoise.NoteColumn
---@return renoise.NoteColumn column
---@return PatternColumnPosition pos
function renoise.PatternIterator:note_columns_in_pattern_track(pattern_index, track_index, visible_only) end

---@param pattern_index integer
---@param track_index integer
---@param visible_only boolean? Default: true
---@return fun(context: unknown):PatternColumnPosition, renoise.EffectColumn
---@return renoise.EffectColumn column
---@return PatternColumnPosition pos
function renoise.PatternIterator:effect_columns_in_pattern_track(pattern_index, track_index, visible_only) end
