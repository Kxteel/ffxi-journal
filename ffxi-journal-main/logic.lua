local M = {}

local settings = require('settings')
local tracker = require('tracker')
local zonematch = require('zonematch')

-- Data

local mission_areas = {
    'sandoria',
    'bastok',
    'windurst',
    'zilart',
    'cop',
    'toau',
    'wotg',
    'acp',
    'mkd',
    'asa',
    'abyssea',
    'adoulin',
    'rov',
    'tvr',
    'assault',
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

local function get_quest_list_from_tracker(category)
    return tracker.GetQuestArea(category) or {}
end

-- Journal state

local journal_mode = 1

local mission_area_index = 1
local mission_index = 1

local quest_category_index = 1
local quest_index = 1

-- Mission log

local mission_log_visible = false
local mission_log_width = 500
local mission_log_height = 600
local mission_log_x = nil
local mission_log_y = nil
local mission_log_id = ''
local mission_log_name = ''
local mission_log_steps = {}

-- Quest log

local quest_log_visible = false
local quest_log_width = 500
local quest_log_height = 600
local quest_log_x = nil
local quest_log_y = nil
local quest_log_id = ''
local quest_log_name = ''
local quest_log_steps = {}

-- Journal window

local journal_visible = false
local journal_width = 2000
local journal_height = 1600
local journal_x = nil
local journal_y = nil

local journal_mini = false
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

local function clamp_pin_scale(value)
    value = tonumber(value) or 1.0
    value = math.max(PIN_SCALE_MIN, math.min(PIN_SCALE_MAX, value))

    -- Two decimals, so repeated steps do not drift (0.1 + 0.2 ~ 0.30000001).
    return math.floor(value * 100 + 0.5) / 100
end
local pin_auto_zone = false
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

-- Settings

local config = settings.load(T{})

local config_save_dirty = false
local config_save_time = 0
local config_save_delay = 0.75

local log_text_scale = 1.0
local log_text_scale_min = 0.50
local log_text_scale_max = 2.00

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

local function invalidate_mission_cache()
    mission_cache = {}
    mission_cache_area = nil
end

local function invalidate_quest_cache()
    quest_cache = {}
    quest_cache_category = nil
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
            }

            if #result >= PIN_MAX then
                break
            end
        end
    end

    return result
end

-- Settings

local function apply_config()
    if config == nil then
        return
    end

    journal_mode = tonumber(config.journal_mode) or 1
    mission_area_index = tonumber(config.journal_area) or 1
    mission_index = tonumber(config.journal_index) or 1
    quest_category_index = tonumber(config.journal_quest_category) or 1
    quest_index = tonumber(config.journal_quest_index) or 1

    journal_width = tonumber(config.journal_width) or 2000
    journal_height = tonumber(config.journal_height) or 1600
    journal_visible = config.journal_open == true
    journal_x = config.journal_x
    journal_y = config.journal_y

    journal_mini = config.journal_mini == true
    journal_mini_x = config.journal_mini_x
    journal_mini_y = config.journal_mini_y

    pin_visible = config.pin_open == true
    pin_x = config.pin_x
    pin_y = config.pin_y
    pin_mode = config.pin_mode == 'tabs' and 'tabs' or 'stacked'
    pin_active = tonumber(config.pin_active) or 1
    pin_auto_zone = config.pin_auto_zone == true
    pin_scale = clamp_pin_scale(config.pin_scale)
    pins = load_pins(config.pins)

    mission_log_width = tonumber(config.mission_width) or 500
    mission_log_height = tonumber(config.mission_height) or 600
    mission_log_visible = config.mission_open == true
    mission_log_x = config.mission_x
    mission_log_y = config.mission_y
    mission_log_id = tostring(config.mission_id or '')
    mission_log_name = tostring(config.mission_name or '')
    mission_log_steps = config.mission_steps or {}

    quest_log_width = tonumber(config.quest_width) or 500
    quest_log_height = tonumber(config.quest_height) or 600
    quest_log_visible = config.quest_open == true
    quest_log_x = config.quest_x
    quest_log_y = config.quest_y
    quest_log_id = tostring(config.quest_id or '')
    quest_log_name = tostring(config.quest_name or '')
    quest_log_steps = config.quest_steps or {}

    hide_complete_missions = config.hide_complete_missions == true
    hide_complete_quests = config.hide_complete_quests == true

    -- Shown unless the setting was explicitly turned off.
    show_not_started_missions = config.show_not_started_missions ~= false
    show_not_started_quests = config.show_not_started_quests ~= false

    log_text_scale = tonumber(config.log_text_scale) or 1.0

    log_text_scale =
        math.max(
            log_text_scale_min,
            math.min(
                log_text_scale_max,
                log_text_scale
            )
        )

    mission_status_cache = config.mission_status or {}
    quest_status_cache = config.quest_status or {}
