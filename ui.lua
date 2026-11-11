local M = {}

require('common')

local imgui = require('imgui')
local ffi = require('ffi')
local d3d = require('d3d8')
local logic = require('logic')
local richtext = require('richtext')
local i18n = require('i18n')
local tx = i18n.t
local icons = require('icons')

-- Ashita 4.1/4.3 ImGui compatibility.
--
-- 4.1: third argument is the legacy boolean 'border'.
-- 4.3: third argument is ImGuiChildFlags.
--
-- Deliberately keep child_border as a boolean. This means:
--   4.1 -> true is passed unchanged.
--   4.3 -> true is converted to ImGuiChildFlags_Borders.
--
-- This also avoids passing a raw numeric ImGuiChildFlags value through the
-- older binding, which is the important part for cross-version compatibility.
local imgui_BeginChild_original = imgui.BeginChild
local imgui_ashita_43 = (ImGuiChildFlags_Borders ~= nil)

imgui.BeginChild = function(
    id,
    size,
    cflags,
    wflags
)
    if imgui_ashita_43 then
        if cflags == true then
            cflags = ImGuiChildFlags_Borders
        elseif cflags == false or cflags == nil then
            cflags = ImGuiChildFlags_None
        end
    else
        -- Ashita 4.1 expects the old boolean border argument.
        -- If a numeric flag ever reaches this wrapper, normalize it.
        if type(cflags) == 'number' then
            cflags = cflags ~= 0
        elseif cflags == nil then
            cflags = false
        end
    end

    if wflags == nil then
        return imgui_BeginChild_original(
            id,
            size,
            cflags
        )
    end

    return imgui_BeginChild_original(
        id,
        size,
        cflags,
        wflags
    )
end

local d3d8dev = d3d.get_device()
local controller = logic

local function get_styles()
    if controller ~= nil and controller.GetStyles ~= nil then
        return controller.GetStyles()
    end

    return nil
end

-- Keep this as the legacy boolean. The compatibility wrapper above converts
-- it to ImGuiChildFlags_Borders only on Ashita 4.3.
local child_border = true

function M.SetController(value)
    controller = value or logic
end

local journal_font

-- Fira Sans (Regular, Bold, Italic) for the step text. The titles and
-- buttons keep the original font.
local text_font
local text_bold_font
local text_italic_font

local journal_font_size = 30

-- Fira Sans looks larger than the small caps of the original font at the
-- same size, so the step text is set a little smaller.
local step_font_size = 26
local step_text_ratio = step_font_size / journal_font_size

local ui_button_height = 42
local ui_bar_height = 54

-- The size of the text of the Journal can be changed in the settings. The
-- sizes above are the ones at 100%; apply_text_scale gives the real ones to
-- the font, the buttons and the bars, so the text always fits in them.
local text_scale = 1.0

-- Height of the buttons of the settings, guide and camps windows. The text
-- is 30 high and the style keeps 6 free above and below it, so the buttons
-- need 42 or the text is cut and not centered.
local SETTINGS_BUTTON_HEIGHT = 42

-- A size in pixels for the current text scale.
local function scaled(value)
    return math.floor(value * text_scale + 0.5)
end

local function apply_text_scale()
    local wanted = 1.0

    if controller and controller.GetTextScale then
        wanted = controller.GetTextScale()
    end

    if wanted == text_scale then
        return
    end

    text_scale = wanted
    journal_font_size = scaled(30)
    step_font_size = scaled(26)
    step_text_ratio = step_font_size / journal_font_size
    ui_button_height = scaled(42)
    ui_bar_height = scaled(54)
    SETTINGS_BUTTON_HEIGHT = scaled(42)
end

-- Windows follow the size of the text. Each window remembers its size and
-- the text scale it had; when the scale changes, the window grows or shrinks
-- by the same factor. before() goes just ahead of Begin, after() inside it.
-- The Fame window and the icon of the Fame Checker NPCs. A table, to keep the
-- locals of this file under the limit.
local fame_ui = { was_open = false, restore = false }

-- Draws the Fame Checker icon at the cursor, as tall as a line of text, and
-- leaves the cursor ready for SameLine. Returns the width it took (0 when
-- there is no icon, and then nothing was drawn).
function fame_ui.inline_icon(kind)
    local icon = controller
        and controller.worldmark
        and controller.worldmark.GetIcon
        and controller.worldmark.GetIcon(kind or 'fame')

    if icon == nil or not imgui.Dummy or not imgui.SameLine then
        return 0
    end

    local icon_height = imgui.GetTextLineHeight()
    local icon_width = icon_height * icon.width / icon.height

    if not pcall(imgui.Dummy, { icon_width, icon_height }) then
        return 0
    end

    pcall(function()
        local min_x, min_y = imgui.GetItemRectMin()
        local max_x, max_y = imgui.GetItemRectMax()

        imgui.GetWindowDrawList():AddImage(
            icon.id,
            { min_x, min_y },
            { max_x, max_y },
            { 0, 0 },
            { 1, 1 },
            imgui.GetColorU32({ 1, 1, 1, 1 })
        )
    end)

    imgui.SameLine(0, 4)

    return icon_width + 4
end

local scalex = { last = {} }

function scalex.before(key)
    local last = scalex.last[key]

    if last and last.scale ~= text_scale and last.scale > 0 then
        local factor = text_scale / last.scale

        imgui.SetNextWindowSize({
            math.floor(last.w * factor + 0.5),
            math.floor(last.h * factor + 0.5),
        })
    end
end

function scalex.after(key)
    local w, h = imgui.GetWindowSize()
    local last = scalex.last[key]

    if last == nil then
        last = {}
        scalex.last[key] = last
    end

    last.w = w
    last.h = h
    last.scale = text_scale
end

local journal_restore_window = true
local journal_last_reset_count = nil
local journal_mini_restore_window = true

local journal_mode_popup_open = false
local journal_area_popup_open = false

-- Search box of the Journal. The buffer is the table that ImGui edits;
-- the flag is true while the box has the keyboard, so the arrow keys and
-- Enter are left to the text instead of moving the lists.
local journal_search_buffer = { '' }
local journal_search_active = false

-- Sheet window: the whole record of the mission or quest clicked in the
-- list. It follows the selection while it is open.
local sheet_open = false
local sheet_kind = 'Mission'
local sheet_restore = false

-- Window with the progress of every area.
local progress_open = false
local progress_restore = false

-- Window "Active Now": the active quests and missions, and the favorites.
-- Whether it is open is kept by the controller, so a command can open it.
-- The rows are rebuilt about once a second.
local active_was_open = false
local active_restore = false
local active_rows = {}
local favorite_rows = {}
local active_rows_time = -1000
local active_notice = nil

-- The note of the quest or mission selected in the Journal: the text box,
-- the item it holds, and whether it has the keyboard.
local note_buffer = { '' }
local note_key = nil
local note_input_active = false

local function open_sheet(kind)
    sheet_kind = kind

    if not sheet_open then
        sheet_open = true
        sheet_restore = true
    end
end

-- The sheet opened without the Journal (from the compass or the Tracker),
-- and the size the player gave it.
local sheetx = { standalone = false, w = nil, h = nil }

-- The window of the general notes (notes.lua keeps the list): the box that
-- is being edited, the delete that waits for a second click, and the width
-- of the button in the toolbar.
local notesx = {
    buffer = { '' }, tbuf = { '' }, cbuf = { '' },
    key = nil, ckey = nil, confirm = nil,
    was_open = false, btn_w = 0, full = 0,
}

-- The icon (a texture of worldmark.lua) a quest row has instead of the dot:
-- in progress, not started (available or locked), or completed (the
-- repeatable ones have their own). nil when there is none (missions, the
-- quests that cannot be tracked, no PNG files).
sheetx.kinds = {}
sheetx.kinds_time = -1000

sheetx.row_icon = function(row, status, mission)
    if mission then
        -- Missions: completed, not available yet (see IsMissionLocked), or
        -- in progress / available.
        if row == nil or row.id == nil or controller == nil then
            return nil
        end

        local marks = controller.worldmark

        if marks == nil or marks.GetIcon == nil then
            return nil
        end

        if status == 'completed' then
            return marks.GetIcon('mission_completed')
        end

        if status == 'not_started' and row.area ~= nil
            and controller.IsMissionLocked
            and controller.IsMissionLocked(row.area, row.id) then

            return marks.GetIcon('mission_locked')
        end

        -- In progress: its own icon (the one of available when there is
        -- no file). Not started and available: the icon of available. The
        -- ones the game cannot track keep their dot.
        if status == 'active' then
            return marks.GetIcon('mission_progress')
                or marks.GetIcon('mission_available')
        end

        if status == 'not_started' then
            return marks.GetIcon('mission_available')
        end

        return nil
    end

    local repeated = status == 'completed' and row ~= nil
        and row.repeatable == true

    if row == nil or row.id == nil
        or (status ~= 'active' and status ~= 'not_started'
            and status ~= 'completed') then

        return nil
    end

    local marks = controller and controller.worldmark

    if marks == nil or marks.GetIcon == nil then
        return nil
    end

    local kind = 'progress'

    if status == 'completed' then
        -- Done; the repeatable ones can be done again.
        kind = repeated and 'repeatable' or 'completed'
    elseif status ~= 'active' then
        -- Looked up at most once a second for each quest.
        local now = os.clock()

        if now - sheetx.kinds_time > 1 then
            sheetx.kinds = {}
            sheetx.kinds_time = now
        end

        kind = sheetx.kinds[row.id]

        if kind == nil then
            kind = controller.GetQuestIconKind
                and controller.GetQuestIconKind(row.id) or nil
            kind = kind == 'locked' and 'locked' or 'available'
            sheetx.kinds[row.id] = kind
        end
    end

    return marks.GetIcon(kind)
end

logic.sheet_hook = function()
    local journal = logic.GetJournalWindowState and logic.GetJournalWindowState()

    if not sheet_open then
        sheetx.standalone = not (journal and journal.visible)
    end

    open_sheet('Quest')
end

local function toggle_progress()
    progress_open = not progress_open

    if progress_open then
        progress_restore = true
    end
end
local journal_category_popup_open = false

local journal_help_window = false
local journal_help_width = 500
local journal_help_height = 360
local journal_help_restore = true

local controller_repeat_button
local controller_repeat_time = 0
local controller_repeat_delay = 0.40
local controller_repeat_interval = 0.12

local keyboard_repeat_key
local keyboard_repeat_time = 0
local keyboard_repeat_delay = 0.40
local keyboard_repeat_interval = 0.12

local list_last_selection = {}

local pGameMenu = 0
local pEventSystem = 0
local pInterfaceHidden = 0
local game_visibility_initialized = false
local game_ui_visible = false
local visibility_cache_time = 0
local visibility_cache_interval = 0.05

local journal_cover_files = {
    sandoria = 'Sandorian_Iconv2.png',
    bastok = 'Bastok_Iconv2.png',
    windurst = 'Windurst_Iconv2.png',
    zilart = 'Zilart_Icon.png',
    cop = 'Chainsofpromathia_Icon.png',
    toau = 'AhtUrghan_Icon.png',
    wotg = 'Wingsofthegoddess_Icon.png',
    acp = 'CrystallineProphecy_Icon.png',
    mkd = 'Mooglekupodetat_Icon.png',
    asa = 'ShantottoAscension_Icon.png',
    abyssea = 'Abyssea_Icon.png',
    adoulin = 'Seekersofadoulin_Icon.png',
    rov = 'Rhapsodies_Icon.png',
    tvr = 'VoraciousResurgence_Icon.png',
    assault = 'Assault_Icon.PNG',
    campaign = 'Campaign_Iconv2.png',
}

local journal_cover_cache = {}

-- Logos shown above the first mission of an area in the list (optional
-- files in assets/logos).
local journal_logo_files = {
    cop = 'Chainsofpromathia_Logo.png',
    zilart = 'Riseofthezilart_Logo.png',
    windurst = 'Windurst_Logo.png',
    bastok = 'Bastok_Logo.png',
    sandoria = 'Sandoria_Logo.png',
    jeuno = 'Jeuno_Logo.png',
    toau = 'Treasuresofahturhgan_Logo.png',
    wotg = 'Wingsofthegoddess_Logo.png',
    adoulin = 'Seekersofadoulin_Logo.png',
    rov = 'Rhapsodiesofvanadiel_Logo.png',
}
local journal_logo_cache = {}

-- How many times bigger than the usual width a logo is drawn. The banners
-- of the nations are twice as big.
local journal_logo_scale = {
    windurst = 2,
    bastok = 2,
    sandoria = 2,
    jeuno = 2,
}
local d3d_image_info = ffi.new('D3DXIMAGE_INFO')
local journal_mini_texture

local colors = {
    -- Navy palette of the original look, with one blue accent for the
    -- selection and the titles in plain white.
    window_bg = { 0.123, 0.136, 0.247, 0.88 },
    child_bg = { 0.111, 0.123, 0.225, 0.85 },
    header_bg = { 0.080, 0.087, 0.173, 1.00 },
    header_active = { 0.094, 0.102, 0.196, 1.00 },
    border = { 0.55, 0.62, 0.80, 0.16 },
    text = { 0.902, 0.910, 0.925, 1.00 },
    text_dim = { 0.640, 0.660, 0.740, 1.00 },
    -- The infinity sign of the repeatable quests.
    repeatable = { 0.62, 0.85, 1.00, 1.00 },
    -- The green sprout of the guide for new adventurers.
    leaf = { 0.46, 0.82, 0.38, 1.00 },
    camps_red = { 0.90, 0.16, 0.14, 1.00 },
    leaf_2 = { 0.36, 0.72, 0.30, 1.00 },
    stem = { 0.28, 0.58, 0.26, 1.00 },
    -- Title color. The key keeps its old name; it is plain white now.
    gold = { 1.00, 1.00, 1.00, 1.00 },
    -- The star of the favorites and the text of the notes.
    favorite = { 1.00, 0.82, 0.30, 1.00 },
    note = { 0.96, 0.86, 0.58, 1.00 },
    button = { 0.098, 0.109, 0.200, 1.00 },
    button_hover = { 0.128, 0.140, 0.247, 1.00 },
    button_active = { 0.149, 0.162, 0.272, 1.00 },
    -- The Settings button: gray with a bright border.
    settings_fill = { 0.400, 0.412, 0.447, 1.00 },
    settings_hover = { 0.490, 0.502, 0.537, 1.00 },
    settings_active = { 0.318, 0.329, 0.361, 1.00 },
    settings_border = { 0.780, 0.792, 0.827, 1.00 },
    settings_text = { 0.961, 0.965, 0.976, 1.00 },
    -- The Missions and Quests buttons: the blue of the missions and the
    -- yellow of the quests (the ones of the alerts).
    mode_mission = { 0.55, 0.75, 1.00, 1.00 },
    mode_quest = { 1.00, 0.85, 0.40, 1.00 },
    -- The pulsing border of the Active Now button.
    active_border = { 0.30, 0.90, 0.40, 1.00 },
    active_status = { 0.490, 0.698, 0.918, 1.00 },
    completed = { 0.498, 0.749, 0.541, 1.00 },
    not_started = { 0.588, 0.639, 0.710, 1.00 },
    -- The small x that removes an NPC from the compass.
    cross = { 0.50, 0.52, 0.58, 0.55 },
    cross_hover = { 0.82, 0.84, 0.90, 0.95 },

    panel = { 20 / 255, 17 / 255, 48 / 255, 1.00 },
    stripe_dark = { 16 / 255, 12 / 255, 44 / 255, 1.00 },
    stripe = { 24 / 255, 22 / 255, 52 / 255, 1.00 },

    frame = { 0.55, 0.62, 0.80, 0.20 },
    frame_inner = { 0.35, 0.40, 0.55, 0.16 },
    arrow = { 0.490, 0.698, 0.918, 1.00 },

    selector_dot = { 0.490, 0.698, 0.918, 1.00 },
    selector_dot_highlight = { 0.85, 0.95, 1.00, 0.80 },

    -- Dot next to each mission or quest in the list.
    dot_not_started = { 0.490, 0.698, 0.918, 1.00 },
    dot_active = { 0.400, 0.780, 0.500, 1.00 },
    dot_completed = { 0.580, 0.610, 0.680, 1.00 },
    dot_untracked = { 0.490, 0.698, 0.918, 0.40 },
    selector_text = { 0.902, 0.910, 0.925, 1.00 },
    selector_text_selected = { 0.490, 0.698, 0.918, 1.00 },

    scrollbar_bg = { 0.080, 0.087, 0.173, 0.60 },
    scrollbar_grab = { 0.231, 0.259, 0.376, 1.00 },
    scrollbar_grab_hovered = { 0.300, 0.330, 0.460, 1.00 },
    scrollbar_grab_active = { 0.360, 0.400, 0.550, 1.00 },

    panel_alpha_top = 0.55,
    panel_alpha_mid = 0.88,
    panel_alpha_bottom = 1.00,
}

local transparent = { 0, 0, 0, 0 }

-- Button colors of the three nations in the area and category selectors.
-- The keys are the mission areas and the quest categories, which use the
-- same names. Every other area keeps the standard button color.
local area_colors = {
    sandoria = {
        fill = { 0.498, 0.165, 0.180, 1.00 },
        border = { 0.627, 0.267, 0.286, 1.00 },
    },
    bastok = {
        fill = { 0.184, 0.361, 0.620, 1.00 },
        border = { 0.290, 0.471, 0.733, 1.00 },
    },
    windurst = {
        fill = { 0.184, 0.420, 0.271, 1.00 },
        border = { 0.243, 0.541, 0.357, 1.00 },
    },
}

local function lighten(color, amount)
    return {
        math.min(color[1] + amount, 1),
        math.min(color[2] + amount, 1),
        math.min(color[3] + amount, 1),
        color[4] or 1,
    }
end

local theme_colors = {
    { ImGuiCol_WindowBg, colors.window_bg },
    { ImGuiCol_ChildBg, colors.child_bg },
    { ImGuiCol_PopupBg, colors.window_bg },
    { ImGuiCol_Border, colors.border },
    { ImGuiCol_FrameBg, colors.button },
    { ImGuiCol_FrameBgHovered, colors.button_hover },
    { ImGuiCol_FrameBgActive, colors.button_active },
    { ImGuiCol_Button, colors.button },
    { ImGuiCol_ButtonHovered, colors.button_hover },
    { ImGuiCol_ButtonActive, colors.button_active },
    { ImGuiCol_Header, transparent },
    { ImGuiCol_HeaderHovered, transparent },
    { ImGuiCol_HeaderActive, transparent },
    { ImGuiCol_Text, colors.text },
    { ImGuiCol_TitleBg, colors.header_bg },
    { ImGuiCol_TitleBgActive, colors.header_active },
    { ImGuiCol_ScrollbarBg, colors.scrollbar_bg },
    { ImGuiCol_ScrollbarGrab, colors.scrollbar_grab },
    { ImGuiCol_ScrollbarGrabHovered, colors.scrollbar_grab_hovered },
    { ImGuiCol_ScrollbarGrabActive, colors.scrollbar_grab_active },
}

local mode_items = { 'Missions', 'Quests' }
local mode_names = {
    Missions = 'Missions',
    Quests = 'Quests',
}

local KEY = {
    UP = 0xC8,
    DOWN = 0xD0,
    LEFT = 0xCB,
    RIGHT = 0xCD,
}

local DPAD = {
    UP = 0,
    DOWN = 1,
    LEFT = 2,
    RIGHT = 3,
}

local BUTTON_A = 12
local BUTTON_B = 13
local BUTTON_X = 14

local function reset_repeat()
    controller_repeat_button = nil
    controller_repeat_time = 0
    keyboard_repeat_key = nil
    keyboard_repeat_time = 0
end

local function close_popups()
    journal_mode_popup_open = false
    journal_area_popup_open = false
    journal_category_popup_open = false
    journal_search_active = false
    sheet_open = false
    progress_open = false
end

local function initialize_game_visibility()
    if game_visibility_initialized then
        return
    end

    game_visibility_initialized = true

    pGameMenu = ashita.memory.find(
        'FFXiMain.dll',
        0,
        '8B480C85C974??8B510885D274??3B05',
        16,
        0
    )

    pEventSystem = ashita.memory.find(
        'FFXiMain.dll',
        0,
        'A0????????84C0741AA1????????85C0741166A1????????663B05????????0F94C0C3',
        0,
        0
    )

    pInterfaceHidden = ashita.memory.find(
        'FFXiMain.dll',
        0,
        '8B4424046A016A0050B9????????E8????????F6D81BC040C3',
        0,
        0
    )
end

local function get_game_menu_name()
    if pGameMenu == 0 then
        return ''
    end

    local menu_pointer = ashita.memory.read_uint32(pGameMenu)
    if menu_pointer == 0 then
        return ''
    end

    local menu_val = ashita.memory.read_uint32(menu_pointer)
    if menu_val == 0 then
        return ''
    end

    local menu_header = ashita.memory.read_uint32(menu_val + 4)
    if menu_header == 0 then
        return ''
    end

    local name = ashita.memory.read_string(menu_header + 0x46, 16)
    if not name then
        return ''
    end

    return name:gsub('\x00', ''):gsub('menu[%s]+', ''):trimex():lower()
end

local function update_game_ui_visibility()
    initialize_game_visibility()

    local now = os.clock()
    if now - visibility_cache_time < visibility_cache_interval then
        return
    end

    visibility_cache_time = now
    game_ui_visible = GetPlayerEntity() ~= nil

    if not game_ui_visible then
        return
    end

    if pEventSystem ~= 0 then
        local ptr = ashita.memory.read_uint32(pEventSystem + 1)
        if ptr ~= 0 and ashita.memory.read_uint8(ptr) == 1 then
            game_ui_visible = false
            return
        end
    end

    if pInterfaceHidden ~= 0 then
        local ptr = ashita.memory.read_uint32(pInterfaceHidden + 10)
        if ptr ~= 0 and ashita.memory.read_uint8(ptr + 0xB4) == 1 then
            game_ui_visible = false
            return
        end
    end

    local menu = get_game_menu_name()
    if menu ~= ''
        and (
            menu:find('map', 1, true)
            or menu:find('regioninfo', 1, true)
            or menu:find('region', 1, true)
            or menu:find('cnqframe', 1, true)
            or menu:find('widescan', 1, true)
        ) then
        game_ui_visible = false
    end
end

local function can_draw_ui()
    return game_ui_visible
end

local function load_journal_cover(area)
    local cached = journal_cover_cache[area]
    if cached ~= nil then
        return cached ~= false and cached or nil
    end

    local filename = journal_cover_files[area]
    if not filename then
        journal_cover_cache[area] = false
        return nil
    end

    local path = addon.path .. '/assets/covers/' .. filename
    if not ashita.fs.exists(path) then
        journal_cover_cache[area] = false
        return nil
    end

    if ffi.C.D3DXGetImageInfoFromFileA(path, d3d_image_info) ~= ffi.C.S_OK then
        journal_cover_cache[area] = false
        return nil
    end

    local texture_ptr = ffi.new('IDirect3DTexture8*[1]')

    if ffi.C.D3DXCreateTextureFromFileA(
        d3d8dev,
        path,
        texture_ptr
    ) ~= ffi.C.S_OK then

        journal_cover_cache[area] = false
        return nil
    end

    local texture = {
        ptr = d3d.gc_safe_release(
            ffi.cast('IDirect3DTexture8*', texture_ptr[0])
        ),
        width = tonumber(d3d_image_info.Width),
        height = tonumber(d3d_image_info.Height),
    }

    journal_cover_cache[area] = texture
    return texture
end

local function load_journal_logo(area)
    local cached = journal_logo_cache[area]

    if cached ~= nil then
        return cached ~= false and cached or nil
    end

    journal_logo_cache[area] = false

    local filename = journal_logo_files[area]

    if not filename then
        return nil
    end

    local path = addon.path .. '/assets/logos/' .. filename

    if not ashita.fs.exists(path) then
        return nil
    end

    if ffi.C.D3DXGetImageInfoFromFileA(path, d3d_image_info) ~= ffi.C.S_OK then
        return nil
    end

    local texture_ptr = ffi.new('IDirect3DTexture8*[1]')

    if ffi.C.D3DXCreateTextureFromFileA(
        d3d8dev,
        path,
        texture_ptr
    ) ~= ffi.C.S_OK then

        return nil
    end

    local texture = {
        ptr = d3d.gc_safe_release(
            ffi.cast('IDirect3DTexture8*', texture_ptr[0])
        ),
        width = tonumber(d3d_image_info.Width),
        height = tonumber(d3d_image_info.Height),
    }

    journal_logo_cache[area] = texture

    return texture
end

local function load_journal_mini_texture()
    if journal_mini_texture ~= nil then
        return
    end

    local path = addon.path .. '/assets/journal.jpg'

    if not ashita.fs.exists(path) then
        return
    end

    local texture_ptr = ffi.new('IDirect3DTexture8*[1]')

    if ffi.C.D3DXCreateTextureFromFileA(
        d3d8dev,
        path,
        texture_ptr
    ) ~= ffi.C.S_OK then
        return
    end

    journal_mini_texture = d3d.gc_safe_release(
        ffi.cast('IDirect3DTexture8*', texture_ptr[0])
    )
end

-- left: draw it at the cursor instead of centering it.
local function draw_journal_cover(
    cover,
    width,
    height,
    left
)
    if not cover or not cover.ptr then
        return
    end

    local texture_id =
        tonumber(
            ffi.cast(
                'uint32_t',
                cover.ptr
            )
        )

    if not texture_id then
        return
    end

    if not left then
        imgui.SetCursorPosX(
            (
                imgui.GetWindowWidth()
                - width
            ) * 0.5
        )
    end

    imgui.Image(
        texture_id,
        { width, height },
        { 0, 0 },
        { 1, 1 },
        { 1, 1, 1, 1 }
    )
end

local function set_window_visible(
    kind,
    visible
)
    if not controller then
        return
    end

    local fn =
        controller[
            (
                visible
                and 'Show'
                or 'Hide'
            ) .. kind
        ]

    if fn then
        fn()
        return
    end

    fn =
        controller[
            'Set' .. kind .. 'Visible'
        ]

    if fn then
        fn(visible)
    end
end

local function toggle_window(kind)
    if not controller then
        return
    end

    local fn =
        controller[
            'Toggle' .. kind
        ]

    if not fn then
        return
    end

    fn()

    if kind == 'Journal' then
        journal_restore_window = true
    end
end

function M.ShowJournal()
    set_window_visible(
        'Journal',
        true
    )

    if controller
        and controller.SetJournalMini then

        controller.SetJournalMini(false)
    end

    journal_restore_window = true
    journal_mini_restore_window = true
end

function M.HideJournal()
    set_window_visible(
        'Journal',
        false
    )

    close_popups()
    reset_repeat()
end

function M.ToggleJournal()
    toggle_window('Journal')
end

function M.ShowHelp()
    journal_help_window = true
    journal_help_restore = true
end

function M.HideHelp()
    journal_help_window = false
end

function M.ToggleHelp()
    journal_help_window =
        not journal_help_window

    if journal_help_window then
        journal_help_restore = true
    end
end

-- Opacity of the backgrounds of the window being drawn (1.0 = solid). Only
-- the backgrounds fade: the text, the buttons and the lines stay sharp.
local current_bg_opacity = 1.0

local function scale_alpha(color, opacity)
    return { color[1], color[2], color[3], (color[4] or 1) * opacity }
end

