---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.SongPos

---Helper class used in Transport and Song, representing a position in the song.
---@class renoise.SongPos
---Position in the pattern sequence.
---@field sequence integer
---Position in the pattern at the given pattern sequence.
---@field line integer
---@overload fun(): renoise.SongPos
---@overload fun(sequence: integer, line: integer): renoise.SongPos
renoise.SongPos = {}

---### operators

---operator==(song_pos, song_pos): boolean
---operator<(song_pos, song_pos): boolean

--------------------------------------------------------------------------------
---## renoise.Song

---@class renoise.Song
renoise.Song = {}

---Selection range in the current pattern
---@class PatternSelection
---@field start_line integer? Start pattern line index
---@field start_track integer? Start track index
---@field start_column integer? Start column index within start_track
---@field end_line integer? End pattern line index
---@field end_track integer? End track index
---@field end_column integer? End column index within end_track

---Selection range in the current phrase
---@class PhraseSelection
---@field start_line integer? Start pattern line index
---@field start_column integer? Start column index within start_track
---@field end_line integer? End pattern line index
---@field end_column integer? End column index within end_track

---### constants

renoise.Song.MAX_NUMBER_OF_INSTRUMENTS = 255

---@enum renoise.Song.SubColumnType
---@diagnostic disable-next-line: missing-fields
renoise.Song = {
  SUB_COLUMN_NOTE = 1,
  SUB_COLUMN_INSTRUMENT = 2,
  SUB_COLUMN_VOLUME = 3,
  SUB_COLUMN_PANNING = 4,
  SUB_COLUMN_DELAY = 5,
  SUB_COLUMN_SAMPLE_EFFECT_NUMBER = 6,
  SUB_COLUMN_SAMPLE_EFFECT_AMOUNT = 7,
  SUB_COLUMN_EFFECT_NUMBER = 8,
  SUB_COLUMN_EFFECT_AMOUNT = 9
}

---### properties