end

local function update_config_values()
    config.journal_mode = journal_mode
    config.journal_area = mission_area_index
    config.journal_index = mission_index
    config.journal_quest_category = quest_category_index
    config.journal_quest_index = quest_index

    config.journal_width = journal_width
    config.journal_height = journal_height
    config.journal_open = journal_visible
    config.journal_x = journal_x
    config.journal_y = journal_y

    config.journal_mini = journal_mini
    config.journal_mini_x = journal_mini_x
    config.journal_mini_y = journal_mini_y

    config.pin_open = pin_visible
    config.pin_x = pin_x
    config.pin_y = pin_y
    config.pin_mode = pin_mode
    config.pin_active = pin_active
    config.pin_auto_zone = pin_auto_zone
    config.pin_scale = pin_scale
    config.pins = serialize_pins(pins)

    config.mission_width = mission_log_width
    config.mission_height = mission_log_height
    config.mission_open = mission_log_visible
    config.mission_x = mission_log_x
    config.mission_y = mission_log_y
    config.mission_id = mission_log_id
    config.mission_name = mission_log_name
    config.mission_steps = serialize_steps(mission_log_steps)

    config.quest_width = quest_log_width
    config.quest_height = quest_log_height
    config.quest_open = quest_log_visible
    config.quest_x = quest_log_x
    config.quest_y = quest_log_y
    config.quest_id = quest_log_id
    config.quest_name = quest_log_name
    config.quest_steps = serialize_steps(quest_log_steps)

    config.hide_complete_missions = hide_complete_missions
    config.hide_complete_quests = hide_complete_quests
    config.show_not_started_missions = show_not_started_missions
    config.show_not_started_quests = show_not_started_quests
    config.log_text_scale = log_text_scale
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

-- Log text scale API

function M.GetLogTextScale()
    return log_text_scale
end

function M.SetLogTextScale(value)
    value = tonumber(value)

    if value == nil then
        return false
    end

    value =
        math.max(
            log_text_scale_min,
            math.min(
                log_text_scale_max,
                value
            )
        )

    if log_text_scale == value then
        return true
    end

    log_text_scale = value
    request_config_save()

    return true
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

    local changed = false

    for _, quest in ipairs(
        get_quest_list_from_tracker(category)
    ) do
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

-- Mission cache

local function rebuild_mission_cache()
    local area =
        mission_areas[mission_area_index]

    if area == nil then
        mission_area_index = 1
        area = mission_areas[1]
    end

    local mission_list =
        apply_cached_statuses(
            area,
            tracker.GetMissionArea(area)
        )

    mission_cache = {}

    local first_mission

    for _, mission in ipairs(
        mission_list
    ) do
        if mission.status ~= 'hidden' then
            first_mission = mission
            break
        end
    end

    for _, mission in ipairs(
        mission_list
    ) do
        local status =
            mission.status
            or 'not_started'

        local show = false

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

        if show then
            mission_cache[
                #mission_cache + 1
            ] = mission
        end
    end

    mission_cache_area = area

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
        mission_areas[mission_area_index]

    if mission_cache_area ~= area then
        rebuild_mission_cache()
    end

    return mission_cache
end

-- Quest cache

local function rebuild_quest_cache()
    local categories =
        get_quest_categories()

    local category =
        categories[quest_category_index]

    if category == nil then
        invalidate_quest_cache()
        quest_index = 1
        return
    end

    local quests_list =
        apply_cached_quest_statuses(
            category,
            get_quest_list_from_tracker(category)
        )

    quest_cache = {}

    for _, quest in ipairs(
        quests_list
    ) do
        local status =
            quest.status
            or 'not_started'

        if status == 'active'
            or (
                status == 'completed'
                and not hide_complete_quests
            )
            or (
                status == 'not_started'
                and show_not_started_quests
            ) then

            quest_cache[
                #quest_cache + 1
            ] = quest
        end
    end

    quest_cache_category =
        category

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
        categories[quest_category_index]

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

-- Mission API

function M.GetMissionAreas()
    return mission_areas
end

function M.GetMissionAreaNames()
    return mission_area_names
end

function M.GetMissionList()
    return get_visible_missions()
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
        area_index = mission_area_index,
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

    if new_area ~= nil
        and new_area >= 1
        and new_area <= #mission_areas then

        mission_area_index =
            new_area
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

