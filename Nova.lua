local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local NovaUI = {}

-- Delta Inspired Dark Minimalist Theme Palette
local C = {
    Bg          = Color3.fromRGB(11, 11, 14),
    Card        = Color3.fromRGB(18, 18, 24),
    TabBar      = Color3.fromRGB(14, 14, 18),
    ActiveTab   = Color3.fromRGB(24, 24, 32),
    Accent      = Color3.fromRGB(0, 220, 140), -- Delta Neon Green
    AccentHover = Color3.fromRGB(0, 255, 160),
    Text        = Color3.fromRGB(255, 255, 255),
    Subtext     = Color3.fromRGB(150, 150, 165),
    Border      = Color3.fromRGB(26, 26, 34),
    ToggleOff   = Color3.fromRGB(35, 35, 45),
    ToggleOn    = Color3.fromRGB(0, 220, 140),
    HoverCard   = Color3.fromRGB(28, 28, 38),
    SliderTrack = Color3.fromRGB(28, 28, 38),
}

local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function addStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function addPadding(parent, left, top, right, bottom)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, left or 0)
    p.PaddingTop = UDim.new(0, top or 0)
    p.PaddingRight = UDim.new(0, right or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.Parent = parent
    return p
end

local function getLuminance(color)
    return (0.299 * color.R) + (0.587 * color.G) + (0.114 * color.B)
end

function NovaUI:CreateWindow(titleText)
    local Window = {
        CurrentTab = nil,
        Tabs = {},
        TabButtons = {}
    }
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeltaNovaUI_Instance"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main Window Container
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 580, 0, 380)
    main.Position = UDim2.new(0.5, -290, 0.5, -190)
    main.BackgroundColor3 = C.Bg
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = screenGui
    
    addCorner(main, 10)
    local mainStroke = addStroke(main, C.Border, 1)
    
    -- Header Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = C.Bg
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -120, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = titleText or "Delta UI"
    titleLabel.TextColor3 = C.Text
    titleLabel.TextSize = 15
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Window Control Buttons
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 12, 0, 12)
    closeBtn.Position = UDim2.new(1, -24, 0.5, -6)
    closeBtn.BackgroundColor3 = Color3.fromRGB(250, 90, 85)
    closeBtn.Text = ""
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    addCorner(closeBtn, 6)
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.Size = UDim2.new(0, 12, 0, 12)
    minimizeBtn.Position = UDim2.new(1, -44, 0.5, -6)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(242, 180, 60)
    minimizeBtn.Text = ""
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = titleBar
    addCorner(minimizeBtn, 6)
    
    local fullscreenBtn = Instance.new("TextButton")
    fullscreenBtn.Name = "Fullscreen"
    fullscreenBtn.Size = UDim2.new(0, 12, 0, 12)
    fullscreenBtn.Position = UDim2.new(1, -64, 0.5, -6)
    fullscreenBtn.BackgroundColor3 = Color3.fromRGB(45, 200, 80)
    fullscreenBtn.Text = ""
    fullscreenBtn.BorderSizePixel = 0
    fullscreenBtn.Parent = titleBar
    addCorner(fullscreenBtn, 6)
    
    -- Maximize toggle button
    local showButton = Instance.new("TextButton")
    showButton.Size = UDim2.new(0, 120, 0, 40)
    showButton.Position = UDim2.new(.5, -60, 1, -70)
    showButton.BackgroundColor3 = C.Accent
    showButton.Text = "Open UI"
    showButton.TextColor3 = Color3.new(0, 0, 0)
    showButton.Font = Enum.Font.GothamBold
    showButton.TextSize = 14
    showButton.Visible = false
    showButton.Parent = screenGui
    addCorner(showButton, 8)
    
    local closeDragToggle, closeDragInput, closeDragStart, closeStartPos
    showButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            closeDragToggle = true
            closeDragStart = input.Position
            closeStartPos = showButton.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    closeDragToggle = false
                end
            end)
        end
    end)
    
    showButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            closeDragInput = input
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui.Enabled = not screenGui.Enabled
    end)
    
    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        if minimized then return end
        minimized = true
        TweenService:Create(main, TweenInfo.new(.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 580, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(.3)
        main.Visible = false
        showButton.Visible = true
        showButton.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(showButton, TweenInfo.new(.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 120, 0, 40)
        }):Play
