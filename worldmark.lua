-- A yellow arrow over the NPC the compass points at (prototype).
--
-- The position of the NPC in the world is turned into a point of the screen
-- with the view and projection matrices of Direct3D. Nobody has confirmed
-- yet that those can be read in the game, or which way the axes of the game
-- go, so everything here is protected and calibrated:
--
--   * The matrices are read with GetTransform in three moments of the frame
--     (the start of the scene, the drawing calls of the 3D pass, and the
--     present). The interface of the game is drawn last with its own flat
--     matrices, so the ones that count are those with a perspective
--     projection. If they cannot be read, nothing is drawn and nothing fails.
--   * The wrapper of Ashita for GetTransform takes only the kind of matrix
--     and RETURNS the matrix (res, matrix); it does not fill a buffer.
--   * The axes are not assumed. The player is always in front of the camera,
--     near the middle of the screen, and a point above the player must go up
--     on the screen. The combination of matrices set, order of the
--     multiplication and axes that does that is the one used.
--   * /journal mark debug prints what was read and what was chosen.

local M = {}

local D3DTS_VIEW = 2
local D3DTS_PROJECTION = 3

-- How high over the position of the NPC the tip of the arrow is.
local HEAD = 3.0

local device = nil
local sets = {}
local choice = nil
local passing = {}
local info = {
    reason = 'not started',
    reads = 0,
    errors = 0,
    last_error = nil,
    last = nil,
    hits = {},
    flat = {},
    events = {},
    viewport = nil,
    display = nil,
}

-- How the position of the game (x, y on the ground, h the height) goes into
-- the world of Direct3D: every order of the three numbers and every sign
-- (48 ways). The right one is found by calibrating.
local MAPS = {}

do
    local names = { 'x', 'y', 'h' }
    local orders = {
        { 1, 2, 3 }, { 1, 3, 2 }, { 2, 1, 3 },
        { 2, 3, 1 }, { 3, 1, 2 }, { 3, 2, 1 },
    }

    for _, order in ipairs(orders) do
        for mask = 0, 7 do
            local signs = {
                (mask % 2 == 0) and 1 or -1,
                (math.floor(mask / 2) % 2 == 0) and 1 or -1,
                (math.floor(mask / 4) % 2 == 0) and 1 or -1,
            }
            local label = {}

            for k = 1, 3 do
                label[k] = (signs[k] > 0 and '+' or '-') .. names[order[k]]
            end

            MAPS[#MAPS + 1] = {
                name = table.concat(label, ','),
                f = function(x, y, h)
                    local v = { x, y, h }

                    return signs[1] * v[order[1]],
                        signs[2] * v[order[2]],
                        signs[3] * v[order[3]]
                end,
            }
        end
    end
end

local CONVENTIONS = { 'row', 'col' }

local function now()
    return os.clock()
end

-- Reading the matrices ---------------------------------------------------------

local function get_device()
    if device ~= nil then
        return device
    end

    local ok, d3d = pcall(require, 'd3d8')

    if not ok or type(d3d) ~= 'table' or d3d.get_device == nil then
        info.reason = 'the d3d8 module is not available'

        return nil
    end

    local got, value = pcall(d3d.get_device)

    if not got or value == nil then
        info.reason = 'no Direct3D device'

        return nil
    end

    device = value

    return device
end

-- The 16 numbers of a D3DMATRIX (a struct returned by value), row by row.
local function matrix_values(ffi, mat)
    local ok, values = pcall(function()
        local holder = ffi.new(ffi.typeof('$[1]', ffi.typeof(mat)))

        holder[0] = mat

        local floats = ffi.cast('float*', holder)
        local m = {}

        for i = 0, 15 do
            m[i + 1] = floats[i]
        end

        return m
    end)

    if ok then
        return values
    end

    -- By the names of the fields.
    local named_ok, named = pcall(function()
        return {
            mat._11, mat._12, mat._13, mat._14,
            mat._21, mat._22, mat._23, mat._24,
            mat._31, mat._32, mat._33, mat._34,
            mat._41, mat._42, mat._43, mat._44,
        }
    end)

    if named_ok and named[1] ~= nil then
        return named
    end

    info.last_error = 'cannot read the fields of the matrix: ' .. tostring(values)

    return nil
