/*
 * -------------------------
 * • Fichier: sh_functions.lua
 * • Projet: p_lib
 * • Création : Sunday, 9th July 2023 4:52:03 pm
 * • Auteur : Ekali
 * • Modification : Saturday, 15th July 2023 12:48:07 am
 * • Destiné à Prisel.fr en V3
 * -------------------------
 */
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

function DarkRP.Library.Delay(seconds)
    local promise = Promise.New()

    timer.Simple(seconds, function()
        promise:Resolve()
    end)

    return promise
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
