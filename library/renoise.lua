---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
-- ## renoise

---Holds all renoise related API functions and classes.
renoise = {}

---### constants

---Currently 6.1. Any changes in the API which are not backwards compatible,
---will increase the internal API's major version number (e.g. from 1.4 -> 2.0).
---All other backwards compatible changes, like new functionality, new functions
---and classes which do not break existing scripts, will increase only the minor
---version number (e.g. 1.0 -> 1.1).
---@type number
renoise.API_VERSION = 6.1

---Renoise Version "Major.Minor.Revision[AlphaBetaRcVersion][Demo]"
---@type string
renoise.RENOISE_VERSION = "Major.Minor.Revision[AlphaBetaRcVersion][Demo]"

---### functions

---Global access to the Renoise Application.
---@return renoise.Application
function renoise.app() end

---Global access to the Renoise Song.
---
---NB: The song instance changes when a new song is loaded or created in Renoise,
---so tools can not memorize the song instance globally once, but must instead
---react on the application's `new_document_observable`
---observable.
---@return renoise.Song?
function renoise.song() end

---Global access to the Renoise Scripting Tool (your XRNX tool).
---
---This is only valid when getting called from a tool and not when e.g. using the
---scripting terminal and editor in Renoise.
---@return renoise.ScriptingTool
function renoise.tool() end
