repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library")
local Client = Library:WaitForChild("Client")

local Save = require(Client:WaitForChild("Save"))
local RAPCmds = require(Client:WaitForChild("RAPCmds"))
local Network = require(Client:WaitForChild("Network"))

-- Конфигурация продаж
_G.Config = {
    ["Tower Defense Gift"] = {Class = "Lootbox", Price = "-5%", Amount = 5},
    ["Huge Robot Ball"] = {Class = "Pet", Price = "-20%"},
}

-- Парсинг имени
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

-- Получение RAP
local function GetItemRAP(Class, ItemData)
    local ItemModule = require(Library.Items[Class .. "Item"])
    local Item = ItemModule(ItemData.id)

    if ItemData.sh then Item:SetShiny(true) end
    if ItemData.pt == 1 then Item:SetGolden()
    elseif ItemData.pt == 2 then Item:SetRainbow() end
    if ItemData.tn then Item:SetTier(ItemData.tn) end

    return RAPCmds.Get(Item) or 0
end

-- Телепорт в буст
if game.PlaceId == 8737899170 then
    while task.wait(4) do
        Network.Invoke("Travel to Trading Plaza")
    end
end

-- Занимаем буст
local HaveBooth = false
while not HaveBooth do 
    local BoothSpawns = workspace.TradingPlaza.BoothSpawns:FindFirstChildWhichIsA("Model")
    for _, Booth in ipairs(workspace.__THINGS.Booths:GetChildren()) do
        if Booth:IsA("Model") and Booth.Info.BoothBottom.Frame.Top.Text == LocalPlayer.DisplayName .. "'s Booth!" then
            HaveBooth = true
            LocalPlayer.Character.HumanoidRootPart.CFrame = Booth.Table.CFrame * CFrame.new(5, 0, 0) * CFrame.Angles(0, math.rad(90), 0)
            break
        end
    end
    if not HaveBooth and BoothSpawns then
        LocalPlayer.Character.HumanoidRootPart.CFrame = BoothSpawns.Table.CFrame * CFrame.new(5, 0, 0) * CFrame.Angles(0, math.rad(90), 0)
        Network.Invoke("Booths_ClaimBooth", tostring(BoothSpawns:GetAttribute("ID")))
    end
    task.wait(1)
end

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.Jump = true
    end
end)

-- Автоматическая продажа предметов из конфига
while task.wait(5) do
    local BoothQueue = {}

    for fullName, cfg in pairs(_G.Config) do
        local className = cfg.Class
        local inventory = Save.Get().Inventory[className]
        if inventory then
            local parsedName, pt, sh = ParseItemName(fullName)
            for uuid, item in pairs(inventory) do
                if item.id == parsedName and (item.pt or 0) == pt and (item.sh or false) == sh then
                    local baseRAP = GetItemRAP(className, item)
                    local finalRAP = ApplyPriceModifier(baseRAP, cfg.Price)
                    table.insert(BoothQueue, {
                        Price = finalRAP,
                        UUID = uuid,
                        Item = item,
                        Rap = baseRAP,
                        Class = className,
                        MaxCfgAmount = cfg.Amount or 1
                    })
                end
            end
        end
    end

    -- Сортировка по RAP
    table.sort(BoothQueue, function(a, b) return a.Rap > b.Rap end)

    -- Выставление на продажу
    for _, v in ipairs(BoothQueue) do
        local maxAmount = math.min(v.Item._am or 1, v.MaxCfgAmount, 15000, math.floor(25e9 / v.Price))
        local result = Network.Invoke("Booths_CreateListing", v.UUID, math.ceil(v.Price), maxAmount)
        print(string.format("Выставлено: [%s] %s за %s x%d (успех: %s)", v.Class, v.Item.id, v.Price, maxAmount, tostring(result)))
        task.wait(1)
    end
end

