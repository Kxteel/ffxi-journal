-- Alerts of a new quest or mission, and of a completed one.
--
-- When the game gives the player a new quest or mission, a banner fades in
-- at the center of the screen ("New Quest!" or "New Mission!"), a sound
-- plays, and the banner asks if the item should be pinned to the Tracker.
-- When one is completed the banner says "Quest Completed" or "Mission
-- Completed", with a green check mark drawn beside it. A banner goes away by
-- itself after a few seconds; with no answer the item is not pinned.
--
-- logic.lua finds the items and queues them (TakeAnnouncement); this file
-- only draws the banner and plays the sound. The look (background opacity,
-- text size and color) is set in the settings window, one look for the new
-- items and one for the completed ones, and the settings window can keep a
-- banner on the screen to try it (GetAlertTest).
--
-- Sounds (optional, the player puts them there):
--   assets/sounds/new_quest.wav       assets/sounds/new_mission.wav
--   assets/sounds/complete_quest.wav  assets/sounds/complete_mission.wav
--   assets/sounds/nearby_quest.wav    (quests not active in the new zone)

local imgui = require('imgui')
local richtext = require('richtext')
local icons = require('icons')
local i18n = require('i18n')

local M = {}

local tx = i18n.t

-- Sizes are for a 1080 px tall screen, and grow or shrink with the screen.
local WIDTH = 640
local HEIGHT_PLAIN = 150
local HEIGHT_ASK = 200
local TITLE_SIZE = 50
local NAME_SIZE = 24
local TEXT_SIZE = 18
local SLIDE = 26

-- Seconds.
local FADE_IN = 0.45
local FADE_OUT = 0.60
local HOLD = 3.4
-- The banner of the quests in progress stays this much longer.
local PROGRESS_EXTRA = 3
local ASK_TIMEOUT = 14
local ANSWER_HOLD = 0.9

-- Where the center of the banner is, as a share of the screen height.
local CENTER_Y = 0.38

local TRANSPARENT = { 0, 0, 0, 0 }

local colors = {
    quest = { 1.00, 0.85, 0.40, 1.00 },
    mission = { 0.55, 0.75, 1.00, 1.00 },
    name = { 1.00, 1.00, 1.00, 1.00 },
    text = { 0.82, 0.84, 0.90, 1.00 },
    dim = { 0.62, 0.64, 0.72, 1.00 },
    done = { 0.55, 0.85, 0.55, 1.00 },
    completed = { 0.50, 0.92, 0.55, 1.00 },
    near = { 0.45, 0.88, 0.90, 1.00 },
    check = { 0.35, 0.85, 0.45, 1.00 },
    panel = { 0.045, 0.055, 0.110 },
}

local current = nil
local screen_warned = false
local missing_sound = {}

-- Time in seconds. ImGui's clock when the binding has it.
local function now()
    if imgui.GetTime ~= nil then
        local ok, value = pcall(imgui.GetTime)

        if ok and type(value) == 'number' then
            return value
        end
    end

    return os.clock()
end

local function ease_out(t)
    t = math.min(1, math.max(0, t))

    return 1 - (1 - t) ^ 3
end

local function read_size(value)
    if value == nil then
        return nil
    end

    local ok, x, y = pcall(function()
        return value.x or value[1], value.y or value[2]
    end)

    if ok and type(x) == 'number' and type(y) == 'number'
        and x > 0 and y > 0 then

        return x, y
    end

    return nil
end

-- Size of the screen, or nil when the binding does not tell it.
local function screen_size()
    if imgui.GetIO ~= nil then
        local ok, io = pcall(imgui.GetIO)

        if ok and io ~= nil then
            local ok_size, size = pcall(function()
                return io.DisplaySize
            end)

            if ok_size then
                local w, h = read_size(size)

                if w ~= nil then
                    return w, h
                end
            end
        end
    end

    if imgui.GetMainViewport ~= nil then
        local ok, viewport = pcall(imgui.GetMainViewport)

        if ok and viewport ~= nil then
            local ok_size, size = pcall(function()
                return viewport.Size
            end)

            if ok_size then
                local w, h = read_size(size)

                if w ~= nil then
                    return w, h
                end
            end
        end
    end

    return nil
end

