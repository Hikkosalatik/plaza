local Library = game.ReplicatedStorage.Library
local Client = Library.Client

local RAPCmds = require(Client.RAPCmds)
local Network = require(Client.Network)
local Save = require(Client.Save)

-- Пример конфигурации
_G.Config = {
    ["Tower Defense Gift"] = {Price = "-5%", Amount = 5},
    ["Huge Spring Griffin"] = {Price = "+20%"},
    ["Golden Huge Spring Griffin"] = {Price = "-5"},
}

-- Проверка, подходит ли предмет под конфиг
local function IsInConfig(name)
    return _G.Config[name] or (string.find(name, "Huge") and _G.Config["All Huges"])
end

-- Применение модификатора RAP
local function ModifyRAP(name, baseRAP)
    local config = _G.Config[name]
    if not config and string.find(name, "Huge") then
        config = _G.Config["All Huges"]
    end
    if not config then return baseRAP end

    local priceStr = config.Price
    if string.find(priceStr, "%%") then
        local sign, percent = string.match(priceStr, "([%+%-])(%d+)%%")
        percent = tonumber(percent)
        if sign == "+" then
            return math.floor(baseRAP * (1 + percent / 100))
        else
            return math.floor(baseRAP * (1 - percent / 100))
        end
    else
        return baseRAP + tonumber(priceStr)
    end
end

-- Получение RAP
local function GetItemRAP(Class, ItemData)
    local ItemModule = require(Library.Items[Class .. "Item"])
    local Item = ItemModule(ItemData.id)

    if ItemData.sh then
        Item:SetShiny(true)
    end
    if ItemData.pt == 1 then
        Item:SetGolden()
    elseif ItemData.pt == 2 then
        Item:SetRainbow()
    end
    if ItemData.tn then
        Item:SetTier(ItemData.tn)
    end

    local baseRAP = RAPCmds.Get(Item) or 0
    return ModifyRAP(ItemData.id, baseRAP)
end

-- Перебор только предметов, указанных в конфиге
for className, itemList in pairs(Save.Get().Inventory) do
    for _, itemData in pairs(itemList) do
        if IsInConfig(itemData.id) then
            local rap = GetItemRAP(className, itemData)
            print(string.format("[%s] %s: %d RAP", className, itemData.id, rap))
        end
    end
end
