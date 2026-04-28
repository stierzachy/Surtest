--[[
    // NOTE \\
SUR SCRIPT OPEN SOURCE 
BY mituma.xyz
]]


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local backpack = player:WaitForChild("Backpack")

if game:GetService("Players").LocalPlayer.PlayerGui.MenuGUI.Enabled then
local player = game:GetService("Players").LocalPlayer
local menuGui = player.PlayerGui:WaitForChild("MenuGUI")
local playButton = menuGui:WaitForChild("Play")

local connections = getconnections(playButton.MouseButton1Click)
for _, connection in pairs(connections) do
connection.Function()
end
end

_G.MyName = tostring(player.Name)


local azrlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MITUMAxDev/Azurium/main/Library/Source.lua"))()

local Window = azrlib:MakeWindow({
  "Azurium HUB | Stand Upright Rebooted",
  "by mituma",
  "azurium-hub-sur.json"
})

Window:AddMinimizeButton({
  Button = {
    Image = "rbxassetid://103208753702759", BackgroundTransparency = 0
  },
  Corner = {
    CornerRadius = UDim.new(0, 6)}
})

local MainTab = Window:MakeTab({
  "Main Farming", "lucide-home"
})
local StandTab = Window:MakeTab({
  "Stand Farming", "lucide-ghost"
})
local DungeonTab = Window:MakeTab({
  "Dungeon Farming", "lucide-skull"
})
local CombatTab = Window:MakeTab({
  "Combat", "lucide-swords"
})
local Credit = Window:MakeTab({
  "Credits", "User"
})

local function safeCall(func, ...)
local success, result = pcall(func, ...)
if not success then
warn("Error in function call: " .. tostring(result))
end
return success, result
end

local function Attack()
pcall(function()
  game:GetService("Players").LocalPlayer.Character.StandEvents.M1:FireServer()
  end)
end

local function NewAttack()
pcall(function()
  local args = {
    [1] = {
      ["State"] = "Begin",
      ["Type"] = Enum.UserInputType.MouseButton1,
      ["Key"] = Enum.KeyCode.Unknown
    }
  }

  game:GetService("Players").LocalPlayer.Character.StandEvents.Input:FireServer(unpack(args))
  end)
end

local function Barrage()
pcall(function()
  local args = {
    [1] = true
  }

  game:GetService("Players").LocalPlayer.Character.StandEvents.Barrage:FireServer(unpack(args))
  end)
end

local function BarrageNew()
pcall(function()
  local args = {
    [1] = {
      ["State"] = "Begin",
      ["Type"] = Enum.UserInputType.Touch,
      ["Key"] = Enum.KeyCode.E
    }
  }

  game:GetService("Players").LocalPlayer.Character.StandEvents.Input:FireServer(unpack(args))
  end)
end


local function PressKey(key)
game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[key], false, game)
end


local function SummonStand()
pcall(function()
  PressKey('Q')
  end)
end

local function InteractNearest()
local rootPart = player.Character:WaitForChild("HumanoidRootPart")
local nearestNPC, shortestDistance = nil, math.huge
local maxDistance = 20

for _, npc in pairs(workspace.Map.NPCs:GetChildren()) do
if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and npc.Name == "i_stabman" then
local distance = (rootPart.Position - npc.HumanoidRootPart.Position).magnitude
if distance < shortestDistance and distance <= maxDistance then
nearestNPC, shortestDistance = npc, distance
end
end
end

local remoteEvent = nearestNPC and nearestNPC:FindFirstChild("Done")
if remoteEvent and remoteEvent:IsA("RemoteEvent") then
remoteEvent:FireServer()
end
end

local function updateStand()
local standGui = playerGui:WaitForChild("newStatsGUI"):WaitForChild("StatsMenu"):WaitForChild("StandName"):WaitForChild("_Background"):WaitForChild("TextLabel")
local attributeGui = playerGui:WaitForChild("newStatsGUI"):WaitForChild("StatsMenu"):WaitForChild("AttributeName"):WaitForChild("_Background"):WaitForChild("TextLabel")

_G.CurrentStand = standGui.Text:match("Stand: (.+)") or "None"
_G.CurrentAttribute = attributeGui.Text:match("Attribute: (.+)") or "None"
end

local function UseItem()
safeCall(function()
  ReplicatedStorage.Events.UseItem:FireServer()
  end)
end

local function Equip(ItemName)
pcall(function()
  local backpack = player:FindFirstChild("Backpack")
  if not backpack then return end

  local EquipItem = backpack:FindFirstChild(ItemName)
  if not EquipItem then return end

  local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
  if not humanoid then return end

  humanoid:EquipTool(EquipItem)
  end)
end



local function checkStand()
return table.find(_G.SelectedStands, _G.CurrentStand) ~= nil
end

local function checkAttribute()
return table.find(_G.SelectedAttributes, _G.CurrentAttribute) ~= nil
end

local function sendStandNotification()
if not _G.Webhook then
warn("Webhook URL is not set.")
return
end

local requestfunc = syn and syn.request or request or http_request or http.request or fluxus and fluxus.request or game.HttpGet

safeCall(function()
  requestfunc({
    Url = _G.Webhook,
    Method = 'POST',
    Headers = {
      ['Content-Type'] = 'application/json'
    },
    Body = HttpService:JSONEncode({
      ["username"] = "Azurium | Stand Farming",
      ["avatar_url"] = "https://media.discordapp.net/attachments/1261133634472247379/1293827174125801514/d58e721c-4d8c-44f7-9061-d808375e3d6b.png?ex=6708c9f4&is=67077874&hm=359ae4f79c56d6e94296ff6ac80f7fee0e1893fa8e26451d146af3cb90f4b152&",
      ["content"] = "<a:notif:1247922324934754345> @everyone",
      ["embeds"] = {{
        ["title"] = "<:roblox:1124836342363336784> User : ||" .. player.DisplayName .. "(@" .. player.Name .. ")||",
        ["color"] = tonumber(0xFF0000),
        ["description"] = "## You've got Selected Stand" .. "\n### <a:animejojo:1089912812173787268> Stand : " .. (_G.CurrentStand or "Unknown Stand") .. "\n###  <:strong_doge:1130407113290686474> Attribute : " .. (_G.CurrentAttribute or "Unknown Attribute"),
        ["image"] = {
          ["url"] = "https://media.discordapp.net/attachments/1261133634472247379/1293772076183978064/6c2d236b4ea89f66ab84e4f6404579e0.gif?ex=670896a4&is=67074524&hm=dd2002c9b84ea47bc8da5584cde97b688696e048411b97414a180fdaa2c21a0d&"
        }
      }}
    })
  })
  end)
