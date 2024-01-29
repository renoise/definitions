---@meta
---Do not try to execute this file. It's just a type definition file.
---
---This reference lists Lua functions to access observables, a notification system
---for value changes in the Renoise API.
---
---Please read the INTRODUCTION.txt first to get an overview about the complete
---API, and scripting for Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Observable

---Documents and views in the Renoise API are modelled after the
---[observer pattern](http://en.wikipedia.org/wiki/Observer_pattern)
---
---This means, in order to track changes, a document is basically just a
---set of raw data (booleans, numbers, lists, nested nodes) which anything can
---attach listeners (notifier functions) to. For example, a view in the Renoise
---API is an Observer, which listens to observable values in Documents.
---
---Attaching and removing notifiers can be done with the functions 'add_notifier',
---'remove_notifier' from the renoise.Observable class. These support multiple kinds
---of callbacks, plain functions and methods (functions with a context). 
---
---### example:
---```lua
---function bpm_changed()
---  print(("something changed the BPM to %s"):format(
---    renoise.song().transport.bpm))
---end
---
---local bpm_observable = renoise.song().transport.bpm_observable
---bpm_observable:add_notifier(bpm_changed)
----- later on, maybe:
---if bpm_observable:has_notifier(bpm_changed) then
---  bpm_observable:remove_notifier(bpm_changed)
---end
---```
---@class renoise.Observable
renoise.Observable = {}

--------------------------------------------------------------------------------
---## renoise.Observable

---### functions

---@alias NotifierFunction fun()
---@alias NotifierMemberContext table|userdata
---@alias NotifierMemberFunction fun(self: NotifierMemberContext)
---@alias Notifier NotifierFunction|({[1]:NotifierMemberContext,[2]:NotifierMemberFunction})|({[1]:NotifierMemberFunction, [2]:NotifierMemberContext})

---Checks if the given function, method was already registered as notifier.
---@return boolean
---@param notifier Notifier
function renoise.Observable:has_notifier(notifier) end

---Register a function or method as a notifier, which will be called as soon as
---the observable's value changed. The passed notifier can either be a funtion 
---or a table with a function and some context (an "object") -> method. 
---### example:
---```lua
---renoise.song().transport.bpm_observable:add_notifier(function() 
---  print("BPM changed")
---end)
---
---local my_context = { bpm_changes = 0, something_else = "bla" }
---renoise.song().transport.bpm_observable:add_notifier({
---  my_context,
---  function(context)
---    context.bpm_changes = context.bpm_changes + 1;
---    print(("#BPM changes: %s"):format(context.bpm_changes)); 
---  end
---})
---```
---@param notifier Notifier
function renoise.Observable:add_notifier(notifier) end

-- Unregister a previously registered notifier. When only passing an object to
-- remove_notifier, all notifier functions that match the given object will be
-- removed; in other words: all methods of the given object are removed. This 
---will not fire errors when no methods for the given object are attached.
---@param notifier NotifierFunction|NotifierMemberContext
function renoise.Observable:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Serializable

---@class renoise.Serializable 
renoise.Serializable = {}

---### functions

---Serialize an object to a string.
---@return string
function renoise.Serializable:to_string() end

---Assign the object's value from a string - when possible. Errors are
---silently ignored.
---@return string
function renoise.Serializable:from_string(string) end

--------------------------------------------------------------------------------
---## renoise.ObservableBang (inherits Observable)

--- Observable without a value which sends out notifications when "banging" it.
---@class renoise.ObservableBang : renoise.Observable
renoise.ObservableBang = {}

---### functions

-- fire a notification, calling all registered notifiers.
function renoise.ObservableBang:bang() end

--------------------------------------------------------------------------------
---## renoise.ObservableBoolean

---@class renoise.ObservableBoolean : renoise.Observable, renoise.Serializable
---@field value boolean Read/write access to the value of an Observable.
renoise.ObservableBoolean = {}

--------------------------------------------------------------------------------
---## renoise.ObservableNumber

---@class renoise.ObservableNumber : renoise.Observable, renoise.Serializable
---@field value number Read/write access to the value of an Observable.
renoise.ObservableNumber = {}

--------------------------------------------------------------------------------
---## renoise.ObservableString

---@class renoise.ObservableString : renoise.Observable, renoise.Serializable
---@field value string Read/write access to the value of an Observable.
renoise.ObservableString = {}

--------------------------------------------------------------------------------
---## renoise.ObservableList

---@alias ListElementAdded {type: "insert", index:number}
---@alias ListElementRemoved {type: "removed", index:number}
---@alias ListElementsSwapped {type: "swapped", index1:number, index2:number}
---@alias ListElementChange ListElementAdded|ListElementRemoved|ListElementsSwapped
---@alias ListNotifierFunction fun(change: ListElementChange)
---@alias ListNotifierMemberContext table|userdata
---@alias ListNotifierMemberFunction fun(self: NotifierMemberContext, change: ListElementChange)
---@alias ListNotifier ListNotifierFunction|({[1]:ListNotifierMemberContext,[2]:ListNotifierMemberFunction})|({[1]:ListNotifierMemberFunction, [2]:ListNotifierMemberContext})

---Notifiers from renoise.Document.Observable are available for lists as well,
---but will not broadcast changes made to the items, only changes to the
---**list** layout.
---
---This means you will get notified as soon as an item is added, removed or
---changes its position, but not when an item's value has changed. If you are
---interested in value changes, attach notifiers directly to the items and
---not to the list...
---
---### example:
---```lua
---function tracks_changed(notification)
---  if (notification.type == "insert") then
---    print(("new track was inserted at index: %d"):format(notification.index))
---
---  elseif (notification.type == "remove") then
---    print(("track got removed from index: %d"):format(notification.index))
---
---  elseif (notification.type == "swap") then
---    print(("track at index: %d and %d swapped their positions"):format(
---      notification.index1, notification.index2))
---  end
---end
---
---renoise.song().tracks_observable:add_notifier(tracks_changed)
---```
---@class renoise.ObservableList
---Query a list's size (item count).
---@operator len:integer
renoise.ObservableList = {}

---### functions

---Returns the number of entries of the list.
---@return number
function renoise.ObservableList:size() end

---@param notifier ListNotifier
---@returns boolean
function renoise.ObservableList:has_notifier(notifier) end

---@param notifier ListNotifier
function renoise.ObservableList:add_notifier(notifier) end

---@param notifier ListNotifierFunction|ListNotifierMemberContext
function renoise.ObservableList:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.ObservableBooleanList

---A observable list of boolean values.
---@class renoise.ObservableBooleanList : renoise.ObservableList, renoise.Serializable
---Query a list's size (item count).
---@operator len:integer
renoise.ObservableBooleanList = {}

---List item access (returns nil for non existing items).
---@param index integer
---@return nil|renoise.ObservableBoolean
function renoise.ObservableBooleanList:property(index) end

---Find a value in the list by comparing the list values with the passed
---value. The first successful match is returned. When no match is found, nil
---is returned.
---@param start_pos number
---@param value boolean
---@return integer|nil
---@overload fun(self, value: boolean):integer|nil
function renoise.ObservableBooleanList:find(start_pos, value) end

---Insert a new item to the end of the list when no position is specified, or
---at the specified position. Returns the newly created and inserted Observable.
---@param pos integer
---@param value boolean
---@return renoise.ObservableBoolean
---@overload fun(self, value: boolean):renoise.ObservableBoolean
function renoise.ObservableBooleanList:insert(pos, value) end

---Removes an item (or the last one if no index is specified) from the list.
---@param pos integer
---@overload fun(self)
function renoise.ObservableBooleanList:remove(pos) end

---Swaps the positions of two items without adding/removing the items.
---With a series of swaps you can move the item from/to any position.
---@param pos1 integer
---@param pos2 integer
function renoise.ObservableBooleanList:swap(pos1, pos2) end

--------------------------------------------------------------------------------
---## renoise.ObservableNumberList

---A observable list of number values.
---@class renoise.ObservableNumberList : renoise.ObservableList, renoise.Serializable
---Query a list's size (item count).
---@operator len:integer
renoise.ObservableNumberList = {}

---List item access (returns nil for non existing items).
---@param index integer
---@return nil|renoise.ObservableNumber
function renoise.ObservableNumberList:property(index) end

---Find a value in the list by comparing the list values with the passed
---value. The first successful match is returned. When no match is found, nil
---is returned.
---@param start_pos number
---@param value number
---@return integer|nil
---@overload fun(self, value: number):integer|nil
function renoise.ObservableNumberList:find(start_pos, value) end

---Insert a new item to the end of the list when no position is specified, or
---at the specified position. Returns the newly created and inserted Observable.
---@param pos integer
---@param value number
---@return renoise.ObservableNumber
---@overload fun(self, value: boolean):renoise.ObservableBoolean
function renoise.ObservableNumberList:insert(pos, value) end

---Removes an item (or the last one if no index is specified) from the list.
---@param pos integer
---@overload fun(self)
function renoise.ObservableNumberList:remove(pos) end

---Swaps the positions of two items without adding/removing the items.
---With a series of swaps you can move the item from/to any position.
---@param pos1 integer
---@param pos2 integer
function renoise.ObservableNumberList:swap(pos1, pos2) end

--------------------------------------------------------------------------------
---## renoise.ObservableStringList

---A observable list of number values.
---@class renoise.ObservableStringList : renoise.ObservableList, renoise.Serializable
---Query a list's size (item count).
---@operator len:integer
renoise.ObservableStringList = {}

---List item access (returns nil for non existing items).
---@param index integer
---@return nil|renoise.ObservableString
function renoise.ObservableStringList:property(index) end

---Find a value in the list by comparing the list values with the passed
---value. The first successful match is returned. When no match is found, nil
---is returned.
---@param start_pos number
---@param value number
---@return integer|nil
---@overload fun(self, value: number):integer|nil
function renoise.ObservableStringList:find(start_pos, value) end

---Insert a new item to the end of the list when no position is specified, or
---at the specified position. Returns the newly created and inserted Observable.
---@param pos integer
---@param value number
---@return renoise.ObservableString
---@overload fun(self, value: boolean):renoise.ObservableBoolean
function renoise.ObservableStringList:insert(pos, value) end

---Removes an item (or the last one if no index is specified) from the list.
---@param pos integer
---@overload fun(self)
function renoise.ObservableStringList:remove(pos) end

---Swaps the positions of two items without adding/removing the items.
---With a series of swaps you can move the item from/to any position.
---@param pos1 integer
---@param pos2 integer
function renoise.ObservableStringList:swap(pos1, pos2) end
