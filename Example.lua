local Nova = loadstring(game:HttpGet("https://raw.githubusercontent.com/isaacflo602-hash/NovaUILibrary/main/Nova.lua"))()
local Window = Nova:CreateWindow("Nova Player Menu")

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local wsVal = 16
local jpVal = 50
local infJump = false
local espEnabled = false
local noclipEnabled = false

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

UIS.JumpRequest:Connect(function()
    if infJump then
        pcall(function()
            if lp.Character and lp.Character:FindFirstChildWhichIsA("Humanoid") then
                lp.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

local function applyESP(p)
    if p == lp then return end
    local function addHighlight(char)
        task.wait(0.5)
        if not char:FindFirstChild("NovaESP") then
            local hl = Instance.new("Highlight")
            hl.Name = "NovaESP"
            hl.FillColor = Color3.fromRGB(0, 220, 140)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.5
            hl.Enabled = espEnabled
            hl.Parent = char
        end
    end
    if p.Character then addHighlight(p.Character) end
    p.CharacterAdded:Connect(addHighlight)
end

for _, v in pairs(Players:GetPlayers()) do applyESP(v) end
Players.PlayerAdded:Connect(applyESP)

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

local Visuals = Window:CreateTab("Visuals")

Visuals:CreateToggle("Player ESP", false, function(state)
    espEnabled = state
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("NovaESP") then
            p.Character.NovaESP.Enabled = state
        end
    end
end)

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
