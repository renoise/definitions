---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------

---Thin wrapper around the public domain SQLite database engine.
---
---For more information about the SQL features supported by SQLite and details
---about the syntax of SQL statements and queries, please see the SQLite
---documentation at https://www.sqlite.org/.
---
---The Lua bindings and this documentation are based on a simplified version of
---https://lua.sqlite.org/
---
---@class SQLite
---
---**READ-ONLY** SQLite version information, in the form `x.y[.z[.p]]`.
---@field version string
renoise.SQLite = {}

---### constants

---@enum SQLiteStatusCode
renoise.SQLite.Status = {
  ---The operation was successful and that there were no errors.
  ---Most other result codes indicate an error.
  OK = 0,
  ERROR = 1,
  INTERNAL = 2,
  PERM = 3,
  ABORT = 4,
  BUSY = 5,
  LOCKED = 6,
  NOMEM = 7,
  READONLY = 8,
  INTERRUPT = 9,
  IOERR = 10,
  CORRUPT = 11,
  NOTFOUND = 12,
  FULL = 13,
  CANTOPEN = 14,
  MISMATCH = 20,
  MISUSE = 21,
  NOLFS = 22,
  FORMAT = 24,
  RANGE = 25,
  NOTADB = 26,
  ROW = 100,
  DONE = 101,
}

---### functions

---Configure database open mode.
---Default: "rwc" (read-write-create).
---@alias SQLiteOpenModes "ro"|"rw"|"rwc"

---Raw open mode flags from SQLite.
---See https://sqlite.org/c3ref/open.html#urifilenamesinsqlite3open
---@alias SQLiteOpenFlags integer

---Opens (or creates if it does not exist) a SQLite database either in memory
---or from the given file path.
---
---### Examples:
---
---```lua
----- open an existing db in read-only mode.
---local db, status, error = renoise.SQLite.open('MyDatabase.sqlite', 'ro')
---if db then
---  -- do some database calls...
---  db:close()
---else
---  -- handle error
---end
---
----- open an in-memory db in read-write-create mode.
---local db, status, error = renoise.SQLite.open()
---if db then
---  -- do some database calls...
---  db:close()
---else
---  -- handle error
---end
---```
---
---@param filename? string The name of the database file. When undefined or nil a new in-memory db is created.
---@param flags? SQLiteOpenModes|SQLiteOpenFlags Optional flags that can be passed to control the behavior of this function.
---@return SQLiteDatabase?, SQLiteStatusCode?, string?
function renoise.SQLite.open(filename, flags) end

--------------------------------------------------------------------------------

---@alias SQLiteValue string | integer

---@class SQLiteDatabase : userdata
---
---**READ-ONLY** Whether or not the database is open.
---@field is_open boolean
---**READ-ONLY** Whether or not the database is closed.
---@field is_closed boolean
---
---**READ-ONLY** The most recent error code.
---@field error_code SQLiteStatusCode
---**READ-ONLY** The most recent error message.
---@field error_message string 
---
---**READ-ONLY** Number of database rows that were changed, inserted, or deleted by 
---the most recent SQL statement. 
---Only changes that are directly specified by INSERT, UPDATE, or DELETE statements
---are counted.
---Auxiliary changes caused by triggers are not counted. Use `db.total_changes`
---to find the total number of changes.
---@field changes integer
---**READ-ONLY** The number of database rows that have been modified by INSERT, 
---UPDATE or DELETE statements since the database was opened.
---This includes UPDATE, INSERT and DELETE statements executed as part of
---trigger programs. All changes are counted as soon as the statement that
---produces them is completed by calling either `stmt:reset()` or `stmt:finalize()`.
---@field total_changes integer
---
---**READ-ONLY** Gets the rowid of the most recent INSERT into the database.
---If no inserts have ever occurred, 0 is returned.
---(Each row in an SQLite table has a unique 64-bit signed integer
---key called the 'rowid'. This id is always available as an undeclared
---column named ROWID, OID, or _ROWID_.
---If the table has a column of type INTEGER PRIMARY KEY then that column
---is another alias for the rowid.)
---
---If an INSERT occurs within a trigger, then the rowid of the inserted
---row is returned as long as the trigger is running. Once the trigger terminates,
---the value returned reverts to the last value inserted before the trigger fired.
---@field last_insert_rowid integer
local SQLiteDatabase = {}

