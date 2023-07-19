local function storeJail(ply, add, hasAccess)
    if not IsValid(ply) then return end

    local team = ply:Team()

    if (RPExtraTeams[team] and RPExtraTeams[team].chief and GAMEMODE.Config.chiefjailpos) or hasAccess then
        DarkRP.storeJailPos(ply, add)
    else
        local str = DarkRP.getPhrase("admin_only")
        if GAMEMODE.Config.chiefjailpos then
            str = DarkRP.getPhrase("chief_or") .. str
        end

        DarkRP.notify(ply, 1, 4, str)
    end
end

local function jailPos(ply)
    CAMI.PlayerHasAccess(ply, "DarkRP_AdminCommands", function()
        storeJail(ply, false, true)
    end)

    return ""
end

local function addJailPos(ply)
    CAMI.PlayerHasAccess(ply, "DarkRP_AdminCommands", function()
        storeJail(ply, true, true)
    end)

    return ""
end

DarkRP.defineChatCommand("jailpos", jailPos)
DarkRP.defineChatCommand("setjailpos", jailPos)
DarkRP.defineChatCommand("addjailpos", addJailPos)
