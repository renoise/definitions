---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Transport

---### constants

---@enum renoise.Transport.PlayMode
renoise.Transport = {
  PLAYMODE_RESTART_PATTERN = 1,
  PLAYMODE_CONTINUE_PATTERN = 2
}

---@enum renoise.Transport.RecordParameterMode
renoise.Transport = {
  RECORD_PARAMETER_MODE_PATTERN = 1,
  RECORD_PARAMETER_MODE_AUTOMATION = 2,
}

---@enum renoise.Transport.TimingModel
renoise.Transport = {
  TIMING_MODEL_SPEED = 1,
  TIMING_MODEL_LPB = 2
}

---### properties

---Transport component of the Renoise song.
---@class renoise.Transport
---
---Playing
---@field playing boolean
---@field playing_observable renoise.Document.Observable
---
---*READ-ONLY* Old school speed or new LPB timing used?
---With `TIMING_MODEL_SPEED`, tpl is used as speed factor. The lpb property
---is unused then. With `TIMING_MODEL_LPB`, tpl is used as event rate for effects
---only and lpb defines relationship between pattern lines and beats.
---@field timing_model renoise.Transport.TimingModel
---
---BPM, LPB, and TPL
---@field bpm number Range: (32 - 999) Beats per Minute
---@field bpm_observable renoise.Document.Observable
---@field lpb integer Range: (1 - 256) Lines per Beat
---@field lpb_observable renoise.Document.Observable
---@field tpl integer  Range: (1 - 16) Ticks per Line
---@field tpl_observable renoise.Document.Observable
---
---Playback position
---@field playback_pos renoise.SongPos
---@field playback_pos_beats number Range: (0 - song_end_beats) Song position in beats
---
---Edit position
---@field edit_pos renoise.SongPos
---@field edit_pos_beats number Range: (0 - song_end_beats) Song position in beats
---
---Song length
---@field song_length renoise.SongPos **READ-ONLY**
---@field song_length_beats number **READ-ONLY**
---
---Loop
---@field loop_start renoise.SongPos **READ-ONLY**
---@field loop_end renoise.SongPos **READ-ONLY**
---@field loop_range renoise.SongPos[] {loop start, loop end}
---@field loop_start_beats number **READ-ONLY** Range: (0 - song_end_beats)
---@field loop_end_beats number **READ-ONLY** Range: (0 - song_end_beats)
---@field loop_range_beats number[] {loop start beats, loop end beats}
---
---@field loop_sequence_start integer **READ-ONLY** 0 or Range: (1  -  sequence length)
---@field loop_sequence_end integer **READ-ONLY** 0 or Range: (1  -  sequence length)
---@field loop_sequence_range integer[] {} or Range(sequence start, sequence end)
---
---@field loop_pattern boolean Pattern Loop On/Off
---@field loop_pattern_observable renoise.Document.Observable
---
---@field loop_block_enabled boolean Block Loop On/Off
---@field loop_block_start_pos renoise.SongPos Start of block loop
---@field loop_block_range_coeff integer Range: (2 - 16)
---
---Edit modes
---@field edit_mode boolean
---@field edit_mode_observable renoise.Document.Observable
---@field edit_step integer Range: (0 - 64)
---@field edit_step_observable renoise.Document.Observable
---@field octave integer Range: (0 - 8)
---@field octave_observable renoise.Document.Observable
---
---Metronome
---@field metronome_enabled boolean
---@field metronome_enabled_observable renoise.Document.Observable
---@field metronome_beats_per_bar integer Range: (1 - 16)
---@field metronome_beats_per_bar_observable renoise.Document.Observable
---@field metronome_lines_per_beat integer Range: (1 - 256) or 0 = songs current LPB
---@field metronome_lines_per_beat_observable renoise.Document.Observable
---
---Metronome precount
---@field metronome_precount_enabled boolean
---@field metronome_precount_enabled_observable renoise.Document.Observable
---@field metronome_precount_bars integer Range: (1 - 4)
---@field metronome_precount_bars_observable renoise.Document.Observable
---
---Quantize
---@field record_quantize_enabled boolean
---@field record_quantize_enabled_observable renoise.Document.Observable
---@field record_quantize_lines integer Range: (1 - 32)
---@field record_quantize_lines_observable renoise.Document.Observable
---
---Record parameter
---@field record_parameter_mode renoise.Transport.RecordParameterMode
---@field record_parameter_mode_observable renoise.Document.Observable
---
---Follow, wrapped pattern, single track modes
---@field follow_player boolean
---@field follow_player_observable renoise.Document.Observable
---@field wrapped_pattern_edit boolean
---@field wrapped_pattern_edit_observable renoise.Document.Observable
---@field single_track_edit_mode boolean
---@field single_track_edit_mode_observable renoise.Document.Observable
---
---Groove. (aka Shuffle)
---@field groove_enabled boolean
---@field groove_enabled_observable renoise.Document.Observable
---@field groove_amounts number[] table with 4 numbers in Range: (0 - 1)
---Attach notifiers that will be called as soon as any groove value changed.
---@field groove_assignment_observable renoise.Document.Observable
---
---Global Track Headroom
---To convert to dB: `dB = math.lin2db(renoise.Transport.track_headroom)`
---To convert from dB: `renoise.Transport.track_headroom = math.db2lin(dB)`
---@field track_headroom number Range: (math.db2lin(-12) - math.db2lin(0))
---@field track_headroom_observable renoise.Document.Observable
---
---Computer Keyboard Velocity.
---@field keyboard_velocity_enabled boolean
---@field keyboard_velocity_enabled_observable renoise.Document.Observable
---Will return the default value of 127 when keyboard_velocity_enabled == false.
---@field keyboard_velocity integer Range: (0 - 127)
---@field keyboard_velocity_observable renoise.Document.Observable
renoise.Transport = {}

---### functions

---Panic.
function renoise.Transport:panic() end

---Start playing in song or pattern mode.
---@param mode renoise.Transport.PlayMode
function renoise.Transport:start(mode) end

---Start playing the currently edited pattern at the given line offset
---@param line integer
function renoise.Transport:start_at(line) end

---Start playing a the given renoise.SongPos (sequence pos and line)
---@param song_pos renoise.SongPos
function renoise.Transport:start_at(song_pos) end

---Stop playing. When already stopped this just stops all playing notes.
function renoise.Transport:stop() end

---Immediately start playing at the given sequence position.
---@param sequence_pos integer
function renoise.Transport:trigger_sequence(sequence_pos) end

---Append the sequence to the scheduled sequence list. Scheduled playback
---positions will apply as soon as the currently playing pattern play to end.
---@param sequence_pos integer
function renoise.Transport:add_scheduled_sequence(sequence_pos) end

---Replace the scheduled sequence list with the given sequence.
---@param sequence_pos integer
function renoise.Transport:set_scheduled_sequence(sequence_pos) end

---Move the block loop one segment forwards, when possible.
function renoise.Transport:loop_block_move_forwards() end

---Move the block loop one segment backwards, when possible.
function renoise.Transport:loop_block_move_backwards() end

---Start a new sample recording when the sample dialog is visible,
---otherwise stop and finish it.
function renoise.Transport:start_stop_sample_recording() end

---Cancel a currently running sample recording when the sample dialog
---is visible, otherwise do nothing.
function renoise.Transport:cancel_sample_recording() end
