local M = {}

local settings = require('settings')
local tracker = require('tracker')
local zonematch = require('zonematch')
local i18n = require('i18n')

-- Notes, favorites and the state of the "Active Now" window (personal.lua).
-- It is a field of M and not a local variable: this file has no room left
-- for more locals.
M.personal = (require('personal'))
M.notes = (require('notes'))

-- The compass: an arrow to the NPC of the current step (compass.lua). A
-- field of M for the same reason.
M.compass = (require('compass'))

-- The arrow over the NPC of the compass in the game world (worldmark.lua).
M.worldmark = (require('worldmark'))

-- Data

-- The areas in the order of the selector, in four types. Voidwatch has no
-- mission data yet, so it is not listed.
local mission_areas = {
    -- Starter City Missions
    'bastok',
    'windurst',
    'sandoria',

    -- Expansion Missions
    'zilart',
    'cop',
    'toau',
    'wotg',
    'adoulin',
    'rov',

    -- Scenario Missions
    'acp',
    'mkd',
    'asa',
    'abyssea',
    'tvr',

    -- Special Battle Endeavors
    'assault',
    'campaign',
}

-- The type each area belongs to (the header shown above its first area).
local mission_area_types = {
    bastok = 'Starter City Missions',
    zilart = 'Expansion Missions',
    acp = 'Scenario Missions',
    assault = 'Special Battle Endeavors',
}

-- How the missions of Rise of the Zilart and Chains of Promathia are
-- numbered and grouped (by mission id). The epilogue is made of three
-- quests (see GetMissionListExtras). "The Outlands" of Zilart has no number.
-- (One table: the main chunk of a Lua file may have only 200 locals.)
local EPILOGUE_QUESTS = {
    'jeu_rg_storms_of_fate',
    'jeu_rg_shadows_of_the_departed',
    'jeu_rg_apocalypse_nigh',
}

local MISSION_GUIDE = {
    zilart = {
        numbers = {
            [0] = 1, [4] = 2, [6] = 3, [8] = 4, [10] = 5, [12] = 6, [14] = 7,
            [16] = 8, [18] = 9, [20] = 10, [22] = 11, [23] = 12, [24] = 13,
            [26] = 14, [27] = 15, [28] = 16, [30] = 17, [31] = 18,
        },
        finale_id = 31,
    },

    cop = {
        numbers = {
            [110] = '1-1', [118] = '1-2', [128] = '1-3',
            [138] = '2-1', [218] = '2-2', [228] = '2-3', [238] = '2-4', [248] = '2-5',
            [258] = '3-1', [318] = '3-2', [325] = '3-3', [350] = '3-4', [358] = '3-5',
            [368] = '4-1', [418] = '4-2', [428] = '4-3', [438] = '4-4',
            [448] = '5-1', [518] = '5-2', [530] = '5-3',
            [578] = '6-1', [618] = '6-2', [628] = '6-3', [638] = '6-4',
            [648] = '7-1', [718] = '7-2', [728] = '7-3', [738] = '7-4', [748] = '7-5',
            [800] = '8-1', [818] = '8-2', [828] = '8-3', [840] = '8-4', [850] = '8-5',
        },
        finale_id = 850,
        chapters = {
            'Ancient Flames Beckon',
            'The Isle of Forgotten Saints',
            'A Transient Dream',
            'The Cradles of Children Lost',
            'The Return Home',
            'Echoes of Time',
            'In the Light of the Crystal',
            'Emptiness Bleeds',
        },
    },

    -- Seekers of Adoulin: the code of each mission ("2-4-1") is a field of
    -- the data. The epilogue is made of three Records of Eminence quests
    -- that are not in the quest data, so they are shown as information.
    adoulin = {
        from_data = true,
        finale_id = 368,
        chapters = {
            'The Sacred City of Adoulin',
            'The Ancient Pact',
            'Shadows Upon Adoulin',
            'The Serpentine Labyrinth',
            'Hades',
        },
        epilogue_info = {
            {
                name = 'The Silent Forest',
                type = 'BCNM',
                reward = 'One of: Pact with Siren, Ligeia Ring, Ligeia Sash, Ligeia Scythe; 10,000 Bayld',
            },
            {
                name = 'The Ygnas Directive',
                type = 'Records of Eminence Quests',
                reward = '30,000 Experience Points; 18,000 Sparks of Eminence; Delegate\'s Cuffs; Delegate\'s Garb; 50 Pinches of High-Purity Bayld; Key Item: Ygnas\'s insignia; one of: Adoulin Ring +1, Gorney Ring +1, Haverton Ring +1, Janniston Ring +1, Karieyh Ring +1, Orvail Ring +1, Renaye Ring +1, Shneddick Ring +1, Thurandaut Ring +1, Vocane Ring +1, Weatherspoon Ring +1, Woltaris Ring +1',
            },
            {
                name = 'The Arciela Directive',
                type = 'Records of Eminence Quests',
                reward = '1,000 Sparks of Eminence; 5,000 Experience Points; 50 Pinches of High-Purity Bayld; Key Item: Ygnas\'s leaf; Trust: Ygnas',
            },
        },
    },

    -- Rhapsodies of Vana'diel: the code of each mission is a field of the
    -- data. notes are the requirements shown before a mission (by code).
    rov = {
        from_data = true,
        finale_id = 334,
        chapters = {
            'Creation and Rebirth',
            'Revitalization',
            'Reckoning',
        },
        notes = {
            ['1-7'] = 'Requires: Rank 3 in your home nation (Journey Abroad, The Emissary, The Three Kingdoms)',
            ['1-12'] = 'Requires: Rank 6 in your home nation (The Shadow Lord; Xarcabard, Land of Truths; The Shadow Awaits)',
            ['2-2'] = 'Requires: Chains of Promathia up to The Road Forks',
            ['2-7'] = 'Requires: Treasures of Aht Urhgan up to Royal Puppeteer',
            ['2-14'] = 'Requires: Wings of the Goddess up to In the Name of the Father',
            ['2-24'] = 'Requires: Rise of the Zilart up to Headstone Pilgrimage',
            ['3-4'] = 'Requires: Seekers of Adoulin up to Meeting of the Minds',
            ['3-6'] = 'Requires: Seekers of Adoulin up to An Aimless Journey',
            ['3-8'] = 'Requires: Seekers of Adoulin up to Behind the Sluices, and the Key Item Waterway facility crank',
        },
        epilogue_info = {
            {
                name = 'The Silent Forest',
                type = 'BCNM - Finale',
                reward = 'One of: Pact with Siren, Ligeia Ring, Ligeia Sash, Ligeia Scythe; 10,000 Bayld',
            },
        },
    },

    -- The three nations: the missions are grouped by rank (the rank is a
    -- field of the data).
    windurst = { by_rank = true },
    bastok = { by_rank = true },
    sandoria = { by_rank = true },

    -- Treasures of Aht Urhgan: missions 1 to 48, the mission id plus one
    -- (filled in just below).
    toau = {
        numbers = {},
        finale_id = 47,
    },
}

for id = 0, 47 do
    MISSION_GUIDE.toau.numbers[id] = id + 1
end

-- The order before the types, to read a position saved by an older version.
local OLD_MISSION_ORDER = {
    'sandoria', 'bastok', 'windurst', 'zilart', 'cop', 'toau', 'wotg',
    'acp', 'mkd', 'asa', 'abyssea', 'adoulin', 'rov', 'tvr', 'assault',
    'campaign',
}

local mission_area_names = {
    sandoria = "San d'Oria",
    bastok = 'Bastok',
    windurst = 'Windurst',
    zilart = 'Rise of the Zilart',
    cop = 'Chains of Promathia',
    toau = 'Treasures of Aht Urhgan',
    wotg = 'Wings of the Goddess',
    acp = 'A Crystalline Prophecy',
    mkd = "A Moogle Kupo d'Etat",
    asa = 'A Shantotto Ascension',
    abyssea = 'Abyssea',
    adoulin = 'Seekers of Adoulin',
    rov = "Rhapsodies of Vana'diel",
    tvr = 'The Voracious Resurgence',
    assault = 'Assault',
    campaign = 'Campaign',
}

local function get_quest_categories()
    return tracker.GetQuestCategories()
end

local function get_quest_category_names()
    return tracker.GetQuestCategoryNames()
end

-- What the selector of categories shows: "All" and then the categories. It is
-- rebuilt only when the list of the tracker changes.
local quest_categories_source = nil
local quest_categories_view = {}

