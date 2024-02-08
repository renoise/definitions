--------------------------------------------------------------------------------
-- renoise.Sample
--------------------------------------------------------------------------------

-------- Constants

renoise.Sample.INTERPOLATE_NONE
renoise.Sample.INTERPOLATE_LINEAR
renoise.Sample.INTERPOLATE_CUBIC
renoise.Sample.INTERPOLATE_SINC

renoise.Sample.BEAT_SYNC_REPITCH
renoise.Sample.BEAT_SYNC_PERCUSSION
renoise.Sample.BEAT_SYNC_TEXTURE

renoise.Sample.NEW_NOTE_ACTION_NOTE_CUT
renoise.Sample.NEW_NOTE_ACTION_NOTE_OFF
renoise.Sample.NEW_NOTE_ACTION_SUSTAIN

renoise.Sample.LOOP_MODE_OFF
renoise.Sample.LOOP_MODE_FORWARD
renoise.Sample.LOOP_MODE_REVERSE
renoise.Sample.LOOP_MODE_PING_PONG


-------- Functions

-- Reset, clear all sample settings and sample data.
renoise.song().instruments[].samples[]:clear()

-- Copy all settings, including sample data from another sample.
renoise.song().instruments[].samples[]:copy_from(
  other renoise.Sample object)

-- Insert a new slice marker at the given sample position. Only samples in
-- the first sample slot may use slices. Creating slices will automatically
-- create sample aliases in the following slots: read-only sample slots that 
-- play the sample slice and are mapped to notes. Sliced sample lists can not 
-- be modified manually then. To update such aliases, modify the slice marker 
-- list instead. 
-- Existing 0S effects or notes will be updated to ensure that the old slices
-- are played back just as before.
renoise.song().instruments[].samples[]:insert_slice_marker(marker_sample_pos)
-- Delete an existing slice marker. marker_sample_pos must point to an existing
-- marker. See also property 'samples[].slice_markers'. Existing 0S effects or 
-- notes will be updated to ensure that the old slices are played back just as 
-- before.
renoise.song().instruments[].samples[]:delete_slice_marker(marker_sample_pos)
-- Change the sample position of an existing slice marker. see also property 
-- 'samples[].slice_markers'.
-- When moving a marker behind or before an existing other marker, existing 0S
-- effects or notes will automatically be updated to ensure that the old slices
-- are played back just as before.
renoise.song().instruments[].samples[]:move_slice_marker(
  old_marker_pos, new_marker_pos)

    
-------- Properties

-- True, when the sample slot is an alias to a sliced master sample. Such sample 
-- slots are read-only and automatically managed with the master samples slice 
-- list.
renoise.song().instruments[].samples[].is_slice_alias 
  -> [read-only, boolean]
    
-- Read/write access to the slice marker list of a sample. When new markers are 
-- set or existing ones unset, existing 0S effects or notes to existing slices 
-- will NOT be remapped (unlike its done with the insert/remove/move_slice_marker
-- functions). See function insert_slice_marker for info about marker limitations 
-- and preconditions.
renoise.song().instruments[].samples[].slice_markers, _observable 
  -> [table of numbers, sample positions]

    
-- Name.
renoise.song().instruments[].samples[].name, _observable
  -> [string]

-- Panning, volume.
renoise.song().instruments[].samples[].panning, _observable
  -> [number, 0.0-1.0]
renoise.song().instruments[].samples[].volume, _observable
  -> [number, 0.0-4.0]

-- Tuning.
renoise.song().instruments[].samples[].transpose, _observable
  -> [number, -120-120]
renoise.song().instruments[].samples[].fine_tune, _observable
  -> [number, -127-127]

-- Beat sync.
renoise.song().instruments[].samples[].beat_sync_enabled, _observable
  -> [boolean]
renoise.song().instruments[].samples[].beat_sync_lines, _observable
  -> [number, 1-512]
renoise.song().instruments[].samples[].beat_sync_mode, _observable
  -> [enum = BEAT_SYNC]

-- Interpolation, new note action, oneshot, mute_group, autoseek, autofade.
renoise.song().instruments[].samples[].interpolation_mode, _observable
  -> [enum = INTERPOLATE]
renoise.song().instruments[].samples[].oversample_enabled, _observable 
  -> [boolean]

