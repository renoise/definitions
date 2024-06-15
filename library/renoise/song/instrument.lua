---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Instrument

---@class renoise.Instrument
renoise.Instrument = {}

---### constants

renoise.Instrument.NUMBER_OF_MACROS = 8
renoise.Instrument.MAX_NUMBER_OF_PHRASES = 126

---@enum renoise.Instrument.Tab
renoise.Instrument = {
  TAB_SAMPLES = 1,
  TAB_PLUGIN = 2,
  TAB_EXT_MIDI = 3,
}

---@enum renoise.Instrument.PhrasePlaybackMode
renoise.Instrument = {
  PHRASES_OFF = 1,
  PHRASES_PLAY_SELECTIVE = 2,
  PHRASES_PLAY_KEYMAP = 3,
}

---@enum renoise.Instrument.Layer
renoise.Instrument = {
  LAYER_NOTE_DISABLED = 0,
  LAYER_NOTE_ON = 1,
  LAYER_NOTE_OFF = 2,
}

---@enum renoise.Instrument.OverlapMode
renoise.Instrument = {
  OVERLAP_MODE_ALL = 0,
  OVERLAP_MODE_CYCLED = 1,
  OVERLAP_MODE_RANDOM = 2,
}

---### properties

---@class renoise.Instrument
---
---Currently active tab in the instrument GUI (samples, plugin or MIDI).
---@see renoise.
---@field active_tab renoise.Instrument.Tab
---@field active_tab_observable renoise.Document.Observable
--
---Instrument's name.
---@field name string
---@field name_observable renoise.Document.Observable
--
---Instrument's comment list. See renoise.song().comments for more info on
---how to get notified on changes and how to change it.
---@field comments string[]
---@field comments_observable renoise.Document.Observable
--
---Notifier which is called as soon as any paragraph in the comments change.
---@field comments_assignment_observable renoise.Document.Observable
--
---Set this to true to show the comments dialog after loading a song
---@field show_comments_after_loading  boolean
---@field show_comments_after_loading_observable renoise.Document.Observable
---
---Macro parameter pane visibility in the GUI.
---@field macros_visible boolean
---@field macros_visible_observable renoise.Document.Observable
---
---**READ-ONLY** Macro parameters. Array with size Instrument.NUMBER_OF_MACROS.
---@field macros renoise.InstrumentMacro[]
---
---Access the MIDI pitch-bend macro
---@field pitchbend_macro renoise.InstrumentMacro
---
---Access the MIDI modulation-wheel macro
---@field modulation_wheel_macro renoise.InstrumentMacro
---
---Access the MIDI channel pressure macro
---@field channel_pressure_macro renoise.InstrumentMacro
---
---Global linear volume of the instrument. Applied to all samples, MIDI and
---plugins in the instrument.
---@field volume number Range: (0 - math.db2lin(6))
---@field volume_observable renoise.Document.Observable
---
---Range: (-120 - 120). Global relative pitch in semi tones.
---Applied to all samples, MIDI and plugins in the instrument.
---@field transpose integer
---@field transpose_observable renoise.Document.Observable
---
---Global trigger options (quantization and scaling options).
---@field trigger_options renoise.InstrumentTriggerOptions
---
---Sample mapping's overlap trigger mode.
---@field sample_mapping_overlap_mode renoise.Instrument.OverlapMode
---@field sample_mapping_overlap_mode_observable renoise.Document.Observable
---
---Phrase editor pane visibility in the GUI.
---@field phrase_editor_visible boolean
---@field phrase_editor_visible_observable renoise.Document.Observable
---
---Phrase playback.
---@field phrase_playback_mode renoise.Instrument.PhrasePlaybackMode
---@field phrase_playback_mode_observable renoise.Document.Observable
---
---Phrase playback program: 0 = Off, 1-126 = specific phrase, 127 = keymap.
---@field phrase_program integer
---@field phrase_program_observable renoise.Document.Observable
---
---**READ-ONLY** Phrases.
---@field phrases renoise.InstrumentPhrase[]
---@field phrases_observable renoise.Document.ObservableList
---
---**READ-ONLY** Phrase mappings.
---@field phrase_mappings renoise.InstrumentPhraseMapping[]
---@field phrase_mappings_observable renoise.Document.ObservableList
---
---**READ-ONLY** Samples slots.
---@field samples renoise.Sample[]
---@field samples_observable renoise.Document.ObservableList
---
---**READ-ONLY**
---Sample mappings (key/velocity to sample slot mappings).
---sample_mappings[LAYER_NOTE_ON/OFF][]. Sample mappings also can
---be accessed via ---@field samples[].sample_mapping
---@field sample_mappings renoise.SampleMapping[]
---@field sample_mappings_observable renoise.Document.ObservableList
---
---**READ-ONLY** Sample modulation sets.
---@field sample_modulation_sets renoise.SampleModulationSet[]
---@field sample_modulation_sets_observable renoise.Document.ObservableList
---
---**READ-ONLY** Sample device chains.
---@field sample_device_chains renoise.SampleDeviceChain[]
---@field sample_device_chains_observable renoise.Document.ObservableList
---
---**READ-ONLY** MIDI input properties.
---@field midi_input_properties renoise.InstrumentMidiInputProperties
---
---**READ-ONLY** MIDI output properties.
---@field midi_output_properties renoise.InstrumentMidiOutputProperties
---
---**READ-ONLY** Plugin properties.
---@field plugin_properties renoise.InstrumentPluginProperties

