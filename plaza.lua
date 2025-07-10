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
local time = _G.Time_Update or 10
local mode = _G.Sell_Mode or "Random"
local Mail_Cost = 0
_G.Rejoin_Time = _G.Rejoin_Time or 20
local prefix = "PlayerScripts."

if Save.Get().Gamepasses.VIP == true then Mail_Cost = startMailCost else Mail_Cost = startMailCost * costGrowthRate^MailboxSendsSinceReset end

local BoothSlots = Save.Get().BoothSlots
local lastSuccessfulListing = os.time()
if game.PlaceId == 8737899170 then
    while task.wait(4) do
        Network.Invoke("Travel to Trading Plaza")
    end
end

    local rawList = [[
    Scripts.Game.Misc.World Animations.PlanetAnimations
    Scripts.Game.Trading Plaza Portal
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.Subtitle
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame
    Scripts.Game.Music
    Scripts.Game.Pets.Modifier VFX
    PlayerModule.CameraModule.OrbitalCamera
    Scripts.Game.Misc.Fantasy Transition TEMP
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui
    Scripts.Core.Voice Chat Trading Server
    Scripts.Game.Misc.World Animations.Balloons - Castle
    Scripts.GUIs.Boosts Panel V3.Types
    Scripts.GUIs.Prison Key Surge Sign
    Scripts.Game.Misc.World Animations
    Scripts.Game.Breakables.Damage Statistics Manager
    Scripts.Game.Misc.World Animations.Windmill Animation
    PlayerModule.ControlModule.DynamicThumbstick
    Scripts.GUIs.Boosts Panel V3.Modules.__BLUEPRINT
    Scripts.Game.Breakables
    PlayerModule.CameraModule.VRBaseCamera
    PlayerModule.ControlModule.TouchJump
    PlayerModule.CameraModule.VehicleCamera.VehicleCameraCore
    PlayerModule.ControlModule
    PlayerModule.CameraModule.BaseCamera
    Scripts.Game.Castle Door
    Scripts.Game.Misc.World Animations.Spike Animation
    Scripts.Game.My Guild Banner
    Scripts.GUIs.Boosts Panel V3.Modules.Capes
    Scripts.Game.Misc.World Animations.Door Glow Animation
    Scripts.Game.Physical Eggs Frontend
    Scripts.Core.Chat Nametags.Filters
    Scripts.Core.Idle Tracking
    PlayerModule.CommonUtils.ConnectionUtil
    Scripts.Game.Egg Opening Frontend
    Scripts.Game.Misc.Huge Event Billboard
    Scripts.Game.Upgrades Frontend
    PlayerModule.CameraModule.VehicleCamera.VehicleCameraConfig
    PlayerModule.CameraModule.VRVehicleCamera
    PlayerModule.ControlModule.TouchThumbstick
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.ProgressBar
    Scripts.Test.Test Riding
    Scripts.GUIs.Instances.BasketballCalendar
    Scripts.GUIs.Boosts Panel V3.Modules.Friends
    Scripts.Game.Time Trials
    Scripts.Game.Tower Tycoon Raffle Boards
    Scripts.Test.UI Resize Finder
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.Completed.UITextSizeConstraint
    PlayerModule.CameraModule.Invisicam
    Scripts.GUIs.World GUIs
    Scripts.Game.Machines.Item Index
    Scripts.Core.Custom Chat Filtering
    Scripts.GUIs.Boosts Panel V3
    PlayerModule.CameraModule.BaseOcclusion
    Scripts.Game.Misc.World Animations.Rainbow Road Animations
    Scripts.GUIs.Tower Players Billboard Gui
    PlayerModule.CameraModule.CameraToggleStateController
    Scripts.GUIs.Boosts Panel V3.Modules.Gamepasses
    Scripts.GUIs.Hype Eggs
    Scripts.GUIs.Boosts Panel V3.Modules.TowerXpDouble
    Scripts.Game.Breakables.Breakables Frontend
    Scripts.GUIs.Free Gifts
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.Subtitle.UIStroke
    PlayerModule.ControlModule.VehicleController
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.Title.UITextSizeConstraint
    Scripts.GUIs.Random Active Drops
    Scripts.Game.Misc.Egg Promo.Egg Billboard Pets Cards
    Scripts.Game.Misc.World Animations.Enchanted Lights Animation
    Scripts.Game.Misc.Prison World.Prison Doors
    Scripts.Game.Clan Castle Door
    Scripts.Game.Misc.World Animations.VIP Water Chests
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.ProgressBar.Bar.UIGradient
    Scripts.Game.Misc.Egg Promo
    Scripts.GUIs.Boosts Panel V3.Modules.Subscriptions
    Scripts.Game.Misc.World Animations.Castle Propeller Cat
    Scripts.Test.Test Message
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.ProgressBar.UICorner
    PlayerModule.CommonUtils.FlagUtil
    PlayerModule.CommonUtils.CameraWrapper
    PlayerModule.ControlModule.Gamepad
    Scripts.Core.Product Notifications
    Scripts.Game.Misc.World Animations.Toilet Cat Outhouse
    Scripts.Game.Items
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.ProgressBar.Bar.UIStroke
    Scripts.GUIs.Currency 2
    ParallelPetExport
    PlayerModule.ControlModule.BaseCharacterController
    Scripts.Game.Pets
    Parallel Pet Actors
    Scripts.GUIs.Trade Notification
    Scripts.Game.Machine Animations.Upgrade Presents Anim
    Scripts.GUIs.Teleports Map OLD
    Scripts.GUIs.Boosts Panel V3.Modules.FishingEvent
    PlayerModule.CameraModule.MouseLockController
    Scripts.Game.Water Detector
    PlayerModule.CameraModule.ClassicCamera
    Parallel Pet Actors.ParallelPet
    Scripts.Test.Memory Report
    Scripts.Test.Show Instance Counts
    Scripts.Test.Test Notifications
    Scripts.Game.Gamepasses
    Scripts.Test.Test Raid UI
    Scripts.Test.Print Damage Factor
    Scripts.Test.Test Exclamation
    Scripts.Test.Find Skinned Meshes
    Scripts.Game.Trading Plaza
    Scripts.Test.Test Rain
    Scripts.Test.Test Fireworks
    Scripts.Game.Enchants
    Scripts.Test.Test Confetti
    Scripts.Test.Disable Development UI On Boot
    Scripts.Test
    Scripts.Misc
    Scripts.Game.Farming.Farming Gift Notification
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.ProgressBar.UIStroke
    Scripts.Game.Pets.Modifier VFX.📖 README
    Scripts.Game.Misc.Prison World
    Scripts.GUIs.Boosts Panel V3.Modules.Rebirths
    Scripts.Test.MessageTesting
    Scripts.Game.Gates Frontend
    Scripts.Game.Machines.Tower AFK
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.Completed.UIStroke
    PlayerModule.CameraModule.CameraInput
    Scripts.Game.Misc.Rebirth VFX
    PlayerModule
    Scripts.Game.Events.Basketball
    Scripts.Game.Farming
    PlayerModule.CameraModule
    Scripts.Game.Misc.World Animations.PlanetAnimationsOLD
    Scripts.Game.Misc.World Animations.Disco Bulbs AnimationOLD
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.ProgressBar.Bar
    Scripts.GUIs.Boosts Panel V3.Modules.SaturdayBuff
    Scripts.Game.Misc.World Animations.Balloons
    Scripts.Test.Disable Player List Menu
    Scripts.Game.Misc.World Animations.Gate Countdown
    Scripts.GUIs.Instances
    Scripts.Game.Machines.Doodle Upgrade Machine
    Scripts.GUIs.Boosts Panel V3.Modules.Effects
    Scripts.GUIs.Boosts Panel V3.Modules.Boost Exchange
    Scripts.Game.Egg Opening Frontend.EggPositions
    Scripts.Game.Misc.World Animations.Lighthouse Animation
    Scripts.Game.Doodle World.Doodle Jar
    Scripts.GUIs.PETS GO Countdown
    Scripts.Game.Doodle World
    Scripts.Game.Raffles
    PlayerModule.ControlModule.PathDisplay
    Scripts.Game.Misc.Egg Promo.Egg Pets Farming
    Scripts.Game.Misc.Egg Promo.Monday Pets Fantasy
    Scripts.Game.Misc.World Animations.Window Glow Animation
    Scripts.Game.Random Events
    Scripts.Game.Misc.Notification Prompt
    PlayerModule.CameraModule.Poppercam
    Scripts.GUIs.Boosts Panel V3.BasketballEvent
    Scripts.Game.Physical Eggs Frontend.LuckModifiers
    Scripts.GUIs.Boosts Panel V3.Modules.Fruit
    PlayerModule.ControlModule.ClickToMoveDisplay
    Scripts.Game.Top Guild Banner
    PlayerModule.CameraModule.CameraUI
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.Completed
    Scripts.Core.Chat Nametags
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.UIListLayout
    PlayerModule.CameraModule.VRCamera
    PlayerModule.CameraModule.TransparencyController
    Scripts.GUIs.Boosts Panel V3.Modules.FactoryPoints
    Scripts.Game.Events.Hacker.UFO Invasion
    Scripts.Game.Events.Hacker
    Scripts.Game.Events.Obby.Summer Event Notification
    Scripts.Game.Events
    PlayerModule.CommonUtils
    PlayerModule.CameraModule.VehicleCamera
    PlayerModule.CameraModule.LegacyCamera
    Scripts.Game.Ultimates
    Scripts.Game.Trading Plaza.Main Game Portal
    Scripts.Game.Mastery (Square Version)
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.Title.UIStroke
    Scripts.Game.ForeverPacks
    Scripts.GUIs.Ranks.Sound
    Scripts.Game.Worlds.Olympus World
    Scripts.Game.Race Rewards
    Scripts.Game.Breakable VFX (Enchants, etc.)
    Scripts.Game.Machine Animations.Pickaxe Machine Anim
    Scripts.Game.Machine Animations
    Scripts.Game.Instancing
    Scripts.Game.Worlds.Obby World
    Scripts.GUIs
    Scripts.Game.Misc.Potato Mode Setting
    Scripts.GUIs.Boosts Panel V3.Modules.Potions
    Scripts.GUIs.Egg Deal
    Scripts.Game.Machines
    Scripts.Game.Worlds
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.ProgressBar.Bar.UICorner
    PlayerModule.CommonUtils.CharacterUtil
    Scripts.Game.Machines.Fantasy Shard Machine
    Scripts.GUIs.Ranks
    Scripts.Game.Misc.Favorite Prompt
    Scripts.GUIs.New Player Tasks
    Scripts.Game.Misc.Instances
    Scripts.Game.Events.Farming
    Scripts.Game
    Scripts.GUIs.Zone Progress Bar
    Scripts.Game.Misc
    Scripts.Core.Controller
    Scripts.Game.Guild Chat (Hide Locally)
    PlayerModule.ControlModule.VRNavigation
    Scripts.Game.Tower Tycoon Raffle Boards.TicketSelector
    Scripts.GUIs.Chat Filters
    Scripts.Game.Scary Pet
    Scripts
    Scripts.Game.ForeverPacks.Lucky Pack
    Scripts.Game.Machines.Vending Machines
    Scripts.Game.Misc.World Animations.Preston Shop
    PlayerModule.ControlModule.ClickToMoveController
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.Subtitle.UITextSizeConstraint
    PlayerModule.CameraModule.ZoomController
    Scripts.Game.Misc.World Animations.Door Cats NPC
    Scripts.Core.Disable Chat on Join
    PlayerModule.ControlModule.Keyboard
    Scripts.GUIs.Boosts Panel V3.Modules.Buffs
    Scripts.GUIs.Boosts Panel V3.Modules
    Scripts.Game.Misc.Instances.MillionaireRun
    PlayerModule.CameraModule.CameraUtils
    Scripts.GUIs.Ultimates HUD
    Scripts.Game.Misc.Tutorial
    PlayerModule.CameraModule.ZoomController.Popper
    Scripts.Game.Misc.World Animations.Castle Cat NPC
    Scripts.Test.Test Award Notif
    Scripts.Core.Disable PlaySolo Chat
    Scripts.GUIs.Monetization.Free Huge
    Scripts.Game.Misc.World Animations.Sandcastle Flag Animation
    Scripts.Game.Events.Obby
    Scripts.GUIs.Tower Players Billboard Gui.BillboardGui.Frame.Title
    Scripts.Core
    Scripts.Game.Misc.World Animations.The Hacker Cubes
    Scripts.GUIs.Monetization
    Scripts.GUIs.Boosts Panel V3.Modules.Guilds
    ]]

    local excludedPaths = {}
    for line in rawList:gmatch("[^\r\n]+") do
        excludedPaths[prefix .. line] = true
    end
    local function getPathFrom(root, obj)
        local path = obj.Name
        local parent = obj.Parent
        while parent and parent ~= root do
            path = parent.Name .. "." .. path
            parent = parent.Parent
        end
        return parent == root and "PlayerScripts." .. path or nil
    end
    local function DestroyFiltered(root)
        for _, obj in ipairs(root:GetDescendants()) do
            local relativePath = getPathFrom(root, obj)
            if relativePath and not excludedPaths[relativePath] then
                pcall(function() obj:Destroy() end)
                task.wait()
            end
        end
    end

    

