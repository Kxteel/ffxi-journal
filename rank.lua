--[[
    Rank of the character in its own nation.

    The game does not send the rank of the other two nations; the packet
    0x061 (character status) only carries the rank of the nation of the
    character. Layout from the server source (LandSandBoat, CLISTATUS,
    4 bytes of header): rank = u16 at 0x46, rank points = u16 at 0x48,
    nation = u8 at 0x50 (0 San d'Oria, 1 Bastok, 2 Windurst).

    Until the first packet is read (for example just after /addon reload,
    until the next zone change) the rank is unknown, and nothing is locked.
]]

local M = {
    nation = nil,
    rank = nil,
    points = nil,
}

M.NATIONS = { [0] = 'sandoria', [1] = 'bastok', [2] = 'windurst' }
M.NAMES = {
    sandoria = "San d'Oria", bastok = 'Bastok', windurst = 'Windurst',
}

local function u16(data, offset)
    local a, b = data:byte(offset + 1, offset + 2)

    if a == nil or b == nil then
        return nil
    end

    return a + b * 256
end

-- Reads the packet 0x061. Returns true when it was understood.
function M.OnPacket(data)
    if type(data) ~= 'string' or #data < 0x51 then
        return false
    end

    local rank = u16(data, 0x46)
    local points = u16(data, 0x48)
    local nation = M.NATIONS[data:byte(0x50 + 1)]

    if rank == nil or nation == nil or rank < 1 or rank > 10 then
        return false
    end

    M.nation = nation
    M.rank = rank
    M.points = points

    return true
end

-- The area ('sandoria', 'bastok', 'windurst') and rank, or nil when unknown.
function M.Get()
    return M.nation, M.rank, M.points
end

-- True when a mission of `needed` rank of `area` cannot be taken yet: only
-- the nation of the character is known, and only with its rank read.
function M.IsBelow(area, needed)
    needed = tonumber(needed)

    if needed == nil or M.rank == nil or M.nation ~= area then
        return false
    end

    return M.rank < needed
end

function M.OnCommand(args)
    if #args < 2 or args[1]:lower() ~= '/journal' or args[2]:lower() ~= 'rank' then
        return false
    end

    if M.rank == nil then
        print('[Journal] Rank not read yet (it is read when you zone).')
    else
        print(string.format('[Journal] Rank %d of %s (rank points: %s).',
            M.rank, M.NAMES[M.nation] or tostring(M.nation),
            tostring(M.points)))
    end

    return true
end

ashita.events.register('packet_in', 'journal_rank_packet', function(e)
    if e.id == 0x061 then
        M.OnPacket(e.data)
    end
end)

ashita.events.register('command', 'journal_rank_command', function(e)
    local ok, args = pcall(function()
        return e.command:args()
    end)

    if ok and args ~= nil and M.OnCommand(args) then
        e.blocked = true
    end
end)

return M
