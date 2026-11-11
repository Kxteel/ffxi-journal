-- Small icons drawn with lines, so they do not depend on a font (the infinity
-- sign is not in the fonts the Journal loads).

local M = {}

local SEGMENTS = 36

-- Points of a lemniscate (the infinity sign) for a half width of 1. They are
-- computed once.
local unit_points = {}

for i = 0, SEGMENTS do
    local t = (i / SEGMENTS) * 2 * math.pi
    local s = math.sin(t)
    local c = math.cos(t)
    local d = 1 + s * s

    unit_points[#unit_points + 1] = { c / d, (s * c) / d }
end

-- Width and height of the infinity sign for a line of text this tall.
function M.infinity_size(line_height)
    local width = math.floor((line_height or 16) * 0.95 + 0.5)

    return width, math.floor(width * 0.45 + 0.5)
end

-- Draws the infinity sign inside the box that starts at x, y. color is an
-- already converted color (GetColorU32).
function M.draw_infinity(draw, x, y, width, height, color, thickness)
    if draw == nil then
        return
    end

    local half = width * 0.5
    local cx = x + half
    local cy = y + height * 0.5

    local previous = nil

    for _, point in ipairs(unit_points) do
        local px = cx + point[1] * half
        local py = cy + point[2] * half

        if previous ~= nil then
            draw:AddLine(
                { previous[1], previous[2] },
                { px, py },
                color,
                thickness or 2.0
            )
        end

        previous = { px, py }
    end
end

-- A filled leaf: the lens between a base point and a tip, drawn as a strip of
-- triangles. width is the widest part of the leaf.
local function draw_leaf(draw, base_x, base_y, tip_x, tip_y, width, color)
    local dx = tip_x - base_x
    local dy = tip_y - base_y
    local length = math.sqrt(dx * dx + dy * dy)

    if length <= 0 then
        return
    end

    local nx = -dy / length
    local ny = dx / length
    local steps = 8
    local left = {}
    local right = {}

    for i = 0, steps do
        local t = i / steps
        local half = math.sin(math.pi * t) * width * 0.5
        local px = base_x + dx * t
        local py = base_y + dy * t

        left[#left + 1] = { px + nx * half, py + ny * half }
        right[#right + 1] = { px - nx * half, py - ny * half }
    end

    for i = 1, steps do
        draw:AddTriangleFilled(left[i], left[i + 1], right[i], color)
        draw:AddTriangleFilled(left[i + 1], right[i + 1], right[i], color)
    end
end

-- A green sprout (a stem with two leaves) inside the square that starts at
-- x, y. The colors are already converted (GetColorU32).
function M.draw_sprout(draw, x, y, size, leaf_color, leaf_color_2, stem_color)
    if draw == nil then
        return
    end

    local cx = x + size * 0.5

    draw:AddLine(
        { cx, y + size * 0.96 },
        { cx, y + size * 0.52 },
        stem_color,
        math.max(2.0, size * 0.09)
    )

    draw_leaf(
        draw,
        cx, y + size * 0.55,
        x + size * 0.06, y + size * 0.22,
        size * 0.30,
        leaf_color
    )

    draw_leaf(
        draw,
        cx, y + size * 0.55,
        x + size * 0.94, y + size * 0.12,
        size * 0.34,
        leaf_color_2
    )
end

-- A question mark inside the square that starts at x, y: a hook drawn with
-- line segments, a stem and a square dot (two triangles). color is already
-- converted (GetColorU32).
function M.draw_question(draw, x, y, size, color)
    if draw == nil then
        return
    end

    local cx = x + size * 0.5
    local cy = y + size * 0.31
    local radius = size * 0.25
    local thickness = math.max(2.0, size * 0.15)

    -- The hook: from the left, over the top and the right side, down to the
    -- center line.
    local start_angle = math.rad(185)
    local end_angle = math.rad(450)
    local steps = 30
    local previous = nil

    for i = 0, steps do
        local angle = start_angle + (end_angle - start_angle) * (i / steps)
        local point = {
            cx + math.cos(angle) * radius,
            cy + math.sin(angle) * radius,
        }

        if previous ~= nil then
            draw:AddLine(previous, point, color, thickness)
        end

        previous = point
    end

    -- The stem, from the end of the hook down.
    draw:AddLine(
        { cx, cy + radius },
        { cx, y + size * 0.68 },
        color,
        thickness
    )

    -- The dot.
    local half = math.max(1.2, thickness * 0.62)
    local dot_y = y + size * 0.9

    draw:AddTriangleFilled(
        { cx - half, dot_y - half },
        { cx + half, dot_y - half },
        { cx - half, dot_y + half },
        color
    )
    draw:AddTriangleFilled(
        { cx + half, dot_y - half },
        { cx + half, dot_y + half },
        { cx - half, dot_y + half },
        color
    )
end

-- A compass inside the square that starts at x, y: a ring, a needle made of
-- two triangles (the north half in needle_color, the south half in
-- needle_color_2) and a small center dot. Colors are already converted
-- (GetColorU32).
function M.draw_compass(draw, x, y, size, ring_color, needle_color, needle_color_2)
    if draw == nil then
        return
    end

    local cx = x + size * 0.5
    local cy = y + size * 0.5
    local radius = size * 0.46
    local thickness = math.max(1.5, size * 0.09)
    local steps = 28
    local previous = nil

    for i = 0, steps do
        local angle = math.pi * 2 * (i / steps)
        local point = {
            cx + math.cos(angle) * radius,
            cy + math.sin(angle) * radius,
        }

        if previous ~= nil then
            draw:AddLine(previous, point, ring_color, thickness)
        end

        previous = point
    end

    -- The needle points to the upper right.
    local angle = math.rad(45)
    local sin = math.sin(angle)
    local cos = math.cos(angle)
    local length = radius * 0.78
    local half_width = radius * 0.24

    local function point(px, py)
        return {
            cx + (px * cos - py * sin) * length,
            cy + (px * sin + py * cos) * length,
        }
    end

    local side = half_width / length

    draw:AddTriangleFilled(
        point(0, -1),
        point(-side, 0),
        point(side, 0),
        needle_color
    )
    draw:AddTriangleFilled(
        point(0, 1),
        point(-side, 0),
        point(side, 0),
        needle_color_2
    )

    local dot = math.max(1.0, size * 0.05)

    draw:AddTriangleFilled(
        { cx - dot, cy - dot },
        { cx + dot, cy - dot },
        { cx, cy + dot },
        ring_color
    )
end

-- A thumbtack inside the square that starts at x, y, drawn with lines and
-- triangles. filled = false draws only its outline (an item that is not
-- pinned). color is already converted (GetColorU32).
local function draw_box(draw, x0, y0, x1, y1, color, filled, thickness)
    if filled then
        draw:AddTriangleFilled({ x0, y0 }, { x1, y0 }, { x0, y1 }, color)
        draw:AddTriangleFilled({ x1, y0 }, { x1, y1 }, { x0, y1 }, color)
    else
        draw:AddLine({ x0, y0 }, { x1, y0 }, color, thickness)
        draw:AddLine({ x1, y0 }, { x1, y1 }, color, thickness)
        draw:AddLine({ x1, y1 }, { x0, y1 }, color, thickness)
        draw:AddLine({ x0, y1 }, { x0, y0 }, color, thickness)
    end
end

function M.draw_pin(draw, x, y, size, color, filled)
    if draw == nil then
        return
    end

    local thickness = math.max(1.2, size * 0.09)
    local cx = x + size * 0.5

    -- The head, the flange and the needle.
    draw_box(
        draw,
        cx - size * 0.17, y + size * 0.04,
        cx + size * 0.17, y + size * 0.40,
        color, filled, thickness
    )

    draw_box(
        draw,
        cx - size * 0.30, y + size * 0.40,
        cx + size * 0.30, y + size * 0.50,
        color, filled, thickness
    )

    draw:AddLine(
        { cx, y + size * 0.50 },
        { cx, y + size * 0.96 },
        color,
        thickness
    )
end

-- A check mark (a V) inside the square that starts at x, y. progress goes
-- from 0 to 1 and draws it stroke by stroke. color is already converted
-- (GetColorU32).
function M.draw_check(draw, x, y, size, color, progress, thickness)
    if draw == nil then
        return
    end

    local ax, ay = x + size * 0.10, y + size * 0.55
    local bx, by = x + size * 0.38, y + size * 0.82
    local cx, cy = x + size * 0.92, y + size * 0.20

    local first = math.sqrt((bx - ax) ^ 2 + (by - ay) ^ 2)
    local second = math.sqrt((cx - bx) ^ 2 + (cy - by) ^ 2)
    local drawn = math.max(0, math.min(1, progress or 1)) * (first + second)
    local width = thickness or math.max(2.5, size * 0.16)

    if drawn <= 0 then
        return
    end

    local share = math.min(1, drawn / first)

    draw:AddLine(
        { ax, ay },
        { ax + (bx - ax) * share, ay + (by - ay) * share },
        color,
        width
    )

    if drawn > first then
        share = math.min(1, (drawn - first) / second)

        draw:AddLine(
            { bx, by },
            { bx + (cx - bx) * share, by + (cy - by) * share },
            color,
            width
        )
    end
end

-- A filled five-point star in the box that starts at x, y: a fan of triangles
-- from the center. color is an already converted color (GetColorU32).
function M.draw_star(draw, x, y, size, color)
    if draw == nil then
        return
    end

    local cx = x + size * 0.5
    local cy = y + size * 0.54
    local outer = size * 0.5
    local inner = outer * 0.42
    local points = {}

    for i = 0, 9 do
        local radius = (i % 2 == 0) and outer or inner
        local angle = -math.pi / 2 + i * math.pi / 5

        points[#points + 1] = {
            cx + math.cos(angle) * radius,
            cy + math.sin(angle) * radius,
        }
    end

    for i = 1, 10 do
        local a = points[i]
        local b = points[i % 10 + 1]

        draw:AddTriangleFilled(
            { cx, cy },
            { a[1], a[2] },
            { b[1], b[2] },
            color
        )
    end
end

-- An arrow head centered on (cx, cy). angle is in radians: 0 points up and
-- a positive angle turns it to the right. size is the distance from the
-- center to the tip.
function M.draw_arrow(draw, cx, cy, size, angle, color)
    local sin = math.sin(angle)
    local cos = math.cos(angle)

    local function point(px, py)
        return {
            cx + (px * cos - py * sin) * size,
            cy + (px * sin + py * cos) * size,
        }
    end

    local tip = point(0, -1)
    local left = point(-0.62, 0.78)
    local notch = point(0, 0.34)
    local right = point(0.62, 0.78)

    draw:AddTriangleFilled(tip, left, notch, color)
    draw:AddTriangleFilled(tip, notch, right, color)
end

-- A sticky note (post-it): a square with the bottom right corner folded and
-- two lines of "text". Colors are already converted (GetColorU32).
function M.draw_postit(draw, x, y, size, paper, flap, ink)
    if draw == nil then
        return
    end

    local cut = size * 0.72

    -- The paper: a square without the bottom right corner.
    draw:AddRectFilled({ x, y }, { x + size, y + cut }, paper)
    draw:AddRectFilled({ x, y + cut }, { x + cut, y + size }, paper)
    draw:AddTriangleFilled(
        { x + cut, y + cut },
        { x + size, y + cut },
        { x + cut, y + size },
        paper
    )

    -- The folded corner.
    draw:AddTriangleFilled(
        { x + cut, y + cut },
        { x + size, y + cut },
        { x + cut, y + size },
        flap
    )

    -- Two lines of text.
    draw:AddLine(
        { x + size * 0.18, y + size * 0.28 },
        { x + size * 0.82, y + size * 0.28 },
        ink,
        1.5
    )

    draw:AddLine(
        { x + size * 0.18, y + size * 0.5 },
        { x + size * 0.62, y + size * 0.5 },
        ink,
        1.5
    )
end

return M
