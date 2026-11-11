-- The compass: an arrow that points at the NPC of the current step of a
-- quest or mission.
--
-- The quest data has no world coordinates (only map squares such as
-- "(I-9)" in the text), so the arrow can only follow an NPC that the game
-- has loaded near the player. This file finds the NPC name in the step
-- text, looks for that NPC among the entities, and works out the distance
-- and the direction. It draws nothing: ui.lua does.
--
-- It is a file of its own because logic.lua has no room left for more
-- local variables. The target (a quest or mission) is saved with the other
-- settings; the state of the search is not.
--
-- The calls that read entities are the part that could not be tried
-- outside the game: see M.AshitaApi and M.config.

local richtext = require('richtext')
local zonematch = require('zonematch')

local M = {}

local SCAN_INTERVAL = 0.25
local MAX_ENTITY = 0x8FF
local ARRIVED = 5.0

-- The direction conventions of the game are not confirmed. The relative
-- angle is 0 when the NPC is straight ahead and grows to the right.
--   z_sign     -1 if the z axis of the game points the other way
--   yaw_sign   -1 if the heading of the player grows the other way
--   yaw_offset added to the heading, in radians
--   second_axis which of the coordinates of Ashita is the second one on the
--               ground, with X: 'y' or 'z'. The other one is the height. In
--               the first test in the game the Z of the player stayed the
--               same while walking on flat ground, and the Z of an NPC
--               matched the height that LandSandBoat gives for it, so the
--               height is Z and the ground is X and Y.
M.config = {
    z_sign = 1,
    yaw_sign = 1,
    yaw_offset = 0,
    second_axis = 'y',
    -- The arrow needs the heading of the player to be right, and it is not
    -- confirmed yet: it is off, and the window shows the distance only.
    arrow = false,
}

M.ARRIVED = ARRIVED

local target = nil
local window_open = false
local window_x = nil
local window_y = nil
-- Size the player gave the window (nil = it fits its content) and the
-- opacity of its background.
local window_w = nil
local window_h = nil
local OPACITY_MIN = 0.00
local OPACITY_MAX = 1.00
local OPACITY_STEP = 0.05
local opacity = 1.0
-- Size of the text of the window (a multiple of the size of the Journal)
-- and whether the NPC search box is shown.
local TEXT_SCALE_MIN = 0.60
local TEXT_SCALE_MAX = 1.60
local text_scale = 1.0
local search_visible = true
local state = { status = 'none' }
local cache = { text = nil, styles = nil, name = nil, grid = nil }
-- The pins of the Tracker shown in the compass (see M.UpdatePins): the ones
-- the player took off with the "x" (kept with the settings), the last rows
-- and what they were made from.
local pin_hidden = {}
local pin_rows = {}
local pin_signature = nil
local pin_scan_time = -1000
local pin_parse = {}
local pin_parse_styles = nil
local last_scan = -1000
local last_debug = nil

-- Text ---------------------------------------------------------------------

-- The first NPC named in the text (as written there), and the first map
-- square, such as "I-9". Either can be nil.
function M.ParseStep(text, styles)
    text = tostring(text or '')

    local name = nil

    for _, mark in ipairs(richtext.marks(text, styles or {})) do
        if mark.kind == 'npc' then
            name = text:sub(mark.s, mark.e)
            break
        end
    end

    local letter, number = text:match('%(([A-N])%-(%d%d?)%)')
    local grid = letter and (letter .. '-' .. number) or nil

    return name, grid
end

local function same_name(a, b)
    return zonematch.normalize(a) == zonematch.normalize(b)
end

-- Geometry -------------------------------------------------------------------

local function wrap(angle)
    local two_pi = 2 * math.pi

    angle = angle % two_pi

    if angle > math.pi then
        angle = angle - two_pi
    end

    return angle
end

-- me and other are { x =, z = }; heading is the heading of the player in
-- radians. Returns the distance on the ground and the relative angle: 0
-- straight ahead, positive to the right, between -pi and pi.
function M.Direction(me, other, heading)
    local dx = other.x - me.x
    local dz = (other.z - me.z) * M.config.z_sign

    local distance = math.sqrt(dx * dx + dz * dz)
    local world = math.atan2(dz, dx)
    local facing = (heading or 0) * M.config.yaw_sign + M.config.yaw_offset

    return distance, wrap(facing - world)
end

-- Fixed positions ---------------------------------------------------------------

-- data/npc_positions.lua: name -> { { zone, x, y, height }, ... }. It is read
-- the first time it is needed and indexed by the normalized name.
local positions = nil
local position_names = {}
local search_index = nil

local function index_positions(list)
    positions = {}
    position_names = {}
    search_index = nil

    for name, entries in pairs(list or {}) do
        local key = zonematch.normalize(name)

        positions[key] = entries
        position_names[key] = name
    end
end

local function load_positions()
    if positions ~= nil then
        return positions
    end

    local ok, list = pcall(require, 'data.npc_positions')

    index_positions(ok and type(list) == 'table' and list or {})

    return positions
end

-- For the tests: use this table instead of the file.
function M.SetPositions(list)
    index_positions(list)
