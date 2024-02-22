# LuaCATS definitions for the Renoise Lua API 

<img src="https://www.renoise.com/sites/default/files/renoise_logo_0.png" alt="Renoise" height="100"/>

This is a [Renoise Tools API](https://github.com/renoise/xrnx) add-on for the [LuaLS Language Server](https://github.com/LuaLS/lua-language-server).


LuaLS provides various features for Lua in code editors, such as autocompletion, type hovers, dynamic type checking, diagnostics and more via [LuaCATS](https://github.com/LuaCATS) annotations.


## Status

*The API definitions is usable as is is now, but still a work in progress.*

Please report bugs or improvements as issues [here](https://github.com/renoise/definitions/issues) and/or create a merge request.

### Known issues

* __eq, __lt, __le meta methods can't be annotated via LuaLS at the moment. 
They are specified in `### operators` as plain comments and should be converted as soon as LuaLS supports them.

* __index meta methods currently can't be annotated via LuaLS.  
They are currently mentioned as @operator index, but won't be picked up by the language server and should be converted as soon as LuaLS supports them.

* Scripts to convert/generate a HTML doc page are missing. So no HTML version can be built from the definitions yet.
The old conversion script won't work anymore, but maybe can be used as a template, for inspirations: 
https://github.com/renoise/xrnx/tree/master/Xtra/HtmlGen

* ViewBuilder: add/remove_notifier function parameters are not yet annotated properly

* ViewBuilder: functions to create views are not yet annotated properly 


## Usage

To use the definition in e.g. vscode, first install the **sumneko.lua vscode extension** as described here:
https://luals.github.io/#vscode-install

Then clone or download a copy of this repository, and configure your workspace to use the Renoise definition files:

```json
// .vscode/settings.json:
{
    "Lua.workspace.library": ["PATH/TO/RENOISE_DEFINITION_FOLDER"],
    "Lua.runtime.plugin": "PATH/TO/RENOISE_DEFINITION_FOLDER/plugin.lua"
}
```

The "Lua.runtime.plugin" setting only is needed in order to automatically annotate the custom `class` keyword.


## Contribute

Contributions are welcome!

Please report issues [here](https://github.com/renoise/definitions/issues) or fork the latest git repository and create a feature or bugfix branch.
