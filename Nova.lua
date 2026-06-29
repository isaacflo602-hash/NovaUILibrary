local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local NovaUI = {}

local C = {
    Bg = Color3.fromRGB(8, 8, 15),
    Card = Color3.fromRGB(15, 15, 28),
    TabBar = Color3.fromRGB(12, 12, 24),
    ActiveTab = Color3.fromRGB(124, 92, 252),
    Accent = Color3.fromRGB(124, 92, 252),
    AccentHover = Color3.fromRGB(155, 130, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Subtext = Color3.fromRGB(180, 180, 200),
    Border = Color3.fromRGB(40, 40, 65),
    ToggleOff = Color3.fromRGB(40, 40, 65),
    ToggleOn = Color3.fromRGB(124, 92, 252),
    SliderTrack = Color3.fromRGB(25, 25, 45),
}

local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 14)
    c.Parent = parent
    return c
end

local function addStroke(parent, color, thickness, trans)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = trans or 0.4
    s.Parent = parent
    return s
end

function NovaUI:CreateWindow(titleText)
    local Window = { CurrentTab = nil, Tabs = {}, TabButtons = {} }

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NovaUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 560, 0, 480)
    main.Position = UDim2.new(0.5, -280, 0.5, -240)
    main.BackgroundColor3 = C.Bg
    main.BackgroundTransparency = 0.15
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = screenGui
    addCorner(main, 16)
    addStroke(main, C.Accent, 1.5, 0.6)

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 52)
    titleBar.BackgroundColor3 = C.Card
    titleBar.BackgroundTransparency = 0.3
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    addCorner(titleBar, 16)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -170, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = titleText or "Nova UI"
    titleLabel.TextColor3 = C.Text
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 34, 0, 34)
    closeBtn.Position = UDim2.new(1, -46, 0.5, -17)
    closeBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    addCorner(closeBtn, 10)

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 34, 0, 34)
    minimizeBtn.Position = UDim2.new(1, -88, 0.5, -17)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(234, 179, 8)
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.new(1,1,1)
    minimizeBtn.TextSize = 20
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = titleBar
    addCorner(minimizeBtn, 10)

    local fullscreenBtn = Instance.new("TextButton")
    fullscreenBtn.Size = UDim2.new(0, 34, 0, 34)
    fullscreenBtn.Position = UDim2.new(1, -130, 0.5, -17)
    fullscreenBtn.BackgroundColor3 = Color3.fromRGB(74, 222, 128)
    fullscreenBtn.Text = "⬜"
    fullscreenBtn.TextColor3 = Color3.new(1,1,1)
    fullscreenBtn.TextSize = 14
    fullscreenBtn.Font = Enum.Font.GothamBold
    fullscreenBtn.BorderSizePixel = 0
    fullscreenBtn.Parent = titleBar
    addCorner(fullscreenBtn, 10)

    local tabBar = Instance.new("ScrollingFrame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -24, 0, 46)
    tabBar.Position =
