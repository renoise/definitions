---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## renoise.Document

---renoise.Document classes are wrappers for Renoise's internal document
---classes.
---
---**Please note**: the Lua wrappers are not really "the Lua way" of solving and
---expressing things. e.g: there's no support for mixed types in lists, tuples
---at the moment.
---
---Documents can be serialized from/to XML, just like Renoise's internal
---document and are observable.
---
---An empty document (node) object can be created via
---```renoise.Document.create("MyDoc"){}```
---
---Such document objects can then be extended with the document's
---`add_property` function. Existing properties can also be removed again with the
---`remove_property` function.
---
---### examples:
---```lua
----- Creates an empty document, using "MyDoc" as the model name (a type name)
---local my_document = renoise.Document.create("MyDoc"){ }
----- adds a number to the document with the initial value 1
---my_document:add_property("value1", 1)
----- adds a string
---my_document:add_property("value2", "bla")
----- create another document and adds it
---local node = renoise.Document.create("MySubDoc"){ }
---node:add_property("another_value", 1)
----- add another already existing node
---my_document:add_property("nested_node", node)
----- removes a previously added node
---my_document:remove_property(node)
----- access properties
---local value1 = my_document.value1
---value1 = my_document:property("value1")
---```
---As an alternative to `renoise.Document.create`, you can also inherit from
---renoise.Document.DocumentNode in order to create your own document classes.
---This is especially recommended when dealing with more complex docs, because
---you can also use additional methods to deal with your properties, the data.
---
---### examples:
---```lua
---class "MyDocument" (renoise.Document.DocumentNode)
---  function MyDocument:__init()
---    -- important! call super first
---    renoise.Document.DocumentNode.__init(self)
---    -- add properties to construct the document model
---    self:add_property("age", 1)
---    self:add_property("name", renoise.Document.ObservableString("value"))
---    -- other doc renoise.Document.DocumentNode object
---    self:add_property("sub_node", MySubNode())
---    -- list of renoise.Document.DocumentNode objects
---    self:add_property("doc_list", renoise.Document.DocumentList())
---    -- or the create() way:
---    self:add_properties {
---      something = "else"
---    }
---  end
---```
---Instantiating such custom document objects can then be done by simply
---calling the constructor:
---```lua
---my_document = MyDocument()
----- do something with my_document, load/save, add/remove more properties
---```
---@class renoise.Document
renoise.Document = {}

---@alias ObservableTypes boolean|number|string|boolean[]|number[]|string[]
---@alias ObservableProperties table <string, ObservableTypes|renoise.Document.DocumentNode|renoise.Document.DocumentList>

---### functions

---Create an empty DocumentNode or a DocumentNode that is modeled after the
---passed key value table. "model_name" will be used to identify the documents
---type when loading/saving. It also allows you to instantiate new document
---objects (see renoise.Document.instantiate).
---
---### examples:
---```lua
---my_document = renoise.Document.create("MyDoc") {
---  age = 1,
---  name = "bla", -- implicitly specify a property type
---  is_valid = renoise.Document.ObservableBoolean(false), -- or explicitly
---  age_list = {1, 2, 3},
---  another_list = renoise.Document.ObservableNumberList(),
---  sub_node = {
---    sub_value1 = 2,
---    sub_value2 = "bla2"
---  }
---}
---```
---This will create a document node which is !modeled! after the the passed table.
---The table is not used internally by the document after construction, and will
---only be referenced to construct new instances. Also note that you need to assign
---values for all passed table properties in order to automatically determine it's
---type, or specify the types explicitly -> renoise.Document.ObservableXXX().
---
---The passed name ("MyDoc" in the example above) is used to identify the document
---when loading/saving it (loading a XML file which was saved with a different
---model will fail) and to generally specify the "type".
---
---Additionally, once "create" is called, you can use the specified model name to
---create new instances.
---
---### examples:
---```lua
----- create a new instance of "MyDoc"
---my_other_document = renoise.Document.instantiate("MyDoc")
---```
---@param model_name string
---@return fun(properties: ObservableProperties):renoise.Document.DocumentNode
function renoise.Document.create(model_name)
    local new_node = renoise.Document.DocumentNode();
    return function(properties)
        new_node:add_properties(properties)
        return new_node
    end
