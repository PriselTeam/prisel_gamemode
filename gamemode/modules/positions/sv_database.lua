local teamSpawns = {}
local jailPos = {}

local function onDBInitialized()
    local map = MySQLite.SQLStr(string.lower(game.GetMap()))
    MySQLite.query("SELECT * FROM darkrp_position NATURAL JOIN darkrp_jobspawn WHERE map = " .. map .. ";", function(data)
        teamSpawns = data or {}
    end)

    MySQLite.query([[SELECT * FROM darkrp_position WHERE type = 'J' AND map = ]] .. map .. [[;]], function(data)
        for _, v in ipairs(data or {}) do
            table.insert(jailPos, Vector(v.x, v.y, v.z))
        end
    end)
end

hook.Add("DarkRPDBInitialized", "GetPositions", onDBInitialized)

local JailIndex = 1

function DarkRP.setJailPos(pos)
    local map = MySQLite.SQLStr(string.lower(game.GetMap()))
    jailPos = {pos}

    local remQuery = "DELETE FROM darkrp_position WHERE type = 'J' AND map = %s;"
    local insQuery = "INSERT INTO darkrp_position(map, type, x, y, z) VALUES(%s, 'J', %s, %s, %s);"

    remQuery = remQuery:format(map)
    insQuery = insQuery:format(map, pos.x, pos.y, pos.z)

    MySQLite.begin()
    MySQLite.queueQuery(remQuery)
    MySQLite.queueQuery(insQuery)
    MySQLite.commit()

    JailIndex = 1
end

function DarkRP.addJailPos(pos)
    local map = MySQLite.SQLStr(string.lower(game.GetMap()))
    table.insert(jailPos, pos)

    local insQuery = "INSERT INTO darkrp_position(map, type, x, y, z) VALUES(%s, 'J', %s, %s, %s);"
    insQuery = insQuery:format(map, pos.x, pos.y, pos.z)

    MySQLite.query(insQuery)

    JailIndex = 1
end

function DarkRP.retrieveJailPos(index)
    if not jailPos then return Vector(0, 0, 0) end
    if index then
        return jailPos[index]
    end

    local oldestPos = jailPos[JailIndex]
    JailIndex = JailIndex % #jailPos + 1

    return oldestPos
end

function DarkRP.storeTeamSpawnPos(t, pos)
    local map = string.lower(game.GetMap())
    local teamcmd = RPExtraTeams[t].command

    DarkRP.removeTeamSpawnPos(t, function()
        local insQuery = "INSERT INTO darkrp_position(map, type, x, y, z) VALUES(%s, 'T', %s, %s, %s);"
        insQuery = insQuery:format(MySQLite.SQLStr(map), pos[1], pos[2], pos[3])

        MySQLite.query(insQuery, function()
            local maxIdQuery = "SELECT MAX(id) FROM darkrp_position WHERE map = %s AND type = 'T';"
            maxIdQuery = maxIdQuery:format(MySQLite.SQLStr(map))

            MySQLite.queryValue(maxIdQuery, function(id)
                if not id then return end

                local jobSpawnQuery = "INSERT INTO darkrp_jobspawn VALUES(%d, %s);"
                jobSpawnQuery = jobSpawnQuery:format(id, MySQLite.SQLStr(teamcmd))

                MySQLite.query(jobSpawnQuery)

                table.insert(teamSpawns, { id = id, map = map, x = pos[1], y = pos[2], z = pos[3], teamcmd = teamcmd })
            end)
        end)
    end)
end

function DarkRP.removeTeamSpawnPos(t, callback)
    local map = string.lower(game.GetMap())
    local teamcmd = RPExtraTeams[tonumber(t)].command

    for k, v in ipairs(teamSpawns) do
        if v.teamcmd == teamcmd then
            teamSpawns[k] = nil
        end
    end

    local query = [[SELECT dp.id FROM darkrp_position dp
        JOIN darkrp_jobspawn dj ON dp.id = dj.id
        WHERE dp.map = %s AND dj.teamcmd = %s;]]

    query = query:format(MySQLite.SQLStr(map), MySQLite.SQLStr(teamcmd))

    MySQLite.query(query, function(data)
        MySQLite.begin()
        for i = 1, #data do
            MySQLite.query("DELETE FROM darkrp_position WHERE id = " .. data[i].id .. ";")
            MySQLite.query("DELETE FROM darkrp_jobspawn WHERE id = " .. data[i].id .. ";")
        end
        MySQLite.commit(callback)
    end)
end

function DarkRP.retrieveTeamSpawnPos(t)
    local teamcmd = RPExtraTeams[t].command
    local filteredSpawns = {}

    for k, v in ipairs(teamSpawns) do
        if v.teamcmd == teamcmd then
            table.insert(filteredSpawns, Vector(v.x, v.y, v.z))
        end
    end

    return filteredSpawns
end
