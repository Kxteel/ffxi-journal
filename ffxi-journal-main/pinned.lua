-- Pinned tracker.
--
-- Small standalone window with the missions and quests pinned from the
-- Journal ("Pin to Tracker"). Two layouts:
--   stacked : every pinned item at once, missions first, then quests
--   tabs    : one item at a time, with a tab per item
--
-- The window has no background and everything is set flush right, with a
-- small shadow behind the text so it stays readable over the game.
--
-- The server only reports whether a quest or mission is active or
-- completed, so the current step is advanced by hand (the < and >
-- buttons, or /journal pin next|prev|reset) or by the zone-change check.
-- Items are unpinned from the Journal or with /journal pin remove <n>.

local imgui = require('imgui')
local richtext = require('richtext')

local M = {}

local styles = nil

-- Light blue for italics, used only if the italic font could not be loaded.
local italic_tint = { 0.75, 0.84, 1.00, 1.00 }

local restore_window = true

local WINDOW_WIDTH = 420
local TAB_NAME_LENGTH = 12
local TEXT_SIZE = 16

-- Text size of the current frame, TEXT_SIZE times the tracker scale.
local current_size = TEXT_SIZE

-- Layout of the default ImGui style, used to set buttons flush right.
local WINDOW_PADDING = 8
local FRAME_PADDING_X = 4
local FRAME_PADDING_Y = 3
local ITEM_SPACING_X = 8
local INNER_SPACING_X = 4

local TRANSPARENT = { 0, 0, 0, 0 }
local SHADOW_COLOR = 0xCC000000

local colors = {
    mission = { 0.55, 0.75, 1.00, 1.00 },
    quest = { 1.00, 0.85, 0.40, 1.00 },
    section = { 0.60, 0.60, 0.60, 1.00 },
    step = { 1.00, 1.00, 1.00, 1.00 },
    next = { 0.65, 0.65, 0.65, 1.00 },
    done = { 0.55, 0.85, 0.55, 1.00 },
    tab_active = { 0.30, 0.30, 0.30, 1.00 },
    bg = { 0.00, 0.00, 0.00, 0.00 },
}

local section_labels = {
    mission = '-- MISSIONS --',
    quest = '-- QUESTS --',
}

local kinds = { 'mission', 'quest' }

local function step_text(step)
    if type(step) == 'table' then
        if step.text ~= nil then
            return tostring(step.text)
        end

        return ''
    end

    return tostring(step or '')
end

local function short_name(name)
    name = tostring(name or '')

    if #name <= TAB_NAME_LENGTH then
        return name
    end

    return name:sub(1, TAB_NAME_LENGTH - 3) .. '...'
end

---------------------------------------------------------- flush right

local function text_width(text)
    return (imgui.CalcTextSize(text))
end

local function button_width(label)
    return text_width(label) + FRAME_PADDING_X * 2
end

-- Moves the cursor so that something this wide ends at the right edge.
local function align_right(width)
    imgui.SetCursorPosX(
        math.max(
            WINDOW_PADDING,
            imgui.GetWindowWidth() - width - WINDOW_PADDING
        )
    )
end

-- One line of text flush right, with a shadow.
local function right_text(color, text)
    align_right(text_width(text))

    -- The line is reserved with invisible text and then drawn twice, the
    -- first time as the shadow.
    imgui.PushStyleColor(ImGuiCol_Text, TRANSPARENT)
    local reserved = pcall(imgui.Text, text)
    imgui.PopStyleColor()

    local drawn = reserved and pcall(function()
        local draw = imgui.GetWindowDrawList()
        local x, y = imgui.GetItemRectMin()

        draw:AddText({ x + 1, y + 1 }, SHADOW_COLOR, text)
        draw:AddText({ x, y }, imgui.GetColorU32(color), text)
    end)

    if not drawn then
        imgui.TextColored(color, text)
    end
end

local function text_wrapped(color, text)
    richtext.draw_wrapped(text, {
        styles = styles,
        color = color,
        italic_color = italic_tint,
        size = current_size,
        align = 'right',
        shadow = true,
    })
end

