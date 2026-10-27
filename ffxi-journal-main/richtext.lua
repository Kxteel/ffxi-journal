-- Styled place names in step text.
--
--   bold    : zones of the game (names read from the game resources)
--   italic  : other places such as rooms and buildings (data/places.lua)
--   olive   : characters and NPCs (data/npcs.lua), same font, new color
--   red     : monsters (data/monsters.lua), same font, light red
--   yellow  : objects and items (data/items.lua), same font, soft yellow
--
-- The text fonts (Fira Sans Regular, Bold and Italic) are loaded by ui.lua
-- and handed over with set_fonts. A bold or italic font is wider or
-- narrower than the regular one, so every piece of a line is measured
-- with its own font before wrapping.
--
-- If a font is missing there is a fallback: bold is faked by drawing the
-- name a second time one pixel to the right, and italic becomes a tinted
-- color.
--
-- The first half of this file is pure (find the names, wrap the text) so
-- it can be tested outside the game. The second half draws.

local M = {}

local BOLD_OFFSET = 1.0

local function is_word_char(ch)
    return ch ~= '' and ch:match('%w') ~= nil
end

-- Lowercased copy of the text without apostrophes, with [S] written as
-- (S) and whitespace collapsed (the same rules zonematch uses), plus a
-- map from each position back to the original text.
local function normalize_with_map(text)
    local out = {}
    local map = {}
    local n = 0
    local last_space = false
    local i = 1
    local length = #text

    while i <= length do
        local c = text:sub(i, i)
        local skip = 0

        if c == "'" or c == '`' then
            skip = 1
        elseif c == '\226' and text:sub(i, i + 2) == '\226\128\153' then
            skip = 3
        end

        if skip > 0 then
            i = i + skip
        else
            if c == '[' then
                c = '('
            elseif c == ']' then
                c = ')'
            end

            if c:match('%s') then
                if not last_space and n > 0 then
                    n = n + 1
                    out[n] = ' '
                    map[n] = i
                end

                last_space = true
            else
                n = n + 1
                out[n] = c:lower()
                map[n] = i
                last_space = false
            end

            i = i + 1
        end
    end

    return table.concat(out), map
end

