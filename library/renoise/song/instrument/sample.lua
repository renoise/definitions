--------------------------------------------------------------------------------
---@class renoise.Sample
--------------------------------------------------------------------------------
--- 
---### properties
---
---True, when the sample slot is an alias to a sliced master sample. Such sample 
---slots are read-only and automatically managed with the master samples slice 
---list.
---**READ-ONLY**
---@field is_slice_alias boolean
---Read/write access to the slice marker list of a sample. When new markers are 
---set or existing ones unset, existing 0S effects or notes to existing slices 
---will NOT be remapped (unlike its done with the insert/remove/move_slice_marker
---functions). See function insert_slice_marker for info about marker limitations 
---and preconditions.
---@field slice_markers integer[]
---@field slice_markers_observable renoise.Document.Observable 
---Name.
---@field name string
---@field name_observable renoise.Document.Observable
---
---Panning, volume.
---@field panning number Range: (0.0-1.0)
---@field panning_observable renoise.Document.Observable
---@field volume number Range: (0.0-4.0)
---@field volume_observable renoise.Document.Observable
---
---Tuning.
---@field transpose integer Range: (-120-120)
---@field transpose_observable renoise.Document.Observable
---@field fine_tune integer Range: (-127-127)
---@field fine_tune_observable renoise.Document.Observable
---
---Beat sync.
---@field beat_sync_enabled boolean
---@field beat_sync_enabled_observable renoise.Document.Observable
---@field beat_sync_lines integer Range: (1-512)
---@field beat_sync_lines_observable renoise.Document.Observable
---@field beat_sync_mode renoise.Sample.BeatSyncMode
---@field beat_sync_mode_observable renoise.Document.Observable
---
---Interpolation, new note action, oneshot, mute_group, autoseek, autofade.
---@field interpolation_mode renoise.Sample.InterpolationMode
---@field interpolation_mode_observable renoise.Document.Observable
---@field oversample_enabled  boolean
---@field oversample_enabled_observable renoise.Document.Observable 
---
---@field new_note_action renoise.Sample.NewNoteActionMode
---@field new_note_action_observable renoise.Document.Observable
---@field oneshot  boolean
---@field oneshot_observable renoise.Document.Observable 
---@field mute_group  integer Range: (0-15) where 0 means no group
---@field mute_group_observable renoise.Document.Observable 
---@field autoseek boolean
---@field autoseek_observable renoise.Document.Observable
---@field autofade boolean
---@field autofade_observable renoise.Document.Observable
---
---Loops.
---@field loop_mode renoise.Sample.LoopMode
---@field loop_mode_observable renoise.Document.Observable
---@field loop_release boolean
---@field loop_release_observable renoise.Document.Observable
---@field loop_start integer Range: (1-num_sample_frames)
---@field loop_start_observable renoise.Document.Observable
---@field loop_end integer Range: (1-num_sample_frames)
---@field loop_end_observable renoise.Document.Observable
---
---The linked modulation set. 0 when disable, else a valid index for the
---renoise.Instrument.sample_modulation_sets table
---@field modulation_set_index integer
---@field modulation_set_index_observable renoise.Document.Observable 
---
---The linked instrument device chain. 0 when disable, else a valid index for the
---renoise.Instrument.sample_device_chain table
---@field device_chain_index integer
---@field device_chain_index_observable renoise.Document.Observable 
---
---**READ-ONLY**
---@field sample_buffer renoise.SampleBuffer
---@field sample_buffer_observable renoise.Document.Observable
---
---Keyboard Note/velocity mapping
---**READ-ONLY**
---@field sample_mapping renoise.SampleMapping


---### constants
---@enum renoise.Sample.InterpolationMode
renoise.Sample = {
  INTERPOLATE_NONE = 1,
  INTERPOLATE_LINEAR = 2,
  INTERPOLATE_CUBIC = 3,
  INTERPOLATE_SINC = 4,
}

---@enum renoise.Sample.LoopMode
renoise.Sample = {
  LOOP_MODE_OFF = 1,
  LOOP_MODE_FORWARD = 2,
  LOOP_MODE_REVERSE = 3,
  LOOP_MODE_PING_PONG = 4,
}

