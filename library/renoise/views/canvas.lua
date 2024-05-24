---@meta
error("Do not try to execute this file. It's just a type definition file.")
---
---Please read the introduction at https://github.com/renoise/xrnx/
---to get an overview about the complete API, and scripting for
---Renoise in general...
---

--------------------------------------------------------------------------------

---Rendering callback for a canvas.
---
---To update the canvas, use the canvas view's `update` function.
---This will will schedule a new drawing as soon as the backend is ready to draw.
---Always draw a complete image here, as the canvas will be completely empty in
---each new render call.
---
---**UI scaling**: the canvas context by default is set up, so that the global UI
---scaling gets applied. So all positions in the canvas context by default use
---**view sizes** and not pixels. If you want to draw in a raw pixel resolution
---reset the canvas transformation via `context.set_transform(1.0, 0.0, 0.0, 1.0, 0.0, 0.0)`
---To query the actual canvas size in pixels, use the context's `size` property.
---
---@see renoise.Views.Canvas.Context
---@alias CanvasRenderFunction fun(context: renoise.Views.Canvas.Context)

---How to draw the canvas context to screen: "transparent" draws with alpha from
---the canvas, "plain" ignores alpha values, which usually is a lot faster to draw.
---Use "plain" to speed up drawing background alike canvas views which cover the
---entire view area. Default: "transparent"
---@alias CanvasMode "plain"|"transparent"

---The canvas view's optional child views.
---Views can later on also be added and removed dynamically after construction via
---`stack:add_view(child)` and `stack:remove_view(child)`
---@alias CanvasChildViews renoise.Views.View[]

--------------------------------------------------------------------------------
---## renoise.Views.Canvas

---A canvas view lets you draw and handle mouse events in a completely
---customisable way.
---
---Note: The content is cached in a texture and not hardware accelerated, so
---it's not suitable for animations, but for static content such as custom
---backgrounds or bitmap-like views.
---```text
---      .--.
---    .'_\/_'.
---    '. /\ .'
---      "||"
---       || /\
---    /\ ||//\)
---   (/\\||/
---______\||/_______
---```
---@class renoise.Views.Canvas : renoise.Views.View
---@field mode CanvasMode
local Canvas = {}

---### functions

---Request background drawing contents of the canvas to be updated in the next
---UI draw cycle.<br>
---
---Size changes of the canvas view, global UI scaling changes, and color theme
---changes will automatically update the canvas, so this is only necessary to
---call when your draw content needs to be updated due to some internal state
---changes.
function Canvas:update() end

--------------------------------------------------------------------------------