end

local HttpService = game:GetService("HttpService")
local LeftArrow = 0

local function GetAmount(item)
    local success, result = pcall(function()
        local me = game:GetService("Players").LocalPlayer
        if me then
            local backpack = me:FindFirstChild("Backpack")
            if backpack then
                local itemfind = backpack:FindFirstChild(item)
                if itemfind then
                    return itemfind:GetAttribute("ItemAmount") or 0
                end
            end
        end
        return 0
    end)
    return success and result or 0
end

local function sendStandLog()
    if not _G.Webhook then
        warn("Webhook URL is not set.")
        return
    end

    local requestfunc = syn and syn.request or request or http_request or http.request or fluxus and fluxus.request or game.HttpGet
    LeftArrow = GetAmount(_G.SFArrow)

    pcall(function()
        requestfunc({
            Url = _G.Webhook,
            Method = 'POST',
            Headers = {
                ['Content-Type'] = 'application/json'
            },
            Body = HttpService:JSONEncode({
                ["username"] = "Azurium | Stand Farming",
                ["avatar_url"] = "https://media.discordapp.net/attachments/1261133634472247379/1293827174125801514/d58e721c-4d8c-44f7-9061-d808375e3d6b.png?ex=6708c9f4&is=67077874&hm=359ae4f79c56d6e94296ff6ac80f7fee0e1893fa8e26451d146af3cb90f4b152&",
                ["content"] = "You've got **" .. (_G.CurrentAttribute or "Unknown Attribute") .. "** " .. (_G.CurrentStand or "Unknown Stand") .. "\n-# Removed, " .. (_G.SFArrow or "Arrow") .." Left: x" .. LeftArrow
            })
        })
    end)
end

task.spawn(function()
  pcall(function()
    while task.wait() do
      if _G.SFArrow then 
        local LeftArrow = GetAmount(_G.SFArrow)
      end
    end
  end)
end)


local StandList = {
  "Aerosmith", "Crazy Diamond", "Cream", "D4C", "DIO's The World", "Diver Down", "Golden Experience",
  "Hierophant Green", "Jotaro's Star Platinum", "Killer Queen", "King Crimson", "Magicians Red",
  "Premier Macho", "Purple Smoke", "Putrid Whine", "Silver Chariot", "Silver Chariot OVA",
  "Soft And Wet", "Star Platinum", "Star Platinum OVA", "Star Platinum Stone Ocean", "Sticky Fingers",
  "The Emperor", "The Hand", "The World", "The World Alternate Universe", "The World OVA",
  "Tusk Act 1", "Weather Report", "White Snake"
}

local AttributeList = {
  "None", "Strong", "Tough", "Sloppy", "Powerful", "Manic", "Enrage", "Lethargic", "Godly",
  "Daemon", "Glass Cannon", "Invincible", "Scourge", "Tragic", "Hacker", "Legendary"
}

local ModeList = {
  "Stand Only", "Attribute Only", "Stand or Attribute", "Stand and Attribute"
}

local ArrowList = {
  "Stand Arrow", "Charged Arrow", "Kars Mask"
}

local SectionStandSelect = StandTab:AddSection({
  "// Stand Farm Settings //"
})

StandTab:AddDropdown({
  Name = "Select Stand Farming",
  Description = "Select stands that you need",
  Options = StandList,
  Default = {},
  Flag = "StandSelect",
  MultiSelect = true,
  Callback = function(selected)
  _G.SelectedStands = {}
  for i, v in pairs(selected) do
  if v then
  table.insert(_G.SelectedStands, i)
  end
  end
  end
})

StandTab:AddDropdown({
  Name = "Select Attribute Farming",
  Description = "Select attributes that you need",
  Options = AttributeList,
  Default = {},
  Flag = "AttriSelect",
  MultiSelect = true,
  Callback = function(selected)
  _G.SelectedAttributes = {}
  for i, v in pairs(selected) do
  if v then
  table.insert(_G.SelectedAttributes, i)
  end
  end
  end
})

StandTab:AddDropdown({
  Name = "Select Arrow",
  Description = "Select Arrow that you want to use",
  Options = ArrowList,
  Default = _G.SFArrow,
  Flag = "SFArrow",
  MultiSelect = false,
  Callback = function(selected)
  _G.SFArrow = selected
  end
})

StandTab:AddDropdown({
  Name = "Select Stand Farm Mode",
  Description = "Select Mode for farming stand",
  Options = ModeList,
  Default = _G.SFMode,
  Flag = "Mode",
  MultiSelect = false,
  Callback = function(selected)
  _G.SFMode = selected
  end
})

local SectionFarmStand = StandTab:AddSection({
  "// Auto Farm Stand //"
})

local AutoStandToggle = StandTab:AddToggle({
  Name = "Auto Farm Stand",
  Default = false,
  Flag = "AutoStand",
  Callback = function(state)
  _G.AutoStand = state
  end
})

local CheckSection = StandTab:AddSection({
  "// Check Selected //"
})

StandTab:AddButton({
  Name = "Check Selected Stands",
  Callback = function()
  print("--------------- [ Selected Stands ] ---------------")
  for i, v in pairs(_G.SelectedStands) do
  print(i, v)
  end
  end
})

