local isnil = fn.Curry(fn.Eq, 2)(nil)
local validFood = {
    "name",
    model = isstring,
    "energy",
    "price",
    onEaten = fn.FOr{isnil, isfunction}
}

FoodItems = {}

function DarkRP.createFood(name, mdl, energy, price)
    local foodItem = istable(mdl) and mdl or {model = mdl, energy = energy, price = price}
    foodItem.name = name

    if DarkRP.DARKRP_LOADING and DarkRP.disabledDefaults["food"][name] then return end

    for k, v in pairs(validFood) do
        local isFunction = isfunction(v)

        if (isFunction and not v(foodItem[k])) or (not isFunction and foodItem[v] == nil) then
            ErrorNoHalt("Corrupt food \"" .. (name or "") .. "\": element " .. (isFunction and k or v) .. " is corrupt.\n")
        end
    end

    table.insert(FoodItems, foodItem)
end
AddFoodItem = DarkRP.createFood

local plyMeta = FindMetaTable("Player")
plyMeta.isCook = fn.Compose{fn.Curry(fn.GetValue, 2)("cook"), plyMeta.getJobTable}

DarkRP.registerDarkRPVar("Energy", net.WriteFloat, net.ReadFloat)

DarkRP.createFood("Banana", {model = "models/props/cs_italy/bananna.mdl", energy = 10, price = 10})
DarkRP.createFood("Bunch of bananas", {model = "models/props/cs_italy/bananna_bunch.mdl", energy = 20, price = 20})
DarkRP.createFood("Melon", {model = "models/props_junk/watermelon01.mdl", energy = 20, price = 20})
DarkRP.createFood("Glass bottle", {model = "models/props_junk/GlassBottle01a.mdl", energy = 20, price = 20})
DarkRP.createFood("Pop can", {model = "models/props_junk/PopCan01a.mdl", energy = 5, price = 5})
DarkRP.createFood("Plastic bottle", {model = "models/props_junk/garbage_plasticbottle003a.mdl", energy = 15, price = 15})
DarkRP.createFood("Milk", {model = "models/props_junk/garbage_milkcarton002a.mdl", energy = 20, price = 20})
DarkRP.createFood("Bottle 1", {model = "models/props_junk/garbage_glassbottle001a.mdl", energy = 10, price = 10})
DarkRP.createFood("Bottle 2", {model = "models/props_junk/garbage_glassbottle002a.mdl", energy = 10, price = 10})
DarkRP.createFood("Bottle 3", {model = "models/props_junk/garbage_glassbottle003a.mdl", energy = 10, price = 10})
DarkRP.createFood("Orange", {model = "models/props/cs_italy/orange.mdl", energy = 20, price = 20})
