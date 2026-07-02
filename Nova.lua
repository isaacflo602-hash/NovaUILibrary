local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local NovaUI = {}
local C = {
    Bg = Color3.fromRGB(15, 15, 26),
    Card = Color3.fromRGB(26, 26, 46),
    TabBar = Color3.fromRGB(22, 22, 42),
    ActiveTab = Color3.fromRGB(42, 42, 74),
    Accent = Color3.fromRGB(124, 92, 252),
    AccentHover = Color3.fromRGB(160, 132, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Subtext = Color3.fromRGB(136, 136, 170),
    Border = Color3.fromRGB(42, 42, 74),
    ToggleOff = Color3.fromRGB(50, 50, 80),
    ToggleOn = Color3.fromRGB(124, 92, 252),
    HoverCard = Color3.fromRGB(36, 36, 60),
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
    screenGui.Name = "NovaUI_Instance"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = player:WaitForChild("PlayerGui")
   
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 520, 0, 440)
    main.Position = UDim2.new(0.5, -260, 0.5, -220)
    main.BackgroundColor3 = C.Bg
    main.BackgroundTransparency = 0.15
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = screenGui
   
    addCorner(main, 12)
    local mainStroke = addStroke(main, C.Border, 1)
   
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 44)
    titleBar.BackgroundColor3 = C.Card
    titleBar.BackgroundTransparency = 0.15
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    addCorner(titleBar, 12)
   
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 12)
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.BackgroundColor3 = C.Card
    titleFix.BackgroundTransparency = 0.15
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
        if closeDragToggle then return end
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
            BackgroundTransparency = 0.15
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
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        elseif input == closeDragInput and closeDragToggle then
            local delta = input.Position - closeDragStart
            showButton.Position = UDim2.new(closeStartPos.X.Scale, closeStartPos.X.Offset + delta.X, closeStartPos.Y.Scale, closeStartPos.Y.Offset + delta.Y)
        end
    end)
   
    local allButtons = {}
    local allLabels = {}
   
    local function updateThemeColors(newAccent)
        C.Accent = newAccent
        C.AccentHover = Color3.fromRGB(math.min(newAccent.R*255 + 30, 255), math.min(newAccent.G*255 + 30, 255), math.min(newAccent.B*255 + 30, 255))
        C.ToggleOn = newAccent
       
        local targetTextColor = (getLuminance(newAccent) > 0.7) and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
       
        showButton.BackgroundColor3 = C.Accent
        showButton.TextColor3 = targetTextColor
       
        for _, btn in ipairs(allButtons) do
            if btn:GetAttribute("IsAccentButton") then
                btn.BackgroundColor3 = C.Accent
                btn.TextColor3 = targetTextColor
            end
        end
       
        for btn, name in pairs(Window.TabButtons) do
            if Window.CurrentTab == name then
                btn.BackgroundColor3 = C.ActiveTab
                btn.TextColor3 = C.Text
            end
        end
    end
   
    function Window:CreateTab(tabName)
        local Tab = {}
        local btn = Instance.new("TextButton")
        btn.Name = tabName
        btn.Size = UDim2.new(0, 112, 1, 0)
        btn.BackgroundColor3 = C.TabBar
        btn.BackgroundTransparency = 0.3
        btn.Text = tabName
        btn.TextColor3 = C.Subtext
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamMedium
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = tabBar
        addCorner(btn, 6)
       
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Name = tabName
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.BorderSizePixel = 0
        tabFrame.ScrollBarThickness = 4
        tabFrame.ScrollBarImageColor3 = C.Border
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabFrame.Visible = false
        tabFrame.Parent = contentArea
       
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 10)
        tabLayout.Parent = tabFrame
       
        Window.Tabs[tabName] = tabFrame
        Window.TabButtons[tabName] = btn
       
        local function selectThisTab()
            Window.CurrentTab = tabName
            for name, frame in pairs(Window.Tabs) do
                if name == tabName then
                    frame.Visible = true
                    Window.TabButtons[name].BackgroundColor3 = C.ActiveTab
                    Window.TabButtons[name].TextColor3 = C.Text
                else
                    frame.Visible = false
                    Window.TabButtons[name].BackgroundColor3 = C.TabBar
                    Window.TabButtons[name].TextColor3 = C.Subtext
                end
            end
        end
       
        btn.MouseButton1Click:Connect(selectThisTab)
       
        if not Window.CurrentTab then
            selectThisTab()
        end
       
        function Tab:CreateButton(text, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 40)
            b.BackgroundColor3 = C.Accent
            b.BackgroundTransparency = 0.15
            b.Text = text
            local currentTextColor = (getLuminance(C.Accent) > 0.7) and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
            b.TextColor3 = currentTextColor
            b.TextSize = 14
            b.Font = Enum.Font.GothamMedium
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.Parent = tabFrame
            addCorner(b, 8)
           
            b:SetAttribute("IsAccentButton", true)
            table.insert(allButtons, b)
           
            b.MouseEnter:Connect(function() b.BackgroundColor3 = C.AccentHover end)
            b.MouseLeave:Connect(function() b.BackgroundColor3 = C.Accent end)
            b.MouseButton1Click:Connect(function()
                local origText = b.TextColor3
                b.TextColor3 = C.Accent
                task.spawn(callback)
                task.wait(0.15)
                b.TextColor3 = origText
            end)
        end
       
        function Tab:CreateToggle(text, default, callback)
            local state = default or false
            local row = Instance.new("TextButton")
            row.Size = UDim2.new(1, 0, 0, 44)
            row.BackgroundColor3 = C.Card
            row.BackgroundTransparency = 0.15
            row.Text = ""
            row.BorderSizePixel = 0
            row.AutoButtonColor = false
            row.Parent = tabFrame
            addCorner(row, 8)
           
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -70, 1, 0)
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = C.Text
            lbl.TextSize = 14
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row
           
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 44, 0, 24)
            toggleBg.Position = UDim2.new(1, -56, 0.5, -12)
            toggleBg.BackgroundColor3 = state and C.ToggleOn or C.ToggleOff
            toggleBg.BackgroundTransparency = 0.15
            toggleBg.BorderSizePixel = 0
            toggleBg.Parent = row
            addCorner(toggleBg, 12)
           
            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 18, 0, 18)
            circle.Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            circle.BackgroundColor3 = C.Text
            circle.BorderSizePixel = 0
            circle.Parent = toggleBg
            addCorner(circle, 9)
           
            row.MouseButton1Click:Connect(function()
                state = not state
                toggleBg.BackgroundColor3 = state and C.ToggleOn or C.ToggleOff
                circle.Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                task.spawn(callback, state)
            end)
        end
       
        function Tab:CreateSlider(text, min, max, default, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 48)
            container.BackgroundColor3 = C.Card
            container.BackgroundTransparency = 0.15
            container.BorderSizePixel = 0
            container.Parent = tabFrame
            addCorner(container, 8)
           
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -80, 0, 20)
            lbl.Position = UDim2.new(0, 10, 0, 4)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = C.Text
            lbl.TextSize = 13
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = container
           
            local valLabel = Instance.new("TextLabel")
            valLabel.Size = UDim2.new(0, 60, 0, 20)
            valLabel.Position = UDim2.new(1, -70, 0, 4)
            valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(default)
            valLabel.TextColor3 = C.Accent
            valLabel.TextSize = 13
            valLabel.Font = Enum.Font.GothamBold
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            valLabel.Parent = container
           
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -20, 0, 6)
            track.Position = UDim2.new(0, 10, 0, 30)
            track.BackgroundColor3 = C.SliderTrack
            track.BackgroundTransparency = 0.15
            track.BorderSizePixel = 0
            track.Parent = container
            addCorner(track, 3)
           
            local fill = Instance.new("Frame")
            local startPercent = (default - min) / (max - min)
            fill.Size = UDim2.new(startPercent, 0, 1, 0)
            fill.BackgroundColor3 = C.Accent
            fill.BorderSizePixel = 0
            fill.Parent = track
            addCorner(fill, 3)
           
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 14, 0, 14)
            knob.Position = UDim2.new(startPercent, -7, 0.5, -7)
            knob.BackgroundColor3 = C.Text
            knob.BorderSizePixel = 0
            knob.Parent = track
            addCorner(knob, 7)
           
            local dragging = false
            local function updateSlider(inputObj)
                local relX = math.clamp((inputObj.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(relX, 0, 1, 0)
                knob.Position = UDim2.new(relX, -7, 0.5, -7)
                local calculatedValue = math.floor(min + (relX * (max - min)))
                valLabel.Text = tostring(calculatedValue)
                task.spawn(callback, calculatedValue)
            end
           
            track.InputBegan:Connect(function(inputObj)
                if inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(inputObj)
                end
            end)
           
            UIS.InputEnded:Connect(function(inputObj)
                if inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
           
            UIS.InputChanged:Connect(function(inputObj)
                if dragging and (inputObj.UserInputType == Enum.UserInputType.MouseMovement or inputObj.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(inputObj)
                end
            end)
        end
       
        return Tab
    end
   
    local themesTab = Window:CreateTab("Themes")
   
    local colorPresets = {
        {Name = "Purple (Default)", Color = Color3.fromRGB(124, 92, 252)},
        {Name = "Red", Color = Color3.fromRGB(230, 50, 50)},
        {Name = "Green", Color = Color3.fromRGB(40, 210, 90)},
        {Name = "Blue", Color = Color3.fromRGB(50, 130, 240)},
        {Name = "Orange", Color = Color3.fromRGB(245, 135, 45)},
        {Name = "White", Color = Color3.fromRGB(255, 255, 255)},
    }
   
    for _, preset in ipairs(colorPresets) do
        themesTab:CreateButton(preset.Name, function()
            updateThemeColors(preset.Color)
        end)
    end
   
    return Window
end
return NovaUI
