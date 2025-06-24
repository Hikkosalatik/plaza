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
local VirtualUser = game:GetService("VirtualUser")
local MailboxSendsSinceReset = Save.MailboxSendsSinceReset
local costGrowthRate = require(game:GetService("ReplicatedStorage").Library.Types.Mailbox).DiamondCostGrowthRate
local startMailCost = require(game:GetService("ReplicatedStorage").Library.Balancing.Constants).MailboxDiamondCost
repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
local webhook = _G.URL
local time = _G.TIME_UPDATE or 10
local mode = _G.Sell_Mode or "Random"
local Mail_Cost = 0
if Save.Get().Gamepasses.VIP == true then Mail_Cost = startMailCost else Mail_Cost = startMailCost * costGrowthRate^MailboxSendsSinceReset end

if game.PlaceId == 8737899170 then
    while task.wait(4) do
        Network.Invoke("Travel to Trading Plaza")
    end
end

local function shortenNumber(n)
	if n >= 1e12 then
		return string.format("%.2fT", n / 1e12)
	elseif n >= 1e9 then
		return string.format("%.2fB", n / 1e9)
	elseif n >= 1e6 then
		return string.format("%.2fM", n / 1e6)
	elseif n >= 1e3 then
		return string.format("%.2fK", n / 1e3)
	else
		return tostring(n)
	end
end

local function sendWebhook(arg1,arg2,arg3)
	local data = {
		['content'] = 'Update every '.. time .. ' minutes',
		["embeds"] = {{        
			title = LocalPlayer.Name ..
                    "\nHuges: " .. arg1 .. 
					"\nGems: " .. arg2 ..
					"\nMagma Gifts: " .. arg3,
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
	local huge, gift, event1 = 0, 0, 0

	for _, v in pairs(save.Inventory.Pet or {}) do
		if v.id:find("Huge") then huge += 1 end
	end
	for _, v in pairs(save.Inventory.Lootbox or {}) do
		if v.id == "Magma Tower Defense Gift" then
			gift = v._am or 1
		end
	end
	for _, v in pairs(save.Inventory.Currency or {}) do
		if v.id == "Diamonds" then event1 = shortenNumber(v._am) end
	end

	sendWebhook(huge, event1, gift)
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

for _, v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end
LocalPlayer.Idled:Connect(function() VirtualUser:ClickButton2(Vector2.new(math.random(0, 1000), math.random(0, 1000))) end)

old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() then
        local Name = tostring(self)
        if table.find({"Server Closing", "Idle Tracking: Update Timer", "Move Server"}, Name) then
            return nil
        end
    end
    return old(self, ...)
end)
Network.Fire("Idle Tracking: Stop Timer")

task.spawn(function()
	while task.wait(time * 60) do
		pcall(checkInventory)
	end
end)

task.spawn(function()
    while task.wait(60) do
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Claim All"):InvokeServer()
    end
end)

task.spawn(function()
    while task.wait(60) do
        local gems
        local id
        for _, v in pairs(save.Inventory.Currency or {}) do
		    if v.id == "Diamonds" then 
                gems = v._am 
                id = _
                break
            end
        end
        if gems+Mail_Cost > _G.Gems_mail then
            local args = {
                [1] = _G.User,
                [2] = "thanks for gift",
                [3] = "Currency",
                [4] = id,
                [5] = gems-Mail_Cost
            }
            local response = false
            repeat
                response = Network:WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
            until response == true
        end
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

    if mode == "Maximize" then
	    table.sort(BoothQueue, function(a, b) return a.Rap > b.Rap end)
    elseif mode == "Minimize" then
	    table.sort(BoothQueue, function(a, b) return a.Rap < b.Rap end)
    elseif mode == "Random" then
	    local function shuffle(t)
		    for i = #t, 2, -1 do
			    local j = math.random(i)
			    t[i], t[j] = t[j], t[i]
		    end
	    end
	    shuffle(BoothQueue)
    end

    for _, v in ipairs(BoothQueue) do
        local maxAmount = math.min(v.Item._am or 1, v.MaxCfgAmount, 15000, math.floor(25e9 / v.Price))
        local result = Network.Invoke("Booths_CreateListing", v.UUID, math.ceil(v.Price), maxAmount)
        task.wait(4)
    end
end
