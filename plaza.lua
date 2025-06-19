local Library = game.ReplicatedStorage:WaitForChild("Library")
local Client = Library:WaitForChild("Client")
local Save = require(Client.Save)

local RAPCmds = require(Client:WaitForChild("RAPCmds"))

-- Конфигурация
_G.Config = {
    ["Tower Defense Gift"] = {Class = "Lootbox", Price = "-5%", Amount = 5},
    ["Shiny Huge Spring Griffin"] = {Class = "Pet", Price = "+20%"},
}

-- Применение модификатора цены
local function ApplyPriceModifier(baseRAP, config)
    if not config or not config.Price then return baseRAP end

    local priceStr = config.Price
    local sign, value, isPercent = priceStr:match("([%+%-])(%d+)(%%?)")
    value = tonumber(value)

    if isPercent == "%" then
        local factor = (sign == "+" and 1 + value / 100) or (1 - value / 100)
        return math.floor(baseRAP * factor)
    else
        return baseRAP + (sign == "-" and -value or value)
    end
end

-- Получение RAP предмета с учётом конфига
local function GetItemRAP(Class, ItemData)
    local ItemModule = require(Library.Items[Class .. "Item"])
    local Item = ItemModule(ItemData.id)

    -- Устанавливаем состояния предмета
    if ItemData.sh then Item:SetShiny(true) end
    if ItemData.pt == 1 then
        Item:SetGolden()
    elseif ItemData.pt == 2 then
        Item:SetRainbow()
    end
    if ItemData.tn then Item:SetTier(ItemData.tn) end

    -- Получаем базовый RAP
    local baseRAP = RAPCmds.Get(Item) or 0

    -- Проверка и применение конфига
    local config = _G.Config[ItemData.id]
    if config and config.Class == Class then
        return ApplyPriceModifier(baseRAP, config)
    end

    return baseRAP
end

-- Пример

for itemName, config in pairs(_G.Config) do
    local exampleItem = {
        id = itemName,
        sh = false,
        pt = 0,
        tn = false
    }

    if string.find(itemName, "Golden") then
        exampleItem.pt = 1
        itemName = string.gsub(itemName, "Golden ", "")
    end
    if string.find(itemName, "Rainbow") then
        exampleItem.pt = 2
        itemName = string.gsub(itemName, "Rainbow ", "")
    end
    if string.find(itemName, "Shiny") then
        exampleItem.sh = true
        itemName = string.gsub(itemName, "Shiny ", "")
    end

    exampleItem.id = itemName  

    local className = config.Class
    local inventory = Save.Get().Inventory[className]

    if inventory then
        for _, itemData in pairs(inventory) do
            local match =
                itemData.id == exampleItem.id and
                (itemData.pt or 0) == exampleItem.pt and
                (itemData.sh or false) == exampleItem.sh and
                (itemData.tn or false) == exampleItem.tn

            if match then
                print("Найден предмет в инвентаре:", itemData.id)
                local rap = GetItemRAP(className, itemData)
                print(string.format("[%s] %s: %d RAP", className, itemData.id, rap))
            end
        end
    end
end