local function play_sound(entry)
    if ashita == nil or ashita.misc == nil
        or ashita.misc.play_sound == nil then

        return
    end

    local file = (entry.done and 'complete_' or 'new_')
        .. (entry.kind == 'mission' and 'mission' or 'quest')
        .. '.wav'

    if entry.near then
        file = 'nearby_quest.wav'
    end

    local base = tostring(addon and addon.path or '')

    if base ~= '' and not base:match('[\\/]$') then
        base = base .. '/'
    end

    local path = base .. 'assets/sounds/' .. file

    if ashita.fs ~= nil and ashita.fs.exists(path) then
        pcall(ashita.misc.play_sound, path)

        return
    end

    if not missing_sound[file] then
        missing_sound[file] = true

        print(string.format(
            tx('[Journal] Alert sound not found: assets/sounds/%s'),
            file
        ))
    end
end

-- The text sizes are baked into the font, so any size is pushed with it.
local function sized(font, size, draw_fn)
    if font ~= nil then
        imgui.PushFont(font, size)
        draw_fn()
        imgui.PopFont()
    elseif imgui.SetWindowFontScale ~= nil then
        imgui.SetWindowFontScale(size / 16)
        draw_fn()
        imgui.SetWindowFontScale(1)
    else
        draw_fn()
    end
end

-- One line of text centered in the window, with a shadow. alpha follows the
-- fade, because the shadow is drawn with a plain color.
local function centered_text(font, size, color, text, width, alpha, offset)
    sized(font, size, function()
        local w = (imgui.CalcTextSize(text))

        imgui.SetCursorPosX(math.max(0, (width - w) * 0.5 + (offset or 0)))

        imgui.PushStyleColor(ImGuiCol_Text, TRANSPARENT)
        local reserved = pcall(imgui.Text, text)
        imgui.PopStyleColor()

        local drawn = reserved and pcall(function()
            local draw = imgui.GetWindowDrawList()
            local x, y = imgui.GetItemRectMin()
            local shadow = math.floor(0xCC * alpha + 0.5) * 0x1000000

            draw:AddText({ x + 2, y + 2 }, shadow, text)
            draw:AddText({ x, y }, imgui.GetColorU32(color), text)
        end)

        if not drawn then
            imgui.TextColored(color, text)
        end
    end)
end