local function simplifyObject(obj)
    local simpleTextureId = "rbxassetid://0"

    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam")
    or obj:IsA("Smoke")
    or obj:IsA("Fire")
    or obj:IsA("Sparkles")
    or obj:IsA("Explosion")
    or obj:IsA("Light")
    or obj:IsA("PointLight")
    or obj:IsA("SpotLight")
    or obj:IsA("SurfaceLight") then
        pcall(function() obj:Destroy() end)

    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        pcall(function()
            obj.Texture = simpleTextureId
            obj.Transparency = 1
        end)

    elseif obj:IsA("SurfaceAppearance") then
        pcall(function() obj:Destroy() end)

    elseif obj:IsA("MeshPart") then
        pcall(function()
            obj.TextureID = ""
            obj.Material = Enum.Material.Plastic
            obj.Transparency = 1
        end)

    elseif obj:IsA("BasePart") then
        pcall(function()
            obj.Material = Enum.Material.Plastic
            obj.Transparency = 1
            obj.Reflectance = 0
        end)
    end
end

local function simplifyVisuals()
    local processed = 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        simplifyObject(obj)
        processed += 1
        if processed % 1000 == 0 then
            task.wait(0.1)
        end
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
					"\nBuff Gym Gifts: " .. arg3,
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
	local save = Save.Get()
	local huge, gift, event1 = 0, 0, 0

	for _, v in pairs(save.Inventory.Pet or {}) do
		if v.id:find("Huge") then huge += 1 end
	end
	for _, v in pairs(save.Inventory.Lootbox or {}) do
		if v.id == "Buff Gym Gift" then
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

	if string.find(parsed, "Shiny") then
		sh = true
		parsed = parsed:gsub("Shiny%s*", "") 
	end
	if string.find(parsed, "Golden") then
		pt = 1
		parsed = parsed:gsub("Golden%s*", "")
	elseif string.find(parsed, "Rainbow") then
		pt = 2
		parsed = parsed:gsub("Rainbow%s*", "")
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

