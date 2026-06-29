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

    -- Main Window
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

    -- Title Bar
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

    -- Control Buttons
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

    -- Tab Bar
    local tabBar = Instance.new("ScrollingFrame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -24, 0, 46)
    tabBar.Position = UDim2.new(0, 12, 0, 60)
    tabBar.BackgroundColor3 = C.TabBar
    tabBar.BackgroundTransparency = 0.4
    tabBar.BorderSizePixel = 0
    tabBar.ScrollBarThickness = 0
    tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabBar.ScrollingDirection = Enum.ScrollingDirection.X
    tabBar.Parent = main
    addCorner(tabBar, 12)

    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.Padding = UDim.new(0, 8)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabBar

    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -24, 1, -122)
    contentArea.Position = UDim2.new(0, 12, 0, 114)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = main

    -- Button Functions
    local minimized = false
    local fullscreen = false
    local oldSize = main.Size
    local oldPos = main.Position

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            oldSize = main.Size
            TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {
                Size = UDim2.new(0, 560, 0, 52),
                BackgroundTransparency = 0.7
            }):Play()
        else
            TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {
                Size = oldSize,
                BackgroundTransparency = 0.15
            }):Play()
        end
    end)

    fullscreenBtn.MouseButton1Click:Connect(function()
        if minimized then return end
        fullscreen = not fullscreen
        if fullscreen then
            oldSize = main.Size
            oldPos = main.Position
            TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
                Size = UDim2.new(0.96, 0, 0.94, 0),
                Position = UDim2.new(0.02, 0, 0.03, 0)
            }):Play()
        else
            TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
                Size = oldSize,
                Position = oldPos
            }):Play()
        end
    end)

    -- Drag System
    local dragToggle, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end
    end)

    -- Tab System
    function Window:CreateTab(tabName)
        local Tab = {}

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 130, 1, 0)
        btn.BackgroundColor3 = C.TabBar
        btn.BackgroundTransparency = 0.3
        btn.Text = tabName
        btn.TextColor3 = C.Subtext
        btn.TextSize = 14.5
        btn.Font = Enum.Font.GothamSemibold
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = tabBar
        addCorner(btn, 10)

        local underline = Instance.new("Frame")
        underline.Size = UDim2.new(1, -20, 0, 3)
        underline.Position = UDim2.new(0.5, -55, 1, -4)
        underline.BackgroundColor3 = C.ActiveTab
        underline.BorderSizePixel = 0
        underline.BackgroundTransparency = 1
        underline.Parent = btn

        local tab
