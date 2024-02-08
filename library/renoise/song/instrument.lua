--------------------------------------------------------------------------------
-- renoise.Instrument
--------------------------------------------------------------------------------

-------- Constants

renoise.Instrument.TAB_SAMPLES
renoise.Instrument.TAB_PLUGIN
renoise.Instrument.TAB_EXT_MIDI

renoise.Instrument.PHRASES_OFF
renoise.Instrument.PHRASES_PLAY_SELECTIVE
renoise.Instrument.PHRASES_PLAY_KEYMAP

renoise.Instrument.LAYER_NOTE_DISABLED
renoise.Instrument.LAYER_NOTE_ON
renoise.Instrument.LAYER_NOTE_OFF

renoise.Instrument.OVERLAP_MODE_ALL
renoise.Instrument.OVERLAP_MODE_CYCLED
renoise.Instrument.OVERLAP_MODE_RANDOM

renoise.Instrument.NUMBER_OF_MACROS

renoise.Instrument.MAX_NUMBER_OF_PHRASES


-------- Functions

-- Reset, clear all settings and all samples.
renoise.song().instruments[]:clear()

-- Copy all settings from the other instrument, including all samples.
renoise.song().instruments[]:copy_from(
  other renoise.Instrument object)


-- Access a single macro by index [1-NUMBER_OF_MACROS].
-- See also property 'macros'.
renoise.song().instruments[]:macro(index) 
 -> [returns renoise.InstrumentMacro]


-- Insert a new phrase behind the given phrase index (1 for the first one).
renoise.song().instruments[]:insert_phrase_at(index) 
  -> [returns newly created renoise.InstrumentPhrase]
-- Delete a new phrase at the given phrase index.
renoise.song().instruments[]:delete_phrase_at(index)
  
-- Access a single phrase by index. Use properties 'phrases' to iterate
-- over all phrases and to query the phrase count.
renoise.song().instruments[]:phrase(index)
  -> [renoise.InstrumentPhrase object]

-- Returns true if a new phrase mapping can be inserted at the given 
-- phrase mapping index (see See renoise.song().instruments[].phrase_mappings). 
-- Passed phrase must exist and must not have a mapping yet.
-- Phrase note mappings may not overlap and are sorted by note, so there
-- can be max 119 phrases per instrument when each phrase is mapped to
-- a single key only. To make up room for new phrases, access phrases by 
-- index, adjust their note_range, then call 'insert_phrase_mapping_at' again.
renoise.song().instruments[]:can_insert_phrase_mapping_at(index) 
  -> [boolean]
-- Insert a new phrase mapping behind the given phrase mapping index.
-- The new phrase mapping will by default use the entire free (note) range 
-- between the previous and next phrase (if any). To adjust the note range 
-- of the new phrase change its 'new_phrase_mapping.note_range' property. 
renoise.song().instruments[]:insert_phrase_mapping_at(index, phrase) 
  -> [returns newly created renoise.InstrumentPhraseMapping]
-- Delete a new phrase mapping at the given phrase mapping index.
renoise.song().instruments[]:delete_phrase_mapping_at(index)

-- Access to a phrase note mapping by index. Use property 'phrase_mappings' to
-- iterate over all phrase mappings and to query the phrase (mapping) count.
renoise.song().instruments[]:phrase_mapping(index)
  -> [renoise.InstrumentPhraseMapping object]

-- Insert a new empty sample. returns the new renoise.Sample object.
-- Every newly inserted sample has a default mapping, which covers the 
-- entire key and velocity range, or it gets added as drum kit mapping 
-- when the instrument used a drum-kit mapping before the sample got added.
renoise.song().instruments[]:insert_sample_at(index)
  -> [new renoise.Sample object]
-- Delete an existing sample.
renoise.song().instruments[]:delete_sample_at(index)
-- Swap positions of two samples.
renoise.song().instruments[]:swap_samples_at(index1, index2)

-- Access to a single sample by index. Use properties 'samples' to iterate
-- over all samples and to query the sample count.
renoise.song().instruments[]:sample(index)
  -> [renoise.Sample object]

-- Access to a sample mapping by index. Use property 'sample_mappings' to
-- iterate over all sample mappings and to query the sample (mapping) count.
renoise.song().instruments[]:sample_mapping(layer, index)
  -> [renoise.SampleMapping object]

-- Insert a new modulation set at the given index
renoise.song().instruments[]:insert_sample_modulation_set_at(index) 
  -> [new renoise.SampleModulationSet object]
-- Delete an existing modulation set at the given index.
renoise.song().instruments[]:delete_sample_modulation_set_at(index)
-- Swap positions of two modulation sets.
renoise.song().instruments[]:swap_sample_modulation_sets_at(index1, index2)
  
-- Access to a single sample modulation set by index. Use property 
-- 'sample_modulation_sets' to iterate over all sets and to query the set count.
renoise.song().instruments[]:sample_modulation_set(index) 
  -> [renoise.SampleModulationSet object]

-- Insert a new sample device chain at the given index.
renoise.song().instruments[]:insert_sample_device_chain_at(index) 
  -> [returns newly created renoise.SampleDeviceChain]
-- Delete an existing sample device chain at the given index.
renoise.song().instruments[]:delete_sample_device_chain_at(index)
-- Swap positions of two sample device chains.
renoise.song().instruments[]:swap_sample_device_chains_at(index1, index2)

-- Access to a single device chain by index. Use property 'sample_device_chains' 
-- to iterate over all chains and to query the chain count.
renoise.song().instruments[]:sample_device_chain(index) 
  -> [renoise.SampleDeviceChain object]


