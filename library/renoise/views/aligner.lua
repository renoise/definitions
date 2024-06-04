---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

---------------------------------------------------------------------------------

---* Default: "left" (for horizontal_aligner) "top" (for vertical_aligner)
---@alias AlignerMode
---| "left"       # align from left to right (for horizontal_aligner only)
---| "right"      # align from right to left (for horizontal_aligner only)
---| "top"        # align from top to bottom (for vertical_aligner only)
---| "bottom"     # align from bottom to top (for vertical_aligner only)
---| "center"     # center all views
---| "justify"    # keep outer views at the borders, distribute the rest
---| "distribute" # equally distributes views over the aligners width/height

---------------------------------------------------------------------------------
---## renoise.Views.Aligner

---Just like a Rack, the Aligner shows no content on its own. It just aligns
---child views vertically or horizontally. As soon as children are added, the
---Aligner will expand itself to make sure that all children are visible
---(including spacing & margins).
---To make use of modes like "center", you manually have to setup a size that
---is bigger than the sum of the child sizes.
---
---@class renoise.Views.Aligner : renoise.Views.View
---@field margin RackMargin
---@field spacing RackSpacing
---@field mode AlignerMode
local Aligner = {}

---------------------------------------------------------------------------------

---@class AlignerViewProperties : ViewProperties
---@field margin RackMargin?
---@field spacing RackSpacing?
---@field mode AlignerMode?
