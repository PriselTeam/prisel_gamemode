local DarkRP = DarkRP or {}
DarkRP.Library = DarkRP.Library or {}

function DarkRP.Library.DebugPrint(message, level)
    if not DarkRP.Config.DebugMode then return end

    level = level or 1

    local debugInfo = debug.getinfo(level + 1)
    local source = debugInfo.short_src or ""
    local line = debugInfo.currentline or ""
    local funcName = debugInfo.name or ""
    local args = ""

    local currentTime = os.date("%Y-%m-%d %H:%M:%S")

    local argCount = debug.getinfo(level, "u").nparams
    if argCount > 0 then
        local argValues = {}
        for i = 1, argCount do
            local argName, argValue = debug.getlocal(level, i)
            table.insert(argValues, string.format("%s = %s", argName, tostring(argValue)))
        end
        args = table.concat(argValues, ", ")
    end

    local debugMessage = string.format("[Prisel V3 Debug - %s]\n  Source: %s\n  Line: %s\n  Function: %s\n  Arguments: %s\n  Message: %s", currentTime, source, line, funcName, args, message)
    print(debugMessage)
end

function DarkRP.Library.FindPlayerByName(name)
    local lowerName = string.lower(name)
    for _, ply in ipairs(player.GetAll()) do
        local lowerNick = string.lower(ply:Nick())
        local lowerSteamID = string.lower(ply:SteamID())
        if lowerNick == lowerName or lowerSteamID == lowerName then
            return ply
        end
    end
    return nil
end

DarkRP.Library.Promises = {}
DarkRP.Library.PromiseCount = 0

local function AwaitCoroutine(hookName, condition, callback)
    local framesPassed = 0

    local function ThinkCallback()
        framesPassed = framesPassed + 1

        if condition() then
            hook.Remove("Think", hookName)
            callback()
            DarkRP.Library.Promises[hookName] = nil
        end
    end

    hook.Add("Think", hookName, ThinkCallback)
end

function DarkRP.Library.Await(condition, callback)
    local hookName = "DarkRP.Library.Await_" .. tostring(DarkRP.Library.PromiseCount)

    if condition() then
        callback()
        return
    end

    DarkRP.Library.PromiseCount = DarkRP.Library.PromiseCount + 1

    local promiseData = {
        condition = condition,
        callback = callback,
        hookName = hookName
    }

    DarkRP.Library.Promises[hookName] = promiseData

    timer.Simple(0, function()
        AwaitCoroutine(hookName, condition, callback)
    end)
end

function DarkRP.Library.Benchmark(iIterations, ...) -- Wasied
    local tTests = {...}
    local tResults = {}

    for i, testFunc in ipairs(tTests) do
        local startTime = SysTime()
        for _ = 1, iIterations do testFunc() end
        local endTime = SysTime()
        tResults[i] = {endTime - startTime, i}
    end

    table.sort(tResults, function(a, b) return a[1] < b[1] end)

    local fastestTime = tResults[1][1]
    for i, result in ipairs(tResults) do
        local testIndex, durationSeconds = result[2], result[1]
        local slowerPercentage = math.Round((durationSeconds - fastestTime) / durationSeconds * 100, 2)
        print(string.format("Test %d took %.4f seconds, %s%% slower than the fastest test", testIndex, durationSeconds, slowerPercentage))
    end
end

function DarkRP.Library.IsValidReason(reason)
    if not reason then return false end
    if not isstring(reason) then return false end
    return string.match(reason, "[a-zA-Z].*[a-zA-Z].*[a-zA-Z]") ~= nil
end

local time_units = {
    {"an", 60 * 60 * 24 * 365},
    {"mois", 60 * 60 * 24 * 30},
    {"jour", 60 * 60 * 24},
    {"heure", 60 * 60},
    {"minute", 60},
    {"seconde", 1},
}

function DarkRP.Library.FormatSeconds(seconds, abbreviate)
    local result = {}

    for _, unit in ipairs(time_units) do
        local value = math.floor(seconds / unit[2])
        if value > 0 then
            local unit_label = abbreviate and unit[1]:sub(1, 1) or unit[1]
            if not abbreviate and value > 1 then
                unit_label = unit_label .. "s"  -- Add "s" for plural units when not abbreviated
            end
            table.insert(result, value .. " " .. unit_label)
            seconds = seconds - (value * unit[2])
        end
    end

    return #result > 0 and table.concat(result, " ") or "0 seconds"
end

local PLAYER = FindMetaTable("Player")

function PLAYER:PIsVIP()
    if not IsValid(self) then return end
    return DarkRP.Config["VIPGroups"][self:GetUserGroup()]
end

function PLAYER:PIsStaff()
    if not IsValid(self) then return end
    return DarkRP.Config["StaffGroups"][self:GetUserGroup()]
end

function PLAYER:HasAdminMode()
    if not IsValid(self) then return end
    if not self:PIsStaff() then return false end
    return self:GetNWBool("Prisel.AdminMode")
end


function PLAYER:SetAdminMode(bool)
    if not IsValid(self) then return end
    if not self:PIsStaff() then return end

    if SERVER then
        self:SetNWBool("Prisel.AdminMode", bool)
    end

    if CLIENT then
        net.Start("PriselV3::PlayerAdmin")
        net.WriteUInt(1, 2)
        net.WriteBool(bool)
        net.SendToServer()

        surface.PlaySound("buttons/button14.wav")
    end
end