end

---Create a new instance of the given document model. Given `model_name` must
---have been registered with `renoise.Document.create` before.
---@param model_name string
---@return renoise.Document.DocumentNode
function renoise.Document.instantiate(model_name) end

--------------------------------------------------------------------------------
---## renoise.Document.DocumentNode

---@alias DocumentMember renoise.Document.Observable|renoise.Document.ObservableList|renoise.Document.DocumentNode|renoise.Document.DocumentList

-- TODO:
-- * inheriting from 'table' is workaround here to allow users to define custom types
--   for their document classes and still have useful diagnostics instead of warnings
-- * add @operator index(any):DocumentMember? once its supported by LuaLS

---A document node is a sub component in a document which contains other
---documents or observables.
---@class renoise.Document.DocumentNode : table
---Construct a new document node.
---@overload fun():renoise.Document.DocumentNode
renoise.Document.DocumentNode = {}

---### functions

---Base constructor, only necessary to be called in your custom class constructor,
---when inheriting from renoise.Document.DocumentNode.
function renoise.Document.DocumentNode:__init() end

---Check if the given property exists.
---@param property_name string
---@return boolean
function renoise.Document.DocumentNode:has_property(property_name) end

---Access a property by name. Returns the property, or nil when there is no
---such property.
---@param property_name string
---@return DocumentMember?
function renoise.Document.DocumentNode:property(property_name) end

---Add a new property. Name must be unique: overwriting already existing
---properties with the same name is not allowed and will fire an error.
---If you want to replace a property, remove it first, then add it again.
---@return renoise.Document.DocumentNode
---@param name string
---@param value renoise.Document.DocumentNode
---@overload fun(self, name: string, value: renoise.Document.DocumentList): renoise.Document.DocumentList
---@overload fun(self, name: string, value: boolean): renoise.Document.ObservableBoolean
---@overload fun(self, name: string, value: number): renoise.Document.ObservableNumber
---@overload fun(self, name: string, value: string): renoise.Document.ObservableString
---@overload fun(self, name: string, value: boolean[]): renoise.Document.ObservableBooleanList
---@overload fun(self, name: string, value: number[]): renoise.Document.ObservableNumberList
---@overload fun(self, name: string, value: string[]): renoise.Document.ObservableStringList
function renoise.Document.DocumentNode:add_property(name, value) end

---Add a batch of properties in one go, similar to renoise.Document.create.
---@param properties ObservableProperties
function renoise.Document.DocumentNode:add_properties(properties) end

---Remove a previously added property. Property must exist.
---
---In order to remove a value by it's key, use
---`my_document:remove_property(my_document["some_member"])`
---@param value DocumentMember
function renoise.Document.DocumentNode:remove_property(value) end

---Save the whole document tree to an XML file. Overwrites all contents of the
---file when it already exists.
---@param file_name string
---@return  boolean success, string? error
function renoise.Document.DocumentNode:save_as(file_name) end

---Load the document tree from an XML file. This will NOT create new properties,
---except for list items, but will only assign existing property values in the
---document node with existing property values from the XML.
---This means: nodes that only exist in the XML will silently be ignored.
---Nodes that only exist in the document, will not be altered in any way.
---The loaded document's type must match the document type that saved the XML
---data.
---A document's type is specified in the renoise.Document.create() function
---as "model_name". For classes which inherit from renoise.Document.DocumentNode
---it's the class name.
---@param file_name string
---@return boolean success, string? error
function renoise.Document.DocumentNode:load_from(file_name) end

---Serialize the whole document tree to a XML string.
---@return string
function renoise.Document.DocumentNode:to_string() end

---Parse document tree from the given string data.
---See renoise.Document.DocumentNode:load_from for details about how properties
---are parsed and errors are handled.
---@param string string
---@return boolean success, string? error
function renoise.Document.DocumentNode:from_string(string) end

--------------------------------------------------------------------------------
---## renoise.Document.DocumentList

-- TODO:
-- * add @operator index(any):renoise.Document.DocumentNode? once its supported by LuaLS

