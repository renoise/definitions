---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------
---## RenderScriptOptions

---Options for the render functions. All undefined properties will fall back to the
---user preferences values from the script preview
---@class RenderScriptOptions
---Lines per beat of the target phrase.
---@field lpb number?
---Maximum events (not pattern lines) that will be rendered
---@field max_events number?

--------------------------------------------------------------------------------
---## renoise.InstrumentPhraseScript

---@class renoise.InstrumentPhraseScript
renoise.InstrumentPhraseScript = {}

---### properties

---@class renoise.InstrumentPhraseScript
---
---When false, a preview of the script is shown instead of a text editor.
---@field editor_visible boolean
---fired, when the editor visibility changed.
---@field editor_visible_observable renoise.Document.Observable
---
--- **READ-ONLY** List of script input parameters, if any.
---@field parameters renoise.DeviceParameter[]
---fired, when the input parameter set changed.
---@field parameters_observable renoise.Document.ObservableList
---
---Script content. When changing paragraphs, changes are visible in the
---script editor, but are not applied for playback until they get committed.
---See also @function `commit` and @field `committed_observable`.
---@field paragraphs string[]
---Notifier which is called when a paragraph got added or removed.
---@field paragraphs_observable renoise.Document.DocumentList
---Notifier which is called when existing paragraph content changed.
---@field paragraphs_assignment_observable renoise.Document.Observable
---
---**READ-ONLY** When not empty, the script failed to compile.
---This error text is also visible to the user in the script preview.
---@field compile_error string
---@field compile_error_observable renoise.Document.Observable
---**READ-ONLY** When not empty, script compiled successfully, but caused an
---error while running. This error text is also visible to the user in the
---script editor.
---@field runtime_error string
---@field runtime_error_observable renoise.Document.Observable
---
---**READ-ONLY** Number of changes since the last commit() or auto-commit call,
---that have been applied to the parapgraphs.
---Note: `auto-commit` only is applied for scripts which are currently edited.
---@field pending_changes integer
---@field pending_changes_observable renoise.Document.Observable
---
---Fired when script paragraph changes got committed: Either by an explicit
---`commit` call or via `auto-commit` in the editor when the script currently is
---edited. Script compile errors will be set or cleared *after* the observable
---fires as the commit & compilation happens asynchroniously in the player engine.
---@field committed_observable renoise.Document.Observable

---### functions

---Access to a single input parameter by index. Use properties 'parameters'
---to iterate over all parameters and to query the parameter count.
---@param index integer
---@return renoise.DeviceParameter
function renoise.InstrumentPhraseScript:parameter(index) end

---Commit paragraph changes for playback.
function renoise.InstrumentPhraseScript:commit() end

---@alias RenderingDoneCallback fun(error: string?, rendered_events: integer, skipped_events: integer)

---Render script content with the given options to the phrase pattern.
---Only committed content will be rendered, so make sure to commit changes first.
---Parameter `rendering_done_callback` is called with the results:
--- * `error`: nil when the rendering succeeded, otherwise a string describing the error
--- * `rendered_events`: number of successfully rendered raw events (not pattern lines) or 0
--- * `skipped_events`: number of skipped raw events, in case the pattern couldn't fit all events, or 0
---@param options RenderScriptOptions
---@param rendering_done_callback RenderingDoneCallback
---@overload fun(self, rendering_done_callback: RenderingDoneCallback): boolean, string?
function renoise.InstrumentPhraseScript:render_to_pattern(options, rendering_done_callback) end

---Same as `render_to_pattern`, but rendering into a temporary phrase object in the clipboard,
---which can then be pasted by the user somewhere.
---@param options RenderScriptOptions
---@param rendering_done_callback RenderingDoneCallback
---@overload fun(self, rendering_done_callback: RenderingDoneCallback): boolean, string?
function renoise.InstrumentPhraseScript:render_to_clipboard(options, rendering_done_callback) end