-- A name that does not fit is cut and ends in "...".
local function fit_text(font, size, text, max_width)
    local result = text

    sized(font, size, function()
        while #result > 4 and (imgui.CalcTextSize(result)) > max_width do
            result = result:sub(1, #result - 4) .. '...'
        end
    end)

    return result
end

-- The "Pin" button (a pin icon and the word): small and gray, and the only one. It is an
-- invisible button with its own drawing, so its height can be half of a
-- normal button without the frame padding cutting the text. The banner leaves
-- by itself when nobody answers (ASK_TIMEOUT).
local function draw_buttons(controller, scale, width, t, alpha)
    local pin_label = tx('Pin')
    local text_w, text_h = imgui.CalcTextSize(pin_label)
    local button_h = 16 * scale
    local pin_size = button_h * 0.72
    local pin_gap = 4 * scale
    local button_w = pin_size + pin_gap + text_w + 14 * scale

    text_h = text_h or button_h

    imgui.SetCursorPosX(math.max(0, (width - button_w) * 0.5))

    local clicked = imgui.InvisibleButton(
        '##alert_pin', { button_w, button_h }
    )
    local hovered = imgui.IsItemHovered()
    local min_x, min_y = imgui.GetItemRectMin()
    local max_x, max_y = imgui.GetItemRectMax()
    local draw = imgui.GetWindowDrawList()
    local shade = hovered and 0.50 or 0.40

    draw:AddRectFilled(
        { min_x, min_y }, { max_x, max_y },
        imgui.GetColorU32({ shade, shade + 0.01, shade + 0.04, alpha }),
        3
    )
    draw:AddRect(
        { min_x, min_y }, { max_x, max_y },
        imgui.GetColorU32({ 0.62, 0.63, 0.67, 0.70 * alpha }),
        3, 0, 1
    )
    -- The pin icon, then the word, centered together.
    local content_x =
        min_x + (button_w - (pin_size + pin_gap + text_w)) * 0.5
    local ink = imgui.GetColorU32({ 0.93, 0.94, 0.96, alpha })

    icons.draw_pin(
        draw,
        content_x,
        min_y + (button_h - pin_size) * 0.5,
        pin_size,
        ink,
        true
    )

    draw:AddText(
        {
            content_x + pin_size + pin_gap,
            min_y + (button_h - text_h) * 0.5,
        },
        ink,
        pin_label
    )

    if clicked and not current.persistent then
        if controller.AnnouncePin ~= nil then
            controller.AnnouncePin(current.entry)
        end

        current.answer = 'pinned'
        current.leave = t + ANSWER_HOLD
    end
end

-- Starts a banner and plays its sound. token is the one of a test.
local function start_banner(controller, entry, token)
    current = {
        entry = entry,
        start = now(),
        leave = nil,
        answer = nil,
        persistent = token ~= nil,
        token = token,
    }

    -- With no question the banner leaves by itself, but a test stays.
    if not entry.ask and token == nil then
        current.leave = HOLD + (entry.progress and PROGRESS_EXTRA or 0)
    end

    if controller.GetAnnounceSound == nil
        or controller.GetAnnounceSound() then

        play_sound(entry)
    end
end

function M.Draw(controller, can_draw)
    if controller == nil or controller.TakeAnnouncement == nil then
        return
    end

    if can_draw ~= nil and not can_draw() then
        return
    end

    -- An alert tried from the settings window stays until it is stopped.
    local test = controller.GetAlertTest ~= nil
        and controller.GetAlertTest()
        or nil

    if test ~= nil and (current == nil or current.token ~= test.token) then
        if test.near then
            start_banner(controller, {
                kind = 'quest',
                near = true,
                progress = test.progress == true,
                name = tx('Sample Zone'),
                names = { tx('Sample Quest'), tx('Sample Quest') .. ' 2' },
                more = 0,
                ask = false,
            }, test.token)
        else
            start_banner(controller, {
                kind = test.kind,
                done = test.done,
                name = tx(test.kind == 'mission' and 'Sample Mission' or 'Sample Quest'),
                ask = not test.done,
            }, test.token)
        end
    elseif test == nil
        and current ~= nil
        and current.persistent
        and current.leave == nil then

        current.leave = now() - current.start
    end

    if current == nil then
        local entry = controller.TakeAnnouncement()

        if entry == nil then
            return
        end

        start_banner(controller, entry, nil)
    end

    local entry = current.entry
    local t = now() - current.start

    -- No answer in time counts as "No".
    if entry.ask
        and not current.persistent
        and current.leave == nil
        and t >= ASK_TIMEOUT then
        current.leave = t
    end

    if current.leave ~= nil and t >= current.leave + FADE_OUT then
        current = nil

        return
    end

    local alpha = ease_out(t / FADE_IN)

    if current.leave ~= nil and t >= current.leave then
        alpha = math.min(alpha, 1 - (t - current.leave) / FADE_OUT)
    end

    -- Position: the center of the screen. When the size of the screen is
    -- not known the chat says so once.
    local screen_w, screen_h = screen_size()

    if screen_w == nil then
        screen_w, screen_h = 1920, 1080

        if not screen_warned then
            screen_warned = true

            print(tx('[Journal] The size of the screen is unknown: the alert may not be centered.'))
        end
    end

    -- The look set in the settings: one for new items, one for completed.
    local style = controller.GetAlertStyle ~= nil
        and controller.GetAlertStyle(
            entry.near and 'near' or (entry.done and 'done' or 'new')
        )
        or { opacity = 0.70, size = 1.0, color = 0 }

    local scale =
        math.max(0.75, math.min(1.6, screen_h / 1080)) * (style.size or 1.0)
    local width = WIDTH * scale
    local height = (entry.ask and HEIGHT_ASK or HEIGHT_PLAIN) * scale

    -- A "nearby" alert lists the quests, one line each, and a last line.
    local near_lines = 0

    if entry.near then
        near_lines = #(entry.names or {}) + ((entry.more or 0) > 0 and 1 or 0)
        height = (HEIGHT_PLAIN + 36 + near_lines * (NAME_SIZE + 10)) * scale
    end
    local slide = (1 - ease_out(t / FADE_IN)) * SLIDE * scale

    imgui.SetNextWindowSize({ width, height })
    imgui.SetNextWindowPos({
        screen_w * 0.5 - width * 0.5,
        screen_h * CENTER_Y - height * 0.5 + slide,
    })

    local alpha_pushed = false

    if ImGuiStyleVar_Alpha ~= nil then
        imgui.PushStyleVar(ImGuiStyleVar_Alpha, math.max(0.001, alpha))
        alpha_pushed = true
    end

    imgui.PushStyleColor(
        ImGuiCol_WindowBg,
        { colors.panel[1], colors.panel[2], colors.panel[3], style.opacity or 0.70 }
    )
    imgui.PushStyleColor(ImGuiCol_Border, TRANSPARENT)

    -- The color of the title: the one chosen in the palette, or the default
    -- of the alert (gold for quests, blue for missions, green when done).
    local accent = entry.near and colors.near
        or entry.done and colors.completed
        or colors[entry.kind]
        or colors.quest
    local palette = controller.GetAlertPalette ~= nil
        and controller.GetAlertPalette()
        or nil

    if palette ~= nil and (style.color or 0) > 0 and palette[style.color] ~= nil then
        accent = palette[style.color]
    end

    local flags =
        ImGuiWindowFlags_NoTitleBar
        + ImGuiWindowFlags_NoSavedSettings
        + ImGuiWindowFlags_NoScrollbar
        + ImGuiWindowFlags_NoCollapse
        + ImGuiWindowFlags_NoResize
        + (ImGuiWindowFlags_NoMove or 0)

    if imgui.Begin('New Quest Alert###JournalAlert', { true }, flags) then
        local fonts = richtext.fonts or {}
        local regular = fonts.regular
        local bold = fonts.bold or fonts.regular

        imgui.Spacing()

        local title

        if entry.near then
            title = entry.progress and tx('Quest In Progress')
                or tx('Quest Nearby')
        elseif entry.done then
            title = entry.kind == 'mission'
                and tx('Mission Completed')
                or tx('Quest Completed')
        else
            title = entry.kind == 'mission'
                and tx('New Mission!')
                or tx('New Quest!')
        end

        -- A completed item has a green check mark beside the title; the title
        -- moves over so the two stay centered together.
        local check_size = TITLE_SIZE * scale * 0.85
        local check_gap = 14 * scale
        local offset = entry.done and (check_size + check_gap) * 0.5 or 0

        centered_text(bold, TITLE_SIZE * scale, accent, title, width, alpha, offset)

        if entry.done then
            pcall(function()
                local min_x, min_y = imgui.GetItemRectMin()
                local _, max_y = imgui.GetItemRectMax()
                local x = min_x - check_gap - check_size
                local y = min_y + ((max_y - min_y) - check_size) * 0.5
                local draw = imgui.GetWindowDrawList()
                local progress = ease_out(t / (FADE_IN * 2.2))
                local shadow = math.floor(0xCC * alpha + 0.5) * 0x1000000

                icons.draw_check(draw, x + 2, y + 2, check_size, shadow, progress)
                icons.draw_check(
                    draw, x, y, check_size,
                    imgui.GetColorU32(colors.check), progress
                )
            end)
        end

        -- A line under the title that grows from the center.
        pcall(function()
            local window_x = imgui.GetWindowPos()
            local _, item_bottom = imgui.GetItemRectMax()
            local half = width * 0.40 * ease_out(t / (FADE_IN * 1.8))
            local center = window_x + width * 0.5
            local y = item_bottom + 3 * scale

            imgui.GetWindowDrawList():AddLine(
                { center - half, y },
                { center + half, y },
                imgui.GetColorU32(accent),
                2.0
            )
        end)

        imgui.Spacing()

        if entry.near then
            centered_text(
                regular, TEXT_SIZE * scale, colors.dim,
                tx(entry.progress and 'In progress' or 'Not active yet')
                    .. ' - ' .. tostring(entry.name or ''),
                width, alpha
            )

            imgui.Spacing()

            for index, quest_name in ipairs(entry.names or {}) do
                centered_text(
                    regular,
                    NAME_SIZE * scale,
                    colors.name,
                    fit_text(regular, NAME_SIZE * scale, tostring(quest_name), width - 40 * scale),
                    width,
                    alpha
                )

                -- The small icon of the quest, left of its name.
                local icon = controller.worldmark ~= nil
                    and controller.worldmark.GetIcon ~= nil
                    and controller.worldmark.GetIcon(
                        entry.progress and 'progress' or 'available'
                    ) or nil
                local icon_extra = 0

                if icon ~= nil then
                    pcall(function()
                        local min_x, min_y = imgui.GetItemRectMin()
                        local _, max_y = imgui.GetItemRectMax()
                        local icon_w = (max_y - min_y) * icon.width / icon.height

                        imgui.GetWindowDrawList():AddImage(
                            icon.id,
                            { min_x - icon_w - 6, min_y },
                            { min_x - 6, max_y },
                            { 0, 0 },
                            { 1, 1 },
                            imgui.GetColorU32({ 1, 1, 1, alpha })
                        )

                        icon_extra = icon_w + 6
                    end)
                end

                -- The quests open their sheet with a click: a shaded box and a
                -- line under the name show it (green for the ones in progress,
                -- blue for the others).
                local quest_id = entry.ids ~= nil and entry.ids[index] or nil
                local green = entry.progress == true

                if quest_id ~= nil
                    and (controller.OpenQuestSheet ~= nil
                        or controller.OpenQuestFromCompass ~= nil) then

                    local over = imgui.IsItemHovered()

                    pcall(function()
                        local min_x, min_y = imgui.GetItemRectMin()
                        local max_x, max_y = imgui.GetItemRectMax()
                        local draw = imgui.GetWindowDrawList()

                        draw:AddRectFilled(
                            { min_x - 6 - icon_extra, min_y },
                            { max_x + 6, max_y + 1 },
                            imgui.GetColorU32(green and {
                                0.35, 0.85, 0.40, (over and 0.38 or 0.18) * alpha,
                            } or {
                                0.45, 0.65, 1.00, (over and 0.38 or 0.18) * alpha,
                            }),
                            4
                        )
                        draw:AddLine(
                            { min_x - 6 - icon_extra, max_y + 1 },
                            { max_x + 6, max_y + 1 },
                            imgui.GetColorU32(green and {
                                0.55, 0.95, 0.55, (over and 1.00 or 0.60) * alpha,
                            } or {
                                0.60, 0.78, 1.00, (over and 1.00 or 0.60) * alpha,
                            }),
                            1
                        )
                    end)

                    if over then
                        if imgui.SetTooltip then
                            imgui.SetTooltip(tx('Opens the quest sheet'))
                        end

                        if imgui.IsItemClicked()
                            and not current.persistent then

                            if controller.OpenQuestSheet ~= nil then
                                controller.OpenQuestSheet(quest_id)
                            else
                                controller.OpenQuestFromCompass(quest_id)
                            end

                            if current.leave == nil or current.leave > t then
                                current.leave = t
                            end
                        end
                    end
                end
            end

            if (entry.more or 0) > 0 then
                centered_text(
                    regular, TEXT_SIZE * scale, colors.dim,
                    string.format(tx('+%d more'), entry.more), width, alpha
                )
            end
        else
            -- A new or completed quest or mission has its icon left of the
            -- name; name and icon are centered together.
            local icon_name

            if entry.kind == 'mission' then
                icon_name = entry.done and 'mission_completed'
                    or 'mission_available'
            else
                icon_name = entry.done and 'completed' or 'available'
            end

            local icon = controller.worldmark ~= nil
                and controller.worldmark.GetIcon ~= nil
                and controller.worldmark.GetIcon(icon_name)
                or nil
            local icon_gap = 8 * scale
            local icon_offset = 0

            if icon ~= nil then
                local line_h = NAME_SIZE * scale * 1.25

                sized(regular, NAME_SIZE * scale, function()
                    local _, h = imgui.CalcTextSize('Ag')

                    line_h = h or line_h
                end)

                icon_offset = (line_h * icon.width / icon.height + icon_gap) * 0.5
            end

            centered_text(
                regular,
                NAME_SIZE * scale,
                colors.name,
                fit_text(regular, NAME_SIZE * scale, tostring(entry.name or ''), width - 80 * scale),
                width,
                alpha,
                icon_offset
            )

            if icon ~= nil then
                pcall(function()
                    local min_x, min_y = imgui.GetItemRectMin()
                    local _, max_y = imgui.GetItemRectMax()
                    local icon_w = (max_y - min_y) * icon.width / icon.height

                    imgui.GetWindowDrawList():AddImage(
                        icon.id,
                        { min_x - icon_w - icon_gap, min_y },
                        { min_x - icon_gap, max_y },
                        { 0, 0 },
                        { 1, 1 },
                        imgui.GetColorU32({ 1, 1, 1, alpha })
                    )
                end)
            end
        end

        imgui.Spacing()

        if current.answer == 'pinned' then
            centered_text(
                regular, TEXT_SIZE * scale, colors.done,
                tx('Pinned to the Tracker'), width, alpha
            )
        elseif entry.ask and current.answer == nil then
            centered_text(
                regular, TEXT_SIZE * scale, colors.text,
                tx('Pin it to the Tracker?'), width, alpha
            )

            imgui.Spacing()

            sized(regular, TEXT_SIZE * scale * 0.62, function()
                draw_buttons(controller, scale, width, t, alpha)
            end)
        elseif entry.note ~= nil then
            centered_text(
                regular, TEXT_SIZE * scale, colors.dim,
                tx(entry.note), width, alpha
            )
        end
    end

    imgui.End()
    imgui.PopStyleColor(2)

    if alpha_pushed then
        imgui.PopStyleVar(1)
    end
end

return M
