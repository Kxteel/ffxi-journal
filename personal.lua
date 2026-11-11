-- The player's own marks on the quests and missions of the Journal:
--
--   * a short note for each quest or mission (what is missing, who to ask),
--   * a list of favorites, to find them again quickly.
--
-- Both are kept by kind, id and name, the same key the step marks use
-- (missions of different nations can share an id, so the name is part of
-- it). logic.lua calls Load and Serialize to keep them with the other
-- settings, and passes the calls of the interface on to this file.
--
-- This is a file of its own because logic.lua has no room left for more
-- local variables.
--
-- The state of the "Active Now" window is kept here too, so that a command
-- can open it. It is not saved.

local M = {}

local NOTE_MAX = 240
local FAVORITE_MAX = 200

local notes = {}
local favorites = {}
local favorite_order = {}

local window = { open = false, tab = 'active' }

-- The lists of the Journal can show only the favorites (one switch for the
-- missions and one for the quests).
local only_favorites = { mission = false, quest = false }

M.NOTE_MAX = NOTE_MAX
M.FAVORITE_MAX = FAVORITE_MAX

-- Ashita's T{} when it exists; the settings library saves those tables.
local function new_table()
    if T ~= nil then
        return T{}
    end

    return {}
end

local function normalize_kind(kind)
    kind = tostring(kind or ''):lower()

    if kind == 'quest' or kind == 'mission' then
        return kind
    end

    return nil
end

function M.Key(kind, id, name)
    return tostring(kind or ''):lower()
        .. ':' .. tostring(id or '')
        .. ':' .. tostring(name or '')
end

-- Notes -------------------------------------------------------------------

-- One line, single spaces, no longer than NOTE_MAX.
local function clean_note(text)
    text = tostring(text or '')
    text = text:gsub('%c', ' ')
    text = text:gsub('%s+', ' ')
    text = text:match('^%s*(.-)%s*$') or ''

    if #text > NOTE_MAX then
        text = text:sub(1, NOTE_MAX)
    end

    return text
end

-- The settings file is Lua source, so the characters that could break a
-- quoted string are saved as %XX and read back.
local function encode_note(text)
    return (text:gsub('[%%\\"]', function(char)
        return string.format('%%%02X', char:byte())
    end))
end

local function decode_note(text)
    return (text:gsub('%%(%x%x)', function(hex)
        return string.char(tonumber(hex, 16))
    end))
end

function M.GetNote(kind, id, name)
    return notes[M.Key(kind, id, name)] or ''
end

function M.HasNote(kind, id, name)
    return notes[M.Key(kind, id, name)] ~= nil
end

-- Returns true when the note changed. An empty text removes the note.
function M.SetNote(kind, id, name, text)
    if normalize_kind(kind) == nil then
        return false
    end

    local key = M.Key(kind, id, name)
    local clean = clean_note(text)
    local current = notes[key] or ''

    if clean == current then
        return false
    end

    if clean == '' then
        notes[key] = nil
    else
        notes[key] = clean
    end

    return true
end

-- Favorites ---------------------------------------------------------------

function M.IsFavorite(kind, id, name)
    return favorites[M.Key(kind, id, name)] ~= nil
end

-- area is the area of a mission (needed to open it again).
-- Returns the new state, and 'full' when there was no room for one more.
function M.ToggleFavorite(kind, id, name, area)
    kind = normalize_kind(kind)

    if kind == nil then
        return false
    end

    local key = M.Key(kind, id, name)

    if favorites[key] ~= nil then
        favorites[key] = nil

        for index, other in ipairs(favorite_order) do
            if other == key then
                table.remove(favorite_order, index)
                break
            end
        end

        return false
    end

    if #favorite_order >= FAVORITE_MAX then
        return false, 'full'
    end

    favorites[key] = {
        kind = kind,
        id = tostring(id or ''),
        name = tostring(name or ''),
        area = area ~= nil and tostring(area) or nil,
    }

    favorite_order[#favorite_order + 1] = key

    return true
end

-- The favorites, the oldest first. The entries are copies.
function M.GetFavorites()
    local result = {}

    for _, key in ipairs(favorite_order) do
        local entry = favorites[key]

        result[#result + 1] = {
            kind = entry.kind,
            id = entry.id,
            name = entry.name,
            area = entry.area,
        }
    end

    return result
end

-- Settings ----------------------------------------------------------------

-- saved_notes is a table key -> text; saved_favorites a list of entries.
-- Anything that does not look right is skipped.
function M.Load(saved_notes, saved_favorites, saved_filters)
    notes = {}
    favorites = {}
    favorite_order = {}

    only_favorites.mission =
        type(saved_filters) == 'table' and saved_filters.missions == true
    only_favorites.quest =
        type(saved_filters) == 'table' and saved_filters.quests == true

    if type(saved_notes) == 'table' then
        for key, text in pairs(saved_notes) do
            if type(key) == 'string' and type(text) == 'string' then
                local clean = clean_note(decode_note(text))

                if clean ~= '' then
                    notes[key] = clean
                end
            end
        end
    end

    if type(saved_favorites) == 'table' then
        for _, entry in ipairs(saved_favorites) do
            local kind = type(entry) == 'table' and normalize_kind(entry.kind)

            if kind and entry.id ~= nil and entry.name ~= nil
                and #favorite_order < FAVORITE_MAX then

                local key = M.Key(kind, entry.id, entry.name)

                if favorites[key] == nil then
                    favorites[key] = {
                        kind = kind,
                        id = tostring(entry.id),
                        name = tostring(entry.name),
                        area = entry.area ~= nil
                            and tostring(entry.area) or nil,
                    }

                    favorite_order[#favorite_order + 1] = key
                end
            end
        end
    end
end

-- Returns the notes, the favorites and the filters, ready for the settings
-- file.
function M.Serialize()
    local saved_notes = new_table()

    for key, text in pairs(notes) do
        saved_notes[key] = encode_note(text)
    end

    local saved_favorites = new_table()

    for _, key in ipairs(favorite_order) do
        local entry = favorites[key]

        saved_favorites[#saved_favorites + 1] = new_table()
        local saved = saved_favorites[#saved_favorites]

        saved.kind = entry.kind
        saved.id = entry.id
        saved.name = entry.name
        saved.area = entry.area
    end

    local saved_filters = new_table()

    saved_filters.missions = only_favorites.mission
    saved_filters.quests = only_favorites.quest

    return saved_notes, saved_favorites, saved_filters
end

-- The "only favorites" switch of the missions or of the quests.
function M.GetOnlyFavorites(kind)
    return only_favorites[normalize_kind(kind) or ''] == true
end

-- Returns true when the switch changed.
function M.SetOnlyFavorites(kind, value)
    kind = normalize_kind(kind)
    value = value == true

    if kind == nil or only_favorites[kind] == value then
        return false
    end

    only_favorites[kind] = value

    return true
end

-- "Active Now" window (not saved) ------------------------------------------

function M.GetWindowOpen()
    return window.open
end

function M.GetWindowTab()
    return window.tab
end

-- tab is 'active' or 'favorites'; without it the tab stays as it was.
function M.SetWindowOpen(value, tab)
    window.open = value == true

    if tab == 'active' or tab == 'favorites' then
        window.tab = tab
    end
end

return M
