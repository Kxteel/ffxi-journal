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
-- completed, so the current step is advanced by hand (the < and > buttons,
-- or /journal pin next|prev|reset) or by the zone-change check.
-- Each item has a thumbtack: it unpins the item. The item stays on the list
-- for a few seconds, with an empty thumbtack, so it can be pinned again.
-- The mode and the visibility of the tracker are set in the settings.

local imgui = require('imgui')
local icons = require('icons')
local richtext = require('richtext')
local i18n = require('i18n')

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

-- Opacity of the tracker in the current frame (set from the settings), and
-- the last window reset that was applied.
local current_opacity = 1.0
local last_reset_count = nil

-- The shadow follows the opacity of the text.
local function shadow_color()
    local alpha = math.floor(0xCC * current_opacity + 0.5)

    return alpha * 0x1000000
end

local colors = {
    mission = { 0.55, 0.75, 1.00, 1.00 },
    quest = { 1.00, 0.85, 0.40, 1.00 },
    repeatable = { 0.62, 0.85, 1.00, 1.00 },
    section = { 0.60, 0.60, 0.60, 1.00 },
    step = { 1.00, 1.00, 1.00, 1.00 },
    next = { 0.65, 0.65, 0.65, 1.00 },
    done = { 0.55, 0.85, 0.55, 1.00 },
    ghost = { 0.55, 0.55, 0.55, 1.00 },
    pin_icon = { 0.90, 0.90, 0.90, 1.00 },
    tab_active = { 0.30, 0.30, 0.30, 1.00 },
    bg = { 0.00, 0.00, 0.00, 0.00 },

    -- The < and > step buttons: translucent gray.
    step_button = { 0.55, 0.55, 0.55, 0.35 },
    step_button_hovered = { 0.65, 0.65, 0.65, 0.50 },
    step_button_active = { 0.75, 0.75, 0.75, 0.65 },
}

local section_labels = {
    mission = '-- MISSIONS --',
    quest = '-- QUESTS --',
}

local kinds = { 'mission', 'quest' }

-- Items just unpinned from the tracker. They stay a few seconds, so the
-- thumbtack can pin them again. Each one: kind, id, name, steps, time.
local GHOST_SECONDS = 20
local ghosts = {}

-- What the thumbtacks asked for during this frame. It is done when the frame
-- has been drawn, so the list of pins does not change while it is drawn.
local pending_unpin = nil
local pending_repin = nil

local function step_text(step)
    if type(step) == 'table' then
        if step.text ~= nil then
            return i18n.step(tostring(step.text))
        end

        return ''
    end

    return i18n.step(tostring(step or ''))
end

local function short_name(name)
    name = string.upper(tostring(name or ''))

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

-- One line of text flush right, with a shadow. With icon_color, an infinity
-- sign follows the text (the repeatable quests).
local function right_text(color, text, icon_color, lead)
    local line_height = imgui.GetTextLineHeight()
    local icon_width, icon_height = 0, 0
    local icon_gap = 0
    -- A small icon of the quest before the name (a texture of worldmark.lua).
    local lead_width = 0

    if icon_color ~= nil then
        icon_width, icon_height = icons.infinity_size(line_height)
        icon_gap = 8
    end

    if lead ~= nil and imgui.Dummy and imgui.SameLine then
        lead_width = line_height * lead.width / lead.height
    end

    align_right(
        text_width(text) + icon_gap + icon_width
            + (lead_width > 0 and lead_width + 4 or 0)
    )

    if lead_width > 0 then
        if pcall(imgui.Dummy, { lead_width, line_height }) then
            pcall(function()
                local min_x, min_y = imgui.GetItemRectMin()
                local max_x, max_y = imgui.GetItemRectMax()

                imgui.GetWindowDrawList():AddImage(
                    lead.id,
                    { min_x, min_y },
                    { max_x, max_y },
                    { 0, 0 },
                    { 1, 1 },
                    imgui.GetColorU32({ 1, 1, 1, 1 })
                )
            end)

            imgui.SameLine(0, 4)
        end
    end

    -- The line is reserved with invisible text and then drawn twice, the
    -- first time as the shadow.
    imgui.PushStyleColor(ImGuiCol_Text, TRANSPARENT)
    local reserved = pcall(imgui.Text, text)
    imgui.PopStyleColor()

    local drawn = reserved and pcall(function()
        local draw = imgui.GetWindowDrawList()
        local x, y = imgui.GetItemRectMin()

        draw:AddText({ x + 1, y + 1 }, shadow_color(), text)
        draw:AddText({ x, y }, imgui.GetColorU32(color), text)

        if icon_color ~= nil then
            local icon_x = x + text_width(text) + icon_gap
            local icon_y = y + (line_height - icon_height) * 0.5

            icons.draw_infinity(
                draw,
                icon_x + 1,
                icon_y + 1,
                icon_width,
                icon_height,
                shadow_color(),
                1.6
            )

            icons.draw_infinity(
                draw,
                icon_x,
                icon_y,
                icon_width,
                icon_height,
                imgui.GetColorU32(icon_color),
                1.6
            )
        end
    end)

    if not drawn then
        imgui.TextColored(color, text)
    end