---Drawing context for a canvas view.<br>
---
---The context is *similar* to the HTML5 canvas 2d drawing context, with the
---following differences and limitations:
---
---* no text drawing: layer a renoise.Views.Text on top of this view instead.
---* no image and pattern drawing: layer a renoise.Views.Bitmap on top of this
---  view, if you need to draw bitmaps in the canvas.
---* no shadow rendering: that would be awful slow
---* colors can be specified as strings or rgba tables in range [0-255]. when
---  specifying strings, only renoise theme colors are supported (e.g. "button_back").
---* to create gradients use the available `start_XXX` gradient functions
---  instead of creating gradient objects.
---* to set a new fill or stroke color, use the `fill_color` and `stroke_color`
---  properties instead of `fill/strokeStyle`
---
---This canvas implementation is based on 'canvas_ity' by Andrew Kensler
---https://github.com/a-e-k/canvas_ity
---
--- [HTML5 Canvas Documentation](https://www.w3schools.com/tags/ref_canvas.asp)
---@class renoise.Views.Canvas.Context
---
---**READ_ONLY** Size of the render context backend **in raw pixel resolution**.
---This is the view ports size, multiplied with the global UI scaling factor.
---It does not change with transformations.
---@field pixel_size { width: integer, height: integer }
---
---**READ_ONLY** Size of the render context **with transformations applied**.
---This initially will be the view's size. Calls to `transform` or `scale`
---may change the size further.
---@field size { width: integer, height: integer }
---
---The degree of opacity applied to all drawing operations.<br>
---
---If an operation already uses a transparent color, this can make it
---yet more transparent. It must be in the range from 0 for fully transparent
---to 255 for fully opaque. Defaults to 255 (opaque).
---@field global_alpha number
---Compositing operation for blending new drawing and old pixels.<br>
---
---The source_copy, source_in, source_out, destination_atop, and
---destination_in operations may clear parts of the canvas outside the
---new drawing but within the clip region. Defaults to "source_over".
---@field global_composite_operation "source_atop"|"source_copy"|"source_in"|"source_out"|"source_over"|"destination_atop"|"destination_in"|"destination_out"|"destination_over"|"exclusive_or"|"lighter"
---Set filling to use a constant color and opacity.<br>
---
---Defaults a constant color with 0,0,0,255 (opaque black).
---@field fill_color RGBColor|RGBAColor|ThemeColor
---Set stroking to use a constant color and opacity.<br>
---
---Defaults a constant color with 0,0,0,255 (opaque black).
---@field stroke_color RGBColor|RGBAColor|ThemeColor
---Cap style for the ends of open subpaths and dash segments.<br>
---
---The actual shape may be affected by the current transform at the time
---of drawing. Only affects stroking.  Defaults to "butt".
---@field line_cap "butt"|"square"|"circle"
---Join style for connecting lines within the paths.<br>
---
---The actual shape may be affected by the current transform at the time
---of drawing. Only affects stroking. Defaults to "miter".
---@field line_join "miter"|"beval"|"rounded"
---The width of the lines when stroking.<br>
---
---Initially this is measured in pixels, though the current transform
---at the time of drawing can affect this. Must be positive. Defaults to 1.0.
---@field line_width number
---Limit on maximum pointiness allowed for miter joins.<br>
---
---If the distance from the point where the lines intersect to the
---point where the outside edges of the join intersect exceeds this
---ratio relative to the line width, then a bevel join will be used
---instead, and the miter will be lopped off. Larger values allow
---pointier miters. Only affects stroking and only when the line join
---style is miter. Defaults to 10.0.
---@field miter_limit number
---Offset where each subpath starts the dash pattern.<br>
---
---Changing this shifts the location of the dashes along the path and
---animating it will produce a marching ants effect. Only affects
---stroking and only when a dash pattern is set. May be negative or
---exceed the length of the dash pattern, in which case it will wrap.
---Defaults to 0.0.
---@field line_dash_offset number
local CanvasContext = {}

---Restrict the clip region by the current path.<br>
---
---Intersects the current clip region with the interior of the current
---path (the region that would be filled), and replaces the current
---clip region with this intersection. Subsequent calls to clip can
---only reduce this further. When filling or stroking, only pixels
---within the current clip region will change. The current path is
---left unchanged by updating the clip region; begin a new path to
---clear it. Defaults to the entire canvas.
---
---Tip: to be able to reset the current clip region, save the canvas
---state first before clipping then restore the state to reset it.
function CanvasContext:clip() end

---Save the current state as though to a stack.<br>
---
---The full state of the canvas is saved, except for the pixels in the
---canvas buffer, and the current path.
---
---Tip: to be able to reset the current clip region, save the canvas
---state first before clipping then restore the state to reset it.
function CanvasContext:save() end

---Restore a previously saved state as though from a stack.<br>
---
---This does not affect the pixels in the canvas buffer or the current
---path.  If the stack of canvas states is empty, this does nothing.
function CanvasContext:restore() end

---Fill a rectangular area.<br>
---
---This behaves as though the current path were reset to a single
---rectangle and then filled as usual. However, the current path is
---not actually changed. The current transform at the time that this is
---called will affect the given point and rectangle. The width and/or
---the height may be negative but not zero. If either is zero, or the
---current transform is not invertible, this does nothing.
---@param x       number horizontal coordinate of a rectangle corner
---@param y       number vertical coordinate of a rectangle corner
---@param width   number width of the rectangle
---@param height  number height of the rectangle
function CanvasContext:fill_rect(x, y, width, height) end

---Stroke a rectangular area.<br>
---
---This behaves as though the current path were reset to a single
---rectangle and then stroked as usual. However, the current path is
---not actually changed. The current transform at the time that this
---is called will affect the given point and rectangle. The width
---and/or the height may be negative or zero. If both are zero, or
---the current transform is not invertible, this does nothing. If only
---one is zero, this behaves as though it strokes a single horizontal or
---vertical line.
---@param x       number horizontal coordinate of a rectangle corner
---@param y       number vertical coordinate of a rectangle corner
---@param width   number width of the rectangle
---@param height  number height of the rectangle
function CanvasContext:stroke_rect(x, y, width, height) end

---Clear a rectangular area back to transparent black.<br>
---
---The clip region may limit the area cleared. The current path is not
---affected by this clearing. The current transform at the time that
---this is called will affect the given point and rectangle. The width
---and/or the height may be negative or zero. If either is zero, or the
---current transform is not invertible, this does nothing.
---@param x       number horizontal coordinate of a rectangle corner
---@param y       number vertical coordinate of a rectangle corner
---@param width   number width of the rectangle
---@param height  number height of the rectangle
function CanvasContext:clear_rect(x, y, width, height) end

---Reset the current path.<br>
---
---The current path and all subpaths will be cleared after this, and a
---new path can be built.
function CanvasContext:begin_path() end

---Close the current subpath.<br>
---
---Adds a straight line from the end of the current subpath back to its
---first point and marks the subpath as closed so that this line will
---join with the beginning of the path at this point. A new, empty
---subpath will be started beginning with the same first point.  If the
---current path is empty, this does nothing.
function CanvasContext:close_path() end

---Create a new subpath.<br>
---
---The given point will become the first point of the new subpath and
---is subject to the current transform at the time this is called.
---@param x number horizontal coordinate of the new first point
---@param y number vertical coordinate of the new first point
function CanvasContext:move_to(x, y) end

---Extend the current subpath with a straight line.<br>
---
---The line will go from the current end point (if the current path is
---not empty) to the given point, which will become the new end point.
---Its position is affected by the current transform at the time that
---this is called. If the current path was empty, this is equivalent
---to just a move.
---@param x number horizontal coordinate of the new end point
---@param y number vertical coordinate of the new end point
function CanvasContext:line_to(x, y) end

---Draw the interior of the current path using the fill style.<br>
---
---Interior pixels are determined by the non-zero winding rule, with
---all open subpaths implicitly closed by a straight line beforehand.
---If shadows have been enabled by setting the shadow color with any
---opacity and either offsetting or blurring the shadows, then the
---shadows of the filled areas will be drawn first, followed by the
---filled areas themselves. Both will be blended into the canvas
---according to the global alpha, the global compositing operation,
---and the clip region. If the fill style is a gradient or a pattern,
---it will be affected by the current transform. The current path is
---left unchanged by filling; begin a new path to clear it. If the
---current transform is not invertible, this does nothing.
function CanvasContext:fill() end

---Draw the edges of the current path using the stroke style.<br>
---
---Edges of the path will be expanded into strokes according to the
---current dash pattern, dash offset, line width, line join style
---(and possibly miter limit), line cap, and transform. If shadows
---have been enabled by setting the shadow color with any opacity and
---either offsetting or blurring the shadows, then the shadow will be
---drawn for the stroked lines first, then the stroked lines themselves.
---Both will be blended into the canvas according to the global alpha,
---the global compositing operation, and the clip region. If the stroke
---style is a gradient or a pattern, it will be affected by the current
---transform.  The current path is left unchanged by stroking; begin a
---new path to clear it. If the current transform is not invertible,
---this does nothing.
---
---Tip: to draw with a calligraphy-like angled brush effect, add a
---     non-uniform scale transform just before stroking.
function CanvasContext:stroke() end

---Set or clear the line dash pattern.<br>
---
---Takes an array with entries alternately giving the lengths of dash
---and gap segments. All must be non-negative; if any are not, this
---does nothing. These will be used to draw with dashed lines when
---stroking, with each subpath starting at the length along the dash
---pattern indicated by the line dash offset. Initially these lengths
---are measured in pixels, though the current transform at the time of
---drawing can affect this. The count must be non-negative. If it is
---odd, the array will be appended to itself to make an even count. If
---it is zero, or the pointer is null, the dash pattern will be cleared
---and strokes will be drawn as solid lines. The array is copied and
---it is safe to change or destroy it after this call. Defaults to
---solid lines.
---@param segments number[] array for dash pattern
function CanvasContext:set_line_dash(segments) end

---Set filling to use a linear gradient.<br>
---
---Positions the start and end points of the gradient and clears all
---color stops to reset the gradient to transparent black. Color stops
---can then be added again. When drawing, pixels will be painted with
---the color of the gradient at the nearest point on the line segment
---between the start and end points. This is affected by the current
---transform at the time of drawing.
---@param start_x  number horizontal coordinate of the start of the gradient
---@param start_y  number vertical coordinate of the start of the gradient
---@param end_x    number horizontal coordinate of the end of the gradient
---@param end_y    number vertical coordinate of the end of the gradient
function CanvasContext:set_fill_linear_gradient(start_x, start_y, end_x, end_y) end

---Set filling to use a linear gradient.<br>
---
---@see renoise.Views.Canvas.Context:set_fill_linear_gradient
---@param start_x  number horizontal coordinate of the start of the gradient
---@param start_y  number vertical coordinate of the start of the gradient
---@param end_x    number horizontal coordinate of the end of the gradient
---@param end_y    number vertical coordinate of the end of the gradient
function CanvasContext:set_stroke_linear_gradient(start_x, start_y, end_x, end_y) end

---Set filling to use a radial gradient.<br>
---
---Positions the start and end circles of the gradient and clears all
---color stops to reset the gradient to transparent black. Color stops
---can then be added again. When drawing, pixels will be painted as
---though the starting circle moved and changed size linearly to match
---the ending circle, while sweeping through the colors of the gradient.
---Pixels not touched by the moving circle will be left transparent
---black. The radial gradient is affected by the current transform
---at the time of drawing. The radii must be non-negative.
---@param start_x       number horizontal starting coordinate of the circle
---@param start_y       number vertical starting coordinate of the circle
---@param start_radius  number starting radius of the circle
---@param end_x         number horizontal ending coordinate of the circle
---@param end_y         number vertical ending coordinate of the circle
---@param end_radius    number ending radius of the circle
function CanvasContext:set_fill_radial_gradient(start_x, start_y, start_radius, end_x, end_y, end_radius) end

---Set stroke to use a radial gradient.<br>
---
---@see renoise.Views.Canvas.Context:set_fill_radial_gradient
---@param start_x       number horizontal starting coordinate of the circle
---@param start_y       number vertical starting coordinate of the circle
---@param start_radius  number starting radius of the circle
---@param end_x         number horizontal ending coordinate of the circle
---@param end_y         number vertical ending coordinate of the circle
---@param end_radius    number ending radius of the circle
function CanvasContext:set_stroke_radial_gradient(start_x, start_y, start_radius, end_x, end_y, end_radius) end

---Add a color stop to a linear or radial gradient fill.<br>
---
---Each color stop has an offset which defines its position from 0.0 at
---the start of the gradient to 1.0 at the end. Colors and opacity are
---linearly interpolated along the gradient between adjacent pairs of
---stops without premultiplying the alpha. If more than one stop is
---added for a given offset, the first one added is considered closest
---to 0.0 and the last is closest to 1.0. If no stop is at offset 0.0
---or 1.0, the stops with the closest offsets will be extended. If no
---stops are added, the gradient will be fully transparent black. Set a
---new linear or radial gradient to clear all the stops and redefine the
---gradient colors. Color stops may be added to a gradient at any time.
---The color and opacity values will be clamped to the 0.0 to 1.0 range,
---inclusive. The offset must be in the 0.0 to 1.0 range, inclusive.
---If it is not, or if chosen style type is not currently set to a
---gradient, this does nothing.
---@param offset number
---@param color RGBColor|RGBAColor|ThemeColor
function CanvasContext:add_fill_color_stop(offset, color) end

---Add a color stop to a linear or radial gradient stroke.<br>
---
---@see renoise.Views.Canvas.Context:add_fill_color_stop
---@param offset number
---@param color RGBColor|RGBAColor|ThemeColor
function CanvasContext:add_stroke_color_stop(offset, color) end

---Add a closed subpath in the shape of a rectangle.<br>
---
---The rectangle has one corner at the given point and then goes in the
---direction along the width before going in the direction of the height
---towards the opposite corner. The current transform at the time that
---this is called will affect the given point and rectangle. The width
---and/or the height may be negative or zero, and this can affect the
---winding direction.
---@param x       number horizontal coordinate of a rectangle corner
---@param y       number vertical coordinate of a rectangle corner
---@param width   number width of the rectangle
---@param height  number height of the rectangle
function CanvasContext:rect(x, y, width, height) end

---Extend the current subpath with a cubic Bezier curve.<br>
---
---The curve will go from the current end point (or the first control
---point if the current path is empty) to the given point, which will
---become the new end point. The curve will be tangent toward the first
---control point at the beginning and tangent toward the second control
---point at the end. The current transform at the time that this is
---called will affect all points passed in.
---
---Tip: to make multiple curves join smoothly, ensure that each new end
---point is on a line between the adjacent control points.
---@param control_1_x number horizontal coordinate of the first control point
---@param control_1_y number vertical coordinate of the first control point
---@param control_2_x number horizontal coordinate of the second control point
---@param control_2_y number vertical coordinate of the second control point
---@param x           number horizontal coordinate of the new end point
---@param y           number vertical coordinate of the new end point
function CanvasContext:bezier_curve_to(control_1_x, control_1_y, control_2_x, control_2_y, x, y) end

---Extend the current subpath with an arc between two angles.<br>
---
---The arc is from the circle centered at the given point and with the
---given radius. A straight line will be added from the current end
---point to the starting point of the arc (unless the current path is
---empty), then the arc along the circle from the starting angle to the
---ending angle in the given direction will be added. If they are more
---than two pi radians apart in the given direction, the arc will stop
---after one full circle. The point at the ending angle will become
---the new end point of the path. Initially, the angles are clockwise
---relative to the x-axis. The current transform at the time that
---this is called will affect the passed in point, angles, and arc.
---The radius must be non-negative.
---@param x                  number horizontal coordinate of the circle center
---@param y                  number vertical coordinate of the circle center
---@param radius             number radius of the circle containing the arc
---@param start_angle        number radians clockwise from x-axis to begin
---@param end_angle          number radians clockwise from x-axis to end
---@param counter_clockwise  number true if the arc turns counter-clockwise
function CanvasContext:arc(x, y, radius, start_angle, end_angle, counter_clockwise) end

---Extend the current subpath with an arc tangent to two lines.<br>
---
---The arc is from the circle with the given radius tangent to both
---the line from the current end point to the vertex, and to the line
---from the vertex to the given point. A straight line will be added
---from the current end point to the first tangent point (unless the
---current path is empty), then the shortest arc from the first to the
---second tangent points will be added. The second tangent point will
---become the new end point.  If the radius is large, these tangent
---points may fall outside the line segments. The current transform
---at the time that this is called will affect the passed in points
---and the arc. If the current path was empty, this is equivalent to
---a move. If the arc would be degenerate, it is equivalent to a line
---to the vertex point. The radius must be non-negative. If it is not,
---or if the current transform is not invertible, this does nothing.
---
---Tip: to draw a polygon with rounded corners, call this once for each
---vertex and pass the midpoint of the adjacent edge as the second
---point; this works especially well for rounded boxes.
---@param vertex_x number horizontal coordinate where the tangent lines meet
---@param vertex_y number vertical coordinate where the tangent lines meet
---@param x        number a horizontal coordinate on the second tangent line
---@param y        number a vertical coordinate on the second tangent line
---@param radius   number radius of the circle containing the arc
function CanvasContext:arc_to(vertex_x, vertex_y, x, y, radius) end

---Extend the current subpath with a quadratic Bezier curve.<br>
---
---The curve will go from the current end point (or the control point
---if the current path is empty) to the given point, which will become
---the new end point. The curve will be tangent toward the control
---point at both ends. The current transform at the time that this
---is called will affect both points passed in.
---
---Tip: to make multiple curves join smoothly, ensure that each new end
---point is on a line between the adjacent control points.
---@param control_x number horizontal coordinate of the control point
---@param control_y number vertical coordinate of the control point
---@param x         number horizontal coordinate of the new end point
---@param y         number vertical coordinate of the new end point
function CanvasContext:quadratic_curve_to(control_x, control_y, x, y) end

---Scale the current transform.<br>
---
---Scaling may be non-uniform if the x and y scaling factors are
---different.  When a scale factor is less than one, things will be
---shrunk in that direction. When a scale factor is greater than
---one, they will grow bigger. Negative scaling factors will flip or
---mirror it in that direction. The scaling factors must be non-zero.
---If either is zero, most drawing operations will do nothing.
---@param x number horizontal scaling factor
---@param y number vertical scaling factor
function CanvasContext:scale(x, y) end

---Rotate the current transform.<br>
---
---The rotation is applied clockwise in a direction around the origin.
---
---Tip: to rotate around another point, first translate that point to
---the origin, then do the rotation, and then translate back.
---@param angle number clockwise angle in radians
function CanvasContext:rotate(angle) end

---Translate the current transform.<br>
---
---By default, positive x values shift that many pixels to the right,
---while negative y values shift left, positive y values shift up, and
---negative y values shift down.
---@param x number amount to shift horizontally
---@param y number amount to shift vertically
function CanvasContext:translate(x, y) end

---Add an arbitrary transform to the current transform.<br>
---
---This takes six values for the upper two rows of a homogenous 3x3
---matrix (i.e., {{a, c, e}, {b, d, f}, {0.0, 0.0, 1.0}}) describing an
---arbitrary affine transform and appends it to the current transform.
---The values can represent any affine transform such as scaling,
---rotation, translation, or skew, or any composition of affine
---transforms. The matrix must be invertible. If it is not, most
---drawing operations will do nothing.
---@param a number horizontal scaling factor (m11)
---@param b number vertical skewing (m12)
---@param c number horizontal skewing (m21)
---@param d number vertical scaling factor (m22)
---@param e number horizontal translation (m31)
---@param f number vertical translation (m32)
function CanvasContext:transform(a, b, c, d, e, f) end

---Replace the current transform.<br>
---
---This takes six values for the upper two rows of a homogenous 3x3
---matrix (i.e., {{a, c, e}, {b, d, f}, {0.0, 0.0, 1.0}}) describing
---an arbitrary affine transform and replaces the current transform
---with it. The values can represent any affine transform such as
---scaling, rotation, translation, or skew, or any composition of
---affine transforms. The matrix must be invertible. If it is not,
---most drawing operations will do nothing.
---
---Tip: to reset the current transform back to the default, use
---1.0, 0.0, 0.0, 1.0, 0.0, 0.0.
---@param a number horizontal scaling factor (m11)
---@param b number vertical skewing (m12)
---@param c number horizontal skewing (m21)
---@param d number vertical scaling factor (m22)
---@param e number horizontal translation (m31)
---@param f number vertical translation (m32)
function CanvasContext:set_transform(a, b, c, d, e, f) end

--------------------------------------------------------------------------------

---@class CanvasViewProperties : ViewProperties
---@field mode CanvasMode?
---@field render CanvasRenderFunction?
---@field mouse_handler MouseHandler?
---@field mouse_events MouseEventTypes?
---@field views CanvasChildViews?
