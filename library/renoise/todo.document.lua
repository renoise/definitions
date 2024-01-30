--[[============================================================================
Renoise Document API Reference
============================================================================]]--

--[[

The renoise.Document namespace covers all document related Renoise API
functions. This includes:

* Accessing existing Renoise document objects. The Renoise API uses these types
  of document structs, e.g. all "_observables" found in the Renoise Lua API are
  renoise.Document.Observable objects

* Create new documents (e.g persistent options, presets for your tools)
  which can be loaded and saved as XML files by your scripts. These can also be
  bound to custom views, or "your own" document listeners
  -> see renoise.Document.create()

Please read the INTRODUCTION first to get an overview about the complete
API, and scripting for Renoise in general...

Do not try to execute this file. It uses a .lua extension for markup only.


-------- Overall API Design

All renoise.Document classes are wrappers for Renoise's internal document
classes. The Lua wrappers are not really "the Lua way" of solving
and expressing things. e.g: theres no support for mixed types in lists,
tuples at the moment.

The reason behind this limitation is to allow both worlds (Lua in scripts
and the internal C++ objects) to fully interact with each others: scripts
can use existing Renoise objects, Renoise documents can be extended with
Lua classes, and so on.

If all you need is a generic XML import/export (or JSON, or "insert trendy
format here") and you don't need an Observable mechanism for your values, then
you should look into using using a generic Lua table serializer instead.
See <http://lua-users.org/wiki/TableSerialization> to start.

Related to this, import of renoise.Documents from XML will NOT create new object
models from the source XML files, but will only assign existing corresponding
values in your document object (except for lists which are instantiated
dynamically). This means values which are not present in the original model
will silently be ignored during import. This behaviour is, most of the time, the
desired one. For example, when extending an already existing document format.
However, when dealing with unknown models or formats, you will need to research
other options.


-------- Document Basetypes, Building Blocks

Types that can be in used in renoise.Documents, things that can make up a
document are:

+ ObservableBoolean/Number/String (wrappers for the "raw" Lua base types)
+ ObservableBoolean/String/NumberList (wrappers of lists for the Lua base types)
+ other document objects (create document trees)
+ lists of document objects (dynamically sized lists of other document nodes)

ObservableBoolean/Number/String is a simple wrapper for the raw Lua base types.
Basically, it just stores the corresponding value (a boolean, number, or string)
and maintains a list of attached notifiers. Each Observable object is strongly
typed, can only hold a predefined Lua base type, defined when constructing the
property. Same is true for the basetype list wrappers: Lists can not contain
multiple objects of different types.

Lua's other fundamental type, the table, has no direct representation in the
Document API: You can either use strongly typed lists in order to get Lua
index based table alike behaviour, or use nested document nodes or lists
(documents in documents) to get an associative table alike layout/behaviour.

Except for the strong typing, ObservableBoolean/String/NumberList and
DocumentList will behave more or less like Lua tables with number based indices
(Arrays).

You can use the `#` operator or `[]` operators just like you do with tables, but
can also query all this info via list methods (:size(), :property(name), [...]).


-------- Creating Documents via "renoise.Document.create()" (models)

An empty document (node) object can be created with the function
> renoise.Document.create("MyDoc"){}

Such document objects can be extended with the document's "add_property"
function. Existing properties can also be removed again with the
"remove_property" function:

    -- creates an empty document, using "MyDoc" as the model name (a type name)
    local my_document = renoise.Document.create("MyDoc"){ }
    
    -- adds a number to the document with the initial value 1
    my_document:add_property("value1", 1)
    
    -- adds a string
    my_document:add_property("value2", "bla")
    
    -- create another document and adds it
    local node = renoise.Document.create("MySubDoc"){ }
    node:add_property("another_value", 1)
    
    -- add another already existing node
    my_document:add_property("nested_node", node)
    
    -- removes a previously added node
    my_document:remove_property(node)
    
    -- access properties
    local value1 = my_document.value1
    value1 = my_document:property("value1")

A more comfortable, and often more readable way of creating simple
document trees, structs, can be done by passing a table to the create()
function:

    my_document = renoise.Document.create("MyDoc") {
      age = 1,
      name = "bla", -- implicitly specify a property type
      is_valid = renoise.Document.ObservableBoolean(false), -- or explicitly
      age_list = {1, 2, 3},
      another_list = renoise.Document.ObservableNumberList(),
      sub_node = {
        sub_value1 = 2,
        sub_value2 = "bla2"
      }
    }

This will create a document node which is !modeled! after the the passed table.
The table is not used internally by the document after construction, and will
only be referenced to construct new instances. Also note that you need to assign
values for all passed table properties in order to automatically determine it's
type, or specify the types explicitly -> renoise.Document.ObservableXXX().

The passed name ("MyDoc" in the example above) is used to identify the document
when loading/saving it (loading a XML file which was saved with a different
model will fail) and to generally specify the "type".

Additionally, once "create" is called, you can use the specified model name to
create new instances. For example:

    -- create a new instance of "MyDoc"
    my_other_document = renoise.Document.instantiate("MyDoc")


-------- Creating Documents via inheritance (custom Doc classes)

As an alternative to "renoise.Document.create", you can also inherit from
renoise.Document.DocumentNode in order to create your own document classes.
This is especially recommended when dealing with more complex docs, because you
can also use additional methods to deal with your properties, the data.

Here is a simple example:

    class "MyDocument"(renoise.Document.DocumentNode)

      function MyDocument:__init()
        -- important! call super first
        renoise.Document.DocumentNode.__init(self)

        -- add properties to construct the document model
        self:add_property("age", 1)
        self:add_property("name", renoise.Document.ObservableString("value"))

        -- other doc renoise.Document.DocumentNode object
        self:add_property("sub_node", MySubNode())

        -- list of renoise.Document.DocumentNode objects
        self:add_property("doc_list", renoise.Document.DocumentList())

        -- or the create() way:
        self:add_properties {
          something = "else"
        }
      end

instantiating such document objects can be done, as previously stated, by
calling the constructor:

    my_document = MyDocument()
    -- do something with my_document, load/save, add/remove more properties


-------- Accessing Document Properties

Accessing "renoise.Document.DocumentNode" can be done more or less just like you
do with tables in Lua, except that if you want to get/set the value of some
property, you have to query the value explicitly. Using my_document from
the example above:

    -- this returns the !ObservableNumber object, not a number!
    local age_observable = my_document.age
    
    -- this sets the value of the object
    my_document.age.value = 2
    
    -- this accesses/prints the value of the object
    print(my_document.age.value)
    
    -- add notifiers
    my_document.age:add_notifier(function()
      print("something changed 'age'!")
    end)
    
    -- inserts a new entry to the list
    my_document.age_list:insert(22)
    
    -- queries the length of the list
    print(#my_document.age_list)
    
    -- access a list member
    local entry = my_document.age_list[1]
    
    -- list members are observables as well
    my_document.age_list[2].value = 33

For more details about document construction and notifiers, have a look
at the class docs below.

]]--

--==============================================================================
-- renoise.Document
--==============================================================================

-------- Construction

-- Create an empty DocumentNode or a DocumentNode that is modelled after the
-- passed table. See the general description in this file for more info about
-- creating documents. "model name" will be used to identify the documents type
-- when loading/saving. It also allows you to instantiate new document
-- objects (see renoise.Document.instantiate).
renoise.Document.create(model_name) {[table]}
  -> [renoise.Document.DocumentNode object]

-- create a new instance of the given document model. model_name must have been
-- registered with renoise.Document.create before.
renoise.Document.instantiate(model_name)
  -> [renoise.Document.DocumentNode object]

--------------------------------------------------------------------------------
-- renoise.Document.DocumentNode
--------------------------------------------------------------------------------

-------- Operators

doc[property_name]
  -> [nil or (Observable, ObservableList or DocumentNode, DocumentList object)]


-------- Functions

doc:has_property(property_name)
  -> [boolean]

-- Access a property by name. Returns the property, or nil when there is no
-- such property.
doc:property(property_name)
  -> [nil or (Observable, ObservableList or DocumentNode, DocumentList object)]

-- Add a new property. Name must be unique: overwriting already existing
-- properties with the same name is not allowed and will fire an error.
doc:add_property(name, boolean_value)
  -> [newly created ObservableBoolean object]
doc:add_property(name, number_value)
  -> [newly created ObservableNumber object]
doc:add_property(name, string_value)
  -> [newly created ObservableString object]
doc:add_property(name, list)
  -> [newly created ObservableList object]
doc:add_property(name, node)
  -> [newly created DocumentNode object]
doc:add_property(name, node_list)
  -> [newly created DocumentList object]

-- Remove a previously added property. Property must exist.
doc:remove_property(document or observable object)


-- Save the whole document tree to an XML file. Overwrites all contents of the
-- file when it already exists.
doc:save_as(file_name)
  -> [success, error_string or nil on success]

-- Load the document tree from an XML file. This will NOT create new properties,
-- except for list items, but will only assign existing property values in the
-- document node with existing property values from the XML.
-- This means: nodes that only exist in the XML will silently be ignored.
-- Nodes that only exist in the document, will not be altered in any way.
-- The loaded document's type must match the document type that saved the XML
-- data.
-- A document's type is specified in the renoise.Document.create() function
-- as 'model_name'. For classes which inherit from renoise.Document.DocumentNode
-- it's the class name.
doc:load_from(file_name)
  -> [success, error_string or nil on success]


-- Serialize the whole document tree to a XML string. 
doc:to_string()
  -> [string]

-- Parse document tree from the given string data. See doc:load_from for details
-- about how properties are parsed and errors are handled.
doc:from_string(string)
  -> [boolean, error_String]


--------------------------------------------------------------------------------
-- renoise.Document.DocumentList
--------------------------------------------------------------------------------

-------- Operators

-- Query a list's size (item count).
#doc_list
  -> [Number]

-- Access a document item from the list by index (returns nil for non
-- existing items).
doc_list[number]
  -> [renoise.Document.DocumentNode object]


-------- Functions

-- Returns the number of entries in the list.
doc_list:size()
  -> [number]


-- List item access by index (returns nil for non existing items).
doc_list:property(index)
  -> [nil or renoise.Document.DocumentNode object]

-- Insert a new item to the end of the list when no position is specified, or
-- at the specified position. Returns the inserted DocumentNode.
doc_list:insert([pos,] doc_object)
  -> [inserted renoise.Document.DocumentNode object]

-- Removes an item (or the last one if no index is specified) from the list.
doc_list:remove([pos])

-- Swaps the positions of two items without adding/removing them.
-- With a series of swaps you can move the item from/to any position.
doc_list:swap(pos1, pos2)


-------- Notifiers

-- Notifiers behave exactly like renoise.Document.ObservableXXXLists. Please
-- have a look at those for more info.

doc_list:has_notifier(function or (object, function) or
  (function, object)) -> [boolean]

doc_list:add_notifier(function or (object, function) or
  (function, object))

doc_list:remove_notifier(function or (object, function) or
 (function, object) or (object))
