--------------------------------------------------------------------------------
-- renoise.Transport
--------------------------------------------------------------------------------

-------- Constants

renoise.Transport.PLAYMODE_RESTART_PATTERN
renoise.Transport.PLAYMODE_CONTINUE_PATTERN

renoise.Transport.RECORD_PARAMETER_MODE_PATTERN
renoise.Transport.RECORD_PARAMETER_MODE_AUTOMATION

renoise.Transport.TIMING_MODEL_SPEED
renoise.Transport.TIMING_MODEL_LPB


-------- Functions

-- Panic.
renoise.song().transport:panic()

-- Mode: enum = PLAYMODE
renoise.song().transport:start(mode)
-- start playing the currently edited pattern at the given line offset
renoise.song().transport:start_at(line)
-- start playing a the given renoise.SongPos (sequence pos and line)
renoise.song().transport:start_at(song_pos)

-- stop playing. when already stopped this just stops all playing notes.
renoise.song().transport:stop()

-- Immediately start playing at the given sequence position.
renoise.song().transport:trigger_sequence(sequence_pos)
-- Append the sequence to the scheduled sequence list. Scheduled playback
-- positions will apply as soon as the currently playing pattern play to end.
renoise.song().transport:add_scheduled_sequence(sequence_pos)
-- Replace the scheduled sequence list with the given sequence.
renoise.song().transport:set_scheduled_sequence(sequence_pos)

-- Move the block loop one segment forwards, when possible.
renoise.song().transport:loop_block_move_forwards()
-- Move the block loop one segment backwards, when possible.
renoise.song().transport:loop_block_move_backwards()

-- Start a new sample recording when the sample dialog is visible,
-- otherwise stop and finish it.
renoise.song().transport:start_stop_sample_recording()
-- Cancel a currently running sample recording when the sample dialog
-- is visible, otherwise do nothing.
renoise.song().transport:cancel_sample_recording()


-------- Properties

-- Playing.
renoise.song().transport.playing, _observable
  -> [boolean]

-- Old school speed or new LPB timing used?
-- With TIMING_MODEL_SPEED, tpl is used as speed factor. The lpb property 
-- is unused then. With TIMING_MODEL_LPB, tpl is used as event rate for effects
-- only and lpb defines relationship between pattern lines and beats.
renoise.song().transport.timing_model
  -> [read-only, enum = TIMING_MODEL]

-- BPM, LPB, and TPL.
renoise.song().transport.bpm, _observable
  -> [number, 32-999]
renoise.song().transport.lpb, _observable
  -> [number, 1-256]
renoise.song().transport.tpl, _observable
  -> [number, 1-16]
 
-- Playback position.
renoise.song().transport.playback_pos
  -> [renoise.SongPos object]
renoise.song().transport.playback_pos_beats
  -> [number, 0-song_end_beats]

-- Edit position.
renoise.song().transport.edit_pos
  -> [renoise.SongPos object]
renoise.song().transport.edit_pos_beats
  -> [number, 0-sequence_length]

-- Song length.
renoise.song().transport.song_length
  -> [read-only, SongPos]
renoise.song().transport.song_length_beats
  -> [read-only, number]

-- Loop.
renoise.song().transport.loop_start
  -> [read-only, SongPos]
renoise.song().transport.loop_end
  -> [read-only, SongPos]
renoise.song().transport.loop_range[]
  -> [array of two renoise.SongPos objects]

renoise.song().transport.loop_start_beats
  -> [read-only, number within 0-song_end_beats]
renoise.song().transport.loop_end_beats
  -> [read-only, number within 0-song_end_beats]
renoise.song().transport.loop_range_beats[]
  -> [array of two numbers, 0-song_end_beats]

renoise.song().transport.loop_sequence_start
  -> [read-only, 0 or 1-sequence_length]
renoise.song().transport.loop_sequence_end
  -> [read-only, 0 or 1-sequence_length]
renoise.song().transport.loop_sequence_range[]
  -> [array of two numbers, 0 or 1-sequence_length or empty to disable]

renoise.song().transport.loop_pattern, _observable
  -> [boolean]

renoise.song().transport.loop_block_enabled
  -> [boolean]
renoise.song().transport.loop_block_start_pos
  -> [read-only, renoise.SongPos object]
renoise.song().transport.loop_block_range_coeff
  -> [number, 2-16]

-- Edit modes.
renoise.song().transport.edit_mode, _observable
  -> [boolean]
renoise.song().transport.edit_step, _observable
  -> [number, 0-64]
renoise.song().transport.octave, _observable
  -> [number, 0-8]

-- Metronome.
renoise.song().transport.metronome_enabled, _observable
  -> [boolean]
renoise.song().transport.metronome_beats_per_bar, _observable
  -> [1-16]
renoise.song().transport.metronome_lines_per_beat, _observable
  -> [number, 1-256 or 0 = songs current LPB]

-- Metronome precount.
renoise.song().transport.metronome_precount_enabled, _observable
  -> [boolean]
renoise.song().transport.metronome_precount_bars, _observable
  -> [number, 1-4]


-- Quantize.
renoise.song().transport.record_quantize_enabled, _observable
  -> [boolean]
renoise.song().transport.record_quantize_lines, _observable
  -> [number, 1-32]

-- Record parameter.
renoise.song().transport.record_parameter_mode, _observable
  -> [enum = RECORD_PARAMETER_MODE]

-- Follow, wrapped pattern, single track modes.
renoise.song().transport.follow_player, _observable
  -> [boolean]
renoise.song().transport.wrapped_pattern_edit, _observable
  -> [boolean]
renoise.song().transport.single_track_edit_mode, _observable
  -> [boolean]

-- Groove. (aka Shuffle)
renoise.song().transport.groove_enabled, _observable
  -> [boolean]
renoise.song().transport.groove_amounts[]
  -> [array of numbers, 0.0-1.0]
-- Attach notifiers that will be called as soon as any
-- groove amount value changed.
renoise.song().transport.groove_assignment_observable
  -> [renoise.Document.Observable object]

-- Global Track Headroom.
-- To convert to dB:   dB = math.lin2db(renoise.song().transport.track_headroom)
-- To convert from dB: renoise.song().transport.track_headroom = math.db2lin(dB)
renoise.song().transport.track_headroom, _observable
  -> [number, math.db2lin(-12)-math.db2lin(0)]  
  
-- Computer Keyboard Velocity.
-- Will return the default value of 127 when keyboard_velocity_enabled == false.
renoise.song().transport.keyboard_velocity_enabled, _observable
  -> [boolean] 
renoise.song().transport.keyboard_velocity, _observable
  -> [number, 0-127]  