-- Spanish version of the Journal.
--
-- Two dictionaries are used:
--   data/translations_es.lua  the objective texts (steps)
--   data/ui_es.lua            the texts of the Journal itself (buttons,
--                             titles, labels and chat messages)
--
-- data/translations_es.lua maps the English text of a step to its Spanish
-- text. The names of zones, places, NPCs, monsters and items are kept in
-- English inside the Spanish text. A text that has no translation is shown
-- in English, so a missing entry never hides a step.
--
-- The dictionary is big, so it is only loaded the first time Spanish is
-- used.

local M = {}

local language = 'en'
local dictionary = nil
local load_failed = false

local function get_dictionary()
    if dictionary ~= nil or load_failed then
        return dictionary
    end

    local ok, result = pcall(require, 'data.translations_es')

    if ok and type(result) == 'table' then
        dictionary = result
    else
        load_failed = true
    end

    return dictionary
end

function M.get_language()
    return language
end

function M.set_language(code)
    language = code == 'es' and 'es' or 'en'
end

-- Returns the text of a step in the current language.
function M.step(text)
    if language ~= 'es' or type(text) ~= 'string' then
        return text
    end

    local words = get_dictionary()

    if words == nil then
        return text
    end

    return words[text] or text
end

local ui_words = nil
local ui_load_failed = false

local function get_ui_words()
    if ui_words ~= nil or ui_load_failed then
        return ui_words
    end

    local ok, result = pcall(require, 'data.ui_es')

    if ok and type(result) == 'table' then
        ui_words = result
    else
        ui_load_failed = true
    end

    return ui_words
end

-- Returns a text of the Journal itself in the current language. A text
-- that ends in ##id (an ImGui id) keeps its id. A text with no
-- translation is returned as it is.
function M.t(text)
    if language ~= 'es' or type(text) ~= 'string' then
        return text
    end

    local words = get_ui_words()

    if words == nil then
        return text
    end

    local at = text:find('##', 1, true)

    if at == nil then
        return words[text] or text
    end

    local base = text:sub(1, at - 1)

    if base == '' then
        return text
    end

    return (words[base] or base) .. text:sub(at)
end

-- True when the Spanish dictionary could be loaded.
function M.available()
    return get_dictionary() ~= nil
end

return M
