local Nova = loadstring(game:HttpGet("https://raw.githubusercontent.com/isaacflo602-hash/NovaUILibrary/main/Nova.lua"))()
local Window = Nova:CreateWindow("Nova Player Menu - Full Test")

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- Variables
local wsVal = 16
local jpVal = 50
local infJump = false
local espEnabled = false
local noclipEnabled = false
local godmode = false

-- Services
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- WalkSpeed & JumpPower Loop
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if lp.Character and lp.Character:FindFirstChildWhichIsA("Humanoid") then
                local hum = lp.Character:FindFirstChildWhichIsA("Humanoid")
                hum.WalkSpeed = wsVal
                hum.JumpPower = jpVal
                hum.UseJumpPower = true
            end
        end)
    end
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if infJump and lp.Character then
        pcall(function()
            lp.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if noclipEnabled and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end)

-- Simple ESP
local function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("NovaESP")
            if hl then hl.Enabled = espEnabled end
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(1) updateESP() end)
end)

-- ==================== TABS ====================

local Movement = Window:CreateTab("Movement")
Movement:CreateSlider("WalkSpeed", 16, 250, 16, function(value)
    wsVal = value
end)

Movement:CreateSlider("JumpPower", 50, 300, 50, function(value)
    jpVal = value
end)

Movement:CreateToggle("Infinite Jump", false, function(state)
    infJump = state
end)

Movement:CreateButton("Reset Speed Values", function()
    wsVal = 16
    jpVal = 50
    print("Speed values reset!")
end)

-- ==================== VISUALS ====================

local Visuals = Window:CreateTab("Visuals")
Visuals:CreateToggle("Player ESP", false, function(state)
    espEnabled = state
    updateESP()
end)

Visuals:CreateToggle("Godmode (Client)", false, function(state)
    godmode = state
    pcall(function()
        if lp.Character and lp.Character:FindFirstChildWhichIsA("Humanoid") then
            lp.Character:FindFirstChildWhichIsA("Humanoid").MaxHealth = state and math.huge or 100
            lp.Character:FindFirstChildWhichIsA("Humanoid").Health = state and math.huge or 100
        end
    end)
end)

Visuals:CreateButton("Refresh ESP", function()
    updateESP()
end)

-- ==================== CHARACTER ====================

local Character = Window:CreateTab("Character")
Character:CreateToggle("Noclip", false, function(state)
    noclipEnabled = state
end)

Character:CreateButton("Reset Character", function()
    if lp.Character and lp.Character:FindFirstChildWhichIsA("Humanoid") then
        lp.Character:FindFirstChildWhichIsA("Humanoid"):BreakJoints()
    end
end)

Character:CreateButton("Rejoin Game", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
end)

Character:CreateButton("Kill Yourself", function()
    pcall(function()
        lp.Character:FindFirstChildWhichIsA("Humanoid").Health = 0
    end)
end)

-- ==================== TEST TAB ====================

local Test = Window:CreateTab("Test Elements")
Test:CreateButton("Test Button 1", function()
    print("Button 1 clicked!")
end)

Test:CreateToggle("Test Toggle", true, function(state)
    print("Toggle changed to:", state)
end)

Test:CreateSlider("Test Slider", 0, 100, 50, function(value)
    print("Slider value:", value)
end)

Test:CreateButton("Show Notification Test", function()
    -- Simple notification simulation
    print("🔔 This would be a notification in a full UI!")
end)

print("NovaUI Full Test Loaded Successfully!")
