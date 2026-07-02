local NovaUI = {}

local C = {
    BG = Color3.fromRGB(18, 18, 32),
    TitleBar = Color3.fromRGB(12, 12, 24),
    TabBar = Color3.fromRGB(25, 25, 48),
    TabActive = Color3.fromRGB(88, 101, 242),
    Accent = Color3.fromRGB(88, 101, 242),
    AccentHover = Color3.fromRGB(110, 120, 255),
    Text = Color3.fromRGB(240, 240, 255),
    TextDim = Color3.fromRGB(160, 160, 190),
    Card = Color3.fromRGB(35, 35, 60),
    SliderTrack = Color3.fromRGB(45, 45, 75),
    ToggleOff = Color3.fromRGB(55, 55, 85),
    ToggleOn = Color3.fromRGB(88, 101, 242),
    Border = Color3.fromRGB(60, 60, 100),
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

local function addPadding(parent, l, t, r, b)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, l or 0)
    p.PaddingTop = UDim.new(0, t or 0)
    p.PaddingRight = UDim.new(0, r or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.Parent = parent
    return p
end

function NovaUI:CreateWindow(titleText)
    local Window = { CurrentTab = nil, Tabs = {}, TabButtons = {} }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NovaUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local Shadow = Instance.new("Frame")
    Shadow.Size = UDim2.new(0, 540, 0, 460)
    Shadow.Position = UDim2.new(0.5, -270, 0.5, -230)
    Shadow.BackgroundColor3 = Color3.new(0,0,0)
    Shadow.BackgroundTransparency = 0.65
    Shadow.Parent = ScreenGui
    addCorner(Shadow, 20)

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 520, 0, 440)
    Main.Position = UDim2.new(0.5, -260, 0.5, -220)
    Main.BackgroundColor3 = C.BG
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    addCorner(Main, 12)
    addStroke(Main, C.Border, 1)

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 46)
    TitleBar.BackgroundColor3 = C.TitleBar
    TitleBar.Parent = Main
    addCorner(TitleBar, 12)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -160, 1, 0)
    TitleLabel.Position = UDim2.new(0, 16, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = titleText or "Nova UI"
    TitleLabel.TextColor3 = C.Text
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- Window Buttons
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 34, 0, 26)
    CloseBtn.Position = UDim2.new(1, -46, 0.5, -13)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleBar
    addCorner(CloseBtn, 6)

    local FullBtn = Instance.new("TextButton")
    FullBtn.Size = UDim2.new(0, 34, 0, 26)
    FullBtn.Position = UDim2.new(1, -86, 0.5, -13)
    FullBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
    FullBtn.Text = "⛶"
    FullBtn.TextColor3 = Color3.new(1,1,1)
    FullBtn.Font = Enum.Font.GothamBold
    FullBtn.Parent = TitleBar
    addCorner(FullBtn, 6)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 34, 0, 26)
    MinBtn.Position = UDim2.new(1, -126, 0.5, -13)
    MinBtn.BackgroundColor3 = Color3.fromRGB(250, 204, 21)
    MinBtn.Text = "—"
    MinBtn.TextColor3 = Color3.new(1,1,1)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = TitleBar
    addCorner(MinBtn, 6)

    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 46)
    TabBar.Position = UDim2.new(0, 0, 0, 46)
    TabBar.BackgroundColor3 = C.TabBar
    TabBar.Parent = Main

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Size = UDim2.new(1, 0, 1, 0)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 0
    TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabScroll.Parent = TabBar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.Parent = TabScroll
    addPadding(TabScroll, 8, 8, 8, 8)

    local TabIndicator = Instance.new("Frame")
    TabIndicator.Size = UDim2.new(0, 140, 0, 4)
    TabIndicator.BackgroundColor3 = C.TabActive
    TabIndicator.Position = UDim2.new(0, 30, 1, -4)
    TabIndicator.Parent = TabBar
    addCorner(TabIndicator, 2)

    -- Content
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -24, 1, -108)
    Content.Position = UDim2.new(0, 12, 0, 98)
    Content.BackgroundTransparency = 1
    Content.ClipsDescendants = true
    Content.Parent = Main

    -- Dragging
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            Shadow.Position = Main.Position + UDim2.new(0,-10,0,-10)
        end
    end)
    UIS.InputEnded:Connect(function() dragging = false end)

    -- Exit Confirmation
    local confirmOverlay = Instance.new("Frame")
    confirmOverlay.Size = UDim2.new(1,0,1,0)
    confirmOverlay.BackgroundColor3 = Color3.new(0,0,0)
    confirmOverlay.BackgroundTransparency = 0.5
    confirmOverlay.Visible = false
    confirmOverlay.ZIndex = 100
    confirmOverlay.Parent = ScreenGui

    local confirmFrame = Instance.new("Frame")
    confirmFrame.Size = UDim2.new(0, 300, 0, 160)
    confirmFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
    confirmFrame.BackgroundColor3 = C.BG
    confirmFrame.ZIndex = 101
    confirmFrame.Parent = confirmOverlay
    addCorner(confirmFrame, 12)
    addStroke(confirmFrame, C.Border, 1)

    local confirmLabel = Instance.new("TextLabel")
    confirmLabel.Size = UDim2.new(1, -40, 0, 60)
    confirmLabel.Position = UDim2.new(0, 20, 0, 20)
    confirmLabel.BackgroundTransparency = 1
    confirmLabel.Text = "Are you sure you want to close Nova UI?"
    confirmLabel.TextColor3 = C.Text
    confirmLabel.TextSize = 15
    confirmLabel.Font = Enum.Font.GothamSemibold
    confirmLabel.TextWrapped = true
    confirmLabel.ZIndex = 102
    confirmLabel.Parent = confirmFrame

    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0, 120, 0, 38)
    yesBtn.Position = UDim2.new(0, 25, 1, -50)
    yesBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    yesBtn.Text = "Yes"
    yesBtn.TextColor3 = Color3.new(1,1,1)
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.ZIndex = 102
    yesBtn.Parent = confirmFrame
    addCorner(yesBtn, 8)

    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0, 120, 0, 38)
    noBtn.Position = UDim2.new(1, -145, 1, -50)
    noBtn.BackgroundColor3 = C.Card
    noBtn.Text = "No"
    noBtn.TextColor3 = C.Text
    noBtn.Font = Enum.Font.GothamBold
    noBtn.ZIndex = 102
    noBtn.Parent = confirmFrame
    addCorner(noBtn, 8)

    yesBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    noBtn.MouseButton1Click:Connect(function() confirmOverlay.Visible = false end)
    CloseBtn.MouseButton1Click:Connect(function() confirmOverlay.Visible = true end)

    -- Tab Creation Function
    function Window:CreateTab(tabName)
        local Tab = {}

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 140, 1, -12)
        btn.BackgroundColor3 = C.TabBar
        btn.Text = tabName
        btn.TextColor3 = C.TextDim
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamSemibold
        btn.AutoButtonColor = false
        btn.Parent = TabScroll
        addCorner(btn, 8)

        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Size = UDim2.new(1,0,1,0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.ScrollBarThickness = 5
        tabFrame.ScrollBarImageColor3 = C.Accent
        tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabFrame.Visible = false
        tabFrame.Parent = Content

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = tabFrame
        addPadding(tabFrame, 8, 8, 8, 8)

        Window.Tabs[tabName] = tabFrame
        Window.TabButtons[tabName] = btn

        local function selectTab()
            Window.CurrentTab = tabName
            for name, frame in pairs(Window.Tabs) do
                frame.Visible = name == tabName
                Window.TabButtons[name].BackgroundColor3 = name == tabName and C.TabActive or C.TabBar
                Window.TabButtons[name].TextColor3 = name == tabName and C.Text or C.TextDim
            end
            local x = btn.AbsolutePosition.X - TabBar.AbsolutePosition.X
            TweenService:Create(TabIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, x + 8, 1, -4)}):Play()
        end

        btn.MouseButton1Click:Connect(selectTab)
        if not Window.CurrentTab then selectTab() end

        -- Elements
        function Tab:CreateButton(text, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1,0,0,42)
            b.BackgroundColor3 = C.Accent
            b.Text = text
            b.TextColor3 = Color3.new(1,1,1)
            b.TextSize = 14
            b.Font = Enum.Font.GothamSemibold
            b.AutoButtonColor = false
            b.Parent = tabFrame
            addCorner(b, 8)

            b.MouseEnter:Connect(function() b.BackgroundColor3 = C.AccentHover end)
            b.MouseLeave:Connect(function() b.BackgroundColor3 = C.Accent end)
            b.MouseButton1Click:Connect(function() task.spawn(callback) end)
        end

        function Tab:CreateToggle(text, default, callback)
            local state = default or false
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1,0,0,44)
            row.BackgroundColor3 = C.Card
            row.Parent = tabFrame
            addCorner(row, 8)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1,-80,1,0)
            label.Position = UDim2.new(0,14,0,0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = C.Text
            label.TextSize = 14
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = row

            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0,48,0,24)
            toggleBg.Position = UDim2.new(1,-58,0.5,-12)
            toggleBg.BackgroundColor3 = state and C.ToggleOn or C.ToggleOff
            toggleBg.Parent = row
            addCorner(toggleBg, 12)

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0,18,0,18)
            circle.Position = state and UDim2.new(1,-22,0.5,-9) or UDim2.new(0,4,0.5,-9)
            circle.BackgroundColor3 = Color3.new(1,1,1)
            circle.Parent = toggleBg
            addCorner(circle, 9)

            row.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    state = not state
                    TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = state and C.ToggleOn or C.ToggleOff}):Play()
                    TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = state and UDim2.new(1,-22,0.5,-9) or UDim2.new(0,4,0.5,-9)}):Play()
                    task.spawn(callback, state)
                end
            end)
        end

        function Tab:CreateSlider(text, min, max, default, callback)
            local value = default
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1,0,0,56)
            container.BackgroundColor3 = C.Card
            container.Parent = tabFrame
            addCorner(container, 8)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1,-80,0,20)
            label.Position = UDim2.new(0,14,0,6)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = C.Text
            label.TextSize = 13
            label.Font = Enum.Font.GothamSemibold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container

            local valLabel = Instance.new("TextLabel")
            valLabel.Size = UDim2.new(0,60,0,20)
            valLabel.Position = UDim2.new(1,-70,0,6)
            valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(default)
            valLabel.TextColor3 = C.Accent
            valLabel.TextSize = 13
            valLabel.Font = Enum.Font.GothamBold
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            valLabel.Parent = container

            local track = Instance.new("Frame")
            track.Size = UDim2.new(1,-28,0,6)
            track.Position = UDim2.new(0,14,0,34)
            track.BackgroundColor3 = C.SliderTrack
            track.Parent = container
            addCorner(track, 3)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            fill.BackgroundColor3 = C.Accent
            fill.Parent = track
            addCorner(fill, 3)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0,16,0,16)
            knob.Position = UDim2.new((default-min)/(max-min), -8, 0.5, -8)
            knob.BackgroundColor3 = Color3.new(1,1,1)
            knob.Parent = track
            addCorner(knob, 8)
            addStroke(knob, C.Accent, 2)

            local dragging = false
            local function updateSlider(input)
                local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                knob.Position = UDim2.new(rel, -8, 0.5, -8)
                value = math.floor(min + rel * (max - min))
                valLabel.Text = tostring(value)
                task.spawn(callback, value)
            end

            track.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true updateSlider(i) end end)
            UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(i) end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
        end

        return Tab
    end

    return Window
end

return NovaUI
