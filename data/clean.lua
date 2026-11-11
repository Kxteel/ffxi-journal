-- Step text cleanup, applied when the quest and mission data is loaded.
--
-- Actor texts in data/actors.lua are complete fragments and end with a
-- period ("Patt-Pott (I-7)."). Step files add their own punctuation
-- around them, which leaves things like "Patt-Pott (I-7).." or
-- "Kupipi. in Heavens Tower". Fixing it here keeps actors.lua intact,
-- so the actor text can still be shown on its own.

local M = {}

function M.step(text)
    if type(text) ~= 'string' then
        return text
    end

    -- "Cid (H-8).." -> "Cid (H-8)."
    text = text:gsub('%.%.', '.')

    -- "Kocco Ehllek (H-8)., who" -> "Kocco Ehllek (H-8), who"
    text = text:gsub('%.([,;])', '%1')

    -- "Thorben (J-10). in Batallia" -> "Thorben (J-10) in Batallia"
    -- A sentence break is always followed by a capital letter, so a
    -- period followed by a lowercase word is a stray one.
    text = text:gsub('%. (%l)', ' %1')

    return text
end

-- Returns a cleaned copy of a step list. Anything that is not a plain
-- string is passed through untouched.
function M.steps(list)
    if type(list) ~= 'table' then
        return list
    end

    local result = {}

    for index, step in ipairs(list) do
        result[index] = M.step(step)
    end

    return result
end

return M
