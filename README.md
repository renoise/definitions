# LuaCATS definitions for the Renoise Lua API 

This is a [Renoise Tools API](https://github.com/renoise/xrnx) add-on for the [LuaLS Language Server](https://github.com/LuaLS/lua-language-server).

LuaLS provides various features for Lua in code editors, such as autocompletion, type hovers, dynamic type checking, diagnostics and more via [LuaCATS](https://github.com/LuaCATS) annotations.

## Status

This is a work in progress. Below you can see which Renoise API sections have already been converted to the LuaCATS format:

- [x] `standard.lua` *extensions of the standard Lua API in Renoise*
- [x] `renoise.lua` *main renoise namespace*
- [x] `renoise/application.lua` *renoise.Application*
- [x] `renoise/application/window.lua` *renoise.ApplicationWindow*
- [x] `renoise/document.lua` *renoise.Document.DocumentNode*
- [x] `renoise/document/observable.lua` *renoise.Document.Observable*
- [x] `renoise/tool.lua` *renoise.ScriptingTool*
- [x] `renoise/midi.lua` *renoise.Midi*
- [x] `renoise/socket.lua` *renoise.Socket*
- [x] `renoise/osc.lua` *renoise.OsctingTool*
- [x] `renoise/song.lua` *renoise.Song*
- [x] `renoise/song/sequencer.lua` *renoise.PatternSequencer*
- [x] `renoise/song/track.lua` *renoise.Track/GroupTrack*
- [x] `renoise/song/transport.lua` *renoise.Transport*
- [x] `renoise/song/device.lua` *renoise.AudioDevice and renoise.DeviceParameter*
- [x] `renoise/song/instrument.lua` *renoise.Instrument*
- [x] `renoise/song/instrument/phrase.lua` *renoise.InstrumentPhrase*
- [x] `renoise/song/instrument/plugin.lua` *renoise.InstrumentPluginProperties*
- [x] `renoise/song/instrument/sample.lua` *renoise.Sample/Mapping/Buffer*
- [x] `renoise/song/instrument/sample_modulation.lua` *renoise.SampleModulationSet/Device*
- [x] `renoise/song/instrument/sample_device_chain.lua` *renoise.SampleDeviceChain*
- [x] `renoise/song/instrument/macro.lua` *renoise.InstrumentMacro/Mapping*
- [x] `renoise/song/instrument/midi_input.lua` *renoise.InstrumentMidiInputProperties*
- [x] `renoise/song/instrument/midi_output.lua` *renoise.InstrumentMidiOutputProperties*
- [x] `renoise/song/pattern.lua` *renoise.Pattern*
- [x] `renoise/song/pattern/line.lua` *renoise.PatternLine/Column*
- [x] `renoise/song/pattern/track.lua` *renoise.PatternTrack*
- [x] `renoise/song/pattern/automation.lua` *renoise.PatternTrackAutomation*
- [x] `renoise/song/pattern_iterator.lua` *renoise.PatternIterator*
- [x] `renoise/view_builder.lua` *renoise.Views & Widgets*

## Usage

To use the definition in e.g. VSCode, first install the **sumneko.lua vscode extension** as described here:
https://luals.github.io/#vscode-install

Then clone or download a copy of this repository, and configure your workspace to use the Renoise definition files:

```json
// .vscode/settings.json:
{
    "Lua.workspace.library": ["PATH/TO/RENOISE_DEFINITION_FOLDER"]
}
```

## Contribute

Contributions are welcome!

Please report issues [here](https://github.com/renoise/definitions/issues) or fork the latest git repository and create a feature or bugfix branch.