end

-- The fixed position of the NPC in the zone the player is in, or, when it is
-- not in this zone (or the zone is not known), the zones where it is.
-- Returns { zone =, x =, y =, distance = } or { zones = { ids } } or nil.
function M.Lookup(name, zone, me)
    local entries = load_positions()[zonematch.normalize(name)]

    if entries == nil or #entries == 0 then
        return nil
    end

    local best = nil

    if zone ~= nil then
        for _, entry in ipairs(entries) do
            if entry[1] == zone then
                local distance = M.Direction(
                    me, { x = entry[2], z = entry[3] }, 0
                )

                if best == nil or distance < best.distance then
                    best = {
                        zone = zone,
                        x = entry[2],
                        y = entry[3],
                        h = entry[4],
                        distance = distance,
                    }
                end
            end
        end
    end

    if best ~= nil then
        return best
    end

    local zones = {}
    local seen = {}

    for _, entry in ipairs(entries) do
        if not seen[entry[1]] then
            seen[entry[1]] = true
            zones[#zones + 1] = entry[1]
        end
    end

    return { zones = zones }
end

-- The zone to use for an NPC clicked somewhere else (the Tracker, the steps
-- of the Journal): the zone the player is in when the NPC is there; then the
-- zone that the text of the step names (hint, with zone_name(id) giving the
-- name of a zone; the longest name wins); otherwise the first zone of the
-- table. An NPC that is not in the table gets the zone the player is in (it
-- can still be found if it is close). nil when there is no zone to use.
function M.PickZone(name, current_zone, hint, zone_name)
    local entries = load_positions()[zonematch.normalize(name)]
    local first = nil
    local named = nil
    local named_length = 0
    local text = (hint ~= nil and zone_name ~= nil)
        and zonematch.normalize(hint) or nil

    for _, entry in ipairs(entries or {}) do
        if entry[1] == current_zone then
            return current_zone
        end

        first = first or entry[1]

        if text ~= nil then
            local ok, label = pcall(zone_name, entry[1])
            label = ok and type(label) == 'string'
                and zonematch.normalize(label) or ''

            if #label > named_length
                and string.find(text, label, 1, true) then

                named = entry[1]
                named_length = #label
            end
        end
    end

    return named or first or current_zone
end

-- Route between zones -----------------------------------------------------------

-- data/zone_links.lua: zone id -> ids of the zones you reach by walking out
-- of it (the zonelines of LandSandBoat). Boats and airships are not in it.
local links = nil

local function load_links()
    if links ~= nil then
        return links
    end

    local ok, list = pcall(require, 'data.zone_links')

    links = ok and type(list) == 'table' and list or {}

    return links
end

-- For the tests: use this table instead of the file.
function M.SetLinks(list)
    links = type(list) == 'table' and list or {}
end

-- The shortest way on foot from zone `from` to the closest of the zones in
-- `targets` (a list of ids). Returns { next =, hops =, path = } with path the
-- zone ids after `from`, or nil when there is no way (or `from` is already
-- one of the targets).
function M.Route(from, targets)
    if type(from) ~= 'number' or type(targets) ~= 'table' then
        return nil
    end

    local wanted = {}

    for _, id in ipairs(targets) do
        wanted[id] = true
    end

    if wanted[from] then
        return nil
    end

    local map = load_links()
    local parent = { [from] = false }
    local queue = { from }
    local head = 1

    while head <= #queue do
        local here = queue[head]

        head = head + 1

        for _, there in ipairs(map[here] or {}) do
            if parent[there] == nil then
                parent[there] = here

                if wanted[there] then
                    local path = {}
                    local step = there

                    while step ~= from do
                        table.insert(path, 1, step)
                        step = parent[step]
                    end

                    return { next = path[1], hops = #path, path = path }
                end

                queue[#queue + 1] = there
            end
        end
    end

    return nil
end

-- The NPCs chosen with the search -------------------------------------------

local NPC_MAX = 5
M.NPC_MAX = NPC_MAX

M.NPC_MAX = NPC_MAX

-- { { name =, zone = } }: up to NPC_MAX NPCs the player picked from the
-- search, one row per name and zone.
local npcs = {}
local npc_rows = {}
local npc_scan_time = -1000

local function build_search_index()
    if search_index ~= nil then
        return search_index
    end

    load_positions()

    search_index = {}

    for key, entries in pairs(positions) do
        local seen = {}

        for _, entry in ipairs(entries) do
            if not seen[entry[1]] then
                seen[entry[1]] = true

                search_index[#search_index + 1] = {
                    name = position_names[key],
                    key = key,
                    zone = entry[1],
                }
            end
        end
    end

    table.sort(search_index, function(a, b)
        if a.key ~= b.key then
            return a.key < b.key
        end

        return a.zone < b.zone
    end)

    return search_index
end

-- The NPCs whose name has the text in it, the ones that start with it first.
-- Returns { { name =, zone = } }, at most limit (8 by default). Fewer than
-- two letters finds nothing.
function M.Search(query, limit)
    local text = zonematch.normalize(query):match('^%s*(.-)%s*$') or ''

    if #text < 2 then
        return {}
    end

    limit = limit or 8

    local starts = {}
    local contains = {}

    for _, item in ipairs(build_search_index()) do
        local from = item.key:find(text, 1, true)

        if from == 1 then
            starts[#starts + 1] = item
        elseif from ~= nil then
            contains[#contains + 1] = item
        end
    end

    local result = {}

    for _, list in ipairs({ starts, contains }) do
        for _, item in ipairs(list) do
            if #result >= limit then
                return result
            end

            result[#result + 1] = { name = item.name, zone = item.zone }
        end
    end

    return result
end

local function find_npc(name, zone)
    local key = zonematch.normalize(name)

    for index, npc in ipairs(npcs) do
        if zonematch.normalize(npc.name) == key and npc.zone == zone then
            return index
        end
    end

    return nil
end

-- Returns true when it was added; false and 'full' when there is no room,
-- false and 'exists' when it is already in the list.
function M.AddNpc(name, zone, auto, quests)
    if type(name) ~= 'string' or name == '' or type(zone) ~= 'number' then
        return false
    end

    local found = find_npc(name, zone)

    if found ~= nil then
        -- Chosen by hand: it is no longer an automatic one.
        if not auto then
            npcs[found].auto = nil
        end

        return false, 'exists'
    end

    if #npcs >= NPC_MAX then
        return false, 'full'
    end

    npcs[#npcs + 1] = {
        name = name,
        zone = zone,
        auto = auto and true or nil,
        quests = auto and quests or nil,
    }
    npc_scan_time = -1000

    return true
end

function M.RemoveNpc(index)
    if npcs[index] == nil then
        return false
    end

    table.remove(npcs, index)
    npc_scan_time = -1000

    return true
end

-- Removes an NPC that was added with auto = true (see logic.lua, the
-- proximity alert). One chosen by hand is not touched.
function M.RemoveAutoNpc(name, zone)
    local index = find_npc(name, zone)

    if index ~= nil and npcs[index].auto then
        table.remove(npcs, index)
        npc_scan_time = -1000

        return true
    end

    return false
end

-- The quests under the name of an automatic NPC: { { name =, id = } }.
function M.SetAutoQuests(name, zone, quests)
    local index = find_npc(name, zone)

    if index ~= nil and npcs[index].auto then
        npcs[index].quests = quests
    end
end

function M.IsAutoNpc(index)
    return npcs[index] ~= nil and npcs[index].auto == true
end

function M.ClearNpcs()
    npcs = {}
    npc_rows = {}
end

-- Copies.
function M.GetNpcs()
    local result = {}

    for _, npc in ipairs(npcs) do
        result[#result + 1] = { name = npc.name, zone = npc.zone }
    end

    return result
end

-- Entities --------------------------------------------------------------------

-- api = {
--     me      = function() -> { x =, z =, heading = } or nil
--     count   = number of entity slots to look at (0 .. count),
--     name    = function(index) -> string or nil
--     pos     = function(index) -> x, z   (nil when not loaded)
-- }
-- Returns the closest entity with that name, or nil.
function M.Scan(api, wanted, me)
    local best = nil

    for index = 0, api.count do
        local name = api.name(index)

        if name ~= nil and name ~= '' and same_name(name, wanted) then
            local x, z = api.pos(index)

            if x ~= nil and z ~= nil then
                local distance = M.Direction(me, { x = x, z = z }, 0)

                if best == nil or distance < best.distance then
                    best = {
                        index = index,
                        name = name,
                        x = x,
                        z = z,
                        distance = distance,
                    }
                end
            end
        end
    end

    return best
end

-- One pass over the entities for several names at once. wanted is a set of
-- normalized names. Returns { [normalized name] = closest entity }.
function M.ScanMany(api, wanted, me)
    local best = {}

    for index = 0, api.count do
        local name = api.name(index)

        if name ~= nil and name ~= '' then
            local key = zonematch.normalize(name)

            if wanted[key] then
                local x, z = api.pos(index)

                if x ~= nil and z ~= nil then
                    local distance = M.Direction(me, { x = x, z = z }, 0)
                    local current = best[key]

                    if current == nil or distance < current.distance then
                        best[key] = {
                            index = index,
                            name = name,
                            x = x,
                            z = z,
                            distance = distance,
                        }
                    end
                end
            end
        end
    end

    return best
end

-- Reads the entities through Ashita. Every call is protected: a name that
-- does not exist in this version of Ashita makes the compass report
-- "unavailable", not an error.
function M.AshitaApi()
    local ok, api = pcall(function()
        local manager = AshitaCore:GetMemoryManager()
        local entity = manager:GetEntity()
        local party = manager:GetParty()

        -- The second coordinate on the ground (see M.config).
        local function second(index)
            if M.config.second_axis == 'z' then
                return entity:GetLocalPositionZ(index)
            end

            return entity:GetLocalPositionY(index)
        end

        return {
            count = MAX_ENTITY,
            me_index = function()
                return party:GetMemberTargetIndex(0)
            end,
            zone = function()
                return party:GetMemberZone(0)
            end,
            raw = function(index)
                return entity:GetLocalPositionX(index),
                    entity:GetLocalPositionY(index),
                    entity:GetLocalPositionZ(index)
            end,
            me = function()
                -- The entity index of the player changes when the player
                -- changes zone, so it is asked for every time.
                local mine = party:GetMemberTargetIndex(0)

                if mine == nil or mine == 0 then
                    return nil
                end

                local x = entity:GetLocalPositionX(mine)
                local z = second(mine)
                local heading = entity:GetLocalPositionYaw(mine)

                if x == nil or z == nil then
                    return nil
                end

                return { x = x, z = z, heading = heading or 0 }
            end,
            name = function(index)
                return entity:GetName(index)
            end,
            pos = function(index)
                return entity:GetLocalPositionX(index), second(index)
            end,
        }
    end)

    if ok then
        return api
    end

    return nil
end

-- State ------------------------------------------------------------------------

-- status:
--   none        no target
--   nostep      the target has no step text
--   nonpc       the step names no NPC
--   unavailable the entities cannot be read
--   far         the NPC is not loaded near the player and its position is
--               not known
--   known       not loaded, but its fixed position is known and it is in
--               this zone: distance, arrived (no angle)
--   otherzone   its fixed position is in another zone: zones (ids), and
--               next_zone / hops: the next zone on foot (M.Route), nil when
--               there is no way on foot
--   found       the NPC is loaded near the player: distance, arrived, and
--               angle when M.config.arrow is on
function M.GetState()
    return state
end

-- Looks at the step text and the entities, at most four times a second.
-- step_text is the text of the current step of the target (nil if none).
-- api is M.AshitaApi() in the game; tests pass their own.
function M.Update(now, step_text, styles, api)
    if target == nil then
        state = { status = 'none' }
        return state
    end

    if step_text == nil or step_text == '' then
        state = { status = 'nostep', target = target }
        return state
    end

    if cache.text ~= step_text or cache.styles ~= styles then
        cache.text = step_text
        cache.styles = styles
        cache.name, cache.grid = M.ParseStep(step_text, styles)
        last_scan = -1000
    end

    if cache.name == nil then
        state = { status = 'nonpc', target = target, grid = cache.grid }
        return state
    end

    if api == nil then
        state = {
            status = 'unavailable',
            target = target,
            npc = cache.name,
            grid = cache.grid,
        }
        return state
    end

    if now - last_scan < SCAN_INTERVAL and state.npc == cache.name then
        return state
    end

    last_scan = now

    local ok, me = pcall(api.me)

    if not ok or me == nil then
        state = {
            status = 'unavailable',
            target = target,
            npc = cache.name,
            grid = cache.grid,
        }
        return state
    end

    local scanned, found = pcall(M.Scan, api, cache.name, me)

    if not scanned then
        state = {
            status = 'unavailable',
            target = target,
            npc = cache.name,
            grid = cache.grid,
        }
        return state
    end

    if found == nil then
        -- Not loaded near the player: the fixed position of the NPC.
        local zone = nil

        if api.zone ~= nil then
            local zone_ok, value = pcall(api.zone)

            if zone_ok and type(value) == 'number' and value > 0 then
                zone = value
            end
        end

        local known = M.Lookup(cache.name, zone, me)

        if known ~= nil and known.zone ~= nil then
            state = {
                status = 'known',
                target = target,
                npc = cache.name,
                grid = cache.grid,
                zone = known.zone,
                distance = known.distance,
                arrived = known.distance <= ARRIVED,
                pos = { x = known.x, y = known.y, h = known.h },
            }
        elseif known ~= nil then
            local route = M.Route(zone, known.zones)

            state = {
                status = 'otherzone',
                target = target,
                npc = cache.name,
                grid = cache.grid,
                zones = known.zones,
                next_zone = route and route.next or nil,
                hops = route and route.hops or nil,
            }
        else
            state = {
                status = 'far',
                target = target,
                npc = cache.name,
                grid = cache.grid,
            }
        end

        return state
    end

    local distance, angle = M.Direction(me, found, me.heading)

    state = {
        status = 'found',
        target = target,
        npc = cache.name,
        grid = cache.grid,
        distance = distance,
        angle = M.config.arrow and angle or nil,
        arrived = distance <= ARRIVED,
        index = found.index,
    }

    return state
end

-- The position in the world of the NPC the compass points at, for the arrow
-- over it (worldmark.lua): { x =, y = (ground), h = (height), distance =,
-- me = { x =, y =, h = } }, or nil when the compass has no NPC with a
-- position. The heights are the third coordinate of the game; the other two
-- are the ground (see M.config.second_axis).
-- The position of an entity on the ground: { x, y, h } (h the height), or nil.
local function ground_of(api, index)
    local ok, rx, ry, rz = pcall(api.raw, index)

    if not ok or rx == nil or ry == nil or rz == nil then
        return nil
    end

    if M.config.second_axis == 'z' then
        return { x = rx, y = rz, h = ry }
    end

    return { x = rx, y = ry, h = rz }
end

function M.GetMarkPoint(api)
    if api == nil or api.raw == nil or api.me_index == nil
        or state == nil then

        return nil
    end

    local function ground(index)
        return ground_of(api, index)
    end

    local okm, mine = pcall(api.me_index)

    if not okm or mine == nil or mine == 0 then
        return nil
    end

    local me = ground(mine)

    if me == nil then
        return nil
    end

    local point = nil

    if state.status == 'found' and state.index ~= nil then
        point = ground(state.index)
    elseif state.status == 'known' and state.pos ~= nil
        and state.pos.x ~= nil and state.pos.y ~= nil then

        point = {
            x = state.pos.x,
            y = state.pos.y,
            h = state.pos.h or me.h,
        }
    end

    if point == nil then
        return nil
    end

    point.me = me
    point.distance = state.distance
    point.name = state.npc

    return point
end

-- The points of the rest of the NPCs of the compass (the list chosen with
-- the search and the pins of the Tracker), for the arrows in the game world.
-- lists are the rows (M.UpdateNpcs, M.UpdatePins); only the ones in this
-- zone with a position (found or known). skip is a name already drawn (the
-- target). Each point is { x, y, h, me, distance, name }.
function M.GetMarkPoints(api, lists, skip)
    local out = {}

    if api == nil or api.raw == nil or api.me_index == nil then
        return out
    end

    local okm, mine = pcall(api.me_index)

    if not okm or mine == nil or mine == 0 then
        return out
    end

    local me = ground_of(api, mine)

    if me == nil then
        return out
    end

    local seen = {}

    if type(skip) == 'table' then
        for _, name in ipairs(skip) do
            seen[zonematch.normalize(name)] = true
        end
    elseif skip ~= nil then
        seen[zonematch.normalize(skip)] = true
    end

    for _, rows in ipairs(lists or {}) do
        for _, row in ipairs(rows) do
            local name = row.name or row.npc

            if type(name) == 'string' then
                local key = zonematch.normalize(name)
                local point = nil

                if not seen[key] then
                    if row.status == 'found' and row.index ~= nil
                        and api.name ~= nil then

                        -- The entity may have gone since the last look.
                        local okn, now_name = pcall(api.name, row.index)

                        if okn and type(now_name) == 'string'
                            and zonematch.normalize(now_name) == key then

                            point = ground_of(api, row.index)
                        end
                    elseif row.status == 'known' and row.pos ~= nil
                        and row.pos.x ~= nil and row.pos.y ~= nil then

                        point = {
                            x = row.pos.x,
                            y = row.pos.y,
                            h = row.pos.h or me.h,
                        }
                    end
                end

                if point ~= nil then
                    seen[key] = true
                    point.me = me
                    point.distance = row.distance
                    point.name = name
                    point.kind = row.kind
                    point.id = row.id
                    out[#out + 1] = point
                end
            end
        end
    end

    return out
end

-- For /journal compass debug: the raw numbers, to confirm in the game that
-- the calls and the direction conventions are right. Returns a list of
-- lines. Walk towards the NPC and look at the angle: it should go to 0.
function M.DebugLines(api)
    local lines = {}

    lines[#lines + 1] = string.format(
        'config z_sign=%s yaw_sign=%s yaw_offset=%s second_axis=%s arrow=%s',
        tostring(M.config.z_sign),
        tostring(M.config.yaw_sign),
        tostring(M.config.yaw_offset),
        tostring(M.config.second_axis),
        tostring(M.config.arrow)
    )

    if api == nil then
        lines[#lines + 1] = 'Entity API: unavailable'

        return lines
    end

    local ok, me = pcall(api.me)

    if not ok or me == nil then
        lines[#lines + 1] = 'Player position: unavailable'

        return lines
    end

    lines[#lines + 1] = string.format(
        'Player ground=(%.2f, %.2f) heading=%.3f rad',
        me.x, me.z, me.heading or 0
    )

    if api.raw ~= nil then
        local raw_ok, rx, ry, rz = pcall(api.raw, api.me_index and api.me_index() or nil)

        if raw_ok and rx ~= nil then
            lines[#lines + 1] = string.format(
                'Player raw X=%.2f Y=%.2f Z=%.2f', rx, ry or 0, rz or 0
            )
        end
    end

    -- Between two calls, the way the player really moved against the
    -- heading the game reports: walk straight for a few yalms, call the
    -- command at the start and at the end.
    local previous = last_debug

    last_debug = { x = me.x, z = me.z }

    if previous ~= nil then
        local dx = me.x - previous.x
        local dz = me.z - previous.z
        local moved = math.sqrt(dx * dx + dz * dz)

        if moved >= 1.0 then
            local motion = math.atan2(dz, dx)

            lines[#lines + 1] = string.format(
                'Moved dx=%.2f dz=%.2f (%.1f yalms) motion=%.3f rad; heading minus motion=%.3f rad',
                dx, dz, moved, motion, wrap((me.heading or 0) - motion)
            )
        end
    end

    if api.zone ~= nil then
        local zone_ok, zone = pcall(api.zone)

        lines[#lines + 1] = 'Zone id: '
            .. (zone_ok and tostring(zone) or 'unavailable')
    end

    local wanted = state.npc

    if wanted == nil then
        lines[#lines + 1] = 'No NPC in the current step of the target.'

        return lines
    end

    -- The fixed position of the same NPC, to compare with the live one.
    local zone_ok, zone = pcall(api.zone or function() return nil end)
    local known = M.Lookup(wanted, zone_ok and zone or nil, me)

    if known ~= nil and known.zone ~= nil then
        lines[#lines + 1] = string.format(
            'Table: %s ground=(%.2f, %.2f) distance=%.1f',
            wanted, known.x, known.y, known.distance
        )
    elseif known ~= nil then
        lines[#lines + 1] = 'Table: ' .. wanted .. ' is in zone(s) '
            .. table.concat(known.zones, ', ')
    else
        lines[#lines + 1] = 'Table: no fixed position for ' .. wanted
    end

    local scanned, found = pcall(M.Scan, api, wanted, me)

    if not scanned then
        lines[#lines + 1] = 'Entity scan failed: ' .. tostring(found)
    elseif found == nil then
        lines[#lines + 1] = wanted .. ': not loaded near the player.'
    else
        local distance, angle = M.Direction(me, found, me.heading)

        lines[#lines + 1] = string.format(
            '%s (entity %d) ground=(%.2f, %.2f) distance=%.1f angle=%.1f deg',
            found.name, found.index, found.x, found.z,
            distance, math.deg(angle)
        )

        if api.raw ~= nil then
            local raw_ok, rx, ry, rz = pcall(api.raw, found.index)

            if raw_ok and rx ~= nil then
                lines[#lines + 1] = string.format(
                    '%s raw X=%.2f Y=%.2f Z=%.2f',
                    found.name, rx, ry or 0, rz or 0
                )
            end
        end
    end

    return lines
end

-- The rows of the NPCs chosen with the search: { name, zone, status,
-- distance, arrived }. status is
--   found       loaded near the player: live distance
--   known       not loaded, fixed position in this zone: distance
--   otherzone   the NPC is in another zone (next_zone, hops: see GetState)
--   far         no position known for it in its zone
--   unavailable the entities or the zone cannot be read
-- Looked at most four times a second; one pass over the entities serves all
-- the NPCs.
function M.UpdateNpcs(now, api)
    if #npcs == 0 then
        npc_rows = {}

        return npc_rows
    end

    if now - npc_scan_time < SCAN_INTERVAL and #npc_rows == #npcs then
        return npc_rows
    end

    npc_scan_time = now

    local rows = {}

    local function fill(status)
        rows = {}

        for _, npc in ipairs(npcs) do
            rows[#rows + 1] = {
                name = npc.name,
                zone = npc.zone,
                quests = npc.quests,
                status = status,
            }
        end

        npc_rows = rows

        return rows
    end

    if api == nil then
        return fill('unavailable')
    end

    local ok, me = pcall(api.me)
    local zone = nil

    if api.zone ~= nil then
        local zone_ok, value = pcall(api.zone)

        if zone_ok and type(value) == 'number' and value > 0 then
            zone = value
        end
    end

    if not ok or me == nil or zone == nil then
        return fill('unavailable')
    end

    local wanted = {}

    for _, npc in ipairs(npcs) do
        if npc.zone == zone then
            wanted[zonematch.normalize(npc.name)] = true
        end
    end

    local scanned, live = pcall(M.ScanMany, api, wanted, me)

    if not scanned then
        return fill('unavailable')
    end

    for _, npc in ipairs(npcs) do
        local row = { name = npc.name, zone = npc.zone, quests = npc.quests }

        if npc.zone ~= zone then
            local route = M.Route(zone, { npc.zone })

            row.status = 'otherzone'
            row.next_zone = route and route.next or nil
            row.hops = route and route.hops or nil
        else
            local found = live[zonematch.normalize(npc.name)]

            if found ~= nil then
                row.status = 'found'
                row.distance = found.distance
                row.index = found.index
            else
                local known = M.Lookup(npc.name, zone, me)

                if known ~= nil and known.zone ~= nil then
                    row.status = 'known'
                    row.distance = known.distance
                    row.pos = { x = known.x, y = known.y, h = known.h }
                else
                    row.status = 'far'
                end
            end

            if row.distance ~= nil then
                row.arrived = row.distance <= ARRIVED
            end
        end

        rows[#rows + 1] = row
    end

    npc_rows = rows

    return rows
end

function M.GetNpcRows()
    return npc_rows
end

-- The pins of the Tracker --------------------------------------------------------

-- The same text that the Tracker uses to tell a pin apart.
function M.PinKey(kind, id, name)
    return tostring(kind or '') .. ':' .. tostring(id or '') .. ':'
        .. tostring(name or '')
end

-- Takes the pin off the compass (not off the Tracker). It stays off while
-- the item stays pinned. Returns true when it changed.
function M.HidePin(key)
    if type(key) ~= 'string' or key == '' or pin_hidden[key] then
        return false
    end

    pin_hidden[key] = true
    pin_scan_time = -1000

    return true
end

-- The item was unpinned: forget that it was taken off the compass, so pinning
-- it again shows it again. Returns true when it was hidden.
function M.ForgetPin(key)
    if pin_hidden[key] then
        pin_hidden[key] = nil
        pin_scan_time = -1000

        return true
    end

    return false
end

-- valid is a set of the keys of the items that are pinned now: the ones
-- that are not pinned any more are forgotten, so pinning one again shows it
-- again. Returns true when something was forgotten.
function M.PrunePinHidden(valid)
    local changed = false

    for key in pairs(pin_hidden) do
        if not valid[key] then
            pin_hidden[key] = nil
            changed = true
        end
    end

    return changed
end

-- items: { { key =, kind =, name =, text = } }, in the order of the Tracker;
-- text is the current step of the pin. One row for each pin that is not
-- hidden and whose step names an NPC:
--   { key, kind, title, npc, status, distance, arrived, zone, zones,
--     next_zone, hops }
-- status is found / known / otherzone / far / unavailable, as in the rows of
-- the NPC list. Looked at most four times a second.
function M.UpdatePins(now, items, styles, api)
    local list = {}
    local parts = {}

    for _, item in ipairs(items or {}) do
        if not pin_hidden[item.key]
            and type(item.text) == 'string'
            and item.text ~= '' then

            list[#list + 1] = item
            parts[#parts + 1] = item.key .. '\1' .. item.text
        end
    end

    local signature = table.concat(parts, '\2')

    if signature == pin_signature and now - pin_scan_time < SCAN_INTERVAL then
        return pin_rows
    end

    pin_signature = signature
    pin_scan_time = now

    if pin_parse_styles ~= styles then
        pin_parse = {}
        pin_parse_styles = styles
    end

    local entries = {}

    for _, item in ipairs(list) do
        local cached = pin_parse[item.text]

        if cached == nil then
            local name = M.ParseStep(item.text, styles)

            cached = { name = name or false }
            pin_parse[item.text] = cached
        end

        if cached.name then
            entries[#entries + 1] = { item = item, npc = cached.name }
        end
    end

    local rows = {}

    local function row_of(entry, status)
        return {
            key = entry.item.key,
            kind = entry.item.kind,
            id = entry.item.id,
            title = entry.item.name,
            npc = entry.npc,
            status = status,
        }
    end

    local function fill(status)
        for _, entry in ipairs(entries) do
            rows[#rows + 1] = row_of(entry, status)
        end

        pin_rows = rows

        return rows
    end

    if #entries == 0 then
        pin_rows = rows

        return rows
    end

    if api == nil then
        return fill('unavailable')
    end

    local ok, me = pcall(api.me)
    local zone = nil

    if api.zone ~= nil then
        local zone_ok, value = pcall(api.zone)

        if zone_ok and type(value) == 'number' and value > 0 then
            zone = value
        end
    end

    if not ok or me == nil then
        return fill('unavailable')
    end

    local wanted = {}

    for _, entry in ipairs(entries) do
        wanted[zonematch.normalize(entry.npc)] = true
    end

    local scanned, live = pcall(M.ScanMany, api, wanted, me)

    if not scanned then
        return fill('unavailable')
    end

    for _, entry in ipairs(entries) do
        local row = row_of(entry, 'far')
        local found = live[zonematch.normalize(entry.npc)]

        if found ~= nil then
            row.status = 'found'
            row.distance = found.distance
            row.zone = zone
            row.index = found.index
        else
            local known = M.Lookup(entry.npc, zone, me)

            if known ~= nil and known.zone ~= nil then
                row.status = 'known'
                row.distance = known.distance
                row.zone = known.zone
                row.pos = { x = known.x, y = known.y, h = known.h }
            elseif known ~= nil then
                local route = M.Route(zone, known.zones)

                row.status = 'otherzone'
                row.zones = known.zones
                row.zone = known.zones[1]
                row.next_zone = route and route.next or nil
                row.hops = route and route.hops or nil
            end
        end

        if row.distance ~= nil then
            row.arrived = row.distance <= ARRIVED
        end

        rows[#rows + 1] = row
    end

    pin_rows = rows

    return rows
end

function M.GetPinRows()
    return pin_rows
end

-- Target and window ---------------------------------------------------------

-- kind is 'quest' or 'mission'; area is needed to open a mission again.
function M.SetTarget(kind, id, name, area)
    kind = tostring(kind or ''):lower()

    if kind ~= 'quest' and kind ~= 'mission' then
        return false
    end

    target = {
        kind = kind,
        id = tostring(id or ''),
        name = tostring(name or ''),
        area = area ~= nil and tostring(area) or nil,
    }

    cache.text = nil
    state = { status = 'none' }

    return true
end

function M.ClearTarget()
    target = nil
    cache.text = nil
    state = { status = 'none' }
end

-- A copy, or nil.
function M.GetTarget()
    if target == nil then
        return nil
    end

    return {
        kind = target.kind,
        id = target.id,
        name = target.name,
        area = target.area,
    }
end

function M.IsTarget(kind, id, name)
    return target ~= nil
        and target.kind == tostring(kind or ''):lower()
        and target.id == tostring(id or '')
        and target.name == tostring(name or '')
end

function M.GetWindowOpen()
    return window_open
end

function M.SetWindowOpen(value)
    window_open = value == true
end

-- Where the player left the window (nil until it is moved).
function M.GetPosition()
    return window_x, window_y
end

function M.SetPosition(x, y)
    if type(x) == 'number' and type(y) == 'number' then
        window_x = x
        window_y = y
    end
end

function M.GetSize()
    return window_w, window_h
end

-- width and height nil put the window back to fitting its content.
function M.SetSize(width, height)
    if type(width) == 'number' and type(height) == 'number'
        and width >= 50 and height >= 30
        and width <= 4000 and height <= 4000 then

        window_w = width
        window_h = height
    else
        window_w = nil
        window_h = nil
    end
end

local function clamp_opacity(value, default)
    value = tonumber(value)

    if value == nil then
        return default
    end

    value = math.floor(value / OPACITY_STEP + 0.5) * OPACITY_STEP
    value = tonumber(string.format('%.2f', value))

    return math.max(OPACITY_MIN, math.min(OPACITY_MAX, value))
end

function M.GetOpacity()
    return opacity
end

function M.SetOpacity(value)
    opacity = clamp_opacity(value, opacity)

    return opacity
end

function M.AdjustOpacity(direction)
    return M.SetOpacity(opacity + direction * OPACITY_STEP)
end

function M.GetTextScale()
    return text_scale
end

function M.SetTextScale(value)
    value = tonumber(value)

    if value ~= nil then
        value = math.floor(value / OPACITY_STEP + 0.5) * OPACITY_STEP
        value = tonumber(string.format('%.2f', value))
        text_scale = math.max(TEXT_SCALE_MIN, math.min(TEXT_SCALE_MAX, value))
    end

    return text_scale
end

function M.AdjustTextScale(direction)
    return M.SetTextScale(text_scale + direction * OPACITY_STEP)
end

function M.GetSearchVisible()
    return search_visible
end

function M.SetSearchVisible(value)
    search_visible = value == true
end

-- Settings -----------------------------------------------------------------------

local function new_table()
    if T ~= nil then
        return T{}
    end

    return {}
end

-- saved is the table that Serialize returned (or nil). Anything that does
-- not look right is skipped.
function M.Load(saved)
    target = nil
    window_open = false
    window_x = nil
    window_y = nil
    window_w = nil
    window_h = nil
    opacity = 1.0
    text_scale = 1.0
    search_visible = true
    cache.text = nil
    state = { status = 'none' }
    npcs = {}
    npc_rows = {}
    pin_hidden = {}
    pin_rows = {}
    pin_signature = nil
    pin_scan_time = -1000

    if type(saved) ~= 'table' then
        return
    end

    if type(saved.hidden) == 'table' then
        for _, key in ipairs(saved.hidden) do
            if type(key) == 'string' and key ~= '' then
                pin_hidden[key] = true
            end
        end
    end

    window_open = saved.open == true
    opacity = clamp_opacity(saved.opacity, 1.0)
    M.SetTextScale(saved.text_scale)
    search_visible = saved.search ~= false

    if type(saved.w) == 'number' and type(saved.h) == 'number' then
        M.SetSize(saved.w, saved.h)
    end

    if type(saved.npcs) == 'table' then
        for _, item in ipairs(saved.npcs) do
            if type(item) == 'table' then
                M.AddNpc(item.name, item.zone)
            end
        end
    end

    if type(saved.x) == 'number' and type(saved.y) == 'number' then
        window_x = saved.x
        window_y = saved.y
    end

    local kind = tostring(saved.kind or ''):lower()

    if (kind == 'quest' or kind == 'mission')
        and saved.id ~= nil and saved.name ~= nil then

        target = {
            kind = kind,
            id = tostring(saved.id),
            name = tostring(saved.name),
            area = saved.area ~= nil and tostring(saved.area) or nil,
        }
    end
end

function M.Serialize()
    local saved = new_table()

    saved.open = window_open
    saved.x = window_x
    saved.y = window_y
    saved.w = window_w
    saved.h = window_h
    saved.opacity = opacity
    saved.text_scale = text_scale
    saved.search = search_visible

    saved.npcs = new_table()

    for _, npc in ipairs(npcs) do
        -- The automatic ones are not saved.
        if not npc.auto then
            local item = new_table()

            item.name = npc.name
            item.zone = npc.zone
            saved.npcs[#saved.npcs + 1] = item
        end
    end

    local hidden = {}

    for key in pairs(pin_hidden) do
        hidden[#hidden + 1] = key
    end

    table.sort(hidden)

    if #hidden > 0 then
        saved.hidden = new_table()

        for _, key in ipairs(hidden) do
            saved.hidden[#saved.hidden + 1] = key
        end
    end

    if target ~= nil then
        saved.kind = target.kind
        saved.id = target.id
        saved.name = target.name
        saved.area = target.area
    end

    return saved
end

return M