--- Closes a database. All SQL statements prepared using `db:prepare()` should
---have been finalized before this function is called.
---
---The function returns `renoise.SQLlite.Status.OK` on success or else a error code.
---@return SQLiteStatusCode
function SQLiteDatabase:close() end

---Compiles the SQL statement in string sql into an internal representation
---and returns this as userdata. The returned object should be used for all
---further method calls in connection with this specific SQL statement.
---
---The function returns the statement object and `renoise.SQLlite.Status.OK`
---on success or else nil, an error code and the error message.
---
---### Examples:
---
---```lua
---local statement, code, error = db:prepare("SELECT * from my_table")
---if statement then
---  -- bind, step or do some queries
---else
---  -- handle error
---end
---```
---@see SQLiteStatement
---@param sql string
---@return SQLiteStatement?, SQLiteStatusCode, string?
function SQLiteDatabase:prepare(sql) end

--- Finalizes all statements that have not been explicitly finalized.
---@param temp_only? boolean # Only finalize temporary and internal statements.
function SQLiteDatabase:finalize(temp_only) end

---Compiles and executes the SQL statement(s) given in string sql.
---The statements are simply executed one after the other and not stored.
---
---The function returns `renoise.SQLlite.Status.OK` on success or else an
---error code and the error message.
---
---If one or more of the SQL statements are queries, then the callback
---function specified in `fun` is invoked once for each row of the query
---result (if `fun` is `nil`, no callback is invoked).
---
---The callback receives four arguments:
---`data` (the third parameter of the `db:exec()` call),
---the number of columns in the row, a table with the column values
---and another table with the column names.
---
---The callback function should return `0`. If the callback returns
---a non-zero value then the query is aborted, all subsequent SQL statements
---are skipped and `db:exec()` returns `sqlite.ABORT`.
---
---### Example:
---
---```lua
---sql = [[
---  CREATE TABLE numbers(num1,num2,str);
---  INSERT INTO numbers VALUES(1,11,"ABC");
---  INSERT INTO numbers VALUES(2,22,"DEF");
---  INSERT INTO numbers VALUES(3,33,"UVW");
---  INSERT INTO numbers VALUES(4,44,"XYZ");
---  SELECT * FROM numbers;
---]]
---function show_row(udata,cols,values,names)
---  assert(udata=='test_udata')
---  print('exec:')
---  for i=1,cols do print('',names[i],values[i]) end
---  return 0
---end
---db:execute(sql,show_row,'test_udata')
---```
---@param sql string
---@param fun? fun(data: any, cols: integer, values: table<SQLiteValue>, names: table<string>)
---@param data? any
---@return SQLiteStatusCode, string?
function SQLiteDatabase:execute(sql, fun, data) end

--- Causes any pending database operation to abort and return at the next opportunity.
function SQLiteDatabase:interrupt() end

---Sets or removes a busy handler for a SQLiteDatabase. 
---`fun` is either a Lua function that implements the busy handler or `nil`
---to remove a previously set handler. This function returns nothing.
---The handler function is called with two parameters: `data` and the number
---of (re-)tries for a pending transaction.
---It should return `nil`, `false` or `0` if the transaction is to be aborted.
---All other values will result in another attempt to perform the transaction.
---
---(See the SQLite documentation for important hints about writing busy handlers.)
---@param fun? fun(udata: any, retries: integer): boolean
---@param data? any
function SQLiteDatabase:busy_handler(fun, data) end

---Sets a busy handler that waits for `t` milliseconds if a transaction cannot
---proceed. Calling this function will remove any busy handler set by `db:busy_handler()`;
---calling it with an argument less than or equal to 0 will turn off all busy handlers.
---@param t integer
function SQLiteDatabase:busy_timeout(t) end

---Creates an iterator that returns the successive rows selected
---by the SQL statement given in string sql.
---
---Each call to the iterator returns a table in which the named fields correspond
---to the columns in the database.
---@param sql string
---@return fun(): table<string, SQLiteValue>?
function SQLiteDatabase:nrows(sql) end

