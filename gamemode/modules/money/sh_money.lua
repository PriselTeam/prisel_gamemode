local pMeta = FindMetaTable("Player")
local entMeta = FindMetaTable("Entity")

function pMeta:canAfford(amount)
    if not amount or self.DarkRPUnInitialized or amount < 0 then
        return false
    end

    local money = self:getDarkRPVar("money") or 0

    return money - math.ceil(amount) >= 0
end

function entMeta:isMoneyBag()
    return self.IsSpawnedMoney or (IsValid(self) and self:GetClass() == GAMEMODE.Config.MoneyClass)
end