StandTab:AddButton({
  Name = "Check Selected Attribute",
  Callback = function()
  print("--------------- [ Selected Attributes ] ---------------")
  for i, v in pairs(_G.SelectedAttributes) do
  print(i, v)
  end
  end
})

StandTab:AddButton({
  Name = "Open Console (Check Print List)",
  Callback = function()
  game:GetService("VirtualInputManager"):SendKeyEvent(true,Enum.KeyCode.F9,false,game)
  end
})

local SectionHook = StandTab:AddSection({
  "// Discord Webhook //"
})
local function ensurePath()
    local folderPath = "AzuriumSave/StandUpright"
    local filePath = folderPath .. "/webhook.txt"

    if not isfolder(folderPath) then
        makefolder(folderPath)
    end

    if not isfile(filePath) then
        writefile(filePath, "")
    end

    return filePath
end

local function saveWebhook(link)
    local filePath = ensurePath()
    local success, errorMsg = pcall(function()
        writefile(filePath, link)
    end)
    if not success then
        warn("Failed to save webhook: " .. errorMsg)
    end
end

local function loadWebhook()
    local filePath = ensurePath()
    local success, result = pcall(function()
        return readfile(filePath)
    end)
    if not success then
        warn("Failed to load webhook: " .. result)
        return nil
    end
    return result ~= "" and result or nil
end

_G.Webhook = loadWebhook()

local placeholderText = _G.Webhook and "Using Saved Webhook" or "Enter your webhook here"

local WebhookEnter = StandTab:AddTextBox({
    Name = "Webhook Link",
    Description = "Discord webhook",
    Default = _G.Webhook,
    PlaceholderText = placeholderText,
    Callback = function(link)
        _G.Webhook = link
        saveWebhook(link)
    end
})



local AutoHook = StandTab:AddToggle({
  Name = "Auto Send Webhook",
  Default = false,
  Flag = "AutoHook",
  Callback = function(state)
  _G.AutoSendHook = state
  end
})

local StandLog = StandTab:AddToggle({
  Name = "Send Stand Logs",
  Default = false,
  Flag = "AutoLog",
  Callback = function(state)
  _G.StandLog = state
  end
})

_G.DefaultSafePos = "-103.573524, 44.4639778, 399.847931, -0.999902606, -8.44959103e-10, 0.0139545342, -1.53468693e-09, 1, -4.94160801e-08, -0.0139545342, -4.94326819e-08, -0.999902606"

_G.StoragePos = "3323.82861, 97.4779434, -156.192719, -0.285883605, -4.80745186e-08, 0.958264351, 3.1625401e-08, 1, 5.96032841e-08, -0.958264351, 4.73450967e-08, -0.285883605"

local function StringToCFrame(str)
local components = {}
for num in string.gmatch(str, "[^,]+") do
table.insert(components, tonumber(num))
end
return CFrame.new(unpack(components))
end

local function CFrameToString(cf)
local components = {
  cf:GetComponents()}
return table.concat(components, ", ")
end

_G.SafePos = _G.SafePos or _G.DefaultSafePos

local SectionSafeZone = StandTab:AddSection({
  "// Safe Zone //"
})

StandTab:AddButton({
  Name = "Go to Safe Position",
  Callback = function()
  game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = StringToCFrame(_G.SafePos)
  end
})

