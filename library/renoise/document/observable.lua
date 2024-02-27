---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Document.Observable

---Documents and views in the Renoise API are modelled after the
---[observer pattern](http://en.wikipedia.org/wiki/Observer_pattern).
---
---This means, in order to track changes, a document is basically just a
---set of raw data (booleans, numbers, lists, nested nodes) which anything can
---attach listeners (notifier functions) to. For example, a view in the Renoise
---API is an Observer, which listens to observable values in Documents.
---
---Attaching and removing notifiers can be done with the functions 'add_notifier',
---'remove_notifier' from the renoise.Document.Observable class. These support
---multiple kinds of callbacks, plain functions and methods (functions with a context).
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
---@class renoise.Document.Observable
renoise.Document.Observable = {}

---@alias NotifierFunction fun()
---@alias NotifierMemberContext table|userdata
---@alias NotifierMemberFunction fun(self: NotifierMemberContext)
---@alias NotifierMethod1 {[1]:NotifierMemberContext, [2]:NotifierMemberFunction}
---@alias NotifierMethod2 {[1]:NotifierMemberFunction, [2]:NotifierMemberContext}

---@alias BooleanValueNotifierFunction fun(value: boolean)
---@alias BooleanValueNotifierMemberFunction fun(self: NotifierMemberContext, value: boolean)
---@alias BooleanValueNotifierMethod1 {[1]:NotifierMemberContext, [2]:BooleanValueNotifierMemberFunction}
---@alias BooleanValueNotifierMethod2 {[1]:BooleanValueNotifierMemberFunction, [2]:NotifierMemberContext}

---@alias IntegerValueNotifierFunction fun(value: integer)
---@alias IntegerValueNotifierMemberFunction fun(self: NotifierMemberContext, value: integer)
---@alias IntegerValueNotifierMethod1 {[1]:NotifierMemberContext, [2]:IntegerValueNotifierMemberFunction}
---@alias IntegerValueNotifierMethod2 {[1]:IntegerValueNotifierMemberFunction, [2]:NotifierMemberContext}

---@alias NumberValueNotifierFunction fun(value: number)
---@alias NumberValueNotifierMemberFunction fun(self: NotifierMemberContext, value: number)
---@alias NumberValueNotifierMethod1 {[1]:NotifierMemberContext, [2]:NumberValueNotifierMemberFunction}
---@alias NumberValueNotifierMethod2 {[1]:NumberValueNotifierMemberFunction, [2]:NotifierMemberContext}

---@alias StringValueNotifierFunction fun(value: string)
---@alias StringValueNotifierMemberFunction fun(self: NotifierMemberContext, value: string)
---@alias StringValueNotifierMethod1 {[1]:NotifierMemberContext, [2]:StringValueNotifierMemberFunction}
---@alias StringValueNotifierMethod2 {[1]:StringValueNotifierMemberFunction, [2]:NotifierMemberContext}

---### functions

---Checks if the given function, method was already registered as notifier.
---@return boolean
---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function renoise.Document.Observable:has_notifier(notifier) end

---Register a function or method as a notifier, which will be called as soon as
---the observable's value changed. The passed notifier can either be a function
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
---@param notifier NotifierFunction
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function renoise.Document.Observable:add_notifier(notifier) end

---Unregister a previously registered notifier. When only passing an object,
---all notifier functions that match the given object will be removed.
---This will not fire errors when no methods for the given object are attached.
---Trying to unregister a function or method which wasn't registered, will resolve
---into an error.
---@param notifier NotifierFunction|NotifierMemberContext
---@overload fun(self, notifier: NotifierMethod1)
---@overload fun(self, notifier: NotifierMethod2)
function renoise.Document.Observable:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Document.Serializable

---@class renoise.Document.Serializable
renoise.Document.Serializable = {}

---### functions

---Serialize an object to a string.
---@return string
function renoise.Document.Serializable:to_string() end

---Assign the object's value from a string - when possible. Errors are
---silently ignored.
---@return string
function renoise.Document.Serializable:from_string(string) end

--------------------------------------------------------------------------------
---## renoise.Document.ObservableBang (inherits Observable)

---Observable without a value which sends out notifications when "banging" it.
---@class renoise.Document.ObservableBang : renoise.Document.Observable
---Construct a new observable bang.
---@overload fun():renoise.Document.ObservableBang
renoise.Document.ObservableBang = {}

---### functions

-- fire a notification, calling all registered notifiers.
function renoise.Document.ObservableBang:bang() end

--------------------------------------------------------------------------------
---## renoise.Document.ObservableBoolean

---@class renoise.Document.ObservableBoolean : renoise.Document.Observable, renoise.Document.Serializable
---Read/write access to the value of an observable.
---@field value boolean
---Construct a new observable boolean.
---@overload fun(boolean?):renoise.Document.ObservableBoolean
renoise.Document.ObservableBoolean = {}

--------------------------------------------------------------------------------
---## renoise.Document.ObservableNumber

---@class renoise.Document.ObservableNumber : renoise.Document.Observable, renoise.Document.Serializable
---Read/write access to the value of an Observable.
---@field value number
---Construct a new observable boolean.
---@overload fun(number?):renoise.Document.ObservableNumber
renoise.Document.ObservableNumber = {}

--------------------------------------------------------------------------------
---## renoise.Document.ObservableString

---@class renoise.Document.ObservableString : renoise.Document.Observable, renoise.Document.Serializable
---Read/write access to the value of an Observable.
---@field value string
---Construct a new observable string.
---@overload fun(string?):renoise.Document.ObservableString
renoise.Document.ObservableString = {}

--------------------------------------------------------------------------------
---## renoise.Document.ObservableList

---@alias ListElementAdded {type: "insert", index:integer}
---@alias ListElementRemoved {type: "removed", index:integer}
---@alias ListElementsSwapped {type: "swapped", index1:integer, index2:integer}
---@alias ListElementChange ListElementAdded|ListElementRemoved|ListElementsSwapped

---@alias ListNotifierFunction fun(change: ListElementChange)
---@alias ListNotifierMemberContext table|userdata
---@alias ListNotifierMemberFunction fun(self: NotifierMemberContext, change: ListElementChange)
---@alias ListNotifierMethod1 {[1]:ListNotifierMemberContext, [2]:ListNotifierMemberFunction}
---@alias ListNotifierMethod2 {[1]:ListNotifierMemberFunction, [2]:ListNotifierMemberContext}

---Notifiers from renoise.Document.Observable are available for lists as well,
---but will not broadcast changes made to the items, but only changes to the
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
---  elseif (notification.type == "remove") then
---    print(("track got removed from index: %d"):format(notification.index))
---  elseif (notification.type == "swap") then
---    print(("track at index: %d and %d swapped their positions"):format(
---      notification.index1, notification.index2))
---  end
---end
---
---renoise.song().tracks_observable:add_notifier(tracks_changed)
---```
---@class renoise.Document.ObservableList
---Query a list's size (item count).
---@operator len:integer
renoise.Document.ObservableList = {}

---### functions

---Returns the number of entries of the list.
---@return integer
function renoise.Document.ObservableList:size() end

---Checks if the given function, method was already registered as notifier.
---@param notifier ListNotifierFunction
---@returns boolean
---@overload fun(self, notifier: ListNotifierMethod1)
---@overload fun(self, notifier: ListNotifierMethod2)
function renoise.Document.ObservableList:has_notifier(notifier) end

---Register a function or method as a notifier, which will be called as soon as
---the observable lists layout changed. The passed notifier can either be a function
---or a table with a function and some context (an "object") -> method.
---@param notifier ListNotifierFunction
---@overload fun(self, notifier: ListNotifierMethod1)
---@overload fun(self, notifier: ListNotifierMethod2)
function renoise.Document.ObservableList:add_notifier(notifier) end

---Unregister a previously registered list notifier. When only passing an object,
---all notifier functions that match the given object will be removed.
---This will not fire errors when no methods for the given object are attached.
---Trying to unregister a function or method which wasn't registered, will resolve
---into an error.
---@param notifier ListNotifierFunction|ListNotifierMemberContext
---@overload fun(self, notifier: ListNotifierMethod1)
---@overload fun(self, notifier: ListNotifierMethod2)
function renoise.Document.ObservableList:remove_notifier(notifier) end

--------------------------------------------------------------------------------
---## renoise.Document.ObservableBooleanList

---A observable list of boolean values.
---@class renoise.Document.ObservableBooleanList : renoise.Document.ObservableList, renoise.Document.Serializable
---Query a list's size (item count).
---@operator len:integer
---Construct a new observable list of booleans.
---@overload fun():renoise.Document.ObservableBooleanList
renoise.Document.ObservableBooleanList = {}

---List item access by index. returns nil for non existing items.
---@param index integer
---@return renoise.Document.ObservableBoolean?
function renoise.Document.ObservableBooleanList:property(index) end

---Find a value in the list by comparing the list values with the passed
---value. The first successful match is returned. When no match is found, nil
---is returned.
---@param start_pos integer
---@param value boolean
---@return integer?
---@overload fun(self, value: boolean):integer?
function renoise.Document.ObservableBooleanList:find(start_pos, value) end

---Insert a new item to the end of the list when no position is specified, or
---at the specified position. Returns the newly created and inserted Observable.
---@param pos integer
---@param value boolean
---@return renoise.Document.ObservableBoolean
---@overload fun(self, value: boolean):renoise.Document.ObservableBoolean
function renoise.Document.ObservableBooleanList:insert(pos, value) end

---Removes an item (or the last one if no index is specified) from the list.
---@param pos integer
---@overload fun(self)
function renoise.Document.ObservableBooleanList:remove(pos) end

---Swaps the positions of two items without adding/removing the items.
---
---With a series of swaps you can move the item from/to any position.
---@param pos1 integer
---@param pos2 integer
function renoise.Document.ObservableBooleanList:swap(pos1, pos2) end

--------------------------------------------------------------------------------
---## renoise.Document.ObservableNumberList

---A observable list of number values.
---@class renoise.Document.ObservableNumberList : renoise.Document.ObservableList, renoise.Document.Serializable
---Query a list's size (item count).
---@operator len:integer
---Construct a new observable list of numbers.
---@overload fun():renoise.Document.ObservableNumberList
renoise.Document.ObservableNumberList = {}

---List item access by index. returns nil for non existing items.
---@param index integer
---@return renoise.Document.ObservableNumber?
function renoise.Document.ObservableNumberList:property(index) end

---Find a value in the list by comparing the list values with the passed
---value. The first successful match is returned. When no match is found, nil
---is returned.
---@param start_pos integer
---@param value number
---@return integer?
---@overload fun(self, value: number):integer?
function renoise.Document.ObservableNumberList:find(start_pos, value) end

---Insert a new item to the end of the list when no position is specified, or
---at the specified position. Returns the newly created and inserted Observable.
---@param pos integer
---@param value number
---@return renoise.Document.ObservableNumber
---@overload fun(self, value: boolean):renoise.Document.ObservableBoolean
function renoise.Document.ObservableNumberList:insert(pos, value) end

---Removes an item (or the last one if no index is specified) from the list.
---@param pos integer
---@overload fun(self)
function renoise.Document.ObservableNumberList:remove(pos) end

---Swaps the positions of two items without adding/removing the items.
---With a series of swaps you can move the item from/to any position.
---@param pos1 integer
---@param pos2 integer
function renoise.Document.ObservableNumberList:swap(pos1, pos2) end

--------------------------------------------------------------------------------
---## renoise.Document.ObservableStringList

---A observable list of number values.
---@class renoise.Document.ObservableStringList : renoise.Document.ObservableList, renoise.Document.Serializable
---Query a list's size (item count).
---@operator len:integer
---Construct a new observable list of strings.
---@overload fun():renoise.Document.ObservableStringList
renoise.Document.ObservableStringList = {}

---List item access by index. returns nil for non existing items.
---@param index integer
---@return renoise.Document.ObservableString?
function renoise.Document.ObservableStringList:property(index) end

---Find a value in the list by comparing the list values with the passed
---value. The first successful match is returned. When no match is found, nil
---is returned.
---@param start_pos integer
---@param value number
---@return integer?
---@overload fun(self, value: number):integer?
function renoise.Document.ObservableStringList:find(start_pos, value) end

---Insert a new item to the end of the list when no position is specified, or
---at the specified position. Returns the newly created and inserted Observable.
---@param pos integer
---@param value number
---@return renoise.Document.ObservableString
---@overload fun(self, value: boolean):renoise.Document.ObservableBoolean
function renoise.Document.ObservableStringList:insert(pos, value) end

---Removes an item (or the last one if no index is specified) from the list.
---@param pos integer
---@overload fun(self)
function renoise.Document.ObservableStringList:remove(pos) end

---Swaps the positions of two items without adding/removing the items.
---With a series of swaps you can move the item from/to any position.
---@param pos1 integer
---@param pos2 integer
function renoise.Document.ObservableStringList:swap(pos1, pos2) end
