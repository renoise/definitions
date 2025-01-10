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

### How to install into Sublime Text using macOS & Homebrew

1. If you have Homebrew installed, launch the Terminal and type in `brew install lua-language-server`
2. Type in `which lua-language-server` and copy the path to the clipboard / textfile, example: `/opt/homebrew/bin/lua-language-server`
3. If you have Git installed, clone this repository to a folder ( navigate to where you want it to be added to, and type `git clone https://github.com/renoise/definitions`, example: `/Users/yourusername/work/definitions` 
4. If you already have Sublime Text installed, launch Sublime Text.
5. Navigate to `Tools -> Command Palette` from the Top Menu
6. Type in `Package Control -> Install Package`
7. Type in `LSP-lua`
8. LSP-lua installs
9. Go to `Sublime Text -> Settings... -> Package Settings -> LSP -> Settings` from the Top Menu
10. Two instances of  `LSP.sublime-settings` file open. Select the second one (the User one), and paste in something similar to this, making sure the paths match to what you have on your computer:
```
// In "LSP.sublime-settings - User"
{
  "clients": {
    "lua-ls": {
      "enabled": true,
      "command": [
        // Single binary from Homebrew
        "/opt/homebrew/bin/lua-language-server"
      ],
      "selector": "source.lua",
      // Optionally set additional settings:
      "settings": {
        "Lua": {
          "workspace": {
            // Add your Renoise definitions so they're treated like built-in libraries
            "library": {
              "/Users/yourusername/work/definitions": true
            },
            "maxPreload": 2000,
            "preloadFileSize": 500
          },
          "completion": {
            "callSnippet": "Replace"
          },
          "diagnostics": {
            // If 'renoise' is a global, define it so you don't get "undefined global" errors
            "globals": ["renoise"]
          }
        }
      }
    }
  }
}
```
11. Save.
12. Add your current tool folder via `Project -> Add Folder to Project...` from the Top Menu
13. Add the `definitions` folder via `Project -> Add Folder to Project...` from the Top Menu
14. Save your Project (which you've added your Renoise LUA script tool folder to) ( `Project -> Save Project...` from the Top Menu)
15. Go to `Project -> Edit Project` from the Top Menu.
Change the following
```
{
	"folders":
	[
		{
			"path": "Renoise/Tools/yourtool.xrnx",
		},
    {
			"path": "/Users/yourusername/definitions"
		},
  ]
}
```
to this:
```
{
	"folders":
	[
		{
			"path": "Renoise/Tools/yourtool.xrnx",
		},
    {
			"path": "/Users/yourusername/definitions"
		},
  ],
  "settings": {
    "LSP": {
      "lua-ls": {
        "enabled": true,
        "command": [
          "/opt/homebrew/bin/lua-language-server"
        ],
        "selector": "source.lua",
        "settings": {
          "Lua": {
            "workspace": {
              "library": {
                "/Users/yourusername/definitions": true,
              },
            },
            "diagnostics": {
              "globals": ["renoise"],
            },
          },
        },
      },
    },
  },	
}

``` 
16. Restart Sublime Text
17. Open a .LUA file from within the Project.

Enjoy.

## Contribute

Contributions are welcome!

Please report issues [here](https://github.com/renoise/definitions/issues) or fork the latest git repository and create a feature or bugfix branch.