StandTab:AddButton({
  Name = "Set New Safe Position",
  Callback = function()
  _G.SafePos = CFrameToString(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
  end
})

StandTab:AddButton({
  Name = "Reset Safe Position",
  Callback = function()
  _G.SafePos = _G.DefaultSafePos
  end
})

StandTab:AddButton({
  Name = "Go to Stand Storage",
  Callback = function()
  game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = StringToCFrame(_G.StoragePos)
  end
})

local RemoteSec = StandTab:AddSection({
  "// Misc //"
})

local OpenStorage = StandTab:AddButton({
  Name = "Open Stand Storage"
})
OpenStorage:Callback(function()
  workspace.Map.NPCs.admpn.Done:FireServer()
  end)

local DungeonList = {
  "Level 15+", "Level 40+", "Level 80+", "Level 100+", "Level 200+"
}

local SectionDG = DungeonTab:AddSection({
  "// Auto Farm Dungeon //"
})

DungeonTab:AddDropdown({
  Name = "Select Dungeon",
  Description = "Select Dungeon that you need to farm",
  Options = DungeonList,
  Default = {},
  Flag = "SelectDungeon",
  MultiSelect = false,
  Callback = function(Value)
  _G.Dungeon = Value
  end
})

local TGDungeon = DungeonTab:AddToggle({
  Name = "Auto Farm Dungeon",
  Default = false,
  Flag = "AutoDungeon",
  Callback = function(state)
  _G.AutoDungeon = state
  end
})

DungeonTab:AddToggle({
  Name = "Clear Dungeon Minion",
  Default = false,
  Flag = "AutoMinionDungeon",
  Callback = function(state)
  _G.AutoClearMinion = state
  end
})

task.spawn(function()
    local standLogSent = false

    while true do
        local myCharacter = player.Character or player.CharacterAdded:Wait()
        local myHumanoid = myCharacter:FindFirstChild("Humanoid") or myCharacter:WaitForChild("Humanoid", 5)
        if not myHumanoid or myHumanoid.Health <= 0 then
            repeat
                task.wait(0.1)
                myCharacter = player.Character or player.CharacterAdded:Wait()
                myHumanoid = myCharacter:FindFirstChild("Humanoid") or myCharacter:WaitForChild("Humanoid", 5)
            until myHumanoid and myHumanoid.Health > 0
            task.wait(0.5)
        end

        if _G.AutoStand then
            local success, errorMsg = pcall(function()
                updateStand()
                local shouldStop = false

                if _G.SFMode == "Stand Only" then
                    shouldStop = checkStand()
                elseif _G.SFMode == "Attribute Only" then
                    shouldStop = checkAttribute()
                elseif _G.SFMode == "Stand or Attribute" then
                    shouldStop = checkStand() or checkAttribute()
                elseif _G.SFMode == "Stand and Attribute" then
                    shouldStop = checkStand() and checkAttribute()
                end

                if shouldStop then
                    _G.AutoStand = false
                    AutoStandToggle:Set(false)
                    if _G.AutoSendHook then
                        sendStandNotification()
                    end
                    return
                end

                if _G.CurrentStand == "None" then
                    Equip(_G.SFArrow)
                    standLogSent = false
                else
                    Equip("Rokakaka")
                    task.wait(0.5)
                end

                if _G.StandLog and not shouldStop and _G.CurrentStand ~= "None" and not standLogSent then
                    sendStandLog()
                    standLogSent = true
                end

                UseItem()
                task.wait(0.3)
            end)

            if not success then
                warn("Error in AutoStand loop: " .. errorMsg)
            end
        else
            standLogSent = false
            task.wait(0.3)
        end
    end
end)




player.Idled:Connect(function()
  VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
  wait(1)
  VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
  end)

local TeleportService = game:GetService("TeleportService")
local promptOverlay = game.CoreGui:WaitForChild('RobloxPromptGui'):WaitForChild('promptOverlay')

promptOverlay.ChildAdded:Connect(function(child)
  if child.Name == 'ErrorPrompt' then
  local success
  while true do
  success = pcall(function()
    TeleportService:Teleport(game.PlaceId)
    end)

  if success then
  break
  end

  wait(2) 
  end
  end
  end)

---- [[ MAIN TAB ]] ----

local SectionFarmLevel = MainTab:AddSection({
  "// Auto Farm Level //"
})

local SlideRange = MainTab:AddSlider({
  Name = "Farm Range Slider",
  Min = 1,
  Max = 20,
  Increase = 1,
  Default = 5,
  Callback = function(value)
  _G.Range = value
  end
})

local AutoFarmTG = MainTab:AddToggle({
  Name = "Auto Farm Level",
  Default = false,
  Flag = "AutoLevel",
  Callback = function(state)
  _G.AutoFarm = state
  end
})


local QuestData = {
  {
    level = 1, name = "Giorno Lv.1+", target = "Bad Gi", npc = "Giorno"
  },
  {
    level = 10, name = "Scared Noob Lv.10+", target = "Scary Monster", npc = "Scared Noob"
  },
  {
    level = 20, name = "Koiichi Lv.20+", target = "Giorno Giovanna", npc = "Koichi"
  },
  {
    level = 30, name = "Rker Dummy Lv.30+", target = "Rker Dummy", npc = "aLLmemester"
  },
  {
    level = 40, name = "Okuyasu Lv.40+", target = "Yoshikage Kira", npc = "Okayasu"
  },
  {
    level = 50, name = "Joseph Lv.50+", target = "Dio Over Heaven", npc = "Joseph Joestar"
  },
  {
    level = 75, name = "Josuke Lv.75+", target = "Angelo", npc = "Josuke"
  },
  {
    level = 100, name = "Kishibe Rohan Lv.100+", target = "Alien", npc = "Rohan"
  },
  {
    level = 125, name = "DIO Lv.125+", target = "Jotaro Part 4", npc = "DIO"
  },
  {
    level = 150, name = "Muhammed Avdol Lv.150+", target = "Kakyoin", npc = "Muhammed Avdol"
  },
  {
    level = 200, name = "Zeppeli Lv.200+", target = "Sewer Vampire", npc = "Zeppeli"
  },
  {
    level = 275, name = "Young Joseph Lv.275+", target = "Pillerman", npc = "Young Joseph"
  }
}

local function getQuestData(level)
for i = #QuestData, 1, -1 do
if level >= QuestData[i].level then
return QuestData[i]
end
end
return QuestData[1]
end

local function findNPC(npcName)
return workspace.Map.NPCs:FindFirstChild(npcName)
end

local function SafeTeleport(character, targetCFrame)
if character and character:FindFirstChild("HumanoidRootPart") then
character.HumanoidRootPart.CFrame = targetCFrame
return true
end
return false
end



local AutoSkill = MainTab:AddToggle({
  Name = "Auto Use Skills",
  Default = false,
  Flag = "AutoSkill"
})
AutoSkill:Callback(function(state)
  _G.AutoSkill = state
  end)

-- [ SKILLS ] --

local SectionSkill = MainTab:AddSection({
  "// Skills To Use //"
})

local ToggleE = MainTab:AddToggle({
  Name = "Auto E",
  Default = false,
  Flag = "ToggleE"
})
ToggleE:Callback(function(Value)
  _G.AutoE = Value
  end)

local ToggleR = MainTab:AddToggle({
  Name = "Auto R",
  Default = false,
  Flag = "ToggleR"
})
ToggleR:Callback(function(Value)
  _G.AutoR = Value
  end)

local ToggleT = MainTab:AddToggle({
  Name = "Auto T",
  Default = false,
  Flag = "ToggleT"
})
ToggleT:Callback(function(Value)
  _G.AutoT = Value
  end)

local ToggleY = MainTab:AddToggle({
  Name = "Auto Y",
  Default = false,
  Flag = "ToggleY"
})
ToggleY:Callback(function(Value)
  _G.AutoY = Value
  end)

local ToggleU = MainTab:AddToggle({
  Name = "Auto U",
  Default = false,
  Flag = "ToggleU"
})
ToggleU:Callback(function(Value)
  _G.AutoU = Value
  end)

local ToggleJ = MainTab:AddToggle({
  Name = "Auto J",
  Default = false,
  Flag = "ToggleJ"
})
ToggleJ:Callback(function(Value)
  _G.AutoJ = Value
  end)

local ToggleZ = MainTab:AddToggle({
  Name = "Auto Z",
  Default = false,
  Flag = "ToggleZ"
})
ToggleZ:Callback(function(Value)
  _G.AutoZ = Value
  end)

local ToggleX = MainTab:AddToggle({
  Name = "Auto X",
  Default = false,
  Flag = "ToggleX"
})
ToggleX:Callback(function(Value)
  _G.AutoX = Value
  end)

local ToggleH = MainTab:AddToggle({
  Name = "Auto H",
  Default = false,
  Flag = "ToggleH"
})
ToggleH:Callback(function(Value)
  _G.AutoH = Value
  end)

task.spawn(function()
  while true do
  wait()
  pcall(function()
    if _G.AutoSkill then
    if _G.AutoE then
    Barrage()
    BarrageNew()
    end
    if _G.AutoR then
    PressKey("R")
    end
    if _G.AutoF then
    PressKey("F")
    end
    if _G.AutoT then
    PressKey("T")
    end
    if _G.AutoY then
    PressKey("Y")
    end
    if _G.AutoU then
    PressKey("U")
    end
    if _G.AutoJ then
    PressKey("J")
    end
    if _G.AutoZ then
    PressKey("Z")
    end
    if _G.AutoX then
    PressKey("X")
    end
    if _G.AutoH then
    PressKey("H")
    end
    end
    end)
  end
  end)

---- [[ AUTO BOSS ]] ----

local BossSec = MainTab:AddSection({
  "// Auto Farm Boss //"
})

local AutoJotaro = MainTab:AddToggle({
  Name = "Auto Jotaro Over Heaven",
  Default = false,
  Flag = "AutoJotaro"
})
AutoJotaro:Callback(function(state)
  _G.AutoJotaro = state
  end)

local AutoJohnny = MainTab:AddToggle({
  Name = "Auto Johnny Joestar",
  Default = false,
  Flag = "AutoJohnny"
})
AutoJohnny:Callback(function(state)
  _G.AutoJohnny = state
  end)

local AutoGiorno = MainTab:AddToggle({
  Name = "Auto Giorno Giovanna Requiem",
  Default = false,
  Flag = "AutoGiorno"
})
AutoGiorno:Callback(function(state)
  _G.AutoGiorno = state
  end)

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- Constants
local BOSS_POSITIONS = {
  Jotaro = CFrame.new(28124.5273, 73.4733734, -209.276123),
  Johnny = CFrame.new(63.8494797, 83.3270874, -327.052643),
  Giorno = CFrame.new(-505.478577, 73.2101212, 33923.0664)
}

local DUNGEON_POSITIONS = {
  ["Level 15+"] = CFrame.new(-722.297668, 67.0181732, -940.724182),
  ["Level 40+"] = CFrame.new(-726.523804, 67.0282059, -386.987396),
  ["Level 80+"] = CFrame.new(-323.425873, 66.9731827, -133.544128),
  ["Level 100+"] = CFrame.new(-90.7289734, 66.9272995, -888.08728),
  ["Level 200+"] = CFrame.new(28081.9238, 47.2731171, -234.488235)
}

local player = Players.LocalPlayer
local DEFAULT_RANGE = 5
local WAITING_POSITION = CFrame.new(0, 1000, 0)

local function isCharacterAlive()
return player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
end

local function safeSetSimulationRadius()
local success, err = pcall(function()
  sethiddenproperty(player, "SimulationRadius", math.huge)
  end)
if not success then
warn("Failed to set simulation radius:", err)
end
end

local function teleportWithRetry(targetCFrame, maxAttempts)
if not isCharacterAlive() then return false end

maxAttempts = maxAttempts or 3
for attempt = 1, maxAttempts do
local success = pcall(function()
  player.Character.HumanoidRootPart.CFrame = targetCFrame
  end)
if success then return true end
wait()
end
return false
end

-- Kill Boss
task.spawn(function()
  while wait() do
  safeCall(function()
    if _G.AutoDungeon and game.workspace.Living:FindFirstChild("Boss") then
    sethiddenproperty(player, "SimulationRadius", math.huge)
    for _, v in pairs(workspace.Living:GetChildren()) do
    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name == "Boss" then
    v.Humanoid.Health = 0
    end
    end
    end
    end)
  end
  end)


-- Combat Functions
local function attack()
if not isCharacterAlive() then return end

pcall(function()
  Attack()
  NewAttack()
  VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.S, false, game)
  end)
