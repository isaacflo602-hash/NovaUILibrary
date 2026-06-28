local Nova = loadstring(game:HttpGet("https://raw.githubusercontent.com/isaacflo602-hash/NovaUILibrary/main/Nova.lua"))()

local Window = Nova:CreateWindow("Nova UI Library Test")

--// Tab 1 - Home
local Home = Window:CreateTab("Home")

Home:CreateButton("Print Hello", function()
	print("Hello!")
end)

Home:CreateToggle("Test Toggle", false, function(state)
	print("Toggle:", state)
end)

Home:CreateSlider("Volume", 0, 100, 50, function(value)
	print("Volume:", value)
end)

--// Tab 2 - Player
local Player = Window:CreateTab("Player")

Player:CreateButton("Reset Character", function()
	game.Players.LocalPlayer.Character:BreakJoints()
end)

Player:CreateToggle("Infinite Jump", false, function(state)
	print("Infinite Jump:", state)
end)

Player:CreateSlider("WalkSpeed", 16, 100, 16, function(value)
	local hum = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum.WalkSpeed = value
	end
end)

--// Tab 3 - Combat
local Combat = Window:CreateTab("Combat")

Combat:CreateButton("Attack", function()
	print("Attack!")
end)

Combat:CreateToggle("Auto Attack", false, function(state)
	print("Auto Attack:", state)
end)

Combat:CreateSlider("Attack Speed", 1, 20, 5, function(value)
	print("Attack Speed:", value)
end)

--// Tab 4 - Visuals
local Visuals = Window:CreateTab("Visuals")

Visuals:CreateButton("Refresh ESP", function()
	print("ESP Refreshed")
end)

Visuals:CreateToggle("Player ESP", false, function(state)
	print("ESP:", state)
end)

Visuals:CreateSlider("Brightness", 0, 10, 2, function(value)
	game.Lighting.Brightness = value
end)

--// Tab 5 - Misc
local Misc = Window:CreateTab("Misc")

Misc:CreateButton("Rejoin", function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end)

Misc:CreateToggle("Anti AFK", false, function(state)
	print("Anti AFK:", state)
end)

Misc:CreateSlider("FOV", 70, 120, 70, function(value)
	workspace.CurrentCamera.FieldOfView = value
end)
