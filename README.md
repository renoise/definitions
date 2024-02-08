# LuaCATS definitions for the Renoise Lua API 

This is a [Renoise Tools API](https://github.com/renoise/xrnx) add-on for the [LuaLS Language Server](https://github.com/LuaLS/lua-language-server).

LuaLS provides various features for Lua in code editors, such as autocompletion, type hovers, dynamic type checking, diagnostics and more via [LuaCATS](https://github.com/LuaCATS) annotations.

## Status

This is a work in progress. Below you can see which Renoise API sections have already been converted to the LuaCATS format:

- [x] `standard.lua` *extensions of the standard Lua API in Renoise*
- [x] `renoise.lua` *main renoise namespace*
- [x] `renoise/application.lua` *renoise.Application*
- [x] `renoise/application/window.lua` *renoise.ApplicationWindow*
- [x] `renoise/document.lua` *renoise.Document*
- [x] `renoise/document/observable.lua` *renoise.Document.Observable*
- [x] `renoise/scripting_tool.lua` *renoise.ScriptingTool*
- [x] `renoise/midi.lua` *renoise.Midi*
- [x] `renoise/socket.lua` *renoise.Socket*
- [x] `renoise/osc.lua` *renoise.Osc*
- [ ] `renoise/song.lua` *renoise.Song/Track/Instrument...*
- [ ] `renoise/view_builder.lua` *renoise.View & Widgets*

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