end

local function summonStandIfNeeded()
if not Workspace.Living:FindFirstChild(_G.MyName) then return end

if not Workspace.Living[_G.MyName].Aura.Value then
pcall(function()
  SummonStand()
  end)
wait()
end
end

-- Dungeon Functions
local function isDungeonCompleted()
return false
end

local function handleDungeonMobs()
if _G.AutoClearMinion then
if _G.Dungeon == "Level 200+" then
for _, v in pairs(Workspace.Living:GetChildren()) do
if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name == "Speed wagonnnnn" then
v.Humanoid.Health = 0
end
end
elseif _G.Dungeon == "Level 80+" then
for _, v in pairs(Workspace.Living:GetChildren()) do
if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name == "Homeless Man" then
v.Humanoid.Health = 0
end
end
end
end
end

local BossManager = {
  bosses = {
    {
      name = "Jotaro Over Heaven", flag = "AutoJotaro", pos = BOSS_POSITIONS.Jotaro
    },
    {
      name = "JohnnyJoestar", flag = "AutoJohnny", pos = BOSS_POSITIONS.Johnny
    },
    {
      name = "Giorno Giovanna Requiem", flag = "AutoGiorno", pos = BOSS_POSITIONS.Giorno
    }
  },

  getCurrentBoss = function(self)
  for _, bossData in ipairs(self.bosses) do
  if _G[bossData.flag] then
  local boss = Workspace.Living:FindFirstChild(bossData.name)
  if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
  return boss, bossData.pos
  end
  end
  end
  return nil, nil
  end
}

