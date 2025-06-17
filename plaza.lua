local Library = game.ReplicatedStorage.Library
local Client = Library.Client

local RAPCmds = require(Client.RAPCmds)
local Network = require(Client.Network)
local Save = require(Client.Save)

-- Пример конфигурации (только точные названия!)
_G.Config = {
    ["Tower Defense Gift"] = {Class = "Tower", Price = "-5%", Amount = 5},
    ["Huge Spring Griffin"] = {Class = "Pet", Price = "+20%"},
    ["Golden Huge Spring Griffin"] = {Class = "Pet", Price = "-5"},
}

-- Быстрый доступ к нужным предметам из конфига по классам
local ClassLookup = {}
for name, cfg in pairs(_G.Config) do
    local class = cfg.Class
    if not ClassLookup[class] then
        ClassLookup[class] = {}
    end
    ClassLookup[class][name] = cfg
end

-- Применяем модификатор
local function ModifyRAP(cfg, baseRAP)
    local priceStr = cfg.Price
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

-- Получаем объект Item
local function GetItem(className, itemData)
    local moduleScript = Library.Items:FindFirstChild(className .. "Item")
    if not moduleScript then return nil end

    local Module = require(moduleScript)
    local item

    if typeof(Module) == "function" then
        item = Module(itemData.id)
    elseif typeof(Module) == "table" then
        if typeof(Module.Get) == "function" then
            item = Module.Get(itemData.id)
        elseif typeof(Module.new) == "function" then
            item = Module.new(itemData.id)
        else
            return nil
        end
    else
        return nil
    end

    if itemData.sh then item:SetShiny(true) end
    if itemData.pt == 1 then item:SetGolden()
    elseif itemData.pt == 2 then item:SetRainbow() end
    if itemData.tn then item:SetTier(itemData.tn) end

    return item
end

-- Основной проход по инвентарю
for className, itemList in pairs(Save.Get().Inventory) do
    local classConfig = ClassLookup[className]
    if classConfig then
        for _, itemData in pairs(itemList) do
            local cfg = classConfig[itemData.id]
            if cfg then
                local item = GetItem(className, itemData)
                if item then
                    local baseRAP = RAPCmds.Get(item) or 0
                    local finalRAP = ModifyRAP(cfg, baseRAP)
                    print(string.format("[%s] %s: %d RAP (base %d)", className, itemData.id, finalRAP, baseRAP))
                end
            end
        end
    end
end