---@enum renoise.Sample.BeatSyncMode
renoise.Sample = {
  BEAT_SYNC_REPITCH = 1,
  BEAT_SYNC_PERCUSSION = 2,
  BEAT_SYNC_TEXTURE = 3,
}

---@enum renoise.Sample.NewNoteActionMode
renoise.Sample = {
  NEW_NOTE_ACTION_NOTE_CUT = 1,
  NEW_NOTE_ACTION_NOTE_OFF = 2,
  NEW_NOTE_ACTION_SUSTAIN = 3,
}

---### functions

---Reset, clear all sample settings and sample data.
function renoise.Sample:clear() end

---Copy all settings, including sample data from another sample.
---@param sample renoise.Sample
function renoise.Sample:copy_from(sample) end

---Insert a new slice marker at the given sample position. Only samples in
---the first sample slot may use slices. Creating slices will automatically
---create sample aliases in the following slots: read-only sample slots that 
---play the sample slice and are mapped to notes. Sliced sample lists can not 
---be modified manually then. To update such aliases, modify the slice marker 
---list instead. 
---Existing 0S effects or notes will be updated to ensure that the old slices
---are played back just as before.
---@param marker_sample_pos integer
function renoise.Sample:insert_slice_marker(marker_sample_pos) end
---Delete an existing slice marker. marker_sample_pos must point to an existing
---marker. See also property 'samples[].slice_markers'. Existing 0S effects or 
---notes will be updated to ensure that the old slices are played back just as 
---before.
---@param marker_sample_pos integer
function renoise.Sample:delete_slice_marker(marker_sample_pos) end
---Change the sample position of an existing slice marker. see also property 
---'samples[].slice_markers'.
---When moving a marker behind or before an existing other marker, existing 0S
---effects or notes will automatically be updated to ensure that the old slices
---are played back just as before.
---@param old_marker_pos integer
---@param new_marker_pos integer
function renoise.Sample:move_slice_marker(old_marker_pos, new_marker_pos) end


--------------------------------------------------------------------------------
---General remarks: Sample mappings of sliced samples are read-only: can not be
---modified. See `sample_mappings[].read_only`
---@class renoise.SampleMapping
--------------------------------------------------------------------------------
---
---### properties
---
---True for sliced instruments. No sample mapping properties are allowed to 
---be modified, but can be read.
---**READ-ONLY**
---@field read_only boolean 
---  
---Linked sample.
---@field sample renoise.Sample
---
---Mapping's layer (triggered via Note-Ons or Note-Offs?).
---@field layer renoise.Instrument.Layer
---@field layer_observable renoise.Document.Observable
---
---Mappings velocity->volume and key->pitch options.
---@field map_velocity_to_volume boolean
---@field map_velocity_to_volume_observable renoise.Document.Observable 
---@field map_key_to_pitch boolean
---@field map_key_to_pitch_observable renoise.Document.Observable 
---
---Mappings base-note. Final pitch of the played sample is:
---  played_note - mapping.base_note + sample.transpose + sample.finetune
---@field base_note integer  (0-119, c-4=48)]
---@field base_note_observable renoise.Document.Observable 
---
---Note range the mapping is triggered for.
---table of two integers
---@field note_range integer[] Range: (0-119) where C-4 is 48
---@field note_range_observable renoise.Document.Observable 
---
---Velocity range the mapping is triggered for.
---@field velocity_range integer[] Range: (0-127)
---@field velocity_range_observable renoise.Document.Observable 