renoise.song().instruments[].samples[].new_note_action, _observable
  -> [enum = NEW_NOTE_ACTION]
renoise.song().instruments[].samples[].oneshot, _observable 
  -> [boolean]
renoise.song().instruments[].samples[].mute_group, _observable 
  -> [number, 0-15 with 0=none]
renoise.song().instruments[].samples[].autoseek, _observable
  -> [boolean]
renoise.song().instruments[].samples[].autofade, _observable
  -> [boolean]

-- Loops.
renoise.song().instruments[].samples[].loop_mode, _observable
  -> [enum = LOOP_MODE]
renoise.song().instruments[].samples[].loop_release, _observable
  -> [boolean]
renoise.song().instruments[].samples[].loop_start, _observable
  -> [number, 1-num_sample_frames]
renoise.song().instruments[].samples[].loop_end, _observable
  -> [number, 1-num_sample_frames]

-- The linked modulation set. 0 when disable, else a valid index for the
-- instruments[].sample_modulation_sets table
renoise.song().instruments[].sample[].modulation_set_index, _observable 
  -> [number]
  
-- The linked instrument device chain. 0 when disable, else a valid index for the
-- instruments[].sample_device_chain table
renoise.song().instruments[].sample[].device_chain_index, _observable 
  -> [number]

-- Buffer.
renoise.song().instruments[].samples[].sample_buffer, _observable
  -> [read-only, renoise.SampleBuffer object]

-- Keyboard Note/velocity mapping
renoise.song().instruments[].samples[].sample_mapping
  -> [read-only, renoise.SampleMapping object]


--------------------------------------------------------------------------------
-- renoise.SampleMapping
--------------------------------------------------------------------------------

-- General remarks: Sample mappings of sliced samples are read-only: can not be
-- modified. See `sample_mappings[].read_only`

-------- Properties

-- True for sliced instruments. No sample mapping properties are allowed to 
-- be modified, but can be read.
renoise.song().instruments[].sample_mappings[].read_only
  -> [read-only, boolean]
  
-- Linked sample.
renoise.song().instruments[].sample_mappings[].sample
  -> [renoise.Sample object]

-- Mapping's layer (triggered via Note-Ons or Note-Offs?).
renoise.song().instruments[].sample_mappings[].layer, _observable
  -> [enum = renoise.Instrument.LAYER]

-- Mappings velocity->volume and key->pitch options.
renoise.song().instruments[].sample_mappings[].map_velocity_to_volume, _observable 
  -> [boolean]
renoise.song().instruments[].sample_mappings[].map_key_to_pitch, _observable 
  -> [boolean]

-- Mappings base-note. Final pitch of the played sample is:
--   played_note - mapping.base_note + sample.transpose + sample.finetune
renoise.song().instruments[].sample_mappings[].base_note, _observable 
  -> [number (0-119, c-4=48)]

-- Note range the mapping is triggered for.
renoise.song().instruments[].sample_mappings[].note_range, _observable 
  -> [table with two numbers (0-119, c-4=48)]

-- Velocity range the mapping is triggered for.
renoise.song().instruments[].sample_mappings[].velocity_range, _observable 
  -> [table with two numbers (0-127)]

--------------------------------------------------------------------------------
-- renoise.SampleBuffer
--------------------------------------------------------------------------------

-------- Constants

renoise.SampleBuffer.CHANNEL_LEFT
renoise.SampleBuffer.CHANNEL_RIGHT
renoise.SampleBuffer.CHANNEL_LEFT_AND_RIGHT


-------- Functions

-- Create new sample data with the given rate, bit-depth, channel and frame
-- count. Will trash existing sample data. Initial buffer is all zero.
-- Will only return false when memory allocation fails (you're running out
-- of memory). All other errors are fired as usual.
renoise.song().instruments[].samples[].sample_buffer:create_sample_data(
  sample_rate, bit_depth, num_channels, num_frames)
    -> [boolean, success]
-- Delete existing sample data.
renoise.song().instruments[].samples[].sample_buffer:delete_sample_data()

-- Read access to samples in a sample data buffer.
renoise.song().instruments[].samples[].sample_buffer:sample_data(
  channel_index, frame_index)
  -> [number -1-1]

