local function HMPlayerSpawn(ply)
    ply:setSelfDarkRPVar("Energy", 100)
end
hook.Add("PlayerSpawn", "HMPlayerSpawn", HMPlayerSpawn)

local function HMThink()
    for _, v in ipairs(player.GetAll()) do
        if v:Alive() then
            v:hungerUpdate()
        end
    end
end
timer.Create("HMThink", 10, 0, HMThink)

local function HMPlayerInitialSpawn(ply)
    ply:newHungerData()
end
hook.Add("PlayerInitialSpawn", "HMPlayerInitialSpawn", HMPlayerInitialSpawn)

local function HMAFKHook(ply, afk)
    if afk then
        ply.preAFKHunger = ply:getDarkRPVar("Energy")
    else
        ply:setSelfDarkRPVar("Energy", ply.preAFKHunger or 100)
        ply.preAFKHunger = nil
    end
end
hook.Add("playerSetAFK", "Hungermod", HMAFKHook)