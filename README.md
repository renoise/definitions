# LuaCATS definitions for the Renoise Lua API 

<img src="https://www.renoise.com/sites/default/files/renoise_logo_0.png" alt="Renoise" height="100"/>

This is a [Renoise Tools API](https://github.com/renoise/xrnx) add-on for the [LuaLS Language Server](https://github.com/LuaLS/lua-language-server).


LuaLS provides various features for Lua in code editors, such as autocompletion, type hovers, dynamic type checking, diagnostics and more via [LuaCATS](https://github.com/LuaCATS) annotations.

## HTML API Docs

A pretty online API reference book based on this definition and general guide to scripting development in Renoise can be read here: [Renoise Scripting Development Book](https://renoise.github.io/xrnx)

The scripting development book, latest API definition and example tools, can be downloaded as a "scripting starter pack" bundle file from the [XRNX Repository](https://github.com/renoise/xrnx/releases).

## Status

The API definitions is usable as is is now, but still a work in progress. Please report bugs or improvements as issues here and/or create a merge request.

### Known issues

* __eq, __lt, __le meta methods can't be annotated via LuaLS at the moment. 
They are specified in `### operators` as plain comments and should be converted as soon as LuaLS supports them.

* __index meta methods currently can't be annotated via LuaLS.  
They are currently mentioned as @operator index, but won't be picked up by the language server and should be converted as soon as LuaLS supports them.

* Return types for main class constructors (`renoise.app()`, `.tool()`, `.song()` etc.) should be specified as an instance to allow the LSP to warn when trying to access non-constant properties on the classes themselves (like `renoise.Song.selected_track`).

* The LuaLS type system allows setting non-existent properties for constructor tables, which then causes runtime crash (for example `vb:text { margin = 100 }`), using [(exact)](https://luals.github.io/wiki/annotations/#class) for `@class` annotations doesn't help.

## Usage

To use the definition in e.g. vscode, first install the **sumneko.lua vscode extension** as described here:
https://luals.github.io/#vscode-install

Then clone or download a copy of this repository, and configure your workspace to use the Renoise definition files:

In your project's `/.vscode/settings.json` file, add:
```json
{
    "Lua.workspace.library": ["PATH/TO/RENOISE_DEFINITION_FOLDER"],
    "Lua.runtime.plugin": "PATH/TO/RENOISE_DEFINITION_FOLDER/plugin.lua"
}
```

Note: The `Lua.runtime.plugin` setting only is needed in order to automatically annotate the custom `class` keyword.


## Contribute

Contributions are welcome!

Please report issues [here](https://github.com/renoise/definitions/issues) or fork the latest git repository and create a feature or bugfix branch.