---Creates an iterator that returns the successive rows selected by the SQL
---statement given in string `sql`. Each call to the iterator returns a table
---in which the numerical indices 1 to n correspond to the selected columns
--1 to n in the database.
---
---### Example:
---
---```lua
---for a in db:rows('SELECT * FROM table') do
---  for _,v in ipairs(a) do print(v) end
---end
---```
---@param sql string
---@return fun(): any[]
function SQLiteDatabase:rows(sql) end

---Creates an iterator that returns the successive rows selected by the SQL
---statement given in string sql. Each call to the iterator returns the values
---that correspond to the columns in the currently selected row.
---
---### Example:
---
---```lua
---for num1,num2 in db:urows('SELECT * FROM table') do
---  print(num1,num2)
---end
---```
---@param sql string
---@return fun(): SQLiteValue?
function SQLiteDatabase:urows(sql) end

--------------------------------------------------------------------------------

---Precompiled SQLite statements, as created with `db:prepare()`.
---@class SQLiteStatement: userdata
---
---**READ-ONLY** Whether or not the statement hasn't been finalized.
---@field is_open boolean
---**READ-ONLY** Whether or not the statement has been finalized.
---@field is_closed boolean
---
---**READ-ONLY** Number of columns in the result set returned by the statement,
---or 0 if the statement does not return data (for example an UPDATE).
---@field columns integer
---
---**READ-ONLY** rowid of the most recent INSERT into the database corresponding 
---to this statement.
---@field last_insert_rowid integer
---
---**READ-ONLY** A table with the names and types of all columns in the current
---result set of the statement.
---@field named_types table<string, string>
---**READ-ONLY** A table with names and values of all columns in the current
---result row of a query.
---@field named_values table<string, SQLiteValue>
---
---**READ-ONLY** A list of the names of all columns in the result set returned
---by the statement.
---@field names string[]
---**READ-ONLY** A list of the values of all columns in the result set
---returned by the statement.
---@field values SQLiteValue[]
---**READ-ONLY** A list of the types of all columns in the result set returned
---by the statement.
---@field types string[]
---
---**READ-ONLY** A list of the names of all columns in the result set returned
---by the statement.
---@field unames string[]
---**READ-ONLY** A list of the types of all columns in the result set returned
---by the statement.
---@field utypes string[]
---**READ-ONLY** A list of the values of all columns in the current result
---row of a query.
---@field uvalues SQLiteValue[]
local SQLiteStatement = {}

---### functions

---The name of column `n` in the result set of the statement.
---(The left-most column is number 0.)
---@param n integer
---@return string
function SQLiteStatement:name(n) end

---The value of column `n` in the result set of the statement.
---(The left-most column is number 0.)
---@param n integer
---@return SQLiteValue
function SQLiteStatement:value(n) end

---The type of column `n` in the result set of the statement.
---(The left-most column is number 0.)
---@param n integer
---@return string
function SQLiteStatement:type(n) end

---Frees a prepared statement.
---
---If the statement was executed successfully, or not executed at all,
---then `renoise.SQLlite.Status.OK` is returned. If execution of the statement
---failed then an error code is returned.
---@return SQLiteStatusCode
function SQLiteStatement:finalize() end

---Resets the statement so that it is ready to be re-executed.
---Any statement variables that had values bound to them using
---the `stmt:bind*()` functions retain their values.
function SQLiteStatement:reset() end

---Evaluates the (next iteration of the) prepared statement.
---It will return one of the following values:
--- - `renoise.SQLite.Status.BUSY`: the engine was unable to acquire the locks needed. 
---   If the statement is a COMMIT or occurs outside of an explicit transaction, 
---   then you can retry the statement. If the statement is not a COMMIT and
---   occurs within a explicit transaction then you should rollback the transaction
---   before continuing.
--- - `renoise.SQLite.Status.DONE`: the statement has finished executing successfully. 
---   `stmt:step()` should not be called again on this statement without first
---   calling `stmt:reset()` to reset the virtual machine back to the initial state.
--- - `renoise.SQLite.Status.ROW`: this is returned each time a new row of data is ready.
---   The values may be accessed using the column access functions. 
---   `stmt:step()` can be called again to retrieve the next row of data.
--- - `renoise.SQLite.Status.ERROR`: a run-time error (e.g. a constraint violation) occurred.
---   `stmt:step()` should not be called again. More information may be found by
---   calling `db:error_message()`. A more specific error code can be obtained by calling 
---   `stmt:reset()`.
--- - `renoise.SQLite.Status.MISUSE`: the function was called inappropriately.
---   Perhaps because the statement has already been finalized or a previous call to 
---   `stmt:step()` has returned `sqlite.ERROR` or `sqlite.DONE`.
---@return SQLiteStatusCode
function SQLiteStatement:step() end