end

local function read_matrix(dev, ffi, which)
    local ok, res, mat = pcall(function()
        return dev:GetTransform(which)
    end)

    if not ok then
        info.errors = info.errors + 1
        info.last_error = tostring(res)

        return nil
    end

    if mat == nil then
        info.errors = info.errors + 1
        info.last_error = 'GetTransform returned ' .. tostring(res)
            .. ' and no matrix'

        return nil
    end

    local m = matrix_values(ffi, mat)

    if m == nil then
        info.errors = info.errors + 1

        return nil
    end

    -- The values of an unset matrix are all zeros.
    local sum = 0

    for i = 1, 16 do
        sum = sum + math.abs(m[i])
    end

    if sum == 0 then
        return nil
    end

    return m
end

-- A perspective projection of Direct3D has m34 = 1 and m44 = 0; a flat one
-- (the interface) has m44 = 1.
local function is_perspective(proj)
    return math.abs(proj[16]) < 0.0001 and math.abs(proj[12]) > 0.5
end

-- Reads the view and projection matrices into the set `name`. With
-- only_perspective, a flat projection is not kept. Returns true when kept.
function M.Capture(name, only_perspective)
    local ok_ffi, ffi = pcall(require, 'ffi')

    if not ok_ffi then
        info.reason = 'no ffi'

        return false
    end

    local dev = get_device()

    if dev == nil then
        return false
    end

    local view = read_matrix(dev, ffi, D3DTS_VIEW)
    local proj = read_matrix(dev, ffi, D3DTS_PROJECTION)

    info.reads = info.reads + 1

    if view == nil or proj == nil then
        return false
    end

    local flat = not is_perspective(proj)

    if flat then
        info.flat[name] = (info.flat[name] or 0) + 1
    end

    if only_perspective and flat then
        return false
    end

    sets[name] = { view = view, proj = proj, at = now(), flat = flat }

    return true
end

-- The events of Direct3D, listened to only while the arrow is on.
local EVENTS = {
    { 'd3d_beginscene', 'begin' },
    { 'd3d_drawprimitive', 'draw' },
    { 'd3d_drawindexedprimitive', 'draw' },
    { 'd3d_drawprimitiveup', 'draw' },
    { 'd3d_drawindexedprimitiveup', 'draw' },
}

local CAPTURE_EVERY = 0.03
local last_capture = {}
local listening = false

local function on_event(alias, event)
    info.hits[event] = (info.hits[event] or 0) + 1

    local at = now()

    if at - (last_capture[alias] or -1000) < CAPTURE_EVERY then
        return
    end

    last_capture[alias] = at

    M.Capture(alias, alias == 'draw')
end

