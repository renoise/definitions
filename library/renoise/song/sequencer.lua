---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.PatternSequencer

---Pattern sequencer component of the Renoise song.
---@class renoise.PatternSequencer
renoise.PatternSequencer = {}

---### properties

---@class renoise.PatternSequencer
---
---When true, the sequence will be auto sorted.
---@field keep_sequence_sorted boolean
---@field keep_sequence_sorted_observable renoise.Document.Observable
---
---Access to the selected slots in the sequencer. When no selection is present
---`{0, 0}` is returned, else Range: (1 - #sequencer.pattern_sequence)
---@field selection_range integer[]
---@field selection_range_observable renoise.Document.Observable
---
---Pattern order list: Notifiers will only be fired when sequence positions are
---added, removed or their order changed. To get notified of pattern assignment
---changes use the property `pattern_assignments_observable`.
---@field pattern_sequence integer[]
---@field pattern_sequence_observable renoise.Document.ObservableList
---Attach notifiers that will be called as soon as any pattern assignment
---at any sequence position changes.
---@field pattern_assignments_observable renoise.Document.Observable
---
---Attach notifiers that will be fired as soon as any slot muting property
---in any track/sequence slot changes.
---@field pattern_slot_mutes_observable renoise.Document.Observable

---### functions

---Insert the specified pattern at the given position in the sequence.
---@param sequence_index integer
---@param pattern_index integer
function renoise.PatternSequencer:insert_sequence_at(sequence_index, pattern_index) end

---Insert an empty, unreferenced pattern at the given position.
---@param sequence_index integer
---@return integer new_pattern_index
function renoise.PatternSequencer:insert_new_pattern_at(sequence_index) end

---Delete an existing position in the sequence. Renoise needs at least one
---sequence in the song for playback. Completely removing all sequence positions
---is not allowed.
function renoise.PatternSequencer:delete_sequence_at(sequence_index) end

---Access to a single sequence by index (the pattern number). Use property
---`pattern_sequence` to iterate over the whole sequence and to query the
---sequence count.
---@param sequence_index integer
---@return integer pattern_index
function renoise.PatternSequencer:pattern(sequence_index) end

---Clone a sequence range, appending it right after to_sequence_index.
---Slot muting is copied as well.
---@param from_sequence_index integer
---@param to_sequence_index integer
function renoise.PatternSequencer:clone_range(from_sequence_index, to_sequence_index) end

---Make patterns in the given sequence pos range unique, if needed.
---@param from_sequence_index integer
---@param to_sequence_index integer
function renoise.PatternSequencer:make_range_unique(from_sequence_index, to_sequence_index) end

---Sort patterns in the sequence in ascending order, keeping the old pattern
---data in place. This will only change the visual order of patterns, but
---not change the song's structure.
function renoise.PatternSequencer:sort() end

---Access to pattern sequence sections. When the `is_start_of_section flag` is
---set for a sequence pos, a section ranges from this pos to the next pos
---which starts a section, or till the end of the song when there are no others.
---@return boolean
---@param sequence_index integer
---@return boolean
function renoise.PatternSequencer:sequence_is_start_of_section(sequence_index) end

---@param sequence_index integer
---@param is_section boolean
function renoise.PatternSequencer:set_sequence_is_start_of_section(sequence_index, is_section) end

---@param sequence_index integer
---@return renoise.Document.Observable
function renoise.PatternSequencer:sequence_is_start_of_section_observable(sequence_index) end

---Access to a pattern sequence section's name. Section names are only visible
---for a sequence pos which starts the section (see `sequence_is_start_of_section`).
---@param sequence_index integer
---@return string
function renoise.PatternSequencer:sequence_section_name(sequence_index) end

---@param sequence_index integer
---@param name string
function renoise.PatternSequencer:set_sequence_section_name(sequence_index, name) end

---@param sequence_index integer
---@return renoise.Document.Observable
function renoise.PatternSequencer:sequence_section_name_observable(sequence_index) end

---Returns true if the given sequence pos is part of a section, else false.
---@param sequence_index integer
---@return boolean
function renoise.PatternSequencer:sequence_is_part_of_section(sequence_index) end

---Returns true if the given sequence pos is the end of a section, else false
---@param sequence_index integer
---@return boolean
function renoise.PatternSequencer:sequence_is_end_of_section(sequence_index) end

---Observable, which is fired, whenever the section layout in the sequence
---changed in any way, i.e. new sections got added, existing ones got deleted
---@return renoise.Document.Observable
function renoise.PatternSequencer:sequence_sections_changed_observable() end

---Access to sequencer slot mute states. Mute slots are memorized in the
---sequencer and not in the patterns.
---@param track_index integer
---@param sequence_index integer
---@return boolean
function renoise.PatternSequencer:track_sequence_slot_is_muted(track_index, sequence_index) end

---@param track_index integer
---@param sequence_index integer
function renoise.PatternSequencer:set_track_sequence_slot_is_muted(track_index, sequence_index, muted) end

---Access to sequencer slot selection states.
---@param track_index integer
---@param sequence_index integer
---@return boolean
function renoise.PatternSequencer:track_sequence_slot_is_selected(track_index, sequence_index) end

---@param track_index integer
---@param sequence_index integer
function renoise.PatternSequencer:set_track_sequence_slot_is_selected(track_index, sequence_index, selected) end
