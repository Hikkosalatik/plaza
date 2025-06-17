local Library = game.ReplicatedStorage.Library
local Client = Library.Client

local RAPCmds = require(Client.RAPCmds)
local Network = require(Client.Network)
local Save = require(Client.Save)

-- Конфиг
_G.Config = {
    ["All Huges"] = {Price = "+20%"},
    ["Tower Defense Gift"] = {Price = "-5%", Amount = 5},
    ["Huge Spring Griffin"] = {Price = "+20%"},
    ["Golden Huge Spring Griffin"] = {Price = "-5"},
}

-- Проверка, есть ли предмет в конфиге
local function IsInConfig(name, className)
    if _G.Config[name] then
        return true
    end

    -- All Huges применяется только к питомцам
    if className == "Pet" and string.find(name, "Huge") and _G.Config["All Huges"] then
        return true
    end

    return false
end

-- Применение модификатора RAP
local function ModifyRAP(name, baseRAP, className)
    local config = _G.Config[name]
    if not config and className == "Pet" and string.find(name, "Huge") then
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
    local itemModulePath = Library.Items:FindFirstChild(Class .. "Item")
    if not itemModulePath then
        warn("Item module not found for class:", Class)
        return 0
    end

    local ItemModule = require(itemModulePath)
    if type(ItemModule) ~= "function" then
        warn("Invalid ItemModule (not a function) for:", Class)
        return 0
    end

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
    return ModifyRAP(ItemData.id, baseRAP, Class)
end

-- Перебор инвентаря
for className, itemList in pairs(Save.Get().Inventory) do
    for _, itemData in pairs(itemList) do
        if IsInConfig(itemData.id, className) then
            local rap = GetItemRAP(className, itemData)
            print(string.format("[%s] %s: %d RAP", className, itemData.id, rap))
        end
    end
end
