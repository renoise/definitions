---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

-------------------------------------------------------------------------------

---All standard Lua libraries are included in Renoise as well. You can find the
---full reference here: <http://www.lua.org/manual/5.1/manual.html#5>

---## globals

---### added

---package path setup
package.path = package.path .. ';Libraries/?.lua'

---An iterator like ipairs, but in reverse order.
---@generic T: table, V
---@param table T
---@return fun(table: V[], i?: integer):integer, V
---@return T
---@return integer i
---### examples:
---```lua
---t = {"a", "b", "c"}
---for k,v in ripairs(t) do print(k, v) end -> "3 c, 2 b, 1 a"
---```
function ripairs(table) end

---Return a string which lists properties and methods of class objects.
---@param object userdata
---@return string[]
function objinfo(object) end

---Dumps properties and methods of class objects (like renoise.app()).
---@param object userdata
function oprint(object) end

---Recursively dumps a table and all its members to the std out (console).
---This works for standard Lua types and class objects as well.
---@param value any
function rprint(value) end

---Luabind "class" registration. Registers a global class object and returns a
---closure to optionally set the base class.
---
---See also [Luabind class](https://luabind.sourceforge.net/docs.html#class_lua)
---
---### examples
---```lua
------@class Animal
----- Construct a new animal with the given name.
------@overload fun(string): Animal
---Animal = {}
---class 'Animal'
---  ---@param name string
---  function Animal:__init(name)
---    self.name = name
---    self.can_fly = nil
---  end
---  function Animal:show()
---    return ("I am a %s (%s) and I %s fly"):format(self.name, type(self),
---      (self.can_fly and "can fly" or "can not fly"))
---  end
---
----- Mammal class (inherits Animal functions and members)
------@class Mammal : Animal
----- Construct a new mamal with the given name.
------@overload fun(string): Mammal
---Mammal = {}
---class 'Mammal' (Animal)
---  ---@param name string
---  function Mammal:__init(name)
---    Animal.__init(self, name)
---    self.can_fly = false
---  end
---
----- show() function and base member are available for Mammal too
---local mamal = Mammal("Cow")
---mamal:show()
---```
---@param name string
function class(name)
  -- globally register the new class as table with the given name
  local class_table = {}
  rawset(_G, name, class_table)
  -- override class table's call operator to use the class name as constructor too
  setmetatable(class_table, {
    __call = function(self, ...)
      -- create a new instance of the class
      local new_object = {}
      setmetatable(new_object, {
        __index = class_table,
      })
      -- call new class' __init function, when its present
      if rawget(class_table, "__init") then
        class_table.__init(new_object, ...)
      end
      return new_object
    end
  })
  -- return a closure which optionally sets a base class
  ---@param base table|unknown
  return function(base)
    for k, v in pairs(base) do
      class_table[k] = v
    end
  end
end

---### changed

---Returns a Renoise class object's type name. For all other types the standard
---Lua type function is used.
---@param value any|userdata
---@return string
---### examples:
---```lua
---class "MyClass"; function MyClass:__init() end
---print(type(MyClass)) -> "MyClass class"
---print(type(MyClass())) -> "MyClass"
---```
function type(value) end

---Also compares object identities of Renoise API class objects.
---For all other types the standard Lua rawequal function is used.
---### examples:
---```lua
---print(rawequal(renoise.app(), renoise.app())) --> true
---print(rawequal(renoise.song().track[1],
---renoise.song().track[1]) --> true
---print(rawequal(renoise.song().track[1],
---renoise.song().track[2]) --> false
---```
function rawequal(obj1, obj2) end

-------------------------------------------------------------------------------
---## debug

---### added

---Shortcut to remdebug.session.start(), which starts a debug session:
---launches the debugger controller and breaks script execution. See
---"Debugging.md" in the documentation root folder for more info.
function debug.start() end

---Shortcut to remdebug.session.stop: stops a running debug session
function debug.stop() end

-------------------------------------------------------------------------------
---## table

---### added

---Create a new, or convert an exiting table to an object that uses the global
---'table.XXX' functions as methods, just like strings in Lua do.
---@param t table?
---### examples:
---```lua
---t = table.create(); t:insert("a"); rprint(t) -> [1] = a;
---t = table.create{1,2,3}; print(t:concat("|")); -> "1|2|3";
---```
function table.create(t)
  return setmetatable(t or {}, { __index = _G.table })
end

---Returns true when the table is empty, else false and will also work
---for non indexed tables
---@param t table
---@return boolean
---### examples:
---```lua
---t = {};          print(table.is_empty(t)); -> true;
---t = {66};        print(table.is_empty(t)); -> false;
---t = {["a"] = 1}; print(table.is_empty(t)); -> false;
function table.is_empty(t) end

---Count the number of items of a table, also works for non index
---based tables (using pairs).
---@param t table
---@returns integer
---### examples:
---```lua
---t = {["a"]=1, ["b"]=1}; print(table.count(t)) --> 2
---```
function table.count(t) end

---Find first match of *value* in the given table, starting from element
---number *start_index*.<br>
---Returns the first *key* that matches the value or nil
---@param t table
---@param value any
---@param start_index integer?
---@return (string|integer|number)? key_or_nil
---### examples:
---```lua
---t = {"a", "b"}; table.find(t, "a") --> 1
---t = {a=1, b=2}; table.find(t, 2) --> "b"
---t = {"a", "b", "a"}; table.find(t, "a", 2) --> "3"
---t = {"a", "b"}; table.find(t, "c") --> nil
---```
function table.find(t, value, start_index) end

---Return an indexed table of all keys that are used in the table.
---@param t table
---@return table
---### examples:
---```lua
---t = {a="aa", b="bb"}; rprint(table.keys(t)); --> "a", "b"
---t = {"a", "b"};       rprint(table.keys(t)); --> 1, 2
---```
function table.keys(t) end

---Return an indexed table of all values that are used in the table
---@param t table
---@return table
---### examples:
---```lua
--- t = {a="aa", b="bb"}; rprint(table.values(t)); --> "aa", "bb"
--- t = {"a", "b"};       rprint(table.values(t)); --> "a", "b"
---```
function table.values(t) end

---Copy the metatable and all first level elements of the given table into a
---new table. Use table.rcopy to do a recursive copy of all elements
---@param t table
---@return table
function table.copy(t) end

---Deeply copy the metatable and all elements of the given table recursively
---into a new table - create a clone with unique references.
---@param t table
---@return table
function table.rcopy(t) end

---Recursively clears and removes all table elements.
---@param t table
function table.clear(t) end

-------------------------------------------------------------------------------
---## os

---### added

---Returns the platform the script is running on:
---@return "WINDOWS"|"MACINTOSH"|"LINUX"
function os.platform() end

---Returns the current working dir. Will always be the scripts directory
---when executing a script from a file
---@return string path
function os.currentdir() end

---Returns a list of directory names (names, not full paths) for the given
---parent directory. Passed directory must be valid, or an error will be thrown.
---@return string[] paths
function os.dirnames(path) end

---Returns a list file names (names, not full paths) for the given
---parent directory. Second optional argument is a list of file extensions that
---should be searched for, like {"*.wav", "*.txt"}. By default all files are
---matched. The passed directory must be valid, or an error will be thrown.
---@param path string
---@param file_extensions string[]?
---@return string[] paths
function os.filenames(path, file_extensions) end

---Creates a new directory. mkdir can only create one new sub directory at the
---same time. If you need to create more than one sub dir, call mkdir multiple
---times. Returns true if the operation was successful; in case of error, it
---returns nil plus an error string.
---@param path string
---@return boolean?, string?
function os.mkdir(path) end

---Moves a file or a directory from path 'src' to 'dest'. Unlike 'os.rename'
---this also supports moving a file from one file system to another one. Returns
---true if the operation was successful; in case of error, it returns nil plus
---an error string.
---@param src string
---@param dest string
---@return boolean?, string?
function os.move(src, dest) end

---### changed

---Changed in Renoises: Returns a temp directory and name which renoise will
---clean up on exit.
---@param extension string? Default: ".tmp"
---@return string
function os.tmpname(extension) end

---Replaced with a high precision timer (still expressed in milliseconds)
---@return number
function os.clock() end

---Will not exit, but fire an error that os.exit() can not be called
function os.exit() end

-------------------------------------------------------------------------------
---## io

---### added

---Returns true when a file, folder or link at the given path and name exists
---@param filename string
---@return boolean
function io.exists(filename) end

---return value for io.stat
---@class Stat
---@field dev integer device number of filesystem
---@field ino integer inode number
---@field mode integer unix styled file permissions
---@field type "file"|"directory"|"link"|"socket"|"named pipe"|"char device"|"block device"
---@field nlink integer number of (hard) links to the file
---@field uid integer numeric user ID of file's owner
---@field gid integer numeric group ID of file's owner
---@field rdev integer the device identifier (special files only)
---@field size integer total size of file, in bytes
---@field atime integer last access time in seconds since the epoch
---@field mtime integer last modify time in seconds since the epoch
---@field ctime integer inode change time (NOT creation time!) in seconds

---Returns a table with status info about the file, folder or link at the given
---path and name, else nil the error and the error code is returned.
---@param filename string
---@return Stat? result, string? error, integer? error_code
function io.stat(filename) end

---Change permissions of a file, folder or link. mode is a unix permission
---styled octal number (like 755 - WITHOUT a leading octal 0). Executable,
---group and others flags are ignored on windows and won't fire errors
---@param filename string
---@param mode integer
---@return boolean result, string? error, integer? error_code
function io.chmod(filename, mode) end

---### changed

---All io functions use UTF8 as encoding for the file names and paths. UTF8
---is used for Lua in the whole API as default string encoding...


-------------------------------------------------------------------------------
---## math

---### added

---Converts a linear value to a db value. db values will be clipped to
---math.infdb.
---@param n number
---@return number
---### example:
---```lua
---print(math.lin2db(1.0)) --> 0
---print(math.lin2db(0.0)) --> -200 (math.infdb)
---```
function math.lin2db(n) end

---Converts a dB value to a linear value.
---@param n number
---@return number
---### example:
---```lua
---print(math.db2lin(math.infdb)) --> 0
---print(math.db2lin(6.0)) --> 1.9952623149689
---```
function math.db2lin(n) end

---Converts a dB value to a normalized linear fader value between 0-1 within
---the given dB range.
---@param min_dB number
---@param max_dB number
---@param dB_to_convert number
---@return number
---### example:
---```lua
---print(math.db2fader(-96, 0, 1)) --> 0
---print(math.db2fader(-48, 6, 0)) --> 0.73879611492157
---```
function math.db2fader(min_dB, max_dB, dB_to_convert) end

---Converts a normalized linear mixer fader value to a db value within
---the given dB range.
---@param min_dB number
---@param max_dB number
---@param fader_value number
---@return number
---### example:
---```lua
---print(math.fader2db(-96, 0, 1)) --> 0
---print(math.fader2db(-96, 0, 0)) --> -96
---```
function math.fader2db(min_dB, max_dB, fader_value) end

---db values at and below this value will be treated as silent (linearly 0)
math.infdb = -200