---Renoise's main document - the song.
---@class renoise.Song
---
---**READ-ONLY** When the song is loaded from or saved to a file, the absolute
---path and name to the XRNS file, otherwise an empty string.
---@field file_name string
---
---Song Comments
---@field artist string
---@field artist_observable renoise.Document.Observable
---@field name string
---@field name_observable renoise.Document.Observable
---Note: All property tables of basic types in the API are temporary copies.
---In other words `comments = { "Hello", "World" }` will work,
---`comments[1] = "Hello"; renoise.song().comments[2] = "World"`
---will *not* work.
---@field comments string[]
---@field comments_observable renoise.Document.ObservableList
---**READ-ONLY** Notifier is called as soon as any paragraph in the comments change.
---@field comments_assignment_observable renoise.Document.Observable
---Set this to true to show the comments dialog after loading a song
---@field show_comments_after_loading boolean
---@field show_comments_after_loading_observable renoise.Document.Observable
---
---Inject/fetch custom XRNX scripting tool data into the song. Can only be called
---from scripts that are running in Renoise scripting tool bundles; attempts to
---access the data from e.g. the scripting terminal will result in an error.
---Returns nil when no data is present.
---
---Each tool gets it's own data slot in the song, which is resolved by the tool's
---bundle id, so this data is unique for every tool and persistent across tools
---with the same bundle id (but possibly different versions).
---If you want to store renoise.Document data in here, you can use the
---renoise.Document's 'to_string' and 'from_string' functions to serialize the data.
---Alternatively, write your own serializers for your custom data.
---@field tool_data string?
---
---**READ-ONLY** True while rendering is in progress.
---@see renoise.Song.render
---@field rendering boolean
---**READ-ONLY** The current render progress amount 
---@see renoise.Song.render
---@field rendering_progress number Range: (0.0 - 1.0)
---
---**READ-ONLY**
---@field transport renoise.Transport
---
---**READ-ONLY**
---@field sequencer renoise.PatternSequencer
---
---**READ-ONLY**
---@field pattern_iterator renoise.PatternIterator
---
---**READ-ONLY** number of normal playback tracks (non-master or sends) in song.
---@field sequencer_track_count integer
----**READ-ONLY** number of send tracks in song.
---@field send_track_count integer
---
---**READ-ONLY** Instrument, Pattern, and Track arrays
---@field instruments renoise.Instrument[]
---@field instruments_observable renoise.Document.ObservableList
---@field patterns renoise.Pattern[]
---@field patterns_observable renoise.Document.ObservableList
---@field tracks renoise.Track[]
---@field tracks_observable renoise.Document.ObservableList
---
---**READ-ONLY** Selected in the instrument box.
---@field selected_instrument renoise.Instrument
---@field selected_instrument_observable renoise.Document.Observable
---@field selected_instrument_index integer
---@field selected_instrument_index_observable renoise.Document.Observable
---
---**READ-ONLY** Currently selected phrase the instrument's phrase map piano
---view.
---@field selected_phrase renoise.InstrumentPhrase?
---@field selected_phrase_observable renoise.Document.Observable
---@field selected_phrase_index integer
---
---**READ-ONLY** Selected in the instrument's sample list. Only nil when no
---samples are present in the selected instrument.
---@field selected_sample renoise.Sample?
---@field selected_sample_observable renoise.Document.Observable
---@field selected_sample_index integer
---
---**READ-ONLY** Selected in the instrument's modulation view.
---@field selected_sample_modulation_set renoise.SampleModulationSet?
---@field selected_sample_modulation_set_observable renoise.Document.Observable
---@field selected_sample_modulation_set_index integer
---
---**READ-ONLY** Selected in the instrument's effects view.
---@field selected_sample_device_chain renoise.SampleDeviceChain?
---@field selected_sample_device_chain_observable renoise.Document.Observable
---@field selected_sample_device_chain_index integer
---
---**READ-ONLY** Selected in the sample effect mixer.
---@field selected_sample_device renoise.AudioDevice?
---@field selected_sample_device_observable renoise.Document.Observable
---@field selected_sample_device_index integer
---
---**READ-ONLY** Selected in the pattern editor or mixer.
---@field selected_track renoise.Track
---@field selected_track_observable renoise.Document.Observable
---@field selected_track_index integer
---@field selected_track_index_observable renoise.Document.Observable
---
---**READ-ONLY** Selected in the track DSP chain editor.
---@field selected_track_device renoise.AudioDevice?
---@field selected_track_device_observable renoise.Document.Observable
---@field selected_track_device_index integer
---
---@deprecated **READ-ONLY** alias for new 'selected_track_device' property
---@field selected_device renoise.AudioDevice?
---@field selected_device_observable renoise.Document.Observable
---@field selected_device_index integer
---
---@deprecated **READ-ONLY** alias for new 'selected_automation_parameter' property
---@field selected_parameter renoise.DeviceParameter?
---@field selected_parameter_observable renoise.Document.Observable
---
---Selected parameter in the automation editor.
---When setting a new parameter, parameter must be automateable and
---must be one of the currently selected track device chain.
---@field selected_automation_parameter renoise.DeviceParameter?
---@field selected_automation_parameter_observable renoise.Document.Observable
---**READ-ONLY** parent device of 'selected_automation_parameter'. not settable.
---@field selected_automation_device renoise.AudioDevice?
---@field selected_automation_device_observable renoise.Document.Observable
---
---**READ-ONLY** The currently edited pattern.
---@field selected_pattern renoise.Pattern
---@field selected_pattern_observable renoise.Document.Observable
---**READ-ONLY** The currently edited pattern index.
---@field selected_pattern_index integer
---@field selected_pattern_index_observable renoise.Document.Observable
---
---**READ-ONLY** The currently edited pattern track object.
---and selected_track_observable for notifications.
---@field selected_pattern_track renoise.PatternTrack
---@field selected_pattern_track_observable renoise.Document.Observable
---
---The currently edited sequence position.
---@field selected_sequence_index integer
---@field selected_sequence_index_observable renoise.Document.Observable
---
---**READ-ONLY** The currently edited line in the edited pattern.
---@field selected_line renoise.PatternLine
---@field selected_line_index integer
---
---**READ-ONLY** The currently edited column in the selected line in the edited
---sequence/pattern. Nil when an effect column is selected.
---@field selected_note_column renoise.NoteColumn?
---@field selected_note_column_index integer
---
---**READ-ONLY** The currently edited column in the selected line in the edited
---sequence/pattern. Nil when a note column is selected.
---@field selected_effect_column renoise.EffectColumn?
---@field selected_effect_column_index integer
---
---**READ-ONLY** The currently edited sub column type within the selected
---note/effect column.
---@field selected_sub_column_type renoise.Song.SubColumnType
---
---Read/write access to the selection in the pattern editor.
---
---Line indexes are valid from 1 to patterns[].number_of_lines
---Track indexes are valid from 1 to #tracks
---Column indexes are valid from 1 to
---  (tracks[].visible_note_columns + tracks[].visible_effect_columns)
---
---When setting the selection, all members are optional. Combining them in
---various different ways will affect how specific the selection is. When
---`selection_in_pattern` returns nil or is set to nil, no selection is present.
---
---### examples:
---```lua
---renoise.song().selection_in_pattern = {}
---  --> clear
---renoise.song().selection_in_pattern = { start_line = 1, end_line = 4 }
---  --> select line 1 to 4, first to last track
---renoise.song().selection_in_pattern =
---  { start_line = 1, start_track = 1, end_line = 4, end_track = 1 }
---  --> select line 1 to 4, in the first track only
---```
---@field selection_in_pattern PatternSelection?
---Same as `selection_in_pattern` but for the currently selected phrase (if any).
---@field selection_in_phrase PhraseSelection?