-- Write access to samples in a sample data buffer. New samples values must be
-- within [-1, 1] and will be clipped automatically. Sample buffers may be 
-- read-only (see property 'read_only'). Attempts to write on such buffers 
-- will result into errors.
-- IMPORTANT: before modifying buffers, call 'prepare_sample_data_changes'.
-- When you are done, call 'finalize_sample_data_changes' to generate undo/redo
-- data for your changes and update sample overview caches!
renoise.song().instruments[].samples[].sample_buffer:set_sample_data(
  channel_index, frame_index, sample_value)

-- To be called once BEFORE sample data gets manipulated via 'set_sample_data'.
-- This will prepare undo/redo data for the whole sample. See also
-- 'finalize_sample_data_changes'.
renoise.song().instruments[].samples[].sample_buffer:prepare_sample_data_changes()
-- To be called once AFTER the sample data is manipulated via 'set_sample_data'.
-- This will create undo/redo data for the whole sample, and also  update the
-- sample view caches for the sample. The reason this isn't automatically
-- invoked is to avoid performance overhead when changing sample data 'sample by
-- sample'. Don't forget to call this after any data changes, or changes may not
-- be visible in the GUI and can not be un/redone!
renoise.song().instruments[].samples[].sample_buffer:finalize_sample_data_changes()

-- Load sample data from a file. Files can be any audio format Renoise supports.
-- Possible errors are shown to the user, otherwise success is returned.
renoise.song().instruments[].samples[].sample_buffer:load_from(filename)
  -> [boolean, success]
-- Export sample data to a file. Possible errors are shown to the user,
-- otherwise success is returned. Valid export types are 'wav' or 'flac'.
renoise.song().instruments[].samples[].sample_buffer:save_as(filename, format)
  -> [boolean, success]


-------- Properties

-- Has sample data?
renoise.song().instruments[].samples[].sample_buffer.has_sample_data
  -> [read-only, boolean]

-- _NOTE: All following properties are invalid when no sample data is present,
-- 'has_sample_data' returns false:_

-- True, when the sample buffer can only be read, but not be modified. true for
-- sample aliases of sliced samples. To modify such sample buffers, modify the 
-- sliced master sample buffer instead.
renoise.song().instruments[].samples[].sample_buffer.read_only
  -> [read-only, boolean]
  
-- The current sample rate in Hz, like 44100.
renoise.song().instruments[].samples[].sample_buffer.sample_rate
  -> [read-only, number]

-- The current bit depth, like 32, 16, 8.
renoise.song().instruments[].samples[].sample_buffer.bit_depth
  -> [read-only, number]

-- The number of sample channels (1 or 2)
renoise.song().instruments[].samples[].sample_buffer.number_of_channels
  -> [read-only, number]

-- The sample frame count (number of samples per channel)
renoise.song().instruments[].samples[].sample_buffer.number_of_frames
  -> [read-only, number]

-- The first sample displayed in the sample editor view. Set together with
-- DisplayLength to control zooming.
renoise.song().instruments[].samples[].sample_buffer.display_start, _observable
  -> [number >= 1 <= number_of_frames]

-- The number of samples displayed in the sample editor view. Set together with
-- DisplayStart to control zooming.
renoise.song().instruments[].samples[].sample_buffer.display_length, _observable
  -> [number >= 1 <= number_of_frames]

-- The start and end points of the sample editor display.
renoise.song().instruments[].samples[].sample_buffer.display_range[], _observable
  -> [array of two numbers, 1-number_of_frames]

-- The vertical zoom level where 1.0 is fully zoomed out.
renoise.song().instruments[].samples[].sample_buffer.vertical_zoom_factor, _observable
   -> [number, 0.0-1.0]

-- Selection range as visible in the sample editor. always valid. returns the entire
-- buffer when no selection is present in the UI.
renoise.song().instruments[].samples[].sample_buffer.selection_start, _observable
  -> [number >= 1 <= number_of_frames]
renoise.song().instruments[].samples[].sample_buffer.selection_end, _observable
  -> [number >= 1 <= number_of_frames]
renoise.song().instruments[].samples[].sample_buffer.selection_range[], _observable
  -> [array of two numbers, 1-number_of_frames]

-- The selected channel.
renoise.song().instruments[].samples[].sample_buffer.selected_channel, _observable
  -> [enum = CHANNEL_LEFT, CHANNEL_RIGHT, CHANNEL_LEFT_AND_RIGHT]
