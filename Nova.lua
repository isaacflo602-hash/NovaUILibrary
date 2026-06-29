local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local NovaUI = {}

local C = {
    Bg = Color3.fromRGB(10, 10, 18),           -- Transparent Black
    Card = Color3.fromRGB(18, 18, 32),
    TabBar = Color3.fromRGB(14, 14, 26),
    ActiveTab = Color3.fromRGB(124, 92, 252),
    Accent = Color3.fromRGB(124, 92, 252),
    AccentHover = Color3.fromRGB(160, 135, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Subtext = Color3.fromRGB(200, 200, 220),   -- Brighter for visibility
    Border = Color3.fromRGB(45, 45, 75),
    ToggleOff = Color3.fromRGB(45, 45, 70),
    ToggleOn = Color3.fromRGB(124, 92, 252),
    HoverCard = Color3.fromRGB(30, 30, 55),
    SliderTrack = Color3.fromRGB(35, 35, 60),
}

local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = parent
    return c
end

local function addStroke(parent, color, thickness, trans)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = trans or 0.5
    s.Parent = parent
    return s
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
    main.BackgroundTransparency = 0.12   -- Transparent Black
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = screenGui
    addCorner(main, 16)
    addStroke(main, C.Border, 1.5, 0.4)

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 44)
    titleBar.BackgroundColor3 = C.Card
    titleBar.BackgroundTransparency = 0.25
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    addCorner(titleBar, 16)
    
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 12)
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.BackgroundColor3 = C.Card
    titleFix.BackgroundTransparency = 0.25
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -120, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = titleText or "Nova UI Library"
    titleLabel.TextColor3 = C.Text
    titleLabel.TextSize = 17
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Control Buttons (Better visibility)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -38, 0.5, -14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    addCorner(closeBtn, 14)

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
    minimizeBtn.Position = UDim2.new(1, -72, 0.5, -14)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 190, 0)
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.new(1,1,1)
    minimizeBtn.TextSize = 18
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = titleBar
    addCorner(minimizeBtn, 14)

    local fullscreenBtn = Instance.new("TextButton")
    fullscreenBtn.Size = UDim2.new(0, 28, 0, 28)
    fullscreenBtn.Position = UDim2.new(1, -106, 0.5, -14)
    fullscreenBtn.BackgroundColor3 = Color3.fromRGB(40, 210, 90)
    fullscreenBtn.Text = "⬜"
    fullscreenBtn.TextColor3 = Color3.new(1,1,1)
    fullscreenBtn.TextSize = 12
    fullscreenBtn.Font = Enum.Font.GothamBold
    fullscreenBtn.BorderSizePixel = 0
    fullscreenBtn.Parent = titleBar
    addCorner(fullscreenBtn, 14)

    -- Tab Bar (Better visibility)
    local tabBar = Instance.new("ScrollingFrame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -24, 0, 36)
    tabBar.Position = UDim2.new(0, 12, 0, 52)
    tabBar.BackgroundColor3 = C.TabBar
    tabBar.BackgroundTransparency = 0.3
    tabBar.BorderSizePixel = 0
    tabBar.ScrollBarThickness = 0
    tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabBar.ScrollingDirection = Enum.ScrollingDirection.X
    tabBar.Parent = main
    addCorner(tabBar, 10)
    addStroke(tabBar, C.Border, 1, 0.6)

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.FillDirection = Enum.FillDirection.Horizontal
    tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 4)
    tabListLayout.Parent = tabBar
    addPadding = addPadding or function() end -- safety

    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -24, 1, -104)
    contentArea.Position = UDim2.new(0, 12, 0, 96)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = main

    -- Keep all your original logic exactly the same from here
    -- (drag, minimize, fullscreen, closeBtn, showButton, etc.)

    -- [Your original code from dragToggle down to the end remains unchanged]
    -- I'm only showing the changed UI part to keep it clean.

    -- Tab Button (Improved visibility)
    function Window:CreateTab(tabName)
        local Tab = {}
        local btn = Instance.new("TextButton")
        btn.Name = tabName
        btn.Size = UDim2.new(0, 112, 1, 0)
        btn.BackgroundColor3 = C.TabBar
        btn.BackgroundTransparency = 0.3
        btn.Text = tabName
        btn.TextColor3 = C.Subtext
        btn.TextSize = 13.5
        btn.Font = Enum.Font.GothamSemibold
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = tabBar
        addCorner(btn, 8)

        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Name = tabName
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.BorderSizePixel = 0
        tabFrame.ScrollBarThickness = 4
        tabFrame.ScrollBarImageColor3 = C.Accent
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabFrame.Visible = false
        tabFrame.Parent = contentArea

        -- Rest of your original CreateTab logic stays 100% the same
        -- (selectThisTab, CreateButton, CreateToggle, CreateSlider, etc.)

        Window.Tabs[tabName] = tabFrame
        Window.TabButtons[tabName] = btn

        local function selectThisTab()
            for name, frame in pairs(Window.Tabs) do
                if name == tabName then
                    frame.Visible = true
                    Window.TabButtons[name].BackgroundColor3 = C.ActiveTab
                    Window.TabButtons[name].BackgroundTransparency = 0
                    Window.TabButtons[name].TextColor3 = C.Text
                else
                    frame.Visible = false
                    Window.TabButtons[name].BackgroundColor3 = C.TabBar
                    Window.TabButtons[name].BackgroundTransparency = 0.3
                    Window.TabButtons[name].TextColor3 = C.Subtext
                end
            end
        end

        btn.MouseButton1Click:Connect(selectThisTab)
        if not Window.CurrentTab then
            selectThisTab()
            Window.CurrentTab = tabName
        end

        -- Your original CreateButton, CreateToggle, CreateSlider stay exactly the same
        function Tab:CreateButton(text, callback) 
            -- ... your original code
        end
        function Tab:CreateToggle(text, default, callback)
            -- ... your original code
        end
        function Tab:CreateSlider(text, min, max, default, callback)
            -- ... your original code
        end

        return Tab
    end

    return Window
end

return NovaUI
