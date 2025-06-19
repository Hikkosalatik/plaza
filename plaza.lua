repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library")
local Client = Library:WaitForChild("Client")
local Save = require(Client:WaitForChild("Save"))
local RAPCmds = require(Client:WaitForChild("RAPCmds"))
local Network = require(Client:WaitForChild("Network"))
local HttpService = game:GetService("HttpService")

local webhook = _G.URL
local time = _G.TIME_UPDATE or 10

if game.PlaceId == 8737899170 then
    while task.wait(4) do
        Network.Invoke("Travel to Trading Plaza")
    end
end

local function sendWebhook(arg1,arg2,arg3,arg4,arg5)
	local data = {
		['content'] = 'Update every '.. time .. ' minutes',
		["embeds"] = {{
			title = "Huges: " .. arg1 .. 
					"\nNuclear Dominus: " .. arg2 ..
					"\nNightmare Cyclops: " .. arg3 ..
					"\nArcade Angelus: " .. arg4 ..
					"\nGifts: " .. arg5,
			footer = { text = "Made by Hikko" }
		}}
	}
	local newdata = HttpService:JSONEncode(data)
	local headers = {["content-type"] = "application/json"}
	local requestFunc = http_request or request or HttpPost or syn.request
	if requestFunc then
		requestFunc({Url = webhook, Body = newdata, Method = "POST", Headers = headers})
	end
end

local function checkInventory()
	local save = require(game.ReplicatedStorage.Library.Client.Save).Get()
	local huge, gift, event1, event2, event3 = 0, 0, 0, 0, 0

	for _, v in pairs(save.Inventory.Pet or {}) do
		if v.id:find("Huge") then huge += 1 end
	end
	for _, v in pairs(save.Inventory.Lootbox or {}) do
		if v.id == "Tower Defense Gift" then
			gift = v._am or 1
		end
	end
	for _, v in pairs(save.Inventory.Tower or {}) do
		if v.id == "Nuclear Dominus" then event1 += 1 end
		if v.id == "Nightmare Cyclops" then event2 += 1 end
		if v.id == "Arcade Angelus" then event3 += 1 end
	end

	sendWebhook(huge, event1, event2, event3, gift)
end


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

local function GetItemRAP(Class, ItemData)
    local ItemModule = require(Library.Items[Class .. "Item"])
    local Item = ItemModule(ItemData.id)

    if ItemData.sh then Item:SetShiny(true) end
    if ItemData.pt == 1 then Item:SetGolden()
    elseif ItemData.pt == 2 then Item:SetRainbow() end
    if ItemData.tn then Item:SetTier(ItemData.tn) end

    return RAPCmds.Get(Item) or 0
end

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

task.spawn(function()
	while task.wait(time * 60) do
		pcall(checkInventory)
	end
end)

task.spawn(function()
    task.wait(30)
    while task.wait(60) do
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Claim All"):InvokeServer()
    end
end)

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

    table.sort(BoothQueue, function(a, b) return a.Rap > b.Rap end)

    for _, v in ipairs(BoothQueue) do
        local maxAmount = math.min(v.Item._am or 1, v.MaxCfgAmount, 15000, math.floor(25e9 / v.Price))
        local result = Network.Invoke("Booths_CreateListing", v.UUID, math.ceil(v.Price), maxAmount)
        task.wait(4)
    end
end