-- no_fade keeps the window solid (the settings window, so it can always be
-- read while the opacity is being changed).
local function push_theme(no_fade, opacity_override)
    local opacity = 1.0

    if opacity_override ~= nil then
        opacity = opacity_override
    elseif not no_fade
        and controller
        and controller.GetJournalOpacity then

        opacity = controller.GetJournalOpacity()
    end

    current_bg_opacity = opacity

    for _, entry in ipairs(theme_colors) do
        local color = entry[2]

        if opacity_override ~= nil
            and opacity <= 0
            and entry[1] == ImGuiCol_Border then

            -- A window with a fully transparent background has no border.
            color = transparent
        elseif opacity < 1.0
            and (
                entry[1] == ImGuiCol_WindowBg
                or entry[1] == ImGuiCol_ChildBg
                or entry[1] == ImGuiCol_PopupBg
            ) then

            color = scale_alpha(color, opacity)
        end

        imgui.PushStyleColor(
            entry[1],
            color
        )
    end

    imgui.PushStyleVar(
        ImGuiStyleVar_WindowPadding,
        { 12, 12 }
    )

    imgui.PushStyleVar(
        ImGuiStyleVar_FramePadding,
        { 8, 6 }
    )

    imgui.PushStyleVar(
        ImGuiStyleVar_ItemSpacing,
        { 7, 7 }
    )

    imgui.PushStyleVar(
        ImGuiStyleVar_ItemInnerSpacing,
        { 6, 5 }
    )
end

local function pop_theme()
    imgui.PopStyleVar(4)
    imgui.PopStyleColor(
        #theme_colors
    )

    current_bg_opacity = 1.0
end

local function draw_window_panel(
    draw,
    x,
    y,
    width,
    height,
    double_line
)
    if not draw then
        return
    end

    local opacity = current_bg_opacity

    local top = imgui.GetColorU32({
        colors.panel[1],
        colors.panel[2],
        colors.panel[3],
        colors.panel_alpha_top * opacity,
    })

    local mid = imgui.GetColorU32({
        colors.panel[1],
        colors.panel[2],
        colors.panel[3],
        colors.panel_alpha_mid * opacity,
    })

    local bottom = imgui.GetColorU32({
        colors.panel[1],
        colors.panel[2],
        colors.panel[3],
        colors.panel_alpha_bottom * opacity,
    })

    local mid_y =
        y + height * 0.5

    draw:AddRectFilledMultiColor(
        { x, y },
        {
            x + width,
            mid_y,
        },
        top,
        top,
        mid,
        mid
    )

    draw:AddRectFilledMultiColor(
        { x, mid_y },
        {
            x + width,
            y + height,
        },
        mid,
        mid,
        bottom,
        bottom
    )

    local light =
        imgui.GetColorU32(
            scale_alpha(colors.stripe, opacity)
        )

    local dark =
        imgui.GetColorU32(
            scale_alpha(colors.stripe_dark, opacity)
        )

    for row_y = y, y + height, 5 do
        local row =
            math.floor(
                (row_y - y) / 5
            )

        draw:AddLine(
            { x, row_y },
            { x + width, row_y },
            row % 2 == 0
                and light
                or dark,
            2.0
        )
    end

    draw:AddRect(
        { x + 0.5, y + 0.5 },
        {
            x + width - 0.5,
            y + height - 0.5,
        },
        imgui.GetColorU32(
            colors.frame
        ),
        0,
        0,
        1
    )

    if double_line then
        draw:AddRect(
            {
                x + 2.5,
                y + 2.5,
            },
            {
                x + width - 2.5,
                y + height - 2.5,
            },
            imgui.GetColorU32(
                colors.frame_inner
            ),
            0,
            0,
            1
        )
    end
end

-- Panel of a block inside a window: only a thin line, so the stripes of the
-- window show through. double_line is accepted for the callers and ignored.
local function draw_panel(
    draw,
    x,
    y,
    width,
    height,
    double_line
)
    if not draw then
        return
    end

    draw:AddRect(
        { x + 0.5, y + 0.5 },
        {
            x + width - 0.5,
            y + height - 0.5,
        },
        imgui.GetColorU32(
            colors.frame
        ),
        0,
        0,
        1
    )
end

local function draw_selection_arrow(
    draw,
    x,
    y,
    height
)
    if not draw then
        return
    end

    local cy =
        y + height * 0.5

    local left =
        x + 3

    draw:AddTriangleFilled(
        {
            left,
            cy - 6,
        },
        {
            left + 9,
            cy,
        },
        {
            left,
            cy + 6,
        },
        imgui.GetColorU32(
            colors.arrow
        )
    )
end

-- Color of the dot for a status as shown in the list: blue when not
-- started, green when active, gray when completed. A quest that cannot be
-- tracked gets a faded blue, since its real state is unknown.
local function status_dot_color(status)
    if status == 'active' then
        return colors.dot_active
    elseif status == 'completed' then
        return colors.dot_completed
    elseif status == 'untracked' then
        return colors.dot_untracked
    end

    return colors.dot_not_started
end

local function draw_selector_item(
    text,
    selected,
    dot_color,
    repeatable,
    id_suffix,
    favorite,
    icon
)
    imgui.PushStyleColor(
        ImGuiCol_Text,
        transparent
    )

    -- id_suffix keeps two rows with the same text apart.
    local clicked =
        imgui.Selectable(
            id_suffix and (text .. '##' .. id_suffix) or text,
            selected
        )

    local hovered =
        imgui.IsItemHovered()

    imgui.PopStyleColor()

    local draw =
        imgui.GetWindowDrawList()

    local min_x, min_y =
        imgui.GetItemRectMin()

    local max_x, max_y =
        imgui.GetItemRectMax()

    local height =
        max_y - min_y

    if hovered then
        draw:AddRectFilled(
            {
                min_x + 2,
                min_y + 1,
            },
            {
                max_x - 2,
                max_y - 1,
            },
            imgui.GetColorU32({
                colors.button_hover[1],
                colors.button_hover[2],
                colors.button_hover[3],
                0.55,
            }),
            2
        )
    end

    if selected then
        draw_selection_arrow(
            draw,
            min_x,
            min_y,
            height
        )
    end

    -- The icon of the quest, or the dot when there is none (or it fails).
    local icon_drawn = false

    if icon ~= nil then
        icon_drawn = pcall(function()
            local icon_h = math.min(height - 2, 24)
            local icon_w = icon_h * icon.width / icon.height
            local center_y = min_y + height * 0.5

            -- The mission icons are wider: they must not touch the text.
            if icon_w > 21 then
                icon_h = icon_h * 21 / icon_w
                icon_w = 21
            end

            draw:AddImage(
                icon.id,
                { min_x + 19 - icon_w * 0.5, center_y - icon_h * 0.5 },
                { min_x + 19 + icon_w * 0.5, center_y + icon_h * 0.5 },
                { 0, 0 },
                { 1, 1 },
                imgui.GetColorU32({ 1, 1, 1, 1 })
            )
        end)
    end

    if not icon_drawn then
        draw:AddCircleFilled(
            {
                min_x + 19,
                min_y + height * 0.5,
            },
            6.1,
            imgui.GetColorU32(
                dot_color
                    or colors.selector_dot
            ),
            14
        )

        draw:AddCircleFilled(
            {
                min_x + 17.4,
                min_y + height * 0.5 - 1.6,
            },
            1.9,
            imgui.GetColorU32(
                colors.selector_dot_highlight
            ),
            10
        )
    end

    local text_x =
        min_x + 32

    local text_y =
        min_y
        + (
            height
            - imgui.GetTextLineHeight()
        ) * 0.5

    if selected then
        text_x =
            text_x + 2

        text_y =
            text_y - 1
    end

    draw:AddText(
        {
            text_x,
            text_y,
        },
        imgui.GetColorU32(
            selected
                and colors.selector_text_selected
                or colors.selector_text
        ),
        text
    )

    -- Repeatable quests: an infinity sign after the name.
    if repeatable then
        local line_height = imgui.GetTextLineHeight()
        local icon_width, icon_height =
            icons.infinity_size(line_height)

        icons.draw_infinity(
            draw,
            text_x + (imgui.CalcTextSize(text)) + 10,
            text_y + (line_height - icon_height) * 0.5,
            icon_width,
            icon_height,
            imgui.GetColorU32(colors.repeatable),
            2.0
        )
    end

    -- Favorites: a star after the name (and after the infinity sign).
    if favorite then
        local line_height = imgui.GetTextLineHeight()
        local star_x = text_x + (imgui.CalcTextSize(text)) + 10

        if repeatable then
            star_x = star_x + (icons.infinity_size(line_height)) + 8
        end

        local size = line_height * 0.8

        icons.draw_star(
            draw,
            star_x,
            text_y + (line_height - size) * 0.5,
            size,
            imgui.GetColorU32(colors.favorite)
        )
    end

    return clicked
end

local function restore_window(
    state,
    restore
)
    if not restore then
        return false
    end

    if state.width ~= nil
        and state.height ~= nil then

        imgui.SetNextWindowSize({
            state.width,
            state.height,
        })
    end

    if state.x ~= nil
        and state.y ~= nil then

        imgui.SetNextWindowPos({
            state.x,
            state.y,
        })
    end

    return false
end

local function get_status_display(status)
    if status == 'active' then
        return tx('Active'),
            colors.active_status

    elseif status == 'completed' then
        return tx('Completed'),
            colors.completed
    end

    if status == 'untracked' then
        return tx('Not Tracked'),
            colors.not_started
    end

    return tx('Not Started'),
        colors.not_started
end

-- Quests without a tracking id cannot be told apart, so "Not Started"
-- would be a guess: they could be done already. They are shown as not
-- tracked instead.
local function display_status(item)
    local status = item.status or 'not_started'

    if item.trackable == false and status == 'not_started' then
        return 'untracked'
    end

    return status
end

local function draw_status_at_item_end(
    status
)
    local text, color =
        get_status_display(status)

    local _, min_y =
        imgui.GetItemRectMin()

    local max_x =
        select(
            1,
            imgui.GetItemRectMax()
        )

    local width =
        imgui.CalcTextSize(text)

    local draw =
        imgui.GetWindowDrawList()

    if draw then
        draw:AddText(
            {
                max_x - width - 12,
                min_y + 4,
            },
            imgui.GetColorU32(color),
            text
        )
    end
end

