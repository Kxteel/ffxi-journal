-- General notes: free text notes that belong to no quest or mission. Each
-- has a title and can be put in a folder (a category).
--
-- They are shared by all the characters, so they are kept in a file of their
-- own (not with the settings of the character): Ashita's config folder for
-- the addon, or the folder of the addon when that cannot be written.
--
-- The window that edits them is drawn by ui.lua. This file only keeps the
-- list and saves it.

local M = {}

M.TEXT_MAX = 2000
M.TITLE_MAX = 60
M.CAT_NAME_MAX = 30
M.NOTE_MAX_COUNT = 100
M.COLOR_COUNT = 8 -- the colors of a folder are 1 to 8 (ui.lua); 0 is none
M.CAT_MAX_COUNT = 30

local FILE_NAME = 'shared_notes.lua'
local SAVE_DELAY = 1.5

local notes = {}
local cats = {}
local next_id = 1
local next_cat_id = 1
local win_size = nil
local loaded = false
local dirty = false
local dirty_time = 0
local used_path = nil

local window = { open = false, selected = nil, sel_cat = nil }

local function now()
    return os.clock()
end

-- The folders where the file may be, in order of preference.
local function candidate_dirs()
    local dirs = {}

    local ok, install = pcall(function()
        return AshitaCore:GetInstallPath()
    end)

    if ok and type(install) == 'string' and install ~= '' then
        install = install:gsub('/', '\\')

        if install:sub(-1) ~= '\\' then
            install = install .. '\\'
        end

        dirs[#dirs + 1] = {
            dir = install .. 'config\\addons\\journal\\',
            create = true,
        }
    end

    if addon ~= nil and type(addon.path) == 'string' then
        dirs[#dirs + 1] = { dir = addon.path, create = false }
    end

    return dirs
end

local function make_dir(path)
    if ashita == nil or ashita.fs == nil then
        return
    end

    for _, name in ipairs({ 'create_dir', 'create_directory' }) do
        local fn = ashita.fs[name]

        if fn ~= nil then
            pcall(fn, path)
        end
    end
end

-- Serializes everything as a Lua file that returns a table.
local function serialize()
    local parts = { 'return {\n' }

    if win_size ~= nil then
        parts[#parts + 1] = string.format(
            '  window = { w = %d, h = %d },\n',
            win_size.w,
            win_size.h
        )
    end

    parts[#parts + 1] = '  categories = {\n'

    for _, cat in ipairs(cats) do
        parts[#parts + 1] = string.format(
            '    { id = %d, name = %q, color = %d, collapsed = %s },\n',
            cat.id,
            cat.name,
            cat.color or 0,
            cat.collapsed and 'true' or 'false'
        )
    end

    parts[#parts + 1] = '  },\n  notes = {\n'

    for _, note in ipairs(notes) do
        parts[#parts + 1] = string.format(
            '    { id = %d, time = %d, cat = %d, title = %q, text = %q },\n',
            note.id,
            note.time or 0,
            note.cat or 0,
            note.title or '',
            note.text or ''
        )
    end

    parts[#parts + 1] = '  },\n}\n'

    return table.concat(parts)
end

local function read_file(path)
    local file = io.open(path, 'rb')

    if file == nil then
        return nil
    end

    local data = file:read('*a')
    file:close()

    return data
end

local function parse(data)
    if type(data) ~= 'string' or data == '' then
        return nil
    end

    local chunk

    if loadstring ~= nil then
        chunk = loadstring(data, 'shared_notes')
    else
        chunk = load(data, 'shared_notes', 't', {})
    end

    if chunk == nil then
        return nil
    end

    if setfenv ~= nil then
        setfenv(chunk, {})
    end

    local ok, result = pcall(chunk)

    if ok and type(result) == 'table' then
        return result
    end

    return nil
end

local function find_cat(id)
    for index, cat in ipairs(cats) do
        if cat.id == id then
            return cat, index
        end
    end

    return nil
end

local function clean_text(value, max)
    return tostring(value or ''):gsub('[\r\n]+', ' '):sub(1, max)
end

local function read_list(list)
    notes = {}
    cats = {}
    next_id = 1
    next_cat_id = 1
    win_size = nil

    -- The first version of the file was a plain list of notes.
    local note_list = list
    local cat_list = {}

    if type(list.notes) == 'table' then
        note_list = list.notes
        cat_list = type(list.categories) == 'table' and list.categories or {}

        local w = type(list.window) == 'table' and tonumber(list.window.w)
        local h = type(list.window) == 'table' and tonumber(list.window.h)

        if w and h and w >= 100 and h >= 100 then
            win_size = { w = math.floor(w), h = math.floor(h) }
        end
    end

    local seen_cat = {}

    for _, item in ipairs(cat_list) do
        if type(item) == 'table' and type(item.name) == 'string'
            and #cats < M.CAT_MAX_COUNT then

            local id = math.floor(tonumber(item.id) or 0)

            if id < 1 or seen_cat[id] then
                id = next_cat_id
            end

            seen_cat[id] = true

            if id >= next_cat_id then
                next_cat_id = id + 1
            end

            cats[#cats + 1] = {
                id = id,
                name = clean_text(item.name, M.CAT_NAME_MAX),
                color = math.max(0, math.min(M.COLOR_COUNT, math.floor(tonumber(item.color) or 0))),
                collapsed = item.collapsed == true,
            }
        end
    end

    local seen = {}

    for _, item in ipairs(note_list) do
        if type(item) == 'table' and type(item.text) == 'string'
            and #notes < M.NOTE_MAX_COUNT then

            local id = math.floor(tonumber(item.id) or 0)

            -- An id that is missing or repeated gets a new one.
            if id < 1 or seen[id] then
                id = next_id
            end

            seen[id] = true

            if id >= next_id then
                next_id = id + 1
            end

            local cat = math.floor(tonumber(item.cat) or 0)

            if find_cat(cat) == nil then
                cat = 0
            end

            notes[#notes + 1] = {
                id = id,
                time = tonumber(item.time) or 0,
                cat = cat,
                title = clean_text(item.title, M.TITLE_MAX),
                text = item.text:sub(1, M.TEXT_MAX),
            }
        end
    end
end

function M.Load()
    notes = {}
    cats = {}
    next_id = 1
    next_cat_id = 1
    win_size = nil
    dirty = false
    loaded = true

    for _, entry in ipairs(candidate_dirs()) do
        local data = read_file(entry.dir .. FILE_NAME)
        local list = parse(data)

        if list ~= nil then
            read_list(list)
            used_path = entry.dir .. FILE_NAME

            return true
        end
    end

    return false
end

-- Writes the file now. True when it was written.
function M.Save()
    local data = serialize()

    for _, entry in ipairs(candidate_dirs()) do
        if entry.create then
            make_dir(entry.dir)
        end

        local file = io.open(entry.dir .. FILE_NAME, 'wb')

        if file ~= nil then
            file:write(data)
            file:close()

            used_path = entry.dir .. FILE_NAME
            dirty = false

            return true
        end
    end

    return false
end

local function touch()
    dirty = true
    dirty_time = now()
end

-- Called every frame by the window: saves a second and a half after the
-- last change, not at every key.
function M.Tick()
    if dirty and now() - dirty_time >= SAVE_DELAY then
        M.Save()
    end
end

function M.Flush()
    if dirty then
        M.Save()
    end
end

function M.GetPath()
    return used_path
end

function M.Count()
    return #notes
end

function M.Get(index)
    return notes[index]
end

-- A new empty note goes first, in the folder cat_id when it is given.
-- Returns its index, or nil when the list is full.
function M.Add(cat_id)
    if #notes >= M.NOTE_MAX_COUNT then
        return nil
    end

    if cat_id ~= nil and find_cat(cat_id) == nil then
        cat_id = nil
    end

    table.insert(notes, 1, {
        id = next_id,
        time = os.time(),
        cat = cat_id or 0,
        title = '',
        text = '',
    })

    next_id = next_id + 1
    touch()

    return 1
end

function M.SetText(index, text)
    local note = notes[index]

    if note == nil then
        return false
    end

    text = tostring(text or ''):sub(1, M.TEXT_MAX)

    if note.text ~= text then
        note.text = text
        note.time = os.time()
        touch()
    end

    return true
end

function M.SetTitle(index, title)
    local note = notes[index]

    if note == nil then
        return false
    end

    title = clean_text(title, M.TITLE_MAX)

    if note.title ~= title then
        note.title = title
        touch()
    end

    return true
end

-- Puts the note in a folder (0 or nil: no folder).
function M.SetCategory(index, cat_id)
    local note = notes[index]

    if note == nil then
        return false
    end

    cat_id = cat_id or 0

    if cat_id ~= 0 and find_cat(cat_id) == nil then
        return false
    end

    if note.cat ~= cat_id then
        note.cat = cat_id
        touch()
    end

    return true
end

function M.Delete(index)
    if notes[index] == nil then
        return false
    end

    table.remove(notes, index)
    M.Save()

    return true
end

-- What the list shows: the title, or the first line of the text when it
-- has none. nil when both are empty.
function M.Title(note, max_chars)
    local shown = note and note.title or ''

    if shown == '' then
        shown = tostring(note and note.text or ''):match('[^\r\n]+') or ''
    end

    shown = shown:gsub('^%s+', '')

    if shown == '' then
        return nil
    end

    max_chars = max_chars or 24

    if #shown > max_chars then
        shown = shown:sub(1, max_chars - 3) .. '...'
    end

    return shown
end

-- Folders -------------------------------------------------------------------

function M.GetCategories()
    return cats
end

function M.GetCategory(id)
    return (find_cat(id))
end

function M.CountInCategory(id)
    local count = 0

    for _, note in ipairs(notes) do
        if note.cat == id then
            count = count + 1
        end
    end

    return count
end

-- A new folder with a name that is not taken. Returns its id, or nil when
-- there are too many.
function M.AddCategory()
    if #cats >= M.CAT_MAX_COUNT then
        return nil
    end

    local n = #cats + 1
    local name

    repeat
        name = 'Folder ' .. n
        n = n + 1

        local taken = false

        for _, cat in ipairs(cats) do
            if cat.name == name then
                taken = true
            end
        end
    until not taken

    local cat = { id = next_cat_id, name = name, color = 0, collapsed = false }

    next_cat_id = next_cat_id + 1
    cats[#cats + 1] = cat
    touch()

    return cat.id
end

function M.RenameCategory(id, name)
    local cat = find_cat(id)

    if cat == nil then
        return false
    end

    name = clean_text(name, M.CAT_NAME_MAX)

    if name ~= '' and cat.name ~= name then
        cat.name = name
        touch()
    end

    return true
end

-- The color of a folder: 0 (none) to COLOR_COUNT.
function M.SetCategoryColor(id, color)
    local cat = find_cat(id)

    if cat == nil then
        return false
    end

    color = math.floor(tonumber(color) or 0)

    if color < 0 or color > M.COLOR_COUNT then
        return false
    end

    if cat.color ~= color then
        cat.color = color
        touch()
    end

    return true
end

function M.SetCollapsed(id, value)
    local cat = find_cat(id)

    if cat ~= nil and cat.collapsed ~= (value == true) then
        cat.collapsed = value == true
        touch()
    end
end

-- The notes of the folder go back to "no folder".
function M.DeleteCategory(id)
    local cat, index = find_cat(id)

    if cat == nil then
        return false
    end

    for _, note in ipairs(notes) do
        if note.cat == id then
            note.cat = 0
        end
    end

    table.remove(cats, index)
    M.Save()

    return true
end

-- The rows of the list: the notes without a folder, then each folder with its
-- notes (not the notes of a folder that is collapsed).
function M.Rows()
    local rows = {}

    for index, note in ipairs(notes) do
        if note.cat == 0 then
            rows[#rows + 1] = { kind = 'note', note = note, index = index }
        end
    end

    for _, cat in ipairs(cats) do
        rows[#rows + 1] = {
            kind = 'folder',
            cat = cat,
            count = M.CountInCategory(cat.id),
        }

        if not cat.collapsed then
            for index, note in ipairs(notes) do
                if note.cat == cat.id then
                    rows[#rows + 1] = {
                        kind = 'note',
                        note = note,
                        index = index,
                        nested = true,
                    }
                end
            end
        end
    end

    return rows
end

-- Size of the window, kept in the file.
function M.GetSize()
    return win_size
end

function M.SetSize(w, h)
    w = math.floor(tonumber(w) or 0)
    h = math.floor(tonumber(h) or 0)

    if w < 100 or h < 100 then
        return
    end

    if win_size == nil or win_size.w ~= w or win_size.h ~= h then
        win_size = { w = w, h = h }
        touch()
    end
end

-- State of the window (not saved).
function M.GetOpen()
    return window.open
end

function M.SetOpen(value)
    value = value == true

    if window.open and not value then
        M.Flush()
    end

    window.open = value
end

function M.Toggle()
    M.SetOpen(not window.open)
end

function M.GetSelected()
    return window.selected
end

-- Selecting a note leaves the folder, and the other way around.
function M.Select(id)
    window.selected = id

    if id ~= nil then
        window.sel_cat = nil
    end
end

function M.GetSelectedCategory()
    return window.sel_cat
end

function M.SelectCategory(id)
    window.sel_cat = id

    if id ~= nil then
        window.selected = nil
    end
end

function M.IndexOfId(id)
    for index, note in ipairs(notes) do
        if note.id == id then
            return index
        end
    end

    return nil
end

return M
