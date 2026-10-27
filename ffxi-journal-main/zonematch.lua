-- Zone matching for the pinned step tracker.
--
-- Quest steps are free text. This module finds the destination zone a
-- step refers to ("Travel to East Ronfaure.") and decides whether a step
-- is a plain travel step that completes just by arriving there.
-- Pure functions only, so it can be tested outside the game.

local M = {}

-- A step only counts as "plain travel" when it starts with one of these
-- verbs and asks for nothing else once you arrive.
local travel_verbs = {
    travel = true,
    enter = true,
    go = true,
    proceed = true,
    reach = true,
    head = true,
}

-- If any of these words appear, arriving is not enough to finish the step.
local action_words = {
    'speak', 'talk', 'examine', 'check', 'trade', 'defeat', 'obtain',
    'apply', 'meet', 'receive', 'wait', 'kill', 'fight', 'give', 'use',
    'open', 'click', 'event', 'cutscene', 'and', 'then', 'to complete',
}

function M.normalize(text)
    local s = tostring(text or ''):lower()

    -- Game resources write "[S]"; the quest data writes "(S)".
    s = s:gsub('%[', '('):gsub('%]', ')')

    -- Ignore apostrophes so "San d'Oria" matches however it was typed.
    s = s:gsub("'", ''):gsub('\226\128\153', ''):gsub('`', '')

    s = s:gsub('%s+', ' ')

    return s
end

-- names_by_id: { [zone_id] = 'Zone Name', ... }
-- Names shorter than min_length (4 by default, 3 for people such as
-- "Cid" and "Pius") are left out. Returns a list sorted from longest to
-- shortest name.
function M.build_index(names_by_id, min_length)
    local index = {}

    min_length = min_length or 4

    for id, name in pairs(names_by_id or {}) do
        local normalized = M.normalize(name)

        if #normalized >= min_length and normalized ~= '???' then
            index[#index + 1] = {
                id = id,
                name = normalized,
                length = #normalized,
            }
        end
    end

    table.sort(index, function(a, b)
        if a.length ~= b.length then
            return a.length > b.length
        end

        return a.id < b.id
    end)

    return index
end

local function is_word_char(ch)
    return ch ~= '' and ch:match('%w') ~= nil
end

-- Returns the zone id of the first zone mentioned in the text.
-- When two names start at the same place, the longer one wins, so
-- "Windurst Waters (S)" is not mistaken for "Windurst Waters".
function M.find_destination(text, index)
    local haystack = M.normalize(text)

    local best_id
    local best_start
    local best_length = 0

    for _, zone in ipairs(index or {}) do
        local from = 1

        while true do
            local s, e = haystack:find(zone.name, from, true)

            if s == nil then
                break
            end

            local before = s > 1 and haystack:sub(s - 1, s - 1) or ''
            local after = haystack:sub(e + 1, e + 1)

            if not is_word_char(before) and not is_word_char(after) then
                if best_start == nil
                    or s < best_start
                    or (s == best_start and zone.length > best_length) then

                    best_id = zone.id
                    best_start = s
                    best_length = zone.length
                end

                break
            end

            from = s + 1
        end
    end

    return best_id
end

function M.is_plain_travel(text)
    local s = M.normalize(text)
    local verb = s:match('^%s*(%a+)')

    if verb == nil or not travel_verbs[verb] then
        return false
    end

    local padded = ' ' .. s:gsub('[^%w%s]', ' ') .. ' '

    for _, word in ipairs(action_words) do
        if padded:find(' ' .. word .. ' ', 1, true) ~= nil then
            return false
        end
    end

    return true
end

-- True when entering `zone_id` completes this step.
function M.step_completed_by_zone(text, zone_id, index)
    if not M.is_plain_travel(text) then
        return false
    end

    return M.find_destination(text, index) == zone_id
end

return M
