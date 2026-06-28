local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local NovaUI = {}

local C = {
    Bg          = Color3.fromRGB(15, 15, 26),
    Card        = Color3.fromRGB(26, 26, 46),
    TabBar      = Color3.fromRGB(22, 22, 42),
    ActiveTab   = Color3.fromRGB(42, 42, 74),
    Accent      = Color3.fromRGB(124, 92, 252),
    AccentHover = Color3.fromRGB(160, 132, 255),
    Text        = Color3.fromRGB(255, 255, 255),
    Subtext     = Color3.fromRGB(136, 136, 170),
    Border      = Color3.fromRGB(42, 42, 74),
    ToggleOff   = Color3.fromRGB(50, 50, 80),
    ToggleOn    = Color3.fromRGB(124, 92, 252),
    HoverCard   = Color3.fromRGB(36, 36, 60),
    SliderTrack = Color3.fromRGB(35, 35, 58),
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

function NovaUI:CreateWindow(titleText)
    local Window = {
        CurrentTab = nil,
        Tabs = {},
        TabButtons = {}
    }

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NovaUI_Instance"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 520, 0, 440)
    main.Position = UDim2.new(0.5, -260, 0.5, -220)
    main.BackgroundColor3 = C.Bg
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = screenGui
    addCorner(main, 12)
    addStroke(main, C.Border, 1)

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 44)
    titleBar.BackgroundColor3 = C.Card
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    addCorner(titleBar, 12)

    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 12)
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.BackgroundColor3 = C.Card
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -120, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = titleText or "Nova UI Library"
    titleLabel.TextColor3 = C.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -38, 0.5, -14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeBtn.Text = ""
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    addCorner(closeBtn, 14)

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
    minimizeBtn.Position = UDim2.new(1, -72, 0.5, -14)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 190, 0)
    minimizeBtn.Text = ""
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = titleBar
    addCorner(minimizeBtn, 14)

    local fullscreenBtn = Instance.new("TextButton")
    fullscreenBtn.Name = "Fullscreen"
    fullscreenBtn.Size = UDim2.new(0, 28, 0, 28)
    fullscreenBtn.Position = UDim2.new(1, -106, 0.5, -14)
    fullscreenBtn.BackgroundColor3 = Color3.fromRGB(40, 210, 90)
    fullscreenBtn.Text = ""
    fullscreenBtn.BorderSizePixel = 0
    fullscreenBtn.Parent = titleBar
    addCorner(fullscreenBtn, 14)

    local confirmFrame = Instance.new("Frame")
    confirmFrame.Name = "ConfirmFrame"
    confirmFrame.Size = UDim2.new(0, 280, 0, 140)
    confirmFrame.Position = UDim2.new(0.5, -140, 0.5, -70)
    confirmFrame.BackgroundColor3 = C.Card
    confirmFrame.BorderSizePixel = 0
    confirmFrame.Visible = false
    confirmFrame.ZIndex = 10
    confirmFrame.Parent = screenGui
    addCorner(confirmFrame, 10)
    addStroke(confirmFrame, C.Border, 1)

    local confirmLabel = Instance.new("TextLabel")
    confirmLabel.Size = UDim2.new(1, -20, 0, 50)
    confirmLabel.Position = UDim2.new(0, 10, 0, 15)
    confirmLabel.BackgroundTransparency = 1
    confirmLabel.Text = "Do you wanna unload the UI?"
    confirmLabel.TextColor3 = C.Text
    confirmLabel.TextSize = 16
    confirmLabel.Font = Enum.Font.GothamMedium
    confirmLabel.TextWrapped = true
    confirmLabel.Parent = confirmFrame

    local yesBtn = Instance.new("TextButton")
    yesBtn.Name = "Yes"
    yesBtn.Size = UDim2.new(0, 110, 0, 36)
    yesBtn.Position = UDim2.new(0, 20, 1, -50)
    yesBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    yesBtn.Text = "Yes"
    yesBtn.TextColor3 = C.Text
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.TextSize = 14
    yesBtn.Parent = confirmFrame
    addCorner(yesBtn, 6)

    local noBtn = Instance.new("TextButton")
    noBtn.Name = "No"
    noBtn.Size = UDim2.new(0, 110, 0, 36)
    noBtn.Position = UDim2.new(1, -130, 1, -50)
    noBtn.BackgroundColor3 = C.ActiveTab
    noBtn.Text = "No"
    noBtn.TextColor3 = C.Text
    noBtn.Font = Enum.Font.GothamBold
    noBtn.TextSize = 14
    noBtn.Parent = confirmFrame
    addCorner(noBtn, 6)
     
    closeBtn.MouseButton1Click:Connect(function()
        confirmFrame.Visible = true
    end)

    yesBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    noBtn.MouseButton1Click:Connect(function()
        confirmFrame.Visible = false
    end)

    local showButton = Instance.new("TextButton")
    showButton.Size = UDim2.new(0, 120, 0, 40)
    showButton.Position = UDim2.new(.5, -60, 1, -70)
    showButton.BackgroundColor3 = C.Accent
    showButton.Text = "Show"
    showButton.TextColor3 = Color3.new(1, 1, 1)
    showButton.Font = Enum.Font.GothamBold
    showButton.TextSize = 15
    showButton.Visible = false
    showButton.Parent = screenGui
    addCorner(showButton, 10)

    local minimized = false

    minimizeBtn.MouseButton1Click:Connect(function()
        if minimized then return end
        minimized = true

        TweenService:Create(main, TweenInfo.new(.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 520, 0, 0),
            BackgroundTransparency = 1
        }):Play()

        task.wait(.35)
        main.Visible = false
        showButton.Visible = true
        showButton.Size = UDim2.new(0, 0, 0, 0)

        TweenService:Create(showButton, TweenInfo.new(.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 120, 0, 40)
        }):Play()
    end)

    showButton.MouseButton1Click:Connect(function()
        showButton.Visible = true

        TweenService:Create(showButton, TweenInfo.new(.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()

        task.wait(.25)
        showButton.Visible = false

        main.Visible = true
        main.Size = UDim2.new(0, 520, 0, 0)
        main.BackgroundTransparency = 1

        TweenService:Create(main, TweenInfo.new(.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 520, 0, 440),
            BackgroundTransparency = 0
        }):Play()

        minimized = false
    end)

    local fullscreen = false
    local oldSize = main.Size
    local oldPos = main.Position

    fullscreenBtn.MouseButton1Click:Connect(function()
        fullscreen = not fullscreen

        if fullscreen then
            oldSize = main.Size
            oldPos = main.Position

            TweenService:Create(main, TweenInfo.new(.35, Enum.EasingStyle.Quart), {
                Size = UDim2.new(.95, 0, .92, 0),
                Position = UDim2.new(.025, 0, .04, 0)
            }):Play()
        else
            TweenService:Create(main, TweenInfo.new(.35, Enum.EasingStyle.Quart), {
                Size = oldSize,
                Position = oldPos
            }):Play()
        end
    end)

    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -24, 0, 36)
    tabBar.Position = UDim2.new(0, 12, 0, 52)
    tabBar.BackgroundColor3 = C.TabBar
    tabBar.BorderSizePixel = 0
    tabBar.Parent = main
    addCorner(tabBar, 8)

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.FillDirection = Enum.FillDirection.Horizontal
    tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 4)
    tabListLayout.Parent = tabBar
    addPadding(tabBar, 4, 4, 4, 4)

    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -24, 1, -104)
    contentArea.Position = UDim2.new(0, 12, 0, 96)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = main
    addPadding(contentArea, 0, 4, 0, 0)

    local dragToggle, dragInput, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            local delta = input.Position - dragStart
            main.Position = UDim
