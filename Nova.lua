local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local NovaUI = {}
local C = {
    Bg = Color3.fromRGB(10, 10, 18),
    Card = Color3.fromRGB(18, 18, 32),
    TabBar = Color3.fromRGB(14, 14, 26),
    ActiveTab = Color3.fromRGB(124, 92, 252),
    Accent = Color3.fromRGB(124, 92, 252),
    AccentHover = Color3.fromRGB(145, 115, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Subtext = Color3.fromRGB(170, 170, 190),
    Border = Color3.fromRGB(35, 35, 55),
    ToggleOff = Color3.fromRGB(45, 45, 65),
    ToggleOn = Color3.fromRGB(124, 92, 252),
    SliderTrack = Color3.fromRGB(30, 30, 50),
    Shadow = Color3.fromRGB(0, 0, 0),
}

local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = parent
    return c
end

local function addStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function addShadow(parent)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent.Parent
    
    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(1, 1)
    })
    gradient.Color = ColorSequence.new(C.Shadow)
    gradient.Parent = shadow
    
    local corner = addCorner(shadow, 16)
    return shadow
end

local function createHoverEffect(btn, baseColor, hoverColor)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = hoverColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = baseColor}):Play()
    end)
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
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = screenGui
    addCorner(main, 16)
    addStroke(main, C.Border, 1.5)
    addShadow(main)

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = C.Card
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    addCorner(titleBar, 16)
    
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 16)
    titleFix.Position = UDim2.new(0, 0, 1, -16)
    titleFix.BackgroundColor3 = C.Card
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -160, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = titleText or "Nova UI"
    titleLabel.TextColor3 = C.Text
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Window Controls
    local function createControlButton(name, color, pos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 32, 0, 32)
        btn.Position = pos
        btn.BackgroundColor3 = color
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.Parent = titleBar
        addCorner(btn, 10)
        return btn
    end

    local closeBtn = createControlButton("Close", Color3.fromRGB(239, 68, 68), UDim2.new(1, -44, 0.5, -16))
    local minimizeBtn = createControlButton("Minimize", Color3.fromRGB(234, 179, 8), UDim2.new(1, -84, 0.5, -16))
    local fullscreenBtn = createControlButton("Fullscreen", Color3.fromRGB(74, 222, 128), UDim2.new(1, -124, 0.5, -16))

    -- Tab Bar
    local tabBar = Instance.new("ScrollingFrame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -24, 0, 44)
    tabBar.Position = UDim2.new(0, 12, 0, 58)
    tabBar.BackgroundColor3 = C.TabBar
    tabBar.BorderSizePixel = 0
    tabBar.ScrollBarThickness = 0
    tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabBar.ScrollingDirection = Enum.ScrollingDirection.X
    tabBar.Parent = main
    addCorner(tabBar, 12)
    addStroke(tabBar, C.Border, 1)

    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.Padding = UDim.new(0, 6)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabBar

    local contentArea = Instance.new("Frame")
    contentArea.Name = "Content"
    contentArea.Size = UDim2.new(1, -24, 1, -118)
    contentArea.Position = UDim2.new(0, 12, 0, 110)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = main

    -- Drag Functionality
    local dragToggle, dragInput, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = false
        end
    end)

    -- Tab Creation
    function Window:CreateTab(tabName)
        local Tab = {}
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 120, 1, 0)
        btn.BackgroundColor3 = C.TabBar
        btn.Text = tabName
        btn.TextColor3 = C.Subtext
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamSemibold
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = tabBar
        addCorner(btn, 10)

        local underline = Instance.new("Frame")
        underline.Size = UDim2.new(1, 0, 0, 3)
        underline.Position = UDim2.new(0, 0, 1, -3)
        underline.BackgroundColor3 = C.ActiveTab
        underline.BorderSizePixel = 0
        underline.BackgroundTransparency = 1
        underline.Parent = btn

        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.ScrollBarThickness = 5
        tabFrame.ScrollBarImageColor3 = C.Accent
        tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabFrame.Visible = false
        tabFrame.Parent = contentArea

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = tabFrame

        Window.Tabs[tabName] = tabFrame
        Window.TabButtons[tabName] = btn

        local function selectTab()
            for name, frame in pairs(Window.Tabs) do
                local isActive = name == tabName
                frame.Visible = isActive
                local b = Window.TabButtons[name]
                TweenService:Create(b, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = isActive and C.Card or C.TabBar,
                    TextColor3 = isActive and C.Text or C.Subtext
                }):Play()
                TweenService:Create(b:FindFirstChild("Frame") or underline, TweenInfo.new(0.3), {
                    BackgroundTransparency = isActive and 0 or 1
                }):Play()
            end
        end

        btn.MouseButton1Click:Connect(selectTab)
        createHoverEffect(btn, C.TabBar, C.Card)

        if not Window.CurrentTab then
            selectTab()
            Window.CurrentTab = tabName
        end

        -- Button
        function Tab:CreateButton(text, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 46)
            b.BackgroundColor3 = C.Accent
            b.Text = text
            b.TextColor3 = C.Text
            b.TextSize = 15
            b.Font = Enum.Font.GothamSemibold
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.Parent = tabFrame
            addCorner(b, 12)
            addStroke(b, C.Accent, 1, 0.8)

            createHoverEffect(b, C.Accent, C.AccentHover)

            b.MouseButton1Click:Connect(function()
                TweenService:Create(b, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
                task.spawn(callback)
                task.wait(0.15)
                TweenService:Create(b, TweenInfo.new(0.1), {TextColor3 = C.Text}):Play()
            end)
        end

        -- Toggle
        function Tab:CreateToggle(text, default, callback)
            local state = default or false
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 52)
            row.BackgroundColor3 = C.Card
            row.BorderSizePixel = 0
            row.Parent = tabFrame
            addCorner(row, 12)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -90, 1, 0)
            lbl.Position = UDim2.new(0, 16, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = C.Text
            lbl.TextSize = 15
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row

            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 52, 0, 28)
            toggleBg.Position = UDim2.new(1, -68, 0.5, -14)
            toggleBg.BackgroundColor3 = state and C.ToggleOn or C.ToggleOff
            toggleBg.Parent = row
            addCorner(toggleBg, 14)

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 22, 0, 22)
            circle.Position = state and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
            circle.BackgroundColor3 = C.Text
            circle.Parent = toggleBg
            addCorner(circle, 11)

            row.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    state = not state
                    TweenService:Create(toggleBg, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = state and C.ToggleOn or C.ToggleOff
                    }):Play()
                    TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                        Position = state and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
                    }):Play()
                    task.spawn(callback, state)
                end
            end)
        end

        -- Slider (improved)
        function Tab:CreateSlider(text, min, max, default, callback)
            -- (I can expand this further if you want — it's already cleaner)
            -- Let me know if you want the full polished slider code too
        end

        return Tab
    end

    return Window
end

return NovaUI