---Gets the largest statement parameter index in prepared statement stmt.
---When the statement parameters are of the forms ":AAA" or "?", then they
---are assigned sequentially increasing numbers beginning with one, so the
---value returned is the number of parameters.
---However if the same statement parameter name is used multiple times,
---each occurrence is given the same number, so the value returned is the
---number of unique statement parameter names.
---
---If statement parameters of the form "?NNN" are used (where NNN is an
---integer) then there might be gaps in the numbering and the value returned
---by this interface is the index of the statement parameter with the largest
---index value.
---@return integer
function SQLiteStatement:bind_parameter_count() end

---Gets the name of the `n`-th parameter in prepared statement stmt.
---Statement parameters of the form ":AAA" or "@AAA" or "$VVV" have
---a name which is the string ":AAA" or "@AAA" or "$VVV".
---In other words, the initial ":" or "$" or "@" is included as part of the name.
---Parameters of the form "?" or "?NNN" have no name.
---The first bound parameter has an index of 1. If the value `n` is out of
---range or if the `n`-th parameter is nameless, then nil is returned.
---
---The function returns `renoise.SQLlite.Status.OK` on success or else a numerical error code.
---@return string?
---@return SQLiteStatusCode
---@see SQLiteStatusCode
function SQLiteStatement:bind_parameter_name(n) end

---Binds `value` to statement parameter `n`. If `value` is a string, it is
---bound as text, otherwise if it is a number it is bound as a double.
---If it is a boolean, it is bound as 0 or 1.
---If `value` is nil, any previous binding is removed.
---
---The function returns `renoise.SQLlite.Status.OK` on success or else a error code.
---@param n integer
---@param value? string | number | boolean
---@return SQLiteStatusCode
function SQLiteStatement:bind(n, value) end

---Binds string `blob` (which can be a binary string) as a blob to
---statement parameter `n`.
---
---The function returns `renoise.SQLlite.Status.OK` on success or else a error code.
---@param n integer
---@param blob string
---@return SQLiteStatusCode
function SQLiteStatement:bind_blob(n, blob) end

---Binds the values in `nametable` to statement parameters.
---
---If the statement parameters are named (i.e., of the form ":AAA" or "$AAA")
---then this function looks for appropriately named fields in nametable;
---if the statement parameters are not named, it looks for numerical fields 1
---to the number of statement parameters.
---
---The function returns `renoise.SQLlite.Status.OK` on success or else a error code.
---@param nametable table<string | integer, string | number | boolean>
---@return SQLiteStatusCode
function SQLiteStatement:bind_names(nametable) end

---Binds the given values to statement parameters.
---
---The function returns `renoise.SQLlite.Status.OK` on success or else a error code.
---@param ... string | number | boolean
---@return SQLiteStatusCode
---@see SQLiteStatusCode
function SQLiteStatement:bind_values(...) end


---Creates an iterator over the names and values of the result
---set of the statement. Each iteration returns a table with the names
---and values for the current row.
---
---This is the prepared statement equivalent of `db:nrows()`.
---@return fun(): table<string, string | integer>?
---@see SQLiteDatabase.nrows
function SQLiteStatement:nrows() end

---Creates an iterator over the values of the result set of the statement.
---Each iteration returns an array with the values for the current row.
---This is the prepared statement equivalent of `db:rows()`.
---@return fun(): any[]
---@see SQLiteDatabase.rows
function SQLiteStatement:rows() end

---Creates an iterator over the values of the result set of the statement.
---Each iteration returns the values for the current row.
---This is the prepared statement equivalent of `db:urows()`.
---@return fun(): (string | number)?
---@see SQLiteDatabase.urows
function SQLiteStatement:urows() end
