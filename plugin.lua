--- LuaLS plugin to add [Luabind class](https://luabind.sourceforge.net/docs.html#class_lua) support.
--- Part of the [Renoise Lua API definitions](https://github.com/renoise/definitions). 
---
--- To use it in your workspace, set the LuaLS "Lua.runtime.plugin" to "PATH_TO_THIS/plugin.lua"
--- See [LuaLS Settings](https://luals.github.io/wiki/settings/#runtimeplugin)

local str_find = string.find
local str_sub = string.sub
local str_gmatch = string.gmatch

print("RNS class plugin: loading...")

function OnSetText(uri, text)
    -- print("RNS class plugin:", uri)

    -- ignore .vscode dir, extension files (i.e. natives), and other meta files
    if str_find(uri, "[\\/]%.vscode[\\/]") or str_sub(text, 1, 8) == "---@meta" then
        return
    end

    local diffs = {}

    -- add class annotation and global class table registration for luabind classes
    -- detects:
    --   class "SomeClass"
    --   class "SomeClass" (OptionalBaseClass)
    -- and then adds:
    -- ---@class SomeClass : OptionalBaseClass
    -- SomeClass = {}
    for pos, comments, class, rest in str_gmatch(text, "()(%-?%-?)[ \t]*class[ \t]*['\"]([^'^\"^\n]+)['\"]([^\n]*)\n") do
        -- print("RNS class plugin:", pos, comments, class, rest)
        if comments == "" then
            local base_class = string.match(rest, "%s*%(([^%(^%)]+)%)")
            if base_class then
                table.insert(diffs, {
                    start = pos,
                    finish = pos - 1,
                    text = ("\n---@class %s : %s\n%s = {}\n"):format(class, base_class, class),
                })
            else
                table.insert(diffs, {
                    start = pos,
                    finish = pos - 1,
                    text = ("\n---@class %s\n%s = {}\n"):format(class, class),
                })
            end
        end
    end

    return diffs
end
