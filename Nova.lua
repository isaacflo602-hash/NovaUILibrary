
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
    tabBar.Position = UDim2.new(0, 12, 0, 60)
    tabBar.BackgroundColor3 = C.TabBar
    tabBar.BackgroundTransparency = 0.4
    tabBar.BorderSizePixel = 0
    tabBar.ScrollBarThickness = 0
    tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabBar.ScrollingDirection = Enum.ScrollingDirection.X
    tabBar.ClipsDescendants = false
    tabBar.Parent = main
    addCorner(tabBar, 12)

    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.VerticalAlignment = Enum.VerticalAlignment.Center
    tabList.Padding = UDim.new(0, 8)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabBar

    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -24, 1, -122)
    contentArea.Position = UDim2.new(0, 12, 0, 114)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = main

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

    local dragToggle = false
    local dragStart
    local startPos

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

    UIS.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    function Window:CreateTab(tabName)
        local Tab = {}

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 130, 0, 38)
        btn.BackgroundColor3 = C.TabBar
        btn.BackgroundTransparency = 0.3
        btn.Text = tabName
        btn.TextColor3 = C.Subtext
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamSemibold
        btn.TextXAlignment = Enum.TextXAlignment.Center
        btn.TextYAlignment = Enum.TextYAlignment.Center
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.ClipsDescendants = false
        btn.Parent = tabBar
        addCorner(btn, 10)

        local underline = Instance.new("Frame")
        underline.Name = "Underline"
        underline.Size = UDim2.new(1, -20, 0, 3)
        underline.Position = UDim2.new(0.5, -55, 1, -3)
        underline.BackgroundColor3 = C.ActiveTab
        underline.BorderSizePixel = 0
        underline.BackgroundTransparency = 1
        underline.Parent = btn

        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.ScrollBarThickness = 6
        tabFrame.ScrollBarImageColor3 = C.Accent
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabFrame.Visible = false
        tabFrame.Parent = contentArea

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 10)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = tabFrame

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 5)
        padding.PaddingLeft = UDim.new(0, 5)
        padding.PaddingRight = UDim.new(0, 5)
        padding.Parent = tabFrame

        Window.Tabs[tabName] = tabFrame
        Window.TabButtons[tabName] = btn

        local function selectTab()
            Window.CurrentTab = tabName
            
            for name, frame in pairs(Window.Tabs) do
                local active = (name == tabName)
                frame.Visible = active
                
                local b = Window.TabButtons[name]
                if b then
                    TweenService:Create(b, TweenInfo.new(0.25), {
                        BackgroundColor3 = active and C.Card or C.TabBar,
                        TextColor3 = active and C.Text or C.Subtext
                    }):Play()
                    
                    local line = b:FindFirstChild("Underline")
                    if line then
                        TweenService:Create(line, TweenInfo.new(0.3), {
                            BackgroundTransparency = active and 0 or 1
                        }):Play()
                    end
                end
            end
        end

        btn.MouseButton1Click:Connect(selectTab)
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
        end)
        btn.MouseLeave:Connect(function()
            if Window.CurrentTab == tabName then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            else
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
            end
        end)

        if not Window.CurrentTab then
            selectTab()
        end

        function Tab:CreateButton(text, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 48)
            b.BackgroundColor3 = C.Accent
            b.Text = text
            b.TextColor3 = C.Text
            b.TextSize = 15
            b.Font = Enum.Font.GothamSemibold
            b.BorderSizePixel = 0
            b.Parent = tabFrame
            addCorner(b, 12)
            addStroke(b, C.Accent, 1, 0.5)

            b.MouseButton1Click:Connect(function()
                task.spawn(callback)
            end)
            return b
        end

        function Tab:CreateToggle(text, default, callback)
            local toggled = default or false

            local toggleFrame = Instance.new("TextButton")
            toggleFrame.Size = UDim2.new(1, 0, 0, 48)
            toggleFrame.BackgroundColor3 = C.Card
            toggleFrame.Text = ""
            toggleFrame.AutoButtonColor = false
            toggleFrame.Parent = tabFrame
            addCorner(toggleFrame, 12)
            addStroke(toggleFrame, C.Border, 1, 0.6)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -60, 1, 0)
            label.Position = UDim2.new(0, 16, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = C.Text
            label.TextSize = 15
            label.Font = Enum.Font.GothamSemibold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = toggleFrame

            local switch = Instance.new("Frame")
            switch.Size = UDim2.new(0, 42, 0, 22)
            switch.Position = UDim2.new(1, -58, 0.5, -11)
            switch.BackgroundColor3 = toggled and C.ToggleOn or C.ToggleOff
            switch.Parent = toggleFrame
            addCorner(switch, 11)

            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 16, 0, 16)
            indicator.Position = UDim2.new(0, toggled and 23 or 3, 0.5, -8)
            indicator.BackgroundColor3 = C.Text
            indicator.Parent = switch
            addCorner(indicator, 8)

            local function updateToggle()
                TweenService:Create(switch, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                    BackgroundColor3 = toggled and C.ToggleOn or C.ToggleOff
                }):Play()
                TweenService:Create(indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                    Position = UDim2.new(0, toggled and 23 or 3, 0.5, -8)
                }):Play()
                task.spawn(callback, toggled)
            end

            toggleFrame.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
            end)

            return toggleFrame
        end

        return Tab
    end

    return Window
end

return NovaUI

```
