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
local function ApplyPriceModifier(baseRAP, priceStr)
    if not priceStr then return baseRAP end

    local sign, value, isPercent = priceStr:match("([%+%-])(%d+)(%%?)")
    value = tonumber(value)

    if isPercent == "%" then
        local factor = (sign == "+" and 1 + value / 100) or (1 - value / 100)
        return math.floor(baseRAP * factor)
    else
        return baseRAP + (sign == "-" and -value or value)
    end
end

-- Очистка имени и извлечение состояний
local function ParseItemName(name)
    local parsed = name
    local sh = false
    local pt = 0

    if parsed:find("Golden") then
        pt = 1
        parsed = parsed:gsub("Golden ", "")
    end
    if parsed:find("Rainbow") then
        pt = 2
        parsed = parsed:gsub("Rainbow ", "")
    end
    if parsed:find("Shiny") then
        sh = true
        parsed = parsed:gsub("Shiny ", "")
    end

    return parsed, pt, sh
end

-- Получение RAP предмета
local function GetItemRAP(Class, ItemData)
    local ItemModule = require(Library.Items[Class .. "Item"])
    local Item = ItemModule(ItemData.id)

    if ItemData.sh then Item:SetShiny(true) end
    if ItemData.pt == 1 then Item:SetGolden()
    elseif ItemData.pt == 2 then Item:SetRainbow() end
    if ItemData.tn then Item:SetTier(ItemData.tn) end

    local baseRAP = RAPCmds.Get(Item) or 0
    return baseRAP
end

-- Проход только по предметам из конфига
for fullName, cfg in pairs(_G.Config) do
    local className = cfg.Class
    local inventory = Save.Get().Inventory[className]

    if inventory then
        local name, pt, sh = ParseItemName(fullName)

        for _, item in pairs(inventory) do
            if item.id == name and (item.pt or 0) == pt and (item.sh or false) == sh then
                local baseRAP = GetItemRAP(className, item)
                local modifiedRAP = ApplyPriceModifier(baseRAP, cfg.Price)

                print(string.format("[%s] %s: %d RAP (base: %d)", className, fullName, modifiedRAP, baseRAP))
            end
        end
    end
end