---### functions

---Test if something in the song can be undone.
---@return boolean
function renoise.Song:can_undo() end

---Undo the last performed action. Will do nothing if nothing can be undone.
function renoise.Song:undo() end

---Test if something in the song can be redone.
---@return boolean
function renoise.Song:can_redo() end

---Redo a previously undo action. Will do nothing if nothing can be redone.
function renoise.Song:redo() end

---When modifying the song, Renoise will automatically add descriptions for
---undo/redo by looking at what first changed (a track was inserted, a pattern
---line changed, and so on). When the song is changed from an action in a menu
---entry callback, the menu entry's label will automatically be used for the
---undo description.
---If those auto-generated names do not work for you, or you want  to use
---something more descriptive, you can (!before changing anything in the song!)
---give your changes a custom undo description (like: "Generate Synth Sample")
function renoise.Song:describe_undo(description) end

---Insert a new track at the given index. Inserting a track behind or at the
---Master Track's index will create a Send Track. Otherwise, a regular track is
---created.
---@param index integer
---@return renoise.Track
function renoise.Song:insert_track_at(index) end

---Delete an existing track. The Master track can not be deleted, but all Sends
---can. Renoise needs at least one regular track to work, thus trying to
---delete all regular tracks will fire an error.
---@param index integer
function renoise.Song:delete_track_at(index) end

---Swap the positions of two tracks. A Send can only be swapped with a Send
---track and a regular track can only be swapped with another regular track.
---The Master can not be swapped at all.
---@param index1 integer
---@param index2 integer
function renoise.Song:swap_tracks_at(index1, index2) end

---Access to a single track by index. Use properties 'tracks' to iterate over
---all tracks and to query the track count.
---@param index integer
---@return renoise.Track
function renoise.Song:track(index) end

---Set the selected track to prev relative to the current track. Takes
---care of skipping over hidden tracks and wrapping around at the edges.
function renoise.Song:select_previous_track() end

---Set the selected track to next relative to the current track. Takes
---care of skipping over hidden tracks and wrapping around at the edges.
function renoise.Song:select_next_track() end

---Insert a new group track at the given index. Group tracks can only be
---inserted before the Master track.
---@param index integer
---@return renoise.GroupTrack
function renoise.Song:insert_group_at(index) end

---Add track at track_index to group at group_index by first moving it to the
---right spot to the left of the group track, and then adding it. If group_index
---is not a group track, a new group track will be created and both tracks
---will be added to it.
---@param track_index integer
---@param group_index integer
function renoise.Song:add_track_to_group(track_index, group_index) end

---Removes track from its immediate parent group and places it outside it to
---the left. Can only be called for tracks that are actually part of a group.
---@param track_index integer
function renoise.Song:remove_track_from_group(track_index) end

---Delete the group with the given index and all its member tracks.
---Index must be that of a group or a track that is a member of a group.
---@param group_index integer
function renoise.Song:delete_group_at(group_index) end