local function group_by_kind(pins)
    local groups = { mission = {}, quest = {} }

    for index, entry in ipairs(pins) do
        local group = groups[entry.kind]

        if group ~= nil then
            group[#group + 1] = index
        end
    end

    return groups
end

-- Draws one pinned item. Only the direction buttons are shown.
local function draw_pin(controller, index, entry)
    local steps = entry.steps or {}
    local total = #steps
    local step = math.max(1, math.min(entry.step or 1, math.max(total, 1)))

    right_text(colors[entry.kind] or colors.quest, entry.name)

    if total == 0 then
        right_text(colors.next, 'No steps available.')
        return
    end

    right_text(colors.next, string.format('Step %d / %d', step, total))

    text_wrapped(colors.step, step_text(steps[step]))

    if steps[step + 1] ~= nil then
        right_text(colors.next, 'Next:')
        text_wrapped(colors.next, step_text(steps[step + 1]))
    end

    align_right(
        button_width('<') + ITEM_SPACING_X + button_width('>')
    )

    if imgui.SmallButton('<##pin_prev_' .. index) then
        controller.PrevPinStep(index)
    end

    imgui.SameLine()

    if imgui.SmallButton('>##pin_next_' .. index) then
        controller.NextPinStep(index)
    end
end

local function draw_stacked(controller, pins)
    local groups = group_by_kind(pins)

    for _, kind in ipairs(kinds) do
        local group = groups[kind]

        if #group > 0 then
            imgui.Separator()
            right_text(colors.section, section_labels[kind])

            for _, index in ipairs(group) do
                draw_pin(controller, index, pins[index])
                imgui.Spacing()
            end
        end
    end
end

local function draw_tabs(controller, pins, active)
    local groups = group_by_kind(pins)

    -- The row of tabs, with a bar between missions and quests.
    local row = {}

    for _, kind in ipairs(kinds) do
        local group = groups[kind]

        if #group > 0 then
            if #row > 0 then
                row[#row + 1] = { separator = true }
            end

            for _, index in ipairs(group) do
                row[#row + 1] = {
                    index = index,
                    label = short_name(pins[index].name),
                }
            end
        end
    end

    local width = 0

    for position, item in ipairs(row) do
        if item.separator then
            width = width + text_width('|')
        else
            width = width + button_width(item.label)
        end

        if position > 1 then
            width = width + ITEM_SPACING_X
        end
    end

    align_right(width)

    for position, item in ipairs(row) do
        if position > 1 then
            imgui.SameLine()
        end

        if item.separator then
            imgui.TextColored(colors.section, '|')
        else
            local is_active = item.index == active

            if is_active then
                imgui.PushStyleColor(ImGuiCol_Button, colors.tab_active)
            end

            if imgui.SmallButton(item.label .. '##pin_tab_' .. item.index) then
                controller.SetPinActive(item.index)
            end

            if is_active then
                imgui.PopStyleColor()
            end
        end
    end

    local entry = pins[active]

    if entry ~= nil then
        imgui.Separator()
        right_text(colors.section, section_labels[entry.kind] or '')

        draw_pin(controller, active, entry)
    end
end

function M.Draw(controller, can_draw)
    if controller == nil
        or controller.GetPinState == nil then
        return
    end

    if can_draw ~= nil and not can_draw() then
        return
    end

    local pin = controller.GetPinState()

    if pin == nil or not pin.visible then
        return
    end

    local pins = controller.GetPins() or {}

    if controller.GetStyles ~= nil then
        styles = controller.GetStyles()
    end

    if restore_window then
        if pin.x ~= nil and pin.y ~= nil then
            imgui.SetNextWindowPos({ pin.x, pin.y })
        end

        restore_window = false
    end

    -- The size set from the Journal scales the text and the width.
    local scale = tonumber(pin.scale) or 1.0

    current_size = TEXT_SIZE * scale

    -- Fixed width, height follows the content.
    imgui.SetNextWindowSize({ WINDOW_WIDTH * scale, 0 })

    -- No background and no border.
    imgui.PushStyleColor(ImGuiCol_WindowBg, colors.bg)
    imgui.PushStyleColor(ImGuiCol_Border, { 0, 0, 0, 0 })

    local open = { true }

    if imgui.Begin(
        'Pinned Tracker###JournalPinned',
        open,
        ImGuiWindowFlags_NoTitleBar
            + ImGuiWindowFlags_NoSavedSettings
            + ImGuiWindowFlags_NoScrollbar
            + ImGuiWindowFlags_NoCollapse
            + ImGuiWindowFlags_NoResize
    ) then
        -- Everything in the window, headers and buttons included, is set
        -- in the text font at the scaled size. Without that font the
        -- window font scale is used instead.
        local regular = richtext.fonts and richtext.fonts.regular
        local pushed_font = false

        if regular ~= nil then
            imgui.PushFont(regular, current_size)
            pushed_font = true
        elseif imgui.SetWindowFontScale ~= nil then
            pcall(imgui.SetWindowFontScale, scale)
        end

        if #pins == 0 then
            right_text(
                colors.next,
                'Nothing pinned. Use "Pin to Tracker" in the Journal.'
            )
        elseif pin.mode == 'tabs' then
            draw_tabs(controller, pins, pin.active)
        else
            draw_stacked(controller, pins)
        end

        imgui.Separator()

        local mode_label = pin.mode == 'tabs' and 'Mode: Tabs' or 'Mode: Stacked'

        align_right(
            button_width(mode_label)
                + ITEM_SPACING_X
                + button_width('Close')
        )

        if imgui.SmallButton(mode_label .. '##pin_mode') then
            controller.TogglePinMode()
        end

        imgui.SameLine()

        if imgui.SmallButton('Close##pin_close') then
            controller.SetPinVisible(false)
        end

        local auto_label = 'Auto step on zone change'
        local label_width, label_height = imgui.CalcTextSize(auto_label)

        align_right(
            (label_height + FRAME_PADDING_Y * 2)
                + INNER_SPACING_X
                + label_width
        )

        local auto = { pin.auto_zone == true }

        if imgui.Checkbox(auto_label .. '##pin_auto', auto) then
            controller.SetPinAutoZone(auto[1])
        end

        if pushed_font then
            imgui.PopFont()
        end

        local x, y = imgui.GetWindowPos()

        if x ~= pin.x or y ~= pin.y then
            controller.SetPinGeometry(x, y)
        end
    end

    imgui.End()
    imgui.PopStyleColor(2)
end

return M