task.spawn(function()
  pcall(function()
    game:GetService("RunService").Stepped:Connect(function()
      if _G.AutoDungeon or _G.AutoFarm then
      if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
      local Noclip = Instance.new("BodyVelocity")
      Noclip.Name = "BodyClip"
      Noclip.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
      Noclip.MaxForce = Vector3.new(100000, 100000, 100000)
      Noclip.Velocity = Vector3.new(0, 0, 0)
      end
      else
        if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
      game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
      end
      end
      end)
    end)
  end)

local function dungeonLoop()
while wait() do
if not _G.AutoDungeon then continue end
if not isCharacterAlive() then continue end

local success, err = pcall(function()
  local character = Workspace.Living:FindFirstChild(_G.MyName)
  if not character then return end

  local inLair = character:FindFirstChild("InLair") and character.InLair.Value

  if not inLair then
  local dungeonPos = DUNGEON_POSITIONS[_G.Dungeon]
  if dungeonPos then
  teleportWithRetry(dungeonPos)
  wait()
  InteractNearest()
  end
  else
    local boss = Workspace.Living:FindFirstChild("Boss")
  if boss and boss:FindFirstChild("HumanoidRootPart") then
  teleportWithRetry(boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.Range or DEFAULT_RANGE))
  attack()
  else
    handleDungeonMobs()
  end

  if isDungeonCompleted() then
  wait()
  end
  end
  end)

if not success then
wait()
end
end
end

local function mainLoop()
local targetIndex = 1

while true do
if not isCharacterAlive() then
wait()
end

local success, err = pcall(function()
  if _G.AutoDungeon then return end

  local currentBoss, bossPos = BossManager:getCurrentBoss()
  if currentBoss then
  local targetPos = currentBoss:FindFirstChild("HumanoidRootPart") and
  currentBoss.HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.Range or DEFAULT_RANGE) or
  bossPos

  if teleportWithRetry(targetPos) then
  attack()
  end

  elseif _G.AutoFarm then
  local questData = getQuestData(player.Data.Level.Value)
  if questData then
  _G.Quest = questData.name
  local targets = {}

  for _, mob in ipairs(Workspace.Living:GetChildren()) do
  if mob.Name == questData.target and
  mob:FindFirstChild("Humanoid") and
  mob.Humanoid.Health > 0 then
  table.insert(targets, mob)
  end
  end

  if #targets > 0 then
  targetIndex = (targetIndex % #targets) + 1
  local target = targets[targetIndex]

  if teleportWithRetry(target.HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.Range or DEFAULT_RANGE)) then
  attack()
  end
  else
    local npc = findNPC(questData.npc)
    if npc then
      pcall(function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 900, 0)
      end)
    end
  end

  local npc = findNPC(questData.npc)
  if npc then
  pcall(function()
    npc.Done:FireServer()
    npc.QuestDone:FireServer()
    end)
  end
  end
  end
  end)

if not success then
wait()
else
  wait(0.1)
end
end
end

do

task.spawn(function()
  while wait() do
  if _G.AutoDungeon or _G.AutoFarm or _G.AutoJotaro or _G.AutoJohnny or _G.AutoGiorno then
  summonStandIfNeeded()
  end
  end
  end)

task.spawn(dungeonLoop)
task.spawn(mainLoop)
end

---- [[ SETTING BOSS ]] ----

local SetBossSec = MainTab:AddSection({
  "// Auto Boss Settings //"
})

local InstantKillBoss = MainTab:AddToggle({
  Name = "Instant Kill Boss",
  Default = false,
  Flag = "InstantKill",
  Callback = function(state)
  _G.InstantKill = state
  end
})

-------------

task.spawn(function()
  while wait() do
  pcall(function()
    if _G.AutoJotaro and _G.InstantKill then
    sethiddenproperty(player, "SimulationRadius", math.huge)
    for _, v in pairs(workspace.Living:GetChildren()) do
    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name == "Jotaro Over Heaven" and v.HumanoidRootPart.Anchored == false then
    v.Humanoid.Health = -math.huge
    end
    end
    end
    end)
  end
  end)

task.spawn(function()
  while wait() do
  pcall(function()
    if _G.AutoJohnny and _G.InstantKill then
    sethiddenproperty(player, "SimulationRadius", math.huge)
    for _, v in pairs(workspace.Living:GetChildren()) do
    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name == "JohnnyJoestar" and v.HumanoidRootPart.Anchored == false then
    v.Humanoid.Health = -math.huge
    end
    end
    end
    end)
  end
  end)

task.spawn(function()
  while wait(0.1) do
  pcall(function()
    if _G.AutoGiorno and _G.InstantKill then
    sethiddenproperty(player, "SimulationRadius", math.huge)
    for _, v in pairs(workspace.Living:GetChildren()) do
    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name == "Giorno Giovanna Requiem" and v.HumanoidRootPart.Anchored == false then
    v.Humanoid.Health = -math.huge
    end
    end
    end
    end)
  end
  end)

------------

local AKGQ = MainTab:AddToggle({
  Name = "Auto Diavolo Quest [Level 500+]",
  Default = false,
  Flag = "AKGQ",
  Callback = function(state)
  _G.AKGQ = state
  end
})

task.spawn(function()
  while true do
  wait()
  if _G.AKGQ then
  workspace.Map.NPCs.Diavolo.Done:FireServer()
  workspace.Map.NPCs.Diavolo.QuestDone:FireServer()
  end
  end
  end)

local CombatSec = CombatTab:AddSection({
  "// ESP //"
})
_G.ESPPlayer = false
_G.TracerPlayer = false

local ActiveTracers = {}

local function GetHealthColor(healthPercent)
    if healthPercent > 50 then
        return Color3.fromRGB(255 - ((healthPercent - 50) * 5.1), 255, 0)
    elseif healthPercent > 25 then
        return Color3.fromRGB(255, 165 + ((healthPercent - 25) * 4), 0)
    else
        return Color3.fromRGB(255, 165 * (healthPercent / 25), 0)     
    end