---Insert a new instrument at the given index. This will remap all existing
---notes in all patterns, if needed, and also update all other instrument links
---in the song. Can't have more than MAX_NUMBER_OF_INSTRUMENTS in a song.
---@param index integer
---@return renoise.Instrument
function renoise.Song:insert_instrument_at(index) end

---Delete an existing instrument at the given index. Renoise needs at least one
---instrument, thus trying to completely remove all instruments is not allowed.
---This will remap all existing notes in all patterns and update all other
---instrument links in the song.
---@param index integer
function renoise.Song:delete_instrument_at(index) end

---Swap the position of two instruments. Will remap all existing notes in all
---patterns and update all other instrument links in the song.
---@param index1 integer
---@param index2 integer
function renoise.Song:swap_instruments_at(index1, index2) end

---Access to a single instrument by index. Use properties 'instruments' to iterate
---over all instruments and to query the instrument count.
---@param index integer
---@return renoise.Instrument
function renoise.Song:instrument(index) end

---Captures the current instrument (selects the instrument) from the current
---note column at the current cursor pos. Changes the selected instrument
---accordingly, but does not return the result. When no instrument is present at
---the current cursor pos, nothing will be done.
function renoise.Song:capture_instrument_from_pattern() end

---Tries to captures the nearest instrument from the current pattern track,
---starting to look at the cursor pos, then advancing until an instrument is
---found. Changes the selected instrument accordingly, but does not return
---the result. When no instruments (notes) are present in the current pattern
---track, nothing will be done.
function renoise.Song:capture_nearest_instrument_from_pattern() end

---Access to a single pattern by index. Use properties 'patterns' to iterate
---over all patterns and to query the pattern count.
---@param index integer
---@return renoise.Pattern
function renoise.Song:pattern(index) end

---When rendering (see rendering, renoise.song().rendering_progress),
---the current render process is canceled. Otherwise, nothing is done.
function renoise.Song:cancel_rendering() end

---@class RenderOptions
---by default the song start.
---@field start_pos renoise.SongPos?
---by default the song end.
---@field end_pos renoise.SongPos?
---by default the players current rate.
---@field sample_rate (22050|44100|48000|88200|96000|192000)?
---by default 32.
---@field bit_depth (16|24|32)?
---by default "default".
---@field interpolation ("default"|"precise")?
---by default "high".
---@field priority ("low"|"realtime"|"high")?

---Start rendering a section of the song or the whole song to a WAV file.
---
---Rendering job will be done in the background and the call will return
---back immediately, but the Renoise GUI will be blocked during rendering. The
---passed `rendering_done_callback` function is called as soon as rendering is
---done, e.g. successfully completed.
---
---While rendering, the rendering status can be polled with the `song().rendering`
---and `song().rendering_progress` properties, for example, in idle notifier
---loops. If starting the rendering process fails (because of file IO errors for
---example), the render function will return false and the error message is set
---as the second return value. On success, only a single `true` value is
---returned.
---
---To render only specific tracks or columns, mute the undesired tracks/columns
---before starting to render.
---
---Parameter `file_name` must point to a valid, maybe already existing file. If it
---already exists, the file will be silently overwritten. The renderer will
---automatically add a ".wav" extension to the file_name, if missing.
---
---Parameter `rendering_done_callback` is ONLY called when rendering has succeeded.
---You can do something with the file you've passed to the renderer here, like
---for example loading the file into a sample buffer.
---@param options RenderOptions
---@param filename string
---@param rendering_done_callback fun()
---@return boolean success, string error?
---@overload fun(self, filename: string, rendering_done_callback: fun()): boolean, string?
function renoise.Song:render(options, filename, rendering_done_callback) end

---Load all global MIDI mappings in the song into a XRNM file.
---Returns true when loading/saving succeeded, else false and the error message.
---@param filename string
---@return boolean success, string error?
function renoise.Song:load_midi_mappings(filename) end

---Save all global MIDI mappings in the song into a XRNM file.
---Returns true when loading/saving succeeded, else false and the error message.
---@param filename string
---@return boolean success, string error?
function renoise.Song:save_midi_mappings(filename) end

---clear all MIDI mappings in the song
function renoise.Song:clear_midi_mappings() end
