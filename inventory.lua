-- What the player carries, to mark the items that a step asks for.
--
-- richtext.lua asks this module (richtext.items_api, set by journal.lua) if
-- the player has an item by its name: Tick() is called while the steps are
-- drawn and does the work in small pieces, Version() changes when the
-- inventory (or the index of names) changes so the marked texts are made
-- again, and Status(name, quantity) answers 'ok' (enough), 'partial' (some)
-- or nil (not an item, or not known yet).
--
-- The names come from the game resources: the items are read once, a slice
-- of ids at each call, and indexed by name (lowercase, no apostrophes). The
-- counts are read from all the containers of the character (bag, safe,
-- storage, locker, satchel, sack, case and the wardrobes), every
-- SCAN_INTERVAL seconds. The key items are the same way: their names are
-- read from the resources ('keyitems.names') and the ones that a text names
-- are asked to the player (HasKeyItem) at each scan. Everything is protected: if the binding of Ashita
-- does not answer as expected the module just says nothing.

local M = {}

-- Container ids of Ashita: 0 bag, 1 mog safe, 2 storage, 3 temporary (left
-- out), 4 locker, 5 satchel, 6 sack, 7 case, 8 wardrobe, 9 safe 2, 10 to 12
-- wardrobes 2 to 4.
local CONTAINERS = { 0, 1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12 }
local SCAN_INTERVAL = 1.5
local INDEX_SLICE = 1500
local INDEX_MAX = 32000
local KEY_MAX = 4500
local GIL_ID = 65535

local counts = {}
local version = 1
local last_scan = -1000

local index = { names = {}, next_id = 1, done = false }
local key_index = { names = {}, next_id = 0, done = false }

-- Key items that a text has asked for: id -> true when the player has it.
local watched = {}

local function normalize(name)
    name = tostring(name or ''):lower()
    name = name:gsub("'", ''):gsub('`', ''):gsub('\226\128\153', '')
    name = name:gsub('%s+', ' '):gsub('^ ', ''):gsub(' $', '')

    return name
end

M.normalize = normalize

local function index_slice()
    local ok, manager = pcall(function()
        return AshitaCore:GetResourceManager()
    end)

    if not ok or manager == nil then
        return
    end

    local last = math.min(index.next_id + INDEX_SLICE - 1, INDEX_MAX)

    for id = index.next_id, last do
        local got, item = pcall(function()
            return manager:GetItemById(id)
        end)

        if got and item ~= nil then
            local named, name = pcall(function()
                return item.Name[1]
            end)

            if named and type(name) == 'string' and name ~= '' then
                local key = normalize(name)
                local list = index.names[key]

                if list == nil then
                    index.names[key] = { id }
                else
                    list[#list + 1] = id
                end
            end
        end
    end

    index.next_id = last + 1

    if index.next_id > INDEX_MAX then
        index.done = true
        version = version + 1
    end
end

local function key_slice()
    local ok, manager = pcall(function()
        return AshitaCore:GetResourceManager()
    end)

    if not ok or manager == nil then
        return
    end

    local last = math.min(key_index.next_id + INDEX_SLICE - 1, KEY_MAX)

    for id = key_index.next_id, last do
        local got, name = pcall(function()
            return manager:GetString('keyitems.names', id)
        end)

        if got and type(name) == 'string' and name ~= '' then
            local key = normalize(name)

            -- The first id of a name is kept.
            if key_index.names[key] == nil then
                key_index.names[key] = id
            end
        end
    end

    key_index.next_id = last + 1

    if key_index.next_id > KEY_MAX then
        key_index.done = true
        version = version + 1
    end
end

local function has_key_item(id)
    local ok, owned = pcall(function()
        return AshitaCore:GetMemoryManager():GetPlayer():HasKeyItem(id)
    end)

    return ok and owned == true
end

local function scan()
    -- The key items that were asked for.
    for id, owned in pairs(watched) do
        local now_owned = has_key_item(id)

        if now_owned ~= owned then
            watched[id] = now_owned
            version = version + 1
        end
    end

    local ok, inventory = pcall(function()
        return AshitaCore:GetMemoryManager():GetInventory()
    end)

    if not ok or inventory == nil then
        return
    end

    local found = {}
    local total = 0

    for _, container in ipairs(CONTAINERS) do
        local got, max = pcall(function()
            return inventory:GetContainerCountMax(container)
        end)

        if got and type(max) == 'number' then
            for slot = 0, max do
                local read, item = pcall(function()
                    return inventory:GetContainerItem(container, slot)
                end)

                if read and item ~= nil then
                    local id = tonumber(item.Id) or 0
                    local count = tonumber(item.Count) or 0

                    if id > 0 and id ~= GIL_ID and count > 0 then
                        found[id] = (found[id] or 0) + count
                        total = total + 1
                    end
                end
            end
        end
    end

    -- An empty answer (zoning, or not logged in yet) keeps what was known.
    if total == 0 then
        return
    end

    local changed = false

    for id, count in pairs(found) do
        if counts[id] ~= count then
            changed = true
            break
        end
    end

    if not changed then
        for id in pairs(counts) do
            if found[id] == nil then
                changed = true
                break
            end
        end
    end

    if changed then
        counts = found
        version = version + 1
    end
end

-- Called while the steps are drawn.
function M.Tick()
    if not index.done then
        index_slice()
    elseif not key_index.done then
        key_slice()
    end

    local now = os.clock()

    if now - last_scan >= SCAN_INTERVAL then
        last_scan = now
        scan()
    end
end

function M.Version()
    return version
end

-- 'ok' when the player has quantity or more, 'partial' (and how many) when
-- he has fewer, nil when the name is neither an item nor a key item of the
-- game (a door, a monster...) or the names are not read yet.
function M.Status(name, quantity)
    if not index.done then
        return nil
    end

    local key = normalize(name)
    local ids = index.names[key]

    if ids == nil then
        -- Not an item: maybe a key item (there is only one of each).
        local key_id = key_index.done and key_index.names[key] or nil

        if key_id == nil then
            return nil
        end

        local owned = watched[key_id]

        if owned == nil then
            owned = has_key_item(key_id)
            watched[key_id] = owned
        end

        if owned then
            return 'ok', 1
        end

        return 'partial', 0
    end

    local have = 0

    for _, id in ipairs(ids) do
        have = have + (counts[id] or 0)
    end

    if have >= (quantity or 1) then
        return 'ok', have
    end

    return 'partial', have
end

-- For the tests.
function M.Reset()
    counts = {}
    version = 1
    last_scan = -1000
    index = { names = {}, next_id = 1, done = false }
    key_index = { names = {}, next_id = 0, done = false }
    watched = {}
end

return M
