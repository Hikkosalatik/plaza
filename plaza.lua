--// ─────────────────────────────────────────────────────────
--  SETUP
--// ─────────────────────────────────────────────────────────
local Library = game.ReplicatedStorage:WaitForChild("Library")
local Client  = Library:WaitForChild("Client")

local RAPCmds = require(Client.RAPCmds)
local Save    = require(Client.Save)

-- Конфиг цен
_G.Config = {
    ["All Huges"]                 = {Price = "+20%"},
    ["Tower Defense Gift"]        = {Price = "-5%", Amount = 5},
    ["Huge Spring Griffin"]       = {Price = "+20%"},
    ["Golden Huge Spring Griffin"] = {Price = "-5"},
}

--// ─────────────────────────────────────────────────────────
--  HELPERS
--// ─────────────────────────────────────────────────────────

-- 1. Проверяем, подпадает ли предмет под конфиг
local function itemMatchesConfig(itemName, className)
    if _G.Config[itemName] then                      -- точное совпадение
        return true
    end
    -- Правило "All Huges" действует ТОЛЬКО для питомцев
    if className == "Pet" and itemName:find("Huge") and _G.Config["All Huges"] then
        return true
    end
    return false
end

-- 2. Применяем ценовой модификатор
local function applyPriceRule(itemName, className, baseRAP)
    local rule = _G.Config[itemName]
    if not rule and className == "Pet" and itemName:find("Huge") then
        rule = _G.Config["All Huges"]
    end
    if not rule then
        return baseRAP
    end

    local price = rule.Price
    local sign , num , pct = price:match("([%+%-])(%d+)(%%?)")
    num = tonumber(num or 0)

    if pct == "%" then                               -- процент
        local factor = (sign == "+" and 1 + num/100) or (1 - num/100)
        return math.floor(baseRAP * factor)
    else                                             -- абсолютное ±число
        return baseRAP + (sign == "-" and -num or num)
    end
end

-- 3. Создаём объект предмета, даже если модуль-таблица
local function buildItem(className, itemData)
    local itemsFolder = Library:FindFirstChild("Items")
    if not itemsFolder then
        warn("Library.Items folder missing")
        return nil
    end

    local moduleScript = itemsFolder:FindFirstChild(className .. "Item")
    if not moduleScript then
        warn("Module for class '" .. className .. "' not found")
        return nil
    end

    local Module = require(moduleScript)
    local item

    if typeof(Module) == "function" then             -- модуль-функция
        item = Module(itemData.id)
    elseif typeof(Module) == "table" then            -- модуль-таблица
        if typeof(Module.Get) == "function" then
            item = Module.Get(itemData.id)
        elseif typeof(Module.new) == "function" then
            item = Module.new(itemData.id)
        else
            warn("No constructor (Get/new) in module for class '" .. className .. "'")
            return nil
        end
    else
        warn("Unsupported module type for class '" .. className .. "'")
        return nil
    end

    -- Состояния предмета
    if itemData.sh then item:SetShiny(true) end
    if itemData.pt == 1 then
        item:SetGolden()
    elseif itemData.pt == 2 then
        item:SetRainbow()
    end
    if itemData.tn then item:SetTier(itemData.tn) end

    return item
end

--// ─────────────────────────────────────────────────────────
--  MAIN LOOP
--// ─────────────────────────────────────────────────────────
for className, itemList in pairs(Save.Get().Inventory) do
    for _, itemData in pairs(itemList) do
        if itemMatchesConfig(itemData.id, className) then
            local itemObj = buildItem(className, itemData)
            if itemObj then
                local baseRAP  = RAPCmds.Get(itemObj) or 0
                local finalRAP = applyPriceRule(itemData.id, className, baseRAP)
                print(string.format("[%s] %s: %d RAP (base %d)", className, itemData.id, finalRAP, baseRAP))
            end
        end
    end
end