-- Starts or stops listening to the events. Protected: an event that does not
-- exist in this version of Ashita is simply not heard (M.GetInfo().events).
function M.SetCapture(on)
    on = on == true

    if on == listening then
        return
    end

    listening = on
    info.events = {}

    if ashita == nil or ashita.events == nil then
        return
    end

    for _, item in ipairs(EVENTS) do
        local event, alias = item[1], item[2]
        local name = 'journal_worldmark_' .. event
        local ok = pcall(function()
            if on then
                ashita.events.register(event, name, function()
                    on_event(alias, event)
                end)
            elseif ashita.events.unregister ~= nil then
                ashita.events.unregister(event, name)
            end
        end)

        if on then
            info.events[#info.events + 1] = event .. (ok and '' or ' (refused)')
        end
    end
end

-- Projection -------------------------------------------------------------------

local function mul_row(m, x, y, z, w)
    return x * m[1] + y * m[5] + z * m[9] + w * m[13],
        x * m[2] + y * m[6] + z * m[10] + w * m[14],
        x * m[3] + y * m[7] + z * m[11] + w * m[15],
        x * m[4] + y * m[8] + z * m[12] + w * m[16]
end

local function mul_col(m, x, y, z, w)
    return m[1] * x + m[2] * y + m[3] * z + m[4] * w,
        m[5] * x + m[6] * y + m[7] * z + m[8] * w,
        m[9] * x + m[10] * y + m[11] * z + m[12] * w,
        m[13] * x + m[14] * y + m[15] * z + m[16] * w
end

-- Clip coordinates (x, y, w) of a world point of Direct3D.
local function project_raw(set, convention, wx, wy, wz)
    -- 'row': point * View * Projection. 'col': Projection * View * point.
    local mul = convention == 'col' and mul_col or mul_row
    local ex, ey, ez, ew = mul(set.view, wx, wy, wz, 1)
    local cx, cy, _, cw = mul(set.proj, ex, ey, ez, ew)

    return cx, cy, cw
end

-- Screen point of a world point of Direct3D, or nil when it is behind the
-- camera. Returns x, y (pixels) and the depth.
local function project(set, convention, wx, wy, wz, width, height)
    local cx, cy, cw = project_raw(set, convention, wx, wy, wz)

    if cw == nil or cw ~= cw or cw <= 0.0001 then
        return nil
    end

    local nx = cx / cw
    local ny = cy / cw

    if nx ~= nx or ny ~= ny then
        return nil
    end

    return (nx * 0.5 + 0.5) * width, (1 - (ny * 0.5 + 0.5)) * height, cw
end

-- Where the player goes on the screen with a combination, and which way the
-- height goes: up = 1 when a higher number of the game is higher on the
-- screen, -1 when it is lower (the client may count the height downwards).
-- Returns the score (the squared distance to the middle of the screen, in
-- fractions of its size) and up, or nil when it does not fit: the player must
-- be in front of the camera, inside the screen, and a point over or under the
-- player must move straight up or down.
local function evaluate(set_name, convention, map, me, view)
    local set = sets[set_name]

    if set == nil then
        return nil
    end

    -- (map.f gives three values: they must be the last argument, or only
    -- the first one would be passed.)
    local ax, ay, az = map.f(me.x, me.y, me.h)
    local x0, y0, d0 = project(set, convention, ax, ay, az, view.w, view.h)

    if x0 == nil
        or x0 < 0 or x0 > view.w or y0 < 0 or y0 > view.h then

        return nil
    end

    local bx, by, bz = map.f(me.x, me.y, me.h + 4.0)
    local x1, y1 = project(set, convention, bx, by, bz, view.w, view.h)

    if x1 == nil then
        return nil
    end

    local dy = y1 - y0

    if math.abs(dy) < 4 or math.abs(x1 - x0) > view.w * 0.12 then
        return nil
    end

    local fx = (x0 - view.w * 0.5) / view.w
    local fy = (y0 - view.h * 0.5) / view.h

    return fx * fx + fy * fy, dy < 0 and 1 or -1, x0, y0
end

local KEEP_SCORE = 0.20

local function calibrate(me, view)
    passing = {}

    if choice ~= nil then
        local score, up = evaluate(
            choice.set, choice.convention, choice.map, me, view
        )

        if score ~= nil and score < KEEP_SCORE then
            choice.score = score
            choice.up = up
            passing[1] = choice

            return choice
        end
    end

    choice = nil

    for _, set_name in ipairs({ 'draw', 'present', 'begin' }) do
        for _, convention in ipairs(CONVENTIONS) do
            for _, map in ipairs(MAPS) do
                local score, up, x0, y0 = evaluate(
                    set_name, convention, map, me, view
                )

                if score ~= nil then
                    passing[#passing + 1] = {
                        set = set_name,
                        convention = convention,
                        map = map,
                        score = score,
                        up = up,
                        x = x0,
                        y = y0,
                    }
                end
            end
        end
    end

    -- The closest to the middle of the screen: the camera follows the player.
    table.sort(passing, function(a, b) return a.score < b.score end)

    choice = passing[1]

    return choice
end

-- For the tests: forget what was read and chosen.
function M.Reset()
    sets = {}
    choice = nil
    passing = {}
    device = nil
    last_capture = {}
    info.hits = {}
    info.flat = {}
    info.reason = 'not started'
    info.reads = 0
    info.errors = 0
    info.last_error = nil
    info.last = nil
end

-- For the tests: use these matrices instead of reading them.
function M.SetMatrices(name, view, proj)
    sets[name] = { view = view, proj = proj, at = now() }
end

-- Where a target goes on the screen, with the combination found by
-- calibrating. Returns { x =, y =, depth = } when the arrow fits on the
-- screen. Otherwise nil, the reason, and (only with edge_on) the direction
-- { dx =, dy = } (a unit vector, y down) in which the NPC is, from the middle
-- of the screen: it works for an NPC in front of the camera but off the
-- screen and for one behind it. view is { x =, y =, w =, h = }.
local function place(picked, target, view, edge_on)
    -- Over the head of the NPC: the way "higher" goes was found by calibrating.
    local px, py, pz = picked.map.f(
        target.x, target.y, target.h + picked.up * HEAD
    )
    local cx, cy, cw = project_raw(
        sets[picked.set], picked.convention, px, py, pz
    )

    if cx == nil or cx ~= cx or cy ~= cy or cw ~= cw then
        return nil, 'the projection is not a number'
    end

    local sx, sy

    if cw > 0.0001 then
        sx = (cx / cw * 0.5 + 0.5) * view.w + view.x
        sy = (1 - (cy / cw * 0.5 + 0.5)) * view.h + view.y

        local inside

        if edge_on then
            -- The arrow is drawn above its tip: keep the tip off the top.
            inside = sx >= view.x + 12 and sx <= view.x + view.w - 12
                and sy >= view.y + 60 and sy <= view.y + view.h - 12
        else
            inside = sx >= view.x - 50 and sx <= view.x + view.w + 50
                and sy >= view.y - 50 and sy <= view.y + view.h + 50
        end

        if inside then
            return { x = sx, y = sy, depth = cw }
        end
    end

    local reason = sx and 'the NPC is off the screen'
        or 'the NPC is behind the camera'

    if not edge_on then
        return nil, reason
    end

    -- The side of the NPC does not change with the sign of w.
    local dx = cx * view.w * 0.5
    local dy = -cy * view.h * 0.5
    local len = math.sqrt(dx * dx + dy * dy)

    if len < 1e-6 then
        return nil, reason, { dx = 0, dy = 1 }
    end

    return nil, reason, { dx = dx / len, dy = dy / len }
end

-- The screen point over a target: { x =, y =, depth = } or nil, with the
-- reason in M.GetInfo().reason. target is { x =, y =, h =, me = { x =, y =, h = } }.
-- view is { x =, y =, w =, h = }: where the 3D scene is on the screen (the
-- viewport of Direct3D), or the whole screen.
function M.Locate(target, view)
    if target == nil or target.me == nil then
        info.reason = 'no target'

        return nil
    end

    if sets.draw == nil and sets.present == nil and sets.begin == nil then
        info.reason = 'the matrices cannot be read'

        return nil
    end

    local picked = calibrate(target.me, view)

    if picked == nil then
        info.reason = 'no combination puts the player in front of the camera'

        return nil
    end

    local point, reason = place(picked, target, view, false)

    if point == nil then
        info.reason = reason

        return nil
    end

    info.reason = 'ok'
    info.last = point

    return point
end

function M.GetInfo()
    return info
end

-- Drawing ----------------------------------------------------------------------

local function screen_size(imgui)
    if imgui.GetIO ~= nil then
        local ok, io = pcall(imgui.GetIO)

        if ok and io ~= nil and io.DisplaySize ~= nil then
            local size = io.DisplaySize
            local w = size.x or size[1]
            local h = size.y or size[2]

            if type(w) == 'number' and type(h) == 'number'
                and w > 0 and h > 0 then

                return w, h
            end
        end
    end

    return nil
end

local function get_draw_list(imgui)
    for _, name in ipairs({ 'GetForegroundDrawList', 'GetBackgroundDrawList' }) do
        if imgui[name] ~= nil then
            local ok, list = pcall(imgui[name])

            if ok and list ~= nil and list ~= false then
                return list
            end
        end
    end

    return nil
end

-- Where Direct3D draws the 3D scene: { x =, y =, w =, h = }, or nil. The
-- wrapper of Ashita returns (result, D3DVIEWPORT8).
local function read_viewport()
    local dev = get_device()

    if dev == nil then
        return nil
    end

    local ok, _, vp = pcall(function()
        return dev:GetViewport()
    end)

    if not ok or vp == nil then
        return nil
    end

    local got, view = pcall(function()
        return {
            x = tonumber(vp.X) or 0,
            y = tonumber(vp.Y) or 0,
            w = tonumber(vp.Width),
            h = tonumber(vp.Height),
        }
    end)

    if not got or view.w == nil or view.h == nil
        or view.w <= 0 or view.h <= 0 then

        return nil
    end

    info.viewport = view

    return view
end

-- Custom icons ------------------------------------------------------------------
--
-- The player can put PNG files (transparent background) in assets/arrows/ to
-- replace the arrows over the NPC:
--   available.png  a quest that can be started, or the target of the compass
--   locked.png     the quests of the NPC wait for another quest
--   progress.png   a quest in progress
-- A file that is not there (or cannot be loaded) leaves the arrow that is
-- drawn with triangles. The files are looked for once, when the addon loads.

local ICON_FILES = {
    available = 'available.png',
    locked = 'locked.png',
    progress = 'progress.png',
    repeatable = 'repeatable.png',
    completed = 'completed.png',
    mission_completed = 'mission_completed.png',
    mission_locked = 'mission_locked.png',
    mission_available = 'mission_available.png',
    mission_progress = 'mission_progress.png',
    fame = 'fame.png',
}

local icons = {}

-- The texture of an icon: { id =, width =, height =, ptr = }, or nil.
local function load_icon(name)
    local cached = icons[name]

    if cached ~= nil then
        return cached ~= false and cached or nil
    end

    icons[name] = false

    local file = ICON_FILES[name]

    if file == nil then
        return nil
    end

    local ok, texture = pcall(function()
        local ffi = require('ffi')
        local d3d = require('d3d8')
        local path = tostring(addon and addon.path or '') .. '/assets/arrows/' .. file

        if not ashita.fs.exists(path) then
            return nil
        end

        local info = ffi.new('D3DXIMAGE_INFO')

        if ffi.C.D3DXGetImageInfoFromFileA(path, info) ~= ffi.C.S_OK then
            return nil
        end

        local pointer = ffi.new('IDirect3DTexture8*[1]')

        if ffi.C.D3DXCreateTextureFromFileA(
            d3d.get_device(), path, pointer
        ) ~= ffi.C.S_OK then

            return nil
        end

        local owned = d3d.gc_safe_release(
            ffi.cast('IDirect3DTexture8*', pointer[0])
        )

        return {
            ptr = owned,
            id = tonumber(ffi.cast('uint32_t', owned)),
            width = tonumber(info.Width),
            height = tonumber(info.Height),
        }
    end)

    if ok and texture ~= nil and texture.id ~= nil
        and (texture.width or 0) > 0 and (texture.height or 0) > 0 then

        icons[name] = texture

        return texture
    end

    return nil
end

-- The texture of an icon (available, locked, progress, repeatable), or nil;
-- for the compass window.
function M.GetIcon(name)
    return load_icon(name)
end

-- For the tests: forget the icons that were looked for.
function M.ResetIcons()
    icons = {}
end

-- Draws an icon with its bottom at the point (sx, sy), with a short bob.
-- Returns true when it was drawn.
function M.DrawIcon(imgui, list, texture, sx, sy, depth, color, time, scale)
    local size = math.max(9, math.min(24, 190 / math.max(depth, 1) + 8))
        * (scale or 1) * 3.38
    local height = size
    local width = size * texture.width / texture.height
    local bob = math.sin(time * 4.0) * size * 0.10
    -- Lowered by a share of its own height so it sits closer to the head.
    local bottom = sy + bob + size * 0.75

    list:AddImage(
        texture.id,
        { sx - width * 0.5, bottom - height },
        { sx + width * 0.5, bottom },
        { 0, 0 },
        { 1, 1 },
        imgui.GetColorU32({ 1, 1, 1, color[4] or 1 })
    )

    return true
end

-- A down arrow with a short bob. tip is the point it points at.
function M.DrawArrow(imgui, list, sx, sy, depth, color, time, scale)
    local size = math.max(9, math.min(24, 190 / math.max(depth, 1) + 8))
        * (scale or 1)
    local bob = math.sin(time * 4.0) * size * 0.35
    local tip_y = sy + bob
    local fill = imgui.GetColorU32(color)
    local edge = imgui.GetColorU32({ 0.05, 0.05, 0.05, 0.90 })

    local head_top = tip_y - size * 1.1
    local a = { sx - size * 0.9, head_top }
    local b = { sx + size * 0.9, head_top }
    local c = { sx, tip_y }
    local shaft_min = { sx - size * 0.35, head_top - size * 1.0 }
    local shaft_max = { sx + size * 0.35, head_top + 1 }

    list:AddRectFilled(shaft_min, shaft_max, edge, 0)
    list:AddTriangleFilled(
        { a[1] - 2, a[2] - 2 }, { b[1] + 2, b[2] - 2 }, { c[1], c[2] + 3 }, edge
    )
    list:AddRectFilled(
        { shaft_min[1] + 2, shaft_min[2] + 2 },
        { shaft_max[1] - 2, shaft_max[2] },
        fill,
        0
    )
    list:AddTriangleFilled(a, b, c, fill)
end

-- A circular arrow turning over the head of the NPC (the quest is in
-- progress). Built with filled triangles only: a ring of 16 small pieces
-- (270 degrees) and an arrow head at its leading end, turning clockwise.
function M.DrawSpinner(imgui, list, sx, sy, depth, color, time, scale)
    local size = math.max(9, math.min(24, 190 / math.max(depth, 1) + 8))
        * (scale or 1)
    local radius = size * 1.15
    local thick = math.max(3, size * 0.38)
    local cx = sx
    local cy = sy - radius - size * 0.4 + math.sin(time * 3.0) * size * 0.12
    local start = time * 3.2
    local sweep = math.pi * 1.5
    local steps = 16
    local fill = imgui.GetColorU32(color)
    local edge = imgui.GetColorU32({ 0.05, 0.05, 0.05, 0.90 })

    for pass = 1, 2 do
        local paint = pass == 1 and edge or fill
        local grow = pass == 1 and 2 or 0
        local outer = radius + thick * 0.5 + grow
        local inner = radius - thick * 0.5 - grow

        for index = 0, steps - 1 do
            local a0 = start + sweep * index / steps
            local a1 = start + sweep * (index + 1) / steps + 0.03
            local c0, s0 = math.cos(a0), math.sin(a0)
            local c1, s1 = math.cos(a1), math.sin(a1)
            local p1 = { cx + c0 * outer, cy + s0 * outer }
            local p2 = { cx + c1 * outer, cy + s1 * outer }
            local p3 = { cx + c1 * inner, cy + s1 * inner }
            local p4 = { cx + c0 * inner, cy + s0 * inner }

            list:AddTriangleFilled(p1, p2, p3, paint)
            list:AddTriangleFilled(p1, p3, p4, paint)
        end

        local ae = start + sweep
        local rx, ry = math.cos(ae), math.sin(ae)
        local tx, ty = -ry, rx
        local bx, by = cx + rx * radius, cy + ry * radius
        local half = thick * 1.2 + grow
        local length = thick * 1.7 + grow

        list:AddTriangleFilled(
            { bx + tx * length, by + ty * length },
            { bx + rx * half, by + ry * half },
            { bx - rx * half, by - ry * half },
            paint
        )
    end
end

-- An arrow at the edge of the screen pointing towards an NPC that is out of
-- view. dir is { dx =, dy = } (unit, y down). The arrow bobs a little along
-- its direction.
function M.DrawEdgeArrow(imgui, list, view, dir, color, time, scale)
    local size = 16 * (scale or 1)
    local margin = size * 2.2
    local cx = view.x + view.w * 0.5
    local cy = view.y + view.h * 0.5
    local tx = math.abs(dir.dx) > 1e-6
        and (view.w * 0.5 - margin) / math.abs(dir.dx) or math.huge
    local ty = math.abs(dir.dy) > 1e-6
        and (view.h * 0.5 - margin) / math.abs(dir.dy) or math.huge
    local t = math.min(tx, ty)
    local bob = math.sin(time * 4.0) * size * 0.25
    local px = cx + dir.dx * (t + bob)
    local py = cy + dir.dy * (t + bob)
    local nx, ny = -dir.dy, dir.dx
    local fill = imgui.GetColorU32(color)
    local edge = imgui.GetColorU32({ 0.05, 0.05, 0.05, 0.90 })

    local function triangle(grow, paint)
        local k = size + grow

        list:AddTriangleFilled(
            { px + dir.dx * k, py + dir.dy * k },
            { px - dir.dx * k * 0.6 + nx * k * 0.85,
              py - dir.dy * k * 0.6 + ny * k * 0.85 },
            { px - dir.dx * k * 0.6 - nx * k * 0.85,
              py - dir.dy * k * 0.6 - ny * k * 0.85 },
            paint
        )
    end

    triangle(3, edge)
    triangle(0, fill)
end

-- controller gives GetWorldMark(), GetWorldMarkPoint() (the target of the
-- compass) and GetWorldMarkColor(). Optional: GetWorldMarkPoints() (a list,
-- the target first), and GetWorldMarkEdge() (arrows at the edge of the
-- screen for the NPCs out of view).
function M.Draw(controller, can_draw)
    if controller == nil
        or controller.GetWorldMark == nil
        or not controller.GetWorldMark() then

        return
    end

    if can_draw ~= nil and not can_draw() then
        return
    end

    local ok, imgui = pcall(require, 'imgui')

    if not ok then
        return
    end

    -- The matrices of this frame, read at the present.
    M.Capture('present')

    local points

    if controller.GetWorldMarkPoints ~= nil then
        points = controller.GetWorldMarkPoints()
    elseif controller.GetWorldMarkPoint ~= nil then
        local single = controller.GetWorldMarkPoint()

        points = single and { single } or {}
    end

    info.drawn = 0
    info.edge_drawn = 0
    info.count = points and #points or 0

    if points == nil or #points == 0 then
        info.reason = 'the compass has no NPC with a position'

        return
    end

    local width, height = screen_size(imgui)

    info.display = width and { w = width, h = height } or nil

    local view = read_viewport()

    if view == nil and width ~= nil then
        view = { x = 0, y = 0, w = width, h = height }
    end

    if view == nil then
        info.reason = 'the size of the screen is unknown'

        return
    end

    if sets.draw == nil and sets.present == nil and sets.begin == nil then
        info.reason = 'the matrices cannot be read'

        return
    end

    local picked = calibrate(points[1].me, view)

    if picked == nil then
        info.reason = 'no combination puts the player in front of the camera'

        return
    end

    local list = get_draw_list(imgui)

    if list == nil then
        info.reason = 'no draw list'

        return
    end

    local edge_on = controller.GetWorldMarkEdge ~= nil
        and controller.GetWorldMarkEdge() == true
    local base = controller.GetWorldMarkColor
        and controller.GetWorldMarkColor()
        or { 1.00, 0.85, 0.40, 1.00 }
    local grey = controller.GetWorldMarkLockedColor
        and controller.GetWorldMarkLockedColor()
        or { 0.62, 0.62, 0.62, 1.00 }
    local green = controller.GetWorldMarkActiveColor
        and controller.GetWorldMarkActiveColor()
        or { 0.45, 0.90, 0.45, 1.00 }
    local time = now()

    info.reason = 'ok'

    for index, target in ipairs(points) do
        local point, reason, dir = place(picked, target, view, edge_on)

        -- The first is the target of the compass: the others are a little
        -- smaller and fainter.
        local main = target.primary == true
            or (target.primary == nil and index == 1)
        local scale = main and 1.0 or 0.8
        -- Grey when the quests of the NPC cannot be started yet, green when
        -- one is in progress.
        local paint = base

        if target.locked then
            paint = grey
        elseif target.state == 'active' then
            paint = green
        elseif target.state == 'repeatable' then
            paint = { 0.62, 0.85, 1.00, 1.00 }
        end

        local color = main and paint
            or { paint[1], paint[2], paint[3], (paint[4] or 1) * 0.85 }

        if point ~= nil then
            if main then
                info.last = point
            end

            info.drawn = info.drawn + 1
            -- A quest in progress: a circular arrow turning; the others: a
            -- down arrow.
            local kind = target.state == 'fame' and 'fame'
                or ((target.state == 'mission_available'
                    or target.state == 'mission_progress'
                    or target.state == 'mission_locked') and target.state)
                or target.locked and 'locked'
                or (target.state == 'active' and 'progress'
                    or (target.state == 'repeatable' and 'repeatable'
                        or 'available'))
            local icon = load_icon(kind)
            local drawn = false

            -- A custom icon, when there is one; if drawing it fails, the
            -- arrow of triangles.
            if icon ~= nil then
                drawn = pcall(M.DrawIcon, imgui, list, icon, point.x, point.y,
                    point.depth, color, time, scale)
            end

            if not drawn then
                local draw = kind == 'progress' and M.DrawSpinner
                    or M.DrawArrow

                pcall(draw, imgui, list, point.x, point.y, point.depth,
                    color, time, scale)
            end
        else
            if main then
                info.reason = reason
            end

            if dir ~= nil then
                info.edge_drawn = info.edge_drawn + 1
                pcall(M.DrawEdgeArrow, imgui, list, view, dir, color, time, scale)
            end
        end
    end
end

-- Lines for /journal mark debug.
function M.DebugLines(target)
    local lines = {}

    lines[#lines + 1] = string.format(
        'reads=%d errors=%d reason=%s',
        info.reads, info.errors, tostring(info.reason)
    )

    if info.last_error ~= nil then
        lines[#lines + 1] = 'last error: ' .. info.last_error
    end

    local heard = {}

    for event, count in pairs(info.hits) do
        heard[#heard + 1] = event .. '=' .. count
    end

    table.sort(heard)

    lines[#lines + 1] = 'events: ' .. (#info.events > 0
        and table.concat(info.events, ' ') or 'none registered')
        .. ' | heard: ' .. (#heard > 0 and table.concat(heard, ' ') or 'nothing')

    for _, name in ipairs({ 'draw', 'begin', 'present' }) do
        local set = sets[name]

        if set == nil then
            lines[#lines + 1] = string.format(
                '%s: no matrices (flat projections seen: %d)',
                name, info.flat[name] or 0
            )
        else
            lines[#lines + 1] = string.format(
                '%s %s | view row1=%.3f %.3f %.3f %.3f | proj m11=%.3f m22=%.3f m33=%.3f m34=%.3f m44=%.3f',
                name, set.flat and 'FLAT' or 'perspective',
                set.view[1], set.view[2], set.view[3], set.view[4],
                set.proj[1], set.proj[6], set.proj[11], set.proj[12], set.proj[16]
            )
        end
    end

    lines[#lines + 1] = string.format(
        'screen: display=%s viewport=%s',
        info.display and string.format('%dx%d', info.display.w, info.display.h) or '?',
        info.viewport and string.format(
            '%d,%d %dx%d', info.viewport.x, info.viewport.y,
            info.viewport.w, info.viewport.h
        ) or '?'
    )

    if choice ~= nil then
        lines[#lines + 1] = string.format(
            'chosen: set=%s order=%s axes=%s up=%d score=%.3f player at (%.0f,%.0f) (%d combinations fit)',
            choice.set, choice.convention, choice.map.name, choice.up or 0,
            choice.score or 0, choice.x or 0, choice.y or 0, #passing
        )
    else
        lines[#lines + 1] = 'chosen: none'
    end

    for index = 2, math.min(#passing, 4) do
        local other = passing[index]

        lines[#lines + 1] = string.format(
            'also fits: %s %s %s up=%d score=%.3f at (%.0f,%.0f)',
            other.set, other.convention, other.map.name, other.up or 0,
            other.score or 0, other.x or 0, other.y or 0
        )
    end

    if target ~= nil then
        lines[#lines + 1] = string.format(
            'target ground=(%.2f, %.2f) height=%.2f player=(%.2f, %.2f, %.2f)',
            target.x, target.y, target.h,
            target.me and target.me.x or 0,
            target.me and target.me.y or 0,
            target.me and target.me.h or 0
        )
    else
        lines[#lines + 1] = 'target: none (point the compass at an NPC)'
    end

    lines[#lines + 1] = string.format(
        'arrows: %d NPC(s) with a position, %d over the NPC, %d at the edge',
        info.count or 0, info.drawn or 0, info.edge_drawn or 0
    )

    if info.last ~= nil then
        lines[#lines + 1] = string.format(
            'screen point (%.0f, %.0f) depth %.1f',
            info.last.x, info.last.y, info.last.depth
        )
    end

    return lines
end

return M