function M.SelectPreviousMissionArea()
    mission_area_index =
        mission_area_index - 1

    if mission_area_index < 1 then
        mission_area_index =
            #mission_areas
    end

    mission_index = 1

    invalidate_mission_cache()
    rebuild_mission_cache()
    request_config_save()
end

function M.SelectNextMissionArea()
    mission_area_index =
        mission_area_index + 1

    if mission_area_index > #mission_areas then
        mission_area_index = 1
    end

    mission_index = 1

    invalidate_mission_cache()
    rebuild_mission_cache()
    request_config_save()
end

-- Quest API

function M.GetQuestCategories()
    return get_quest_categories()
end

function M.GetQuestCategoryNames()
    return get_quest_category_names()
end

function M.GetQuestSelection()
    return {
        category_index =
            quest_category_index,

        quest_index =
            quest_index,
    }
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

    if new_category ~= nil
        and new_category >= 1
        and new_category <= #categories then

        quest_category_index =
            new_category
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

function M.SelectPreviousQuestCategory()
    local categories =
        get_quest_categories()

    if #categories == 0 then
        return
    end

    quest_category_index =
        quest_category_index - 1

    if quest_category_index < 1 then
        quest_category_index =
            #categories
    end

    quest_index = 1

    invalidate_quest_cache()
    rebuild_quest_cache()
    request_config_save()
end

function M.SelectNextQuestCategory()
    local categories =
        get_quest_categories()

    if #categories == 0 then
        return
    end

    quest_category_index =
        quest_category_index + 1

    if quest_category_index > #categories then
        quest_category_index = 1
    end

    quest_index = 1

    invalidate_quest_cache()
    rebuild_quest_cache()
    request_config_save()
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

-- Mission log API

function M.GetMission()
    return {
        id = mission_log_id,
        name = mission_log_name,
        steps = mission_log_steps,
    }
end

function M.GetMissionLogState()
    return {
        visible = mission_log_visible,
        x = mission_log_x,
        y = mission_log_y,
        width = mission_log_width,
        height = mission_log_height,
    }
end

function M.SetMission(
    id,
    name,
    steps
)
    mission_log_id =
        tostring(id or '')

    mission_log_name =
        tostring(name or '')

    mission_log_steps =
        steps or {}

    mission_log_visible =
        true

    request_config_save()
end

function M.SetMissionData(
    id,
    name,
    steps,
    visible
)
    mission_log_id =
        tostring(id or '')

    mission_log_name =
        tostring(name or '')

    mission_log_steps =
        steps or {}

    if visible ~= nil then
        mission_log_visible =
            visible == true
    end

    request_config_save()
end

function M.SetMissionLogVisible(
    visible
)
    mission_log_visible =
        visible == true

    request_config_save()
end

function M.ToggleMissionLog()
    mission_log_visible =
        not mission_log_visible

    request_config_save()
end

function M.ShowMissionLog()
    mission_log_visible = true
    request_config_save()
end

function M.HideMissionLog()
    mission_log_visible = false
    request_config_save()
end

function M.SetMissionLogGeometry(
    x,
    y,
    width,
    height
)
    mission_log_x = x
    mission_log_y = y
    mission_log_width = width
    mission_log_height = height

    request_config_save()
end

-- Quest log API

function M.GetQuest()
    return {
        id = quest_log_id,
        name = quest_log_name,
        steps = quest_log_steps,
    }
end

function M.GetQuestLogState()
    return {
        visible = quest_log_visible,
        x = quest_log_x,
        y = quest_log_y,
        width = quest_log_width,
        height = quest_log_height,
    }
end

function M.SetQuest(
    id,
    name,
    steps
)
    quest_log_id =
        tostring(id or '')

    quest_log_name =
        tostring(name or '')

    quest_log_steps =
        steps or {}

    quest_log_visible =
        true

    request_config_save()
end

function M.SetQuestData(
    id,
    name,
    steps,
    visible
)
    quest_log_id =
        tostring(id or '')

    quest_log_name =
        tostring(name or '')

    quest_log_steps =
        steps or {}

    if visible ~= nil then
        quest_log_visible =
            visible == true
    end

    request_config_save()
end

function M.SetQuestLogVisible(
    visible
)
    quest_log_visible =
        visible == true

    request_config_save()
end

function M.ToggleQuestLog()
    quest_log_visible =
        not quest_log_visible

    request_config_save()
end

function M.ShowQuestLog()
    quest_log_visible = true
    request_config_save()
end

function M.HideQuestLog()
    quest_log_visible = false
    request_config_save()
end