--------------------------------------------------------------------------------
---NOTE: All properties are invalid when no sample data is present,
---'has_sample_data' returns false:
---@class renoise.SampleBuffer
--------------------------------------------------------------------------------
---
---### properties
---
---Check this before accessing properties
---**READ-ONLY**
---@field has_sample_data boolean
---
---
---**READ-ONLY**
---True, when the sample buffer can only be read, but not be modified. true for
---sample aliases of sliced samples. To modify such sample buffers, modify the 
---sliced master sample buffer instead.
---@field read_only boolean 
---**READ-ONLY**
---The current sample rate in Hz, like 44100.
---@field sample_rate integer 
---
---**READ-ONLY**
---The current bit depth, like 32, 16, 8.
---@field bit_depth integer 
---
---**READ-ONLY**
---The integer of sample channels (1 or 2)
---@field number_of_channels integer 
---
---**READ-ONLY**
---The sample frame count (integer of samples per channel)
---@field number_of_frames integer 
---
---The first sample displayed in the sample editor view. Set together with
---DisplayLength to control zooming.
---@field display_start integer Range: (1-number_of_frames)
---@field display_start_observable renoise.Document.Observable
---
---The number of samples displayed in the sample editor view. Set together with
---DisplayStart to control zooming.
---@field display_length integer Range: (1-number_of_frames)
---@field display_length_observable renoise.Document.Observable
---
---Array of two integers, the start and end points of the sample editor display.
---@field display_range integer[] Range: (1-number_of_frames)
---@field display_range_observable renoise.Document.Observable
---
---The vertical zoom level where 1.0 is fully zoomed out.
---@field vertical_zoom_factor number Range(0.0-1.0)
---@field vertical_zoom_factor_observable renoise.Document.Observable
---
---Selection range as visible in the sample editor. always valid. returns the entire
---buffer when no selection is present in the UI.
---@field selection_start integer Range: (1-number_of_frames)
---@field selection_start_observable renoise.Document.Observable
---@field selection_end integer Range: (1-number_of_frames)
---@field selection_end_observable renoise.Document.Observable
---Array of two integers
---@field selection_range integer[] Range: (1-number_of_frames)
---@field selection_range_observable renoise.Document.Observable
---
---The selected channel.
---@field selected_channel renoise.SampleBuffer.Channel
---@field selected_channel_observable renoise.Document.Observable

---### constants

---@enum renoise.SampleBuffer.Channel
renoise.SampleBuffer = {
  CHANNEL_LEFT = 1,
  CHANNEL_RIGHT = 2,
  CHANNEL_LEFT_AND_RIGHT = 3,
}

---### functions

---Create new sample data with the given rate, bit-depth, channel and frame
---count. Will trash existing sample data. Initial buffer is all zero.
---Will only return false when memory allocation fails (you're running out
---of memory). All other errors are fired as usual.
---@param sample_rate integer
---@param bit_depth integer
---@param num_channels integer
---@param num_frames integer
---@return boolean success
function renoise.SampleBuffer:create_sample_data(sample_rate, bit_depth, num_channels, num_frames) end

---Delete existing sample data.
function renoise.SampleBuffer:delete_sample_data() end

---Read access to samples in a sample data buffer.
---@param channel_index integer
---@param frame_index integer
---@return number[] values Range: (-1-1)
function renoise.SampleBuffer:sample_data(channel_index, frame_index) end

---Write access to samples in a sample data buffer. New samples values must be
---within [-1, 1] and will be clipped automatically. Sample buffers may be 
---read-only (see property 'read_only'). Attempts to write on such buffers 
---will result into errors.
---IMPORTANT: before modifying buffers, call 'prepare_sample_data_changes'.
---When you are done, call 'finalize_sample_data_changes' to generate undo/redo
---data for your changes and update sample overview caches!
---@param channel_index integer
---@param frame_index integer
---@param sample_value integer
function renoise.SampleBuffer:set_sample_data(channel_index, frame_index, sample_value) end

---To be called once BEFORE sample data gets manipulated via 'set_sample_data'.
---This will prepare undo/redo data for the whole sample. See also
---'finalize_sample_data_changes'.
function renoise.SampleBuffer:prepare_sample_data_changes() end

---To be called once AFTER the sample data is manipulated via 'set_sample_data'.
---This will create undo/redo data for the whole sample, and also  update the
---sample view caches for the sample. The reason this isn't automatically
---invoked is to avoid performance overhead when changing sample data 'sample by
---sample'. Don't forget to call this after any data changes, or changes may not
---be visible in the GUI and can not be un/redone!
function renoise.SampleBuffer:finalize_sample_data_changes() end

---Load sample data from a file. Files can be any audio format Renoise supports.
---Possible errors are shown to the user, otherwise success is returned.
---@param filename string
---@return boolean success
function renoise.SampleBuffer:load_from(filename) end

---@alias SampleBuffer.ExportType
---| '"wav"'
---| '"flac"'
---Export sample data to a file. Possible errors are shown to the user,
---otherwise success is returned. 
---@param filename string
---@param format SampleBuffer.ExportType
---@return boolean success
function renoise.SampleBuffer:save_as(filename, format) end