FAdmin = FAdmin or {}

FAdmin.PlayerActions = FAdmin.PlayerActions or {}
FAdmin.StartHooks = FAdmin.StartHooks or {}

function FAdmin.FindPlayer(info)
    if not info then return nil end

    local pls = player.GetAll()
    local found = {}

    if string.lower(info) == "*" or string.lower(info) == "<all>" then
        return pls
    end

    local InfoPlayers = {}
    for A in info:gmatch("([%w:_.]*)[;(,%s)%c]") do
        if A ~= "" then
            table.insert(InfoPlayers, A)
        end
    end

    for _, PlayerInfo in ipairs(InfoPlayers) do
        if tonumber(PlayerInfo) then
            local playerByID = Player(PlayerInfo)
            if IsValid(playerByID) and not found[playerByID] then
                found[playerByID] = true
            end
            continue
        end

        for _, v in ipairs(pls) do
            if (PlayerInfo == v:SteamID() or v:SteamID() == "UNKNOWN") and not found[v] then
                found[v] = true
            end

            if string.find(v:Nick():lower(), PlayerInfo:lower(), 1, true) ~= nil and not found[v] then
                found[v] = true
            end

            if v.SteamName and string.find(v:SteamName():lower(), PlayerInfo:lower(), 1, true) ~= nil and not found[v] then
                found[v] = true
            end
        end
    end

    local players = {}
    local empty = true
    for k in pairs(found or {}) do
        empty = false
        table.insert(players, k)
    end

    return not empty and players or nil
end

function FAdmin.SteamToProfile(ply)
    return ("https://steamcommunity.com/profiles/%s"):format(ply:SteamID64() or "BOT")
end

FAdmin.GlobalSetting = FAdmin.GlobalSetting or {}

timer.Simple(0, function()
    for k in pairs(FAdmin.StartHooks) do
        if not isstring(k) then
            FAdmin.StartHooks[k] = nil
        end
    end

    for _, v in SortedPairs(FAdmin.StartHooks) do
        v()
    end
end)