function M.SetQuestLogGeometry(
    x,
    y,
    width,
    height
)
    quest_log_x = x
    quest_log_y = y
    quest_log_width = width
    quest_log_height = height

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

-- Compatibility

function M.ToggleLog()
    M.ToggleMissionLog()
end

-- Automatic mission advance

local function set_log_mission(mission)
    if mission == nil then
        return
    end

    M.SetMission(
        mission.id,
        mission.name,
        mission.steps or {}
    )
end

local function find_log_mission(
    log_id,
    log_name
)
    local numeric_id =
        tonumber(log_id)

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
                    == tostring(log_id)

            local name_matches =
                tostring(
                    mission.name or ''
                )
                == tostring(
                    log_name or ''
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

local function check_current_mission()
    local current_log =
        M.GetMission()

    if current_log.id == ''
        or current_log.name == '' then

        return
    end

    local area,
    mission,
    index =
        find_log_mission(
            current_log.id,
            current_log.name
        )

    if area == nil
        or mission == nil
        or index == nil then

        return
    end

    local key =
        get_status_cache_key(
            area,
            mission.id
        )

    local status =
        mission.status
        or 'not_started'

    if mission_status_cache[key]
        ~= status then

        mission_status_cache[key] =
            status

        invalidate_mission_cache()
        request_config_save()
    end

    if status ~= 'completed' then
        return
    end

    local next_mission =
        find_next_mission(
            area,
            index
        )

    if next_mission ~= nil then
        set_log_mission(
            next_mission
        )
    end
end

-- Automatic quest log watch

local function find_log_quest(
    log_id,
    log_name
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
                    log_id or ''
                )

            local name_matches =
                tostring(
                    quest.name or ''
                )
                == tostring(
                    log_name or ''
                )

            if id_matches
                and name_matches then

                return category, quest
            end
        end
    end

    return nil, nil
end

local function check_current_quest()
    local current_log =
        M.GetQuest()

    if current_log.id == ''
        or current_log.name == '' then

        return
    end

    local category,
    quest =
        find_log_quest(
            current_log.id,
            current_log.name
        )

    if category == nil
        or quest == nil then

        return
    end

    if quest.status == 'completed' then
        M.SetQuestData(
            '',
            '',
            {},
            false
        )
    end
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
            '[Journal] Tracker is full (%d items). Unpin one first.',
            PIN_MAX
        ))

        return false
    end

    pins[#pins + 1] = {
        kind = kind,
        id = tostring(id or ''),
        name = tostring(name or ''),
        steps = serialize_steps(steps),
        step = 1,
    }

    request_config_save()

    return true
end

local function remove_pin_at(index)
    if pins[index] == nil then
        return false
    end

    table.remove(pins, index)
    clamp_pin_active()
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
        count = #pins,
    }
end

function M.GetPins()
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

function M.SetPinMode(mode)
    pin_mode = mode == 'tabs' and 'tabs' or 'stacked'
    request_config_save()
end

function M.TogglePinMode()
    M.SetPinMode(pin_mode == 'tabs' and 'stacked' or 'tabs')
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

-- Pins whatever is currently shown in the Mission Log and Quest Log.
function M.PinCurrentLogs()
    local added = 0

    if mission_log_id ~= '' and add_pin(
        'mission',
        mission_log_id,
        mission_log_name,
        mission_log_steps
    ) then
        added = added + 1
    end

    if quest_log_id ~= '' and add_pin(
        'quest',
        quest_log_id,
        quest_log_name,
        quest_log_steps
    ) then
        added = added + 1
    end

    if added > 0 then
        pin_visible = true
    end

    return added
end

function M.RemovePin(index)
    return remove_pin_at(math.floor(tonumber(index) or 0))
end

function M.ClearPins()
    pins = {}
    pin_active = 1
    request_config_save()
end

function M.SetPinStep(index, value)
    local entry = pins[index]

    if entry == nil then
        return false
    end

    local total = #entry.steps
    local step = math.floor(tonumber(value) or 1)

    entry.step = math.max(1, math.min(step, math.max(total, 1)))
    pin_active = index
    request_config_save()

    return true
end

function M.NextPinStep(index)
    local entry = pins[index]

    if entry ~= nil then
        M.SetPinStep(index, entry.step + 1)
    end
end

