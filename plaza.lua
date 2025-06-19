local Library = game.ReplicatedStorage:WaitForChild("Library")
local Client = Library:WaitForChild("Client")
local Save = require(Client.Save)

local RAPCmds = require(Client:WaitForChild("RAPCmds"))

-- Конфигурация
_G.Config = {
    ["Tower Defense Gift"] = {Class = "Lootbox", Price = "-5%", Amount = 5},
    ["Shiny Huge Spring Griffin"] = {Class = "Pet", Price = "+20%"},
}

-- Применение модификатора
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

-- Получение RAP с применением конфигурации
local function GetModifiedRAP(className, itemData)
    local ItemModule = require(Library.Items[className .. "Item"])
    local Item = ItemModule(itemData.id)

    if itemData.sh then Item:SetShiny(true) end
    if itemData.pt == 1 then Item:SetGolden()
    elseif itemData.pt == 2 then Item:SetRainbow() end
    if itemData.tn then Item:SetTier(itemData.tn) end

    local baseRAP = RAPCmds.Get(Item) or 0

    -- Проверяем все строки конфига на соответствие
    for configName, cfg in pairs(_G.Config) do
        if cfg.Class == className then
            -- Определяем параметры конфиг-предмета
            local parsedName = configName
            local cfg_sh = false
            local cfg_pt = 0

            if string.find(parsedName, "Golden") then
                cfg_pt = 1
                parsedName = string.gsub(parsedName, "Golden ", "")
            end
            if string.find(parsedName, "Rainbow") then
                cfg_pt = 2
                parsedName = string.gsub(parsedName, "Rainbow ", "")
            end
            if string.find(parsedName, "Shiny") then
                cfg_sh = true
                parsedName = string.gsub(parsedName, "Shiny ", "")
            end

            if itemData.id == parsedName and
                (itemData.pt or 0) == cfg_pt and
                (itemData.sh or false) == cfg_sh then
                return ApplyPriceModifier(baseRAP, cfg.Price)
            end
        end
    end

    return baseRAP -- если не найдено в конфиге
end

-- Основной проход
for className, itemList in pairs(Save.Get().Inventory) do
    for _, itemData in pairs(itemList) do
        local rap = GetModifiedRAP(className, itemData)
        print(string.format("[%s] %s: %d RAP", className, itemData.id, rap))
    end
end