local function draw_selectable_status_list(
    child_id,
    width,
    items,
    selection_index,
    hide_label,
    hide_getter,
    hide_setter,
    show_label,
    show_getter,
    show_setter,
    label_getter,
    select_callback,
    empty_top_spacing,
    repeatable_getter,
    repeatable_setter,
    open_callback,
    extras,
    favorite_getter,
    filter_getter,
    filter_setter
)
    imgui.PushStyleColor(
        ImGuiCol_ChildBg,
        transparent
    )

    if imgui.BeginChild(
        child_id,
        { width, -1 },
        child_border
    ) then
        local draw =
            imgui.GetWindowDrawList()

        local x, y =
            imgui.GetWindowPos()

        local w, h =
            imgui.GetWindowSize()

        draw_panel(
            draw,
            x,
            y,
            w,
            h,
            true
        )

        local checkbox = {
            hide_getter
                and hide_getter() == true
                or false,
        }

        if imgui.Checkbox(
            hide_label,
            checkbox
        )
            and hide_setter then

            hide_setter(
                checkbox[1] == true
            )
        end

        -- A button with a star that shows only the favorites. It sits at the
        -- right end of the first row, before the infinity button when there
        -- is one.
        local only_favorites = false

        if filter_getter
            and filter_setter
            and imgui.GetFrameHeight then

            only_favorites = filter_getter() == true

            local size = imgui.GetFrameHeight()
            local right = 14

            if repeatable_getter and repeatable_setter then
                right = right + size + 6
            end

            imgui.SameLine()
            imgui.SetCursorPosX(imgui.GetWindowWidth() - size - right)

            if only_favorites then
                imgui.PushStyleColor(
                    ImGuiCol_Button,
                    colors.button_active
                )
            end

            if imgui.Button(
                '##OnlyFavorites',
                { size, size }
            ) then
                filter_setter(not only_favorites)
            end

            if only_favorites then
                imgui.PopStyleColor()
            end

            local min_x, min_y = imgui.GetItemRectMin()
            local max_x, max_y = imgui.GetItemRectMax()
            local star_size = (max_y - min_y) * 0.6

            icons.draw_star(
                imgui.GetWindowDrawList(),
                min_x + ((max_x - min_x) - star_size) * 0.5,
                min_y + ((max_y - min_y) - star_size) * 0.5,
                star_size,
                imgui.GetColorU32(
                    only_favorites
                        and colors.favorite
                        or colors.text_dim
                )
            )

            if imgui.IsItemHovered() and imgui.SetTooltip then
                imgui.SetTooltip(tx('Only favorites'))
            end
        end

        -- Quests only: a button with the infinity sign that shows only the
        -- repeatable quests. It sits at the right end of the first row.
        local only_repeatable = false

        if repeatable_getter
            and repeatable_setter
            and imgui.GetFrameHeight then

            only_repeatable = repeatable_getter() == true

            local size = imgui.GetFrameHeight()

            imgui.SameLine()
            imgui.SetCursorPosX(imgui.GetWindowWidth() - size - 14)

            if only_repeatable then
                imgui.PushStyleColor(
                    ImGuiCol_Button,
                    colors.button_active
                )
            end

            if imgui.Button(
                '##OnlyRepeatable',
                { size, size }
            ) then
                repeatable_setter(not only_repeatable)
            end

            if only_repeatable then
                imgui.PopStyleColor()
            end

            -- The sign is drawn over the button.
            local min_x, min_y = imgui.GetItemRectMin()
            local max_x, max_y = imgui.GetItemRectMax()
            local icon_width = (max_x - min_x) * 0.66
            local icon_height = icon_width * 0.45

            icons.draw_infinity(
                imgui.GetWindowDrawList(),
                min_x + ((max_x - min_x) - icon_width) * 0.5,
                min_y + ((max_y - min_y) - icon_height) * 0.5,
                icon_width,
                icon_height,
                imgui.GetColorU32(
                    only_repeatable
                        and colors.repeatable
                        or colors.text_dim
                ),
                2.0
            )

            if imgui.IsItemHovered() and imgui.SetTooltip then
                imgui.SetTooltip(tx('Only repeatable quests'))
            end
        end

        if show_label ~= nil then
            local show_checkbox = {
                show_getter
                    and show_getter() == true
                    or false,
            }

            if imgui.Checkbox(
                show_label,
                show_checkbox
            )
                and show_setter then

                show_setter(
                    show_checkbox[1] == true
                )
            end
        end

        imgui.Separator()

        if empty_top_spacing then
            imgui.Spacing()
            imgui.Spacing()
        else
            imgui.Spacing()
        end

        if #items == 0 then
            local empty_text =
                empty_top_spacing
                and tx('No quests available.')
                or tx('No missions available.')

            if controller
                and controller.GetSearchText
                and controller.GetSearchText() ~= '' then

                empty_text = tx('No matches found.')
            elseif only_favorites then
                empty_text = tx('No favorites in this list.')
            elseif only_repeatable then
                empty_text = tx('No repeatable quests.')
            end

            imgui.TextColored(
                colors.text_dim,
                empty_text
            )
        else
            local last_selection =
                list_last_selection[child_id]

            local selection_changed =
                last_selection
                ~= selection_index

            -- Extra blocks (the chapters of Chains of Promathia, the epilogue
            -- of Zilart and Chains) go before one mission of their area.
            -- The epilogue goes after the last mission of its area when that
            -- mission is not in the list.
            local blocks_at = {}

            for _, block in ipairs(extras or {}) do
                local at = block.at_index

                for i, item in ipairs(at == nil and items or {}) do
                    if item.area == block.area then
                        if block.before_code ~= nil then
                            if tostring(item.code or '') == block.before_code then
                                at = i
                                break
                            end
                        elseif block.rank ~= nil then
                            if tonumber(item.rank) == block.rank then
                                at = i
                                break
                            end
                        elseif block.chapter ~= nil then
                            local code = tostring(item.code or '')

                            if tonumber(code:match('^(%d)%-')) == block.chapter then
                                at = i
                                break
                            end
                        else
                            if item.id == block.before_id then
                                at = i
                                break
                            end

                            at = i + 1
                        end
                    end
                end

                if at ~= nil then
                    blocks_at[at] = blocks_at[at] or {}
                    blocks_at[at][#blocks_at[at] + 1] = block
                end
            end

            -- The logo of an area goes above its first mission, and the
            -- banner of a nation above its first quest. In a list of all
            -- the areas each one gets its own.
            local logos_at = {}
            local logo_seen = {}
            local is_mission_list = child_id == '##JournalMissionList'

            for i, item in ipairs(items) do
                local key = is_mission_list and item.area or item.category

                if key ~= nil
                    and journal_logo_files[key] ~= nil
                    and not logo_seen[key] then

                    logo_seen[key] = true
                    logos_at[i] = key
                end
            end

            local function draw_logo(logo_area)
                local logo = load_journal_logo(logo_area)

                if logo == nil or logo.height <= 0 then
                    return
                end

                local logo_width = math.min(
                    imgui.GetWindowWidth() - scaled(40),
                    scaled(380) * (journal_logo_scale[logo_area] or 1)
                )

                if logo_width <= 0 then
                    return
                end

                imgui.Spacing()

                draw_journal_cover(
                    logo,
                    logo_width,
                    logo_width * logo.height / logo.width
                )

                imgui.Spacing()
            end

            local function draw_extras(list)
                for _, block in ipairs(list or {}) do
                    imgui.Spacing()

                    if block.before_code ~= nil then
                        -- A requirement: a short dim text before the mission.
                        imgui.PushStyleColor(ImGuiCol_Text, colors.text_dim)

                        if imgui.TextWrapped then
                            imgui.TextWrapped(tx(block.title))
                        else
                            imgui.Text(tx(block.title))
                        end

                        imgui.PopStyleColor()
                    else
                        imgui.TextColored(
                            colors.gold,
                            block.raw_title and block.title or tx(block.title)
                        )

                        if block.done then
                            -- Green V: every mission of this rank is done.
                            local x0, y0 = imgui.GetItemRectMin()
                            local x1, y1 = imgui.GetItemRectMax()
                            local size = y1 - y0
                            icons.draw_check(
                                imgui.GetWindowDrawList(),
                                x1 + 6,
                                y0,
                                size,
                                imgui.GetColorU32(colors.completed),
                                1
                            )
                        end
                    end

                    for _, row in ipairs(block.rows or {}) do
                        if row.info then
                            -- Information only: no quest to open.
                            imgui.TextColored(
                                colors.text_dim,
                                '    ' .. tostring(row.name)
                            )

                            if imgui.IsItemHovered() and imgui.SetTooltip then
                                imgui.SetTooltip(
                                    tostring(row.type)
                                    .. '\n'
                                    .. tostring(row.reward)
                                )
                            end
                        else
                            local row_clicked =
                                draw_selector_item(
                                    tostring(row.name),
                                    false,
                                    status_dot_color(display_status(row)),
                                    row.repeatable == true,
                                    block.area .. '_' .. tostring(row.id),
                                    nil,
                                    sheetx.row_icon(row, display_status(row))
                                )

                            if row_clicked and controller.JumpToQuest then
                                controller.JumpToQuest(row.id)
                            end

                            if imgui.IsItemHovered() and imgui.SetTooltip then
                                imgui.SetTooltip(tx('Opens the quest'))
                            end

                            draw_status_at_item_end(display_status(row))
                        end
                    end

                    imgui.Spacing()
                end
            end

            for i, item in ipairs(items) do
                if logos_at[i] ~= nil then
                    draw_logo(logos_at[i])
                end

                draw_extras(blocks_at[i])

                local selected =
                    i == selection_index

                local status =
                    display_status(item)

                local clicked =
                    draw_selector_item(
                        tostring(
                            label_getter(item)
                        ),
                        selected,
                        status_dot_color(status),
                        item.repeatable == true,
                        nil,
                        favorite_getter ~= nil
                            and favorite_getter(item) == true,
                        sheetx.row_icon(item, status, is_mission_list)
                    )

                -- One click selects the row; a double click opens its
                -- sheet.
                local double_clicked =
                    open_callback ~= nil
                    and imgui.IsMouseDoubleClicked ~= nil
                    and imgui.IsItemHovered()
                    and imgui.IsMouseDoubleClicked(0)

                if clicked then
                    select_callback(i)
                end

                if double_clicked then
                    select_callback(i)
                    open_callback(i)
                end

                if selected
                    and selection_changed
                    and not imgui.IsItemVisible() then

                    imgui.SetScrollHereY(
                        0.5
                    )
                end

                draw_status_at_item_end(
                    status
                )
            end

            draw_extras(blocks_at[#items + 1])

            list_last_selection[child_id] =
                selection_index
        end
    end

    imgui.EndChild()

    imgui.PopStyleColor()
end

-- A click on an NPC name in a step: the NPC goes to the compass (and the
-- compass window opens). nil when the controller cannot do it, and then the
-- names are not clickable.
local function npc_click(step_text)
    if controller ~= nil and controller.AddCompassNpcByName ~= nil then
        return function(name)
            controller.AddCompassNpcByName(name, step_text)
        end
    end

    return nil
end

-- mark_kind and mark_id (and mark_name) identify the quest or mission, to
-- show and change its checklist.
local function draw_steps(
    steps,
    child_id,
    no_steps_text,
    reserve,
    mark_kind,
    mark_id,
    mark_name,
    locked
)
    if #steps == 0 then
        imgui.TextColored(
            colors.text_dim,
            no_steps_text
        )

        return
    end

    imgui.PushStyleColor(
        ImGuiCol_ChildBg,
        transparent
    )

    if imgui.BeginChild(
        child_id,
        { -1, -(reserve or 76) },
        child_border
    ) then
        local draw =
            imgui.GetWindowDrawList()

        local x, y =
            imgui.GetWindowPos()

        local w, h =
            imgui.GetWindowSize()

        draw_panel(
            draw,
            x,
            y,
            w,
            h,
            true
        )

        local styles = get_styles()

        -- The checklist needs these calls of the interface. Without them the
        -- steps are drawn as before, with no boxes.
        local checklist =
            mark_id ~= nil
            and controller
            and controller.GetStepMarks
            and controller.ToggleStepMark
            and imgui.Checkbox
            and imgui.Indent
            and imgui.Unindent
            and imgui.GetCursorPosY
            and imgui.SetCursorPosY
            and imgui.GetFrameHeight
            and imgui.Dummy

        local marks = {}

        if checklist and locked then
            -- A completed quest or mission: every step is done and cannot
            -- be changed.
            for i = 1, #steps do
                marks[i] = true
            end
        elseif checklist then
            marks =
                controller.GetStepMarks(
                    mark_kind,
                    mark_id,
                    mark_name,
                    steps
                )
        end

        for i, step in ipairs(steps) do
            local text =
                tostring(i)
                    .. '. '
                    .. tostring(i18n.step(step))

            if checklist then
                local done = marks[i] == true
                local top = imgui.GetCursorPosY()
                local box_height = imgui.GetFrameHeight()
                local box_width = box_height + 10
                local box = { done }

                if imgui.Checkbox('##step_done_' .. i, box) and not locked then
                    controller.ToggleStepMark(
                        mark_kind,
                        mark_id,
                        mark_name,
                        steps,
                        i
                    )
                end

                -- The text goes beside the box, indented so that every
                -- line of it stays clear of the box.
                imgui.SetCursorPosY(top)
                imgui.Indent(box_width)

                richtext.draw_wrapped(
                    text,
                    {
                        styles = styles,
                        color = done and colors.text_dim or colors.text,
                        size = step_font_size,
                        items = true,
                        on_npc = npc_click(text),
                        id = tostring(child_id) .. '_' .. i,
                        npc_tooltip = tx('Click to point the compass at it'),
                    }
                )

                imgui.Unindent(box_width)

                -- A short step is as tall as its box.
                local missing = top + box_height - imgui.GetCursorPosY()

                if missing > 0 then
                    imgui.Dummy({ 1, missing })
                end
            else
                richtext.draw_wrapped(
                    text,
                    {
                        styles = styles,
                        color = colors.text,
                        size = step_font_size,
                        items = true,
                        on_npc = npc_click(text),
                        id = tostring(child_id) .. '_' .. i,
                        npc_tooltip = tx('Click to point the compass at it'),
                    }
                )
            end

            imgui.Spacing()
        end
    end

    imgui.EndChild()

    imgui.PopStyleColor()
end

local function draw_selected_status(status)
    local text, color =
        get_status_display(status)

    imgui.TextColored(
        color,
        '[' .. text .. ']'
    )
end

local function draw_mission_info(selected)
    local parts = {}

    if selected.rank ~= nil and selected.rank ~= '' then
        parts[#parts + 1] = tx('Rank ') .. tostring(selected.rank)
    end

    if selected.number ~= nil and selected.number ~= '' then
        parts[#parts + 1] = tx('Mission ') .. tostring(selected.number)
    end

    if selected.mission_type ~= nil and selected.mission_type ~= '' then
        parts[#parts + 1] = tostring(selected.mission_type)
    end

    if #parts > 0 then
        imgui.TextColored(
            colors.text_dim,
            table.concat(parts, '  |  ')
        )
    end

    if selected.reward ~= nil and selected.reward ~= '' then
        imgui.TextColored(
            colors.gold,
            tx('Reward: ') .. tostring(selected.reward)
        )
    end
end

-- A line of the details that jumps to another quest when it is clicked.
-- The mark in front shows if the quest is done ([x]), active ([>]) or not.
local function draw_quest_link(link, section)
    local mark = '[ ] '
    local color = colors.active_status

    if link.status == 'completed' then
        mark = '[x] '
        color = colors.completed
    elseif link.status == 'active' then
        mark = '[>] '
    end

    imgui.PushStyleColor(ImGuiCol_Text, color)

    local clicked =
        imgui.Selectable(
            '  ' .. mark .. link.name
                .. '##quest_link_' .. section
                .. '_' .. tostring(link.id),
            false
        )

    imgui.PopStyleColor()

    return clicked
end

local function draw_metadata(selected)
    local links = nil
    local back = nil

    if controller
        and controller.GetQuestLinks
        and selected.id ~= nil then

        links = controller.GetQuestLinks(selected.id)

        if controller.GetQuestBack then
            back = controller.GetQuestBack()
        end
    end

    if back ~= nil then
        imgui.PushStyleColor(ImGuiCol_Text, colors.text_dim)

        local clicked =
            imgui.Selectable(
                tx('< Back: ') .. back.name .. '##quest_link_back',
                false
            )

        imgui.PopStyleColor()

        if clicked then
            controller.JumpBack()
        end
    end

    if selected.repeatable == true then
        imgui.TextColored(
            colors.active_status,
            tx('Repeatable')
        )
    end

    local fields = {
        { tx('Zone: '), selected.zone },
        { tx('NPC: '), selected.npc },
        { tx('Location: '), selected.loc },
        { tx('Requires: '), selected.req },
        { tx('Prereq: '), selected.prereq },
        { tx('Items: '), selected.items },
    }

    local has_prereq_links =
        links ~= nil
        and #links.prereq > 0

    for _, field in ipairs(fields) do
        if field[2] ~= nil
            and field[2] ~= ''
            and not (
                has_prereq_links
                and field[1] == tx('Prereq: ')
            ) then

            if field[1] == tx('NPC: ') and controller.AddCompassNpcByName then
                -- The NPC that starts the quest: each name (the data may
                -- hold several, separated by "/") is clickable, as in the
                -- steps. The zone of the quest helps to pick the right one.
                local hint = tostring(selected.zone or '') .. ' '
                    .. tostring(selected.loc or '')
                local first = true

                imgui.TextColored(colors.text_dim, field[1])

                for part in tostring(field[2]):gmatch('[^/]+') do
                    local name = part:match('^%s*(.-)%s*$')

                    if name ~= '' then
                        if not first then
                            imgui.SameLine(0, 0)
                            imgui.TextColored(colors.text_dim, ' / ')
                        end

                        first = false

                        imgui.SameLine(0, 0)
                        imgui.TextColored(richtext.COLORS.npc, name)

                        if imgui.IsItemHovered() then
                            pcall(function()
                                local min_x, min_y = imgui.GetItemRectMin()
                                local max_x, max_y = imgui.GetItemRectMax()

                                imgui.GetWindowDrawList():AddLine(
                                    { min_x, max_y },
                                    { max_x, max_y },
                                    imgui.GetColorU32(richtext.COLORS.npc),
                                    1
                                )
                            end)

                            if imgui.SetTooltip then
                                imgui.SetTooltip(
                                    tx('Click to point the compass at it')
                                )
                            end

                            if imgui.IsItemClicked() then
                                controller.AddCompassNpcByName(name, hint)
                            end
                        end
                    end
                end
            else
                imgui.TextColored(
                    colors.text_dim,
                    field[1]
                        .. tostring(field[2])
                )
            end
        end
    end

    if has_prereq_links then
        imgui.TextColored(colors.text_dim, tx('Prereq: '))

        for _, link in ipairs(links.prereq) do
            if draw_quest_link(link, 'prereq') then
                controller.JumpToQuest(link.id)
            end
        end

        if links.has_other_text then
            imgui.TextColored(
                colors.text_dim,
                '  ' .. tostring(selected.prereq)
            )
        end
    end

    if links ~= nil
        and #links.next > 0 then

        imgui.TextColored(colors.text_dim, tx('Next: '))

        for _, link in ipairs(links.next) do
            if draw_quest_link(link, 'next') then
                controller.JumpToQuest(link.id)
            end
        end

        if links.more > 0 then
            imgui.TextColored(
                colors.text_dim,
                '  ' .. string.format(tx('+%d more'), links.more)
            )
        end
    end

    if selected.reward ~= nil
        and selected.reward ~= '' then

        imgui.TextColored(
            colors.gold,
            tx('Reward: ')
                .. tostring(selected.reward)
        )
    end
end

-- The note box of the details panel needs these calls.
local function notes_enabled()
    return controller ~= nil
        and controller.GetNote ~= nil
        and controller.SetNote ~= nil
        and imgui.InputText ~= nil
end

-- A single line where the player writes a note about the quest or mission.
-- It is saved as it is typed.
local function draw_note_input(kind, selected, width)
    if not notes_enabled() then
        return
    end

    local key = kind .. ':' .. tostring(selected.id)
        .. ':' .. tostring(selected.name)

    -- The box shows the note of the item selected now.
    if note_key ~= key then
        note_key = key
        note_buffer[1] = controller.GetNote(kind, selected)
    end

    local field_width = math.max(120, width - 24)

    imgui.SetCursorPosX(
        (imgui.GetWindowWidth() - field_width) * 0.5
    )

    imgui.PushItemWidth(field_width)

    local typed =
        imgui.InputText(
            '##JournalNote',
            note_buffer,
            (controller.personal and controller.personal.NOTE_MAX or 240) + 1
        )

    imgui.PopItemWidth()

    local active = imgui.IsItemActive()

    if active then
        note_input_active = true
    end

    if typed then
        controller.SetNote(kind, selected, note_buffer[1])
    end

    -- Hint inside the empty box.
    if note_buffer[1] == '' and not active then
        local box_x, box_y = imgui.GetItemRectMin()
        local _, box_bottom = imgui.GetItemRectMax()

        imgui.GetWindowDrawList():AddText(
            {
                box_x + 8,
                box_y
                    + (
                        (box_bottom - box_y)
                        - imgui.GetTextLineHeight()
                    ) * 0.5,
            },
            imgui.GetColorU32(colors.text_dim),
            tx('Add a note')
        )
    end
end

-- The pin button, and beside it a star button for the favorites.
local function draw_details_button(
    kind,
    selected,
    width
)
    local button_width =
        math.max(
            120,
            width - 24
        )

    if controller
        and controller.IsPinned
        and controller.ToggleItemPin then

        imgui.SetCursorPosX(
            (
                imgui.GetWindowWidth()
                - button_width
            ) * 0.5
        )

        local pinned =
            controller.IsPinned(
                kind,
                selected
            )

        local can_favorite =
            controller.IsFavorite ~= nil
            and controller.ToggleFavorite ~= nil

        local gap = 8

        local star_width =
            can_favorite
            and math.floor(ui_button_height * 1.4)
            or 0

        local pin_width =
            can_favorite
            and (button_width - star_width - gap)
            or button_width

        if imgui.Button(
            pinned
                and tx('Unpin from Tracker')
                or tx('Pin to Tracker'),
            {
                pin_width,
                ui_button_height,
            }
        ) then
            controller.ToggleItemPin(
                kind,
                selected
            )
        end

        if can_favorite then
            imgui.SameLine(0, gap)

            local favorite =
                controller.IsFavorite(kind, selected)

            if favorite then
                imgui.PushStyleColor(
                    ImGuiCol_Button,
                    colors.button_active
                )
            end

            if imgui.Button(
                '##JournalFavoriteButton',
                { star_width, ui_button_height }
            ) then
                controller.ToggleFavorite(kind, selected)
            end

            if favorite then
                imgui.PopStyleColor()
            end

            local min_x, min_y = imgui.GetItemRectMin()
            local max_x, max_y = imgui.GetItemRectMax()
            local size = (max_y - min_y) * 0.6

            icons.draw_star(
                imgui.GetWindowDrawList(),
                min_x + ((max_x - min_x) - size) * 0.5,
                min_y + ((max_y - min_y) - size) * 0.5,
                size,
                imgui.GetColorU32(
                    favorite and colors.favorite or colors.text_dim
                )
            )

            if imgui.IsItemHovered() and imgui.SetTooltip then
                imgui.SetTooltip(
                    favorite
                        and tx('Remove from favorites')
                        or tx('Add to favorites')
                )
            end
        end
    end

    -- Second row: point the compass at the NPC of the current step.
    if controller
        and controller.IsCompassTarget
        and controller.ToggleCompassTarget then

        imgui.SetCursorPosX(
            (
                imgui.GetWindowWidth()
                - button_width
            ) * 0.5
        )

        local targeted = controller.IsCompassTarget(kind, selected)

        if targeted then
            imgui.PushStyleColor(
                ImGuiCol_Button,
                colors.button_active
            )
        end

        if imgui.Button(
            targeted
                and tx('Stop compass')
                or tx('Point compass here'),
            { button_width, ui_button_height }
        ) then
            controller.ToggleCompassTarget(kind, selected)
        end

        if targeted then
            imgui.PopStyleColor()
        end
    end
end

-- Height kept at the bottom of the details panel for the pin button. The
-- rest of the controls (tracker size, opacity, language...) are in the
-- settings window.
local function details_controls_height()
    local rows = 0

    if controller
        and controller.IsPinned
        and controller.ToggleItemPin then

        rows = rows + 1
    end

    -- The note box.
    if notes_enabled() then
        rows = rows + 1
    end

    -- The compass button.
    if controller
        and controller.IsCompassTarget
        and controller.ToggleCompassTarget then

        rows = rows + 1
    end

    return rows * (ui_button_height + 8) + 8
end

local function draw_details_panel(
    kind,
    width,
    area
)
    imgui.PushStyleColor(
        ImGuiCol_ChildBg,
        transparent
    )

    local selected =
        kind == 'Mission'
        and controller.GetSelectedMission()
        or controller.GetSelectedQuest()

    if imgui.BeginChild(
        '##Journal'
            .. kind
            .. 'Details',
        {
            width,
            -1,
        },
        child_border
    ) then
        local draw =
            imgui.GetWindowDrawList()

        local x, y =
            imgui.GetWindowPos()

        local w, h =
            imgui.GetWindowSize()

        draw_panel(
            draw,
            x,
            y,
            w,
            h,
            true
        )

        if selected then
            local steps =
                selected.steps
                or {}

            if kind == 'Mission'
                and area then

                local cover =
                    load_journal_cover(
                        selected.area or area
                    )

                if cover then
                    -- 40 % of the width it had, so the objectives
                    -- have room.
                    local cover_width =
                        math.floor(
                            (width - 24) * 0.4
                        )

                    local ratio = 1.0

                    if cover.width
                        and cover.height
                        and cover.height > 0 then

                        ratio =
                            cover.width
                            / cover.height
                    end

                    draw_journal_cover(
                        cover,
                        cover_width,
                        math.floor(
                            cover_width
                            / ratio
                        )
                    )

                    imgui.Spacing()
                end
            end

            imgui.TextColored(
                colors.gold,
                tostring(
                    selected.name
                        or ''
                )
            )

            -- Repeatable quests: an infinity sign after the name.
            if selected.repeatable == true
                and imgui.GetCursorScreenPos
                and imgui.Dummy then

                local line_height = imgui.GetTextLineHeight()
                local icon_width, icon_height =
                    icons.infinity_size(line_height)

                imgui.SameLine(0, 10)

                local icon_x, icon_y = imgui.GetCursorScreenPos()

                icons.draw_infinity(
                    imgui.GetWindowDrawList(),
                    icon_x,
                    icon_y + (line_height - icon_height) * 0.5,
                    icon_width,
                    icon_height,
                    imgui.GetColorU32(colors.repeatable),
                    2.0
                )

                imgui.Dummy({ icon_width, line_height })
            end

            imgui.Spacing()

            draw_selected_status(
                display_status(selected)
            )

            imgui.Spacing()

            if kind == 'Quest' then
                draw_metadata(
                    selected
                )

                imgui.Spacing()
            elseif kind == 'Mission' then
                draw_mission_info(
                    selected
                )

                imgui.Spacing()
            end

            imgui.Separator()
            imgui.Spacing()

            imgui.TextColored(
                colors.text,
                tx('Objectives')
            )

            -- A completed quest or mission keeps its steps as they are.
            local steps_locked =
                display_status(selected) == 'completed'

            -- How many steps are done, and a button to start over.
            if #steps > 0
                and selected.id ~= nil
                and controller.GetStepMarks
                and controller.ClearStepMarks then

                local _, done_count =
                    controller.GetStepMarks(
                        kind,
                        selected.id,
                        selected.name,
                        steps
                    )

                if steps_locked then
                    done_count = #steps
                end

                imgui.SameLine(0, 10)

                imgui.TextColored(
                    colors.text_dim,
                    string.format('(%d/%d)', done_count, #steps)
                )

                if done_count > 0 and not steps_locked then
                    imgui.SameLine(0, 12)

                    if imgui.SmallButton(
                        tx('Reset steps') .. '##reset_steps'
                    ) then
                        controller.ClearStepMarks(
                            kind,
                            selected.id,
                            selected.name
                        )
                    end
                end
            end

            imgui.Spacing()

            draw_steps(
                steps,
                '##Journal'
                    .. kind
                    .. 'Steps',
                tx('No objectives available.'),
                details_controls_height(),
                kind,
                selected.id,
                selected.name,
                steps_locked
            )

            imgui.Spacing()

            draw_note_input(
                kind,
                selected,
                width
            )

            imgui.Spacing()

            draw_details_button(
                kind,
                selected,
                width
            )
        else
            imgui.TextColored(
                colors.text_dim,
                (kind == 'Mission' and tx('No mission selected.') or tx('No quest selected.'))
            )
        end
    end

    imgui.EndChild()

    imgui.PopStyleColor()
end

local function get_journal_context(
    is_mission_mode
)
    if is_mission_mode then
        local areas =
            controller.GetMissionAreas()

        local names =
            controller.GetMissionAreaNames()

        local selection =
            controller.GetMissionSelection()

        local area =
            areas[
                selection.area_index
            ]

        return areas,
            names,
            selection,
            area,
            'Questline',
            names[area] or ''
    end

    local categories =
        controller.GetQuestCategories()

    local names =
        controller.GetQuestCategoryNames()

    local selection =
        controller.GetQuestSelection()

    local category =
        categories[
            selection.category_index
        ]

    return categories,
        names,
        selection,
        category,
        'Region',
        names[category] or ''
end

-- A button of the area and category popups. A nation uses its own color,
-- every other entry the standard button color. The selected entry gets a
-- light frame.
local function draw_selector_button(
    text,
    selected,
    tint
)
    imgui.PushStyleColor(
        ImGuiCol_Text,
        transparent
    )

    local clicked =
        imgui.Selectable(
            text,
            selected
        )

    local hovered =
        imgui.IsItemHovered()

    imgui.PopStyleColor()

    local draw =
        imgui.GetWindowDrawList()

    local min_x, min_y =
        imgui.GetItemRectMin()

    local max_x, max_y =
        imgui.GetItemRectMax()

    local fill =
        tint and tint.fill
        or colors.button

    if hovered then
        fill =
            tint and lighten(fill, 0.06)
            or colors.button_hover
    end

    local top_left = { min_x + 2, min_y + 1 }
    local bottom_right = { max_x - 2, max_y - 1 }

    draw:AddRectFilled(
        top_left,
        bottom_right,
        imgui.GetColorU32(fill),
        2
    )

    draw:AddRect(
        top_left,
        bottom_right,
        imgui.GetColorU32(
            tint and tint.border
            or colors.frame
        ),
        2,
        0,
        1
    )

    if selected then
        draw:AddRect(
            top_left,
            bottom_right,
            imgui.GetColorU32(
                colors.text
            ),
            2,
            0,
            2
        )
    end

    draw:AddText(
        {
            min_x + 14,
            min_y
                + (
                    (max_y - min_y)
                    - imgui.GetTextLineHeight()
                ) * 0.5,
        },
        imgui.GetColorU32(
            colors.text
        ),
        text
    )

    return clicked
end

local function selector_popup_width(
    items,
    names
)
    local max_width = 0

    for _, item in ipairs(items) do
        max_width =
            math.max(
                max_width,
                imgui.CalcTextSize(
                    tostring(
                        names[item]
                            or item
                    )
                )
            )
    end

    return max_width + 58
end

-- " (30% 26/85)": share of completed entries, rounded down.
local function format_progress(done, total)
    if total == nil or total <= 0 then
        return ''
    end

    return string.format(
        ' (%d%% %d/%d)',
        math.floor(done * 100 / total),
        done,
        total
    )
end

-- Name of every area or category followed by its progress.
local function get_area_labels(
    is_mission_mode,
    items,
    names
)
    local labels = {}

    for _, item in ipairs(items) do
        local done, total = 0, 0

        if is_mission_mode then
            if controller.GetMissionProgress then
                done, total =
                    controller.GetMissionProgress(item)
            end
        elseif controller.GetQuestProgress then
            done, total =
                controller.GetQuestProgress(item)
        end

        labels[item] =
            tostring(names[item] or item)
            .. format_progress(done, total)
    end

    return labels
end

local function draw_selector_popup(
    popup_id,
    items,
    names,
    selected_index,
    on_select,
    footer,
    headers
)
    local popup_width = selector_popup_width(items, names)

    -- Types: a title above the first item of each one.
    for _, title in pairs(headers or {}) do
        popup_width = math.max(
            popup_width,
            (imgui.CalcTextSize(tx(title))) + 28
        )
    end

    imgui.SetNextWindowSize({ popup_width, 0 })

    if not imgui.BeginPopup(
        popup_id
    ) then
        return false
    end

    for i, item in ipairs(items) do
        if headers ~= nil and headers[item] ~= nil then
            if i > 1 then
                imgui.Spacing()
            end

            imgui.TextColored(colors.gold, tx(headers[item]))
        end

        if draw_selector_button(
            tostring(
                names[item]
                    or item
            ),
            i == selected_index,
            area_colors[item]
        ) then
            on_select(i)
            imgui.CloseCurrentPopup()
        end
    end

    if footer ~= nil and footer ~= '' then
        imgui.Spacing()
        imgui.TextColored(colors.text_dim, footer)
    end

    imgui.EndPopup()

    return true
end

-- One button of the Missions / Quests switch. The active one is filled,
-- the other is plain text.
local function toolbar_mode_button(
    label,
    active,
    width,
    tint
)
    -- With a tint the button has its own color: solid when it is the
    -- active one, a dark shade of it (and tinted text) when it is not.
    local fill, hover, pressed, text

    if tint ~= nil then
        local function shade(amount)
            return { tint[1] * amount, tint[2] * amount, tint[3] * amount, 1 }
        end

        fill = active and tint or shade(0.30)
        hover = active and lighten(tint, 0.08) or shade(0.42)
        pressed = active and shade(0.85) or shade(0.50)
        text = active and { 0.08, 0.09, 0.13, 1.00 } or tint
    else
        fill = active and colors.button_active or transparent
        hover = colors.button_hover
        pressed = colors.button_active
        text = active and colors.text or colors.text_dim
    end

    imgui.PushStyleColor(ImGuiCol_Button, fill)
    imgui.PushStyleColor(ImGuiCol_ButtonHovered, hover)
    imgui.PushStyleColor(ImGuiCol_ButtonActive, pressed)
    imgui.PushStyleColor(ImGuiCol_Text, text)

    local clicked =
        imgui.Button(
            label,
            {
                width,
                ui_button_height,
            }
        )

    imgui.PopStyleColor(4)

    return clicked
end

-- The only bar at the top of the Journal: Missions / Quests on the left,
-- then the questline or region selector, with a thin line underneath.
local function draw_journal_toolbar(
    is_mission_mode
)
    local _, _, _, _, _, value =
        get_journal_context(
            is_mission_mode
        )

    imgui.PushStyleColor(
        ImGuiCol_ChildBg,
        transparent
    )

    if imgui.BeginChild(
        '##JournalToolbar',
        {
            -1,
            ui_bar_height,
        },
        false,
        ImGuiWindowFlags_NoScrollbar
            + ImGuiWindowFlags_NoScrollWithMouse
    ) then
        local draw =
            imgui.GetWindowDrawList()

        local x, y =
            imgui.GetWindowPos()

        local w, h =
            imgui.GetWindowSize()

        draw:AddLine(
            { x, y + h - 0.5 },
            { x + w, y + h - 0.5 },
            imgui.GetColorU32(
                colors.frame
            ),
            1
        )

        imgui.SetCursorPosY(6)

        local missions_width =
            imgui.CalcTextSize(tx('Missions'))
            + 36

        local quests_width =
            imgui.CalcTextSize(tx('Quests'))
            + 36

        if toolbar_mode_button(
            tx('Missions##JournalModeMissions'),
            is_mission_mode,
            missions_width,
            colors.mode_mission
        ) and not is_mission_mode then
            controller.SetJournalMode(1)
        end

        imgui.SameLine(0, 4)

        if toolbar_mode_button(
            tx('Quests##JournalModeQuests'),
            not is_mission_mode,
            quests_width,
            colors.mode_quest
        ) and is_mission_mode then
            controller.SetJournalMode(2)
        end

        imgui.SameLine(0, 24)

        local items,
        names,
        index

        if is_mission_mode then
            items =
                controller.GetMissionAreas()

            names =
                controller.GetMissionAreaNames()

            index =
                controller.GetMissionSelection()
                    .area_index
        else
            items =
                controller.GetQuestCategories()

            names =
                controller.GetQuestCategoryNames()

            index =
                controller.GetQuestSelection()
                    .category_index
        end

        local labels =
            get_area_labels(
                is_mission_mode,
                items,
                names
            )

        local area_width =
            selector_popup_width(
                items,
                labels
            ) + 28

        -- The button takes the color of the current nation.
        local tint =
            area_colors[items[index]]

        if tint then
            imgui.PushStyleColor(
                ImGuiCol_Button,
                tint.fill
            )

            imgui.PushStyleColor(
                ImGuiCol_ButtonHovered,
                lighten(tint.fill, 0.06)
            )

            imgui.PushStyleColor(
                ImGuiCol_ButtonActive,
                lighten(tint.fill, 0.12)
            )

            imgui.PushStyleColor(
                ImGuiCol_Text,
                colors.text
            )
        end

        local area_clicked =
            imgui.Button(
                (labels[items[index]] or value)
                    .. '##JournalAreaButton',
                {
                    area_width,
                    ui_button_height,
                }
            )

        if tint then
            imgui.PopStyleColor(4)
        end

        if area_clicked then
            if is_mission_mode then
                journal_area_popup_open =
                    true

                imgui.OpenPopup(
                    '##JournalAreaPopup'
                )
            else
                journal_category_popup_open =
                    true

                imgui.OpenPopup(
                    '##JournalCategoryPopup'
                )
            end
        end

        -- Small down arrow at the right edge of the selector button.
        local min_x, min_y =
            imgui.GetItemRectMin()

        local max_x, max_y =
            imgui.GetItemRectMax()

        local arrow_x = max_x - 16
        local arrow_y =
            (min_y + max_y) * 0.5

        draw:AddTriangleFilled(
            { arrow_x - 4, arrow_y - 2 },
            { arrow_x + 4, arrow_y - 2 },
            { arrow_x, arrow_y + 3 },
            imgui.GetColorU32(
                tint and colors.text
                or colors.text_dim
            )
        )

        -- Opens the settings window.
        local settings_width = 0

        if controller.ToggleSettings then
            settings_width =
                imgui.CalcTextSize(tx('Settings')) + 28
        end

        -- Opens the Active Now window: the active quests and missions, and
        -- the favorites.
        local active_width = 0

        if controller.GetActiveOpen and controller.SetActiveOpen then
            imgui.SameLine(0, 8)

            active_width =
                imgui.CalcTextSize(tx('Active Now')) + 28

            local window_open = controller.GetActiveOpen()

            if window_open then
                imgui.PushStyleColor(
                    ImGuiCol_Button,
                    colors.button_active
                )
            end

            if imgui.Button(
                tx('Active Now') .. '##JournalActiveButton',
                { active_width, ui_button_height }
            ) then
                controller.SetActiveOpen(not window_open)
            end

            if window_open then
                imgui.PopStyleColor()
            end

            -- Green border that pulses: brighter and thicker while the
            -- window is open.
            local pulse =
                (math.sin(os.clock() * 3.0) + 1.0) * 0.5

            local an_min_x, an_min_y = imgui.GetItemRectMin()
            local an_max_x, an_max_y = imgui.GetItemRectMax()

            imgui.GetWindowDrawList():AddRect(
                { an_min_x, an_min_y },
                { an_max_x, an_max_y },
                imgui.GetColorU32({
                    colors.active_border[1],
                    colors.active_border[2],
                    colors.active_border[3],
                    (window_open and 0.70 or 0.40) + 0.30 * pulse,
                }),
                2,
                0,
                window_open and 2.5 or (1.5 + pulse)
            )

            if imgui.IsItemHovered() and imgui.SetTooltip then
                imgui.SetTooltip(
                    tx('Active quests and missions, and your favorites')
                )
            end
        end

        -- The menu groups the guide, the camps and the functions to come.
        -- Its button sits at the right corner, left of Settings.
        local menu_entries = {}

        if controller.ToggleGuide then
            menu_entries[#menu_entries + 1] = {
                id = 'Guide',
                label = tx('New adventurer guide'),
                icon = 'sprout',
                open = controller.GetGuideOpen
                    and controller.GetGuideOpen() or false,
                toggle = controller.ToggleGuide,
            }
        end

        if controller.ToggleCamps then
            menu_entries[#menu_entries + 1] = {
                id = 'Camps',
                label = tx('Camps'),
                tip = tx('Camps: where to gain experience'),
                icon = 'question',
                open = controller.GetCampsOpen
                    and controller.GetCampsOpen() or false,
                toggle = controller.ToggleCamps,
            }
        end

        if controller.ToggleFame then
            menu_entries[#menu_entries + 1] = {
                id = 'Fame',
                label = tx('Fame'),
                tip = tx('Fame of the nations'),
                icon = 'star',
                open = controller.GetFameOpen
                    and controller.GetFameOpen() or false,
                toggle = controller.ToggleFame,
            }
        end

        local menu_width = 0

        if #menu_entries > 0 then
            menu_width = ui_button_height + 8
        end

        -- Shows or hides the compass window: a button with a compass.
        local compass_width = 0

        if controller.GetCompassOpen and controller.SetCompassOpen then
            imgui.SameLine(0, 8)

            compass_width = ui_button_height

            local compass_open = controller.GetCompassOpen()

            if compass_open then
                imgui.PushStyleColor(
                    ImGuiCol_Button,
                    colors.button_active
                )
            end

            if imgui.Button(
                '##JournalCompassButton',
                { compass_width, ui_button_height }
            ) then
                controller.SetCompassOpen(not compass_open)
            end

            if compass_open then
                imgui.PopStyleColor()
            end

            local min_x, min_y = imgui.GetItemRectMin()
            local max_x, max_y = imgui.GetItemRectMax()
            local size = (max_y - min_y) * 0.68

            icons.draw_compass(
                imgui.GetWindowDrawList(),
                min_x + ((max_x - min_x) - size) * 0.5,
                min_y + ((max_y - min_y) - size) * 0.5,
                size,
                imgui.GetColorU32(colors.active_status),
                imgui.GetColorU32(colors.camps_red),
                imgui.GetColorU32(colors.text)
            )

            if imgui.IsItemHovered() and imgui.SetTooltip then
                imgui.SetTooltip(tx('Compass: show or hide'))
            end
        end

        -- Opens the general notes: a button with a sticky note.
        notesx.btn_w = 0

        if controller.notes ~= nil then
            imgui.SameLine(0, 8)

            notesx.btn_w = ui_button_height

            local notes_open = controller.notes.GetOpen()

            if notes_open then
                imgui.PushStyleColor(
                    ImGuiCol_Button,
                    colors.button_active
                )
            end

            if imgui.Button(
                '##JournalNotesButton',
                { notesx.btn_w, ui_button_height }
            ) then
                controller.notes.Toggle()
            end

            if notes_open then
                imgui.PopStyleColor()
            end

            local min_x, min_y = imgui.GetItemRectMin()
            local max_x, max_y = imgui.GetItemRectMax()
            local size = (max_y - min_y) * 0.62

            icons.draw_postit(
                imgui.GetWindowDrawList(),
                min_x + ((max_x - min_x) - size) * 0.5,
                min_y + ((max_y - min_y) - size) * 0.5,
                size,
                imgui.GetColorU32({ 1.0, 0.86, 0.35, 1.0 }),
                imgui.GetColorU32({ 0.80, 0.62, 0.15, 1.0 }),
                imgui.GetColorU32({ 0.45, 0.33, 0.08, 1.0 })
            )

            if imgui.IsItemHovered() and imgui.SetTooltip then
                imgui.SetTooltip(tx('General notes'))
            end
        end

        -- Search box: filters the list by name.
        if controller.SetSearchText then
            imgui.SameLine(0, 24)

            local search_width =
                math.max(
                    160,
                    math.min(
                        420,
                        imgui.GetWindowWidth()
                            - missions_width
                            - quests_width
                            - area_width
                            - settings_width
                            - active_width
                            - menu_width
                            - compass_width
                            - notesx.btn_w
                            - 190
                    )
                )

            imgui.PushItemWidth(search_width)

            -- A jump from a link clears the text of the search in the
            -- controller; the box follows.
            if controller.GetSearchText
                and controller.GetSearchText() == ''
                and journal_search_buffer[1] ~= ''
                and not journal_search_active then

                journal_search_buffer[1] = ''
            end

            local typed =
                imgui.InputText(
                    '##JournalSearch',
                    journal_search_buffer,
                    64
                )

            imgui.PopItemWidth()

            journal_search_active =
                imgui.IsItemActive()

            if typed then
                controller.SetSearchText(
                    journal_search_buffer[1]
                )
            end

            -- Hint inside the empty box.
            if journal_search_buffer[1] == ''
                and not journal_search_active then

                local box_x, box_y =
                    imgui.GetItemRectMin()

                local _, box_bottom =
                    imgui.GetItemRectMax()

                draw:AddText(
                    {
                        box_x + 8,
                        box_y
                            + (
                                (box_bottom - box_y)
                                - imgui.GetTextLineHeight()
                            ) * 0.5,
                    },
                    imgui.GetColorU32(
                        colors.text_dim
                    ),
                    tx('Search')
                )
            end

            if journal_search_buffer[1] ~= '' then
                imgui.SameLine(0, 4)

                if imgui.Button(
                    'x##JournalSearchClear',
                    {
                        ui_button_height,
                        ui_button_height,
                    }
                ) then
                    journal_search_buffer[1] = ''
                    controller.SetSearchText('')
                end
            end
        end

        -- The menu button (three lines) and its list, then the settings
        -- window button: gray, both at the right corner of the
        -- bar, next to the search box.
        if controller.ToggleSettings or #menu_entries > 0 then
            local target_x =
                imgui.GetWindowWidth() - settings_width - menu_width - 14

            if imgui.GetCursorPosX then
                target_x =
                    math.max(target_x, imgui.GetCursorPosX() + 8)
            end

            imgui.SameLine(target_x, 0)
        end

        if #menu_entries > 0 then
            if imgui.Button(
                '##JournalMenuButton',
                { ui_button_height, ui_button_height }
            ) then
                imgui.OpenPopup('##JournalMenuPopup')
            end

            local mb_min_x, mb_min_y = imgui.GetItemRectMin()
            local mb_max_x, mb_max_y = imgui.GetItemRectMax()
            local mb_w = mb_max_x - mb_min_x
            local mb_h = mb_max_y - mb_min_y
            local mb_draw = imgui.GetWindowDrawList()

            for line = -1, 1 do
                local line_y = mb_min_y + mb_h * 0.5 + line * mb_h * 0.18

                mb_draw:AddLine(
                    { mb_min_x + mb_w * 0.28, line_y },
                    { mb_max_x - mb_w * 0.28, line_y },
                    imgui.GetColorU32(colors.text),
                    2
                )
            end

            if imgui.IsItemHovered() and imgui.SetTooltip then
                imgui.SetTooltip(tx('Menu'))
            end

            if settings_width > 0 then
                imgui.SameLine(0, 8)
            end
        end

        if controller.ToggleSettings then
            imgui.PushStyleColor(
                ImGuiCol_Button,
                colors.settings_fill
            )

            imgui.PushStyleColor(
                ImGuiCol_ButtonHovered,
                colors.settings_hover
            )

            imgui.PushStyleColor(
                ImGuiCol_ButtonActive,
                colors.settings_active
            )

            imgui.PushStyleColor(
                ImGuiCol_Text,
                colors.settings_text
            )

            local settings_clicked =
                imgui.Button(
                    tx('Settings') .. '##JournalSettingsButton',
                    {
                        settings_width,
                        ui_button_height,
                    }
                )

            imgui.PopStyleColor(4)

            -- Bright border drawn over the button.
            local sb_min_x, sb_min_y = imgui.GetItemRectMin()
            local sb_max_x, sb_max_y = imgui.GetItemRectMax()

            imgui.GetWindowDrawList():AddRect(
                { sb_min_x, sb_min_y },
                { sb_max_x, sb_max_y },
                imgui.GetColorU32(colors.settings_border),
                2,
                0,
                2
            )

            if settings_clicked then
                controller.ToggleSettings()
            end
        end

        -- The list of the menu: one row for each function (its icon and its
        -- name). The one whose window is open is shown pressed.
        if #menu_entries > 0 and imgui.BeginPopup('##JournalMenuPopup') then
            local row_icon = ui_button_height * 0.62
            local row_width = 0

            for _, entry in ipairs(menu_entries) do
                row_width = math.max(
                    row_width,
                    (imgui.CalcTextSize(entry.label))
                )
            end

            row_width = row_width + (row_icon + 24) * 2

            for _, entry in ipairs(menu_entries) do
                if entry.open then
                    imgui.PushStyleColor(
                        ImGuiCol_Button,
                        colors.button_active
                    )
                end

                local row_clicked = imgui.Button(
                    entry.label .. '##JournalMenu' .. entry.id,
                    { row_width, ui_button_height }
                )

                if entry.open then
                    imgui.PopStyleColor()
                end

                local r_min_x, r_min_y = imgui.GetItemRectMin()
                local r_max_x, r_max_y = imgui.GetItemRectMax()
                local r_draw = imgui.GetWindowDrawList()
                local r_x = r_min_x + 12
                local r_y = r_min_y + ((r_max_y - r_min_y) - row_icon) * 0.5

                if entry.icon == 'sprout' then
                    icons.draw_sprout(
                        r_draw, r_x, r_y, row_icon,
                        imgui.GetColorU32(colors.leaf),
                        imgui.GetColorU32(colors.leaf_2),
                        imgui.GetColorU32(colors.stem)
                    )
                elseif entry.icon == 'question' then
                    icons.draw_question(
                        r_draw, r_x, r_y, row_icon,
                        imgui.GetColorU32(colors.camps_red)
                    )
                elseif entry.icon == 'star' then
                    -- The icon of the Fame Checkers; the star drawn with
                    -- lines when there is no image.
                    local fame_icon = controller.worldmark
                        and controller.worldmark.GetIcon
                        and controller.worldmark.GetIcon('fame')
                    local image_drawn = false

                    if fame_icon ~= nil then
                        image_drawn = pcall(function()
                            r_draw:AddImage(
                                fame_icon.id,
                                { r_x, r_y },
                                {
                                    r_x + row_icon * fame_icon.width
                                        / fame_icon.height,
                                    r_y + row_icon,
                                },
                                { 0, 0 },
                                { 1, 1 },
                                imgui.GetColorU32({ 1, 1, 1, 1 })
                            )
                        end)
                    end

                    -- Five-point star, drawn with lines.
                    local cx = r_x + row_icon * 0.5
                    local cy = r_y + row_icon * 0.53
                    local rad = row_icon * 0.5
                    local star_color = imgui.GetColorU32(colors.favorite)
                    local points = {}

                    for k = 0, 4 do
                        local ang = -math.pi / 2 + k * (2 * math.pi / 5)
                        points[k] = {
                            cx + math.cos(ang) * rad,
                            cy + math.sin(ang) * rad,
                        }
                    end

                    for k = 0, image_drawn and -1 or 4 do
                        local p1 = points[k]
                        local p2 = points[(k + 2) % 5]

                        r_draw:AddLine(
                            { p1[1], p1[2] }, { p2[1], p2[2] },
                            star_color, math.max(1.5, row_icon * 0.09)
                        )
                    end
                end

                if entry.tip and imgui.IsItemHovered()
                    and imgui.SetTooltip then

                    imgui.SetTooltip(entry.tip)
                end

                if row_clicked then
                    entry.toggle()
                    imgui.CloseCurrentPopup()
                end
            end

            imgui.EndPopup()
        end

        local popup_id =
            is_mission_mode
            and '##JournalAreaPopup'
            or '##JournalCategoryPopup'

        local opened =
            draw_selector_popup(
                popup_id,
                items,
                labels,
                index,
                function(i)
                    if is_mission_mode then
                        controller.SetMissionSelection(
                            i,
                            1
                        )

                        journal_area_popup_open =
                            false
                    else
                        controller.SetQuestSelection(
                            i,
                            1
                        )

                        journal_category_popup_open =
                            false
                    end
                end,
                controller.GetTotalProgress
                    and (
                        tx('Total')
                        .. format_progress(
                            controller.GetTotalProgress(
                                is_mission_mode
                            )
                        )
                    )
                    or nil,
                is_mission_mode
                    and controller.GetMissionAreaTypes
                    and controller.GetMissionAreaTypes()
                    or nil
            )

        if is_mission_mode then
            journal_area_popup_open =
                opened
        else
            journal_category_popup_open =
                opened
        end
    end

    imgui.EndChild()

    imgui.PopStyleColor()
end

local function draw_journal_list(
    is_mission_mode,
    width
)
    local items,
    selection

    local hide_label,
    getter,
    setter,
    callback,
    show_label,
    show_getter,
    show_setter

    local id,
    spacing

    -- What a double click on a row does (opens its sheet).
    local open_fn

    if is_mission_mode then
        items =
            controller.GetMissionList()

        selection =
            controller.GetMissionSelection()

        hide_label =
            tx('Hide complete missions')

        getter =
            controller.GetHideCompleteMissions

        setter =
            controller.SetHideCompleteMissions

        show_label =
            tx('Show not started##JournalShowMissions')

        show_getter =
            controller.GetShowNotStartedMissions

        show_setter =
            controller.SetShowNotStartedMissions

        callback = function(index)
            controller.SetMissionSelection(
                selection.area_index,
                index
            )
        end

        open_fn = function()
            open_sheet('Mission')
        end

        id =
            '##JournalMissionList'

        spacing =
            false
    else
        items =
            controller.GetQuestList()

        selection =
            controller.GetQuestSelection()

        hide_label =
            tx('Hide complete quests')

        getter =
            controller.GetHideCompleteQuests

        setter =
            controller.SetHideCompleteQuests

        show_label =
            tx('Show not started##JournalShowQuests')

        show_getter =
            controller.GetShowNotStartedQuests

        show_setter =
            controller.SetShowNotStartedQuests

        callback = function(index)
            controller.SetQuestSelection(
                selection.category_index,
                index
            )
        end

        open_fn = function()
            open_sheet('Quest')
        end

        id =
            '##JournalQuestList'

        spacing =
            true
    end

    -- Extra rows: the chapters and notes of the missions, or the zone titles
    -- of the quests.
    local list_extras = nil

    if is_mission_mode then
        list_extras = controller.GetMissionListExtras
            and controller.GetMissionListExtras()
            or nil
    elseif controller.GetQuestListGroups then
        for _, group in ipairs(controller.GetQuestListGroups()) do
            list_extras = list_extras or {}
            list_extras[#list_extras + 1] = {
                at_index = group.index,
                title = group.zone,
            }
        end
    end

    draw_selectable_status_list(
        id,
        width,
        items,
        is_mission_mode
            and selection.mission_index
            or selection.quest_index,
        hide_label,
        getter,
        setter,
        show_label,
        show_getter,
        show_setter,
        function(item)
            if item.code ~= nil then
                return tostring(item.code)
                    .. '. '
                    .. tostring(item.name or '')
                    .. (item.finale and (' (' .. tx('Finale') .. ')') or '')
            end

            return tostring(
                item.name or ''
            )
        end,
        callback,
        spacing,
        controller.GetOnlyRepeatableQuests
            and not is_mission_mode
            and controller.GetOnlyRepeatableQuests
            or nil,
        controller.SetOnlyRepeatableQuests
            and not is_mission_mode
            and controller.SetOnlyRepeatableQuests
            or nil,
        open_fn,
        list_extras,
        function(item)
            return controller.IsFavorite ~= nil
                and controller.IsFavorite(
                    is_mission_mode and 'Mission' or 'Quest',
                    item
                ) == true
        end,
        controller.GetOnlyFavorites
            and function()
                return controller.GetOnlyFavorites(
                    is_mission_mode and 'Mission' or 'Quest'
                )
            end
            or nil,
        controller.SetOnlyFavorites
            and function(value)
                controller.SetOnlyFavorites(
                    is_mission_mode and 'Mission' or 'Quest',
                    value
                )
            end
            or nil
    )
end

local function draw_journal_mini()
    if not can_draw_ui()
        or not controller
        or not controller.GetJournalMiniState then

        return
    end

    local state =
        controller.GetJournalMiniState()

    if not state
        or not state.visible then

        return
    end

    -- The button is only drawn when the setting is on.
    if controller.GetJournalMiniButton
        and not controller.GetJournalMiniButton() then

        return
    end

    local journal_state =
        controller.GetJournalWindowState()

    if journal_state
        and journal_state.visible then

        return
    end

    load_journal_mini_texture()

    if journal_mini_restore_window then
        if state.x ~= nil
            and state.y ~= nil then

            imgui.SetNextWindowPos({
                state.x,
                state.y,
            })
        end

        imgui.SetNextWindowSize({
            72,
            72,
        })

        journal_mini_restore_window =
            false
    end

    push_theme()

    if imgui.Begin(
        'Journal Mini###JournalMini',
        { true },
        ImGuiWindowFlags_NoTitleBar
            + ImGuiWindowFlags_NoResize
            + ImGuiWindowFlags_NoScrollbar
            + ImGuiWindowFlags_NoScrollWithMouse
            + ImGuiWindowFlags_NoCollapse
    ) then
        local texture_id

        if journal_mini_texture ~= nil then
            texture_id =
                tonumber(
                    ffi.cast(
                        'uint32_t',
                        journal_mini_texture
                    )
                )
        end

        imgui.SetCursorPos({
            6,
            6,
        })

        local opened

        if texture_id ~= nil then
            opened =
                imgui.ImageButton(
                    texture_id,
                    {
                        60,
                        60,
                    },
                    {
                        0,
                        0,
                    },
                    {
                        1,
                        1,
                    },
                    -1,
                    {
                        0,
                        0,
                        0,
                        0,
                    },
                    {
                        1,
                        1,
                        1,
                        1,
                    }
                )
        else
            opened =
                imgui.Button(
                    'Open',
                    {
                        60,
                        60,
                    }
                )
        end

        if opened then
            controller.SetJournalMini(false)
            controller.SetJournalVisible(true)

            journal_restore_window =
                true
        end

        local x, y =
            imgui.GetWindowPos()

        if x ~= state.x
            or y ~= state.y then

            controller.SetJournalMiniGeometry(
                x,
                y
            )
        end
    end

    imgui.End()
    pop_theme()
end

-- One objective of the sheet. state is 'done' (an earlier step), 'current'
-- or 'pending'. Plain characters keep it readable with any font.
local function draw_sheet_step(index, text, state)
    local marker = '[ ]'
    local color = colors.text

    if state == 'done' then
        marker = '[x]'
        color = colors.text_dim
    elseif state == 'current' then
        marker = '[>]'
        color = colors.active_status
    end

    richtext.draw_wrapped(
        marker
            .. ' '
            .. tostring(index)
            .. '. '
            .. tostring(i18n.step(text)),
        {
            styles = get_styles(),
            color = color,
            size = step_font_size,
            items = true,
            on_npc = npc_click(text),
            id = 'sheet' .. tostring(index),
            npc_tooltip = tx('Click to point the compass at it'),
        }
    )

    imgui.Spacing()
end

local function draw_sheet_window()
    if not sheet_open
        or not can_draw_ui()
        or not controller
        or not controller.GetJournalWindowState then

        return
    end

    local journal =
        controller.GetJournalWindowState()

    -- The sheet goes away with the Journal, unless it was opened without it.
    if not journal
        or (not journal.visible and not sheetx.standalone) then

        sheet_open = false

        return
    end

    if sheet_restore then
        sheet_restore = false

        local sheet_w = sheetx.w or scaled(520)
        local sheet_h = sheetx.h or scaled(660)

        imgui.SetNextWindowSize({ sheet_w, sheet_h })

        local pos_x = (journal.x or 0) + 60
        local pos_y = (journal.y or 0) + 60

        if not journal.visible then
            -- Without the Journal: near the middle of the screen.
            local ok, screen_w, screen_h = pcall(function()
                local size = imgui.GetIO().DisplaySize

                return size.x, size.y
            end)

            if ok and screen_w and screen_h then
                pos_x = math.max(20, (screen_w - sheet_w) * 0.5)
                pos_y = math.max(20, (screen_h - sheet_h) * 0.4)
            end
        end

        imgui.SetNextWindowPos({ pos_x, pos_y })
    end

    -- The player can drag the corner to resize it.
    if imgui.SetNextWindowSizeConstraints then
        imgui.SetNextWindowSizeConstraints(
            { scaled(300), scaled(200) },
            { scaled(1400), scaled(1400) }
        )
    end

    local kind = sheet_kind

    local selected =
        kind == 'Mission'
        and controller.GetSelectedMission()
        or controller.GetSelectedQuest()

    push_theme()

    local font_pushed =
        journal_font ~= nil

    if font_pushed then
        imgui.PushFont(
            journal_font,
            journal_font_size
        )
    end

    local open = { true }

    -- The grip of the corner, visible.
    imgui.PushStyleColor(ImGuiCol_ResizeGrip, { 0.80, 0.84, 0.95, 0.30 })
    imgui.PushStyleColor(ImGuiCol_ResizeGripHovered, { 0.80, 0.84, 0.95, 0.60 })
    imgui.PushStyleColor(ImGuiCol_ResizeGripActive, { 0.80, 0.84, 0.95, 0.90 })

    scalex.before('sheet')

    if imgui.Begin(
        (
            kind == 'Mission'
            and tx('Mission Sheet')
            or tx('Quest Sheet')
        ) .. '###JournalSheet',
        open,
        ImGuiWindowFlags_NoSavedSettings
            + ImGuiWindowFlags_NoCollapse
    ) then
        scalex.after('sheet')

        local draw =
            imgui.GetWindowDrawList()

        local x, y =
            imgui.GetWindowPos()

        local width, height =
            imgui.GetWindowSize()

        -- Remembered for the next time it opens.
        sheetx.w, sheetx.h = width, height

        draw_window_panel(
            draw,
            x,
            y,
            width,
            height,
            true
        )

        if not selected then
            imgui.TextColored(
                colors.text_dim,
                (kind == 'Mission' and tx('No mission selected.') or tx('No quest selected.'))
            )
        else
            local status =
                display_status(selected)

            -- The cover of the area, small, next to the name.
            if kind == 'Mission' then
                local areas =
                    controller.GetMissionAreas()

                local selection =
                    controller.GetMissionSelection()

                local cover =
                    load_journal_cover(
                        selected.area
                            or areas[selection.area_index]
                    )

                if cover then
                    draw_journal_cover(
                        cover,
                        56,
                        56,
                        true
                    )

                    imgui.SameLine(0, 12)
                end
            end

            imgui.TextColored(
                colors.gold,
                tostring(selected.name or '')
            )

            imgui.Spacing()

            draw_selected_status(status)

            -- How far along: the game does not tell the step, so it is the
            -- step pinned in the Tracker.
            local step, total

            if controller.GetPinStep then
                step, total =
                    controller.GetPinStep(
                        kind,
                        selected
                    )
            end

            if status == 'completed' then
                imgui.TextColored(
                    colors.text_dim,
                    tx('All steps completed.')
                )
            elseif step then
                imgui.TextColored(
                    colors.text_dim,
                    string.format(
                        tx('Step %d of %d (pinned in the Tracker)'),
                        step,
                        total
                    )
                )
            elseif status == 'active' then
                imgui.TextColored(
                    colors.text_dim,
                    tx('Pin it to the Tracker to follow your step.')
                )
            end

            imgui.Spacing()

            if kind == 'Quest' then
                draw_metadata(selected)
            else
                draw_mission_info(selected)
            end

            imgui.Spacing()
            imgui.Separator()
            imgui.Spacing()

            imgui.TextColored(
                colors.text,
                tx('Objectives')
            )

            imgui.Spacing()

            local steps =
                selected.steps
                or {}

            if #steps == 0 then
                imgui.TextColored(
                    colors.text_dim,
                    tx('No objectives available.')
                )
            end

            for i, text in ipairs(steps) do
                local state = 'pending'

                if status == 'completed'
                    or (step and i < step) then

                    state = 'done'
                elseif step and i == step then
                    state = 'current'
                end

                draw_sheet_step(
                    i,
                    text,
                    state
                )
            end

            -- The note of the player.
            local note =
                controller.GetNote
                and controller.GetNote(kind, selected)
                or ''

            if note ~= '' then
                imgui.Spacing()
                imgui.Separator()
                imgui.Spacing()

                imgui.TextColored(
                    colors.text,
                    tx('Note')
                )

                imgui.Spacing()

                richtext.draw_wrapped(
                    note,
                    {
                        color = colors.note,
                        size = step_font_size,
                    }
                )
            end
        end
    end

    imgui.End()
    imgui.PopStyleColor(3)

    if not open[1] then
        sheet_open = false
    end

    if font_pushed then
        imgui.PopFont()
    end

    pop_theme()
end

-- One row of the progress window: name, bar and "30%  26/85". The row is
-- clickable when on_click is given.
local function draw_progress_row(
    label,
    done,
    total,
    id,
    label_width,
    on_click
)
    local clicked =
        imgui.Selectable(
            '##progress_row_' .. id,
            false
        )

    local hovered = imgui.IsItemHovered()

    local draw = imgui.GetWindowDrawList()

    local min_x, min_y = imgui.GetItemRectMin()
    local max_x, max_y = imgui.GetItemRectMax()
    local middle = (min_y + max_y) * 0.5

    if hovered and on_click then
        draw:AddRectFilled(
            { min_x + 2, min_y + 1 },
            { max_x - 2, max_y - 1 },
            imgui.GetColorU32({
                colors.button_hover[1],
                colors.button_hover[2],
                colors.button_hover[3],
                0.55,
            }),
            2
        )
    end

    local ratio = 0

    if total > 0 then
        ratio = done / total
    end

    local percent_text =
        string.format(
            '%d%%  %d/%d',
            math.floor(ratio * 100),
            done,
            total
        )

    local percent_width = imgui.CalcTextSize(percent_text)
    local line_height = imgui.GetTextLineHeight()
    local text_y = middle - line_height * 0.5

    draw:AddText(
        { min_x + 8, text_y },
        imgui.GetColorU32(colors.text),
        label
    )

    draw:AddText(
        { max_x - 8 - percent_width, text_y },
        imgui.GetColorU32(colors.text_dim),
        percent_text
    )

    local bar_left = min_x + 8 + label_width + 14
    local bar_right = max_x - 8 - percent_width - 14

    if bar_right - bar_left >= 24 then
        draw:AddRectFilled(
            { bar_left, middle - 4 },
            { bar_right, middle + 4 },
            imgui.GetColorU32(colors.header_bg),
            3
        )

        local fill = (bar_right - bar_left) * ratio

        if fill >= 1 then
            draw:AddRectFilled(
                { bar_left, middle - 4 },
                { bar_left + fill, middle + 4 },
                imgui.GetColorU32(
                    total > 0 and done >= total
                        and colors.completed
                        or colors.active_status
                ),
                3
            )
        end
    end

    if clicked and on_click then
        on_click()
    end
end

-- Opens an area in the Journal from the progress window.
local function open_area_from_progress(is_mission_mode, index)
    controller.SetJournalMode(is_mission_mode and 1 or 2)

    if controller.SetSearchText then
        journal_search_buffer[1] = ''
        controller.SetSearchText('')
    end

    if is_mission_mode then
        controller.SetMissionSelection(index, 1)
    else
        controller.SetQuestSelection(index, 1)
    end
end

local function draw_progress_section(is_mission_mode, label_width)
    local items, names

    if is_mission_mode then
        items = controller.GetMissionAreas()
        names = controller.GetMissionAreaNames()
    else
        items = controller.GetQuestCategories()
        names = controller.GetQuestCategoryNames()
    end

    local done, total = controller.GetTotalProgress(is_mission_mode)

    draw_progress_row(
        is_mission_mode and tx('Missions') or tx('Quests'),
        done,
        total,
        is_mission_mode and 'total_missions' or 'total_quests',
        label_width,
        nil
    )

    imgui.Separator()

    for index, item in ipairs(items) do
        local area_done, area_total = 0, 0

        if is_mission_mode then
            area_done, area_total = controller.GetMissionProgress(item)
        else
            area_done, area_total = controller.GetQuestProgress(item)
        end

        if area_total > 0 then
            draw_progress_row(
                tostring(names[item] or item),
                area_done,
                area_total,
                (is_mission_mode and 'm_' or 'q_') .. tostring(item),
                label_width,
                function()
                    open_area_from_progress(is_mission_mode, index)
                end
            )
        end
    end
end

local function draw_progress_window()
    if not progress_open
        or not can_draw_ui()
        or not controller
        or not controller.GetTotalProgress
        or not controller.GetJournalWindowState then

        return
    end

    local journal = controller.GetJournalWindowState()

    -- The progress window goes away with the Journal.
    if not journal
        or not journal.visible then

        progress_open = false

        return
    end

    if progress_restore then
        progress_restore = false

        imgui.SetNextWindowSize({ scaled(460), scaled(600) })

        imgui.SetNextWindowPos({
            (journal.x or 0) + 80,
            (journal.y or 0) + 80,
        })
    end

    push_theme()

    local font_pushed = journal_font ~= nil

    if font_pushed then
        imgui.PushFont(journal_font, journal_font_size)
    end

    local open = { true }

    scalex.before('progress')

    if imgui.Begin(
        tx('Progress') .. '###JournalProgress',
        open,
        ImGuiWindowFlags_NoSavedSettings
            + ImGuiWindowFlags_NoCollapse
    ) then
        scalex.after('progress')

        local draw = imgui.GetWindowDrawList()
        local x, y = imgui.GetWindowPos()
        local width, height = imgui.GetWindowSize()

        draw_window_panel(draw, x, y, width, height, true)

        -- Names of both lists share one column so the bars line up.
        local label_width = imgui.CalcTextSize(tx('Missions'))

        for _, is_mission_mode in ipairs({ true, false }) do
            local items, names

            if is_mission_mode then
                items = controller.GetMissionAreas()
                names = controller.GetMissionAreaNames()
            else
                items = controller.GetQuestCategories()
                names = controller.GetQuestCategoryNames()
            end

            for _, item in ipairs(items) do
                label_width =
                    math.max(
                        label_width,
                        imgui.CalcTextSize(tostring(names[item] or item))
                    )
            end
        end

        label_width = math.min(label_width, width * 0.45)

        draw_progress_section(true, label_width)

        imgui.Spacing()
        imgui.Spacing()

        draw_progress_section(false, label_width)
    end

    imgui.End()

    if not open[1] then
        progress_open = false
    end

    if font_pushed then
        imgui.PopFont()
    end

    pop_theme()
end

-- Active Now window ---------------------------------------------------------

-- A text that fits in max_width, cut with "..." when it is longer.
local function fit_text(text, max_width)
    text = tostring(text or '')

    if max_width <= 0 then
        return ''
    end

    if (imgui.CalcTextSize(text)) <= max_width then
        return text
    end

    local low = 0
    local high = #text

    while low < high do
        local middle = math.ceil((low + high) / 2)

        if (imgui.CalcTextSize(text:sub(1, middle) .. '...'))
            <= max_width then

            low = middle
        else
            high = middle - 1
        end
    end

    return text:sub(1, low) .. '...'
end

-- Opens the item of a row in the Journal.
local function open_active_row(row)
    local ok = false

    if row.kind == 'mission' then
        ok = controller.JumpToMission ~= nil
            and controller.JumpToMission(row.area, row.id, row.name)
    else
        ok = controller.JumpToQuest ~= nil
            and controller.JumpToQuest(row.id)
    end

    if ok then
        -- The jump cleared the search text; the box must follow.
        journal_search_buffer[1] = ''

        if sheet_open then
            sheet_kind = row.kind == 'mission' and 'Mission' or 'Quest'
        end
    else
        active_notice = {
            text = tx('Not found in the Journal data.'),
            time = os.clock(),
        }
    end
end

-- One row of the window: up to three lines (the name, the step and the
-- note) and a click on any of them opens the item in the Journal. With
-- remove, a small button under the row takes it out of the favorites (on
-- its own line: a button on the same line as a row can swallow its clicks).
-- Returns true when the row was clicked.
local function draw_active_row(row, id, remove)
    local clicked = false
    local draw = imgui.GetWindowDrawList()
    local text_left = nil
    local status = display_status(row)

    for line = 1, 3 do
        if line < 3 or row.note ~= '' then
            local hit =
                imgui.Selectable(
                    '##active_row_' .. id .. '_' .. line,
                    false
                )

            local hovered = imgui.IsItemHovered()
            local min_x, min_y = imgui.GetItemRectMin()
            local max_x, max_y = imgui.GetItemRectMax()
            local middle = (min_y + max_y) * 0.5
            local line_height = imgui.GetTextLineHeight()
            local text_y = middle - line_height * 0.5

            if hit then
                clicked = true
            end

            if line == 1 then
                -- The text of the other lines lines up with the name.
                text_left = min_x + 28
            end

            if hovered then
                draw:AddRectFilled(
                    { min_x + 2, min_y + 1 },
                    { max_x - 2, max_y - 1 },
                    imgui.GetColorU32({
                        colors.button_hover[1],
                        colors.button_hover[2],
                        colors.button_hover[3],
                        0.55,
                    }),
                    2
                )
            end

            if line == 1 then
                local icon = sheetx.row_icon(row, status, row.kind == 'mission')
                local icon_drawn = false

                if icon ~= nil then
                    icon_drawn = pcall(function()
                        local icon_h = math.min(max_y - min_y - 2, 22)
                        local icon_w = icon_h * icon.width / icon.height

                        if icon_w > 20 then
                            icon_h = icon_h * 20 / icon_w
                            icon_w = 20
                        end

                        draw:AddImage(
                            icon.id,
                            { min_x + 15 - icon_w * 0.5, middle - icon_h * 0.5 },
                            { min_x + 15 + icon_w * 0.5, middle + icon_h * 0.5 },
                            { 0, 0 },
                            { 1, 1 },
                            imgui.GetColorU32({ 1, 1, 1, 1 })
                        )
                    end)
                end

                if not icon_drawn then
                    draw:AddCircleFilled(
                        { min_x + 15, middle },
                        5.5,
                        imgui.GetColorU32(status_dot_color(status)),
                        14
                    )
                end

                -- On the right: the pin sign when it is in the Tracker, and
                -- the area or category.
                local right_x = max_x - 8
                local label_width =
                    math.min(
                        imgui.CalcTextSize(row.label),
                        (max_x - min_x) * 0.34
                    )

                if row.label ~= '' then
                    draw:AddText(
                        { right_x - label_width, text_y },
                        imgui.GetColorU32(colors.text_dim),
                        fit_text(row.label, label_width)
                    )

                    right_x = right_x - label_width - 10
                end

                if row.pinned then
                    local size = line_height * 0.9

                    icons.draw_pin(
                        draw,
                        right_x - size,
                        middle - size * 0.5,
                        size,
                        imgui.GetColorU32(colors.active_status),
                        true
                    )

                    right_x = right_x - size - 10
                end

                -- After the name: the infinity sign and the star.
                local after = 0
                local star_size = line_height * 0.8
                local infinity_width = (icons.infinity_size(line_height))

                if row.repeatable then
                    after = after + infinity_width + 8
                end

                if row.favorite and not remove then
                    after = after + star_size + 8
                end

                local name =
                    fit_text(row.name, right_x - text_left - after)

                draw:AddText(
                    { text_left, text_y },
                    imgui.GetColorU32(
                        status == 'completed'
                            and colors.text_dim
                            or colors.text
                    ),
                    name
                )

                local after_x = text_left + (imgui.CalcTextSize(name)) + 10

                if row.repeatable then
                    local icon_width, icon_height =
                        icons.infinity_size(line_height)

                    icons.draw_infinity(
                        draw,
                        after_x,
                        text_y + (line_height - icon_height) * 0.5,
                        icon_width,
                        icon_height,
                        imgui.GetColorU32(colors.repeatable),
                        2.0
                    )

                    after_x = after_x + icon_width + 8
                end

                if row.favorite and not remove then
                    icons.draw_star(
                        draw,
                        after_x,
                        text_y + (line_height - star_size) * 0.5,
                        star_size,
                        imgui.GetColorU32(colors.favorite)
                    )
                end

            elseif line == 2 then
                local text
                local color = colors.text_dim

                if row.missing then
                    text = tx('Not found in the Journal data.')
                elseif status == 'completed' then
                    text = tx('Completed')
                    color = colors.completed
                elseif status ~= 'active' then
                    text = (get_status_display(status))
                elseif row.total == 0 then
                    text = tx('No objectives available.')
                elseif row.all_done then
                    text = tx('All steps completed.')
                else
                    text = string.format(
                        '%d/%d  %s',
                        row.step,
                        row.total,
                        tostring(i18n.step(row.step_text))
                    )

                    color = colors.text
                end

                draw:AddText(
                    { text_left, text_y },
                    imgui.GetColorU32(color),
                    fit_text(text, max_x - 8 - text_left)
                )
            else
                draw:AddText(
                    { text_left, text_y },
                    imgui.GetColorU32(colors.note),
                    fit_text(
                        tx('Note') .. ': ' .. row.note,
                        max_x - 8 - text_left
                    )
                )

                -- The whole note, when the line is too short for it.
                if hovered and imgui.SetTooltip then
                    imgui.SetTooltip(row.note)
                end
            end
        end
    end

    if remove then
        if imgui.SmallButton(tx('Remove') .. '##fav_remove_' .. id) then
            if controller.RemoveFavorite then
                controller.RemoveFavorite(row.kind, row.id, row.name)
                active_rows_time = -1000
            end
        end

        if imgui.IsItemHovered() and imgui.SetTooltip then
            imgui.SetTooltip(tx('Remove from favorites'))
        end
    end

    return clicked
end

local function draw_active_window()
    if not controller
        or not controller.GetActiveOpen then

        return
    end

    if not controller.GetActiveOpen() then
        active_was_open = false

        return
    end

    if not can_draw_ui()
        or not controller.GetActiveNow
        or not controller.GetFavoriteRows
        or not controller.GetJournalWindowState then

        return
    end

    local journal = controller.GetJournalWindowState()

    -- The window goes away with the Journal.
    if not journal
        or not journal.visible then

        controller.SetActiveOpen(false)
        active_was_open = false

        return
    end

    if not active_was_open then
        active_was_open = true
        active_restore = true
        active_rows_time = -1000
        active_notice = nil
    end

    if active_restore then
        active_restore = false

        imgui.SetNextWindowSize({ scaled(500), scaled(640) })

        imgui.SetNextWindowPos({
            (journal.x or 0) + 100,
            (journal.y or 0) + 100,
        })
    end

    -- The rows are rebuilt about once a second, and at once after a change.
    local now = os.clock()

    if now - active_rows_time > 1.0 then
        active_rows_time = now
        active_rows = controller.GetActiveNow() or {}
        favorite_rows = controller.GetFavoriteRows() or {}
    end

    push_theme()

    local font_pushed = journal_font ~= nil

    if font_pushed then
        imgui.PushFont(journal_font, journal_font_size)
    end

    local open = { true }

    scalex.before('active')

    if imgui.Begin(
        tx('Active Now') .. '###JournalActive',
        open,
        ImGuiWindowFlags_NoSavedSettings
            + ImGuiWindowFlags_NoCollapse
    ) then
        scalex.after('active')

        local draw = imgui.GetWindowDrawList()
        local x, y = imgui.GetWindowPos()
        local width, height = imgui.GetWindowSize()

        draw_window_panel(draw, x, y, width, height, true)

        local tab = controller.GetActiveTab()

        local active_text =
            tx('Active') .. ' (' .. #active_rows .. ')'

        local favorites_text =
            tx('Favorites') .. ' (' .. #favorite_rows .. ')'

        if toolbar_mode_button(
            active_text .. '##ActiveTab',
            tab == 'active',
            (imgui.CalcTextSize(active_text)) + 36
        ) then
            controller.SetActiveOpen(true, 'active')
        end

        imgui.SameLine(0, 4)

        if toolbar_mode_button(
            favorites_text .. '##FavoritesTab',
            tab == 'favorites',
            (imgui.CalcTextSize(favorites_text)) + 36
        ) then
            controller.SetActiveOpen(true, 'favorites')
        end

        -- A jump that did not arrive says so for a few seconds.
        if active_notice ~= nil then
            if now - active_notice.time < 4 then
                imgui.TextColored(colors.text_dim, active_notice.text)
            else
                active_notice = nil
            end
        end

        imgui.Spacing()

        imgui.PushStyleColor(ImGuiCol_ChildBg, transparent)

        if imgui.BeginChild('##JournalActiveList', { -1, -1 }, child_border) then
            local list_draw = imgui.GetWindowDrawList()
            local list_x, list_y = imgui.GetWindowPos()
            local list_w, list_h = imgui.GetWindowSize()

            draw_panel(list_draw, list_x, list_y, list_w, list_h, true)

            local rows = tab == 'favorites' and favorite_rows or active_rows

            if #rows == 0 then
                richtext.draw_wrapped(
                    tab == 'favorites'
                        and tx('No favorites yet. Use the star on a quest or mission.')
                        or tx('Nothing active right now.'),
                    { color = colors.text_dim, size = step_font_size }
                )
            end

            local last_kind = nil

            for index, row in ipairs(rows) do
                if tab == 'active' and row.kind ~= last_kind then
                    last_kind = row.kind

                    imgui.TextColored(
                        colors.text_dim,
                        row.kind == 'mission'
                            and tx('Missions')
                            or tx('Quests')
                    )
                end

                local row_id =
                    row.kind .. '_' .. tostring(row.area or '')
                    .. '_' .. tostring(row.id) .. '_' .. index

                if draw_active_row(row, row_id, tab == 'favorites') then
                    open_active_row(row)
                end

                imgui.Spacing()
            end
        end

        imgui.EndChild()

        imgui.PopStyleColor()
    end

    imgui.End()

    if not open[1] then
        controller.SetActiveOpen(false)
    end

    if font_pushed then
        imgui.PopFont()
    end

    pop_theme()
end

-- Compass window ------------------------------------------------------------
-- A small window with an arrow that points at the NPC of the current step of
-- the target. It is drawn whenever it is open, with the Journal or without
-- it, like the Tracker. The locals live in a block: the file has few left.

local draw_compass_window

do
    local placed = false
    -- Resizing of the window. refit counts the frames in which the window
    -- is asked to fit its content (a height of 0); after that its size
    -- belongs to the player. clipped_signature remembers for which content
    -- a refit was already asked because the content did not fit.
    local refit, last_w, clipped_signature = 0, nil, nil
    local compass_scale, last_scale = 1.0, nil

    -- A size in pixels, scaled with the text size of the Journal and with
    -- the text size of the compass.
    local function cscaled(value)
        return scaled(value * compass_scale)
    end
    local size_placed = false

    -- The search box and what it found, the last message and the names of
    -- the zones (looked up once).
    local search_buffer = { '' }
    local search_text = ''
    local search_results = {}
    local search_notice = nil
    local zone_names = {}

    local function zone_label(id)
        if zone_names[id] == nil then
            local name = controller.GetCompassZoneName
                and controller.GetCompassZoneName(id)

            if name == nil then
                return '#' .. tostring(id)
            end

            zone_names[id] = name
        end

        return zone_names[id]
    end

    -- A small, dim "x" at the right end of the row that was just drawn: an
    -- invisible button with two lines drawn over it, lighter when the mouse
    -- is on it. Returns true when it was pressed.
    local function draw_cross(id, window_width)
        local cross = cscaled(14)

        imgui.SameLine(window_width - cscaled(12) - cross)

        local pressed = imgui.InvisibleButton(id, { cross, cross })

        local min_x, min_y = imgui.GetItemRectMin()
        local max_x, max_y = imgui.GetItemRectMax()
        local cx = (min_x + max_x) * 0.5
        local cy = (min_y + max_y) * 0.5
        local arm = cross * 0.22
        local color = imgui.GetColorU32(
            imgui.IsItemHovered()
                and colors.cross_hover
                or colors.cross
        )
        local list = imgui.GetWindowDrawList()

        list:AddLine(
            { cx - arm, cy - arm },
            { cx + arm, cy + arm },
            color,
            1.2
        )
        list:AddLine(
            { cx - arm, cy + arm },
            { cx + arm, cy - arm },
            color,
            1.2
        )

        if imgui.IsItemHovered() and imgui.SetTooltip then
            imgui.SetTooltip(tx('Remove'))
        end

        return pressed
    end

    local function distance_text(distance)
        if distance < 10 then
            return string.format(tx('%.1f meters'), distance)
        end

        return string.format(tx('%d meters'), math.floor(distance + 0.5))
    end

    -- Color and message by distance: 0-5 green, 6-20 yellow, 21-35
    -- orange. Farther than that, no message.
    local proximity_colors = {
        { 0.40, 0.90, 0.40, 1.00 },
        { 1.00, 0.90, 0.30, 1.00 },
        { 1.00, 0.60, 0.20, 1.00 },
    }

    local function proximity(distance)
        local shown = math.floor(distance + 0.5)

        if shown <= 5 then
            return proximity_colors[1], tx("It's right here!")
        elseif shown <= 20 then
            return proximity_colors[2], tx("You're very close..")
        elseif shown <= 35 then
            return proximity_colors[3], tx("You're getting closer..")
        end

        return nil, nil
    end

    -- A line of text with a soft black shadow, as in the Tracker: the
    -- line is reserved with invisible text and drawn twice.
    local function shadow_text(color, text)
        imgui.PushStyleColor(ImGuiCol_Text, transparent)

        local reserved = pcall(imgui.Text, text)

        imgui.PopStyleColor()

        local drawn = reserved and pcall(function()
            local draw = imgui.GetWindowDrawList()
            local x, y = imgui.GetItemRectMin()

            draw:AddText({ x + 1, y + 1 }, 0xCC000000, text)
            draw:AddText({ x, y }, imgui.GetColorU32(color), text)
        end)

        if not reserved then
            imgui.TextColored(color, text)
        elseif not drawn then
            imgui.TextColored(color, text)
        end
    end

    local function compass_text(state)
        if state.status == 'none' then
            if controller.GetCompassSearchVisible
                and not controller.GetCompassSearchVisible() then

                return tx('Choose a quest or mission and press "Point compass here".')
            end

            return tx('Search an NPC below, or choose a quest or mission and press "Point compass here".')
        end

        if state.status == 'nostep' then
            return tx('No step to follow.')
        end

        if state.status == 'nonpc' then
            return tx('This step does not name an NPC.')
        end

        if state.status == 'unavailable' then
            return tx('Compass unavailable')
        end

        return nil
    end

    draw_compass_window = function()
        if not controller
            or not controller.GetCompassOpen
            or not controller.GetCompassState then

            return
        end

        if not controller.GetCompassOpen() then
            placed = false
            size_placed = false
            refit = 0
            last_w = nil
            last_scale = nil
            clipped_signature = nil

            return
        end

        if not can_draw_ui() then
            return
        end

        compass_scale = controller.GetCompassTextScale
            and controller.GetCompassTextScale() or 1.0

        -- A new text size: fit the window to the content again.
        if last_scale == nil then
            last_scale = compass_scale
        elseif compass_scale ~= last_scale then
            last_scale = compass_scale
            refit = 3
            last_w = nil
        end

        local now = os.clock()
        local state = controller.GetCompassState(now)

        -- The window can be resized. Without a saved size it fits its
        -- content (a height of 0) for a few frames and keeps that size. A
        -- saved size is applied once. After that the size is the player's:
        -- it is saved when it changes, and the content scrolls if it does
        -- not fit. No mouse state is needed to tell who changed the size.
        local saved_w, saved_h

        if controller.GetCompassSize then
            saved_w, saved_h = controller.GetCompassSize()
        end

        if saved_w == nil and refit == 0 and controller.SetCompassSize then
            -- First time, or the size was reset.
            refit = 3
            last_w = nil
        end

        if refit > 0 then
            imgui.SetNextWindowSize({ last_w or cscaled(260), 0 })
        elseif not size_placed and saved_w ~= nil then
            imgui.SetNextWindowSize({ saved_w, saved_h })
        end

        size_placed = true

        if imgui.SetNextWindowSizeConstraints then
            imgui.SetNextWindowSizeConstraints(
                { cscaled(190), cscaled(80) },
                { cscaled(1000), cscaled(1000) }
            )
        end

        if not placed then
            placed = true

            local saved_x, saved_y = controller.GetCompassPosition()

            imgui.SetNextWindowPos({
                saved_x or cscaled(80),
                saved_y or cscaled(220),
            })
        end

        push_theme(false, controller.GetCompassOpacity
            and controller.GetCompassOpacity() or nil)

        -- The resize grip of the corner is invisible until the mouse is
        -- over it.
        imgui.PushStyleColor(ImGuiCol_ResizeGrip, transparent)
        imgui.PushStyleColor(
            ImGuiCol_ResizeGripHovered,
            { 0.80, 0.84, 0.95, 0.55 }
        )
        imgui.PushStyleColor(
            ImGuiCol_ResizeGripActive,
            { 0.80, 0.84, 0.95, 0.85 }
        )

        local font_pushed = journal_font ~= nil

        if font_pushed then
            imgui.PushFont(journal_font, journal_font_size * compass_scale)
        end

        -- No title bar and no close button: the window is moved by
        -- dragging it anywhere, and shown or hidden with the button of the
        -- Journal or /journal compass.
        if imgui.Begin(
            tx('Compass') .. '###JournalCompass',
            { true },
            ImGuiWindowFlags_NoSavedSettings
                + ImGuiWindowFlags_NoCollapse
                + ImGuiWindowFlags_NoTitleBar
        ) then
            local draw = imgui.GetWindowDrawList()
            local x, y = imgui.GetWindowPos()
            local window_width, window_height = imgui.GetWindowSize()

            -- Fully transparent: no background and no frame lines either.
            if (controller.GetCompassOpacity
                and controller.GetCompassOpacity() or 1) > 0 then

                draw_window_panel(
                    draw,
                    x,
                    y,
                    window_width,
                    window_height,
                    true
                )
            end

            local available = window_width - cscaled(24)
            local message = compass_text(state)

            local npc_rows = controller.GetCompassNpcRows
                and controller.GetCompassNpcRows(now) or {}
            local pin_rows = controller.GetCompassPinRows
                and controller.GetCompassPinRows(now) or {}

            if state.target ~= nil then
                shadow_text(
                    colors.text,
                    fit_text(state.target.name, available - cscaled(24))
                )

                -- The "x" stops pointing the compass at it.
                if draw_cross('##CompassTargetRemove', window_width)
                    and controller.RemoveCompassTarget then

                    controller.RemoveCompassTarget()
                end
            end

            if state.status == 'none' then
                -- No quest or mission: the hint only while there is nothing
                -- else in the window.
                if #npc_rows == 0 and #pin_rows == 0 then
                    richtext.draw_wrapped(
                        message,
                        { color = colors.text_dim, size = step_font_size * compass_scale, shadow = true }
                    )
                end
            elseif message ~= nil then
                imgui.Spacing()

                richtext.draw_wrapped(
                    message,
                    { color = colors.text_dim, size = step_font_size * compass_scale, shadow = true }
                )
            else
                if state.npc ~= nil then
                    shadow_text(
                        richtext.COLORS.npc,
                        fit_text(state.npc, available)
                    )
                end

                -- The arrow area, only when the compass gives an angle.
                local area = state.angle ~= nil and cscaled(86) or 0
                local start_x, start_y = imgui.GetCursorScreenPos()
                local center_x = x + window_width * 0.5
                local center_y = start_y + area * 0.5

                if state.status == 'found' and state.angle ~= nil then
                    local color = state.arrived
                        and colors.completed
                        or colors.active_status
                    local size = area * 0.40

                    if state.arrived then
                        -- A slow pulse when you are there.
                        size = size * (1 + 0.10 * math.sin(now * 6))
                    end

                    icons.draw_arrow(
                        draw,
                        center_x,
                        center_y,
                        size,
                        state.angle or 0,
                        imgui.GetColorU32(color)
                    )
                end

                if area > 0 and imgui.Dummy then
                    imgui.Dummy({ 1, area })
                else
                    imgui.Spacing()
                end

                if state.status == 'found' or state.status == 'known' then
                    -- The distance always shows; one decimal when it is
                    -- short, to see it drop as you walk.
                    local near_color, near_message = proximity(state.distance)

                    shadow_text(
                        near_color or colors.text,
                        distance_text(state.distance)
                    )

                    if near_message then
                        shadow_text(near_color, near_message)
                    end

                    -- The fixed position is from the game data, not live.
                    if state.status == 'known' then
                        shadow_text(
                            colors.text_dim,
                            tx('From the game data')
                        )
                    end
                elseif state.status == 'otherzone' then
                    local zone_names = {}

                    for _, id in ipairs(state.zones or {}) do
                        if #zone_names < 2 then
                            zone_names[#zone_names + 1] =
                                (controller.GetCompassZoneName
                                    and controller.GetCompassZoneName(id))
                                or ('#' .. tostring(id))
                        end
                    end

                    shadow_text(colors.text_dim, tx('In another zone:'))

                    shadow_text(
                        colors.text,
                        fit_text(table.concat(zone_names, ', '), available)
                    )

                    -- The next zone on foot (data/zone_links.lua).
                    if state.next_zone ~= nil then
                        shadow_text(
                            colors.text_dim,
                            fit_text(
                                tx('Next:') .. ' ' .. zone_label(state.next_zone),
                                available
                            )
                        )
                    end
                else
                    shadow_text(colors.text_dim, tx('Not in range'))
                end

                if state.grid ~= nil then
                    shadow_text(
                        colors.text_dim,
                        tx('Map square') .. ' ' .. state.grid
                    )
                end
            end

            -- The items pinned in the Tracker: the NPC of the current step
            -- of each, with a small "x" that takes it off the compass only.
            local hide_key = nil

            if #pin_rows > 0 then
                if state.status ~= 'none' then
                    imgui.Separator()
                end

                for index, row in ipairs(pin_rows) do
                    shadow_text(
                        richtext.COLORS.npc,
                        fit_text(row.npc, available - cscaled(24))
                    )

                    if draw_cross('##CompassPinRemove' .. index, window_width) then
                        hide_key = row.key
                    end

                    local line
                    local color = colors.text
                    local row_color, row_message

                    if row.status == 'found' or row.status == 'known' then
                        line = distance_text(row.distance)

                        if row.zone ~= nil then
                            line = line .. '  ' .. zone_label(row.zone)
                        end

                        row_color, row_message = proximity(row.distance)
                        color = row_color or color
                    elseif row.status == 'otherzone' then
                        local names = {}

                        for _, id in ipairs(row.zones or {}) do
                            if #names < 2 then
                                names[#names + 1] = zone_label(id)
                            end
                        end

                        line = tx('In another zone:') .. ' '
                            .. table.concat(names, ', ')
                        color = colors.text_dim

                        if row.next_zone ~= nil then
                            row_color = colors.text_dim
                            row_message = tx('Next:') .. ' '
                                .. zone_label(row.next_zone)
                        end
                    elseif row.status == 'far' then
                        line = tx('Not in range')
                        color = colors.text_dim
                    else
                        line = tx('Compass unavailable')
                        color = colors.text_dim
                    end

                    shadow_text(color, fit_text(line, available))

                    if row_message then
                        shadow_text(row_color, fit_text(row_message, available))
                    end

                    -- Which quest or mission it is for.
                    shadow_text(colors.text_dim, fit_text(row.title, available))
                end
            end

            if hide_key ~= nil and controller.HideCompassPin then
                controller.HideCompassPin(hide_key)
            end

            -- The NPCs chosen with the search.
            local remove_index = nil

            if #npc_rows > 0 then
                if state.status ~= 'none' or #pin_rows > 0 then
                    imgui.Separator()
                end

                -- From the closest to the farthest; the ones without a
                -- distance (another zone, not in range) go last. The index
                -- of the row in the list is kept for the "x".
                local order = {}

                for position = 1, #npc_rows do
                    order[position] = position
                end

                table.sort(order, function(a, b)
                    local da = tonumber(npc_rows[a].distance) or math.huge
                    local db = tonumber(npc_rows[b].distance) or math.huge

                    if da ~= db then
                        return da < db
                    end

                    return a < b
                end)

                for position, index in ipairs(order) do
                    local row = npc_rows[index]

                    -- A line between the NPCs.
                    if position > 1 then
                        imgui.Separator()
                    end

                    -- The Fame Checkers have their own icon before the name.
                    local name_icon = 0

                    if controller.IsFameChecker
                        and controller.IsFameChecker(row.name) then

                        name_icon = fame_ui.inline_icon()
                    elseif controller.GetMissionGiverIcon then
                        -- A Gate Guard: the mission available or not.
                        local giver_icon = controller.GetMissionGiverIcon(row.name)

                        if giver_icon ~= nil then
                            name_icon = fame_ui.inline_icon(giver_icon)
                        end
                    end

                    shadow_text(
                        richtext.COLORS.npc,
                        fit_text(row.name, available - cscaled(24) - name_icon)
                    )

                    -- A small, dim "x": an invisible button with two lines
                    -- drawn over it, lighter when the mouse is on it.
                    local cross = cscaled(14)

                    imgui.SameLine(window_width - cscaled(12) - cross)

                    if imgui.InvisibleButton(
                        '##CompassNpcRemove' .. index,
                        { cross, cross }
                    ) then
                        remove_index = index
                    end

                    do
                        local min_x, min_y = imgui.GetItemRectMin()
                        local max_x, max_y = imgui.GetItemRectMax()
                        local cx = (min_x + max_x) * 0.5
                        local cy = (min_y + max_y) * 0.5
                        local arm = cross * 0.22
                        local color = imgui.GetColorU32(
                            imgui.IsItemHovered()
                                and colors.cross_hover
                                or colors.cross
                        )
                        local list = imgui.GetWindowDrawList()

                        list:AddLine(
                            { cx - arm, cy - arm },
                            { cx + arm, cy + arm },
                            color,
                            1.2
                        )
                        list:AddLine(
                            { cx - arm, cy + arm },
                            { cx + arm, cy - arm },
                            color,
                            1.2
                        )
                    end

                    if imgui.IsItemHovered() and imgui.SetTooltip then
                        imgui.SetTooltip(tx('Remove'))
                    end

                    -- The quests of an NPC added by the proximity alert: a
                    -- click opens the quest in the Journal.
                    local previous = nil

                    for number, quest in ipairs(row.quests or {}) do
                        -- A thin line between one quest and the next, in the
                        -- gap under the previous one.
                        if previous ~= nil then
                            pcall(function()
                                imgui.GetWindowDrawList():AddLine(
                                    { previous.min_x - 3, previous.max_y + 3 },
                                    { previous.min_x + available, previous.max_y + 3 },
                                    imgui.GetColorU32({ 0.60, 0.60, 0.60, 0.30 }),
                                    1
                                )
                            end)
                        end

                        if number > 3 then
                            shadow_text(
                                colors.text_dim,
                                string.format(
                                    tx('+%d more'), #row.quests - 3
                                )
                            )

                            break
                        end

                        -- The small icon of the quest before its name: the
                        -- same ones as over the NPC in the game world.
                        local icon_kind = quest.repeatable and 'repeatable'
                            or (quest.active and 'progress' or 'available')
                        local icon = controller.worldmark
                            and controller.worldmark.GetIcon
                            and controller.worldmark.GetIcon(icon_kind)
                        local icon_left = nil
                        local icon_width = 0

                        if icon ~= nil and imgui.Dummy and imgui.SameLine then
                            local icon_height = imgui.GetTextLineHeight()

                            icon_width = icon_height * icon.width / icon.height

                            if pcall(imgui.Dummy, { icon_width, icon_height }) then
                                pcall(function()
                                    local min_x, min_y = imgui.GetItemRectMin()
                                    local max_x, max_y = imgui.GetItemRectMax()

                                    icon_left = min_x

                                    imgui.GetWindowDrawList():AddImage(
                                        icon.id,
                                        { min_x, min_y },
                                        { max_x, max_y },
                                        { 0, 0 },
                                        { 1, 1 },
                                        imgui.GetColorU32({ 1, 1, 1, 1 })
                                    )
                                end)

                                imgui.SameLine(0, 4)
                                icon_width = icon_width + 4
                            else
                                icon_width = 0
                            end
                        end

                        shadow_text(
                            quest.active and { 0.55, 0.95, 0.55, 1.00 } or colors.text,
                            fit_text(quest.name, available - icon_width)
                        )

                        pcall(function()
                            local min_x = imgui.GetItemRectMin()
                            local _, max_y = imgui.GetItemRectMax()

                            previous = {
                                min_x = math.min(min_x, icon_left or min_x),
                                max_y = max_y,
                            }
                        end)

                        -- A shaded box and a line under the text, brighter
                        -- with the mouse over it, so it looks clickable.
                        pcall(function()
                            local min_x, min_y = imgui.GetItemRectMin()
                            local max_x, max_y = imgui.GetItemRectMax()
                            local over = imgui.IsItemHovered()
                            local list = imgui.GetWindowDrawList()

                            -- The box also covers the icon.
                            min_x = math.min(min_x, icon_left or min_x)

                            list:AddRectFilled(
                                { min_x - 3, min_y },
                                { max_x + 3, max_y + 1 },
                                imgui.GetColorU32(quest.active and {
                                    0.35, 0.85, 0.40, over and 0.38 or 0.18,
                                } or {
                                    0.45, 0.65, 1.00, over and 0.38 or 0.18,
                                }),
                                3
                            )
                            list:AddLine(
                                { min_x - 3, max_y + 1 },
                                { max_x + 3, max_y + 1 },
                                imgui.GetColorU32(quest.active and {
                                    0.55, 0.95, 0.55, over and 1.00 or 0.60,
                                } or {
                                    0.60, 0.78, 1.00, over and 1.00 or 0.60,
                                }),
                                1
                            )
                        end)

                        if imgui.IsItemHovered() then
                            if imgui.SetTooltip then
                                imgui.SetTooltip(tx('Opens the quest sheet'))
                            end

                            if imgui.IsItemClicked() then
                                if controller.OpenQuestSheet then
                                    controller.OpenQuestSheet(quest.id)
                                elseif controller.OpenQuestFromCompass then
                                    controller.OpenQuestFromCompass(quest.id)
                                end
                            end
                        end
                    end

                    local line
                    local color = colors.text
                    local row_color, row_message

                    if row.status == 'found' or row.status == 'known' then
                        -- Only the meters, in the color of the distance.
                        line = distance_text(row.distance)
                        row_color = proximity(row.distance)
                        color = row_color or color
                        row_color = nil
                    elseif row.status == 'otherzone' then
                        line = tx('In another zone:') .. ' '
                            .. zone_label(row.zone)
                        color = colors.text_dim

                        if row.next_zone ~= nil then
                            row_color = colors.text_dim
                            row_message = tx('Next:') .. ' '
                                .. zone_label(row.next_zone)
                        end
                    elseif row.status == 'far' then
                        line = tx('Not in range') .. '  '
                            .. zone_label(row.zone)
                        color = colors.text_dim
                    else
                        line = tx('Compass unavailable')
                        color = colors.text_dim
                    end

                    shadow_text(color, fit_text(line, available))

                    if row_message then
                        shadow_text(row_color, row_message)
                    end
                end
            end

            if remove_index ~= nil then
                controller.RemoveCompassNpc(remove_index)
            end

            -- The search box.
            if controller.SearchCompassNpcs
                and controller.AddCompassNpc
                and imgui.InputText ~= nil
                and (
                    controller.GetCompassSearchVisible == nil
                    or controller.GetCompassSearchVisible()
                ) then

                imgui.Separator()
                imgui.PushItemWidth(available)

                local typed = imgui.InputText(
                    '##CompassSearch',
                    search_buffer,
                    41
                )

                imgui.PopItemWidth()

                local active = imgui.IsItemActive()

                if active then
                    note_input_active = true
                end

                -- Hint inside the empty box.
                if search_buffer[1] == '' and not active then
                    local box_x, box_y = imgui.GetItemRectMin()
                    local _, box_bottom = imgui.GetItemRectMax()

                    imgui.GetWindowDrawList():AddText(
                        {
                            box_x + 8,
                            box_y
                                + (
                                    (box_bottom - box_y)
                                    - imgui.GetTextLineHeight()
                                ) * 0.5,
                        },
                        imgui.GetColorU32(colors.text_dim),
                        tx('Search an NPC')
                    )
                end

                if typed or search_text ~= search_buffer[1] then
                    search_text = search_buffer[1]
                    search_results = controller.SearchCompassNpcs(search_text)
                end

                for index, item in ipairs(search_results) do
                    if imgui.Selectable(
                        fit_text(
                            item.name .. ' - ' .. zone_label(item.zone),
                            available
                        ) .. '##CompassResult' .. index
                    ) then
                        local added, problem =
                            controller.AddCompassNpc(item.name, item.zone)

                        if problem == 'full' then
                            search_notice = {
                                time = now,
                                text = string.format(
                                    tx('The NPC list is full (%d). Remove one first.'),
                                    controller.compass
                                        and controller.compass.NPC_MAX or 5
                                ),
                            }
                        end

                        search_buffer[1] = ''
                        search_text = ''
                        search_results = {}

                        break
                    end
                end

                if #search_text >= 2 and #search_results == 0 then
                    shadow_text(colors.text_dim, tx('No NPC matches.'))
                end

                if search_notice ~= nil then
                    if now - search_notice.time < 4 then
                        shadow_text(colors.text_dim, search_notice.text)
                    else
                        search_notice = nil
                    end
                end
            end

            -- Remember the size: the fit of the first frames, then whatever
            -- the player drags it to.
            if refit > 0 then
                refit = refit - 1
                last_w = window_width

                if refit == 0 and controller.SetCompassSize then
                    controller.SetCompassSize(window_width, window_height)
                end
            else
                if controller.SetCompassSize
                    and (
                        saved_w == nil
                        or math.abs(window_width - saved_w) > 2
                        or math.abs(window_height - saved_h) > 2
                    ) then

                    controller.SetCompassSize(window_width, window_height)
                end

                -- New content that does not fit (an NPC was added): fit
                -- again, once for each content.
                local signature = state.status .. #npc_rows .. '/' .. #pin_rows

                for _, row in ipairs(npc_rows) do
                    signature = signature .. row.status .. #(row.quests or {})
                end

                for _, row in ipairs(pin_rows) do
                    signature = signature .. row.status
                end

                if imgui.GetScrollMaxY
                    and imgui.GetScrollMaxY() > 1
                    and signature ~= clipped_signature then

                    clipped_signature = signature
                    refit = 3
                    last_w = window_width
                end
            end

            -- Remember where the player put the window.
            if controller.SetCompassPosition then
                controller.SetCompassPosition(x, y)
            end
        end

        imgui.End()

        if font_pushed then
            imgui.PopFont()
        end

        imgui.PopStyleColor(3)

        pop_theme()
    end
end

-- Settings window ---------------------------------------------------------

local settings_was_open = false
local settings_restore = false

local function settings_percent(value)
    return string.format('%d%%', math.floor((value or 0) * 100 + 0.5))
end

local function draw_settings_header(label)
    imgui.Spacing()
    imgui.TextColored(colors.gold, label)
    imgui.Separator()
end

-- Label on the left and [-] value [+] on the right. Clicking the value goes
-- back to the default.
local function draw_settings_stepper(id, label, value_text, on_step, on_reset)
    if imgui.AlignTextToFramePadding then
        imgui.AlignTextToFramePadding()
    end

    imgui.TextColored(colors.text, label)

    imgui.SameLine()

    local small = SETTINGS_BUTTON_HEIGHT

    -- The value button is as wide as its text needs (the padding of the
    -- style is 8 on each side), so "100%" is never cut.
    local middle = math.max(
        scaled(84),
        math.ceil((imgui.CalcTextSize(value_text)) + 24)
    )
    local gap = 6
    local total = small * 2 + middle + gap * 2

    imgui.SetCursorPosX(imgui.GetWindowWidth() - total - 18)

    if imgui.Button('-##' .. id .. '_minus', { small, small }) then
        on_step(-1)
    end

    imgui.SameLine(0, gap)

    if imgui.Button(
        value_text .. '##' .. id .. '_value',
        { middle, small }
    ) then
        on_reset()
    end

    imgui.SameLine(0, gap)

    if imgui.Button('+##' .. id .. '_plus', { small, small }) then
        on_step(1)
    end
end

local function draw_settings_checkbox(id, label, value, on_change)
    local box = { value == true }

    if imgui.Checkbox(label .. '##' .. id, box) then
        on_change(box[1])
    end
end

-- A button that looks pressed while it is the current choice.
local function draw_settings_choice(label, active, width)
    if active then
        imgui.PushStyleColor(ImGuiCol_Button, colors.button_active)
    end

    -- The button is never narrower than its text (without the ##id).
    local shown = tostring(label):match('^(.-)##') or tostring(label)

    width = math.max(width, math.ceil((imgui.CalcTextSize(shown)) + 24))

    local clicked =
        imgui.Button(
            label,
            { width, SETTINGS_BUTTON_HEIGHT }
        )

    if active then
        imgui.PopStyleColor()
    end

    return clicked
end

-- The look of one kind of alert: background, text size and color. group is
-- 'new' (new quests and missions) or 'done' (completed ones).
local function draw_alert_style_group(group, header)
    if not (controller.GetAlertStyle
        and controller.AdjustAlertOpacity
        and controller.AdjustAlertSize
        and controller.SetAlertColor
        and controller.GetAlertPalette) then

        return
    end

    local style = controller.GetAlertStyle(group)
    local palette = controller.GetAlertPalette()

    imgui.Spacing()
    imgui.TextColored(colors.text_dim, header)

    draw_settings_stepper(
        'alert_' .. group .. '_bg',
        tx('Alert background'),
        settings_percent(style.opacity),
        function(direction)
            controller.AdjustAlertOpacity(group, direction)
        end,
        function()
            controller.SetAlertOpacity(group, 0.70)
        end
    )

    draw_settings_stepper(
        'alert_' .. group .. '_size',
        tx('Alert text size'),
        settings_percent(style.size),
        function(direction)
            controller.AdjustAlertSize(group, direction)
        end,
        function()
            controller.SetAlertSize(group, 1.0)
        end
    )

    imgui.TextColored(colors.text, tx('Alert color'))

    if draw_settings_choice(
        tx('Default') .. '##alert_' .. group .. '_color0',
        style.color == 0,
        scaled(84)
    ) then
        controller.SetAlertColor(group, 0)
    end

    local box = scaled(32)

    for index, color in ipairs(palette) do
        imgui.SameLine(0, 6)

        imgui.PushStyleColor(ImGuiCol_Button, color)
        imgui.PushStyleColor(ImGuiCol_ButtonHovered, lighten(color, 0.10))
        imgui.PushStyleColor(ImGuiCol_ButtonActive, lighten(color, 0.20))

        local clicked =
            imgui.Button(
                '##alert_' .. group .. '_color' .. index,
                { box, box }
            )

        imgui.PopStyleColor(3)

        -- The chosen color gets a white frame.
        if style.color == index then
            local min_x, min_y = imgui.GetItemRectMin()
            local max_x, max_y = imgui.GetItemRectMax()
            local draw = imgui.GetWindowDrawList()
            local white = imgui.GetColorU32({ 1, 1, 1, 1 })

            draw:AddLine({ min_x, min_y }, { max_x, min_y }, white, 2.0)
            draw:AddLine({ max_x, min_y }, { max_x, max_y }, white, 2.0)
            draw:AddLine({ max_x, max_y }, { min_x, max_y }, white, 2.0)
            draw:AddLine({ min_x, max_y }, { min_x, min_y }, white, 2.0)
        end

        if clicked then
            controller.SetAlertColor(group, index)
        end
    end
end

-- The buttons that show an alert on the screen, to see how it looks while
-- the settings are changed. Pressing the one that is showing hides it.
local function draw_alert_tests(width)
    if not (controller.StartAlertTest
        and controller.StopAlertTest
        and controller.GetAlertTest) then

        return
    end

    local test = controller.GetAlertTest()
    local half = math.floor((width - 24 - 8) / 2)

    local function test_button(label, kind, done, id)
        local special = kind == 'near' or kind == 'progress'
        local active =
            test ~= nil
            and test.done == done
            and (test.near == true) == special
            and (not special or (test.progress == true) == (kind == 'progress'))
            and (special or test.kind == kind)

        if draw_settings_choice(
            tx(label) .. '##alert_test_' .. id,
            active,
            half
        ) then
            if active then
                controller.StopAlertTest()
            else
                controller.StartAlertTest(kind, done)
            end
        end
    end

    imgui.Spacing()
    imgui.TextColored(colors.text_dim, tx('Test the alerts'))

    test_button('Test: New Quest', 'quest', false, 'quest')
    imgui.SameLine(0, 8)
    test_button('Test: New Mission', 'mission', false, 'mission')

    test_button('Test: Quest Completed', 'quest', true, 'quest_done')
    imgui.SameLine(0, 8)
    test_button('Test: Mission Completed', 'mission', true, 'mission_done')

    test_button('Test: Quest Nearby', 'near', false, 'near')
    test_button('Test: Quest In Progress', 'progress', false, 'progress')

    imgui.TextColored(
        colors.text_dim,
        tx('The test stays on the screen until you press it again or close the settings.')
    )
end

local function draw_settings_window()
    local wanted =
        controller
        and controller.GetSettingsOpen
        and controller.GetSettingsOpen()

    if not wanted or not can_draw_ui() then
        settings_was_open = false

        return
    end

    if not settings_was_open then
        settings_was_open = true
        settings_restore = true
    end

    if settings_restore then
        settings_restore = false

        local journal =
            controller.GetJournalWindowState
            and controller.GetJournalWindowState()

        local saved_w, saved_h

        if controller.GetSettingsSize then
            saved_w, saved_h = controller.GetSettingsSize()
        end

        imgui.SetNextWindowSize({
            saved_w or scaled(480),
            saved_h or scaled(640),
        })

        imgui.SetNextWindowPos({
            ((journal and journal.visible and journal.x) or 40) + 100,
            ((journal and journal.visible and journal.y) or 40) + 100,
        })
    end

    -- Always fully opaque, so it stays readable while the opacity changes.
    push_theme(true)

    local font_pushed = journal_font ~= nil

    if font_pushed then
        imgui.PushFont(journal_font, journal_font_size)
    end

    local open = { true }

    scalex.before('settings')

    if imgui.Begin(
        tx('Settings') .. '###JournalSettings',
        open,
        ImGuiWindowFlags_NoSavedSettings
            + ImGuiWindowFlags_NoCollapse
    ) then
        scalex.after('settings')

        local draw = imgui.GetWindowDrawList()
        local x, y = imgui.GetWindowPos()
        local width, height = imgui.GetWindowSize()

        draw_window_panel(draw, x, y, width, height, true)

        -- Remember the size the player gives the window.
        if controller.SetSettingsSize and controller.GetSettingsSize then
            local kept_w, kept_h = controller.GetSettingsSize()

            kept_w = kept_w or scaled(480)
            kept_h = kept_h or scaled(640)

            if math.abs(width - kept_w) > 2
                or math.abs(height - kept_h) > 2 then

                controller.SetSettingsSize(width, height)
            end
        end

        -- Language
        if controller.GetLanguage and controller.SetLanguage then
            draw_settings_header(tx('Language'))

            local half = math.floor((width - 24 - 8) / 2)
            local es = controller.GetLanguage() == 'es'

            if draw_settings_choice('English##settings_en', not es, half)
                and es then

                controller.SetLanguage('en')
            end

            imgui.SameLine(0, 8)

            if draw_settings_choice(
                tx('Spanish') .. '##settings_es',
                es,
                half
            ) and not es then

                controller.SetLanguage('es')
            end
        end

        -- Journal
        draw_settings_header(tx('Journal'))

        if controller.GetTextScale then
            draw_settings_stepper(
                'journal_text_size',
                tx('Text size'),
                settings_percent(controller.GetTextScale()),
                function(direction)
                    controller.AdjustTextScale(direction)
                end,
                function()
                    controller.SetTextScale(1.0)
                end
            )
        end

        if controller.GetJournalOpacity then
            draw_settings_stepper(
                'journal_opacity',
                tx('Background opacity'),
                settings_percent(controller.GetJournalOpacity()),
                function(direction)
                    controller.AdjustJournalOpacity(direction)
                end,
                function()
                    controller.SetJournalOpacity(1.0)
                end
            )
        end

        local lists = {
            {
                'hide_missions',
                'Hide complete missions',
                controller.GetHideCompleteMissions,
                controller.SetHideCompleteMissions,
            },
            {
                'hide_quests',
                'Hide complete quests',
                controller.GetHideCompleteQuests,
                controller.SetHideCompleteQuests,
            },
            {
                'show_missions',
                'Show missions not started',
                controller.GetShowNotStartedMissions,
                controller.SetShowNotStartedMissions,
            },
            {
                'show_quests',
                'Show quests not started',
                controller.GetShowNotStartedQuests,
                controller.SetShowNotStartedQuests,
            },
        }

        for _, row in ipairs(lists) do
            if row[3] and row[4] then
                draw_settings_checkbox(
                    row[1],
                    tx(row[2]),
                    row[3](),
                    row[4]
                )
            end
        end

        if controller.GetJournalMiniButton
            and controller.SetJournalMiniButton then

            draw_settings_checkbox(
                'mini_button',
                tx('Show Journal button on close'),
                controller.GetJournalMiniButton(),
                controller.SetJournalMiniButton
            )
        end

        -- Tracker
        draw_settings_header(tx('Tracker'))

        local pin =
            controller.GetPinState and controller.GetPinState()

        if pin and controller.SetPinVisible then
            draw_settings_checkbox(
                'tracker_visible',
                tx('Show the Tracker'),
                pin.visible,
                controller.SetPinVisible
            )
        end

        if pin and controller.TogglePinMode then
            if imgui.Button(
                tx(
                    pin.mode == 'tabs'
                        and 'Mode: Tabs'
                        or 'Mode: Stacked'
                ) .. '##settings_mode',
                { width - 24, SETTINGS_BUTTON_HEIGHT }
            ) then
                controller.TogglePinMode()
            end
        end

        if controller.GetPinScale and controller.AdjustPinScale then
            draw_settings_stepper(
                'tracker_size',
                tx('Size'),
                string.format('%.1fx', controller.GetPinScale()),
                function(direction)
                    controller.AdjustPinScale(direction)
                end,
                function()
                    controller.SetPinScale(1.0)
                end
            )
        end

        if controller.GetPinOpacity then
            draw_settings_stepper(
                'tracker_opacity',
                tx('Opacity'),
                settings_percent(controller.GetPinOpacity()),
                function(direction)
                    controller.AdjustPinOpacity(direction)
                end,
                function()
                    controller.SetPinOpacity(1.0)
                end
            )
        end

        if controller.GetPinBackground then
            draw_settings_stepper(
                'tracker_background',
                tx('Background'),
                settings_percent(controller.GetPinBackground()),
                function(direction)
                    controller.AdjustPinBackground(direction)
                end,
                function()
                    controller.SetPinBackground(0.0)
                end
            )
        end

        if controller.GetPinShowNext and controller.SetPinShowNext then
            draw_settings_checkbox(
                'tracker_next',
                tx('Show next step'),
                controller.GetPinShowNext(),
                controller.SetPinShowNext
            )
        end

        if pin and controller.SetPinAutoZone then
            draw_settings_checkbox(
                'tracker_auto',
                tx('Auto step on zone change'),
                pin.auto_zone,
                controller.SetPinAutoZone
            )
        end

        if pin and controller.SetAutoPinQuests then
            draw_settings_checkbox(
                'tracker_auto_pin',
                tx('Pin active quests automatically'),
                pin.auto_pin,
                controller.SetAutoPinQuests
            )
        end

        -- Compass
        if controller.GetCompassOpacity and controller.AdjustCompassOpacity then
            draw_settings_header(tx('Compass'))

            if controller.GetCompassTextScale then
                draw_settings_stepper(
                    'compass_text_size',
                    tx('Text size'),
                    settings_percent(controller.GetCompassTextScale()),
                    function(direction)
                        controller.AdjustCompassTextScale(direction)
                    end,
                    function()
                        controller.SetCompassTextScale(1.0)
                    end
                )
            end

            draw_settings_stepper(
                'compass_opacity',
                tx('Background opacity'),
                settings_percent(controller.GetCompassOpacity()),
                function(direction)
                    controller.AdjustCompassOpacity(direction)
                end,
                function()
                    controller.SetCompassOpacity(1.0)
                end
            )

            if controller.GetCompassSearchVisible
                and controller.SetCompassSearchVisible then

                draw_settings_checkbox(
                    'compass_search',
                    tx('Show the NPC search'),
                    controller.GetCompassSearchVisible(),
                    controller.SetCompassSearchVisible
                )
            end

            -- The arrows over the NPCs in the game world (/journal mark)
            if controller.GetWorldMark and controller.SetWorldMark then
                draw_settings_checkbox(
                    'world_mark',
                    tx('Arrow over the compass NPC in the game'),
                    controller.GetWorldMark(),
                    controller.SetWorldMark
                )

                if controller.GetWorldMarkAll and controller.SetWorldMarkAll then
                    draw_settings_checkbox(
                        'world_mark_all',
                        tx('Arrows over all the NPCs of the compass'),
                        controller.GetWorldMarkAll(),
                        controller.SetWorldMarkAll
                    )
                end

                if controller.GetWorldMarkActive and controller.SetWorldMarkActive then
                    draw_settings_checkbox(
                        'world_mark_active',
                        tx('Green arrow over the NPC of each quest in progress'),
                        controller.GetWorldMarkActive(),
                        controller.SetWorldMarkActive
                    )
                end

                if controller.GetWorldMarkEdge and controller.SetWorldMarkEdge then
                    draw_settings_checkbox(
                        'world_mark_edge',
                        tx('Arrow at the edge of the screen for NPCs out of view'),
                        controller.GetWorldMarkEdge(),
                        controller.SetWorldMarkEdge
                    )
                end
            end
        end

        -- Alerts of new quests and missions
        if controller.GetAnnounceEnabled and controller.SetAnnounceEnabled then
            draw_settings_header(tx('Alerts'))

            draw_settings_checkbox(
                'alert_enabled',
                tx('New quest / mission alert'),
                controller.GetAnnounceEnabled(),
                controller.SetAnnounceEnabled
            )

            if controller.GetAnnounceSound and controller.SetAnnounceSound then
                draw_settings_checkbox(
                    'alert_sound',
                    tx('Alert sound'),
                    controller.GetAnnounceSound(),
                    controller.SetAnnounceSound
                )
            end

            if controller.GetAnnounceAsk and controller.SetAnnounceAsk then
                draw_settings_checkbox(
                    'alert_ask',
                    tx('Ask to pin in the Tracker'),
                    controller.GetAnnounceAsk(),
                    controller.SetAnnounceAsk
                )
            end

            draw_alert_style_group('new', tx('New quest / mission alerts'))
            draw_alert_style_group('done', tx('Completed alerts'))

            if controller.GetNearEnabled and controller.SetNearEnabled then
                imgui.Spacing()

                draw_settings_checkbox(
                    'alert_near',
                    tx('Alert when entering a zone: quests in progress there'),
                    controller.GetNearEnabled(),
                    controller.SetNearEnabled
                )

                draw_alert_style_group('near', tx('Quest nearby alerts'))

                if controller.GetProxEnabled and controller.SetProxEnabled then
                    draw_settings_checkbox(
                        'alert_prox',
                        tx('Alert when close to an NPC who starts a quest (30 y)'),
                        controller.GetProxEnabled(),
                        controller.SetProxEnabled
                    )

                    if controller.GetProxCompass and controller.SetProxCompass then
                        draw_settings_checkbox(
                            'alert_prox_compass',
                            tx('Add and remove those NPCs in the compass automatically'),
                            controller.GetProxCompass(),
                            controller.SetProxCompass
                        )
                    end
                end
            end

            draw_alert_tests(width)
        end

        -- Windows
        if controller.ResetWindowPositions then
            draw_settings_header(tx('Windows'))

            if imgui.Button(
                tx('Reset window positions') .. '##settings_reset',
                { width - 24, SETTINGS_BUTTON_HEIGHT }
            ) then
                controller.ResetWindowPositions()
            end
        end

        imgui.Spacing()

        imgui.TextColored(
            colors.text_dim,
            'Journal ' .. tostring(addon and addon.version or '')
        )
    end

    imgui.End()

    if not open[1] then
        controller.SetSettingsOpen(false)
    end

    if font_pushed then
        imgui.PopFont()
    end

    pop_theme()
end

-- Guide window ------------------------------------------------------------

local guide_was_open = false
local guide_restore = false
local guide_scroll_top = false

-- A text of the guide in the current language (it falls back to English).
local function guide_text(text)
    return tostring(i18n.step(text))
end

-- Splits a title into lines that fit in max_width (word by word).
local function wrap_guide_title(text, max_width)
    local lines = {}
    local line = ''

    for word in tostring(text):gmatch('%S+') do
        local candidate = line == '' and word or (line .. ' ' .. word)

        if line ~= '' and (imgui.CalcTextSize(candidate)) > max_width then
            lines[#lines + 1] = line
            line = word
        else
            line = candidate
        end
    end

    if line ~= '' then
        lines[#lines + 1] = line
    end

    if #lines == 0 then
        lines[1] = tostring(text)
    end

    return lines
end

local function draw_guide_paragraph(text, color)
    richtext.draw_wrapped(
        guide_text(text),
        {
            styles = get_styles(),
            color = color or colors.text,
            size = step_font_size,
        }
    )

    imgui.Spacing()
end

-- Shows the quests named in a text as lines that open them in the Journal.
local function draw_guide_quest_links(links, section)
    for _, link in ipairs(links) do
        if draw_quest_link(link, section) then
            if controller.ShowJournal then
                controller.ShowJournal()
            end

            controller.JumpToQuest(link.id)
        end
    end
end

local function draw_guide_bullets(items)
    local can_dot =
        imgui.GetCursorScreenPos
        and imgui.Indent
        and imgui.Unindent

    for _, item in ipairs(items) do
        if can_dot then
            local dot_x, dot_y = imgui.GetCursorScreenPos()
            local line_height = imgui.GetTextLineHeight()

            imgui.Indent(18)

            draw_guide_paragraph(item)

            imgui.Unindent(18)

            imgui.GetWindowDrawList():AddCircleFilled(
                { dot_x + 6, dot_y + line_height * 0.55 },
                3,
                imgui.GetColorU32(colors.gold)
            )
        else
            draw_guide_paragraph('- ' .. item)
        end
    end
end

-- Rows with a label and a text, for example the level of a milestone. When
-- links is true the quests named in the text become links.
local function draw_guide_pairs(rows, links, block_id)
    for index, row in ipairs(rows) do
        imgui.TextColored(colors.gold, guide_text(row[1]))

        if imgui.Indent then
            imgui.Indent(14)
        end

        draw_guide_paragraph(row[2])

        if links and controller.GetTextQuestLinks then
            draw_guide_quest_links(
                controller.GetTextQuestLinks(row[2]),
                'guide_' .. block_id .. '_' .. index
            )
        end

        if imgui.Unindent then
            imgui.Unindent(14)
        end

        imgui.Spacing()
    end
end

-- One quest of a table: its name (a link to the quest in the Journal), the
-- infinity sign when it is repeatable, who gives it, what to do and the
-- reward.
local function draw_guide_quests(rows, block_id)
    for index, row in ipairs(rows) do
        local link = nil

        if controller.GetTextQuestLinks then
            link = controller.GetTextQuestLinks(row.name)[1]
        end

        if link ~= nil and link.name == row.name then
            draw_guide_quest_links({ link }, 'guide_' .. block_id .. '_' .. index)
        else
            imgui.TextColored(colors.gold, row.name)
        end

        if imgui.Indent then
            imgui.Indent(14)
        end

        draw_guide_paragraph(tx('Start: ') .. guide_text(row.start), colors.text_dim)
        draw_guide_paragraph(tx('What you do: ') .. guide_text(row.what))
        draw_guide_paragraph(tx('Reward: ') .. guide_text(row.reward), colors.text_dim)

        local repeatable = row.repeatable
        local value =
            repeatable == true and tx('Yes')
            or repeatable == false and tx('No')
            or guide_text(tostring(repeatable))

        if repeatable == true
            and imgui.GetCursorScreenPos
            and imgui.Dummy then

            local line_height = imgui.GetTextLineHeight()
            local icon_width, icon_height =
                icons.infinity_size(line_height)
            local icon_x, icon_y = imgui.GetCursorScreenPos()

            icons.draw_infinity(
                imgui.GetWindowDrawList(),
                icon_x,
                icon_y + (line_height - icon_height) * 0.5,
                icon_width,
                icon_height,
                imgui.GetColorU32(colors.repeatable),
                2.0
            )

            imgui.Dummy({ icon_width + 6, line_height })
            imgui.SameLine(0, 0)
        end

        imgui.TextColored(
            colors.text_dim,
            tx('Repeatable: ') .. value
        )

        if imgui.Unindent then
            imgui.Unindent(14)
        end

        imgui.Spacing()
        imgui.Separator()
        imgui.Spacing()
    end
end

local function draw_guide_section(section)
    imgui.TextColored(colors.gold, guide_text(section.title))
    imgui.Separator()
    imgui.Spacing()

    for index, block in ipairs(section.blocks) do
        local block_id = tostring(section.id) .. '_' .. index

        if block.p then
            draw_guide_paragraph(block.p)
        elseif block.h then
            imgui.TextColored(colors.gold, guide_text(block.h))
            imgui.Spacing()
        elseif block.note then
            draw_guide_paragraph(block.note, colors.gold)
        elseif block.bullets then
            draw_guide_bullets(block.bullets)
            imgui.Spacing()
        elseif block.pairs then
            draw_guide_pairs(block.pairs, block.links == true, block_id)
        elseif block.quests then
            draw_guide_quests(block.quests, block_id)
        end
    end
end

local function draw_guide_window()
    local wanted =
        controller
        and controller.GetGuideOpen
        and controller.GetGuideOpen()

    if not wanted or not can_draw_ui() then
        guide_was_open = false

        return
    end

    local guide = controller.GetGuide and controller.GetGuide()

    if guide == nil then
        controller.SetGuideOpen(false)

        return
    end

    if not guide_was_open then
        guide_was_open = true
        guide_restore = true
        guide_scroll_top = true
    end

    if guide_restore then
        guide_restore = false

        local journal =
            controller.GetJournalWindowState
            and controller.GetJournalWindowState()

        imgui.SetNextWindowSize({ scaled(760), scaled(680) })

        imgui.SetNextWindowPos({
            ((journal and journal.visible and journal.x) or 40) + 60,
            ((journal and journal.visible and journal.y) or 40) + 60,
        })
    end

    push_theme()

    local font_pushed = journal_font ~= nil

    if font_pushed then
        imgui.PushFont(journal_font, journal_font_size)
    end

    local open = { true }

    scalex.before('guide')

    if imgui.Begin(
        tx('New adventurer guide') .. '###JournalGuide',
        open,
        ImGuiWindowFlags_NoSavedSettings
            + ImGuiWindowFlags_NoCollapse
    ) then
        scalex.after('guide')

        local draw = imgui.GetWindowDrawList()
        local x, y = imgui.GetWindowPos()
        local width, height = imgui.GetWindowSize()

        draw_window_panel(draw, x, y, width, height, true)

        local current = controller.GetGuideSection()

        -- The contents, on the left. It is as wide as the longest title
        -- needs (within limits) and a title that is still too long goes on
        -- more than one line, so no title is cut.
        imgui.PushStyleColor(ImGuiCol_ChildBg, transparent)

        local contents_width =
            math.max(
                scaled(280),
                math.min(scaled(400), math.floor(width * 0.45))
            )

        if imgui.BeginChild(
            '##GuideContents',
            { contents_width, -1 },
            true
        ) then
            -- Room for the padding of the panel and its scroll bar.
            local usable = contents_width - 40

            for index, section in ipairs(guide.sections) do
                local indent = section.level == 2 and '   ' or ''
                -- The lines after the first one are indented a little.
                local room =
                    usable
                    - (imgui.CalcTextSize(indent))
                    - (imgui.CalcTextSize('  '))
                local lines =
                    wrap_guide_title(guide_text(section.title), room)

                for line_index, line in ipairs(lines) do
                    -- Every line of a title selects it.
                    if imgui.Selectable(
                        indent
                            .. (line_index > 1 and '  ' or '')
                            .. line
                            .. '##guide_section_' .. index
                            .. '_' .. line_index,
                        index == current
                    ) then
                        controller.SetGuideSection(index)
                        guide_scroll_top = true
                    end
                end
            end
        end

        imgui.EndChild()

        imgui.SameLine()

        -- The text of the section, on the right.
        if imgui.BeginChild('##GuideContent', { 0, -1 }, true) then
            if guide_scroll_top and imgui.SetScrollY then
                imgui.SetScrollY(0)
            end

            guide_scroll_top = false

            local section = guide.sections[current]

            if section ~= nil then
                draw_guide_section(section)
            end

            imgui.Spacing()
            imgui.Separator()

            imgui.TextColored(
                colors.text_dim,
                tx('Source: ') .. tostring(guide.source)
                    .. ' (' .. tostring(guide.url) .. ')'
            )
        end

        imgui.EndChild()

        imgui.PopStyleColor()
    end

    imgui.End()

    if not open[1] then
        controller.SetGuideOpen(false)
    end

    if font_pushed then
        imgui.PopFont()
    end

    pop_theme()
end

-- Camps window ------------------------------------------------------------

local camps_was_open = false
local camps_restore = false

-- One camp: the levels it is good for, the monsters, the area (with its
-- coordinates) and a note when the table has one. In the list by range the
-- camps that are good for the level are highlighted and the rest are dimmed.
local function draw_camps_entries(entries, highlight)
    for _, entry in ipairs(entries) do
        local camp = entry.camp
        local prefix = string.format('Lv%d-Lv%d  ', camp.from, camp.to)
        local monsters = nil
        local forced = nil

        if camp.monsters ~= '' then
            monsters = tostring(i18n.step(camp.monsters))

            -- The names of the monsters are always in the color of the
            -- monsters (red), even when they are not in the list of names.
            forced = {
                {
                    s = #prefix + 1,
                    e = #prefix + #monsters,
                    kind = 'monster',
                },
            }
        else
            monsters = tx('(monsters not listed)')
        end

        local where = camp.area

        if camp.loc ~= nil then
            where = where .. ' ' .. camp.loc
        end

        local text = prefix .. monsters .. '  -  ' .. where

        if camp.note ~= nil then
            text = text .. ' (' .. tostring(i18n.step(camp.note)) .. ')'
        end

        local color = colors.text

        if highlight then
            color = entry.match and colors.gold or colors.text_dim
        end

        richtext.draw_wrapped(
            text,
            {
                styles = get_styles(),
                forced = forced,
                color = color,
                size = step_font_size,
            }
        )

        imgui.Spacing()
    end
end

local function draw_camps_list(view)
    local highlight = controller.GetCampsMode() == 'bracket'
    local shown = 0

    for _, kind in ipairs({ 'standard', 'alternate' }) do
        if #view[kind] > 0 then
            shown = shown + #view[kind]

            imgui.TextColored(
                colors.gold,
                tx(kind == 'standard' and 'Standard camps' or 'Alternate camps')
            )

            imgui.Separator()
            imgui.Spacing()

            draw_camps_entries(view[kind], highlight)
        end
    end

    if shown == 0 then
        if view.level < 10 then
            richtext.draw_wrapped(
                tx('Camps start at level 10. For levels 1-10, see the guide for new adventurers.'),
                {
                    styles = get_styles(),
                    color = colors.text,
                    size = step_font_size,
                }
            )

            imgui.Spacing()

            if imgui.Button(
                tx('Open the guide') .. '##camps_open_guide',
                { scaled(200), SETTINGS_BUTTON_HEIGHT }
            ) then
                controller.OpenGuideSection('levels1')
            end
        else
            imgui.TextColored(colors.text_dim, tx('No camps for this level.'))
        end
    end
end

local function draw_camps_window()
    local wanted =
        controller
        and controller.GetCampsOpen
        and controller.GetCampsOpen()

    if not wanted or not can_draw_ui() then
        camps_was_open = false

        return
    end

    if not controller.GetCamps or controller.GetCamps() == nil then
        controller.SetCampsOpen(false)

        return
    end

    if not camps_was_open then
        camps_was_open = true
        camps_restore = true
    end

    if camps_restore then
        camps_restore = false

        local journal =
            controller.GetJournalWindowState
            and controller.GetJournalWindowState()

        imgui.SetNextWindowSize({ scaled(700), scaled(640) })

        imgui.SetNextWindowPos({
            ((journal and journal.visible and journal.x) or 40) + 80,
            ((journal and journal.visible and journal.y) or 40) + 80,
        })
    end

    push_theme()

    local font_pushed = journal_font ~= nil

    if font_pushed then
        imgui.PushFont(journal_font, journal_font_size)
    end

    local open = { true }

    scalex.before('camps')

    if imgui.Begin(
        tx('Camps') .. '###JournalCamps',
        open,
        ImGuiWindowFlags_NoSavedSettings
            + ImGuiWindowFlags_NoCollapse
    ) then
        scalex.after('camps')

        local draw = imgui.GetWindowDrawList()
        local x, y = imgui.GetWindowPos()
        local width, height = imgui.GetWindowSize()

        draw_window_panel(draw, x, y, width, height, true)

        -- How the camps are listed: the ones for the level, or a whole range.
        local mode = controller.GetCampsMode()
        local half = math.floor((width - 24 - 8) / 2)

        if draw_settings_choice(
            tx('For your level') .. '##camps_mode_level',
            mode == 'level',
            half
        ) then
            controller.SetCampsMode('level')
        end

        imgui.SameLine(0, 8)

        if draw_settings_choice(
            tx('By level range') .. '##camps_mode_bracket',
            mode == 'bracket',
            half
        ) then
            controller.SetCampsMode('bracket')
        end

        imgui.Spacing()

        -- The level. Clicking the number goes back to the level of the
        -- character, when the game gives it.
        draw_settings_stepper(
            'camps_level',
            tx('Level'),
            tostring(controller.GetCampsLevel()),
            function(direction)
                controller.AdjustCampsLevel(direction)
            end,
            function()
                controller.UseGameLevelForCamps()
            end
        )

        if controller.GetPlayerLevel and controller.GetPlayerLevel() ~= nil then
            local my_level =
                tx('My level') .. ' (' .. controller.GetPlayerLevel() .. ')'

            if imgui.Button(
                my_level .. '##camps_my_level',
                {
                    math.max(
                        scaled(200),
                        math.ceil((imgui.CalcTextSize(my_level)) + 24)
                    ),
                    SETTINGS_BUTTON_HEIGHT,
                }
            ) then
                controller.UseGameLevelForCamps()
            end
        end

        -- The ranges of the table (10, 20 ... 70).
        if mode == 'bracket' then
            imgui.Spacing()

            local current = controller.GetCampsBracket()

            for index, level in ipairs(controller.GetCampsBrackets()) do
                if index > 1 then
                    imgui.SameLine(0, 6)
                end

                if draw_settings_choice(
                    tostring(level) .. '##camps_bracket_' .. level,
                    level == current,
                    scaled(58)
                ) then
                    controller.SetCampsBracket(level)
                end
            end
        end

        imgui.Spacing()

        draw_settings_checkbox(
            'camps_hide_shadow',
            tx('Hide (S) areas'),
            controller.GetCampsHideShadow(),
            controller.SetCampsHideShadow
        )

        if imgui.IsItemHovered() and imgui.SetTooltip then
            imgui.SetTooltip(tx('Areas marked (S) belong to Wings of the Goddess.'))
        end

        imgui.Separator()

        -- The camps.
        if imgui.BeginChild('##CampsList', { 0, -1 }, true) then
            draw_camps_list(controller.GetCampsView())
        end

        imgui.EndChild()
    end

    imgui.End()

    if not open[1] then
        controller.SetCampsOpen(false)
    end

    if font_pushed then
        imgui.PopFont()
    end

    pop_theme()
end

-- Fame of the nations, as it was when the player last talked to the Fame
-- Checker NPC of each one (see fame.lua).
function fame_ui.draw()
    local wanted =
        controller
        and controller.GetFameOpen
        and controller.GetFameOpen()

    if not wanted or not can_draw_ui() then
        fame_ui.was_open = false

        return
    end

    if not controller.GetFameLevels or not controller.GetFameAreas then
        controller.SetFameOpen(false)

        return
    end

    if not fame_ui.was_open then
        fame_ui.was_open = true
        fame_ui.restore = true
    end

    if fame_ui.restore then
        fame_ui.restore = false

        local journal =
            controller.GetJournalWindowState
            and controller.GetJournalWindowState()

        local saved_w, saved_h

        if controller.GetFameSize then
            saved_w, saved_h = controller.GetFameSize()
        end

        imgui.SetNextWindowSize({
            saved_w or scaled(520),
            saved_h or scaled(430),
        })

        imgui.SetNextWindowPos({
            ((journal and journal.visible and journal.x) or 40) + 80,
            ((journal and journal.visible and journal.y) or 40) + 80,
        })
    end

    push_theme()

    local font_pushed = journal_font ~= nil

    if font_pushed then
        imgui.PushFont(journal_font, journal_font_size)
    end

    local open = { true }

    scalex.before('fame')

    if imgui.Begin(
        tx('Fame') .. '###JournalFame',
        open,
        ImGuiWindowFlags_NoSavedSettings
            + ImGuiWindowFlags_NoCollapse
    ) then
        scalex.after('fame')

        local draw = imgui.GetWindowDrawList()
        local x, y = imgui.GetWindowPos()
        local width, height = imgui.GetWindowSize()

        draw_window_panel(draw, x, y, width, height, true)

        -- Remember the size the player gives the window.
        if controller.SetFameSize and controller.GetFameSize then
            local kept_w, kept_h = controller.GetFameSize()

            kept_w = kept_w or scaled(520)
            kept_h = kept_h or scaled(430)

            if math.abs(width - kept_w) > 2
                or math.abs(height - kept_h) > 2 then

                controller.SetFameSize(width, height)
            end
        end

        local fame = controller.GetFameLevels()

        local first_area = true

        for _, area in ipairs(controller.GetFameAreas()) do
            local entry = fame[area.key]

            -- A line between the nations.
            if not first_area then
                imgui.Spacing()
                imgui.Separator()
                imgui.Spacing()
            end

            first_area = false

            imgui.TextColored(colors.gold, area.name)
            imgui.SameLine()

            if entry then
                imgui.TextColored(
                    colors.favorite,
                    string.format(tx('Level %d'), entry.level)
                )
            else
                imgui.TextColored(colors.text_dim, tx('Unknown'))
            end

            if entry and entry.time and entry.time > 0 then
                imgui.TextColored(
                    colors.text_dim,
                    string.format(
                        tx('Last read: %s.'),
                        os.date('%Y-%m-%d', entry.time)
                    )
                )
            end

            imgui.TextColored(colors.text_dim, tx('Talk to:'))

            -- The Fame Checkers: each name is clickable and points the
            -- compass at the NPC, as in the steps of the quests.
            for _, checker in ipairs(area.checkers) do
                fame_ui.inline_icon()
                imgui.TextColored(richtext.COLORS.npc, checker.npc)

                if imgui.IsItemHovered() then
                    pcall(function()
                        local min_x, min_y = imgui.GetItemRectMin()
                        local max_x, max_y = imgui.GetItemRectMax()

                        imgui.GetWindowDrawList():AddLine(
                            { min_x, max_y },
                            { max_x, max_y },
                            imgui.GetColorU32(richtext.COLORS.npc),
                            1
                        )
                    end)

                    if imgui.SetTooltip then
                        imgui.SetTooltip(
                            tx('Click to point the compass at it')
                        )
                    end

                    if imgui.IsItemClicked()
                        and controller.AddCompassNpcByName then

                        controller.AddCompassNpcByName(
                            checker.npc,
                            checker.place
                        )
                    end
                end

                imgui.SameLine()
                imgui.TextColored(colors.text_dim, checker.place)
            end
        end
    end

    imgui.End()

    if not open[1] then
        controller.SetFameOpen(false)
    end

    if font_pushed then
        imgui.PopFont()
    end

    pop_theme()
end

-- The results of the search box: every mission and every quest that has the
-- text, whatever its area, category or the filters of the lists. It replaces
-- the list while the box has a text.
local function draw_search_results(width)
    local match_names = {
        npc = 'NPC',
        place = 'Place',
        reward = 'Reward',
        requires = 'Requires',
        type = 'Type',
    }

    imgui.PushStyleColor(
        ImGuiCol_ChildBg,
        transparent
    )

    if imgui.BeginChild(
        '##JournalSearchResults',
        { width, -1 },
        child_border
    ) then
        local draw = imgui.GetWindowDrawList()
        local x, y = imgui.GetWindowPos()
        local w, h = imgui.GetWindowSize()

        draw_panel(draw, x, y, w, h, true)

        local available = w - scaled(70)
        local result = controller.GetSearchResults
            and controller.GetSearchResults(os.clock())
            or nil

        -- The item that is open in the Journal now.
        local open_kind = nil
        local open_item = nil

        if controller.GetJournalMode() == 1 then
            open_kind = 'mission'
            open_item = controller.GetSelectedMission()
        else
            open_kind = 'quest'
            open_item = controller.GetSelectedQuest()
        end

        if result == nil
            or (#result.missions == 0 and #result.quests == 0) then

            imgui.Spacing()
            imgui.TextColored(colors.text_dim, tx('No matches found.'))
        else
            local function group(title, rows, total, kind)
                if #rows == 0 then
                    return
                end

                imgui.Spacing()
                imgui.TextColored(colors.gold, string.format(tx(title), total))

                for _, row in ipairs(rows) do
                    local selected = open_kind == kind
                        and open_item ~= nil
                        and tostring(open_item.id) == tostring(row.id)
                        and tostring(open_item.name or '') == row.name

                    local status = display_status(row)

                    local clicked = draw_selector_item(
                        row.name,
                        selected,
                        status_dot_color(status),
                        row.repeatable == true,
                        kind .. tostring(row.area or row.category)
                            .. tostring(row.id),
                        controller.IsFavorite ~= nil
                            and controller.IsFavorite(
                                kind == 'mission' and 'Mission' or 'Quest',
                                row
                            ) == true,
                        sheetx.row_icon(row, status, kind == 'mission')
                    )

                    -- A double click opens the sheet, as in the lists.
                    local double_clicked = imgui.IsMouseDoubleClicked ~= nil
                        and imgui.IsItemHovered()
                        and imgui.IsMouseDoubleClicked(0)

                    draw_status_at_item_end(status)

                    if clicked or double_clicked then
                        if controller.OpenSearchResult(row) then
                            local sheet = kind == 'mission' and 'Mission'
                                or 'Quest'

                            if double_clicked then
                                open_sheet(sheet)
                            elseif sheet_open then
                                sheet_kind = sheet
                            end
                        end
                    end

                    -- Where it is, and what the text matched.
                    local detail = row.label or ''

                    if row.match == 'step' then
                        detail = detail .. '  -  '
                            .. string.format(tx('Step %d'), row.step or 0)
                    elseif match_names[row.match] ~= nil then
                        detail = detail .. '  -  ' .. tx(match_names[row.match])
                    end

                    imgui.TextColored(
                        colors.text_dim,
                        '      ' .. fit_text(detail, available)
                    )
                end

                if total > #rows then
                    imgui.TextColored(
                        colors.text_dim,
                        fit_text(
                            string.format(
                                tx('Showing the first %d of %d.'),
                                #rows,
                                total
                            ),
                            available
                        )
                    )
                end
            end

            group('Missions (%d)', result.missions, result.total_missions, 'mission')
            group('Quests (%d)', result.quests, result.total_quests, 'quest')
        end
    end

    imgui.EndChild()

    imgui.PopStyleColor()
end

local function draw_journal()
    if not can_draw_ui()
        or not controller
        or not controller.GetJournalWindowState then

        return
    end

    local state =
        controller.GetJournalWindowState()

    if not state
        or not state.visible then

        return
    end

    -- "Reset window positions" in the settings: read the position again.
    if journal_last_reset_count == nil then
        journal_last_reset_count = state.reset_count
    elseif state.reset_count ~= journal_last_reset_count then
        journal_last_reset_count = state.reset_count
        journal_restore_window = true
    end

    if journal_restore_window then
        journal_restore_window =
            restore_window(
                state,
                journal_restore_window
            )
    end

    push_theme()

    local font_pushed =
        journal_font ~= nil

    if font_pushed then
        imgui.PushFont(
            journal_font,
            journal_font_size
        )
    end

    local is_mission_mode =
        controller.GetJournalMode() == 1

    local open = {
        state.visible,
    }

    local title =
        is_mission_mode
        and tx('Mission Journal')
        or tx('Quest Journal')

    scalex.before('journal')

    if imgui.Begin(
        title .. '###JournalWindow',
        open,
        ImGuiWindowFlags_NoSavedSettings
            + ImGuiWindowFlags_NoScrollbar
            + ImGuiWindowFlags_NoScrollWithMouse
            + ImGuiWindowFlags_NoCollapse
    ) then
        scalex.after('journal')

        local draw =
            imgui.GetWindowDrawList()

        local x, y =
            imgui.GetWindowPos()

        local width, height =
            imgui.GetWindowSize()

        draw_window_panel(
            draw,
            x,
            y,
            width,
            height,
            true
        )

        draw_journal_toolbar(
            is_mission_mode
        )

        imgui.Spacing()

        local content_width =
            imgui.GetWindowWidth()

        local spacing = 10

        local details_width =
            math.floor(
                content_width * 0.32
            )

        local list_width =
            content_width
            - details_width
            - spacing

        if controller.GetSearchText
            and controller.GetSearchResults
            and controller.GetSearchText() ~= '' then

            draw_search_results(list_width)
        else
            draw_journal_list(
                is_mission_mode,
                list_width
            )
        end

        imgui.SameLine(
            0,
            spacing
        )

        if is_mission_mode then
            local areas =
                controller.GetMissionAreas()

            local selection =
                controller.GetMissionSelection()

            draw_details_panel(
                'Mission',
                details_width,
                areas[
                    selection.area_index
                ]
            )
        else
            draw_details_panel(
                'Quest',
                details_width
            )
        end

        local wx, wy =
            imgui.GetWindowPos()

        local ww, wh =
            imgui.GetWindowSize()

        if wx ~= state.x
            or wy ~= state.y
            or ww ~= state.width
            or wh ~= state.height then

            if controller.SetJournalGeometry then
                controller.SetJournalGeometry(
                    wx,
                    wy,
                    ww,
                    wh
                )
            end
        end
    end

    imgui.End()

    if not open[1] then
        controller.SetJournalVisible(false)
        controller.SetJournalMini(true)

        journal_mini_restore_window =
            true

        close_popups()
        reset_repeat()
    end

    if font_pushed then
        imgui.PopFont()
    end

    pop_theme()
end

local function controller_vertical(
    direction
)
    if not controller then
        return
    end

    if journal_mode_popup_open then
        controller.SetJournalMode(
            controller.GetJournalMode() == 1
                and 2
                or 1
        )

        return
    end

    if journal_area_popup_open then
        if direction < 0 then
            controller.SelectPreviousMissionArea()
        else
            controller.SelectNextMissionArea()
        end

        return
    end

    if journal_category_popup_open then
        if direction < 0 then
            controller.SelectPreviousQuestCategory()
        else
            controller.SelectNextQuestCategory()
        end

        return
    end

    local state =
        controller.GetJournalWindowState()

    if not state
        or not state.visible then

        return
    end

    if controller.GetJournalMode() == 1 then
        if direction < 0 then
            controller.SelectPreviousMission()
        else
            controller.SelectNextMission()
        end
    else
        if direction < 0 then
            controller.SelectPreviousQuest()
        else
            controller.SelectNextQuest()
        end
    end
end

local function controller_horizontal(
    direction
)
    if not controller then
        return
    end

    local state =
        controller.GetJournalWindowState()

    if not state
        or not state.visible then

        return
    end

    if journal_mode_popup_open
        or journal_area_popup_open
        or journal_category_popup_open then

        return
    end

    if controller.GetJournalMode() == 1 then
        if direction < 0 then
            controller.SelectPreviousMissionArea()
        else
            controller.SelectNextMissionArea()
        end
    else
        if direction < 0 then
            controller.SelectPreviousQuestCategory()
        else
            controller.SelectNextQuestCategory()
        end
    end
end

local function controller_move(button)
    if button == DPAD.UP then
        controller_vertical(-1)

    elseif button == DPAD.DOWN then
        controller_vertical(1)

    elseif button == DPAD.LEFT then
        controller_horizontal(-1)

    elseif button == DPAD.RIGHT then
        controller_horizontal(1)
    end
end

local function controller_confirm()
    if not controller then
        return
    end

    local state =
        controller.GetJournalWindowState()

    if not state
        or not state.visible then

        return
    end

    if journal_mode_popup_open
        or journal_area_popup_open
        or journal_category_popup_open then

        close_popups()
        imgui.CloseCurrentPopup()

        return
    end

    -- Same as double-clicking the row with the mouse: open the sheet.
    open_sheet(
        controller.GetJournalMode() == 1
            and 'Mission'
            or 'Quest'
    )
end

-- Pins the selected mission or quest to the Tracker, or unpins it.
local function controller_toggle_pin()
    if not controller
        or not controller.ToggleItemPin then

        return
    end

    local state =
        controller.GetJournalWindowState()

    if not state
        or not state.visible then

        return
    end

    if controller.GetJournalMode() == 1 then
        local selected =
            controller.GetSelectedMission()

        if selected then
            controller.ToggleItemPin(
                'Mission',
                selected
            )
        end
    else
        local selected =
            controller.GetSelectedQuest()

        if selected then
            controller.ToggleItemPin(
                'Quest',
                selected
            )
        end
    end
end

local function controller_cancel()
    if not controller then
        return
    end

    if journal_mode_popup_open
        or journal_area_popup_open
        or journal_category_popup_open then

        close_popups()
        imgui.CloseCurrentPopup()

        return
    end

    -- The first press closes the sheet, the next one the Journal.
    if sheet_open or progress_open
        or (controller.GetActiveOpen and controller.GetActiveOpen())
        or (controller.GetSettingsOpen and controller.GetSettingsOpen())
        or (controller.GetGuideOpen and controller.GetGuideOpen())
        or (controller.GetCampsOpen and controller.GetCampsOpen())
        or (controller.GetFameOpen and controller.GetFameOpen()) then

        sheet_open = false
        progress_open = false

        if controller.SetFameOpen then
            controller.SetFameOpen(false)
        end

        if controller.SetActiveOpen then
            controller.SetActiveOpen(false)
        end

        if controller.SetCampsOpen then
            controller.SetCampsOpen(false)
        end

        if controller.SetSettingsOpen then
            controller.SetSettingsOpen(false)
        end

        if controller.SetGuideOpen then
            controller.SetGuideOpen(false)
        end

        return
    end

    controller.SetJournalVisible(false)
    controller.SetJournalMini(true)

    journal_mini_restore_window =
        true

    journal_help_window =
        false

    reset_repeat()
end

local function update_controller_repeat()
    if controller_repeat_button == nil then
        return
    end

    if not controller then
        reset_repeat()
        return
    end

    local state =
        controller.GetJournalWindowState()

    if not state
        or not state.visible then

        controller_repeat_button = nil
        controller_repeat_time = 0

        return
    end

    local now = os.clock()

    if now < controller_repeat_time then
        return
    end

    controller_move(
        controller_repeat_button
    )

    controller_repeat_time =
        now
        + controller_repeat_interval
end

local function update_keyboard_repeat()
    if keyboard_repeat_key == nil then
        return
    end

    if not controller then
        keyboard_repeat_key = nil
        keyboard_repeat_time = 0

        return
    end

    local state =
        controller.GetJournalWindowState()

    if not state
        or not state.visible then

        keyboard_repeat_key = nil
        keyboard_repeat_time = 0

        return
    end

    local now = os.clock()

    if now < keyboard_repeat_time then
        return
    end

    if keyboard_repeat_key == KEY.UP then
        controller_vertical(-1)

    elseif keyboard_repeat_key == KEY.DOWN then
        controller_vertical(1)

    elseif keyboard_repeat_key == KEY.LEFT then
        controller_horizontal(-1)

    elseif keyboard_repeat_key == KEY.RIGHT then
        controller_horizontal(1)
    end

    keyboard_repeat_time =
        now
        + keyboard_repeat_interval
end

local function controller_enabled()
    if controller == nil then
        return journal_help_window
    end

    local state =
        controller.GetJournalWindowState()

    return (
        state ~= nil
        and state.visible
    )
        or journal_help_window
end

local function sync_journal_mini()
    if not controller
        or not controller.GetJournalWindowState
        or not controller.GetJournalMiniState
        or not controller.SetJournalMini then

        return
    end

    local state =
        controller.GetJournalWindowState()

    local mini =
        controller.GetJournalMiniState()

    if not state
        or not mini then

        return
    end

    local visible =
        not state.visible

    if mini.visible ~= visible then
        controller.SetJournalMini(
            visible
        )

        if visible then
            journal_mini_restore_window =
                true
        end
    end
end

ashita.events.register(
    'xinput_button',
    'journal_ui_xinput_button',
    function(e)
        if not controller_enabled() then
            return
        end

        if e.state == 0 then
            if controller_repeat_button
                == e.button then

                controller_repeat_button =
                    nil

                controller_repeat_time =
                    0
            end

            return
        end

        if e.button == DPAD.UP
            or e.button == DPAD.DOWN
            or e.button == DPAD.LEFT
            or e.button == DPAD.RIGHT then

            controller_move(
                e.button
            )

            controller_repeat_button =
                e.button

            controller_repeat_time =
                os.clock()
                + controller_repeat_delay

            e.blocked = true

            return
        end

        if e.button == BUTTON_A then
            controller_confirm()
            e.blocked = true

            return
        end

        if e.button == BUTTON_X then
            controller_toggle_pin()
            e.blocked = true

            return
        end

        if e.button == BUTTON_B then
            controller_cancel()
            e.blocked = true
        end
    end
)

ashita.events.register(
    'key_data',
    'journal_ui_key_data',
    function(e)
        if not controller then
            return
        end

        local state =
            controller.GetJournalWindowState()

        if (
            not state
            or not state.visible
        )
            and not journal_help_window then

            return
        end

        if not e.down then
            if (
                e.key == KEY.UP
                or e.key == KEY.DOWN
                or e.key == KEY.LEFT
                or e.key == KEY.RIGHT
            )
                and keyboard_repeat_key
                    == e.key then

                keyboard_repeat_key = nil
                keyboard_repeat_time = 0
            end

            return
        end

        if e.key == 0x01 then
            -- The first Esc closes the sheet, the next one the Journal.
            if sheet_open or progress_open
                or (
                    controller.GetActiveOpen
                    and controller.GetActiveOpen()
                )
                or (
                    controller.GetSettingsOpen
                    and controller.GetSettingsOpen()
                )
                or (
                    controller.GetGuideOpen
                    and controller.GetGuideOpen()
                )
                or (
                    controller.GetCampsOpen
                    and controller.GetCampsOpen()
                )
                or (
                    controller.GetFameOpen
                    and controller.GetFameOpen()
                ) then

                sheet_open = false
                progress_open = false

                if controller.SetFameOpen then
                    controller.SetFameOpen(false)
                end

                if controller.SetActiveOpen then
                    controller.SetActiveOpen(false)
                end

                if controller.SetCampsOpen then
                    controller.SetCampsOpen(false)
                end

                if controller.SetSettingsOpen then
                    controller.SetSettingsOpen(false)
                end

                if controller.SetGuideOpen then
                    controller.SetGuideOpen(false)
                end

                e.blocked = true

                return
            end

            controller.SetJournalVisible(
                false
            )

            journal_help_window =
                false

            close_popups()
            reset_repeat()

            e.blocked = true

            return
        end

        if not state
            or not state.visible then

            return
        end

        -- While a note is being typed every arrow key and Enter belong to
        -- the text (up and down would change the quest under the note).
        if note_input_active
            and (
                e.key == KEY.UP
                or e.key == KEY.DOWN
                or e.key == KEY.LEFT
                or e.key == KEY.RIGHT
                or e.key == 0x1C
                or e.key == 0x9C
            ) then

            return
        end

        -- While the search box has the keyboard, left, right and Enter
        -- belong to the text. Up and down still move the list.
        if journal_search_active
            and (
                e.key == KEY.LEFT
                or e.key == KEY.RIGHT
                or e.key == 0x1C
                or e.key == 0x9C
            ) then

            return
        end

        if e.key == KEY.UP
            or e.key == KEY.DOWN
            or e.key == KEY.LEFT
            or e.key == KEY.RIGHT then

            if keyboard_repeat_key
                ~= e.key then

                if e.key == KEY.UP then
                    controller_vertical(-1)

                elseif e.key == KEY.DOWN then
                    controller_vertical(1)

                elseif e.key == KEY.LEFT then
                    controller_horizontal(-1)

                else
                    controller_horizontal(1)
                end

                keyboard_repeat_key =
                    e.key

                keyboard_repeat_time =
                    os.clock()
                    + keyboard_repeat_delay
            end

            e.blocked = true

            return
        end

        if e.key == 0x1C
            or e.key == 0x9C then

            controller_confirm()
            e.blocked = true
        end
    end
)

local function draw_journal_help()
    if not journal_help_window
        or not game_ui_visible then

        return
    end

    if journal_help_restore then
        imgui.SetNextWindowSize({
            scaled(journal_help_width),
            scaled(journal_help_height),
        })

        journal_help_restore = false
    end

    push_theme()

    local font_pushed =
        journal_font ~= nil

    if font_pushed then
        imgui.PushFont(
            journal_font,
            journal_font_size
        )
    end

    local open = {
        journal_help_window,
    }

    scalex.before('help')

    if imgui.Begin(
        tx('Journal Help') .. '###JournalHelp',
        open
    ) then
        scalex.after('help')

        local draw =
            imgui.GetWindowDrawList()

        local x, y =
            imgui.GetWindowPos()

        local width, height =
            imgui.GetWindowSize()

        draw_window_panel(
            draw,
            x,
            y,
            width,
            height,
            true
        )

        imgui.TextColored(
            colors.gold,
            tx('MISSION JOURNAL COMMANDS')
        )

        imgui.Spacing()
        imgui.Separator()
        imgui.Spacing()

        local help = {
            {
                '/journal',
                tx('Open the Mission Journal.'),
            },
            {
                '/journal settings',
                tx('Open the settings window.'),
            },
            {
                '/journal guide',
                tx('Open the guide for new adventurers.'),
            },
            {
                '/journal camps',
                tx('Open the camps guide.'),
            },
            {
                '/journal help',
                tx('Show this command list in chat.'),
            },
            {
                '/journal quest',
                tx('Open the Quest Journal.'),
            },
            {
                '/journal pin',
                tx('Show or hide the pinned tracker.'),
            },
            {
                '/journal pin size [+|-|reset|<value>]',
                tx('Change the tracker size from 0.60x to 2.00x.'),
            },
            {
                '/journal pin preview [on|off]',
                tx('Show or hide the next step in the tracker.'),
            },
            {
                '/journal lang [en|es]',
                tx('Switch the Journal between English and Spanish.'),
            },
        }

        for i, entry in ipairs(help) do
            imgui.Text(
                entry[1]
            )

            imgui.TextColored(
                colors.text_dim,
                entry[2]
            )

            if i < #help then
                imgui.Spacing()
            end
        end
    end

    imgui.End()

    if not open[1] then
        journal_help_window = false
    end

    if font_pushed then
        imgui.PopFont()
    end

    pop_theme()
end

-- General notes window --------------------------------------------------------
-- On the left the notes (without a folder first, then each folder with its
-- notes), on the right the title, the folder and the text of the selected
-- note, or the name of the selected folder. notes.lua saves everything in a
-- file shared by all the characters, and also the size of this window.

-- The colors a folder can have (notes.lua keeps the number, 1 to 8).
notesx.palette = {
    { 0.90, 0.35, 0.35, 1.0 },
    { 0.95, 0.60, 0.25, 1.0 },
    { 0.95, 0.85, 0.35, 1.0 },
    { 0.45, 0.80, 0.45, 1.0 },
    { 0.35, 0.75, 0.75, 1.0 },
    { 0.40, 0.60, 0.95, 1.0 },
    { 0.68, 0.50, 0.90, 1.0 },
    { 0.92, 0.55, 0.75, 1.0 },
}

-- A bar of the color of the folder on the left of the last item.
function notesx.bar(color, width)
    local rgba = color and color > 0 and notesx.palette[color] or nil

    if rgba == nil then
        return
    end

    local min_x, min_y = imgui.GetItemRectMin()
    local _, max_y = imgui.GetItemRectMax()

    imgui.GetWindowDrawList():AddRectFilled(
        { min_x - width - 2, min_y },
        { min_x - 2, max_y },
        imgui.GetColorU32(rgba)
    )
end

function notesx.draw()
    local store = controller and controller.notes

    if store == nil
        or not store.GetOpen()
        or not can_draw_ui()
        or imgui.InputText == nil then

        notesx.was_open = false

        return
    end

    store.Tick()

    if not notesx.was_open then
        notesx.was_open = true
        notesx.key = nil
        notesx.ckey = nil
        notesx.confirm = nil

        local journal =
            controller.GetJournalWindowState
            and controller.GetJournalWindowState()

        local saved = store.GetSize()

        imgui.SetNextWindowSize({
            saved and saved.w or scaled(720),
            saved and saved.h or scaled(540),
        })

        imgui.SetNextWindowPos({
            ((journal and journal.visible and journal.x) or 40) + 60,
            ((journal and journal.visible and journal.y) or 40) + 60,
        })
    end

    -- The player can drag the corner to resize it.
    if imgui.SetNextWindowSizeConstraints then
        imgui.SetNextWindowSizeConstraints(
            { scaled(460), scaled(300) },
            { scaled(1600), scaled(1400) }
        )
    end

    push_theme()

    local font_pushed = journal_font ~= nil

    if font_pushed then
        imgui.PushFont(journal_font, journal_font_size)
    end

    local open = { true }

    imgui.PushStyleColor(ImGuiCol_ResizeGrip, { 0.80, 0.84, 0.95, 0.30 })
    imgui.PushStyleColor(ImGuiCol_ResizeGripHovered, { 0.80, 0.84, 0.95, 0.60 })
    imgui.PushStyleColor(ImGuiCol_ResizeGripActive, { 0.80, 0.84, 0.95, 0.90 })

    scalex.before('notes')

    if imgui.Begin(
        tx('General notes') .. '###JournalNotes',
        open,
        ImGuiWindowFlags_NoSavedSettings
            + ImGuiWindowFlags_NoCollapse
    ) then
        scalex.after('notes')

        local draw = imgui.GetWindowDrawList()
        local x, y = imgui.GetWindowPos()
        local width, height = imgui.GetWindowSize()

        -- Remembered (the file is written a moment after the last change).
        store.SetSize(width, height)

        draw_window_panel(draw, x, y, width, height, true)

        local list_w = math.floor(math.max(scaled(200), width * 0.32))
        local half = math.floor((list_w - 8) / 2)
        local now = os.clock()

        local sel_cat = store.GetSelectedCategory()

        if imgui.Button(
            tx('New note') .. '##NotesNew',
            { half, ui_button_height }
        ) then
            local index = store.Add(sel_cat)

            if index ~= nil then
                store.Select(store.Get(index).id)
                notesx.key = nil
                notesx.full = 0
            else
                notesx.full = now
            end
        end

        imgui.SameLine(0, 8)

        if imgui.Button(
            tx('New folder') .. '##NotesNewFolder',
            { half, ui_button_height }
        ) then
            local id = store.AddCategory()

            if id ~= nil then
                store.SelectCategory(id)
                notesx.ckey = nil
                notesx.full = 0
            else
                notesx.full = now
            end
        end

        if notesx.full > 0 and now - notesx.full < 4 then
            imgui.SameLine(0, 12)
            imgui.TextColored(
                colors.text_dim,
                tx('The notes list is full.')
            )
        end

        imgui.Spacing()

        imgui.PushStyleColor(ImGuiCol_ChildBg, transparent)

        -- The list.
        if imgui.BeginChild('##NotesList', { list_w, -1 }, child_border) then
            local rows = store.Rows()

            if #rows == 0 then
                imgui.TextWrapped(
                    tx('No notes yet. Click New note to write one.')
                )
            end

            local toggle_w = ui_button_height

            for _, row in ipairs(rows) do
                if row.kind == 'folder' then
                    local cat = row.cat

                    if imgui.Button(
                        (cat.collapsed and '+' or '-')
                            .. '##NotesFold' .. tostring(cat.id),
                        { toggle_w, ui_button_height }
                    ) then
                        store.SetCollapsed(cat.id, not cat.collapsed)
                    end

                    imgui.SameLine(0, 4)

                    if toolbar_mode_button(
                        cat.name .. ' (' .. row.count .. ')'
                            .. '##NotesCat' .. tostring(cat.id),
                        cat.id == sel_cat,
                        list_w - toggle_w - 24
                    ) then
                        store.SelectCategory(cat.id)
                    end

                    notesx.bar(cat.color, 5)
                else
                    local note = row.note
                    local indent = row.nested and scaled(24) or 0

                    if indent > 0 then
                        imgui.Dummy({ indent, 1 })
                        imgui.SameLine(0, 0)
                    end

                    if toolbar_mode_button(
                        (store.Title(note, 22) or tx('Empty note'))
                            .. '##note' .. tostring(note.id),
                        note.id == store.GetSelected(),
                        list_w - 20 - indent
                    ) then
                        store.Select(note.id)
                    end

                    if row.nested then
                        local owner = store.GetCategory(note.cat)

                        notesx.bar(owner and owner.color, 3)
                    end
                end
            end
        end

        imgui.EndChild()

        imgui.SameLine(0, 8)

        -- The right side.
        if imgui.BeginChild('##NotesEdit', { -1, -1 }, child_border) then
            -- The room of the right side. If the call is not there, it is
            -- worked out from the window.
            local avail_w, avail_h = nil, nil

            if imgui.GetContentRegionAvail ~= nil then
                local ok, aw, ah = pcall(imgui.GetContentRegionAvail)

                if ok then
                    avail_w, avail_h = tonumber(aw), tonumber(ah)
                end
            end

            avail_w = avail_w or (width - list_w - 40)
            avail_h = avail_h or (height - ui_button_height - 60)

            local index = store.IndexOfId(store.GetSelected())
            local note = index and store.Get(index) or nil
            local cat = sel_cat and store.GetCategory(sel_cat) or nil

            if cat ~= nil then
                -- A folder: its name and a delete.
                if notesx.ckey ~= cat.id then
                    notesx.ckey = cat.id
                    notesx.cbuf[1] = cat.name
                    notesx.confirm = nil
                end

                imgui.TextColored(colors.text_dim, tx('Folder'))

                imgui.PushItemWidth(math.max(120, avail_w))

                local typed = imgui.InputText(
                    '##NotesFolderName',
                    notesx.cbuf,
                    store.CAT_NAME_MAX + 1
                )

                imgui.PopItemWidth()

                if imgui.IsItemActive() then
                    note_input_active = true
                end

                if typed then
                    store.RenameCategory(cat.id, notesx.cbuf[1])
                end

                imgui.Spacing()
                imgui.TextColored(colors.text_dim, tx('Color'))

                -- No color, then the eight of the palette.
                local swatch = math.floor(ui_button_height * 0.75)

                for number = 0, store.COLOR_COUNT do
                    if number > 0 then
                        imgui.SameLine(0, 6)
                    end

                    if imgui.Button(
                        '##NotesColor' .. number,
                        { swatch, swatch }
                    ) then
                        store.SetCategoryColor(cat.id, number)
                    end

                    local min_x, min_y = imgui.GetItemRectMin()
                    local max_x, max_y = imgui.GetItemRectMax()
                    local sdraw = imgui.GetWindowDrawList()
                    local rgba = notesx.palette[number]

                    if rgba ~= nil then
                        sdraw:AddRectFilled(
                            { min_x + 3, min_y + 3 },
                            { max_x - 3, max_y - 3 },
                            imgui.GetColorU32(rgba)
                        )
                    else
                        -- None: an empty square with a slash.
                        sdraw:AddLine(
                            { min_x + 5, max_y - 5 },
                            { max_x - 5, min_y + 5 },
                            imgui.GetColorU32(colors.text_dim),
                            2.0
                        )
                    end

                    -- The chosen one has a frame.
                    if (cat.color or 0) == number then
                        sdraw:AddRect(
                            { min_x, min_y },
                            { max_x, max_y },
                            imgui.GetColorU32(colors.text),
                            0,
                            0,
                            2.0
                        )
                    end
                end

                imgui.Spacing()
                imgui.TextWrapped(
                    tx('Notes in a deleted folder are kept, without a folder.')
                )
                imgui.Spacing()

                local confirming =
                    notesx.confirm == 'c' .. cat.id
                    and now - (notesx.confirm_time or 0) < 4

                local label =
                    confirming and tx('Click again to delete')
                    or tx('Delete folder')

                if imgui.Button(
                    label .. '##NotesDeleteFolder',
                    {
                        math.max(
                            scaled(140),
                            math.ceil((imgui.CalcTextSize(label)) + 28)
                        ),
                        ui_button_height,
                    }
                ) then
                    if confirming then
                        store.DeleteCategory(cat.id)
                        store.SelectCategory(nil)
                        notesx.ckey = nil
                        notesx.confirm = nil
                    else
                        notesx.confirm = 'c' .. cat.id
                        notesx.confirm_time = now
                    end
                end
            elseif note == nil then
                imgui.TextWrapped(
                    tx('Select a note, or create a new one.')
                )
            else
                if notesx.key ~= note.id then
                    notesx.key = note.id
                    notesx.buffer[1] = note.text
                    notesx.tbuf[1] = note.title
                    notesx.confirm = nil
                end

                -- The title.
                imgui.PushItemWidth(math.max(120, avail_w))

                local title_typed = imgui.InputText(
                    '##NotesTitle',
                    notesx.tbuf,
                    store.TITLE_MAX + 1
                )

                imgui.PopItemWidth()

                local title_active = imgui.IsItemActive()

                if title_active then
                    note_input_active = true
                end

                if title_typed then
                    store.SetTitle(index, notesx.tbuf[1])
                end

                if notesx.tbuf[1] == '' and not title_active then
                    local box_x, box_y = imgui.GetItemRectMin()
                    local _, box_bottom = imgui.GetItemRectMax()

                    imgui.GetWindowDrawList():AddText(
                        {
                            box_x + 8,
                            box_y
                                + (
                                    (box_bottom - box_y)
                                    - imgui.GetTextLineHeight()
                                ) * 0.5,
                        },
                        imgui.GetColorU32(colors.text_dim),
                        tx('Title')
                    )
                end

                -- The folder of the note.
                local current = store.GetCategory(note.cat)
                local current_name =
                    current and current.name or tx('No folder')

                imgui.TextColored(colors.text_dim, tx('Folder'))
                imgui.SameLine(0, 8)

                local cats = store.GetCategories()

                if imgui.BeginCombo ~= nil
                    and imgui.EndCombo ~= nil
                    and imgui.Selectable ~= nil then

                    imgui.PushItemWidth(math.max(120, avail_w - scaled(90)))

                    if imgui.BeginCombo(
                        '##NotesFolder',
                        current_name
                    ) then
                        if imgui.Selectable(
                            tx('No folder') .. '##NotesFolder0',
                            note.cat == 0
                        ) then
                            store.SetCategory(index, 0)
                        end

                        for _, option in ipairs(cats) do
                            if imgui.Selectable(
                                option.name
                                    .. '##NotesFolder' .. tostring(option.id),
                                note.cat == option.id
                            ) then
                                store.SetCategory(index, option.id)
                            end
                        end

                        imgui.EndCombo()
                    end

                    imgui.PopItemWidth()
                else
                    -- Without a list: the button goes to the next folder.
                    if imgui.Button(
                        current_name .. '##NotesFolderCycle',
                        { math.max(120, avail_w - scaled(90)), ui_button_height }
                    ) then
                        local next_id = cats[1] and cats[1].id or 0

                        for position, option in ipairs(cats) do
                            if option.id == note.cat then
                                next_id = cats[position + 1]
                                    and cats[position + 1].id or 0
                            end
                        end

                        store.SetCategory(index, next_id)
                    end
                end

                imgui.Spacing()

                -- The text.
                local box = {
                    math.max(120, avail_w),
                    math.max(80, avail_h - 3 * ui_button_height - 40),
                }

                local typed

                if imgui.InputTextMultiline ~= nil then
                    typed = imgui.InputTextMultiline(
                        '##NotesText',
                        notesx.buffer,
                        store.TEXT_MAX + 1,
                        box
                    )
                else
                    imgui.PushItemWidth(box[1])

                    typed = imgui.InputText(
                        '##NotesText',
                        notesx.buffer,
                        store.TEXT_MAX + 1
                    )

                    imgui.PopItemWidth()
                end

                local active = imgui.IsItemActive()

                if active then
                    note_input_active = true
                end

                if typed then
                    store.SetText(index, notesx.buffer[1])
                end

                -- Hint inside the empty box.
                if notesx.buffer[1] == '' and not active then
                    local box_x, box_y = imgui.GetItemRectMin()

                    imgui.GetWindowDrawList():AddText(
                        { box_x + 8, box_y + 6 },
                        imgui.GetColorU32(colors.text_dim),
                        tx('Write your note here')
                    )
                end

                -- Delete asks for a second click.
                local confirming =
                    notesx.confirm == note.id
                    and now - (notesx.confirm_time or 0) < 4

                local label =
                    confirming and tx('Click again to delete')
                    or tx('Delete')

                if imgui.Button(
                    label .. '##NotesDelete',
                    {
                        math.max(
                            scaled(120),
                            math.ceil((imgui.CalcTextSize(label)) + 28)
                        ),
                        ui_button_height,
                    }
                ) then
                    if confirming then
                        store.Delete(index)
                        store.Select(nil)
                        notesx.key = nil
                        notesx.confirm = nil
                    else
                        notesx.confirm = note.id
                        notesx.confirm_time = now
                    end
                end

                imgui.SameLine(0, 12)
                imgui.TextColored(
                    colors.text_dim,
                    #notesx.buffer[1] .. '/' .. store.TEXT_MAX
                )
            end
        end

        imgui.EndChild()

        imgui.PopStyleColor()
    end

    imgui.End()

    imgui.PopStyleColor(3)

    if not open[1] then
        store.SetOpen(false)
    end

    if font_pushed then
        imgui.PopFont()
    end

    pop_theme()
end

function M.Draw()
    -- Set again by the note box of this frame, if it has the keyboard.
    note_input_active = false

    apply_text_scale()
    update_game_ui_visibility()
    update_controller_repeat()
    update_keyboard_repeat()
    sync_journal_mini()

    draw_journal()
    draw_sheet_window()
    draw_progress_window()
    draw_active_window()
    draw_compass_window()
    draw_settings_window()
    draw_guide_window()
    draw_camps_window()
    fame_ui.draw()
    notesx.draw()
    draw_journal_mini()
    draw_journal_help()
end

ashita.events.register(
    'load',
    'journal_ui_load',
    function()
        initialize_game_visibility()
        load_journal_mini_texture()

        journal_font =
            imgui.AddFontFromFileTTF(
                addon.path
                    .. 'assets/fonts/CarroisGothicSC-Regular.ttf',
                30
            )

        -- Fira Sans for the step text. If a file cannot be loaded that
        -- style falls back (bold is faked, italics are tinted).
        local function load_text_font(file)
            local ok, font = pcall(
                imgui.AddFontFromFileTTF,
                addon.path .. 'assets/fonts/' .. file,
                30
            )

            if ok then
                return font
            end

            return nil
        end

        text_font = load_text_font('FiraSans-Regular.ttf')
        text_bold_font = load_text_font('FiraSans-Bold.ttf')
        text_italic_font = load_text_font('FiraSans-Italic.ttf')

        richtext.set_fonts({
            regular = text_font,
            bold = text_bold_font,
            italic = text_italic_font,
        })
    end
)

ashita.events.register(
    'unload',
    'journal_ui_unload',
    function()
        reset_repeat()
        list_last_selection = {}

        for _, cover in pairs(
            journal_cover_cache
        ) do
            if cover ~= nil
                and cover ~= false then

                cover.ptr = nil
            end
        end

        for _, logo in pairs(journal_logo_cache) do
            if logo ~= nil and logo ~= false then
                logo.ptr = nil
            end
        end

        journal_logo_cache = {}
        journal_mini_texture = nil
        journal_cover_cache = {}

        journal_font = nil
        text_font = nil
        text_bold_font = nil
        text_italic_font = nil
        richtext.set_fonts({})

        pGameMenu = 0
        pEventSystem = 0
        pInterfaceHidden = 0

        game_visibility_initialized =
            false

        game_ui_visible =
            false

        visibility_cache_time =
            0
    end
)

M.CanDrawUI = can_draw_ui

return M