end

local function CleanupESP()
    for _, esp in pairs(game.CoreGui:GetChildren()) do
        if esp.Name:match("_ESP$") then
            esp:Destroy()
        end
    end
    
    for _, tracerData in pairs(ActiveTracers) do
        if tracerData.line then tracerData.line:Remove() end
        if tracerData.dot then tracerData.dot:Remove() end
    end
    table.clear(ActiveTracers)
end

function Create_ESPPlayer(base, player)
    if not _G.ESPPlayer then return end
    if player == game.Players.LocalPlayer then return end 
    local billboard = Instance.new("BillboardGui")
    billboard.Parent = game.CoreGui
    billboard.Adornee = base
    billboard.ExtentsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Name = player.Name .. "_ESP"
    billboard.MaxDistance = math.huge
    local txtlbl = Instance.new("TextLabel", billboard)
    txtlbl.ZIndex = 10
    txtlbl.BackgroundTransparency = 1
    txtlbl.Size = UDim2.new(1, 0, 1, 0)
    txtlbl.Font = Enum.Font.Code
    txtlbl.TextSize = 12
    txtlbl.TextWrapped = true
    txtlbl.TextTruncate = Enum.TextTruncate.AtEnd

    local distlbl = Instance.new("TextLabel", billboard)
    distlbl.ZIndex = 10
    distlbl.BackgroundTransparency = 1
    distlbl.Position = UDim2.new(0, 0, 0, 45)
    distlbl.Size = UDim2.new(1, 0, 1, 0)
    distlbl.Font = Enum.Font.Code
    distlbl.TextSize = 10
    distlbl.TextColor3 = Color3.fromRGB(255, 255, 255)

    if _G.TracerPlayer then
        local tracerData = {
            line = Drawing.new("Line"),
            dot = Drawing.new("Circle")
        }
        
        tracerData.line.Thickness = 1.5
        tracerData.line.Transparency = 1
        tracerData.line.Visible = true

        tracerData.dot.Radius = 2
        tracerData.dot.Filled = true
        tracerData.dot.Thickness = 1.5
        tracerData.dot.Transparency = 1
        tracerData.dot.Visible = true

        ActiveTracers[player.Name] = tracerData
    end

    local function UpdateESP()
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            if ActiveTracers[player.Name] then
                ActiveTracers[player.Name].line:Remove()
                ActiveTracers[player.Name].dot:Remove()
                ActiveTracers[player.Name] = nil
            end
            billboard:Destroy()
            return
        end

        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local playerData = player:FindFirstChild("Data")
        local level = playerData and playerData:FindFirstChild("Level") and playerData.Level.Value or 0
        local stand = playerData and playerData:FindFirstChild("Stand") and playerData.Stand.Value or "N/A"
        local attribute = playerData and playerData:FindFirstChild("Attri") and playerData.Attri.Value or "N/A"

        local health = humanoid.Health
        local maxHealth = humanoid.MaxHealth
        local healthPercent = (health / maxHealth) * 100
        local color = GetHealthColor(healthPercent)

        txtlbl.TextColor3 = color
        txtlbl.Text = string.format("%s | Level: %d\nHealth: %.1f%% | %d HP\nStand โ€ข %s โ€ข %s",
            player.Name, level, healthPercent, health, stand, attribute)

        local distance = (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        distlbl.Text = string.format("[ %.1f Studs ]", distance)

        if _G.TracerPlayer and ActiveTracers[player.Name] then
            local camera = game.Workspace.CurrentCamera
            local localPlayerPos = camera:WorldToViewportPoint(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
            local targetPos = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)

            if targetPos.Z > 0 then
                ActiveTracers[player.Name].line.From = Vector2.new(localPlayerPos.X, localPlayerPos.Y)
                ActiveTracers[player.Name].line.To = Vector2.new(targetPos.X, targetPos.Y)
                ActiveTracers[player.Name].line.Color = color
                ActiveTracers[player.Name].line.Visible = true

                ActiveTracers[player.Name].dot.Position = Vector2.new(targetPos.X, targetPos.Y)
                ActiveTracers[player.Name].dot.Color = color
                ActiveTracers[player.Name].dot.Visible = true
            else
                ActiveTracers[player.Name].line.Visible = false
                ActiveTracers[player.Name].dot.Visible = false
            end
        end
    end

    local updateConnection
    updateConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if _G.ESPPlayer or _G.TracerPlayer then
            pcall(UpdateESP)
        else
            if updateConnection then updateConnection:Disconnect() end
            if ActiveTracers[player.Name] then
                ActiveTracers[player.Name].line:Remove()
                ActiveTracers[player.Name].dot:Remove()
                ActiveTracers[player.Name] = nil
            end
            billboard:Destroy()
        end
    end)
end

local function OnPlayerAdded(player)
    player.CharacterAdded:Connect(function(char)
        repeat wait() until char:FindFirstChild("HumanoidRootPart")
        if player ~= game.Players.LocalPlayer then
            Create_ESPPlayer(char.HumanoidRootPart, player)
        end
    end)
end

local function Apply_ESP()
    if not _G.ESPPlayer and not _G.TracerPlayer then
        CleanupESP()
        return
    end
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            Create_ESPPlayer(player.Character.HumanoidRootPart, player)
        end
        OnPlayerAdded(player)
    end

    game.Players.PlayerAdded:Connect(OnPlayerAdded)

    game.Players.PlayerRemoving:Connect(function(player)
        if ActiveTracers[player.Name] then
            ActiveTracers[player.Name].line:Remove()
            ActiveTracers[player.Name].dot:Remove()
            ActiveTracers[player.Name] = nil
        end
        if game.CoreGui:FindFirstChild(player.Name .. "_ESP") then
            game.CoreGui[player.Name .. "_ESP"]:Destroy()
        end
    end)
end

