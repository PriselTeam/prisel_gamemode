local function updateSpawnPos(ply, args, add)
    local pos = ply:GetPos()
    local t

    for k, v in pairs(RPExtraTeams) do
        if args == v.command then
            t = k
            local message = add and DarkRP.getPhrase("created_spawnpos", v.name) or DarkRP.getPhrase("updated_spawnpos", v.name)
            DarkRP.notify(ply, 0, 4, message)
            break
        end
    end

    if t then
        local func = add and DarkRP.addTeamSpawnPos or DarkRP.storeTeamSpawnPos
        func(t, {pos.x, pos.y, pos.z})
    else
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("could_not_find", tostring(args)))
    end
end

local function setSpawnPos(ply, args)
    updateSpawnPos(ply, args, false)
end

local function addSpawnPos(ply, args)
    updateSpawnPos(ply, args, true)
end

local function removeSpawnPos(ply, args)
    local t

    for k, v in pairs(RPExtraTeams) do
        if args == v.command then
            t = k
            DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("remove_spawnpos", v.name))
            break
        end
    end

    if t then
        DarkRP.removeTeamSpawnPos(t)
    else
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("could_not_find", tostring(args)))
    end
end

DarkRP.definePrivilegedChatCommand("setspawn", "DarkRP_AdminCommands", setSpawnPos)
DarkRP.definePrivilegedChatCommand("addspawn", "DarkRP_AdminCommands", addSpawnPos)
DarkRP.definePrivilegedChatCommand("removespawn", "DarkRP_AdminCommands", removeSpawnPos)
