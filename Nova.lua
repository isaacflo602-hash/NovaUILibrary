--[[
    NovaUI - Modern Edition (Fully Working)
    Author: Grok (updated for you)
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

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
    ScreenGui.Name = "NovaUI_Modern"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    -- Shadow
    local Shadow = Instance.new("Frame")
    Shadow.Size = UDim2.new(0, 540, 0, 460)
    Shadow.Position = UDim2.new(0.5, -270, 0.5, -230)
    Shadow.BackgroundColor3 = Color3.new(0,0,0)
    Shadow.BackgroundTransparency = 0.65
    Shadow.BorderSizePixel = 0
    Shadow.Parent = ScreenGui
    addCorner(Shadow, 20)

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 520, 0, 440)
    Main.Position = UDim2.new(0.5, -260, 0.5, -220)
    Main.BackgroundColor3 = C.BG
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    addCorner(Main, 12)
    addStroke(Main, C.Border, 1)

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 46)
    TitleBar.BackgroundColor3 = C.TitleBar
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    addCorner(TitleBar, 12)

    local TitleCover = Instance.new("Frame")
    TitleCover.Size = UDim2.new(1, 0, 0, 14)
    TitleCover.Position = UDim2.new(0, 0, 1, -14)
    TitleCover.BackgroundColor3 = C.TitleBar
    TitleCover.BorderSizePixel = 0
    TitleCover.Parent = TitleBar

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
    local function createWinBtn(icon, color, xOffset)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 34, 0, 26)
        btn.Position = UDim2.new(1, xOffset, 0.5, -13)
        btn.BackgroundColor3 = color
        btn.Text = icon
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = TitleBar
        addCorner(btn, 6)
        return btn
    end

    local CloseBtn = createWinBtn("✕", Color3.fromRGB(239, 68, 68), -46)
    local FullBtn = createWinBtn("⛶", Color3.fromRGB(34, 197, 94), -86)
    local MinBtn = createWinBtn("—", Color3.fromRGB(250, 204, 21), -126)

    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 46)
    TabBar.Position = UDim2.new(0, 0, 0, 46)
    TabBar.BackgroundColor3 = C.TabBar
    TabBar.BorderSizePixel = 0
    TabBar.ClipsDescendants = true
    TabBar.Parent = Main

    local LeftArrow = Instance.new("TextButton")
    LeftArrow.Size = UDim2.new(0, 30, 1, 0)
    LeftArrow.BackgroundColor3 = Color3.fromRGB(20,20,42)
    LeftArrow.Text = "‹"
    LeftArrow.TextColor3 = C.Text
    LeftArrow.TextSize = 20
    LeftArrow.Font = Enum.Font.GothamBold
    LeftArrow.Parent = TabBar
    addCorner(LeftArrow, 0)

    local RightArrow = Instance.new("TextButton")
    RightArrow.Size = UDim2.new(0, 30, 1, 0)
    RightArrow.Position = UDim2.new(1, -30, 0, 0)
    RightArrow.BackgroundColor3 = Color3.fromRGB(20,20,42)
    RightArrow.Text = "›"
    RightArrow.TextColor3 = C.Text
    RightArrow.TextSize = 20
    RightArrow.Font = Enum.Font.GothamBold
    RightArrow.Parent = TabBar
    addCorner(RightArrow, 0)

    local TabIndicator = Instance.new("Frame")
    TabIndicator.Size = UDim2.new(0, 140, 0, 3)
    TabIndicator.BackgroundColor3 = C.TabActive
    TabIndicator.Position = UDim2.new(0, 30, 1, -3)
    TabIndicator.Parent = TabBar
    addCorner(TabIndicator, 2)

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Size = UDim2.new(1, -60, 1, 0)
    TabScroll.Position = UDim2.new(0, 30, 0, 0)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 0
    TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabScroll.Parent = TabBar

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.Padding = UDim.new(0, 8)
    TabListLayout.Parent = TabScroll
    addPadding(TabScroll, 8, 8, 8, 8)

    -- Content Area
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
            Shadow.Position = Main.Position + UDim2.new(0, -10, 0, -10)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Window Controls
    local isMinimized, isFullscreen = false, false
    local normalSize, normalPos = Main.Size, Main.Position

    local function syncShadow()
        Shadow.Size = Main.Size + UDim2.new(0, 20, 0, 20)
        Shadow.Position = Main.Position + UDim2.new(0, -10, 0, -10)
    end

    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            normalSize = Main.Size
            normalPos = Main.Position
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 320, 0, 46)}):Play()
            TweenService:Create(Shadow, TweenInfo.new(0.3), {Size = UDim2.new(0, 340, 0, 66)}):Play()
            Content.Visible = false
            TabBar.Visible = false
        else
            Content.Visible = true
            TabBar.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Size = normalSize, Position = normalPos}):Play()
            syncShadow()
        end
    end)

    FullBtn.MouseButton1Click:Connect(function()
        isFullscreen = not isFullscreen
        if isFullscreen then
            normalSize = Main.Size
            normalPos = Main.Position
            local fs = UDim2.new(0.92, 0, 0.9, 0)
            local fp = UDim2.new(0.04, 0, 0.05, 0)
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = fs, Position = fp}):Play()
            syncShadow()
        else
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = normalSize, Position = normalPos}):Play()
            syncShadow()
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Tab System
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
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
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
        addPadding(tabFrame, 6, 6, 6, 6)

        Window.Tabs[tabName] = tabFrame
        Window.TabButtons[tabName] = btn

        local function selectThis()
            Window.CurrentTab = tabName
            for name, frame in pairs(Window.Tabs) do
                frame.Visible = (name == tabName)
                local b = Window.TabButtons[name]
                b.BackgroundColor3 = (name == tabName) and C.TabActive or C.TabBar
                b.TextColor3 = (name == tabName) and C.Text or C.TextDim
            end

            local absX = btn.AbsolutePosition.X - TabBar.AbsolutePosition.X
            TweenService:Create(TabIndicator, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
                Position = UDim2.new(0, absX + 8, 1, -3)
            }):Play()
        end

        btn.MouseButton1Click:Connect(selectThis)
        if not Window.CurrentTab then selectThis() end

        -- Elements
        function Tab:CreateButton(text, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 42)
            b.BackgroundColor3 = C.Accent
            b.Text = text
            b.TextColor3 = Color3.new(1,1,1)
            b.TextSize = 14
            b.Font = Enum.Font.GothamSemibold
            b.AutoButtonColor = false
            b.Parent = tabFrame
            addCorner(b, 8)

            b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = C.AccentHover}):Play() end)
            b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = C.Accent}):Play() end)
            b.MouseButton1Click:Connect(function() task.spawn(callback) end)
        end

        function Tab:CreateToggle(text, default, callback)
            local state = default or false
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 44)
            row.BackgroundColor3 = C.Card
            row.BorderSizePixel = 0
            row.Parent = tabFrame
            addCorner(row, 8)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -80, 1, 0)
            label.Position = UDim2.new(0, 14, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = C.Text
            label.TextSize = 14
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = row

            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 48, 0, 24)
            toggleBg.Position = UDim2.new(1, -58, 0.5, -12)
            toggleBg.BackgroundColor3 = state and C.ToggleOn or C.ToggleOff
            toggleBg.BorderSizePixel = 0
            toggleBg.Parent = row
            addCorner(toggleBg, 12)

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 18, 0, 18)
            circle.Position = state and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
            circle.BackgroundColor3 = Color3.new(1,1,1)
            circle.BorderSizePixel = 0
            circle.Parent = toggleBg
            addCorner(circle, 9)

            row.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    state = not state
                    TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = state and C.ToggleOn or C.ToggleOff}):Play()
                    TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                        Position = state and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
                    }):Play()
                    task.spawn(callback, state)
                end
            end)
        end

        function Tab:CreateSlider(text, min, max, default, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 56)
            container.BackgroundColor3 = C.Card
            container.BorderSizePixel = 0
            container.Parent = tabFrame
            addCorner(container, 8)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -70, 0, 20)
            label.Position = UDim2.new(0, 14, 0, 6)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = C.Text
            label.TextSize = 13
            label.Font = Enum.Font.GothamSemibold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container

            local valLabel = Instance.new("TextLabel")
            valLabel.Size = UDim2.new(0, 60, 0, 20)
            valLabel.Position = UDim2.new(1, -70, 0, 6)
            valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(default)
            valLabel.TextColor3 = C.Accent
            valLabel.TextSize = 13
            valLabel.Font = Enum.Font.GothamBold
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            valLabel.Parent = container

            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -28, 0, 6)
            track.Position = UDim2.new(0, 14, 0, 34)
            track.BackgroundColor3 = C.SliderTrack
            track.BorderSizePixel = 0
            track.Parent = container
            addCorner(track, 3)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = C.Accent
            fill.BorderSizePixel = 0
            fill.Parent = track
            addCorner(fill, 3)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
            knob.BackgroundColor3 = Color3.new(1,1,1)
            knob.BorderSizePixel = 0
            knob.Parent = track
            addCorner(knob, 8)
            addStroke(knob, C.Accent, 2)

            local dragging = false
            local function update(input)
                local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                knob.Position = UDim2.new(rel, -8, 0.5, -8)
                local value = math.floor(min + rel * (max - min))
                valLabel.Text = tostring(value)
                task.spawn(callback, value)
            end

            track.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update(i) end end)
            knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
            UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement) then update(i) end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
        end

        return Tab
    end

    return Window
end

return NovaUI