local ESPData = CombatTab:AddToggle({
    Name = "Player Data View",
    Default = false,
    Flag = "ViewData",
    Callback = function(state)
        _G.ESPPlayer = state
        if not state then
            _G.TracerPlayer = false
        end
        CleanupESP()
        if state then
            Apply_ESP()
        end
    end
})

local ESPTracer = CombatTab:AddToggle({
    Name = "Tracer ESP",
    Default = false,
    Flag = "TracerESP",
    Callback = function(state)
        _G.TracerPlayer = state
        if state and not _G.ESPPlayer then
            _G.ESPPlayer = true
        end
        CleanupESP()
        if _G.ESPPlayer then
            Apply_ESP()
        end
    end
})


local FightingSec = CombatTab:AddSection({
    "// Fighting Assistant //"
})

local function AIAttack()
    pcall(function()
        Attack()
        NewAttack()
    end)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local activeLoop = nil 

local FriendlyList = {
    "None",
    "Friends",
    "Gang"
}

CombatTab:AddDropdown({
    Name = "Select Friendly",
    Description = "Type of Player that AI will not target",
    Options = FriendlyList,
    Default = {},
    Flag = "SelectFriendly",
    MultiSelect = false,
    Callback = function(Value)
        _G.Friendly = Value
    end
})

local SlideRadius = CombatTab:AddSlider({
    Name = "Detect Range (for AI)",
    Min = 3,
    Max = 20,
    Increase = 1,
    Default = 5,
    Callback = function(value)
        _G.AttackRadius = value
    end
})

local AIAttackMode = CombatTab:AddToggle({
    Name = "Auto M1 [AI]",
    Default = false,
    Flag = "AutoM1",
    Callback = function(state)
        _G.AutoAttackNear = state
        if state then
            startAttackLoop()
        elseif activeLoop then
            activeLoop = false
        end
    end
})

_G.Friendly = _G.Friendly or "None"
_G.AttackRadius = _G.AttackRadius or 5
_G.AutoAttackNear = _G.AutoAttackNear or false

local function isIn180AoE(target)
    local direction = LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
    local toTarget = (target.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit
    return (direction:Dot(toTarget) > 0)
end

local function isFriendly(target)
    if _G.Friendly == "None" then
        return false
    elseif _G.Friendly == "Friends" then
        return LocalPlayer:IsFriendsWith(target.UserId)
    elseif _G.Friendly == "Gang" then
        return target:FindFirstChild("CurrentGang") and 
               LocalPlayer:FindFirstChild("CurrentGang") and 
               target.CurrentGang.Value == LocalPlayer.CurrentGang.Value
    end
    return false
end

function startAttackLoop()
    if activeLoop then return end
    activeLoop = true
    task.spawn(function()
        while _G.AutoAttackNear and activeLoop do
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= (_G.AttackRadius or 5) and isIn180AoE(player) and not isFriendly(player) then
                        AIAttack()
                        wait(0.1)
                    end
                end
            end
            wait(0.1)
        end
       activeLoop = nil 
    end)
end

--------- [[ JOTARO AU 4 ]] ------------

local CreditSec = MainTab:AddSection({
  "// More Farming //"
})


local AutoJotaroAU = MainTab:AddToggle({
    Name = "Auto Jotaro AU",
    Default = false,
    Flag = "JotaroAU",
    Callback = function(state)
        _G.AutoJotaroAU = state
    end
})

local InstantJotaroAU = MainTab:AddToggle({
    Name = "Instant Kill Jotaro AU",
    Default = false,
    Flag = "InsJotaroAU",
    Callback = function(state)
        _G.InstantJotaroAU = state
    end
})


local JotaroAU = "Alternate Jotaro Part 4"

task.spawn(function()
  while wait(0.1) do
    pcall(function()
      if _G.AutoJotaroAU then
        for _, v in pairs(game.workspace.Living:GetChildren()) do
          if v.Name == JotaroAU and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local rootPart = v:FindFirstChild("HumanoidRootPart")
            if rootPart then
              local range = _G.Range or 5
              game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, range)
              attack()
              safeSetSimulationRadius()
            end
          end
        end
      end
    end)
  end
end)

task.spawn(function()
  while wait() do
    pcall(function()
      if _G.InstantJotaroAU then
        local JAU = workspace.Living:FindFirstChild(JotaroAU)
        if JAU and JAU:FindFirstChild("Humanoid") and JAU.Humanoid.Health < JAU.Humanoid.MaxHealth then
          JAU.Humanoid.Health = -math.huge
          safeSetSimulationRadius()
        end
      end
    end)
  end
end)

local AutoItemTG = MainTab:AddToggle({
    Name = "Auto Farm Spawned Item",
    Default = false,
    Flag = "AutoItem",
    Callback = function(state)
        _G.AutoFarmItem = state
    end
})

local itemFolder = workspace.Vfx

task.spawn(function()
  while task.wait() do
    pcall(function()
      if _G.AutoFarmItem then
        for _, item in pairs(itemFolder:GetChildren()) do
          local handle = item:FindFirstChild("Handle")
          local prompt = handle and handle:FindFirstChild("ProximityPrompt")
          
          if prompt and prompt.Enabled then
            while item.Parent and prompt.Enabled and _G.AutoFarmItem do
              game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = handle.CFrame * CFrame.new(0, 1, 0)
              
              fireproximityprompt(prompt, 20)
              
              task.wait(0.05)
            end
          end
        end
      end
    end)
  end
end)

----------- [[ BUY ITEMS ]] --------------

local NikaSection = StandTab:AddSection({
  "// Buy & Sell Items //"
})



-- Credit Tab
local CreditSec = Credit:AddSection({
  "// Script Credit //"
})

Credit:AddDiscordInvite({
  Name = "Azurium | Community",
  Description = "Join our Discord to get the latest updates first",
  Logo = "rbxassetid://103208753702759",
  Invite = "https://discord.gg/azurium"
})

Credit:AddSection({
  "Map Supported by mituma"
})


warn("Script loaded successfully!")