---### functions

---Reset, clear all settings and all samples.
function renoise.Instrument:clear() end

---Copy all settings from the other instrument, including all samples.
---@param instrument renoise.Instrument
function renoise.Instrument:copy_from(instrument) end

---Range: (1 - renoise.Instrument.NUMBER_OF_MACROS) 
---Access a single macro by index.
---See also property `macros`.
---@param index integer 
---@return renoise.InstrumentMacro instrument_macro
function renoise.Instrument:macro(index) end

---Insert a new phrase behind the given phrase index (1 for the first one).
---@param index integer
---@return renoise.InstrumentPhrase new_phrase
function renoise.Instrument:insert_phrase_at(index) end

---Delete a new phrase at the given phrase index.
---@param index integer
function renoise.Instrument:delete_phrase_at(index) end

---Access a single phrase by index. Use properties 'phrases' to iterate
---over all phrases and to query the phrase count.
---@param index integer
---@return renoise.InstrumentPhrase
function renoise.Instrument:phrase(index) end

---Returns true if a new phrase mapping can be inserted at the given
---phrase mapping index (see See renoise.song().instruments[].phrase_mappings).
---Passed phrase must exist and must not have a mapping yet.
---Phrase note mappings may not overlap and are sorted by note, so there
---can be max 119 phrases per instrument when each phrase is mapped to
---a single key only. To make up room for new phrases, access phrases by
---index, adjust their note_range, then call 'insert_phrase_mapping_at' again.
---@param index integer
---@return boolean
function renoise.Instrument:can_insert_phrase_mapping_at(index) end

---Insert a new phrase mapping behind the given phrase mapping index.
---The new phrase mapping will by default use the entire free (note) range
---between the previous and next phrase (if any). To adjust the note range
---of the new phrase change its 'new_phrase_mapping.note_range' property.
---@param index integer
---@param phrase renoise.InstrumentPhrase
---@return renoise.InstrumentPhraseMapping new_mapping
function renoise.Instrument:insert_phrase_mapping_at(index, phrase) end

---Delete a new phrase mapping at the given phrase mapping index.
---@param index integer
function renoise.Instrument:delete_phrase_mapping_at(index) end

---Access to a phrase note mapping by index. Use property 'phrase_mappings' to
---iterate over all phrase mappings and to query the phrase (mapping) count.
---@param index integer
---@return renoise.InstrumentPhraseMapping
function renoise.Instrument:phrase_mapping(index) end