---A document list is a document sub component which may contain other document
---nodes in an observable list.
---
---### example:
---```lua
----- our goal here is to have a document that contains a list of documents
----- which can loaded as preferences for our tool
-----
----- define a class model for our complex type for document items in the list
----- so that Renoise knows how to load it later our entries will have
---renoise.Document.create("Entry") {
---  name = renoise.Document.ObservableString(),
---  path = renoise.Document.ObservableString(),
---}
---
----- create new entry instances with the given data
---function create_entry(name, path)
---  local entry = renoise.Document.instantiate("Entry")
---  entry.name.value = name
---  entry.path.value = path
---  return entry
---end
---
----- define a class model for our preferences which is using a list of entries
---renoise.Document.create("MyPreferences") {
---  list = renoise.Document.DocumentList()
---}
---
----- assign a fresh instance of our main document as preferences
---local preferences = renoise.Document.instantiate("MyPreferences")
---renoise.tool().preferences = preferences
---
----- insert elements into the list using :insert(index, element)
----- we call our helper to create an instance of Entry
---preferences.list:insert(1, create_entry("some name", "some/path"))
---
----- access entries by using :property(index)
---print(preferences.list:property(1).name)
---
----- get the size of the list (you can use :size() as well)
---print(#preferences.list)
---
----- loop over the list to print all entries
---for i = 1, #preferences.list do
---  local entry = preferences.list:property(i)
---  print(i)
---  print(entry.name)
---  print(entry.path)
---end
---
----- try reloading your tool to see the list get bigger
---```
---@class renoise.Document.DocumentList
---Query a list's size (item count).
---@operator len():integer
---Construct a new document list.
---@overload fun():renoise.Document.DocumentList
renoise.Document.DocumentList = {}

---### functions

---Returns the number of entries of the list.
---@return integer
function renoise.Document.DocumentList:size() end

---List item access by index. returns nil for non existing items.
---@param index integer
---@return renoise.Document.DocumentNode?
function renoise.Document.DocumentList:property(index) end

---Find a value in the list by comparing the list values with the passed
---value. The first successful match is returned. When no match is found, nil
---is returned.
---@param start_pos integer
---@param value renoise.Document.DocumentNode
---@return integer?
---@overload fun(self, value: renoise.Document.DocumentNode):integer?
function renoise.Document.DocumentList:find(start_pos, value) end

---Insert a new item to the end of the list when no position is specified, or
---at the specified position. Returns the newly created and inserted Observable.
---@param pos integer
---@param value renoise.Document.DocumentNode
---@return renoise.Document.DocumentNode
---@overload fun(self, value: renoise.Document.DocumentNode):renoise.Document.DocumentNode
function renoise.Document.DocumentList:insert(pos, value) end

---Removes an item (or the last one if no index is specified) from the list.
---@param pos integer
---@overload fun(self)
function renoise.Document.DocumentList:remove(pos) end

---Swaps the positions of two items without adding/removing the items.
---
---With a series of swaps you can move the item from/to any position.
---@param pos1 integer
---@param pos2 integer
function renoise.Document.DocumentList:swap(pos1, pos2) end

---Checks if the given function, method was already registered as notifier.
---@param notifier ListNotifierFunction
---@returns boolean
---@overload fun(self, notifier: ListNotifierMethod1):boolean
---@overload fun(self, notifier: ListNotifierMethod2):boolean
function renoise.Document.DocumentList:has_notifier(notifier) end

---Register a function or method as a notifier, which will be called as soon as
---the document lists layout changed. The passed notifier can either be a function
---or a table with a function and some context (an "object") -> method.
---@param notifier ListNotifierFunction
---@overload fun(self, notifier: ListNotifierMethod1)
---@overload fun(self, notifier: ListNotifierMethod2)
function renoise.Document.DocumentList:add_notifier(notifier) end

---Unregister a previously registered list notifier. When only passing an object,
---all notifier functions that match the given object will be removed.
---This will not fire errors when no methods for the given object are attached.
---Trying to unregister a function or method which wasn't registered, will resolve
---into an error.
---@param notifier ListNotifierFunction|ListNotifierMemberContext
---@overload fun(self, notifier: ListNotifierMethod1)
---@overload fun(self, notifier: ListNotifierMethod2)
function renoise.Document.DocumentList:remove_notifier(notifier) end