-------- Properties

-- Currently active tab in the instrument GUI (samples, plugin or MIDI).
renoise.song().instruments[].active_tab, _observable 
  -> [enum = TAB]

-- Instrument's name.
renoise.song().instruments[].name, _observable
  -> [string]

-- Instrument's comment list. See renoise.song().comments for more info on
-- how to get notified on changes and how to change it.
renoise.song().instruments[].comments[], _observable
  -> [array of strings]
-- Notifier which is called as soon as any paragraph in the comments change.
renoise.song().instruments[].comments_assignment_observable
  -> [renoise.Document.Observable object]
-- Set this to true to show the comments dialog after loading a song
renoise.song().instruments[].show_comments_after_loading, _observable 
  -> [boolean]

-- Macro parameter pane visibility in the GUI.
renoise.song().instruments[].macros_visible, _observable
 -> [boolean]

-- Macro parameters.
renoise.song().instruments[].macros[]
  -> [read-only, array of NUMBER_OF_MACROS renoise.InstrumentMacro objects]

-- Access the MIDI pitch-bend macro
renoise.song().instruments[].pitchbend_macro 
 -> [returns renoise.InstrumentMacro]

-- Access the MIDI modulation-wheel macro
renoise.song().instruments[].modulation_wheel_macro 
 -> [returns renoise.InstrumentMacro]

-- Access the MIDI channel pressure macro
renoise.song().instruments[].channel_pressure_macro 
 -> [returns renoise.InstrumentMacro]

-- Global linear volume of the instrument. Applied to all samples, MIDI and
-- plugins in the instrument.
renoise.song().instruments[].volume, _observable
 -> [number, 0-math.db2lin(6)]

-- Global relative pitch in semi tones. Applied to all samples, MIDI and 
-- plugins in the instrument.
renoise.song().instruments[].transpose, _observable
 -> [number, -120-120]

-- Global trigger options (quantization and scaling options). 
-- See renoise.InstrumentTriggerOptions for more info.
renoise.song().instruments[].trigger_options
  -> [renoise.InstrumentTriggerOptions object]

-- Sample mapping's overlap trigger mode.
renoise.song().instruments[]:sample_mapping_overlap_mode, observable
  -> [enum=OVERLAP_MODE]


-- Phrase editor pane visibility in the GUI.
renoise.song().instruments[].phrase_editor_visible, _observable
 -> [boolean]

-- Phrase playback. See PHRASES_XXX values.
renoise.song().instruments[].phrase_playback_mode, _observable
 -> [enum=PHRASES]
-- Phrase playback program: 0 = Off, 1-126 = specific phrase, 127 = keymap.
renoise.song().instruments[].phrase_program, _observable
 -> [number]

-- Phrases.
renoise.song().instruments[].phrases[], _observable 
  -> [read-only, array of renoise.InstrumentPhrase objects]
-- Phrase mappings.
renoise.song().instruments[].phrase_mappings[], _observable 
  -> [read-only, array of renoise.InstrumentPhraseMapping objects]
  

-- Samples slots.
renoise.song().instruments[].samples[], _observable
  -> [read-only, array of renoise.Sample objects]

-- Sample mappings (key/velocity to sample slot mappings).
-- sample_mappings[LAYER_NOTE_ON/OFF][]. Sample mappings also can 
-- be accessed via renoise.song().instruments[].samples[].sample_mapping
renoise.song().instruments[].sample_mappings[], _observable
  -> [read-only, array of tables of renoise.SampleMapping objects]

-- Sample modulation sets.
renoise.song().instruments[].sample_modulation_sets, _observable
  -> [read-only, table of renoise.SampleModulationSet objects]

-- Sample device chains.
renoise.song().instruments[].sample_device_chains
  -> [read-only, table of renoise.SampleDeviceChain objects]
  
-- MIDI input properties.
renoise.song().instruments[].midi_input_properties
  -> [read-only, renoise.InstrumentMidiInputProperties object]
  
-- MIDI output properties.
renoise.song().instruments[].midi_output_properties
  -> [read-only, renoise.InstrumentMidiOutputProperties object]

-- Plugin properties.
renoise.song().instruments[].plugin_properties
  -> [read-only, renoise.InstrumentPluginProperties object]


--------------------------------------------------------------------------------
-- renoise.InstrumentTriggerOptions
--------------------------------------------------------------------------------

-------- Constants

renoise.InstrumentTriggerOptions.QUANTIZE_NONE 
renoise.InstrumentTriggerOptions.QUANTIZE_LINE
renoise.InstrumentTriggerOptions.QUANTIZE_BEAT
renoise.InstrumentTriggerOptions.QUANTIZE_BAR


-------- Properties

-- List of all available scale modes.
renoise.song().instruments[].trigger_options.available_scale_modes
  -> [read-only, table of strings]

-- Scale to use when transposing. One of 'available_scales'.
renoise.song().instruments[].trigger_options.scale_mode, _observable
  -> [string, one of 'available_scales']

-- Scale-key to use when transposing (1=C, 2=C#, 3=D, ...)
renoise.song().instruments[].trigger_options.scale_key, _observable
  -> [number]

-- Trigger quantization mode.
renoise.song().instruments[].trigger_options.quantize, _observable
  -> [enum = QUANTIZE]

-- Mono/Poly mode.
renoise.song().instruments[].trigger_options.monophonic, _observable
  -> [boolean]

-- Glide amount when monophonic. 0 == off, 255 = instant
renoise.song().instruments[].trigger_options.monophonic_glide, _observable
  -> [number]