function M.PrevPinStep(index)
    local entry = pins[index]

    if entry ~= nil then
        M.SetPinStep(index, entry.step - 1)
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

            entry.step = current + 1
            changed = true

            print(string.format(
                '[Journal] %s: step %d/%d.',
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

-- Pinned items that finish are cleaned up like the Quest/Mission Log.
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
                local _, quest = find_log_quest(entry.id, entry.name)

                if quest ~= nil and quest.status == 'completed' then
                    table.remove(pins, index)
                    advance = false
                    changed = true
                end
            else
                local area, mission, mission_index =
                    find_log_mission(entry.id, entry.name)

                if area ~= nil
                    and mission ~= nil
                    and mission.status == 'completed' then

                    local next_mission =
                        find_next_mission(area, mission_index)

                    if next_mission ~= nil
                        and find_pin(
                            'mission',
                            next_mission.id,
                            next_mission.name
                        ) == nil then

                        pins[index] = {
                            kind = 'mission',
                            id = tostring(next_mission.id),
                            name = tostring(next_mission.name or ''),
                            steps = serialize_steps(next_mission.steps or {}),
                            step = 1,
                        }
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

        print('[Journal] Commands:')
        print('/journal - Open Mission Journal')
        print('/journal help - Show help')
        print('/journal log - Toggle Mission Log')
        print('/journal quest - Open Quest Journal')
        print('/journal quest log - Toggle Quest Log')
        print('/journal pin - Toggle pinned tracker')
        print('/journal pin add - Pin the current Mission/Quest Log items')
        print('/journal pin remove <n> | clear - Unpin items')
        print('/journal pin mode [stacked|tabs] - Tracker layout')
        print('/journal pin size [+|-|reset|<value>] - Tracker size (0.60x-2.00x)')
        print('/journal pin next|prev|reset|<n> - Change step of the active item')
        print('/journal pin zone [on|off] - Auto step change on zone change')
        print('/journal text scale - Show Log text scale')
        print('/journal text scale <value> - Set Log text scale (0.50x-2.00x)')

        return
    end

    if command == 'text'
        and args[3] ~= nil
        and args[3]:lower()
            == 'scale' then

        if args[4] == nil then
            print(string.format(
                '[Journal] Current Log text scale: %.2fx',
                log_text_scale
            ))

            print(string.format(
                '[Journal] Usage: /journal text scale <%.2f-%.2f>',
                log_text_scale_min,
                log_text_scale_max
            ))

            return
        end

        local value =
            tonumber(args[4])

        if value == nil then
            print('[Journal] Invalid Log text scale.')

            print(string.format(
                '[Journal] Usage: /journal text scale <%.2f-%.2f>',
                log_text_scale_min,
                log_text_scale_max
            ))

            return
        end

        local requested_value =
            value

        value =
            math.max(
                log_text_scale_min,
                math.min(
                    log_text_scale_max,
                    value
                )
            )

        M.SetLogTextScale(value)

        if value ~= requested_value then
            print(string.format(
                '[Journal] Log text scale clamped to %.2fx.',
                value
            ))
        else
            print(string.format(
                '[Journal] Log text scale set to %.2fx.',
                value
            ))
        end

        return
    end

    if command == 'log' then
        M.ToggleMissionLog()
        return
    end

    if command == 'pin' then
        local sub = args[3] and args[3]:lower() or nil
        local value = args[4] and args[4]:lower() or nil

        if sub == nil then
            M.TogglePinVisible()
        elseif sub == 'add' then
            local added = M.PinCurrentLogs()

            print(string.format(
                '[Journal] Pinned %d item(s) from the Mission/Quest Log.',
                added
            ))
        elseif sub == 'remove' then
            if tonumber(value) == nil
                or not M.RemovePin(tonumber(value)) then

                print('[Journal] Usage: /journal pin remove <n>')
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
                '[Journal] Tracker mode: %s.',
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
                '[Journal] Tracker size: %.2fx (%.2f-%.2f).',
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
                '[Journal] Auto step change on zone change: %s.',
                pin_auto_zone and 'ON' or 'OFF'
            ))
        elseif tonumber(sub) ~= nil then
            M.SetPinStep(pin_active, tonumber(sub))
        else
            print('[Journal] Usage: /journal pin [add|remove <n>|clear|mode|size|next|prev|reset|zone|<n>]')
        end

        return
    end

    if command == 'quest' then
        if args[3] ~= nil
            and args[3]:lower()
                == 'log' then

            M.ToggleQuestLog()
        else
            M.SetJournalMode(2)
            M.ShowJournal()
        end
    end
end

-- Lifecycle

function M.Initialize()
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

            check_current_mission()
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

        check_current_quest()
        prune_completed_pins('quest')

        if tracker.ClearQuestDirty ~= nil then
            tracker.ClearQuestDirty()
        end
    end

    update_config_save()
end

function M.Unload()
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