-- Names from index found in the text, as { s = first, e = last } in the
-- original text. Where two names start at the same place the longer one
-- wins, so "Windurst Waters (S)" is not cut down to "Windurst Waters".
function M.spans(text, index)
    text = tostring(text or '')

    if text == '' or index == nil or #index == 0 then
        return {}
    end

    local haystack, map = normalize_with_map(text)
    local found = {}

    for _, zone in ipairs(index) do
        local from = 1

        while true do
            local s, e = haystack:find(zone.name, from, true)

            if s == nil then
                break
            end

            local before = s > 1 and haystack:sub(s - 1, s - 1) or ''
            local after = haystack:sub(e + 1, e + 1)

            -- Names start with a capital letter in the text, so an
            -- ordinary word is never taken for one.
            local first = text:sub(map[s], map[s])

            if not is_word_char(before)
                and not is_word_char(after)
                and first:match('%u') ~= nil then

                found[#found + 1] = { s = s, e = e, length = e - s + 1 }
            end

            from = s + 1
        end
    end

    table.sort(found, function(a, b)
        if a.s ~= b.s then
            return a.s < b.s
        end

        return a.length > b.length
    end)

    local result = {}
    local last_end = 0

    for _, item in ipairs(found) do
        if item.s > last_end then
            result[#result + 1] = { s = map[item.s], e = map[item.e] }
            last_end = item.e
        end
    end

    return result
end

-- All styled ranges in the text. styles is a list in priority order,
-- each { index = <name index>, kind = 'bold' | 'italic' | 'monster' |
-- 'npc' | 'item' }. Where two names overlap the one that starts first
-- wins, then the longer one, then the one earlier in the list, so
-- "Cid's Lab" (a place) beats "Cid" (a person) and "Cipher: Balamor" (an
-- item) beats "Balamor" (a monster).
function M.marks(text, styles)
    local candidates = {}

    for priority, style in ipairs(styles or {}) do
        for _, span in ipairs(M.spans(text, style.index)) do
            candidates[#candidates + 1] = {
                s = span.s,
                e = span.e,
                kind = style.kind,
                length = span.e - span.s + 1,
                priority = priority,
            }
        end
    end

    table.sort(candidates, function(a, b)
        if a.s ~= b.s then
            return a.s < b.s
        end

        if a.length ~= b.length then
            return a.length > b.length
        end

        return a.priority < b.priority
    end)

    local marks = {}
    local last_end = 0

    for _, item in ipairs(candidates) do
        if item.s > last_end then
            marks[#marks + 1] = { s = item.s, e = item.e, kind = item.kind }
            last_end = item.e
        end
    end

    return marks
end

-- Splits the text into words, each with the styled ranges inside it
-- (positions relative to the word).
function M.words(text, styles)
    text = tostring(text or '')

    local marks = M.marks(text, styles)
    local words = {}
    local position = 1

    while true do
        local s, e = text:find('%S+', position)

        if s == nil then
            break
        end

        local word = { text = text:sub(s, e), marks = {} }

        for _, mark in ipairs(marks) do
            local from = math.max(s, mark.s)
            local to = math.min(e, mark.e)

            if from <= to then
                word.marks[#word.marks + 1] = {
                    s = from - s + 1,
                    e = to - s + 1,
                    kind = mark.kind,
                }
            end
        end

        words[#words + 1] = word
        position = e + 1
    end

    return words
end

function M.has_marks(words)
    for _, word in ipairs(words) do
        if #word.marks > 0 then
            return true
        end
    end

    return false
end

-- Wraps the words into lines no wider than max_width. measure(text,
-- marks) returns the width of a line with those styled ranges. Every line
-- is { text = '...', marks = { ... } } with positions relative to the
-- line text. Neighbouring words of the same style are joined into one
-- range, covering the space between them.
local function copy_marks(marks)
    local result = {}

    for index, mark in ipairs(marks) do
        result[index] = { s = mark.s, e = mark.e, kind = mark.kind }
    end

    return result
end

local function extend_line(line, word)
    local shift = #line.text + 1
    local marks = copy_marks(line.marks)

    for _, mark in ipairs(word.marks) do
        local last = marks[#marks]
        local s = mark.s + shift
        local e = mark.e + shift

        if last ~= nil
            and last.kind == mark.kind
            and last.e + 1 == s - 1 then

            last.e = e
        else
            marks[#marks + 1] = { s = s, e = e, kind = mark.kind }
        end
    end

    return { text = line.text .. ' ' .. word.text, marks = marks }
end

local function start_line(word)
    return { text = word.text, marks = copy_marks(word.marks) }
end

function M.layout(words, max_width, measure)
    local lines = {}
    local current = nil

    for _, word in ipairs(words) do
        local added = false

        if current ~= nil then
            local candidate = extend_line(current, word)

            if measure(candidate.text, candidate.marks) <= max_width then
                current = candidate
                added = true
            end
        end

        if not added then
            if current ~= nil then
                lines[#lines + 1] = current
            end

            current = start_line(word)
        end
    end

    if current ~= nil then
        lines[#lines + 1] = current
    end

    if #lines == 0 then
        lines[1] = { text = '', marks = {} }
    end

    return lines
end

-- The line cut into consecutive pieces, each with a kind ('bold',
-- 'italic' or nil for plain text), so every piece can be drawn in its
-- own style.
function M.segments(line)
    local segments = {}
    local position = 1

    local function push(s, e, kind)
        if s <= e then
            segments[#segments + 1] = {
                s = s,
                e = e,
                kind = kind,
                text = line.text:sub(s, e),
            }
        end
    end

    for _, mark in ipairs(line.marks) do
        push(position, mark.s - 1, nil)
        push(mark.s, mark.e, mark.kind)
        position = mark.e + 1
    end

    push(position, #line.text, nil)

    return segments
end

-- Pieces of a line with the width of each and the offset where it
-- starts. measure_kind(text, kind) measures one piece in its own font.
function M.positions(line, measure_kind)
    local result = {}
    local x = 0

    for _, segment in ipairs(M.segments(line)) do
        local width = measure_kind(segment.text, segment.kind)

        result[#result + 1] = {
            text = segment.text,
            kind = segment.kind,
            x = x,
            width = width,
        }

        x = x + width
    end

    return result, x
end

function M.styled_width(text, marks, measure_kind)
    local _, total = M.positions({ text = text, marks = marks }, measure_kind)

    return total
end

function M.line_has_kind(line, kind)
    for _, mark in ipairs(line.marks) do
        if mark.kind == kind then
            return true
        end
    end

    return false
end

M.BOLD_OFFSET = BOLD_OFFSET

-- Colors of the styles that only change color: olive green for
-- characters and NPCs, light red for monsters, soft yellow for objects
-- and items (r, g, b, a).
M.COLORS = {
    npc = { 0.64, 0.75, 0.26, 1.0 },
    monster = { 1.00, 0.55, 0.55, 1.0 },
    item = { 0.96, 0.88, 0.52, 1.0 },
}

-- { r, g, b, a } as the packed 0xAABBGGRR number the draw list wants.
function M.color_u32(color)
    local function byte(value)
        return math.max(0, math.min(255, math.floor(value * 255 + 0.5)))
    end

    return byte(color[4] or 1) * 0x1000000
        + byte(color[3]) * 0x10000
        + byte(color[2]) * 0x100
        + byte(color[1])
end

---------------------------------------------------------------- fonts

M.fonts = {}

-- fonts = { regular = <font>, bold = <font>, italic = <font> }. Any of
-- them may be missing.
function M.set_fonts(fonts)
    M.fonts = fonts or {}
end

function M.font_for(kind)
    local fonts = M.fonts

    if kind == 'bold' then
        return fonts.bold or fonts.regular
    elseif kind == 'italic' then
        return fonts.italic or fonts.regular
    end

    return fonts.regular
end

-- true when this kind has to be faked because its font is missing
function M.fake_bold(kind)
    return kind == 'bold' and M.fonts.bold == nil
end

function M.tint_italic(kind)
    return kind == 'italic' and M.fonts.italic == nil
end

---------------------------------------------------------------- drawing

local cache = { styles = nil, words = {}, count = 0, lines = {}, line_count = 0 }

local function reset_cache(styles)
    cache = {
        styles = styles,
        words = {},
        count = 0,
        lines = {},
        line_count = 0,
    }
end

local function cached_words(text, styles)
    if cache.styles ~= styles then
        reset_cache(styles)
    end

    local words = cache.words[text]

    if words == nil then
        if cache.count > 400 then
            reset_cache(styles)
        end

        words = M.words(text, styles)
        cache.words[text] = words
        cache.count = cache.count + 1
    end

    return words
end

local TRANSPARENT = { 0, 0, 0, 0 }
local WHITE = { 1, 1, 1, 1 }

-- Drop shadow for windows without a background (0xAABBGGRR).
local SHADOW_OFFSET = 1.0
local SHADOW_COLOR = 0xCC000000

-- Draws wrapped text. Without any styled name in the text this is just
-- TextWrapped in the regular text font.
--
-- opts.styles        list for M.marks (zones, places, monsters, NPCs, items)
-- opts.align         'right' to set the text flush right
-- opts.shadow        true to draw a drop shadow (for transparent windows)
-- opts.color         { r, g, b, a } for the text
-- opts.size          font size
-- opts.italic_color  tint used when there is no italic font
function M.draw_wrapped(text, opts)
    local imgui = require('imgui')

    opts = opts or {}
    text = tostring(text or '')

    local size = opts.size or 16
    local regular = M.fonts.regular
    local right = opts.align == 'right'
    local shadow = opts.shadow == true
    local available = 0

    if regular ~= nil then
        imgui.PushFont(regular, size)
    end

    if opts.color ~= nil then
        imgui.PushStyleColor(ImGuiCol_Text, opts.color)
    end

    -- Width of a piece in its own font. The "|" avoids depending on how
    -- trailing spaces are measured.
    local function measure_kind(value, kind)
        local font = M.font_for(kind)

        if font ~= nil then
            imgui.PushFont(font, size)
        end

        local width = (imgui.CalcTextSize(value .. '|'))
            - (imgui.CalcTextSize('|'))

        if font ~= nil then
            imgui.PopFont()
        end

        return width
    end

    local lines
    local ok = pcall(function()
        local words = cached_words(text, opts.styles)

        -- Right-aligned text always needs its own layout.
        if not right and not M.has_marks(words) then
            return
        end

        local width = (imgui.GetContentRegionAvail())

        available = width

        local usable = math.max(40, width - 6)
        local key = text .. '\0' .. math.floor(usable) .. '\0' .. size

        lines = cache.lines[key]

        if lines == nil then
            lines = M.layout(words, usable, function(value, marks)
                return M.styled_width(value, marks, measure_kind)
            end)

            if cache.line_count > 400 then
                cache.lines = {}
                cache.line_count = 0
            end

            cache.lines[key] = lines
            cache.line_count = cache.line_count + 1
        end
    end)

    if not ok or lines == nil then
        imgui.TextWrapped(text)
    else
        for _, line in ipairs(lines) do
            if #line.marks == 0 and not right and not shadow then
                imgui.Text(line.text)
            else
                -- The line is reserved with invisible text and then
                -- drawn piece by piece, each in its own font.
                imgui.PushStyleColor(ImGuiCol_Text, TRANSPARENT)
                imgui.Text(line.text)
                imgui.PopStyleColor()

                pcall(function()
                    local draw = imgui.GetWindowDrawList()
                    local min_x, min_y = imgui.GetItemRectMin()
                    local col = imgui.GetColorU32(opts.color or WHITE)
                    local tint = imgui.GetColorU32(
                        opts.italic_color or opts.color or WHITE
                    )
                    local palette = {}

                    for kind, value in pairs(M.COLORS) do
                        palette[kind] = imgui.GetColorU32(value)
                    end

                    local pieces, line_width = M.positions(line, measure_kind)
                    local shift = 0

                    if right then
                        shift = math.max(0, available - line_width)
                    end

                    local function put(piece, offset_x, offset_y, color)
                        local font = M.font_for(piece.kind)
                        local pos = {
                            min_x + shift + piece.x + offset_x,
                            min_y + offset_y,
                        }

                        if font ~= nil then
                            draw:AddText(font, size, pos, color, piece.text)
                        else
                            draw:AddText(pos, color, piece.text)
                        end
                    end

                    -- Shadows first, so no shadow lands on a neighbour.
                    if shadow then
                        for _, piece in ipairs(pieces) do
                            put(piece, SHADOW_OFFSET, SHADOW_OFFSET, SHADOW_COLOR)
                        end
                    end

                    for _, piece in ipairs(pieces) do
                        local color = col

                        if M.tint_italic(piece.kind) then
                            color = tint
                        elseif palette[piece.kind] ~= nil then
                            color = palette[piece.kind]
                        end

                        put(piece, 0, 0, color)

                        if M.fake_bold(piece.kind) then
                            put(piece, BOLD_OFFSET, 0, color)
                        end
                    end
                end)
            end
        end
    end

    if opts.color ~= nil then
        imgui.PopStyleColor()
    end

    if regular ~= nil then
        imgui.PopFont()
    end
end

return M