if _G.Optimization then 
    simplifyVisuals() 
    task.wait(5)
    DestroyFiltered(LocalPlayer:WaitForChild("PlayerScripts"))
end
task.wait(3)

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
    workspace.DescendantAdded:Connect(function(obj)
        task.defer(function()
            simplifyObject(obj)
        end)
    end)
end)
task.wait()

task.spawn(function()
	while task.wait(time * 60) do
		pcall(checkInventory)
	end
end)
task.wait()
task.spawn(function()
    while task.wait(60) do
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Claim All"):InvokeServer()
    end
end)
task.wait()
task.spawn(function()
    while task.wait(60) do
        local gems, id
        for index, v in pairs(Save.Get().Inventory.Currency or {}) do
            if v.id == "Diamonds" then
                gems = v._am
                id = index
                break
            end
        end
        if gems and (gems + Mail_Cost > _G.Gems_mail) then
            repeat
                gems = 0
                for _, v in pairs(Save.Get().Inventory.Currency or {}) do
                    if v.id == "Diamonds" then
                        gems = v._am
                        break
                    end
                end
                local args = {
                    [1] = _G.User,
                    [2] = "thanks for gift",
                    [3] = "Currency",
                    [4] = id,
                    [5] = gems - Mail_Cost
                }
                local response = false
                task.wait(1)
                response = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
            until response == true
        end
    end
end)
task.wait()
task.spawn(function()
    while true do
        task.wait(60) -- проверка каждую минуту

        local timeSinceLast = os.time() - lastSuccessfulListing
        if timeSinceLast > (_G.Rejoin_Time * 60) then
            print("🔁 No listings in last " .. _G.Rejoin_Time .. " minutes. Rejoining...")

            local TeleportService = game:GetService("TeleportService")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer

            local HttpService = game:GetService("HttpService")
            local success, servers = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(
                    "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
                ))
            end)

            if success and servers and servers.data then
                for _, server in ipairs(servers.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                        return
                    end
                end
            end

            TeleportService:Teleport(game.PlaceId)
            return
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
                local match = false

                if fullName == "All Huges" then
                    match = className == "Pet" and item.id:find("Huge")
                else
                    match = item.id == parsedName and (item.pt or 0) == pt and (item.sh or false) == sh
                end

                if match then
                    local baseRAP = GetItemRAP(className, item)
                    if not baseRAP or baseRAP == 0 then
                        baseRAP = 10000000000
                    end

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
        local maxAmount = math.min(v.Item._am or 1, v.MaxCfgAmount, math.floor(25e9 / v.Price))

        repeat
            task.wait(1)
        until #Save.Get().BoothRecovery < BoothSlots

        local result = Network.Invoke("Booths_CreateListing", v.UUID, math.ceil(v.Price), maxAmount)
        if result == true then
            print("Listing success")
            lastSuccessfulListing = os.time()
        elseif type(result) == "table" and type(result[1]) == "string" then
            print("✅ Listing success:", result[1])
            lastSuccessfulListing = os.time()
        else
            print("❌ Listing failed or empty result. Got:", typeof(result), result)
        end


        task.wait(3) 
    end

end