end

-- The click on an NPC name goes to the controller (set while drawing).
local click_npc = nil

local function text_wrapped(color, text, id, items)
    richtext.draw_wrapped(text, {
        styles = styles,
        items = items,
        color = color,
        italic_color = italic_tint,
        size = current_size,
        align = 'right',
        shadow = true,
        on_npc = click_npc and function(name)
            click_npc(name, text)
        end or nil,
        id = id,
        npc_tooltip = i18n.t('Click to point the compass at it'),
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
-- One of the < and > buttons: small, in translucent gray.
local function step_button(label)
    imgui.PushStyleColor(ImGuiCol_Button, colors.step_button)
    imgui.PushStyleColor(ImGuiCol_ButtonHovered, colors.step_button_hovered)
    imgui.PushStyleColor(ImGuiCol_ButtonActive, colors.step_button_active)

    local clicked = imgui.SmallButton(label)

    imgui.PopStyleColor(3)

    return clicked
end

-- The thumbtack button: as wide as the < and > buttons. filled is a pinned
-- item, an empty thumbtack is an item that was just unpinned.
local function pin_button(id, filled, tooltip)
    local width = button_width('>')
    local height = imgui.GetTextLineHeight()

    imgui.PushStyleColor(ImGuiCol_Button, colors.step_button)
    imgui.PushStyleColor(ImGuiCol_ButtonHovered, colors.step_button_hovered)
    imgui.PushStyleColor(ImGuiCol_ButtonActive, colors.step_button_active)

    local clicked = imgui.Button('##' .. id, { width, height })

    imgui.PopStyleColor(3)

    local min_x, min_y = imgui.GetItemRectMin()
    local max_x, max_y = imgui.GetItemRectMax()
    local size = math.min(max_x - min_x, max_y - min_y) * 0.92

    icons.draw_pin(
        imgui.GetWindowDrawList(),
        min_x + ((max_x - min_x) - size) * 0.5,
        min_y + ((max_y - min_y) - size) * 0.5,
        size,
        imgui.GetColorU32(filled and colors.pin_icon or colors.ghost),
        filled
    )

    if imgui.IsItemHovered() and imgui.SetTooltip then
        imgui.SetTooltip(i18n.t(tooltip))
    end

    return clicked
end

-- An item that was just unpinned: its name, dimmed, and an empty thumbtack.
local function draw_ghost(controller, position)
    local ghost = ghosts[position]

    right_text(
        colors.ghost,
        string.upper(ghost.name),
        ghost.repeatable == true and colors.ghost or nil
    )

    align_right(button_width('>'))

    if pin_button('pin_again_' .. position, false, 'Pin to Tracker') then
        pending_repin = position
    end

    imgui.Spacing()
end

local function draw_ghosts_of(controller, kind)
    for position, ghost in ipairs(ghosts) do
        if ghost.kind == kind then
            draw_ghost(controller, position)
        end
    end
end

local function has_ghosts_of(kind)
    for _, ghost in ipairs(ghosts) do
        if ghost.kind == kind then
            return true
        end
    end

    return false
end

local function draw_pin(controller, index, entry)
    local steps = entry.steps or {}
    local total = #steps
    local step = math.max(1, math.min(entry.step or 1, math.max(total, 1)))

    -- The icon of a quest before its name.
    local lead = nil

    if entry.id ~= nil
        and controller.worldmark ~= nil
        and controller.worldmark.GetIcon ~= nil then

        local kind = nil

        if entry.kind == 'quest' and controller.GetQuestIconKind ~= nil then
            kind = controller.GetQuestIconKind(entry.id)
        elseif entry.kind == 'mission'
            and controller.GetMissionIconKind ~= nil then

            kind = controller.GetMissionIconKind(entry.id, entry.name)
        end

        lead = kind ~= nil and controller.worldmark.GetIcon(kind) or nil
    end

    right_text(
        colors[entry.kind] or colors.quest,
        string.upper(tostring(entry.name or '')),
        entry.repeatable == true and colors.repeatable or nil,
        lead
    )

    -- A click on the name of a quest opens its sheet.
    if entry.kind == 'quest'
        and entry.id ~= nil
        and controller.OpenQuestSheet ~= nil then

        if imgui.IsItemHovered() then
            if imgui.SetTooltip then
                imgui.SetTooltip(i18n.t('Opens the quest sheet'))
            end

            if imgui.IsItemClicked() then
                controller.OpenQuestSheet(entry.id)
            end
        end
    end

    if total == 0 then
        right_text(colors.next, i18n.t('No steps available.'))
        return
    end

    right_text(colors.next, string.format(i18n.t('Step %d / %d'), step, total))

    text_wrapped(colors.step, step_text(steps[step]), 'p' .. index .. 's', true)

    -- The next step is shown unless the Journal switched it off.
    local show_next =
        controller.GetPinShowNext == nil
        or controller.GetPinShowNext()

    if show_next and steps[step + 1] ~= nil then
        right_text(colors.next, i18n.t('Next:'))
        text_wrapped(colors.next, step_text(steps[step + 1]), 'p' .. index .. 'n', true)
    end

    align_right(
        button_width('<') + ITEM_SPACING_X
            + button_width('>') + ITEM_SPACING_X
            + button_width('>')
    )

    if step_button('<##pin_prev_' .. index) then
        controller.PrevPinStep(index)
    end

    imgui.SameLine()

    if step_button('>##pin_next_' .. index) then
        controller.NextPinStep(index)
    end

    imgui.SameLine()

    if pin_button('pin_toggle_' .. index, true, 'Unpin from Tracker') then
        pending_unpin = index
    end
end

local function draw_stacked(controller, pins)
    local groups = group_by_kind(pins)

    for _, kind in ipairs(kinds) do
        local group = groups[kind]

        if #group > 0 or has_ghosts_of(kind) then
            imgui.Separator()
            right_text(colors.section, i18n.t(section_labels[kind]))

            for _, index in ipairs(group) do
                draw_pin(controller, index, pins[index])
                imgui.Spacing()
            end

            draw_ghosts_of(controller, kind)
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
        right_text(colors.section, i18n.t(section_labels[entry.kind] or ''))

        draw_pin(controller, active, entry)
    end

    if #ghosts > 0 then
        imgui.Separator()

        for position = 1, #ghosts do
            draw_ghost(controller, position)
        end
    end
end

-- Does what the thumbtacks asked for in this frame.
local function apply_pending(controller, pins)
    local unpin = pending_unpin
    local repin = pending_repin

    pending_unpin = nil
    pending_repin = nil

    if unpin ~= nil and pins[unpin] ~= nil then
        local entry = pins[unpin]

        ghosts[#ghosts + 1] = {
            kind = entry.kind,
            id = entry.id,
            name = entry.name,
            steps = entry.steps,
            repeatable = entry.repeatable,
            time = os.time(),
        }

        controller.RemovePin(unpin)
    end

    if repin ~= nil and ghosts[repin] ~= nil then
        local ghost = ghosts[repin]

        table.remove(ghosts, repin)

        controller.ToggleItemPin(
            ghost.kind,
            { id = ghost.id, name = ghost.name, steps = ghost.steps }
        )
    end
end

-- Forgets the items unpinned a while ago, and the ones that are pinned
-- again (from the Journal, for example).
local function prune_ghosts(pins)
    local now = os.time()
    local position = 1

    while position <= #ghosts do
        local ghost = ghosts[position]
        local keep = (now - ghost.time) <= GHOST_SECONDS

        for _, entry in ipairs(pins) do
            if entry.kind == ghost.kind
                and entry.id == ghost.id
                and entry.name == ghost.name then

                keep = false
                break
            end
        end

        if keep then
            position = position + 1
        else
            table.remove(ghosts, position)
        end
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

    prune_ghosts(pins)

    if controller.GetStyles ~= nil then
        styles = controller.GetStyles()
    end

    -- Clicking an NPC name points the compass at it.
    click_npc = controller.AddCompassNpcByName

    -- "Reset window positions" in the settings.
    if last_reset_count == nil then
        last_reset_count = pin.reset_count
    elseif pin.reset_count ~= last_reset_count then
        last_reset_count = pin.reset_count
        restore_window = true
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

    -- Opacity of the text and the background set in the settings. The
    -- background is transparent by default, and there is no border.
    current_opacity = tonumber(pin.opacity) or 1.0

    local alpha_pushed = false

    if ImGuiStyleVar_Alpha ~= nil then
        imgui.PushStyleVar(ImGuiStyleVar_Alpha, current_opacity)
        alpha_pushed = true
    end

    imgui.PushStyleColor(
        ImGuiCol_WindowBg,
        { 0, 0, 0, tonumber(pin.background) or 0 }
    )
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

        if #pins == 0 and #ghosts == 0 then
            right_text(
                colors.next,
                i18n.t('Nothing pinned. Use "Pin to Tracker" in the Journal.')
            )
        elseif pin.mode == 'tabs' then
            draw_tabs(controller, pins, pin.active)
        else
            draw_stacked(controller, pins)
        end

        apply_pending(controller, pins)

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

    if alpha_pushed then
        imgui.PopStyleVar(1)
    end
end

return M