local function get_quest_categories_view()
    local source = get_quest_categories()

    if #source == 0 then
        return source
    end

    if source ~= quest_categories_source
        or #quest_categories_view ~= #source + 1 then

        quest_categories_source = source
        quest_categories_view = { 'all' }

        for _, category in ipairs(source) do
            quest_categories_view[#quest_categories_view + 1] = category
        end
    end

    return quest_categories_view
end

-- Names of the categories plus the name of "All" (in the current language).
local quest_category_names_view = setmetatable({}, {
    __index = function(_, key)
        return (get_quest_category_names() or {})[key]
    end,
})

local function get_quest_category_names_view()
    quest_category_names_view.all = i18n.t('All')

    return quest_category_names_view
end

local function get_quest_list_from_tracker(category)
    return tracker.GetQuestArea(category) or {}
end

-- Journal state

local journal_mode = 1

local mission_area_index = 1
local mission_index = 1

local quest_category_index = 1
local quest_index = 1

-- The "All" entry of the area and category selectors: the list shows every
-- area (or category) together. The selectors show it as the first entry, so
-- the index the interface sees is one more than the index kept here.
-- Kept in one table for the same reason as the alert settings.
-- groups: the zone groups of the list of quests (see rebuild_quest_cache).
local all_view = { missions = false, quests = false, groups = {} }

-- Journal window

local journal_visible = false
local journal_width = 2000
local journal_height = 1600
local journal_x = nil
local journal_y = nil

local journal_mini = false

-- Whether the small button of the Journal is shown while the Journal is
-- closed. Off by default.
local journal_mini_button = false
local journal_mini_x = nil
local journal_mini_y = nil

-- Pinned tracker

local PIN_MAX = 8

local pin_visible = false
local pin_x = nil
local pin_y = nil
local pin_mode = 'stacked'
local pin_active = 1

-- Size of the tracker, as a multiple of its normal size.
local PIN_SCALE_MIN = 0.60
local PIN_SCALE_MAX = 2.00
local PIN_SCALE_STEP = 0.10
local pin_scale = 1.0

-- Whether the tracker shows the next step under the current one.
local pin_show_next = true

-- The alert of a new quest or mission: the banner, its sound, and the
-- question about pinning it.
-- (Kept in one table: LuaJIT allows only 60 upvalues in a function, and the
-- functions that read and write the settings already use many.)
local announce = {
    enabled = true,
    sound = true,
    ask = true,

    -- The alert of quests that are not active in the zone just entered.
    -- near_pending is the zone waiting to be checked.
    near = true,
    near_pending = nil,

    -- The alert of an NPC close by who starts a quest that is not active.
    prox = true,
    prox_compass = true,

    -- The arrow over the NPC of the compass (a prototype: off until the
    -- player turns it on with /journal mark on).
    world_mark = false,
    world_mark_all = true,
    world_mark_edge = true,
    world_mark_active = true,

    -- The look of the alerts, one for the new quests and missions and one
    -- for the completed ones. color is a place in the palette, 0 being the
    -- default color of the alert.
    style = {
        new = { opacity = 0.70, size = 1.0, color = 0 },
        done = { opacity = 0.70, size = 1.0, color = 0 },
        near = { opacity = 0.70, size = 1.0, color = 0 },
    },

    -- The alert being tried from the settings window.
    test = nil,
    test_token = 0,
}

-- Colors the text of an alert can have.
local ALERT_PALETTE = {
    { 1.00, 0.85, 0.40, 1.00 },
    { 0.55, 0.75, 1.00, 1.00 },
    { 0.45, 0.90, 0.50, 1.00 },
    { 1.00, 0.42, 0.42, 1.00 },
    { 0.75, 0.55, 1.00, 1.00 },
    { 1.00, 0.65, 0.30, 1.00 },
    { 0.45, 0.88, 0.90, 1.00 },
    { 1.00, 1.00, 1.00, 1.00 },
}

local ALERT_SIZE_MIN = 0.6
local ALERT_SIZE_MAX = 1.6

-- Language of the objective texts: 'en' or 'es'.
local language = 'en'

local function clamp_pin_scale(value)
    value = tonumber(value) or 1.0
    value = math.max(PIN_SCALE_MIN, math.min(PIN_SCALE_MAX, value))

    -- Two decimals, so repeated steps do not drift (0.1 + 0.2 ~ 0.30000001).
    return math.floor(value * 100 + 0.5) / 100
end
local pin_auto_zone = false

-- Automatic pins: the active quests the game reports are pinned by
-- themselves. The ones the player unpinned by hand (id -> true) are not
-- pinned again while they stay active.
local auto_pin_quests = false
local auto_pin_dismissed = {}

-- Opacity of the Journal windows and of the Tracker, and the background of
-- the Tracker (it has none by default). Set from the settings window.
local OPACITY_MIN = 0.35
local OPACITY_MAX = 1.00
local OPACITY_STEP = 0.05
local BACKGROUND_MAX = 0.80
local journal_opacity = 1.0

-- Size of the text of the Journal and of its windows (0.5 to 1.4). The sizes
-- of the buttons and the bars follow it.
local TEXT_SCALE_MIN = 0.50
local TEXT_SCALE_MAX = 1.40
local journal_text_scale = 1.0
local pin_opacity = 1.0
local pin_background = 0.0

local function clamp_opacity(value, min, max, default)
    value = tonumber(value)

    if value == nil then
        return default
    end

    -- Rounded to the step so the value shown is always a clean percent.
    value = math.floor(value / OPACITY_STEP + 0.5) * OPACITY_STEP

    value = tonumber(string.format('%.2f', value))

    return math.max(min, math.min(max, value))
end

-- Settings window (not saved) and how many times the windows were moved
-- back to their default place.
local settings_open = false
local window_reset_count = 0

-- Guide for new adventurers: the window (not saved) and the section that was
-- read last (saved).
local guide_open = false
local guide_section = 1

-- Camps: where to gain experience at each level. The window is not saved; the
-- level, the way of listing them and the filter are.
local camps_open = false
local camps_level = 10
local camps_mode = 'level'
local camps_bracket = 10
local camps_hide_shadow = false
local pins = {}
local last_zone_id = nil
local zone_check_time = 0
local zone_index = nil

-- Help window

local journal_help_visible = false

-- Filters

local hide_complete_missions = false
local hide_complete_quests = false

-- Missions and quests that have not been started are listed too, so they
-- can be read about. They can be hidden to get the list of the game log.
local show_not_started_missions = true
local show_not_started_quests = true

-- Only the repeatable quests in the quest lists (the button with the
-- infinity sign).
local only_repeatable_quests = false

-- Text of the search box in the Journal. It does not filter the lists: with
-- a text the Journal shows the results of searching every mission and every
-- quest (see M.GetSearchResults).
local search_text = ''

-- The letters with an accent of Latin-1 (written in UTF-8 in the files, as
-- the lead byte 195 and a second byte), as the same letter without it, so
-- that "mision" finds "misi" .. "\195\179" .. "n". The key is the code of
-- the letter in Latin-1.
M.search_fold = {
    ['\192'] = 'a', ['\193'] = 'a', ['\194'] = 'a', ['\195'] = 'a',
    ['\196'] = 'a', ['\197'] = 'a', ['\199'] = 'c', ['\200'] = 'e',
    ['\201'] = 'e', ['\202'] = 'e', ['\203'] = 'e', ['\204'] = 'i',
    ['\205'] = 'i', ['\206'] = 'i', ['\207'] = 'i', ['\209'] = 'n',
    ['\210'] = 'o', ['\211'] = 'o', ['\212'] = 'o', ['\213'] = 'o',
    ['\214'] = 'o', ['\217'] = 'u', ['\218'] = 'u', ['\219'] = 'u',
    ['\220'] = 'u', ['\221'] = 'y', ['\224'] = 'a', ['\225'] = 'a',
    ['\226'] = 'a', ['\227'] = 'a', ['\228'] = 'a', ['\229'] = 'a',
    ['\231'] = 'c', ['\232'] = 'e', ['\233'] = 'e', ['\234'] = 'e',
    ['\235'] = 'e', ['\236'] = 'i', ['\237'] = 'i', ['\238'] = 'i',
    ['\239'] = 'i', ['\241'] = 'n', ['\242'] = 'o', ['\243'] = 'o',
    ['\244'] = 'o', ['\245'] = 'o', ['\246'] = 'o', ['\249'] = 'u',
    ['\250'] = 'u', ['\251'] = 'u', ['\252'] = 'u', ['\253'] = 'y',
    ['\255'] = 'y',
}

-- Lower case, without accents or punctuation and with single spaces, so that
-- "curses foiled" finds "Curses, Foiled Again!" and "kos" finds "K.O.'s".
local function normalize_search(text)
    local value = string.lower(tostring(text or ''))

    value = string.gsub(value, '\195([\128-\191])', function(second)
        return M.search_fold[string.char(string.byte(second) + 64)] or ''
    end)
    value = string.gsub(value, '[^%w%s]', '')
    value = string.gsub(value, '%s+', ' ')

    return (string.match(value, '^%s*(.-)%s*$'))
end

-- Settings

local config = settings.load(T{})

local config_save_dirty = false
local config_save_time = 0
local config_save_delay = 0.75

-- Status cache

local mission_status_cache = {}
local quest_status_cache = {}

-- Mission cache

local mission_cache = {}
local mission_cache_area = nil

-- Quest cache

local quest_cache = {}
local quest_cache_category = nil

-- Wait for mission packet bursts to settle.

local MISSION_DIRTY_QUIET_WINDOW = 0.5

-- Helpers

local function tracker_is_ready()
    if tracker.IsReady ~= nil then
        return tracker.IsReady()
    end

    return tracker.IsLoaded()
end

local function get_status_cache_key(area, id)
    return tostring(area) .. '_' .. tostring(id)
end

-- Completed / total per area, so the Journal does not recount every frame.
local progress_cache = {}

local function invalidate_mission_cache()
    mission_cache = {}
    mission_cache_area = nil
    progress_cache = {}
end

local function invalidate_quest_cache()
    quest_cache = {}
    quest_cache_category = nil
    progress_cache = {}
end

local function serialize_step(value)
    if type(value) ~= 'table' then
        return value
    end

    if value.actor_id ~= nil and value.text ~= nil then
        return tostring(value.text)
    end

    local result = T{}

    for key, child in pairs(value) do
        result[key] = serialize_step(child)
    end

    return result
end

local function serialize_steps(steps)
    if type(steps) ~= 'table' then
        return T{}
    end

    local result = T{}

    for index, step in ipairs(steps) do
        result[index] = serialize_step(step)
    end

    return result
end

-- Pinned tracker persistence

local function serialize_pins(list)
    local result = T{}

    for index, entry in ipairs(list) do
        result[index] = T{
            kind = entry.kind,
            id = entry.id,
            name = entry.name,
            steps = serialize_steps(entry.steps),
            step = entry.step,
            auto = entry.auto == true or nil,
        }
    end

    return result
end

local function load_pins(saved)
    local result = {}

    if type(saved) ~= 'table' then
        return result
    end

    for _, entry in ipairs(saved) do
        if type(entry) == 'table'
            and (entry.kind == 'quest' or entry.kind == 'mission')
            and entry.id ~= nil
            and entry.name ~= nil then

            local steps = {}

            if type(entry.steps) == 'table' then
                for _, step in ipairs(entry.steps) do
                    steps[#steps + 1] = tostring(step)
                end
            end

            result[#result + 1] = {
                kind = entry.kind,
                id = tostring(entry.id),
                name = tostring(entry.name),
                steps = steps,
                step = math.max(1, math.floor(tonumber(entry.step) or 1)),
                auto = entry.auto == true or nil,
            }

            if #result >= PIN_MAX then
                break
            end
        end
    end

    return result
end

-- Step checklist.
--
-- The steps the player marks as done, per quest or mission. A mark stores a
-- number made from the text of the step, and it only counts while the step
-- keeps that text: if the objectives of a quest are rewritten, a mark never
-- lands on a different step.

local step_marks = {}

local function step_text_of(step)
    if type(step) == 'table' then
        return tostring(step.text or '')
    end

    return tostring(step or '')
end

local function step_checksum(step)
    local text = step_text_of(step)
    local sum = 7

    for i = 1, #text do
        sum = (sum * 31 + text:byte(i)) % 1000003
    end

    return sum
end

-- Missions of different nations can share an id, so the name is part of
-- the key.
local function marks_key(kind, id, name)
    return tostring(kind):lower()
        .. ':' .. tostring(id)
        .. ':' .. tostring(name or '')
end

-- The marks that are still valid for these steps, and how many there are.
local function get_marks(kind, id, name, steps)
    local stored = step_marks[marks_key(kind, id, name)]
    local result = {}
    local count = 0

    if stored ~= nil then
        for index, sum in pairs(stored) do
            if steps[index] ~= nil
                and step_checksum(steps[index]) == sum then

                result[index] = true
                count = count + 1
            end
        end
    end

    return result, count
end

local function set_mark(kind, id, name, steps, index, done)
    if steps[index] == nil then
        return
    end

    local key = marks_key(kind, id, name)
    local stored = step_marks[key] or {}

    if done then
        stored[index] = step_checksum(steps[index])
    else
        stored[index] = nil
    end

    if next(stored) == nil then
        step_marks[key] = nil
    else
        step_marks[key] = stored
    end
end

-- First step that is not done, or the last one when all of them are.
local function first_undone(kind, id, name, steps)
    local marks = get_marks(kind, id, name, steps)

    for index = 1, #steps do
        if not marks[index] then
            return index
        end
    end

    return math.max(#steps, 1)
end

local function serialize_step_marks()
    local result = T{}

    for key, stored in pairs(step_marks) do
        local list = T{}

        for index, sum in pairs(stored) do
            list[#list + 1] = tostring(index) .. ':' .. tostring(sum)
        end

        table.sort(list)

        if #list > 0 then
            result[key] = list
        end
    end

    return result
end

local function load_step_marks(saved)
    local result = {}

    if type(saved) ~= 'table' then
        return result
    end

    for key, list in pairs(saved) do
        if type(key) == 'string' and type(list) == 'table' then
            local stored = {}

            for _, item in ipairs(list) do
                local index, sum =
                    tostring(item):match('^(%d+):(%d+)$')

                if index ~= nil then
                    stored[tonumber(index)] = tonumber(sum)
                end
            end

            if next(stored) ~= nil then
                result[key] = stored
            end
        end
    end

    return result
end

-- Settings

-- The saved open/closed state of the Journal and of the tracker is only
-- restored the first time real saved data is loaded. The settings library
-- can reload the settings later (for example when the zone changes), and
-- that must never open or close a window by itself.
local saved_visibility_restored = false

-- Position of the saved area in the list. Older versions saved only the
-- position in the old order, so that one is translated.
local function restore_mission_area(key)
    for index, area in ipairs(mission_areas) do
        if area == key then
            return index
        end
    end

    local old = OLD_MISSION_ORDER[mission_area_index]

    for index, area in ipairs(mission_areas) do
        if area == old then
            return index
        end
    end

    return 1
end

-- The look of the alerts is read and written by these two functions, so the
-- functions that read and write the settings stay short.
local function load_alert_styles()
    for group, style in pairs(announce.style) do
        local prefix = 'announce_' .. group .. '_'
        local opacity = tonumber(config[prefix .. 'opacity'])
        local size = tonumber(config[prefix .. 'size'])
        local color = math.floor(tonumber(config[prefix .. 'color']) or 0)

        style.opacity = opacity ~= nil
            and math.max(0.0, math.min(1.0, opacity))
            or 0.70
        style.size = size ~= nil
            and math.max(ALERT_SIZE_MIN, math.min(ALERT_SIZE_MAX, size))
            or 1.0
        style.color = (color >= 0 and color <= #ALERT_PALETTE) and color or 0
    end
end

local function save_alert_styles()
    for group, style in pairs(announce.style) do
        local prefix = 'announce_' .. group .. '_'

        config[prefix .. 'opacity'] = style.opacity
        config[prefix .. 'size'] = style.size
        config[prefix .. 'color'] = style.color
    end
end

-- The second half of apply_config. It is a function of its own because
-- LuaJIT allows only 60 upvalues in one function.
local function apply_config_part_two()
    journal_opacity =
        clamp_opacity(config.journal_opacity, OPACITY_MIN, OPACITY_MAX, 1.0)
    pin_opacity =
        clamp_opacity(config.pin_opacity, OPACITY_MIN, OPACITY_MAX, 1.0)
    journal_text_scale =
        clamp_opacity(config.journal_text_scale, TEXT_SCALE_MIN, TEXT_SCALE_MAX, 1.0)
    pin_background =
        clamp_opacity(config.pin_background, 0.0, BACKGROUND_MAX, 0.0)
    language = config.language == 'es' and 'es' or 'en'
    i18n.set_language(language)
    pins = load_pins(config.pins)
    step_marks = load_step_marks(config.step_marks)
    M.personal.Load(config.notes, config.favorites, config.favorite_filters)
    M.compass.Load(config.compass)

    -- Size of the Settings window, kept between sessions.
    local saved_win = config.settings_win

    if type(saved_win) == 'table'
        and tonumber(saved_win.w) ~= nil
        and tonumber(saved_win.h) ~= nil then

        M.settings_win = {
            w = math.max(300, math.min(2400, tonumber(saved_win.w))),
            h = math.max(200, math.min(2400, tonumber(saved_win.h))),
        }
    else
        M.settings_win = nil
    end

    -- Size of the Fame window, kept between sessions.
    local saved_fame_win = config.fame_win

    if type(saved_fame_win) == 'table'
        and tonumber(saved_fame_win.w) ~= nil
        and tonumber(saved_fame_win.h) ~= nil then

        M.fame_win = {
            w = math.max(300, math.min(2400, tonumber(saved_fame_win.w))),
            h = math.max(200, math.min(2400, tonumber(saved_fame_win.h))),
        }
    else
        M.fame_win = nil
    end

    -- Fame levels read from the Fame Checker NPCs.
    local saved_fame = config.fame_levels

    M.fame_levels = {}

    if type(saved_fame) == 'table' then
        for _, area in ipairs(require('fame').AREAS) do
            local key = area.key
            local entry = saved_fame[key]

            if type(entry) == 'table'
                and tonumber(entry.level) ~= nil
                and tonumber(entry.level) >= 1
                and tonumber(entry.level) <= 9 then

                M.fame_levels[key] = {
                    level = math.floor(tonumber(entry.level)),
                    time = tonumber(entry.time) or 0,
                }
            end
        end
    end

    -- Pins made before the checklist existed: the steps before the current
    -- one count as done.
    for _, entry in ipairs(pins) do
        if entry.step > 1
            and step_marks[marks_key(entry.kind, entry.id, entry.name)]
                == nil then

            for index = 1, math.min(entry.step - 1, #entry.steps) do
                set_mark(
                    entry.kind,
                    entry.id,
                    entry.name,
                    entry.steps,
                    index,
                    true
                )
            end
        end
    end

    if not saved_visibility_restored
        and config.journal_width ~= nil then

        saved_visibility_restored = true

        journal_visible = config.journal_open == true
        pin_visible = config.pin_open == true
    end

    hide_complete_missions = config.hide_complete_missions == true
    hide_complete_quests = config.hide_complete_quests == true

    -- Shown unless the setting was explicitly turned off.
    show_not_started_missions = config.show_not_started_missions ~= false
    show_not_started_quests = config.show_not_started_quests ~= false
    only_repeatable_quests = config.only_repeatable_quests == true

    mission_status_cache = config.mission_status or {}
    quest_status_cache = config.quest_status or {}
end

local function apply_config()
    if config == nil then
        return
    end

    journal_mode = tonumber(config.journal_mode) or 1
    mission_area_index = tonumber(config.journal_area) or 1
    mission_area_index = restore_mission_area(config.journal_area_key)
    mission_index = tonumber(config.journal_index) or 1
    quest_category_index = tonumber(config.journal_quest_category) or 1
    quest_index = tonumber(config.journal_quest_index) or 1
    all_view.missions = config.journal_all_missions == true
    all_view.quests = config.journal_all_quests == true
    announce.enabled = config.announce_enabled ~= false
    announce.sound = config.announce_sound ~= false
    announce.ask = config.announce_ask ~= false
    announce.near = config.announce_near ~= false
    announce.prox = config.announce_prox ~= false
    announce.prox_compass = config.announce_prox_compass ~= false
    announce.world_mark = config.world_mark == true
    announce.world_mark_all = config.world_mark_all ~= false
    announce.world_mark_edge = config.world_mark_edge ~= false
    announce.world_mark_active = config.world_mark_active ~= false
    M.worldmark.SetCapture(announce.world_mark)
    load_alert_styles()

    journal_width = tonumber(config.journal_width) or 2000
    journal_height = tonumber(config.journal_height) or 1600
    journal_x = config.journal_x
    journal_y = config.journal_y

    journal_mini = config.journal_mini == true
    journal_mini_button = config.journal_mini_button == true
    journal_mini_x = config.journal_mini_x
    journal_mini_y = config.journal_mini_y

    pin_x = config.pin_x
    pin_y = config.pin_y
    pin_mode = config.pin_mode == 'tabs' and 'tabs' or 'stacked'
    pin_active = tonumber(config.pin_active) or 1
    pin_auto_zone = config.pin_auto_zone == true
    pin_scale = clamp_pin_scale(config.pin_scale)
    pin_show_next = config.pin_show_next ~= false
    auto_pin_quests = config.auto_pin_quests == true
    guide_section = math.max(1, math.floor(tonumber(config.guide_section) or 1))
    camps_level = math.max(1, math.min(75, math.floor(tonumber(config.camps_level) or 10)))
    camps_mode = config.camps_mode == 'bracket' and 'bracket' or 'level'
    camps_bracket = math.max(10, math.min(70, math.floor(tonumber(config.camps_bracket) or 10)))
    camps_hide_shadow = config.camps_hide_shadow == true
    auto_pin_dismissed = {}

    if type(config.auto_pin_dismissed) == 'table' then
        for _, id in ipairs(config.auto_pin_dismissed) do
            auto_pin_dismissed[tostring(id)] = true
        end
    end

    apply_config_part_two()
end

local function update_config_values()
    config.journal_mode = journal_mode
    config.journal_area = mission_area_index
    config.journal_area_key = mission_areas[mission_area_index]
    config.journal_index = mission_index
    config.journal_quest_category = quest_category_index
    config.journal_quest_index = quest_index
    config.journal_all_missions = all_view.missions
    config.journal_all_quests = all_view.quests
    config.announce_enabled = announce.enabled
    config.announce_sound = announce.sound
    config.announce_ask = announce.ask
    config.announce_near = announce.near
    config.announce_prox = announce.prox
    config.announce_prox_compass = announce.prox_compass
    config.world_mark = announce.world_mark
    config.world_mark_all = announce.world_mark_all
    config.world_mark_edge = announce.world_mark_edge
    config.world_mark_active = announce.world_mark_active
    save_alert_styles()

    config.journal_width = journal_width
    config.journal_height = journal_height
    config.journal_open = journal_visible
    config.journal_x = journal_x
    config.journal_y = journal_y

    config.journal_mini = journal_mini
    config.journal_mini_button = journal_mini_button
    config.journal_mini_x = journal_mini_x
    config.journal_mini_y = journal_mini_y

    config.pin_open = pin_visible
    config.pin_x = pin_x
    config.pin_y = pin_y
    config.pin_mode = pin_mode
    config.pin_active = pin_active
    config.pin_auto_zone = pin_auto_zone
    config.pin_scale = pin_scale
    config.pin_show_next = pin_show_next
    config.auto_pin_quests = auto_pin_quests
    config.guide_section = guide_section
    config.camps_level = camps_level
    config.camps_mode = camps_mode
    config.camps_bracket = camps_bracket
    config.camps_hide_shadow = camps_hide_shadow

    local dismissed = T{}

    for id in pairs(auto_pin_dismissed) do
        dismissed[#dismissed + 1] = id
    end

    table.sort(dismissed)
    config.auto_pin_dismissed = dismissed
    config.journal_opacity = journal_opacity
    config.pin_opacity = pin_opacity
    config.journal_text_scale = journal_text_scale
    config.pin_background = pin_background
    config.language = language
    config.pins = serialize_pins(pins)
    config.step_marks = serialize_step_marks()
    config.notes, config.favorites, config.favorite_filters =
        M.personal.Serialize()
    config.compass = M.compass.Serialize()
    config.settings_win = M.settings_win
    config.fame_win = M.fame_win
    config.fame_levels = M.fame_levels

    -- The Mission Log and the Quest Log were removed in 0.1.13. Their
    -- old settings are dropped from the saved file.
    for _, key in ipairs({
        'mission_width', 'mission_height', 'mission_open',
        'mission_x', 'mission_y', 'mission_id', 'mission_name',
        'mission_steps', 'quest_width', 'quest_height',
        'quest_open', 'quest_x', 'quest_y', 'quest_id',
        'quest_name', 'quest_steps', 'log_text_scale',
    }) do
        config[key] = nil
    end

    config.hide_complete_missions = hide_complete_missions
    config.hide_complete_quests = hide_complete_quests
    config.show_not_started_missions = show_not_started_missions
    config.show_not_started_quests = show_not_started_quests
    config.only_repeatable_quests = only_repeatable_quests
    config.mission_status = mission_status_cache
    config.quest_status = quest_status_cache
end

local function save_config()
    update_config_values()
    return settings.save()
end

local function request_config_save()
    config_save_dirty = true
    config_save_time = os.clock()
end

local function update_config_save()
    if not config_save_dirty then
        return
    end

    if os.clock() - config_save_time < config_save_delay then
        return
    end

    if save_config() then
        config_save_dirty = false
    end
end

-- Status sync

local function sync_mission_status_cache()
    if not tracker_is_ready() then
        return false
    end

    local changed = false

    for _, area in ipairs(mission_areas) do
        for _, mission in ipairs(tracker.GetMissionArea(area) or {}) do
            local key = get_status_cache_key(area, mission.id)
            local status = mission.status or 'not_started'

            if mission_status_cache[key] ~= status then
                mission_status_cache[key] = status
                changed = true
            end
        end
    end

    if changed then
        invalidate_mission_cache()
        request_config_save()
    end

    return changed
end

local function sync_quest_status_cache()
    if not tracker_is_ready() then
        return false
    end

    local categories = get_quest_categories()

    if #categories == 0 then
        return false
    end

    local category = categories[quest_category_index]

    if category == nil then
        return false
    end

    -- With "All" every category is kept up to date, not only one.
    local quests_to_sync = {}

    if all_view.quests then
        for _, each in ipairs(categories) do
            for _, quest in ipairs(get_quest_list_from_tracker(each)) do
                quests_to_sync[#quests_to_sync + 1] = quest
            end
        end
    else
        quests_to_sync = get_quest_list_from_tracker(category)
    end

    local changed = false

    for _, quest in ipairs(quests_to_sync) do
        local tracker_area = quest.tracker_area
        local tracker_id = quest.tracker_id

        if quest.trackable ~= false
            and tracker_area ~= nil
            and tracker_id ~= nil then

            local key =
                get_status_cache_key(
                    tracker_area,
                    tracker_id
                )

            local status =
                quest.status or 'not_started'

            local cached =
                quest_status_cache[key]

            if status == 'completed' then
                if cached ~= 'completed' then
                    quest_status_cache[key] =
                        'completed'

                    changed = true
                end

            elseif status == 'active' then
                if cached ~= 'active' then
                    quest_status_cache[key] =
                        'active'

                    changed = true
                end

            elseif cached == nil then
                quest_status_cache[key] =
                    'not_started'

                changed = true
            end
        end
    end

    if changed then
        invalidate_quest_cache()
        request_config_save()
    end

    return changed
end

local function apply_cached_statuses(
    area,
    missions_list
)
    for _, mission in ipairs(
        missions_list or {}
    ) do
        local key =
            get_status_cache_key(
                area,
                mission.id
            )

        mission.status =
            mission_status_cache[key]
            or mission.status
            or 'not_started'
    end

    return missions_list or {}
end

local function apply_cached_quest_statuses(
    category,
    quests_list
)
    for _, quest in ipairs(
        quests_list or {}
    ) do
        if quest.trackable ~= false
            and quest.tracker_area ~= nil
            and quest.tracker_id ~= nil then

            local key =
                get_status_cache_key(
                    quest.tracker_area,
                    quest.tracker_id
                )

            quest.status =
                quest_status_cache[key]
                or quest.status
                or 'not_started'
        end
    end

    return quests_list or {}
end

-- The active quests, in the order of the Journal. A quest is active when
-- the game reports it active now, or when it was saved as active in an
-- earlier session and it is not completed. The status the game reports is
-- read straight from the tracker: the lists of the tracker are overwritten
-- with the saved statuses when the Journal draws them.
local function get_active_quests()
    local result = {}

    if not tracker_is_ready() then
        return result
    end

    for _, category in ipairs(get_quest_categories()) do
        for _, quest in ipairs(get_quest_list_from_tracker(category)) do
            if quest.id ~= nil
                and quest.trackable ~= false
                and quest.tracker_area ~= nil
                and quest.tracker_id ~= nil then

                local cached =
                    quest_status_cache[
                        get_status_cache_key(
                            quest.tracker_area,
                            quest.tracker_id
                        )
                    ]

                local live =
                    tracker.GetQuestStatus ~= nil
                    and tracker.GetQuestStatus(
                        quest.tracker_area,
                        quest.tracker_id
                    )
                    or nil

                if live ~= 'completed'
                    and cached ~= 'completed'
                    and (live == 'active' or cached == 'active') then

                    result[#result + 1] = quest
                end
            end
        end
    end

    return result
end

-- Progress: how many entries of an area are completed.

-- A mission hidden by the tracker (not part of the line the player can
-- reach) does not count. A quest without tracking data counts as not done.
local function count_completed(list)
    local done = 0
    local total = 0

    for _, item in ipairs(list or {}) do
        local status = item.status or 'not_started'

        if status ~= 'hidden' then
            total = total + 1

            if status == 'completed' then
                done = done + 1
            end
        end
    end

    return done, total
end

local function get_progress(kind, area)
    local key = kind .. ':' .. tostring(area)
    local cached = progress_cache[key]

    if cached == nil then
        local list

        if kind == 'm' then
            list = apply_cached_statuses(
                area,
                tracker.GetMissionArea(area)
            )
        else
            list = apply_cached_quest_statuses(
                area,
                get_quest_list_from_tracker(area)
            )
        end

        local done, total = count_completed(list)

        cached = { done, total }
        progress_cache[key] = cached
    end

    return cached[1], cached[2]
end

-- Links between quests.
--
-- The prereq of a quest is free text. The quest names found in it become
-- links, and the quests that name this one in their own prereq become its
-- "next" list. Text that is not a quest name (for example a mission) stays
-- plain text.

local quest_link_index = nil
local quest_history = {}
local quest_jump_in_progress = false
local QUEST_HISTORY_MAX = 20
local QUEST_NEXT_MAX = 6

local function is_word_char(char)
    return char ~= '' and char:match('%w') ~= nil
end

-- Returns the quests named in a text in the order they appear, and true
-- when some text is left once those names are removed.
local function find_quests_in_text(text, names)
    local lowered = tostring(text or ''):lower()
    local found = {}

    for _, entry in ipairs(names) do
        local start = 1

        while true do
            local s, e = lowered:find(entry.lower, start, true)

            if s == nil then
                break
            end

            local before = s > 1 and lowered:sub(s - 1, s - 1) or ''
            local after = lowered:sub(e + 1, e + 1)

            if not is_word_char(before)
                and not is_word_char(after) then

                found[#found + 1] = { pos = s, id = entry.id }

                -- Mask the match so that a shorter name inside it is not
                -- found again.
                lowered =
                    lowered:sub(1, s - 1)
                    .. string.rep('\1', e - s + 1)
                    .. lowered:sub(e + 1)

                start = e + 1
            else
                start = s + 1
            end
        end
    end

    table.sort(found, function(a, b)
        return a.pos < b.pos
    end)

    local rest = lowered:gsub('%c', ' ')
    rest = rest:gsub('[%s/,;&%(%)%-]+', ' ')

    return found, rest:match('%a') ~= nil
end

local function build_quest_link_index()
    if quest_link_index ~= nil then
        return quest_link_index
    end

    if not tracker_is_ready() then
        return nil
    end

    local index = {
        by_id = {},
        names = {},
        prereq = {},
        next = {},
        by_name = {},
    }

    for category_index, category in ipairs(get_quest_categories()) do
        for _, quest in ipairs(get_quest_list_from_tracker(category)) do
            if quest.id ~= nil and quest.name ~= nil then
                local first = type(quest.steps) == 'table' and quest.steps[1] or nil

                if type(first) == 'table' then
                    first = first.text
                end

                index.by_id[quest.id] = {
                    step1 = type(first) == 'string' and first or nil,
                    id = quest.id,
                    name = tostring(quest.name),
                    category = category,
                    category_index = category_index,
                    prereq = quest.prereq,
                    npc = quest.npc,
                    area = quest.area,
                    fame_area = quest.fame_area,
                    req = quest.req,
                    tracker_area = quest.tracker_area,
                    tracker_id = quest.tracker_id,
                    repeatable = quest.repeatable == true,
                }

                index.names[#index.names + 1] = {
                    id = quest.id,
                    lower = tostring(quest.name):lower(),
                    length = #tostring(quest.name),
                }

                index.by_name[tostring(quest.name):lower()] = quest.id
            end
        end
    end

    -- Longer names first, so "Gifts of the Griffon" wins over a shorter
    -- name that is part of it.
    table.sort(index.names, function(a, b)
        return a.length > b.length
    end)

    for id, info in pairs(index.by_id) do
        if info.prereq ~= nil and info.prereq ~= '' then
            local found, rest =
                find_quests_in_text(info.prereq, index.names)

            index.prereq[id] = { found = found, rest = rest }

            for _, link in ipairs(found) do
                local list = index.next[link.id] or {}

                list[#list + 1] = id
                index.next[link.id] = list
            end
        end
    end

    for _, list in pairs(index.next) do
        table.sort(list, function(a, b)
            return index.by_id[a].name < index.by_id[b].name
        end)
    end

    quest_link_index = index

    return index
end

-- Status of every quest of a category, cached with the progress counters.
local function get_quest_status_map(category)
    local key = 's:' .. tostring(category)
    local map = progress_cache[key]

    if map == nil then
        map = {}

        for _, quest in ipairs(
            apply_cached_quest_statuses(
                category,
                get_quest_list_from_tracker(category)
            )
        ) do
            map[quest.id] = quest.status or 'not_started'
        end

        progress_cache[key] = map
    end

    return map
end

local function describe_quest_link(index, id)
    local info = index.by_id[id]
    local status = get_quest_status_map(info.category)[id]

    return {
        id = id,
        name = info.name,
        status = status or 'not_started',
    }
end

-- The quests named by the prereq of a quest, the quests that come next in
-- the chain, and whether the prereq has text that is not a quest.
function M.GetQuestLinks(id)
    local index = build_quest_link_index()

    if index == nil or index.by_id[id] == nil then
        return nil
    end

    local result = {
        prereq = {},
        has_other_text = false,
        next = {},
        more = 0,
    }

    local prereq = index.prereq[id]

    if prereq ~= nil then
        result.has_other_text = prereq.rest

        for _, link in ipairs(prereq.found) do
            result.prereq[#result.prereq + 1] =
                describe_quest_link(index, link.id)
        end
    end

    local following = index.next[id] or {}

    for i, next_id in ipairs(following) do
        if i > QUEST_NEXT_MAX then
            result.more = #following - QUEST_NEXT_MAX
            break
        end

        result.next[#result.next + 1] =
            describe_quest_link(index, next_id)
    end

    return result
end

-- Opens a quest in the Journal. Whatever hides it (hiding the completed
-- quests, hiding the ones not started) is turned off first. The text of the
-- search is cleared, unless keep_search (a result of the search).
local function select_quest(id, keep_search)
    local index = build_quest_link_index()
    local info = index and index.by_id[id]

    if info == nil then
        return false
    end

    quest_jump_in_progress = true

    M.SetJournalMode(2)

    if search_text ~= '' and not keep_search then
        M.SetSearchText('')
    end

    local status = get_quest_status_map(info.category)[id]

    if only_repeatable_quests and not info.repeatable then
        M.SetOnlyRepeatableQuests(false)
    end

    if M.personal.GetOnlyFavorites('quest')
        and not M.personal.IsFavorite('quest', id, info.name) then

        M.SetOnlyFavorites('quest', false)
    end

    if status == 'completed' and hide_complete_quests then
        M.SetHideCompleteQuests(false)
    elseif status == 'not_started' and not show_not_started_quests then
        M.SetShowNotStartedQuests(true)
    end

    -- The selector index: 1 is "All". A jump made from "All" stays there.
    local target = all_view.quests and 1 or (info.category_index + 1)

    M.SetQuestSelection(target, 1)

    local found = false

    for position, quest in ipairs(M.GetQuestList()) do
        if quest.id == id then
            M.SetQuestSelection(target, position)
            found = true
            break
        end
    end

    quest_jump_in_progress = false

    return found
end

function M.JumpToQuest(id, keep_search)
    local previous = nil

    if journal_mode == 2 then
        local current = M.GetSelectedQuest()

        previous = current and current.id
    end

    if not select_quest(id, keep_search) then
        return false
    end

    if previous ~= nil and previous ~= id then
        quest_history[#quest_history + 1] = previous

        if #quest_history > QUEST_HISTORY_MAX then
            table.remove(quest_history, 1)
        end
    end

    return true
end

-- The quest the "Back" link returns to, or nil.
function M.GetQuestBack()
    local id = quest_history[#quest_history]
    local index = build_quest_link_index()

    if id == nil or index == nil or index.by_id[id] == nil then
        return nil
    end

    return { id = id, name = index.by_id[id].name }
end

function M.JumpBack()
    local id = quest_history[#quest_history]

    if id == nil then
        return false
    end

    quest_history[#quest_history] = nil

    return select_quest(id)
end

-- The id of the quest with this name, or nil.
function M.GetQuestIdByName(name)
    local index = build_quest_link_index()

    if index == nil then
        return nil
    end

    return index.by_name[tostring(name or ''):lower()]
end

-- The quests whose name appears in a text (for the links of the guide), in
-- the order they appear.
function M.GetTextQuestLinks(text)
    local index = build_quest_link_index()
    local result = {}

    if index == nil then
        return result
    end

    local found = find_quests_in_text(text, index.names)
    local seen = {}

    for _, link in ipairs(found) do
        if not seen[link.id] then
            seen[link.id] = true
            result[#result + 1] = describe_quest_link(index, link.id)
        end
    end

    return result
end

-- Guide for new adventurers. A chapter that has no text of its own (it only
-- holds parts) opens its first part.
local guide_data = nil

function M.GetGuide()
    if guide_data == nil then
        local ok, result = pcall(require, 'data.guide')

        guide_data = ok and type(result) == 'table' and result or false
    end

    return guide_data or nil
end

function M.GetGuideOpen()
    return guide_open
end

function M.SetGuideOpen(value)
    guide_open = value == true
end

function M.ToggleGuide()
    guide_open = not guide_open
end

function M.GetGuideSection()
    local guide = M.GetGuide()

    if guide == nil then
        return 1
    end

    return math.max(1, math.min(guide_section, #guide.sections))
end

function M.SetGuideSection(index)
    local guide = M.GetGuide()

    if guide == nil then
        return
    end

    index = math.max(1, math.min(math.floor(tonumber(index) or 1), #guide.sections))

    local section = guide.sections[index]
    local following = guide.sections[index + 1]

    if section ~= nil
        and #section.blocks == 0
        and following ~= nil
        and following.level > section.level then

        index = index + 1
    end

    if index ~= guide_section then
        guide_section = index
        request_config_save()
    end
end

-- Camps ---------------------------------------------------------------------

local camps_data = nil

function M.GetCamps()
    if camps_data == nil then
        local ok, result = pcall(require, 'data.camps')

        camps_data = ok and type(result) == 'table' and result or false
    end

    return camps_data or nil
end

-- The main job level of the character, or nil when the game does not give it.
function M.GetPlayerLevel()
    local ok, level = pcall(function()
        return AshitaCore:GetMemoryManager():GetPlayer():GetMainJobLevel()
    end)

    if ok and type(level) == 'number' and level >= 1 and level <= 99 then
        return level
    end

    return nil
end

-- The level range (10, 20 ... 70) of the table a level belongs to.
local function camps_bracket_of(level)
    return math.max(10, math.min(70, math.floor(level / 10) * 10))
end

function M.GetCampsOpen()
    return camps_open
end

-- When the window opens, the level is the one of the character.
function M.SetCampsOpen(value)
    value = value == true

    if value and not camps_open then
        local level = M.GetPlayerLevel()

        if level ~= nil then
            camps_level = math.min(level, 75)
            camps_bracket = camps_bracket_of(camps_level)
            request_config_save()
        end
    end

    camps_open = value
end

function M.ToggleCamps()
    M.SetCampsOpen(not camps_open)
end

function M.GetCampsLevel()
    return camps_level
end

function M.SetCampsLevel(value)
    local level = math.max(1, math.min(75, math.floor(tonumber(value) or camps_level)))

    if level ~= camps_level then
        camps_level = level
        camps_bracket = camps_bracket_of(level)
        request_config_save()
    end
end

function M.AdjustCampsLevel(direction)
    M.SetCampsLevel(camps_level + direction)
end

-- Uses the level of the character. False when the game does not give it.
function M.UseGameLevelForCamps()
    local level = M.GetPlayerLevel()

    if level == nil then
        return false
    end

    M.SetCampsLevel(math.min(level, 75))

    return true
end

function M.GetCampsMode()
    return camps_mode
end

function M.SetCampsMode(mode)
    mode = mode == 'bracket' and 'bracket' or 'level'

    if mode ~= camps_mode then
        camps_mode = mode
        request_config_save()
    end
end

function M.GetCampsBracket()
    return camps_bracket
end

function M.SetCampsBracket(value)
    local bracket = camps_bracket_of(tonumber(value) or camps_bracket)

    if bracket ~= camps_bracket then
        camps_bracket = bracket
        request_config_save()
    end
end

function M.GetCampsHideShadow()
    return camps_hide_shadow
end

function M.SetCampsHideShadow(value)
    value = value == true

    if value ~= camps_hide_shadow then
        camps_hide_shadow = value
        request_config_save()
    end
end

-- The camps to show. In the mode "level" they are the camps of every range
-- that are good for the level, in the order of the table. In the mode
-- "bracket" they are all the camps of the range, and match tells the ones that
-- are good for the level. Each list has entries {camp = row, match = bool}.
function M.GetCampsView()
    local data = M.GetCamps()
    local view = { standard = {}, alternate = {}, level = camps_level }

    if data == nil then
        return view
    end

    for _, bracket in ipairs(data.brackets) do
        local in_view = camps_mode == 'level' or bracket.level == camps_bracket

        if in_view then
            for _, kind in ipairs({ 'standard', 'alternate' }) do
                for _, camp in ipairs(bracket[kind]) do
                    local match = camp.from <= camps_level and camps_level <= camp.to
                    local shadow = camp.area:find('%(S%)') ~= nil

                    if (camps_mode ~= 'level' or match)
                        and not (camps_hide_shadow and shadow) then

                        view[kind][#view[kind] + 1] = {
                            camp = camp,
                            match = match,
                        }
                    end
                end
            end
        end
    end

    return view
end

-- The levels of the ranges of the table (10, 20 ... 70).
function M.GetCampsBrackets()
    local data = M.GetCamps()
    local result = {}

    if data ~= nil then
        for _, bracket in ipairs(data.brackets) do
            result[#result + 1] = bracket.level
        end
    end

    return result
end

-- Opens a section of the guide for new adventurers (by its id).
function M.OpenGuideSection(id)
    local guide = M.GetGuide()

    if guide == nil then
        return false
    end

    for index, section in ipairs(guide.sections) do
        if section.id == id then
            M.SetGuideSection(index)
            guide_open = true

            return true
        end
    end

    return false
end

-- Validation

local function validate_state()
    if journal_mode ~= 1
        and journal_mode ~= 2 then

        journal_mode = 1
    end

    if mission_area_index < 1
        or mission_area_index > #mission_areas then

        mission_area_index = 1
    end

    if mission_index < 1 then
        mission_index = 1
    end

    local categories =
        get_quest_categories()

    if #categories > 0 then
        if quest_category_index < 1
            or quest_category_index > #categories then

            quest_category_index = 1
        end
    else
        quest_category_index = 1
    end

    if quest_index < 1 then
        quest_index = 1
    end
end

-- Puts the active entries first and keeps the order of the rest.
local function active_first(list)
    local active = {}
    local others = {}

    for _, item in ipairs(list) do
        if (item.status or 'not_started') == 'active' then
            active[#active + 1] = item
        else
            others[#others + 1] = item
        end
    end

    for _, item in ipairs(others) do
        active[#active + 1] = item
    end

    return active
end

-- Mission cache

local function rebuild_mission_cache()
    local areas

    if all_view.missions then
        areas = mission_areas
    else
        local area = mission_areas[mission_area_index]

        if area == nil then
            mission_area_index = 1
            area = mission_areas[1]
        end

        areas = { area }
    end

    mission_cache = {}

    for _, area in ipairs(areas) do
        local mission_list =
            apply_cached_statuses(
                area,
                tracker.GetMissionArea(area)
            )

        local first_mission

        for _, mission in ipairs(mission_list) do
            if mission.status ~= 'hidden' then
                first_mission = mission
                break
            end
        end

        for _, mission in ipairs(mission_list) do
            local status = mission.status or 'not_started'
            local show = false

            local guide = MISSION_GUIDE[area]

            if guide ~= nil then
                mission.code = guide.from_data
                    and mission.number
                    or (guide.numbers and guide.numbers[mission.id])
                mission.finale = mission.id == guide.finale_id or nil
            end

            if mission == first_mission then
                show =
                    status ~= 'completed'
                    or not hide_complete_missions

            elseif status == 'active' then
                show = true

            elseif status == 'completed'
                and not hide_complete_missions then

                show = true

            elseif status == 'not_started'
                and show_not_started_missions then

                show = true
            end

            -- Only the favorites (even the first mission of the area).
            if show
                and M.personal.GetOnlyFavorites('mission')
                and not M.personal.IsFavorite('mission', mission.id, mission.name) then

                show = false
            end

            if show then
                mission_cache[#mission_cache + 1] = mission
            end
        end
    end

    -- The active missions go first.
    mission_cache = active_first(mission_cache)

    mission_cache_area = all_view.missions and 'all' or areas[1]

    if #mission_cache == 0 then
        mission_index = 1
    else
        mission_index =
            math.max(
                1,
                math.min(
                    mission_index,
                    #mission_cache
                )
            )
    end
end

local function get_visible_missions()
    local area =
        all_view.missions and 'all'
        or mission_areas[mission_area_index]

    if mission_cache_area ~= area then
        rebuild_mission_cache()
    end

    return mission_cache
end

-- Quest cache

-- Subzones of a category. The zone of a quest is a field of the data; the
-- quests with no clear zone go to "Other", at the end of the list.
local QUEST_OTHER_ZONE = 'Other'
local QUEST_UNCLEAR_ZONES = {
    ['multi-nation'] = true,
    ['other locations'] = true,
    ['mog house'] = true,
}

local function quest_zone_label(quest)
    local zone = tostring(quest.zone or '')
    local key = zone:lower()

    if zone == '' or QUEST_UNCLEAR_ZONES[key] then
        return QUEST_OTHER_ZONE
    end

    return zone
end

-- Zones of a category, in the order the data lists them.
local function list_category_zones(category)
    local zones = {}
    local seen = {}
    local has_other = false

    for _, quest in ipairs(get_quest_list_from_tracker(category)) do
        local label = quest_zone_label(quest)

        if label == QUEST_OTHER_ZONE then
            has_other = true
        elseif not seen[label] then
            seen[label] = true
            zones[#zones + 1] = label
        end
    end

    if has_other then
        zones[#zones + 1] = QUEST_OTHER_ZONE
    end

    return zones
end

local function rebuild_quest_cache()
    local categories =
        get_quest_categories()

    local category =
        categories[quest_category_index]

    local lists

    if all_view.quests and #categories > 0 then
        lists = categories
    elseif category == nil then
        invalidate_quest_cache()
        quest_index = 1
        return
    else
        lists = { category }
    end

    quest_cache = {}

    for _, each in ipairs(lists) do
        local quests_list =
            apply_cached_quest_statuses(
                each,
                get_quest_list_from_tracker(each)
            )

        for _, quest in ipairs(quests_list) do
            local status =
                quest.status
                or 'not_started'

            if (
                status == 'active'
                or (
                    status == 'completed'
                    and not hide_complete_quests
                )
                or (
                    status == 'not_started'
                    and show_not_started_quests
                )
            ) and (
                    not only_repeatable_quests
                    or quest.repeatable == true
                )
                and (
                    not M.personal.GetOnlyFavorites('quest')
                    or M.personal.IsFavorite('quest', quest.id, quest.name)
                ) then

                quest_cache[
                    #quest_cache + 1
                ] = quest
            end
        end
    end

    -- The quests are grouped by zone (in the order of the data, "Other"
    -- last), one category after another, and the active ones go first
    -- inside each group. The groups are kept for the titles of the list.
    local buckets = {}

    for _, quest in ipairs(quest_cache) do
        local key = tostring(quest.category) .. '|' .. quest_zone_label(quest)

        buckets[key] = buckets[key] or {}
        buckets[key][#buckets[key] + 1] = quest
    end

    quest_cache = {}
    all_view.groups = {}

    for _, each in ipairs(lists) do
        for _, zone in ipairs(list_category_zones(each)) do
            local bucket = buckets[tostring(each) .. '|' .. zone]

            if bucket ~= nil then
                all_view.groups[#all_view.groups + 1] = {
                    index = #quest_cache + 1,
                    zone = zone,
                }

                for _, quest in ipairs(active_first(bucket)) do
                    quest_cache[#quest_cache + 1] = quest
                end
            end
        end
    end

    quest_cache_category =
        (all_view.quests and #categories > 0) and 'all' or category

    if #quest_cache == 0 then
        quest_index = 1
    else
        quest_index =
            math.max(
                1,
                math.min(
                    quest_index,
                    #quest_cache
                )
            )
    end
end

local function get_visible_quests()
    local categories =
        get_quest_categories()

    local category =
        (all_view.quests and #categories > 0) and 'all'
        or categories[quest_category_index]

    if quest_cache_category ~= category then
        rebuild_quest_cache()
    end

    return quest_cache
end

-- Filter API

function M.GetHideCompleteMissions()
    return hide_complete_missions
end

function M.SetHideCompleteMissions(value)
    value = value == true

    if hide_complete_missions == value then
        return
    end

    hide_complete_missions = value
    mission_index = 1

    invalidate_mission_cache()
    request_config_save()
end

function M.GetSearchText()
    return search_text
end

-- Sets the search text. The lists do not change: the results are asked for
-- with M.GetSearchResults.
function M.SetSearchText(text)
    search_text = normalize_search(text)
end

function M.GetHideCompleteQuests()
    return hide_complete_quests
end

function M.SetHideCompleteQuests(value)
    value = value == true

    if hide_complete_quests == value then
        return
    end

    hide_complete_quests = value
    quest_index = 1

    invalidate_quest_cache()
    request_config_save()
end

function M.GetShowNotStartedMissions()
    return show_not_started_missions
end

function M.SetShowNotStartedMissions(value)
    value = value == true

    if show_not_started_missions == value then
        return
    end

    show_not_started_missions = value
    mission_index = 1

    invalidate_mission_cache()
    request_config_save()
end

function M.GetShowNotStartedQuests()
    return show_not_started_quests
end

function M.SetShowNotStartedQuests(value)
    value = value == true

    if show_not_started_quests == value then
        return
    end

    show_not_started_quests = value
    quest_index = 1

    invalidate_quest_cache()
    request_config_save()
end

function M.GetOnlyRepeatableQuests()
    return only_repeatable_quests
end

function M.SetOnlyRepeatableQuests(value)
    value = value == true

    if only_repeatable_quests == value then
        return
    end

    only_repeatable_quests = value
    quest_index = 1

    invalidate_quest_cache()
    request_config_save()
end

function M.ToggleOnlyRepeatableQuests()
    M.SetOnlyRepeatableQuests(not only_repeatable_quests)
end

-- Mission API

-- The selector of areas: "All" first, then the areas.
local mission_areas_view = { 'all' }

for _, area in ipairs(mission_areas) do
    mission_areas_view[#mission_areas_view + 1] = area
end

function M.GetMissionAreas()
    return mission_areas_view
end

-- Completed and total missions of an area.
function M.GetMissionProgress(area)
    if not tracker_is_ready() then
        return 0, 0
    end

    if area == 'all' then
        return M.GetTotalProgress(true)
    end

    return get_progress('m', area)
end

-- Completed and total quests of a category.
function M.GetQuestProgress(category)
    if not tracker_is_ready() then
        return 0, 0
    end

    if category == 'all' then
        return M.GetTotalProgress(false)
    end

    return get_progress('q', category)
end

-- Completed and total of every area of the mission or quest journal.
function M.GetTotalProgress(is_mission_mode)
    if not tracker_is_ready() then
        return 0, 0
    end

    local done = 0
    local total = 0

    local list = is_mission_mode
        and mission_areas
        or get_quest_categories()

    for _, area in ipairs(list) do
        local d, t

        if is_mission_mode then
            d, t = get_progress('m', area)
        else
            d, t = get_progress('q', area)
        end

        done = done + d
        total = total + t
    end

    return done, total
end

-- Header of the type that starts at an area, for the selector.
function M.GetMissionAreaTypes()
    return mission_area_types
end

function M.GetMissionAreaNames()
    mission_area_names.all = i18n.t('All')

    return mission_area_names
end

function M.GetMissionList()
    return get_visible_missions()
end

-- Extra rows the list of missions shows between two missions, as a list of
-- blocks. A block is a title (the chapters of Chains of Promathia, placed
-- before the first visible mission of the chapter: members) or the epilogue,
-- three quests that open in the Quests tab (placed before the mission with
-- id before_id of the area). Returns nil when there is nothing to add.
function M.GetMissionListExtras()
    if not tracker_is_ready() then
        return nil
    end

    local function epilogue_rows()
        local index = build_quest_link_index()

        if index == nil then
            return nil
        end

        local rows = {}

        for _, id in ipairs(EPILOGUE_QUESTS) do
            local info = index.by_id[id]

            if info ~= nil then
                local status =
                    get_quest_status_map(info.category)[id] or 'not_started'

                if (status ~= 'completed' or not hide_complete_missions)
                    and (status ~= 'not_started' or show_not_started_missions) then

                    rows[#rows + 1] = {
                        id = id,
                        name = info.name,
                        status = status,
                        repeatable = info.repeatable,
                    }
                end
            end
        end

        return rows
    end

    local blocks = {}

    for _, area in ipairs({ 'windurst', 'bastok', 'sandoria', 'zilart', 'cop', 'adoulin', 'rov' }) do
        if all_view.missions or mission_areas[mission_area_index] == area then
            local guide = MISSION_GUIDE[area]

            if guide.by_rank then
                -- A rank counts as done when every mission of it is completed
                -- (full list, so the filters do not change the result).
                local totals, dones = {}, {}

                for _, mission in ipairs(apply_cached_statuses(
                    area,
                    tracker.GetMissionArea(area)
                )) do
                    local r = mission.rank

                    if r ~= nil then
                        totals[r] = (totals[r] or 0) + 1

                        if mission.status == 'completed' then
                            dones[r] = (dones[r] or 0) + 1
                        end
                    end
                end

                for rank = 1, 10 do
                    blocks[#blocks + 1] = {
                        area = area,
                        rank = rank,
                        title = string.format(i18n.t('Rank %d'), rank),
                        -- The V sits on the NEXT rank: rank 1 done -> V on
                        -- Rank 2. Rank 1 itself gets it once Rank 2 is reached
                        -- (that is, when Rank 1 is done).
                        done = (rank == 1
                                and (totals[1] or 0) > 0
                                and dones[1] == totals[1])
                            or (rank > 1
                                and (totals[rank - 1] or 0) > 0
                                and dones[rank - 1] == totals[rank - 1]),
                    }
                end
            end

            for number, name in ipairs(guide.chapters or {}) do
                blocks[#blocks + 1] = {
                    area = area,
                    chapter = number,
                    title = string.format(
                        i18n.t('Chapter %d: %s'),
                        number,
                        name
                    ),
                    raw_title = true,
                }
            end

            for code, note in pairs(guide.notes or {}) do
                blocks[#blocks + 1] = {
                    area = area,
                    before_code = code,
                    title = note,
                }
            end

            if guide.epilogue_info ~= nil then
                -- Quests that are not in the quest data: information only.
                local rows = {}

                for _, info in ipairs(guide.epilogue_info) do
                    rows[#rows + 1] = {
                        info = true,
                        name = info.name,
                        type = info.type,
                        reward = info.reward,
                    }
                end

                if #rows > 0 then
                    blocks[#blocks + 1] = {
                        area = area,
                        title = 'Epilogue',
                        rows = rows,
                    }
                end
            elseif guide.finale_id ~= nil then
                local rows = epilogue_rows()

                if rows ~= nil and #rows > 0 then
                    blocks[#blocks + 1] = {
                        area = area,
                        before_id = guide.finale_id,
                        title = 'Epilogue',
                        rows = rows,
                    }
                end
            end
        end
    end

    if #blocks == 0 then
        return nil
    end

    return blocks
end

function M.GetMissionSelection()
    local visible =
        get_visible_missions()

    if #visible == 0 then
        mission_index = 1
    else
        mission_index =
            math.max(
                1,
                math.min(
                    mission_index,
                    #visible
                )
            )
    end

    return {
        area_index = all_view.missions and 1 or (mission_area_index + 1),
        mission_index = mission_index,
    }
end

function M.SetMissionSelection(
    area_index,
    selected_mission_index
)
    local new_area =
        tonumber(area_index)

    local new_index =
        tonumber(selected_mission_index)

    -- The index is the one of the selector: 1 is "All".
    if new_area ~= nil
        and new_area >= 1
        and new_area <= #mission_areas + 1 then

        if new_area == 1 then
            all_view.missions = true
        else
            all_view.missions = false
            mission_area_index = new_area - 1
        end
    end

    invalidate_mission_cache()

    if new_index ~= nil then
        mission_index =
            new_index
    end

    get_visible_missions()
    request_config_save()
end

function M.GetSelectedMission()
    local visible =
        get_visible_missions()

    if #visible == 0 then
        return nil
    end

    return visible[mission_index]
end

function M.SelectPreviousMission()
    local visible =
        get_visible_missions()

    if #visible == 0 then
        return
    end

    mission_index =
        mission_index - 1

    if mission_index < 1 then
        mission_index =
            #visible
    end

    request_config_save()
end

function M.SelectNextMission()
    local visible =
        get_visible_missions()

    if #visible == 0 then
        return
    end

    mission_index =
        mission_index + 1

    if mission_index > #visible then
        mission_index = 1
    end

    request_config_save()
end

local function select_mission_view_index(index)
    if index < 1 then
        index = #mission_areas + 1
    elseif index > #mission_areas + 1 then
        index = 1
    end

    if index == 1 then
        all_view.missions = true
    else
        all_view.missions = false
        mission_area_index = index - 1
    end

    mission_index = 1

    invalidate_mission_cache()
    rebuild_mission_cache()
    request_config_save()
end

function M.SelectPreviousMissionArea()
    select_mission_view_index(
        (all_view.missions and 1 or (mission_area_index + 1)) - 1
    )
end

function M.SelectNextMissionArea()
    select_mission_view_index(
        (all_view.missions and 1 or (mission_area_index + 1)) + 1
    )
end

-- Quest API

function M.GetQuestCategories()
    return get_quest_categories_view()
end

function M.GetQuestCategoryNames()
    return get_quest_category_names_view()
end

function M.GetQuestSelection()
    return {
        category_index =
            (#get_quest_categories() > 0)
            and (all_view.quests and 1 or (quest_category_index + 1))
            or quest_category_index,

        quest_index =
            quest_index,
    }
end

-- The zone titles of the list of quests: the position of the first quest
-- of each group and its zone. Empty when the list has a single group.
function M.GetQuestListGroups()
    get_visible_quests()

    if #all_view.groups < 2 then
        return {}
    end

    return all_view.groups
end

function M.GetQuestList()
    return get_visible_quests()
end

function M.GetSelectedQuest()
    local quests =
        get_visible_quests()

    if #quests == 0 then
        quest_index = 1
        return nil
    end

    quest_index =
        math.max(
            1,
            math.min(
                quest_index,
                #quests
            )
        )

    return quests[quest_index]
end

function M.SetQuestSelection(
    category_index,
    selected_quest_index
)
    -- A selection made by the player (not by a link) starts a new trail.
    if not quest_jump_in_progress then
        quest_history = {}
    end

    local categories =
        get_quest_categories()

    if #categories == 0 then
        quest_category_index = 1
        quest_index = 1
        invalidate_quest_cache()
        return
    end

    local new_category =
        tonumber(category_index)

    local new_index =
        tonumber(selected_quest_index)

    -- The index is the one of the selector: 1 is "All".
    if new_category ~= nil
        and new_category >= 1
        and new_category <= #categories + 1 then

        if new_category == 1 then
            all_view.quests = true
        else
            all_view.quests = false
            quest_category_index = new_category - 1
        end
    end

    if new_index ~= nil then
        quest_index =
            new_index
    end

    invalidate_quest_cache()

    local quests =
        M.GetQuestList()

    if #quests == 0 then
        quest_index = 1
    else
        quest_index =
            math.max(
                1,
                math.min(
                    quest_index,
                    #quests
                )
            )
    end

    request_config_save()
end

local function select_quest_view_index(index)
    local count = #get_quest_categories()

    if count == 0 then
        return
    end

    if index < 1 then
        index = count + 1
    elseif index > count + 1 then
        index = 1
    end

    if index == 1 then
        all_view.quests = true
    else
        all_view.quests = false
        quest_category_index = index - 1
    end

    quest_index = 1

    invalidate_quest_cache()
    rebuild_quest_cache()
    request_config_save()
end

function M.SelectPreviousQuestCategory()
    select_quest_view_index(
        (all_view.quests and 1 or (quest_category_index + 1)) - 1
    )
end

function M.SelectNextQuestCategory()
    select_quest_view_index(
        (all_view.quests and 1 or (quest_category_index + 1)) + 1
    )
end

function M.SelectPreviousQuest()
    local quests =
        get_visible_quests()

    if #quests == 0 then
        return
    end

    quest_index =
        quest_index - 1

    if quest_index < 1 then
        quest_index =
            #quests
    end

    request_config_save()
end

function M.SelectNextQuest()
    local quests =
        get_visible_quests()

    if #quests == 0 then
        return
    end

    quest_index =
        quest_index + 1

    if quest_index > #quests then
        quest_index = 1
    end

    request_config_save()
end

-- Journal mode

function M.GetJournalMode()
    return journal_mode
end

function M.SetJournalMode(mode)
    mode = tonumber(mode)

    if mode ~= 1
        and mode ~= 2 then

        mode = 1
    end

    if journal_mode == mode then
        return
    end

    journal_mode = mode
    request_config_save()
end

-- Journal window API

function M.GetJournalWindowState()
    return {
        visible = journal_visible,
        x = journal_x,
        y = journal_y,
        width = journal_width,
        height = journal_height,
        reset_count = window_reset_count,
    }
end

function M.GetJournalState()
    return M.GetJournalWindowState()
end

function M.SetJournalVisible(
    visible
)
    journal_visible =
        visible == true

    request_config_save()
end

function M.ShowJournal()
    M.SetJournalVisible(true)
end

function M.HideJournal()
    M.SetJournalVisible(false)
end

function M.ToggleJournal()
    journal_visible =
        not journal_visible

    request_config_save()
end

function M.SetJournalGeometry(
    x,
    y,
    width,
    height
)
    journal_x = x
    journal_y = y
    journal_width = width
    journal_height = height

    request_config_save()
end

function M.GetJournalMiniState()
    return {
        visible = journal_mini,
        x = journal_mini_x,
        y = journal_mini_y,
    }
end

function M.SetJournalMini(
    visible
)
    journal_mini =
        visible == true

    request_config_save()
end

function M.GetJournalMiniButton()
    return journal_mini_button
end

function M.SetJournalMiniButton(value)
    journal_mini_button = value == true
    request_config_save()
end

function M.ShowJournalMini()
    journal_mini = true
    request_config_save()
end

function M.HideJournalMini()
    journal_mini = false
    request_config_save()
end

function M.ToggleJournalMini()
    journal_mini =
        not journal_mini

    request_config_save()
end

function M.SetJournalMiniGeometry(
    x,
    y
)
    journal_mini_x = x
    journal_mini_y = y
    request_config_save()
end

-- Help window API

function M.GetHelpVisible()
    return journal_help_visible
end

function M.SetHelpVisible(
    visible
)
    journal_help_visible =
        visible == true
end

function M.ShowHelp()
    journal_help_visible = true
end

function M.HideHelp()
    journal_help_visible = false
end

function M.ToggleHelp()
    journal_help_visible =
        not journal_help_visible
end

-- Lookups that keep the pinned items up to date.

local function find_mission_in_lists(
    item_id,
    item_name
)
    local numeric_id =
        tonumber(item_id)

    for _, area in ipairs(
        mission_areas
    ) do
        for index, mission in ipairs(
            tracker.GetMissionArea(area)
                or {}
        ) do
            local id_matches =
                numeric_id ~= nil
                and tonumber(mission.id)
                    == numeric_id
                or tostring(mission.id)
                    == tostring(item_id)

            local name_matches =
                tostring(
                    mission.name or ''
                )
                == tostring(
                    item_name or ''
                )

            if id_matches
                and name_matches then

                return area,
                    mission,
                    index
            end
        end
    end

    return nil, nil, nil
end

local function find_next_mission(
    area,
    current_index
)
    local mission_list =
        tracker.GetMissionArea(area)

    if mission_list == nil then
        return nil
    end

    local start_index =
        tonumber(current_index)

    if start_index == nil then
        return nil
    end

    for index = start_index + 1,
        #mission_list do

        local mission =
            mission_list[index]

        if mission ~= nil
            and mission.status ~= 'hidden'
            and mission.status ~= 'completed' then

            return mission
        end
    end

    return nil
end

local function find_quest_in_lists(
    item_id,
    item_name
)
    for _, category in ipairs(
        get_quest_categories()
    ) do
        for _, quest in ipairs(
            apply_cached_quest_statuses(
                category,
                get_quest_list_from_tracker(
                    category
                )
            )
        ) do
            local id_matches =
                tostring(
                    quest.id or ''
                )
                == tostring(
                    item_id or ''
                )

            local name_matches =
                tostring(
                    quest.name or ''
                )
                == tostring(
                    item_name or ''
                )

            if id_matches
                and name_matches then

                return category, quest
            end
        end
    end

    return nil, nil
end

-- Settings character switch

settings.register(
    'settings',
    'journal_settings_update',
    function(s)
        if s == nil then
            return
        end

        config = s

        apply_config()
        validate_state()

        invalidate_mission_cache()
        invalidate_quest_cache()
    end
)

-- Pinned tracker API

local function find_pin(kind, id, name)
    for index, entry in ipairs(pins) do
        if entry.kind == kind
            and entry.id == tostring(id or '')
            and entry.name == tostring(name or '') then

            return index
        end
    end

    return nil
end

local function clamp_pin_active()
    pin_active = math.max(1, math.min(pin_active, math.max(#pins, 1)))
end

local function add_pin(kind, id, name, steps)
    if find_pin(kind, id, name) ~= nil then
        return false
    end

    if #pins >= PIN_MAX then
        print(string.format(
            i18n.t('[Journal] Tracker is full (%d items). Unpin one first.'),
            PIN_MAX
        ))

        return false
    end

    local entry = {
        kind = kind,
        id = tostring(id or ''),
        name = tostring(name or ''),
        steps = serialize_steps(steps),
        step = 1,
    }

    -- The steps that were marked as done in the Journal are respected: the
    -- pin starts on the first step that is not done.
    entry.step =
        first_undone(entry.kind, entry.id, entry.name, entry.steps)

    pins[#pins + 1] = entry

    request_config_save()

    return true
end

-- A quest that the player unpins by hand is not pinned again by itself
-- while it stays active.
local function dismiss_auto_pin(entry)
    if not auto_pin_quests or entry.kind ~= 'quest' then
        return
    end

    for _, quest in ipairs(get_active_quests()) do
        if tostring(quest.id) == entry.id then
            auto_pin_dismissed[entry.id] = true

            return
        end
    end
end

local function remove_pin_at(index)
    if pins[index] == nil then
        return false
    end

    local entry = pins[index]

    dismiss_auto_pin(entry)

    table.remove(pins, index)
    clamp_pin_active()

    -- Pinning it again shows it in the compass again.
    M.compass.ForgetPin(M.compass.PinKey(entry.kind, entry.id, entry.name))

    request_config_save()

    return true
end

function M.GetPinState()
    clamp_pin_active()

    return {
        visible = pin_visible,
        x = pin_x,
        y = pin_y,
        mode = pin_mode,
        active = pin_active,
        auto_zone = pin_auto_zone,
        scale = pin_scale,
        show_next = pin_show_next,
        opacity = pin_opacity,
        background = pin_background,
        reset_count = window_reset_count,
        auto_pin = auto_pin_quests,
        count = #pins,
    }
end

-- The pinned items. A pinned quest also tells if it is repeatable, which
-- the Tracker marks with an infinity sign.
function M.GetPins()
    local index = build_quest_link_index()

    for _, pin in ipairs(pins) do
        if pin.kind == 'quest'
            and index ~= nil
            and index.by_id[pin.id] ~= nil then

            pin.repeatable = index.by_id[pin.id].repeatable
        end
    end

    return pins
end

function M.SetPinVisible(visible)
    pin_visible = visible == true
    request_config_save()
end

function M.TogglePinVisible()
    M.SetPinVisible(not pin_visible)
end

function M.SetPinGeometry(x, y)
    pin_x = x
    pin_y = y
    request_config_save()
end

function M.GetPinScale()
    return pin_scale
end

function M.SetPinScale(value)
    local scale = clamp_pin_scale(value)

    if scale == pin_scale then
        return scale
    end

    pin_scale = scale
    request_config_save()

    return scale
end

-- direction is +1 (bigger) or -1 (smaller)
function M.AdjustPinScale(direction)
    return M.SetPinScale(pin_scale + direction * PIN_SCALE_STEP)
end

-- Size of the text of the Journal (0.5 to 1.4, 1.0 is the normal size).
function M.GetTextScale()
    return journal_text_scale
end

function M.SetTextScale(value)
    local scale =
        clamp_opacity(value, TEXT_SCALE_MIN, TEXT_SCALE_MAX, journal_text_scale)

    if scale ~= journal_text_scale then
        journal_text_scale = scale
        request_config_save()
    end

    return journal_text_scale
end

function M.AdjustTextScale(direction)
    return M.SetTextScale(journal_text_scale + direction * OPACITY_STEP)
end

-- Opacity of the Journal windows (0.35 to 1.0).
function M.GetJournalOpacity()
    return journal_opacity
end

function M.SetJournalOpacity(value)
    local opacity =
        clamp_opacity(value, OPACITY_MIN, OPACITY_MAX, journal_opacity)

    if opacity ~= journal_opacity then
        journal_opacity = opacity
        request_config_save()
    end

    return journal_opacity
end

function M.AdjustJournalOpacity(direction)
    return M.SetJournalOpacity(journal_opacity + direction * OPACITY_STEP)
end

-- Opacity of the Tracker text (0.35 to 1.0).
function M.GetPinOpacity()
    return pin_opacity
end

function M.SetPinOpacity(value)
    local opacity =
        clamp_opacity(value, OPACITY_MIN, OPACITY_MAX, pin_opacity)

    if opacity ~= pin_opacity then
        pin_opacity = opacity
        request_config_save()
    end

    return pin_opacity
end

function M.AdjustPinOpacity(direction)
    return M.SetPinOpacity(pin_opacity + direction * OPACITY_STEP)
end

-- Opacity of the dark background behind the Tracker (0 to 0.8).
function M.GetPinBackground()
    return pin_background
end

function M.SetPinBackground(value)
    local opacity =
        clamp_opacity(value, 0.0, BACKGROUND_MAX, pin_background)

    if opacity ~= pin_background then
        pin_background = opacity
        request_config_save()
    end

    return pin_background
end

function M.AdjustPinBackground(direction)
    return M.SetPinBackground(pin_background + direction * OPACITY_STEP)
end

-- Settings window.
function M.GetSettingsOpen()
    return settings_open
end

function M.SetSettingsOpen(value)
    settings_open = value == true
end

function M.ToggleSettings()
    settings_open = not settings_open
end

-- Fame of the nations, read when the player talks to a Fame Checker (see
-- fame.lua): { sandoria = { level, time }, bastok = ..., windurst = ..., jeuno,
-- norg, selbina_rabao }.
function M.GetFameLevels()
    return M.fame_levels or {}
end

function M.GetFameOpen()
    return M.fame_open == true
end

function M.SetFameOpen(value)
    M.fame_open = value == true
end

function M.ToggleFame()
    M.fame_open = not M.fame_open
end

-- Size of the Fame window: nil, nil until the player resizes it.
function M.GetFameSize()
    if M.fame_win then
        return M.fame_win.w, M.fame_win.h
    end

    return nil, nil
end

function M.SetFameSize(width, height)
    width = tonumber(width)
    height = tonumber(height)

    if width == nil or height == nil then
        return
    end

    width = math.max(300, math.min(2400, math.floor(width + 0.5)))
    height = math.max(200, math.min(2400, math.floor(height + 0.5)))

    local old = M.fame_win

    if old == nil or old.w ~= width or old.h ~= height then
        M.fame_win = { w = width, h = height }
        request_config_save()
    end
end

-- true when the NPC is one of the Fame Checkers (they have their own icon).
function M.IsFameChecker(name)
    local ok, result = pcall(function()
        return require('fame').IsChecker(name)
    end)

    return ok and result == true
end

function M.GetFameAreas()
    return require('fame').AREAS
end

function M.SetFameLevel(area, level, stamp)
    level = tonumber(level)

    if level == nil or level < 1 or level > 9 then
        return
    end

    M.fame_levels = M.fame_levels or {}

    local old = M.fame_levels[area]

    M.fame_levels[area] = { level = math.floor(level), time = stamp or 0 }

    if old == nil or old.level ~= math.floor(level) then
        request_config_save()
    end
end

-- Size of the Settings window: nil, nil until the player resizes it.
function M.GetSettingsSize()
    if M.settings_win then
        return M.settings_win.w, M.settings_win.h
    end

    return nil, nil
end

function M.SetSettingsSize(width, height)
    width = tonumber(width)
    height = tonumber(height)

    if width == nil or height == nil then
        return
    end

    width = math.max(300, math.min(2400, math.floor(width + 0.5)))
    height = math.max(200, math.min(2400, math.floor(height + 0.5)))

    local old = M.settings_win

    if old == nil or old.w ~= width or old.h ~= height then
        M.settings_win = { w = width, h = height }
        request_config_save()
    end
end

-- Moves the Journal and the Tracker back to a place on the screen, for when
-- a window ended up outside of it. The windows read reset_count to apply it.
function M.ResetWindowPositions()
    journal_x = 80
    journal_y = 80
    pin_x = 120
    pin_y = 120
    window_reset_count = window_reset_count + 1
    request_config_save()
end

function M.SetPinMode(mode)
    pin_mode = mode == 'tabs' and 'tabs' or 'stacked'
    request_config_save()
end

function M.TogglePinMode()
    M.SetPinMode(pin_mode == 'tabs' and 'stacked' or 'tabs')
end

function M.GetPinShowNext()
    return pin_show_next
end

function M.SetPinShowNext(value)
    pin_show_next = value == true
    request_config_save()
end

function M.TogglePinShowNext()
    M.SetPinShowNext(not pin_show_next)
end

-- Language of the objective texts ('en' or 'es').
function M.GetLanguage()
    return language
end

function M.SetLanguage(code)
    language = code == 'es' and 'es' or 'en'
    i18n.set_language(language)
    request_config_save()
end

function M.ToggleLanguage()
    M.SetLanguage(language == 'es' and 'en' or 'es')
end

function M.SetPinActive(index)
    pin_active = math.floor(tonumber(index) or 1)
    clamp_pin_active()
    request_config_save()
end

-- kind is 'Mission' or 'Quest' (any case); item is a mission or quest
-- as the Journal lists it.
function M.IsPinned(kind, item)
    if item == nil then
        return false
    end

    return find_pin(
        tostring(kind or ''):lower(),
        item.id,
        item.name
    ) ~= nil
end

-- Current step of a pinned mission or quest, and how many steps it has.
-- Returns nil when the item is not pinned: the game does not tell the step,
-- so the pinned step is the only progress the addon knows.
function M.GetPinStep(kind, item)
    if item == nil then
        return nil
    end

    local index = find_pin(
        tostring(kind or ''):lower(),
        item.id,
        item.name
    )

    if index == nil then
        return nil
    end

    local entry = pins[index]
    local total = #entry.steps
    local step = math.max(
        1,
        math.min(entry.step or 1, math.max(total, 1))
    )

    return step, total
end

function M.ToggleItemPin(kind, item)
    kind = tostring(kind or ''):lower()

    if item == nil or (kind ~= 'mission' and kind ~= 'quest') then
        return false
    end

    local index = find_pin(kind, item.id, item.name)

    if index ~= nil then
        return remove_pin_at(index)
    end

    if add_pin(kind, item.id, item.name, item.steps or {}) then
        pin_visible = true
        pin_active = #pins

        return true
    end

    return false
end

-- Pins the mission or quest that is selected in the Journal.
function M.PinSelected()
    local kind
    local item

    if journal_mode == 1 then
        kind = 'mission'
        item = M.GetSelectedMission()
    else
        kind = 'quest'
        item = M.GetSelectedQuest()
    end

    if item == nil then
        return 0
    end

    if add_pin(kind, item.id, item.name, item.steps or {}) then
        pin_visible = true
        pin_active = #pins

        return 1
    end

    return 0
end

function M.RemovePin(index)
    return remove_pin_at(math.floor(tonumber(index) or 0))
end

function M.ClearPins()
    for _, entry in ipairs(pins) do
        dismiss_auto_pin(entry)
        M.compass.ForgetPin(
            M.compass.PinKey(entry.kind, entry.id, entry.name)
        )
    end

    pins = {}
    pin_active = 1
    request_config_save()
end

-- The step the pin is on is done and it moves to the next step that is not.
local function advance_pin(entry)
    local total = #entry.steps
    local current = math.max(1, math.min(entry.step, math.max(total, 1)))

    set_mark(entry.kind, entry.id, entry.name, entry.steps, current, true)

    local marks = get_marks(entry.kind, entry.id, entry.name, entry.steps)
    local following = current + 1

    while following <= total and marks[following] do
        following = following + 1
    end

    entry.step = math.max(1, math.min(following, math.max(total, 1)))
end

-- The pin goes back one step, and that step is not done any more.
local function retreat_pin(entry)
    local total = #entry.steps
    local current = math.max(1, math.min(entry.step, math.max(total, 1)))

    if current <= 1 then
        return
    end

    set_mark(
        entry.kind,
        entry.id,
        entry.name,
        entry.steps,
        current - 1,
        false
    )

    entry.step = current - 1
end

-- Puts every pin of an item on its first step that is not done.
local function sync_pin_cursor(kind, id, name)
    for _, entry in ipairs(pins) do
        if entry.kind == kind
            and entry.id == tostring(id)
            and entry.name == tostring(name or '') then

            entry.step =
                first_undone(entry.kind, entry.id, entry.name, entry.steps)
        end
    end
end

-- Goes to an exact step: the ones before it are done, it and the ones after
-- it are not.
function M.SetPinStep(index, value)
    local entry = pins[index]

    if entry == nil then
        return false
    end

    local total = #entry.steps
    local step = math.floor(tonumber(value) or 1)

    step = math.max(1, math.min(step, math.max(total, 1)))

    for position = 1, total do
        set_mark(
            entry.kind,
            entry.id,
            entry.name,
            entry.steps,
            position,
            position < step
        )
    end

    entry.step = step
    pin_active = index
    request_config_save()

    return true
end

function M.NextPinStep(index)
    local entry = pins[index]

    if entry ~= nil then
        advance_pin(entry)
        pin_active = index
        request_config_save()
    end
end

function M.PrevPinStep(index)
    local entry = pins[index]

    if entry ~= nil then
        retreat_pin(entry)
        pin_active = index
        request_config_save()
    end
end

-- The checklist of a quest or mission (kind is "quest" or "mission").
-- Returns the done steps (index -> true) and how many there are.
function M.GetStepMarks(kind, id, name, steps)
    return get_marks(kind, id, name, steps or {})
end

function M.ToggleStepMark(kind, id, name, steps, index)
    steps = steps or {}
    index = math.floor(tonumber(index) or 0)

    if steps[index] == nil then
        return false
    end

    local marks = get_marks(kind, id, name, steps)

    set_mark(kind, id, name, steps, index, not marks[index])

    sync_pin_cursor(tostring(kind):lower(), id, name)
    request_config_save()

    return true
end

function M.ClearStepMarks(kind, id, name)
    step_marks[marks_key(kind, id, name)] = nil

    sync_pin_cursor(tostring(kind):lower(), id, name)
    request_config_save()
end

-- Notes and favorites (see personal.lua). kind is 'Mission' or 'Quest' (any
-- case); item is a mission or quest as the Journal lists it.

function M.GetNote(kind, item)
    if item == nil then
        return ''
    end

    return M.personal.GetNote(kind, item.id, item.name)
end

function M.HasNote(kind, item)
    return item ~= nil
        and M.personal.HasNote(kind, item.id, item.name)
end

function M.SetNote(kind, item, text)
    if item ~= nil
        and M.personal.SetNote(kind, item.id, item.name, text) then

        request_config_save()

        return true
    end

    return false
end

function M.IsFavorite(kind, item)
    return item ~= nil
        and M.personal.IsFavorite(kind, item.id, item.name)
end

-- The lists show only the favorites (kind is 'Mission' or 'Quest').
function M.GetOnlyFavorites(kind)
    return M.personal.GetOnlyFavorites(kind)
end

function M.SetOnlyFavorites(kind, value)
    if not M.personal.SetOnlyFavorites(kind, value) then
        return
    end

    if tostring(kind):lower() == 'mission' then
        mission_index = 1
        invalidate_mission_cache()
    else
        quest_index = 1
        invalidate_quest_cache()
    end

    request_config_save()
end

function M.ToggleFavorite(kind, item)
    if item == nil then
        return false
    end

    kind = tostring(kind or ''):lower()

    -- A mission is opened again from its area.
    local area = nil

    if kind == 'mission' then
        area = item.area or mission_areas[mission_area_index]
    end

    local state, problem =
        M.personal.ToggleFavorite(kind, item.id, item.name, area)

    if problem == 'full' then
        print(string.format(
            i18n.t('[Journal] The favorites list is full (%d). Remove one first.'),
            M.personal.FAVORITE_MAX
        ))

        return false
    end

    -- With the filter on, the list follows the favorites.
    if M.personal.GetOnlyFavorites(kind) then
        if kind == 'mission' then
            invalidate_mission_cache()
        else
            invalidate_quest_cache()
        end
    end

    request_config_save()

    return state
end

-- Removes a favorite by the values it was saved with (the list of favorites
-- can hold one that is not in the data any more).
function M.RemoveFavorite(kind, id, name)
    if M.personal.IsFavorite(kind, id, name) then
        M.personal.ToggleFavorite(kind, id, name)

        if M.personal.GetOnlyFavorites(kind) then
            if tostring(kind):lower() == 'mission' then
                invalidate_mission_cache()
            else
                invalidate_quest_cache()
            end
        end

        request_config_save()

        return true
    end

    return false
end

-- The "Active Now" window.

function M.GetActiveOpen()
    return M.personal.GetWindowOpen()
end

function M.GetActiveTab()
    return M.personal.GetWindowTab()
end

function M.SetActiveOpen(value, tab)
    M.personal.SetWindowOpen(value, tab)
end

-- Opens a mission in the Journal, the way JumpToQuest does for a quest: what
-- hides it (filters) is relaxed so the jump always arrives, and the search
-- text is cleared unless keep_search. Returns false when the mission is not
-- in the data.
function M.JumpToMission(area, id, name, keep_search)
    local area_index = nil

    for index, key in ipairs(mission_areas) do
        if key == area then
            area_index = index
            break
        end
    end

    if area_index == nil or not tracker_is_ready() then
        return false
    end

    local target = nil

    for _, mission in ipairs(
        apply_cached_statuses(area, tracker.GetMissionArea(area))
    ) do
        if tostring(mission.id) == tostring(id)
            and tostring(mission.name or '') == tostring(name or '') then

            target = mission
            break
        end
    end

    if target == nil then
        return false
    end

    M.SetJournalMode(1)

    if search_text ~= '' and not keep_search then
        M.SetSearchText('')
    end

    local status = target.status or 'not_started'

    if M.personal.GetOnlyFavorites('mission')
        and not M.personal.IsFavorite('mission', target.id, target.name) then

        M.SetOnlyFavorites('mission', false)
    end

    if status == 'completed' and hide_complete_missions then
        M.SetHideCompleteMissions(false)
    elseif status == 'not_started' and not show_not_started_missions then
        M.SetShowNotStartedMissions(true)
    end

    -- The selector index: 1 is "All". A jump made from "All" stays there.
    local selector = all_view.missions and 1 or (area_index + 1)

    M.SetMissionSelection(selector, 1)

    for position, mission in ipairs(M.GetMissionList()) do
        if tostring(mission.id) == tostring(id)
            and tostring(mission.name or '') == tostring(name or '')
            and (mission.area == nil or mission.area == area) then

            M.SetMissionSelection(selector, position)

            return true
        end
    end

    return false
end

-- Search in the whole Journal ---------------------------------------------------
-- The text of the search box looks in every mission and every quest, whatever
-- the area, the category or the filters of the lists: in the name, the NPC,
-- the places, the reward, the requirements, the type and the steps. A word
-- that is not in the same field still counts: every word of the text has to
-- be somewhere in the item. The state is kept in one table because the file
-- has no locals left.
do
    local S = {
        corpus = nil,
        language = nil,
        key = nil,
        time = -1000,
        found = nil,
        MAX = 200,
    }

    function S.field(list, key, value, step)
        value = normalize_search(value)

        if value ~= '' then
            list[#list + 1] = { key = key, text = value, step = step }
        end
    end

    -- One item of the corpus: its fields, in the order of importance, and
    -- all of them together to test the words quickly.
    function S.entry(kind, group, label, item, position, order, language)
        local fields = {}

        S.field(fields, 'name', item.name)

        if kind == 'quest' then
            S.field(fields, 'npc', item.npc)
            S.field(fields, 'place', item.zone)
            S.field(fields, 'place', item.loc)
            S.field(fields, 'reward', item.reward)
            S.field(fields, 'requires', item.req)
            S.field(fields, 'requires', item.prereq)
        else
            S.field(fields, 'type', item.mission_type)
            S.field(fields, 'reward', item.reward)
        end

        for index, step in ipairs(item.steps or {}) do
            local text = step_text_of(step)

            S.field(fields, 'step', text, index)

            if language == 'es' then
                local translated = i18n.step(text)

                if translated ~= text then
                    S.field(fields, 'step', translated, index)
                end
            end
        end

        S.field(fields, 'area', label)

        local texts = {}

        for index, field in ipairs(fields) do
            texts[index] = field.text
        end

        return {
            kind = kind,
            id = item.id,
            name = tostring(item.name or ''),
            group = group,
            label = label or '',
            position = position,
            order = order,
            fields = fields,
            hay = table.concat(texts, '\n'),
            name_text = (fields[1] ~= nil and fields[1].key == 'name')
                and fields[1].text or '',
        }
    end

    function S.build(language)
        local entries = {}
        local order = 0

        for _, area in ipairs(mission_areas) do
            local list = apply_cached_statuses(
                area,
                tracker.GetMissionArea(area)
            )

            for position, mission in ipairs(list) do
                if mission.status ~= 'hidden' and mission.name ~= nil then
                    order = order + 1

                    entries[#entries + 1] = S.entry(
                        'mission',
                        area,
                        mission_area_names[area],
                        mission,
                        position,
                        order,
                        language
                    )
                end
            end
        end

        local names = get_quest_category_names() or {}

        for _, category in ipairs(get_quest_categories()) do
            for position, quest in ipairs(get_quest_list_from_tracker(category)) do
                if quest.name ~= nil then
                    order = order + 1

                    entries[#entries + 1] = S.entry(
                        'quest',
                        category,
                        names[category],
                        quest,
                        position,
                        order,
                        language
                    )
                end
            end
        end

        return entries
    end

    -- How well an item fits the text: 0 the name starts with it, 1 the name
    -- has it, 2 the name has every word, 3 another field has it, 4 the
    -- words are spread. match is the field to tell the player about.
    function S.rate(entry, text, tokens)
        local at = entry.name_text ~= ''
            and string.find(entry.name_text, text, 1, true)

        if at == 1 then
            return 0, nil
        elseif at then
            return 1, nil
        end

        local in_name = entry.name_text ~= ''

        for _, token in ipairs(tokens) do
            if not string.find(entry.name_text, token, 1, true) then
                in_name = false
                break
            end
        end

        if in_name then
            return 2, nil
        end

        for _, field in ipairs(entry.fields) do
            if field.key ~= 'name'
                and string.find(field.text, text, 1, true) then

                return 3, field
            end
        end

        for _, field in ipairs(entry.fields) do
            if field.key ~= 'name'
                and string.find(field.text, tokens[1], 1, true) then

                return 4, field
            end
        end

        return 4, nil
    end

    function S.run(text)
        local tokens = {}

        for word in string.gmatch(text, '%S+') do
            tokens[#tokens + 1] = word
        end

        local hits = {}

        for _, entry in ipairs(S.corpus) do
            local all = true

            for _, token in ipairs(tokens) do
                if not string.find(entry.hay, token, 1, true) then
                    all = false
                    break
                end
            end

            if all then
                local score, field = S.rate(entry, text, tokens)

                hits[#hits + 1] = {
                    entry = entry,
                    score = score,
                    field = field,
                }
            end
        end

        table.sort(hits, function(a, b)
            if a.score ~= b.score then
                return a.score < b.score
            end

            return a.entry.order < b.entry.order
        end)

        local result = {
            ready = true,
            text = text,
            missions = {},
            quests = {},
            total_missions = 0,
            total_quests = 0,
        }

        local mission_lists = {}
        local quest_maps = {}

        for _, hit in ipairs(hits) do
            local entry = hit.entry
            local is_mission = entry.kind == 'mission'
            local rows = is_mission and result.missions or result.quests

            if is_mission then
                result.total_missions = result.total_missions + 1
            else
                result.total_quests = result.total_quests + 1
            end

            if #rows < S.MAX then
                local row = {
                    kind = entry.kind,
                    id = entry.id,
                    name = entry.name,
                    label = entry.label,
                    match = hit.field and hit.field.key or nil,
                    step = hit.field and hit.field.step or nil,
                    status = 'not_started',
                }

                if is_mission then
                    row.area = entry.group

                    if mission_lists[entry.group] == nil then
                        mission_lists[entry.group] = apply_cached_statuses(
                            entry.group,
                            tracker.GetMissionArea(entry.group)
                        )
                    end

                    local mission = mission_lists[entry.group][entry.position]

                    if mission ~= nil then
                        row.status = mission.status or 'not_started'
                        row.trackable = mission.trackable
                    end
                else
                    row.category = entry.group

                    if quest_maps[entry.group] == nil then
                        local map = {}

                        for _, quest in ipairs(apply_cached_quest_statuses(
                            entry.group,
                            get_quest_list_from_tracker(entry.group)
                        )) do
                            map[quest.id] = quest
                        end

                        quest_maps[entry.group] = map
                    end

                    local quest = quest_maps[entry.group][entry.id]

                    if quest ~= nil then
                        row.status = quest.status or 'not_started'
                        row.trackable = quest.trackable
                        row.repeatable = quest.repeatable == true
                    end
                end

                rows[#rows + 1] = row
            end
        end

        return result
    end

    -- now is os.clock(). nil while the box is empty. The matching is done
    -- again when the text changes and about once a second (the statuses
    -- move while the player plays).
    function M.GetSearchResults(now)
        if search_text == '' then
            return nil
        end

        if not tracker_is_ready() then
            return {
                ready = false,
                text = search_text,
                missions = {},
                quests = {},
                total_missions = 0,
                total_quests = 0,
            }
        end

        local language = i18n.get_language()

        if S.corpus == nil or S.language ~= language then
            S.corpus = S.build(language)
            S.language = language
            S.found = nil
        end

        if S.found == nil or S.key ~= search_text or now - S.time >= 1.0 then
            S.key = search_text
            S.time = now
            S.found = S.run(search_text)
        end

        return S.found
    end

    -- Opens a result in the Journal (the search text stays, so the player can
    -- go back to the results). Returns false when it is not in the data.
    function M.OpenSearchResult(row)
        if type(row) ~= 'table' then
            return false
        end

        if row.kind == 'mission' then
            return M.JumpToMission(row.area, row.id, row.name, true)
        end

        return M.JumpToQuest(row.id, true)
    end
end

-- The rows of the "Active Now" window: the active missions and quests, and
-- the favorites. The local function lives in this block so that it does not
-- take one of the locals the file has left.
do
    -- The part of a row that both lists share. status is the status the
    -- Journal shows for the item.
    local function describe(kind, area, label, item, status)
        local steps = item.steps or {}
        local id = tostring(item.id or '')
        local name = tostring(item.name or '')
        local step = 0
        local done = 0
        local step_text = nil

        if #steps > 0 then
            local _, count = get_marks(kind, id, name, steps)

            done = count
            step = first_undone(kind, id, name, steps)
            step_text = step_text_of(steps[step])
        end

        return {
            kind = kind,
            id = item.id,
            name = name,
            area = area,
            label = label or '',
            status = status or 'not_started',
            step = step,
            total = #steps,
            done = done,
            all_done = #steps > 0 and done >= #steps,
            step_text = step_text,
            pinned = find_pin(kind, id, name) ~= nil,
            favorite = M.personal.IsFavorite(kind, id, name),
            note = M.personal.GetNote(kind, id, name),
            repeatable = item.repeatable == true,
            trackable = item.trackable,
        }
    end

    -- Missions first, in the order of the areas, and then the quests in the
    -- order of the Journal. The status is the one the lists show (the saved
    -- status counts as well as the live one).
    function M.GetActiveNow()
        local rows = {}

        if not tracker_is_ready() then
            return rows
        end

        for _, area in ipairs(mission_areas) do
            for _, mission in ipairs(
                apply_cached_statuses(area, tracker.GetMissionArea(area))
            ) do
                if mission.status == 'active' then
                    rows[#rows + 1] = describe(
                        'mission',
                        area,
                        mission_area_names[area],
                        mission,
                        'active'
                    )
                end
            end
        end

        local index = build_quest_link_index()
        local names = get_quest_category_names() or {}

        for _, quest in ipairs(get_active_quests()) do
            local info = index and index.by_id[quest.id]

            rows[#rows + 1] = describe(
                'quest',
                nil,
                info and names[info.category] or '',
                quest,
                'active'
            )
        end

        return rows
    end

    -- The favorites, in the order they were added. One that is not in the
    -- data any more has missing = true (it can still be removed).
    -- The row of one favorite (or of the compass target): favorite is
    -- { kind, id, name, area }. ready, index and names are what
    -- GetFavoriteRows prepares once for all of them.
    local function row_of(favorite, ready, index, names)
        local item = nil
        local area = nil
        local label = ''

        if favorite.kind == 'mission' then
            area = favorite.area
            label = mission_area_names[area] or ''

            if ready and mission_area_names[area] ~= nil then
                for _, mission in ipairs(
                    apply_cached_statuses(
                        area,
                        tracker.GetMissionArea(area)
                    )
                ) do
                    if tostring(mission.id) == favorite.id
                        and tostring(mission.name or '')
                            == favorite.name then

                        item = mission
                        break
                    end
                end
            end
        else
            local info = index and index.by_id[favorite.id]

            if info ~= nil then
                label = names[info.category] or ''

                for _, quest in ipairs(
                    apply_cached_quest_statuses(
                        info.category,
                        get_quest_list_from_tracker(info.category)
                    )
                ) do
                    if tostring(quest.id) == favorite.id then
                        item = quest
                        break
                    end
                end
            end
        end

        local row = describe(
            favorite.kind,
            area,
            label,
            item or { id = favorite.id, name = favorite.name },
            item and item.status or nil
        )

        row.missing = item == nil

        return row
    end

    function M.GetFavoriteRows()
        local rows = {}
        local ready = tracker_is_ready()
        local index = ready and build_quest_link_index() or nil
        local names = ready and get_quest_category_names() or {}

        for _, favorite in ipairs(M.personal.GetFavorites()) do
            rows[#rows + 1] = row_of(favorite, ready, index, names)
        end

        return rows
    end

    -- The compass. The text of the current step of the target is looked up
    -- once a second; the compass itself decides how often it scans.
    local compass_api = nil
    local compass_key = nil
    local compass_time = -1000
    local compass_step = nil

    function M.GetCompassOpen()
        return M.compass.GetWindowOpen()
    end

    function M.SetCompassOpen(value)
        if M.compass.GetWindowOpen() ~= (value == true) then
            M.compass.SetWindowOpen(value)
            request_config_save()
        end
    end

    function M.GetCompassPosition()
        return M.compass.GetPosition()
    end

    function M.SetCompassPosition(x, y)
        local old_x, old_y = M.compass.GetPosition()

        if old_x ~= x or old_y ~= y then
            M.compass.SetPosition(x, y)
            request_config_save()
        end
    end

    function M.GetCompassSize()
        return M.compass.GetSize()
    end

    -- nil, nil puts the window back to fitting its content.
    function M.SetCompassSize(width, height)
        local old_w, old_h = M.compass.GetSize()

        M.compass.SetSize(width, height)

        local new_w, new_h = M.compass.GetSize()

        if old_w ~= new_w or old_h ~= new_h then
            request_config_save()
        end
    end

    function M.GetCompassOpacity()
        return M.compass.GetOpacity()
    end

    function M.SetCompassOpacity(value)
        local old = M.compass.GetOpacity()
        local new = M.compass.SetOpacity(value)

        if new ~= old then
            request_config_save()
        end

        return new
    end

    function M.AdjustCompassOpacity(direction)
        return M.SetCompassOpacity(M.compass.GetOpacity() + direction * 0.05)
    end

    function M.GetCompassTextScale()
        return M.compass.GetTextScale()
    end

    function M.SetCompassTextScale(value)
        local old = M.compass.GetTextScale()
        local new = M.compass.SetTextScale(value)

        if new ~= old then
            request_config_save()
        end

        return new
    end

    function M.AdjustCompassTextScale(direction)
        return M.SetCompassTextScale(
            M.compass.GetTextScale() + direction * 0.05
        )
    end

    function M.GetCompassSearchVisible()
        return M.compass.GetSearchVisible()
    end

    function M.SetCompassSearchVisible(value)
        if M.compass.GetSearchVisible() ~= (value == true) then
            M.compass.SetSearchVisible(value)
            request_config_save()
        end
    end

    function M.IsCompassTarget(kind, item)
        return item ~= nil
            and M.compass.IsTarget(kind, item.id, item.name)
    end

    -- Makes the item the target (and shows the window), or takes it off when
    -- it already is. Returns the new state.
    function M.ToggleCompassTarget(kind, item)
        if item == nil then
            return false
        end

        kind = tostring(kind or ''):lower()

        if M.compass.IsTarget(kind, item.id, item.name) then
            M.compass.ClearTarget()
            compass_key = nil
            request_config_save()

            return false
        end

        local area = nil

        if kind == 'mission' then
            area = item.area or mission_areas[mission_area_index]
        end

        if not M.compass.SetTarget(kind, item.id, item.name, area) then
            return false
        end

        compass_key = nil
        M.compass.SetWindowOpen(true)
        request_config_save()

        return true
    end

    function M.ClearCompassTarget()
        M.compass.ClearTarget()
        compass_key = nil
        request_config_save()
    end

    -- The "x" of the target in the compass window: it stops pointing at the
    -- item. If the item is pinned in the Tracker it does not come back as a
    -- row of the pins either (the pin stays in the Tracker).
    function M.RemoveCompassTarget()
        local target = M.compass.GetTarget()

        if target ~= nil
            and find_pin(target.kind, target.id, target.name) ~= nil then

            M.HideCompassPin(
                M.compass.PinKey(target.kind, target.id, target.name)
            )
        end

        M.ClearCompassTarget()
    end

    -- now is os.clock(). Returns the state of the compass (see compass.lua).
    function M.GetCompassState(now)
        local target = M.compass.GetTarget()

        if target == nil then
            compass_key = nil
            compass_step = nil
        else
            local key = target.kind .. ':' .. target.id .. ':' .. target.name

            if compass_key ~= key or now - compass_time >= 1.0 then
                compass_key = key
                compass_time = now

                local ready = tracker_is_ready()
                local row = row_of(
                    target,
                    ready,
                    ready and build_quest_link_index() or nil,
                    ready and get_quest_category_names() or {}
                )

                compass_step = row.step_text
            end
        end

        if compass_api == nil then
            compass_api = M.compass.AshitaApi()
        end

        return M.compass.Update(now, compass_step, M.GetStyles(), compass_api)
    end

    -- The name of a zone, from the game resources (nil if not available).
    function M.GetCompassZoneName(id)
        local ok, name = pcall(function()
            return AshitaCore:GetResourceManager():GetString('zones.names', id)
        end)

        if ok and type(name) == 'string' and name ~= '' then
            return name
        end

        return nil
    end

    -- The NPC search of the compass window. The NPCs chosen are kept with
    -- the other settings.
    function M.SearchCompassNpcs(query)
        return M.compass.Search(query, 6)
    end

    -- Returns true when added; false and 'full' or 'exists' otherwise.
    function M.AddCompassNpc(name, zone)
        local added, problem = M.compass.AddNpc(name, zone)

        if added then
            request_config_save()
        end

        return added, problem
    end

    -- A click on an NPC name in the Tracker: the NPC goes to the compass
    -- list and the compass window is shown. Returns true when it was added.
    function M.AddCompassNpcByName(name, hint)
        if compass_api == nil then
            compass_api = M.compass.AshitaApi()
        end

        local zone = nil

        if compass_api ~= nil and compass_api.zone ~= nil then
            local ok, value = pcall(compass_api.zone)

            zone = ok and tonumber(value) or nil
        end

        local zone_id = M.compass.PickZone(
            name,
            zone,
            hint,
            M.GetCompassZoneName
        )

        if zone_id == nil then
            return false, 'nozone'
        end

        local added, problem = M.AddCompassNpc(name, zone_id)

        if problem == 'full' then
            print('[Journal] ' .. string.format(
                i18n.t('The NPC list is full (%d). Remove one first.'),
                M.compass.NPC_MAX or 5
            ))
        else
            M.SetCompassOpen(true)
        end

        return added, problem
    end

    -- A click on a quest of an NPC in the compass: the Journal opens on it.
    function M.OpenQuestFromCompass(id)
        if not M.JumpToQuest(id) then
            return false
        end

        M.SetJournalMini(false)
        M.SetJournalVisible(true)

        return true
    end

    -- Which icon a quest has (see worldmark.lua): 'progress' when it is in
    -- progress, 'repeatable' when it can be done again, 'locked' when it waits
    -- for something, 'available' when it can be started, 'completed' when it
    -- is done and cannot be done again; nil when it is unknown.
    function M.GetQuestIconKind(id)
        local index = build_quest_link_index()
        local info = index and index.by_id[id]

        if info == nil then
            return nil
        end

        local state = M.world_lock.quest_state(index, id)

        if info.repeatable == true
            and (state == 'active' or state == 'completed') then

            return 'repeatable'
        elseif state == 'active' then
            return 'progress'
        elseif state == 'locked' or state == 'hidden' then
            return 'locked'
        elseif state == 'available' then
            return 'available'
        elseif state == 'completed' then
            return 'completed'
        end

        return nil
    end

    -- A mission that cannot be taken yet: the areas that are a chain (one
    -- mission after the other, in the order of their ids) and a mission that
    -- is not started while an earlier one of the same area is not completed.
    -- The first one that is not completed is the next to take. A deduction
    -- from the order of the data: the missions with branches may differ.
    M.mission_lock = {
        areas = {
            bastok = true, sandoria = true, windurst = true, zilart = true,
            cop = true, toau = true, wotg = true, adoulin = true,
            rov = true, acp = true, mkd = true, asa = true, tvr = true,
        },
        sets = {},
        time = -1000,
    }

    function M.IsMissionLocked(area, id)
        local lock = M.mission_lock

        if not lock.areas[area] then
            return false
        end

        local now = os.clock()

        if now - lock.time > 1 then
            lock.sets = {}
            lock.time = now
        end

        local locked = lock.sets[area]

        if locked == nil then
            locked = {}
            lock.sets[area] = locked

            local open = false

            for _, mission in ipairs(tracker.GetMissionArea(area) or {}) do
                local status = tracker.GetMissionStatus(area, mission.id)
                    or mission_status_cache[
                        get_status_cache_key(area, mission.id)
                    ]
                    or 'not_started'

                if status ~= 'completed' and status ~= 'hidden' then
                    -- The rank of the character (only the one of its own
                    -- nation is known) is below the rank the mission needs.
                    if status == 'not_started'
                        and require('rank').IsBelow(area, mission.rank) then

                        locked[mission.id] = true
                    end

                    if not open then
                        open = true
                    elseif status == 'not_started' then
                        locked[mission.id] = true
                    end
                end
            end
        end

        return locked[tonumber(id)] == true
    end

    -- The NPCs that give the missions of a nation (the Gate Guards). They
    -- go to the automatic compass when the player is close, and carry the
    -- icon of the mission available or not available.
    M.mission_givers = {
        areas = {
            windurst = {
                'Mokyokyo', 'Janshura-Rashura', 'Rakoh Buuma', 'Zokima-Rokima',
            },
            bastok = {
                'Argus', 'Cleades', 'Malduc', 'Rashid',
            },
            sandoria = {
                'Ambrotien', 'Endracion', 'Grilau',
            },
        },
        by_name = nil,
        cache = nil,
        cache_time = nil,
    }

    -- The area of the missions an NPC gives, or nil.
    function M.GetMissionGiverArea(name)
        local givers = M.mission_givers

        if givers.by_name == nil then
            givers.by_name = {}

            for area, names in pairs(givers.areas) do
                for _, npc in ipairs(names) do
                    givers.by_name[zonematch.normalize(npc)] = area
                end
            end
        end

        if type(name) ~= 'string' then
            return nil
        end

        return givers.by_name[zonematch.normalize(name)]
    end

    -- The icon of a mission in progress: 'mission_progress', or
    -- 'mission_available' when the file mission_progress.png is not there.
    function M.MissionProgressKind()
        local ok, icon = pcall(M.worldmark.GetIcon, 'mission_progress')

        return (ok and icon ~= nil) and 'mission_progress'
            or 'mission_available'
    end

    -- 'mission_available' when the NPC has a mission to give,
    -- 'mission_progress' when the mission is in progress,
    -- 'mission_locked' when there is none that can be
    -- taken now (the rank is too low, or all are completed); nil when the
    -- NPC does not give missions.
    function M.GetMissionGiverIcon(name)
        local area = M.GetMissionGiverArea(name)

        if area == nil then
            return nil
        end

        -- Looked at once per second at most (it is asked every frame).
        local givers = M.mission_givers
        local now = os.clock()

        if givers.cache == nil or now - (givers.cache_time or -10) > 1 then
            givers.cache = {}
            givers.cache_time = now
        end

        if givers.cache[area] ~= nil then
            return givers.cache[area]
        end

        local result = 'mission_locked'

        for _, mission in ipairs(tracker.GetMissionArea(area) or {}) do
            local status = tracker.GetMissionStatus(area, mission.id)
                or mission_status_cache[
                    get_status_cache_key(area, mission.id)
                ]
                or 'not_started'

            if status ~= 'completed' and status ~= 'hidden' then
                if status == 'not_started'
                    and M.IsMissionLocked(area, mission.id) then

                    result = 'mission_locked'
                elseif status == 'active' then
                    result = M.MissionProgressKind()
                else
                    result = 'mission_available'
                end

                break
            end
        end

        givers.cache[area] = result

        return result
    end

    -- The icon of a mission pinned in the Tracker (the pin has no area, so
    -- the mission is looked for by id and name): 'mission_completed',
    -- 'mission_progress', 'mission_locked' or 'mission_available'; nil when
    -- it is not found or the game cannot track it.
    function M.GetMissionIconKind(id, name)
        for _, area in ipairs(tracker.GetMissionAreas()) do
            for _, mission in ipairs(tracker.GetMissionArea(area) or {}) do
                if tostring(mission.id) == tostring(id)
                    and mission.name == name then
                    local status = tracker.GetMissionStatus(area, mission.id)
                        or mission_status_cache[
                            get_status_cache_key(area, mission.id)
                        ]
                        or mission.status
                        or 'not_started'

                    if status == 'completed' then
                        return 'mission_completed'
                    elseif mission.trackable == false
                        and status == 'not_started' then

                        return nil
                    elseif status == 'not_started'
                        and M.IsMissionLocked(area, mission.id) then

                        return 'mission_locked'
                    elseif status == 'active' then
                        return M.MissionProgressKind()
                    elseif status == 'not_started' then
                        return 'mission_available'
                    end

                    return nil
                end
            end
        end

        return nil
    end

    -- A click on a quest of the compass or of the Tracker: its sheet opens,
    -- not the Journal. ui.lua sets sheet_hook; without it, the Journal opens.
    function M.OpenQuestSheet(id)
        if not M.JumpToQuest(id) then
            return false
        end

        if M.sheet_hook ~= nil then
            M.sheet_hook()
        else
            M.SetJournalMini(false)
            M.SetJournalVisible(true)
        end

        return true
    end

    -- The arrow over the NPC of the compass in the game world.
    function M.GetWorldMark()
        return announce.world_mark
    end

    function M.SetWorldMark(value)
        announce.world_mark = value == true
        M.worldmark.SetCapture(announce.world_mark)
        request_config_save()
    end

    -- The rest of the NPCs of the compass too (the list chosen with the
    -- search and the pins of the Tracker), not only the target.
    function M.GetWorldMarkAll()
        return announce.world_mark_all
    end

    function M.SetWorldMarkAll(value)
        announce.world_mark_all = value == true
        request_config_save()
    end

    -- A green arrow over the NPC that starts each quest in progress (when
    -- it is in this zone), even if it is not in the compass.
    function M.GetWorldMarkActive()
        return announce.world_mark_active
    end

    function M.SetWorldMarkActive(value)
        announce.world_mark_active = value == true
        request_config_save()
    end

    -- An arrow at the edge of the screen for the NPCs out of view.
    function M.GetWorldMarkEdge()
        return announce.world_mark_edge
    end

    function M.SetWorldMarkEdge(value)
        announce.world_mark_edge = value == true
        request_config_save()
    end

    -- Grey arrow: the NPC only has quests to start that cannot be started
    -- yet, because each one names a quest in its prereq that is not
    -- completed. An NPC with a quest that is active, or one that can be
    -- started, or with no quest at all, keeps the yellow arrow.
    M.world_lock = { index = nil, by_npc = {} }

    -- completed / active / not_started: what the game reports now, or what
    -- was saved (as get_active_quests does). The saved statuses are only
    -- brought up to date for the category on screen, so they are not enough
    -- alone for quests of the other categories.
    M.world_lock.derived = {}

    -- Many quests keep their requirements in the text of the first step and
    -- not in the fields req and prereq ("You need to be level 15 or higher",
    -- "This quest follows The Real Gift", "The Sand Charm must be completed
    -- before..."). Returns { level = N or nil, prereq = { quest ids } }. Only
    -- plain sentences count: not the ones with "if", "while", "cannot",
    -- "active" (quests that clash, not quests that are needed). Fame, skill,
    -- job, mission and pack requirements are not read.
    function M.world_lock.derive(index, id)
        local cache = M.world_lock.derived

        if cache.index ~= index then
            cache = { index = index }
            M.world_lock.derived = cache
        end

        local got = cache[id]

        if got ~= nil then
            return got
        end

        got = { level = nil, prereq = {} }
        cache[id] = got

        local text = index.by_id[id] and index.by_id[id].step1

        if type(text) ~= 'string' then
            return got
        end

        local sentences = {}
        local pos = 1

        while true do
            local from, to = text:find('[%.!?]%s+', pos)

            if from == nil then
                sentences[#sentences + 1] = text:sub(pos)

                break
            end

            sentences[#sentences + 1] = text:sub(pos, from)
            pos = to + 1
        end

        for _, sentence in ipairs(sentences) do
            local low = sentence:lower()

            -- The level: not fame levels, not "or below", not gear or warps.
            if not low:find('or below', 1, true)
                and not low:find('equip', 1, true)
                and not low:find('warp', 1, true) then

                for at, number in low:gmatch('()level%s+(%d+)') do
                    local value = tonumber(number)

                    if value ~= nil and value <= 99
                        and not low:sub(1, at - 1):match('fame%s+is%s*$')
                        and not low:sub(1, at - 1):match('fame%s*$') then

                        got.level = math.max(got.level or 0, value)
                    end
                end

                for number in low:gmatch('lv%.?%s*(%d+)') do
                    local value = tonumber(number)

                    if value ~= nil and value <= 99 then
                        got.level = math.max(got.level or 0, value)
                    end
                end
            end

            -- The quests that have to be completed first.
            local clash = low:find('if ', 1, true)
                or low:find('while', 1, true)
                or low:find('cannot', 1, true)
                or low:find("can't", 1, true)
                or low:find('active', 1, true)
                or low:find('only one', 1, true)
                or low:find('zone', 1, true)

            if not clash
                and (low:find('follow', 1, true)
                    or low:find('finished', 1, true)
                    or low:find('completed', 1, true)
                    or low:find('completing', 1, true)
                    or low:find('after ', 1, true)) then

                for _, link in ipairs(find_quests_in_text(sentence, index.names)) do
                    if link.id ~= id then
                        got.prereq[#got.prereq + 1] = link.id
                    end
                end
            end
        end

        return got
    end

    function M.world_lock.status_of(info)
        if info.tracker_area == nil or info.tracker_id == nil then
            return 'not_started'
        end

        local live = tracker.GetQuestStatus ~= nil
            and tracker.GetQuestStatus(info.tracker_area, info.tracker_id)
            or nil
        local saved = quest_status_cache[
            get_status_cache_key(info.tracker_area, info.tracker_id)
        ]

        if live == 'completed' or saved == 'completed' then
            return 'completed'
        end

        if live == 'active' or saved == 'active' then
            return 'active'
        end

        return 'not_started'
    end

    -- The state of one quest for this player:
    --   'completed' / 'active'  as the game reports them (or as saved)
    --   'hidden'                not started, and it needs a level (Lv.N in
    --                           req or in the first step) that the main
    --                           job has not reached
    --   'locked'                not started, and a quest it follows (prereq
    --                           or the first step) is not completed, or the
    --                           fame it needs (req 'Fame N') is higher than
    --                           the fame read from the Fame Checker
    --   'available'             not started, and nothing above applies
    -- A quest that needs a level and a quest is 'hidden'. Rank, skill, job,
    -- mission and pack requirements are not checked.

    -- The nation whose fame a quest needs, for the quests of the four
    -- nations with a Fame Checker (fame.lua keys); the quests of the other
    -- areas are not checked.
    M.world_lock.fame_of_area = {
        sandoria = 'sandoria',
        bastok = 'bastok',
        windurst = 'windurst',
        jeuno = 'jeuno',
    }

    -- true when the quest needs more fame than the player has. false when
    -- it needs none, or when the fame of that nation was not read yet (it
    -- cannot be told, so the quest is not locked).
    function M.world_lock.fame_missing(info)
        if type(info.req) ~= 'string' then
            return false
        end

        local needed = tonumber(info.req:match('[Ff]ame%s*(%d+)'))
        -- A quest of one nation can need the fame of another one (fame_area
        -- in the quest data, e.g. 'norg').
        local key = info.fame_area or M.world_lock.fame_of_area[info.area]
        local have = key ~= nil and M.fame_levels and M.fame_levels[key]

        if needed == nil or not have or not have.level then
            return false
        end

        return have.level < needed
    end

    function M.world_lock.quest_state(index, id)
        local info = index.by_id[id]

        if info == nil then
            return 'available'
        end

        local status = M.world_lock.status_of(info)

        if status ~= 'not_started' then
            return status
        end

        -- Quests that do not work on the server: never available.
        if type(info.req) == 'string'
            and info.req:find('NOT IMPLEMENTED', 1, true) then

            return 'hidden'
        end

        local derived = M.world_lock.derive(index, id)
        local needed = type(info.req) == 'string'
            and tonumber(info.req:match('[Ll][Vv]%.?%s*(%d+)'))
            or nil

        if derived.level ~= nil
            and (needed == nil or derived.level > needed) then

            needed = derived.level
        end

        local level = M.GetPlayerLevel()

        if level ~= nil and needed ~= nil and level < needed then
            return 'hidden'
        end

        if M.world_lock.fame_missing(info) then
            return 'locked'
        end

        local before_ids = {}
        local prereq = index.prereq[id]

        for _, link in ipairs(prereq and prereq.found or {}) do
            before_ids[#before_ids + 1] = link.id
        end

        for _, before_id in ipairs(derived.prereq) do
            before_ids[#before_ids + 1] = before_id
        end

        for _, before_id in ipairs(before_ids) do
            local before = index.by_id[before_id]

            if before_id ~= id and before ~= nil
                and M.world_lock.status_of(before) ~= 'completed' then

                return 'locked'
            end
        end

        return 'available'
    end

    -- true when the quest can be started by this player now (or when that
    -- cannot be told: the quest data is not ready).
    function M.world_lock.available(id)
        local index = build_quest_link_index()

        if index == nil then
            return true
        end

        return M.world_lock.quest_state(index, id) == 'available'
    end

    -- What the arrow over an NPC looks like, by the quests the NPC starts
    -- that are not started yet:
    --   'active'  a quest of the NPC is in progress (green); also the NPC of the
    --             current step of a quest in progress
    --   'normal'  a quest can be started, or the NPC has none
    --   'repeatable'  the NPC has a repeatable quest, in progress or completed,
    --             and no quest that can be started or other in progress (blue)
    --   'locked'  every one waits for a quest that is not completed (grey)
    --   'hidden'  every one needs a level (Lv.N in its req) that the main job
    --             has not reached, or waits for a quest (no arrow until then)
    -- A quest that needs a level and a quest is hidden first. Rank, key item
    -- and job requirements are not checked.
    function M.GetNpcMarkState(name, kind, id)
        local index = build_quest_link_index()

        if index == nil or type(name) ~= 'string' then
            return 'normal'
        end

        local cache = M.world_lock

        if cache.index ~= index then
            cache.index = index
            cache.by_npc = {}

            for id, info in pairs(index.by_id) do
                if type(info.npc) == 'string' then
                    for part in info.npc:gmatch('[^/]+') do
                        local npc = part:match('^%s*(.-)%s*$')

                        if npc ~= '' then
                            local key = zonematch.normalize(npc)
                            local list = cache.by_npc[key] or {}

                            list[#list + 1] = id
                            cache.by_npc[key] = list
                        end
                    end
                end
            end
        end

        -- The NPC of the step of a quest that is in progress (the target of
        -- the compass, or a pin).
        if kind == 'quest' and id ~= nil and index.by_id[id] ~= nil
            and index.by_id[id].repeatable ~= true
            and M.world_lock.status_of(index.by_id[id]) == 'active' then

            return 'active'
        end

        local ids = cache.by_npc[zonematch.normalize(name)]

        if ids == nil then
            return 'normal'
        end

        local locked = false
        local hidden = false
        local repeatable = false
        local free = false

        for _, id in ipairs(ids) do
            local state = M.world_lock.quest_state(index, id)

            if state == 'active' or state == 'completed' then
                -- A repeatable quest, in progress or done, keeps the repeatable
                -- icon; any other quest in progress is green.
                if index.by_id[id].repeatable == true then
                    repeatable = true
                elseif state == 'active' then
                    return 'active'
                end
            elseif state == 'available' then
                free = true
            elseif state == 'locked' then
                locked = true
            elseif state == 'hidden' then
                hidden = true
            end
        end

        -- A quest that can be started wins (yellow); then the repeatable one.
        if free then
            return 'normal'
        end

        if repeatable then
            return 'repeatable'
        end

        if locked then
            return 'locked'
        end

        return hidden and 'hidden' or 'normal'
    end

    function M.IsNpcLocked(name)
        return M.GetNpcMarkState(name) == 'locked'
    end

    -- The start NPCs (fixed position, data/npc_positions.lua) of the quests in
    -- progress that are in the zone the player is in, as rows for
    -- compass.GetMarkPoints. Looked at once a second.
    M.world_lock.rows = nil
    M.world_lock.rows_at = -1000
    M.world_lock.near = {}
    M.world_lock.ACTIVE_RANGE = 45
    M.world_lock.ACTIVE_KEEP = 50

    function M.world_lock.active_rows()
        local lock = M.world_lock
        local now = os.clock()

        if lock.rows ~= nil and now - lock.rows_at < 1.0 then
            return lock.rows
        end

        lock.rows_at = now
        lock.rows = {}

        if compass_api == nil then
            compass_api = M.compass.AshitaApi()
        end

        if compass_api == nil then
            return lock.rows
        end

        local ok, zone = pcall(compass_api.zone)

        zone = ok and tonumber(zone) or nil

        if zone == nil or zone <= 0 then
            return lock.rows
        end

        for _, quest in ipairs(get_active_quests()) do
            if type(quest.npc) == 'string' then
                for part in quest.npc:gmatch('[^/]+') do
                    local name = part:match('^%s*(.-)%s*$')
                    local found = name ~= ''
                        and M.compass.Lookup(name, zone, { x = 0, z = 0 })

                    if found and found.x ~= nil then
                        lock.rows[#lock.rows + 1] = {
                            name = name,
                            status = 'known',
                            pos = { x = found.x, y = found.y, h = found.h },
                            kind = 'quest',
                            id = quest.id,
                        }
                    end
                end
            end
        end

        return lock.rows
    end

    function M.GetWorldMarkActiveColor()
        return { 0.45, 0.90, 0.45, 1.00 }
    end

    function M.GetWorldMarkLockedColor()
        return { 0.62, 0.62, 0.62, 1.00 }
    end

    function M.GetWorldMarkColor()
        return { 1.00, 0.85, 0.40, 1.00 }
    end

    -- The position of the NPC the compass points at (compass.GetMarkPoint).
    -- The state of the compass is updated here too, so the arrow works with
    -- the compass window closed.
    function M.GetWorldMarkPoint()
        M.GetCompassState(os.clock())

        local point = M.compass.GetMarkPoint(compass_api)
        local target = M.compass.GetTarget()

        if point ~= nil and target ~= nil then
            point.kind = target.kind
            point.id = target.id
        end

        return point
    end

    -- The points to draw an arrow over: the target of the compass first,
    -- then (if chosen in the settings) the other NPCs of its list.
    function M.GetWorldMarkPoints()
        local list = {}
        local primary = M.GetWorldMarkPoint()

        if primary ~= nil then
            primary.primary = true
            list[1] = primary
        end

        -- The start NPCs of the quests in progress go first (green), so the
        -- other lists do not repeat them.
        local active_names = {}

        if announce.world_mark_active then
            local skip = {}

            if primary ~= nil then
                skip[#skip + 1] = primary.name
            end

            -- Only the ones within ACTIVE_RANGE yalms (ACTIVE_KEEP once
            -- shown, so the arrow does not blink at the limit).
            local near = M.world_lock.near

            for _, point in ipairs(M.compass.GetMarkPoints(
                compass_api, { M.world_lock.active_rows() }, skip
            )) do
                local dx = point.x - point.me.x
                local dy = point.y - point.me.y
                local limit = near[point.name] and M.world_lock.ACTIVE_KEEP
                    or M.world_lock.ACTIVE_RANGE

                if dx * dx + dy * dy <= limit * limit then
                    near[point.name] = true
                    point.primary = false
                    list[#list + 1] = point
                    active_names[#active_names + 1] = point.name
                else
                    near[point.name] = nil
                end
            end

        end

        if primary ~= nil then
            active_names[#active_names + 1] = primary.name
        end

        if announce.world_mark_all then
            local now = os.clock()
            local others = M.compass.GetMarkPoints(
                compass_api,
                { M.GetCompassNpcRows(now), M.GetCompassPinRows(now) },
                active_names
            )

            for _, point in ipairs(others) do
                point.primary = false
                list[#list + 1] = point
            end
        end

        -- Grey for the NPCs that wait for a quest, none for the ones that
        -- wait for a level.
        local shown = {}

        M.world_lock.hidden = 0

        for _, point in ipairs(list) do
            local state = M.GetNpcMarkState(point.name, point.kind, point.id)

            -- A Fame Checker starts no quest: it has its own icon.
            if M.IsFameChecker(point.name) then
                state = 'fame'
            end

            -- A Gate Guard: the icon of the mission available or not.
            local giver_icon = M.GetMissionGiverIcon(point.name)

            if giver_icon ~= nil then
                state = giver_icon
            end

            if state == 'hidden' then
                M.world_lock.hidden = M.world_lock.hidden + 1
            else
                point.locked = state == 'locked'
                point.state = state
                shown[#shown + 1] = point
            end
        end

        list = shown

        return list
    end

    function M.GetWorldMarkDebug()
        local lines = M.worldmark.DebugLines(M.GetWorldMarkPoint())

        table.insert(lines, 1, 'mark: ' .. (announce.world_mark and 'on' or 'off'))
        table.insert(lines, 2, string.format(
            'no arrow (level too low): %d NPC(s); main job level: %s',
            M.world_lock.hidden or 0, tostring(M.GetPlayerLevel())
        ))

        return lines
    end

    function M.RemoveCompassNpc(index)
        local listed = M.compass.GetNpcs()[index]

        if listed ~= nil and M.compass.IsAutoNpc(index) then
            M.ProxDismiss(listed.name)
        end

        if M.compass.RemoveNpc(index) then
            request_config_save()
        end
    end

    -- now is os.clock(). The rows of the NPCs chosen (see compass.lua).
    function M.GetCompassNpcRows(now)
        if compass_api == nil then
            compass_api = M.compass.AshitaApi()
        end

        return M.compass.UpdateNpcs(now, compass_api)
    end

    -- now is os.clock(). One row for each item pinned in the Tracker whose
    -- current step names an NPC (see compass.lua, M.UpdatePins). The item
    -- that is the target of the compass is not repeated here.
    function M.GetCompassPinRows(now)
        if compass_api == nil then
            compass_api = M.compass.AshitaApi()
        end

        local target = M.compass.GetTarget()
        local target_key = target ~= nil
            and M.compass.PinKey(target.kind, target.id, target.name)
            or nil
        local items = {}
        local valid = {}

        for _, entry in ipairs(pins) do
            local key = M.compass.PinKey(entry.kind, entry.id, entry.name)

            valid[key] = true

            if key ~= target_key then
                local total = #entry.steps
                local step = entry.steps[
                    math.max(1, math.min(entry.step or 1, math.max(total, 1)))
                ]

                if type(step) == 'table' then
                    step = step.text
                end

                items[#items + 1] = {
                    key = key,
                    kind = entry.kind,
                    id = entry.id,
                    name = entry.name,
                    text = step ~= nil and tostring(step) or nil,
                }
            end
        end

        if M.compass.PrunePinHidden(valid) then
            request_config_save()
        end

        return M.compass.UpdatePins(now, items, M.GetStyles(), compass_api)
    end

    -- The "x" of a pin row: it leaves the compass, not the Tracker.
    function M.HideCompassPin(key)
        if M.compass.HidePin(key) then
            request_config_save()
        end
    end

    -- The lines of /journal compass debug.
    function M.GetCompassDebug()
        if compass_api == nil then
            compass_api = M.compass.AshitaApi()
        end

        return M.compass.DebugLines(compass_api)
    end
end

function M.SetPinAutoZone(value)
    pin_auto_zone = value == true
    request_config_save()
end

function M.TogglePinAutoZone()
    M.SetPinAutoZone(not pin_auto_zone)
end

-- Automatic step change on zone change

local function get_zone_index()
    if zone_index ~= nil then
        return zone_index
    end

    local names = {}

    local ok, resources = pcall(function()
        return AshitaCore:GetResourceManager()
    end)

    if not ok or resources == nil then
        return {}
    end

    for id = 1, 511 do
        local got, name = pcall(function()
            return resources:GetString('zones.names', id)
        end)

        if got and type(name) == 'string' and name ~= '' then
            names[id] = name
        end
    end

    local index = zonematch.build_index(names)

    -- Only keep it once the game resources were actually readable.
    if #index > 0 then
        zone_index = index
    end

    return index
end

local function get_current_zone_id()
    local ok, zone = pcall(function()
        local party = AshitaCore:GetMemoryManager():GetParty()

        if party:GetMemberIsActive(0) == 0 then
            return nil
        end

        return party:GetMemberZone(0)
    end)

    if ok and type(zone) == 'number' and zone > 0 then
        return zone
    end

    return nil
end

local function check_zone_change()
    local now = os.clock()

    if now - zone_check_time < 0.5 then
        return
    end

    zone_check_time = now

    local zone = get_current_zone_id()

    if zone == nil or zone == last_zone_id then
        return
    end

    local previous = last_zone_id
    last_zone_id = zone

    -- The quests of the new zone are checked a little later, when the
    -- game has sent the quest log.
    announce.near_pending = { zone = zone, at = os.clock() }

    -- The first reading only sets the baseline.
    if previous == nil
        or not pin_auto_zone
        or #pins == 0 then

        return
    end

    local changed = false

    for _, entry in ipairs(pins) do
        local total = #entry.steps
        local current = math.max(1, math.min(entry.step, math.max(total, 1)))

        if current < total
            and zonematch.step_completed_by_zone(
                tostring(entry.steps[current] or ''),
                zone,
                get_zone_index()
            ) then

            advance_pin(entry)
            changed = true

            print(string.format(
                i18n.t('[Journal] %s: step %d/%d.'),
                entry.name,
                entry.step,
                total
            ))
        end
    end

    if changed then
        request_config_save()
    end
end

-- Zone names for the bold place names in step text. Safe to call every
-- frame: when the game resources cannot be read it only retries every
-- few seconds.
local zone_index_state = { retry_at = 0, empty = {} }

function M.GetZoneIndex()
    if zone_index ~= nil then
        return zone_index
    end

    local now = os.clock()

    if now < zone_index_state.retry_at then
        return zone_index_state.empty
    end

    local index = get_zone_index()

    if #index == 0 then
        zone_index_state.retry_at = now + 5
        return zone_index_state.empty
    end

    return index
end

-- Name lists for the styled step text: zones (read from the game), other
-- places, monsters, characters and objects. Each is a file in data/.
local style_lists = {}

local function load_name_index(module_name, min_length)
    if style_lists[module_name] == nil then
        local ok, names = pcall(require, module_name)
        local list = {}

        if ok and type(names) == 'table' then
            for index, name in ipairs(names) do
                list[index] = name
            end
        end

        style_lists[module_name] = zonematch.build_index(list, min_length)
    end

    return style_lists[module_name]
end

-- The list for richtext. It is rebuilt when the zone names finish loading
-- so the text cache notices the change; otherwise it is always the same
-- table. The order is the priority when two names are the same length.
local style_cache = nil

function M.GetStyles()
    local zones = M.GetZoneIndex()

    if style_cache == nil or style_cache.zones ~= zones then
        style_cache = {
            zones = zones,
            styles = {
                { index = zones, kind = 'bold' },
                { index = load_name_index('data.places', 4), kind = 'italic' },
                { index = load_name_index('data.monsters', 3), kind = 'monster' },
                -- 3 letters is enough for names such as Cid and Pius.
                { index = load_name_index('data.npcs', 3), kind = 'npc' },
                { index = load_name_index('data.items', 3), kind = 'item' },
            },
        }
    end

    return style_cache.styles
end

-- Pinned items that finish are cleaned up automatically.
-- A finished quest is unpinned; a finished mission is replaced by the
-- next one in its list.

local function prune_completed_pins(kind)
    local changed = false
    local index = 1

    while index <= #pins do
        local entry = pins[index]
        local advance = true

        if entry.kind == kind then
            if kind == 'quest' then
                local _, quest = find_quest_in_lists(entry.id, entry.name)

                if quest ~= nil and quest.status == 'completed' then
                    step_marks[
                        marks_key(entry.kind, entry.id, entry.name)
                    ] = nil

                    table.remove(pins, index)
                    advance = false
                    changed = true
                end
            else
                local area, mission, mission_index =
                    find_mission_in_lists(entry.id, entry.name)

                if area ~= nil
                    and mission ~= nil
                    and mission.status == 'completed' then

                    step_marks[
                        marks_key(entry.kind, entry.id, entry.name)
                    ] = nil

                    local next_mission =
                        find_next_mission(area, mission_index)

                    if next_mission ~= nil
                        and find_pin(
                            'mission',
                            next_mission.id,
                            next_mission.name
                        ) == nil then

                        local replacement = {
                            kind = 'mission',
                            id = tostring(next_mission.id),
                            name = tostring(next_mission.name or ''),
                            steps = serialize_steps(next_mission.steps or {}),
                            step = 1,
                        }

                        replacement.step =
                            first_undone(
                                replacement.kind,
                                replacement.id,
                                replacement.name,
                                replacement.steps
                            )

                        pins[index] = replacement
                    else
                        table.remove(pins, index)
                        advance = false
                    end

                    changed = true
                end
            end
        end

        if advance then
            index = index + 1
        end
    end

    if changed then
        clamp_pin_active()
        request_config_save()
    end
end

-- Commands

function M.HandleCommand(e)
    local args = e.command:args()

    if #args == 0
        or args[1]:lower()
            ~= '/journal' then

        return
    end

    e.blocked = true

    if #args == 1 then
        M.SetJournalMode(1)
        M.ShowJournal()
        return
    end

    local command =
        args[2]:lower()

    if command == 'help' then
        M.ToggleHelp()

        print(i18n.t('[Journal] Commands:'))
        print(i18n.t('/journal - Open Mission Journal'))
        print(i18n.t('/journal help - Show help'))
        print(i18n.t('/journal settings - Open the settings window'))
        print(i18n.t('/journal guide - Open the guide for new adventurers'))
        print(i18n.t('/journal camps - Open the camps guide'))
        print(i18n.t('/journal notes - Open your general notes'))
        print(i18n.t('/journal active - Open the Active Now window'))
        print(i18n.t('/journal favorites - Open your favorites'))
        print(i18n.t('/journal compass [off|reset|debug] - Show or hide the compass (reset: fit the window to its content)'))
        print(i18n.t('/journal mark [on|off|debug] - Arrow over the NPC of the compass in the game (prototype)'))
        print(i18n.t('/journal alert [quest|mission] [done] - Preview the alerts'))
        print(i18n.t('/journal quest - Open Quest Journal'))
        print(i18n.t('/journal pin - Toggle pinned tracker'))
        print(i18n.t('/journal pin add - Pin the item selected in the Journal'))
        print(i18n.t('/journal pin remove <n> | clear - Unpin items'))
        print(i18n.t('/journal pin mode [stacked|tabs] - Tracker layout'))
        print(i18n.t('/journal pin size [+|-|reset|<value>] - Tracker size (0.60x-2.00x)'))
        print(i18n.t('/journal pin next|prev|reset|<n> - Change step of the active item'))
        print(i18n.t('/journal pin zone [on|off] - Auto step change on zone change'))
        print(i18n.t('/journal pin auto [on|off] - Pin the active quests automatically'))
        print(i18n.t('/journal pin preview [on|off] - Show the next step in the tracker'))
        print(i18n.t('/journal lang [en|es] - Language of the Journal (English or Spanish)'))

        return
    end

    if command == 'settings' then
        M.ToggleSettings()
        return
    end

    if command == 'guide' then
        M.ToggleGuide()
        return
    end

    if command == 'camps' then
        M.ToggleCamps()
        return
    end

    if command == 'notes' then
        M.notes.Toggle()
        return
    end

    if command == 'active' or command == 'favorites' then
        -- The window goes away with the Journal, so the Journal is opened.
        M.SetActiveOpen(true, command == 'favorites' and 'favorites' or 'active')
        M.ShowJournal()

        return
    end

    if command == 'compass' then
        local option = args[3] and args[3]:lower() or ''

        if option == 'off' then
            M.ClearCompassTarget()
            M.SetCompassOpen(false)
        elseif option == 'reset' then
            M.SetCompassSize(nil, nil)
        elseif option == 'debug' then
            for _, line in ipairs(M.GetCompassDebug()) do
                print('[Journal] ' .. line)
            end
        else
            M.SetCompassOpen(not M.GetCompassOpen())
        end

        return
    end

    if command == 'mark' then
        local option = args[3] and args[3]:lower() or ''

        if option == 'on' then
            M.SetWorldMark(true)
        elseif option == 'off' then
            M.SetWorldMark(false)
        elseif option == 'debug' then
            for _, line in ipairs(M.GetWorldMarkDebug()) do
                print('[Journal] ' .. line)
            end
        else
            M.SetWorldMark(not M.GetWorldMark())
        end

        print('[Journal] Arrow over the compass NPC: '
            .. (M.GetWorldMark() and 'on' or 'off'))

        return
    end

    if command == 'alert' then
        local value = args[3] and args[3]:lower() or 'quest'
        local last = args[4] and args[4]:lower() or value

        M.PreviewAnnouncement(
            value == 'mission' and 'mission' or 'quest',
            last == 'done'
        )

        return
    end

    if command == 'lang' or command == 'language' then
        local value = args[3] and args[3]:lower() or nil

        if value == 'es' or value == 'spanish' then
            M.SetLanguage('es')
        elseif value == 'en' or value == 'english' then
            M.SetLanguage('en')
        else
            M.ToggleLanguage()
        end

        print(string.format(
            i18n.t('[Journal] Language: %s.'),
            (language == 'es' and 'Espanol' or 'English')
        ))

        return
    end

    if command == 'pin' then
        local sub = args[3] and args[3]:lower() or nil
        local value = args[4] and args[4]:lower() or nil

        if sub == nil then
            M.TogglePinVisible()
        elseif sub == 'add' then
            local added = M.PinSelected()

            print(string.format(
                i18n.t('[Journal] Pinned %d item(s) from the Journal.'),
                added
            ))
        elseif sub == 'remove' then
            if tonumber(value) == nil
                or not M.RemovePin(tonumber(value)) then

                print(i18n.t('[Journal] Usage: /journal pin remove <n>'))
            end
        elseif sub == 'clear' then
            M.ClearPins()
        elseif sub == 'mode' then
            if value == 'tabs' or value == 'stacked' then
                M.SetPinMode(value)
            else
                M.TogglePinMode()
            end

            print(string.format(
                i18n.t('[Journal] Tracker mode: %s.'),
                pin_mode
            ))
        elseif sub == 'next' then
            M.NextPinStep(pin_active)
        elseif sub == 'prev' then
            M.PrevPinStep(pin_active)
        elseif sub == 'reset' then
            M.SetPinStep(pin_active, 1)
        elseif sub == 'size' then
            if value == '+' or value == 'up' then
                M.AdjustPinScale(1)
            elseif value == '-' or value == 'down' then
                M.AdjustPinScale(-1)
            elseif value == 'reset' then
                M.SetPinScale(1.0)
            elseif tonumber(value) ~= nil then
                M.SetPinScale(tonumber(value))
            end

            print(string.format(
                i18n.t('[Journal] Tracker size: %.2fx (%.2f-%.2f).'),
                pin_scale,
                PIN_SCALE_MIN,
                PIN_SCALE_MAX
            ))
        elseif sub == 'zone' then
            if value == 'on' then
                M.SetPinAutoZone(true)
            elseif value == 'off' then
                M.SetPinAutoZone(false)
            else
                M.TogglePinAutoZone()
            end

            print(string.format(
                i18n.t('[Journal] Auto step change on zone change: %s.'),
                i18n.t(pin_auto_zone and 'ON' or 'OFF')
            ))
        elseif sub == 'auto' then
            if value == 'on' then
                M.SetAutoPinQuests(true)
            elseif value == 'off' then
                M.SetAutoPinQuests(false)
            else
                M.ToggleAutoPinQuests()
            end

            print(string.format(
                i18n.t('[Journal] Automatic pins of the active quests: %s.'),
                i18n.t(auto_pin_quests and 'ON' or 'OFF')
            ))
        elseif sub == 'preview' then
            if value == 'on' then
                M.SetPinShowNext(true)
            elseif value == 'off' then
                M.SetPinShowNext(false)
            else
                M.TogglePinShowNext()
            end

            print(string.format(
                i18n.t('[Journal] Tracker shows the next step: %s.'),
                i18n.t(pin_show_next and 'ON' or 'OFF')
            ))
        elseif tonumber(sub) ~= nil then
            M.SetPinStep(pin_active, tonumber(sub))
        else
            print(i18n.t('[Journal] Usage: /journal pin [add|remove <n>|clear|mode|size|next|prev|reset|zone|auto|preview|<n>]'))
        end

        return
    end

    if command == 'quest' then
        M.SetJournalMode(2)
        M.ShowJournal()
    end
end

-- New quests and missions.
--
-- Every time the data of the game settles, the quests and missions that are
-- active are compared with the ones that were active the last time. Those
-- that were not are new. The first comparison only records what is active
-- (what the character already had at login is not new), and so does a
-- change of more than a few items at once, which is a reload of the data and
-- not something the player did.

local ANNOUNCE_QUIET = 0.6
local ANNOUNCE_ARM_DELAY = 5
local ANNOUNCE_MAX_AT_ONCE = 3
local ANNOUNCE_QUEUE_MAX = 4
local NEAR_MAX_NAMES = 3
local NEAR_GIVE_UP = 90

local announce_known = nil
local announce_known_order = {}
local announce_armed_at = 0
local announce_due = false
local announce_queue = {}

-- Everything that is active now: key -> entry, and the keys in order.
local function collect_active_entries()
    local found = {}
    local order = {}

    for _, category in ipairs(get_quest_categories()) do
        for _, quest in ipairs(get_quest_list_from_tracker(category)) do
            if quest.id ~= nil
                and quest.trackable ~= false
                and quest.tracker_area ~= nil
                and quest.tracker_id ~= nil
                and tracker.GetQuestStatus ~= nil
                and tracker.GetQuestStatus(
                    quest.tracker_area,
                    quest.tracker_id
                ) == 'active' then

                local key =
                    'quest:' .. tostring(quest.tracker_area)
                    .. '_' .. tostring(quest.tracker_id)

                if found[key] == nil then
                    found[key] = {
                        kind = 'quest',
                        id = quest.id,
                        name = quest.name,
                        steps = quest.steps,
                        tracker_area = quest.tracker_area,
                        tracker_id = quest.tracker_id,
                    }

                    order[#order + 1] = key
                end
            end
        end
    end

    for _, area in ipairs(mission_areas) do
        for _, mission in ipairs(tracker.GetMissionArea(area) or {}) do
            if tracker.GetMissionStatus ~= nil
                and tracker.GetMissionStatus(area, mission.id) == 'active' then

                local key =
                    'mission:' .. area .. '_' .. tostring(mission.id)

                if found[key] == nil then
                    found[key] = {
                        kind = 'mission',
                        id = mission.id,
                        name = mission.name,
                        steps = mission.steps,
                        area = area,
                    }

                    order[#order + 1] = key
                end
            end
        end
    end

    return found, order
end

-- True when something that was active has been completed.
local function is_completed_now(entry)
    if entry.kind == 'quest' then
        return tracker.GetQuestStatus ~= nil
            and tracker.GetQuestStatus(
                entry.tracker_area,
                entry.tracker_id
            ) == 'completed'
    end

    return tracker.GetMissionStatus ~= nil
        and tracker.GetMissionStatus(entry.area, entry.id) == 'completed'
end

local function detect_new_entries()
    local found, order = collect_active_entries()

    if announce_known == nil then
        announce_known = found
        announce_known_order = order
        announce_armed_at = os.clock() + ANNOUNCE_ARM_DELAY

        return
    end

    local queued = {}

    -- Completed: it was active the last time and now it is completed.
    for _, key in ipairs(announce_known_order) do
        if found[key] == nil then
            local entry = announce_known[key]

            if is_completed_now(entry) then
                queued[#queued + 1] = {
                    kind = entry.kind,
                    id = entry.id,
                    name = entry.name,
                    steps = entry.steps,
                    done = true,
                }
            end
        end
    end

    -- New: active now and not the last time.
    for _, key in ipairs(order) do
        if announce_known[key] == nil then
            queued[#queued + 1] = found[key]
        end
    end

    announce_known = found
    announce_known_order = order

    if #queued == 0
        or #queued > ANNOUNCE_MAX_AT_ONCE
        or os.clock() < announce_armed_at
        or not announce.enabled then

        return
    end

    for _, entry in ipairs(queued) do
        if #announce_queue < ANNOUNCE_QUEUE_MAX then
            announce_queue[#announce_queue + 1] = entry
        end
    end
end

-- Called when the data of the game may have changed. The check waits until
-- no packet has arrived for a moment.
local function check_new_entries(touched)
    if touched then
        announce_due = true
    end

    if not announce_due then
        return
    end

    local last_touch = math.max(
        tracker.GetMissionLastTouch ~= nil
            and tracker.GetMissionLastTouch() or 0,
        tracker.GetQuestLastTouch ~= nil
            and tracker.GetQuestLastTouch() or 0
    )

    if os.clock() - last_touch >= ANNOUNCE_QUIET then
        announce_due = false
        detect_new_entries()
    end
end

function M.GetAnnounceEnabled()
    return announce.enabled
end

function M.SetAnnounceEnabled(value)
    announce.enabled = value == true

    if not announce.enabled then
        announce_queue = {}
    end

    request_config_save()
end

function M.GetAnnounceSound()
    return announce.sound
end

function M.SetAnnounceSound(value)
    announce.sound = value == true
    request_config_save()
end

function M.GetAnnounceAsk()
    return announce.ask
end

function M.SetAnnounceAsk(value)
    announce.ask = value == true
    request_config_save()
end

-- The next alert to show, or nil. It says if the banner asks about pinning:
-- not when the setting is off or the item is already pinned. A completed
-- item never asks.
function M.TakeAnnouncement()
    local entry = table.remove(announce_queue, 1)

    if entry == nil then
        return nil
    end

    if entry.near then
        local shown = {}
        local shown_ids = entry.ids ~= nil and {} or nil

        for index = 1, math.min(#entry.names, NEAR_MAX_NAMES) do
            shown[index] = entry.names[index]

            if shown_ids ~= nil then
                shown_ids[index] = entry.ids[index]
            end
        end

        return {
            kind = 'quest',
            near = true,
            progress = entry.progress == true,
            name = entry.name,
            names = shown,
            ids = shown_ids,
            more = math.max(0, #entry.names - NEAR_MAX_NAMES),
            ask = false,
        }
    end

    if entry.done then
        return {
            kind = entry.kind,
            id = entry.id,
            name = entry.name,
            steps = entry.steps,
            ask = false,
            done = true,
        }
    end

    local pinned = M.IsPinned(entry.kind, entry)

    return {
        kind = entry.kind,
        id = entry.id,
        name = entry.name,
        steps = entry.steps,
        ask = announce.ask and not pinned and entry.real ~= false,
        note = pinned and 'Already in the Tracker' or nil,
    }
end

-- The answer "pin it" of the alert.
function M.AnnouncePin(entry)
    if entry == nil
        or entry.real == false
        or entry.done
        or M.IsPinned(entry.kind, entry) then

        return false
    end

    return M.ToggleItemPin(entry.kind, entry)
end

-- Shows the alert for the item selected in the Journal (a preview).
function M.PreviewAnnouncement(kind, done)
    local item

    if kind == 'mission' then
        item = M.GetSelectedMission()
    else
        kind = 'quest'
        item = M.GetSelectedQuest()
    end

    if item == nil then
        item = {
            id = 0,
            name = kind == 'mission' and 'Sample Mission' or 'Sample Quest',
            steps = {},
            real = false,
        }
    end

    announce_queue[#announce_queue + 1] = {
        kind = kind,
        id = item.id,
        name = item.name,
        steps = item.steps,
        real = item.real,
        done = done == true or nil,
    }
end

-- The look of the alerts. group is 'new' or 'done'.
function M.GetAlertPalette()
    return ALERT_PALETTE
end

function M.GetAlertStyle(group)
    return announce.style[group] or announce.style.new
end

function M.SetAlertOpacity(group, value)
    local style = announce.style[group]

    if style == nil then
        return nil
    end

    local opacity =
        clamp_opacity(value, 0.0, 1.0, style.opacity)

    if opacity ~= style.opacity then
        style.opacity = opacity
        request_config_save()
    end

    return style.opacity
end

function M.AdjustAlertOpacity(group, direction)
    local style = announce.style[group]

    if style == nil then
        return nil
    end

    return M.SetAlertOpacity(group, style.opacity + direction * OPACITY_STEP)
end

function M.SetAlertSize(group, value)
    local style = announce.style[group]
    local size = tonumber(value)

    if style == nil or size == nil then
        return nil
    end

    -- Rounded to a tenth, so the percent shown is always clean.
    size = math.floor(size * 10 + 0.5) / 10
    size = math.max(ALERT_SIZE_MIN, math.min(ALERT_SIZE_MAX, size))

    if size ~= style.size then
        style.size = size
        request_config_save()
    end

    return style.size
end

function M.AdjustAlertSize(group, direction)
    local style = announce.style[group]

    if style == nil then
        return nil
    end

    return M.SetAlertSize(group, style.size + direction * 0.1)
end

function M.SetAlertColor(group, index)
    local style = announce.style[group]
    local color = math.floor(tonumber(index) or 0)

    if style == nil or color < 0 or color > #ALERT_PALETTE then
        return nil
    end

    if color ~= style.color then
        style.color = color
        request_config_save()
    end

    return style.color
end

-- The alert tried from the settings window. It stays on the screen while
-- the settings window is open, so the look can be changed in front of it.
function M.StartAlertTest(kind, done)
    announce.test_token = announce.test_token + 1

    announce.test = {
        near = kind == 'near' or kind == 'progress',
        progress = kind == 'progress',
        kind = kind == 'mission' and 'mission' or 'quest',
        done = done == true,
        token = announce.test_token,
    }
end

function M.StopAlertTest()
    announce.test = nil
end

function M.GetAlertTest()
    if not settings_open then
        announce.test = nil
    end

    return announce.test
end


-- Quests in progress in the zone the player just entered. Only quests have a
-- zone in the data (missions do not).
local function get_zone_name(id)
    local ok, name = pcall(function()
        return AshitaCore:GetResourceManager():GetString('zones.names', id)
    end)

    if ok and type(name) == 'string' and name ~= '' then
        return name
    end

    return nil
end

-- Names of the quests in progress that belong to the zone: the zone of the
-- quest is the one entered, or the NPC of the quest is in it (known position).
-- Returns the names and the ids.
local function find_progress_quests(zone_id, zone_name)
    local wanted = zonematch.normalize(zone_name)
    local names = {}
    local ids = {}
    local seen = {}

    for _, quest in ipairs(get_active_quests()) do
        local here = quest.zone ~= nil
            and zonematch.normalize(quest.zone) == wanted

        if not here and type(quest.npc) == 'string' then
            for part in quest.npc:gmatch('[^/]+') do
                local name = part:match('^%s*(.-)%s*$')
                local found = name ~= ''
                    and M.compass.Lookup(name, zone_id, { x = 0, z = 0 })

                if found and found.x ~= nil then
                    here = true

                    break
                end
            end
        end

        if here and not seen[quest.id] then
            seen[quest.id] = true
            names[#names + 1] = quest.name
            ids[#ids + 1] = quest.id
        end
    end

    return names, ids
end

local function check_near_quests()
    local pending = announce.near_pending

    if pending == nil then
        return
    end

    if os.clock() - pending.at > NEAR_GIVE_UP then
        announce.near_pending = nil

        return
    end

    -- Wait for the quest log: the first check of the new-quest alert has
    -- been made, and no packet has arrived for a moment.
    if announce_known == nil
        or os.clock() < announce_armed_at
        or announce_due then

        return
    end

    announce.near_pending = nil

    if not announce.near or not announce.enabled then
        return
    end

    local zone_name = get_zone_name(pending.zone)

    if zone_name == nil then
        return
    end

    local names, ids = find_progress_quests(pending.zone, zone_name)

    if #names > 0 and #announce_queue < ANNOUNCE_QUEUE_MAX then
        announce_queue[#announce_queue + 1] = {
            kind = 'quest',
            near = true,
            progress = true,
            names = names,
            ids = ids,
            name = zone_name,
        }
    end
end

-- Proximity alert: the player is within PROX_RADIUS of an NPC (fixed
-- position, data/npc_positions.lua) who starts a quest that is not started.
-- Once for each NPC in each visit to a zone. Kept in one table (the chunk is
-- at the limit of locals). The quest field "npc" may hold several names
-- separated by "/".
do
    local PROX_RADIUS = 30
    local PROX_INTERVAL = 1.0
    local prox = { keep = 35, radius = 30, zone = nil, list = nil, shown = {}, at = 0, last_count = 0, auto = {}, dismissed = {} }

    local function build(zone)
        local by_npc = {}
        local list = {}

        for _, category in ipairs(get_quest_categories()) do
            for _, quest in ipairs(get_quest_list_from_tracker(category)) do
                if type(quest.npc) == 'string'
                    and quest.trackable ~= false
                    and quest.tracker_area ~= nil
                    and quest.tracker_id ~= nil then

                    for part in quest.npc:gmatch('[^/]+') do
                        local name = part:match('^%s*(.-)%s*$')
                        local found = name ~= '' and M.compass.Lookup(name, zone, { x = 0, z = 0 })

                        if found and found.x ~= nil then
                            local key = zonematch.normalize(name)
                            local row = by_npc[key]

                            if row == nil then
                                row = { name = name, x = found.x, y = found.y, quests = {} }
                                by_npc[key] = row
                                list[#list + 1] = row
                            end

                            row.quests[#row.quests + 1] = quest
                        end
                    end
                end
            end
        end

        -- The Gate Guards give the missions: they go to the compass when
        -- the player is close (row.mission, no quests).
        for _, names in pairs(M.mission_givers.areas) do
            for _, npc in ipairs(names) do
                local key = zonematch.normalize(npc)
                local found = by_npc[key] == nil
                    and M.compass.Lookup(npc, zone, { x = 0, z = 0 })

                if found and found.x ~= nil then
                    local row = {
                        name = npc, x = found.x, y = found.y,
                        quests = {}, mission = true,
                    }

                    by_npc[key] = row
                    list[#list + 1] = row
                end
            end
        end

        -- The Fame Checkers start no quest, but they go to the compass like
        -- the others when the player is close (row.fame, no quests).
        local ok_fame, fame_areas = pcall(function()
            return require('fame').AREAS
        end)

        for _, area in ipairs(ok_fame and fame_areas or {}) do
            for _, checker in ipairs(area.checkers) do
                local key = zonematch.normalize(checker.npc)
                local found = by_npc[key] == nil
                    and M.compass.Lookup(checker.npc, zone, { x = 0, z = 0 })

                if found and found.x ~= nil then
                    local row = {
                        name = checker.npc, x = found.x, y = found.y,
                        quests = {}, fame = true,
                    }

                    by_npc[key] = row
                    list[#list + 1] = row
                end
            end
        end

        return list
    end

    -- The quests of the NPC that are not started, { { name =, id = } }, or
    -- nil. With with_active the quests in progress come first, with
    -- active = true (the NPC is marked in the compass for them too), and the
    -- completed repeatable quests go last.
    function prox.start_names(row, with_active)
        local list = {}
        local seen = {}

        if with_active then
            for _, quest in ipairs(row.quests) do
                if not seen[quest.id]
                    and M.world_lock.status_of(quest) == 'active' then

                    seen[quest.id] = true
                    list[#list + 1] = {
                        name = quest.name, id = quest.id, active = true,
                        repeatable = quest.repeatable == true,
                    }
                end
            end
        end

        for _, quest in ipairs(row.quests) do
            if not seen[quest.id]
                and tracker.GetQuestStatus(quest.tracker_area, quest.tracker_id) == 'not_started'
                and M.world_lock.available(quest.id) then

                seen[quest.id] = true
                list[#list + 1] = {
                    name = quest.name, id = quest.id,
                    repeatable = quest.repeatable == true,
                }
            end
        end

        -- With with_active, the repeatable quests that are completed also
        -- keep the NPC in the compass (they can be done again).
        if with_active then
            for _, quest in ipairs(row.quests) do
                if not seen[quest.id]
                    and quest.repeatable == true
                    and M.world_lock.status_of(quest) == 'completed' then

                    seen[quest.id] = true
                    list[#list + 1] = {
                        name = quest.name, id = quest.id, repeatable = true,
                    }
                end
            end
        end

        return #list > 0 and list or nil
    end

    function prox.drop_auto(zone)
        for name in pairs(prox.auto) do
            M.compass.RemoveAutoNpc(name, zone)
            prox.auto[name] = nil
        end
    end

    -- The NPCs in range with quests to start go to the compass list, and
    -- leave it when they are out of range (PROX_KEEP, wider so they do not
    -- flicker), when the quests are started, or when the zone changes.
    function prox.sync_compass(zone, me)
        local cands = {}

        for _, row in ipairs(prox.list) do
            local dx = me.x - row.x
            local dy = me.z - row.y
            local d2 = dx * dx + dy * dy
            local limit = prox.auto[row.name] and prox.keep or prox.radius
            local names = nil

            if d2 <= limit * limit and not prox.dismissed[row.name] then
                -- A Fame Checker or a Gate Guard has no quests to list.
                names = (row.fame or row.mission) and {}
                    or prox.start_names(row, true)
            end

            if names ~= nil then
                cands[#cands + 1] = { row = row, d2 = d2, quests = names }
            end
        end

        table.sort(cands, function(a, b) return a.d2 < b.d2 end)

        -- At most 3 automatic NPCs, the closest ones, so the list keeps
        -- room for the ones chosen by hand (the list holds 5).
        local want = {}
        local count = 0

        for _, item in ipairs(cands) do
            local name = item.row.name

            if prox.auto[name] then
                if count < 3 then
                    want[name] = true
                    count = count + 1
                    M.compass.SetAutoQuests(name, zone, item.quests)
                end
            end
        end

        for _, item in ipairs(cands) do
            local name = item.row.name

            if count < 3 and not prox.auto[name] and not want[name]
                and M.compass.AddNpc(name, zone, true, item.quests) then

                prox.auto[name] = true
                want[name] = true
                count = count + 1

                -- The compass opens by itself when it was closed.
                M.SetCompassOpen(true)
            end
        end

        for name in pairs(prox.auto) do
            if not want[name] then
                M.compass.RemoveAutoNpc(name, zone)
                prox.auto[name] = nil
            end
        end
    end

    -- The player removed an NPC of the compass list: if it was an automatic
    -- one, it is not added again in this zone.
    function M.ProxDismiss(name)
        if prox.auto[name] then
            prox.auto[name] = nil
            prox.dismissed[name] = true
        end
    end

    function M.CheckProximity(now, api)
        if not (announce.prox and announce.enabled) and not announce.prox_compass
            or now - prox.at < PROX_INTERVAL
            or announce_known == nil or now < announce_armed_at
            or announce_due or api == nil then

            return
        end

        prox.at = now

        local ok_zone, zone = pcall(api.zone)
        local ok_me, me = pcall(api.me)

        zone = ok_zone and tonumber(zone) or nil

        if zone == nil or zone <= 0 or not ok_me or me == nil then
            return
        end

        if prox.zone ~= zone then
            prox.drop_auto(prox.zone)
            prox.zone = zone
            prox.list = nil
            prox.shown = {}
            prox.dismissed = {}
            prox.last_count = 0
        end

        if prox.list == nil then
            prox.list = build(zone)
        end

        if announce.prox_compass then
            prox.sync_compass(zone, me)
        end

        if not (announce.prox and announce.enabled)
            or #announce_queue >= ANNOUNCE_QUEUE_MAX then

            return
        end

        -- Every NPC in range with quests to start goes in one alert, the
        -- closest first. An NPC with none is marked as shown. The alert is
        -- made when the group is the same in two checks in a row, so NPCs
        -- close to each other do not make separate alerts.
        local found = {}

        for _, row in ipairs(prox.list) do
            local dx = me.x - row.x
            local dy = me.z - row.y
            local d2 = dx * dx + dy * dy

            if not prox.shown[row.name] and d2 <= PROX_RADIUS * PROX_RADIUS then
                local names = {}
                local ids = {}
                local seen = {}

                for _, quest in ipairs(row.quests) do
                    local key = tostring(quest.tracker_area) .. '_' .. tostring(quest.tracker_id)

                    if not seen[key] and tracker.GetQuestStatus(
                        quest.tracker_area, quest.tracker_id) == 'not_started'
                        and M.world_lock.available(quest.id) then

                        seen[key] = true
                        names[#names + 1] = quest.name
                        ids[#ids + 1] = quest.id
                    end
                end

                if #names == 0 then
                    prox.shown[row.name] = true
                else
                    found[#found + 1] = {
                        row = row, names = names, ids = ids, d2 = d2,
                    }
                end
            end
        end

        if #found == 0 then
            prox.last_count = 0

            return
        end

        if prox.last_count ~= #found then
            prox.last_count = #found

            return
        end

        prox.last_count = 0
        table.sort(found, function(a, b) return a.d2 < b.d2 end)

        for _, item in ipairs(found) do
            prox.shown[item.row.name] = true
        end

        if #found == 1 then
            announce_queue[#announce_queue + 1] = {
                kind = 'quest', near = true,
                names = found[1].names, ids = found[1].ids,
                name = found[1].row.name,
            }

            return
        end

        -- Several NPCs: one line for each, "NPC: first quest (+n)".
        local lines = {}
        local line_ids = {}

        for _, item in ipairs(found) do
            -- A click on the line opens the sheet of its first quest.
            line_ids[#line_ids + 1] = item.ids[1]

            local line = item.row.name .. ': ' .. item.names[1]

            if #item.names > 1 then
                line = line .. ' (+' .. (#item.names - 1) .. ')'
            end

            lines[#lines + 1] = line
        end

        announce_queue[#announce_queue + 1] = {
            kind = 'quest', near = true, names = lines, ids = line_ids,
            name = get_zone_name(zone) or found[1].row.name,
        }
    end

    function M.GetProxEnabled()
        return announce.prox
    end

    function M.GetProxCompass()
        return announce.prox_compass
    end

    function M.SetProxCompass(value)
        announce.prox_compass = value == true

        if not announce.prox_compass then
            prox.drop_auto(prox.zone)
        end

        request_config_save()
    end

    function M.SetProxEnabled(value)
        announce.prox = value == true
        request_config_save()
    end
end

function M.GetNearEnabled()
    return announce.near
end

function M.SetNearEnabled(value)
    announce.near = value == true
    request_config_save()
end

-- Automatic pins of the active quests.
local function reconcile_auto_pins()
    if not tracker_is_ready() then
        return false
    end

    local active = get_active_quests()
    local active_ids = {}

    for _, quest in ipairs(active) do
        active_ids[tostring(quest.id)] = true
    end

    local changed = false

    -- A dismissed quest is forgotten once it is no longer active, so it can
    -- be pinned again the next time it becomes active.
    for id in pairs(auto_pin_dismissed) do
        if not active_ids[id] then
            auto_pin_dismissed[id] = nil
            changed = true
        end
    end

    if auto_pin_quests then
        -- The automatic pins of quests that are not active any more go away.
        local index = 1

        while index <= #pins do
            local pin = pins[index]

            if pin.auto == true
                and pin.kind == 'quest'
                and not active_ids[pin.id] then

                table.remove(pins, index)
                changed = true
            else
                index = index + 1
            end
        end

        -- Pin the active ones, while there is room (no message when the
        -- Tracker is full).
        for _, quest in ipairs(active) do
            local id = tostring(quest.id)

            if #pins >= PIN_MAX then
                break
            end

            if not auto_pin_dismissed[id]
                and find_pin('quest', id, quest.name) == nil then

                local automatic = {
                    kind = 'quest',
                    id = id,
                    name = tostring(quest.name or ''),
                    steps = serialize_steps(quest.steps or {}),
                    step = 1,
                    auto = true,
                }

                automatic.step =
                    first_undone(
                        automatic.kind,
                        automatic.id,
                        automatic.name,
                        automatic.steps
                    )

                pins[#pins + 1] = automatic

                changed = true
            end
        end
    end

    if changed then
        clamp_pin_active()
        request_config_save()
    end

    return changed
end

function M.GetAutoPinQuests()
    return auto_pin_quests
end

function M.SetAutoPinQuests(value)
    value = value == true

    if value == auto_pin_quests then
        return
    end

    auto_pin_quests = value

    if value then
        -- Turning it on starts from nothing dismissed.
        auto_pin_dismissed = {}
        reconcile_auto_pins()
    else
        -- The pins that were automatic stay, as normal pins.
        for _, pin in ipairs(pins) do
            pin.auto = nil
        end
    end

    request_config_save()
end

function M.ToggleAutoPinQuests()
    M.SetAutoPinQuests(not auto_pin_quests)
end

-- Lifecycle

function M.Initialize()
    M.notes.Load()
    tracker.Initialize()
    apply_config()
    validate_state()
end

function M.Load()
    apply_config()
    validate_state()

    invalidate_mission_cache()
    invalidate_quest_cache()

    if tracker_is_ready() then
        sync_mission_status_cache()
        sync_quest_status_cache()

        if tracker.ClearMissionDirty ~= nil then
            tracker.ClearMissionDirty()
        end

        if tracker.ClearQuestDirty ~= nil then
            tracker.ClearQuestDirty()
        end

        rebuild_mission_cache()
        reconcile_auto_pins()
    end
end

function M.Update()
    check_zone_change()

    if not tracker_is_ready() then
        update_config_save()
        return
    end

    local mission_dirty =
        tracker.IsMissionDirty ~= nil
        and tracker.IsMissionDirty()

    local quest_dirty =
        tracker.IsQuestDirty ~= nil
        and tracker.IsQuestDirty()

    if mission_dirty then
        local mission_last_touch =
            tracker.GetMissionLastTouch ~= nil
            and tracker.GetMissionLastTouch()
            or 0

        local mission_quiet_for =
            os.clock()
            - mission_last_touch

        if mission_quiet_for
            >= MISSION_DIRTY_QUIET_WINDOW then

            local mission_changed =
                sync_mission_status_cache()

            if mission_changed then
                rebuild_mission_cache()
            end

            prune_completed_pins('mission')

            if tracker.ClearMissionDirty ~= nil then
                tracker.ClearMissionDirty()
            end
        end
    end

    if quest_dirty then
        local quest_changed =
            sync_quest_status_cache()

        if quest_changed then
            invalidate_quest_cache()
        end

        prune_completed_pins('quest')
        reconcile_auto_pins()

        if tracker.ClearQuestDirty ~= nil then
            tracker.ClearQuestDirty()
        end
    end

    check_new_entries(mission_dirty or quest_dirty)
    check_near_quests()

    if M.prox_api == nil then
        M.prox_api = M.compass.AshitaApi()
    end

    M.CheckProximity(os.clock(), M.prox_api)

    update_config_save()
end

function M.Unload()
    M.notes.Flush()

    if tracker_is_ready() then
        if tracker.IsMissionDirty == nil
            or tracker.IsMissionDirty() then

            sync_mission_status_cache()

            if tracker.ClearMissionDirty ~= nil then
                tracker.ClearMissionDirty()
            end
        end

        if tracker.IsQuestDirty == nil
            or tracker.IsQuestDirty() then

            sync_quest_status_cache()

            if tracker.ClearQuestDirty ~= nil then
                tracker.ClearQuestDirty()
            end
        end
    end

    update_config_values()
    config_save_dirty = false
    settings.save()
end

return M