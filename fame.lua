-- Fame (reputation) of the nations.
--
-- The game does not send the fame levels to the client. What the client
-- does receive is the event that a Fame Checker NPC starts when the player
-- talks to it, and the event says the level (the events of the
-- LandSandBoat scripts; the server of the player may differ, and
-- /journal fame debug shows what really arrives):
--
--   Namonutice (Southern San d'Oria, zone 230)  event 31 + fame points as
--                                               the first number (0x034)
--   Flaco (Port Bastok, 236)                    event 210 + level
--   Zabirego-Hajigo (Windurst Waters, 238)      event 687 + level (1 to 8),
--                                               784 for level 9
--   Ney Hiparujah (Kazham, 250)                 event 251 + level (Kazham
--                                               and Mhaura use the fame of
--                                               Windurst)
--   Mendi (Lower Jeuno, 245)                    event 82 + fame points
--   Vaultimand (Norg, 252)                      event 99 + level
--   Waylea (Rabao, 247)                         event 56 + level (the fame
--                                               of Selbina and Rabao)
--
-- To be sure that the event is the one of a Fame Checker and not another
-- cutscene with the same number, the name of the NPC that started it must
-- be the expected one (when the game lets the addon read it).
--
-- The level read is kept for the character (logic.SetFameLevel) and shown
-- in the settings window. It only changes when the player talks to the NPC
-- again.
--
-- /journal fame debug [on|off] writes to the chat and to fame_log.txt (in
-- the addon folder) every event packet of the server: the NPC, the two event
-- fields and the eight numbers.

local M = {}

-- The areas that can be read, in the order of the settings window. checkers:
-- the NPCs that say the fame of the area.
M.AREAS = {
    { key = 'sandoria', name = "San d'Oria", checkers = {
        { npc = 'Namonutice', place = "Southern San d'Oria (K-6)" } } },
    { key = 'bastok', name = 'Bastok', checkers = {
        { npc = 'Flaco', place = 'Port Bastok (E-6)' } } },
    { key = 'windurst', name = 'Windurst', checkers = {
        { npc = 'Zabirego-Hajigo', place = 'Windurst Waters, North (F-10)' },
        { npc = 'Ney Hiparujah', place = 'Kazham (I-11)' } } },
    { key = 'jeuno', name = 'Jeuno', checkers = {
        { npc = 'Mendi', place = 'Lower Jeuno (H-8)' } } },
    { key = 'norg', name = 'Norg (Tenshodo)', checkers = {
        { npc = 'Vaultimand', place = 'Norg (H-8)' } } },
    { key = 'selbina_rabao', name = 'Selbina / Rabao', checkers = {
        { npc = 'Waylea', place = 'Rabao (G-9)' } } },
}

-- Points of each fame level, the ones the client expects in the events that
-- carry points.
local RANK_POINTS = { 0, 50, 125, 225, 325, 425, 488, 550, 613 }

local function level_from_points(points)
    local level = 1

    for index, needed in ipairs(RANK_POINTS) do
        if points >= needed then
            level = index
        end
    end

    return level
end

-- area, level and the name of the NPC of an event of a Fame Checker, or
-- nil. number is the first number of the packet 0x034 (nil in the packet
-- 0x032).
function M.Decode(zone, event, number)
    if zone == 230 and event == 31 and number ~= nil and number >= 0 then
        return 'sandoria', level_from_points(number), 'Namonutice'
    end

    if zone == 236 and event >= 211 and event <= 219 then
        return 'bastok', event - 210, 'Flaco'
    end

    if zone == 238 then
        if event == 784 then
            return 'windurst', 9, 'Zabirego-Hajigo'
        elseif event >= 688 and event <= 695 then
            return 'windurst', event - 687, 'Zabirego-Hajigo'
        end
    end

    if zone == 250 and event >= 252 and event <= 260 then
        return 'windurst', event - 251, 'Ney Hiparujah'
    end

    if zone == 245 and event == 82 and number ~= nil and number >= 0 then
        return 'jeuno', level_from_points(number), 'Mendi'
    end

    if zone == 252 and event >= 100 and event <= 108 then
        return 'norg', event - 99, 'Vaultimand'
    end

    if zone == 247 and event >= 57 and event <= 65 then
        return 'selbina_rabao', event - 56, 'Waylea'
    end

    return nil
end

-- Name of an entity of the zone, or nil.
local function entity_name(index)
    local ok, name = pcall(function()
        return AshitaCore:GetMemoryManager():GetEntity():GetName(index)
    end)

    if ok and type(name) == 'string' and name ~= '' then
        return name
    end

    return nil
end

local function same_name(a, b)
    local function clean(value)
        return (value:lower():gsub('[_%s]+', ' '))
    end

    return clean(a) == clean(b)
end

-- true when the name is one of the Fame Checker NPCs.
function M.IsChecker(name)
    if type(name) ~= 'string' then
        return false
    end

    for _, area in ipairs(M.AREAS) do
        for _, checker in ipairs(area.checkers) do
            if same_name(name, checker.npc) then
                return true
            end
        end
    end

    return false
end

-- Zone, event, first number and index of the NPC of an event packet.
function M.ReadEvent(id, data)
    if type(data) ~= 'string' then
        return nil
    end

    local reader = M._reader

    if id == 0x034 and #data >= 0x30 then
        return reader.u16(data, 0x2A), reader.u16(data, 0x2C),
            reader.i32(data, 8), reader.u16(data, 0x28)
    end

    if id == 0x032 and #data >= 0x10 then
        return reader.u16(data, 0x0A), reader.u16(data, 0x0C), nil,
            reader.u16(data, 8)
    end

    return nil
end

local function u16(data, offset)
    local a, b = data:byte(offset + 1, offset + 2)

    return a + b * 256
end

local function u32(data, offset)
    local a, b, c, d = data:byte(offset + 1, offset + 4)

    return a + b * 256 + c * 65536 + d * 16777216
end

local function i32(data, offset)
    local value = u32(data, offset)

    if value >= 2147483648 then
        value = value - 4294967296
    end

    return value
end

M._reader = { u16 = u16, i32 = i32 }

-- One line of text for an event packet, or nil.
function M.Describe(id, data)
    if type(data) ~= 'string' then
        return nil
    end

    if id == 0x034 and #data >= 0x30 then
        local numbers = {}

        for index = 0, 7 do
            numbers[#numbers + 1] = tostring(i32(data, 8 + index * 4))
        end

        return string.format(
            '0x034 npc=%d index=%d name=%s field_2A=%d field_2C=%d mode=%d num=[%s]',
            u32(data, 4), u16(data, 0x28), entity_name(u16(data, 0x28)) or '?',
            u16(data, 0x2A), u16(data, 0x2C), u16(data, 0x2E),
            table.concat(numbers, ' ')
        )
    end

    if id == 0x032 and #data >= 0x10 then
        return string.format(
            '0x032 npc=%d index=%d name=%s field_0A=%d field_0C=%d mode=%d',
            u32(data, 4), u16(data, 8), entity_name(u16(data, 8)) or '?',
            u16(data, 0x0A), u16(data, 0x0C), u16(data, 0x0E)
        )
    end

    return nil
end

local function write_line(text)
    print('[Journal] fame: ' .. text)

    pcall(function()
        local base = addon ~= nil and addon.path or ''
        local file = io.open(base .. LOG_NAME, 'a')

        if file ~= nil then
            file:write(os.date('%Y-%m-%d %H:%M:%S ') .. text .. '\n')
            file:close()
        end
    end)
end

function M.IsDebug()
    return debug_on
end

function M.SetDebug(value)
    debug_on = value == true
end

function M.OnPacket(id, data)
    -- A Fame Checker: keep the level.
    local read, zone, event, number, index = pcall(M.ReadEvent, id, data)

    if read and zone ~= nil then
        local area, level, expected = M.Decode(zone, event, number)

        if area ~= nil then
            -- Another NPC with the same event number is not a Fame Checker.
            local seen = entity_name(index)

            if seen ~= nil and not same_name(seen, expected) then
                area = nil
            end
        end

        if area ~= nil then
            local logic = package.loaded['logic']

            if logic ~= nil and logic.SetFameLevel ~= nil then
                logic.SetFameLevel(area, level, os.time())
            end

            for _, entry in ipairs(M.AREAS) do
                if entry.key == area then
                    print(string.format(
                        '[Journal] Fame: %s level %d saved.',
                        entry.name, level
                    ))
                end
            end
        end
    end

    if not debug_on then
        return
    end

    local ok, text = pcall(M.Describe, id, data)

    if ok and text ~= nil then
        write_line(text)
    end
end

function M.OnCommand(args)
    if #args < 2 or args[1]:lower() ~= '/journal' or args[2]:lower() ~= 'fame' then
        return false
    end

    local sub = args[3] and args[3]:lower() or nil

    if sub == 'debug' then
        local value = args[4] and args[4]:lower() or nil

        if value == 'on' then
            debug_on = true
        elseif value == 'off' then
            debug_on = false
        else
            debug_on = not debug_on
        end

        print('[Journal] fame debug: ' .. (debug_on and 'ON' or 'OFF'))

        if debug_on then
            print('[Journal] Talk to a Fame Checker NPC; the event lines go to the chat and to ' .. LOG_NAME .. '.')
        end
    else
        print('[Journal] Usage: /journal fame debug [on|off]')
    end

    return true
end

ashita.events.register('packet_in', 'journal_fame_packet', function(e)
    if e.id == 0x034 or e.id == 0x032 then
        M.OnPacket(e.id, e.data)
    end
end)

ashita.events.register('command', 'journal_fame_command', function(e)
    local ok, args = pcall(function()
        return e.command:args()
    end)

    if ok and args ~= nil and M.OnCommand(args) then
        e.blocked = true
    end
end)

return M