---Insert a new empty sample. returns the new renoise.Sample object.
---Every newly inserted sample has a default mapping, which covers the
---entire key and velocity range, or it gets added as drum kit mapping
---when the instrument used a drum-kit mapping before the sample got added.
---@param index integer
---@return renoise.Sample new_sample
function renoise.Instrument:insert_sample_at(index) end

---Delete an existing sample.
---@param index integer
function renoise.Instrument:delete_sample_at(index) end

---Swap positions of two samples.
---@param index1 integer
---@param index2 integer
function renoise.Instrument:swap_samples_at(index1, index2) end

---Access to a single sample by index. Use properties 'samples' to iterate
---over all samples and to query the sample count.
---@param index integer
---@return renoise.Sample
function renoise.Instrument:sample(index) end

---Access to a sample mapping by index. Use property 'sample_mappings' to
---iterate over all sample mappings and to query the sample (mapping) count.
---@param layer renoise.Instrument.Layer
---@param index integer
---@return renoise.SampleMapping
function renoise.Instrument:sample_mapping(layer, index) end

---Insert a new modulation set at the given index
---@param index integer
---@return renoise.SampleModulationSet new_sample_modulation_set
function renoise.Instrument:insert_sample_modulation_set_at(index) end

---Delete an existing modulation set at the given index.
---@param index integer
function renoise.Instrument:delete_sample_modulation_set_at(index) end

---Swap positions of two modulation sets.
function renoise.Instrument:swap_sample_modulation_sets_at(index1, index2) end

---Access to a single sample modulation set by index. Use property
---'sample_modulation_sets' to iterate over all sets and to query the set count.
---@param index integer
---@return renoise.SampleModulationSet
function renoise.Instrument:sample_modulation_set(index) end

---Insert a new sample device chain at the given index.
---@param index integer
---@return renoise.SampleDeviceChain new_sample_device_chain
function renoise.Instrument:insert_sample_device_chain_at(index) end

---Delete an existing sample device chain at the given index.
---@param index integer
function renoise.Instrument:delete_sample_device_chain_at(index) end

---Swap positions of two sample device chains.
---@param index1 integer
---@param index2 integer
function renoise.Instrument:swap_sample_device_chains_at(index1, index2) end

---Access to a single device chain by index. Use property 'sample_device_chains'
---to iterate over all chains and to query the chain count.
---@param index integer
---@return renoise.SampleDeviceChain
function renoise.Instrument:sample_device_chain(index) end

--------------------------------------------------------------------------------
---## renoise.InstrumentTriggerOptions

---@class renoise.InstrumentTriggerOptions
renoise.InstrumentTriggerOptions = {}

---### constants

---@enum renoise.InstrumentTriggerOptions.QuantizeMode
renoise.InstrumentTriggerOptions = {
  QUANTIZE_NONE = 1,
  QUANTIZE_LINE = 2,
  QUANTIZE_BEAT = 3,
  QUANTIZE_BAR = 4,
}

---### properties

---@class renoise.InstrumentTriggerOptions
---
---**READ-ONLY** List of all available scale modes.
---@field available_scale_modes string[]
---
---Scale to use when transposing. One of 'available_scales'.
---@field scale_mode string, one of 'available_scales']
---@field scale_mode_observable renoise.Document.Observable
---
---Scale-key to use when transposing (1=C, 2=C#, 3=D, ...)
---@field scale_key integer
---@field scale_key_observable renoise.Document.Observable
---
---Trigger quantization mode.
---@field quantize renoise.InstrumentTriggerOptions.QuantizeMode
---@field quantize_observable renoise.Document.Observable
---
---Mono/Poly mode.
---@field monophonic boolean
---@field monophonic_observable renoise.Document.Observable
---
---Glide amount when monophonic. 0 == off, 255 = instant
---@field monophonic_glide integer
---@field monophonic_glide_observable renoise.Document.Observable
