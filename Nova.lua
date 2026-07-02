local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local NovaUI = {}

local C = {
    Bg          = Color3.fromRGB(11, 11, 14),
    Card        = Color3.fromRGB(18, 18, 24),
    TabBar      = Color3.fromRGB(14, 14, 18),
    ActiveTab   = Color3.fromRGB(24, 24, 32),
    Accent      = Color3.fromRGB(0, 220, 140),
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
        main.Size = UDim2.new(0, 580, 0, 0)
        main.BackgroundTransparency = 1
        TweenService:Create(main, TweenInfo.new(.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 580, 0, 380),
            BackgroundTransparency = 0.05
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
            TweenService:Create(main, TweenInfo.new(.3, Enum.EasingStyle.Quart), {
                Size = UDim2.new(.96, 0, .92, 0),
                Position = UDim2.new(.02, 0, .04, 0)
            }):Play()
        else
            TweenService:Create(main, TweenInfo.new(.3, Enum.EasingStyle.Quart), {
                Size = oldSize,
                Position = oldPos
            }):Play()
        end
    end)
    
    local tabBar = Instance.new("ScrollingFrame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(0, 140, 1, -52)
    tabBar.Position = UDim2.new(0, 12, 0, 40)
    tabBar.BackgroundColor3 = C.TabBar
    tabBar.BackgroundTransparency = 0.2
    tabBar.BorderSizePixel = 0
    tabBar.ScrollBarThickness = 0
    tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabBar.ScrollingDirection = Enum.ScrollingDirection.Y
    tabBar.Parent = main
    addCorner(tabBar, 6)
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.FillDirection = Enum.FillDirection.Vertical
    tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = tabBar
    addPadding(tabBar, 6, 6, 6, 6)
    
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -174, 1, -52)
    contentArea.Position = UDim2.new(0, 162, 0, 40)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = main
    addPadding(contentArea, 0, 0, 4, 0)
    
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
    
    local function updateThemeColors(newAccent)
        C.Accent = newAccent
        C.AccentHover = Color3.fromRGB(math.min(newAccent.R*255 + 25, 255), math.min(newAccent.G*255 + 25, 255), math.min(newAccent.B*255 + 25, 255))
        C.ToggleOn = newAccent
        
        local targetTextColor = (getLuminance(newAccent) > 0.6) and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        
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
                btn.TextColor3 = C.Accent
                btn.BackgroundColor3 = C.ActiveTab
            end
        end
    end
    
    function Window:CreateTab(tabName)
        local Tab = {}
        local btn = Instance.new("TextButton")
        btn.Name = tabName
        btn.Size = UDim2.new(1, 0, 0, 32) 
        btn.BackgroundColor3 = C.TabBar
        btn.BackgroundTransparency = 1
        btn.Text = tabName
        btn.TextColor3 = C.Subtext
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamMedium
        btn.BorderSizePixel = 0
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.Parent = tabBar
        addCorner(btn, 5)
        addPadding(btn, 10, 0, 0, 0)
        
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Name = tabName
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.BorderSizePixel = 0
        tabFrame.ScrollBarThickness = 3
        tabFrame.ScrollBarImageColor3 = C.Border
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabFrame.Visible = false
        tabFrame.Parent = contentArea
        
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 8)
        tabLayout.Parent = tabFrame
        
        Window.Tabs[tabName] = tabFrame
        Window.TabButtons[tabName] = btn
        
        local function selectThisTab()
            Window.CurrentTab = tabName
            for name, frame in pairs(Window.Tabs) do
                if name == tabName then
                    frame.Visible = true
                    Window.TabButtons[name].BackgroundTransparency = 0
                    Window.TabButtons[name].BackgroundColor3 = C.ActiveTab
                    Window.TabButtons[name].TextColor3 = C.Accent
                else
                    frame.Visible = false
                    Window.TabButtons[name].BackgroundTransparency = 1
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
            b.Size = UDim2.new(1, 0, 0, 36)
            b.BackgroundColor3 = C.Accent
            b.BackgroundTransparency = 0.1
            b.Text = text
            local currentTextColor = (getLuminance(C.Accent) > 0.6) and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
            b.TextColor3 = currentTextColor
            b.TextSize = 13
            b.Font = Enum.Font.GothamMedium
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.Parent = tabFrame
            addCorner(b, 6)
            
            b:SetAttribute("IsAccentButton", true)
            table.insert(allButtons, b)
            
            b.MouseEnter:Connect(function() b.BackgroundColor3 = C.AccentHover end)
            b.MouseLeave:Connect(function() b.BackgroundColor3 = C.Accent end)
            b.MouseButton1Click:Connect(function()
                local origText = b.TextColor3
                b.TextColor3 = C.Bg
                task.spawn(callback)
                task.wait(0.12)
                b.TextColor3 = origText
            end)
        end
        
        function Tab:CreateToggle(text, default, callback)
            local state = default or false
            local row = Instance.new("TextButton")
            row.Size = UDim2.new(1, 0, 0, 38)
            row.BackgroundColor3 = C.Card
            row.BackgroundTransparency = 0.2
            row.Text = ""
            row.BorderSizePixel = 0
            row.AutoButtonColor = false
            row.Parent = tabFrame
            addCorner(row, 6)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -70, 1, 0)
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = C.Text
            lbl.TextSize = 13
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row
            
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 38, 0, 20)
            toggleBg.Position = UDim2.new(1, -50, 0.5, -10)
            toggleBg.BackgroundColor3 = state and C.ToggleOn or C.ToggleOff
            toggleBg.BorderSizePixel = 0
            toggleBg.Parent = row
            addCorner(toggleBg, 10)
            
            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 14, 0, 14)
            circle.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            circle.BackgroundColor3 = state and C.Bg or C.Text
            circle.BorderSizePixel = 0
            circle.Parent = toggleBg
            addCorner(circle, 7)
            
            row.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(toggleBg, TweenInfo.new(0.15), {BackgroundColor3 = state and C.ToggleOn or C.ToggleOff}):Play()
                TweenService:Create(circle, TweenInfo.new(0.15), {
                    Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                    BackgroundColor3 = state and C.Bg or C.Text
                }):Play()
                task.spawn(callback, state)
            end)
        end
        
        function Tab:CreateSlider(text, min, max, default, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 44)
            container.BackgroundColor3 = C.Card
            container.BackgroundTransparency = 0.2
            container.BorderSizePixel = 0
            container.Parent = tabFrame
            addCorner(container, 6)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -80, 0, 20)
            lbl.Position = UDim2.new(0, 12, 0, 4)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = C.Text
            lbl.TextSize = 12
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = container
            
            local valLabel = Instance.new("TextLabel")
            valLabel.Size = UDim2.new(0, 60, 0, 20)
            valLabel.Position = UDim2.new(1, -72, 0, 4)
            valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(default)
            valLabel.TextColor3 = C.Accent
            valLabel.TextSize = 12
            valLabel.Font = Enum.Font.GothamBold
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            valLabel.Parent = container
            
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -24, 0, 4)
            track.Position = UDim2.new(0, 12, 0, 28)
            track.BackgroundColor3 = C.SliderTrack
            track.BorderSizePixel = 0
            track.Parent = container
            addCorner(track, 2)
            
            local fill = Instance.new("Frame")
            local startPercent = (default - min) / (max - min)
            fill.Size = UDim2.new(startPercent, 0, 1, 0)
            fill.BackgroundColor3 = C.Accent
            fill.BorderSizePixel = 0
            fill.Parent = track
            addCorner(fill, 2)
            
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 10, 0, 10)
            knob.Position = UDim2.new(startPercent, -5, 0.5, -5)
            knob.BackgroundColor3 = C.Text
            knob.BorderSizePixel = 0
            knob.Parent = track
            addCorner(knob, 5)
            
            local dragging = false
            local function updateSlider(inputObj)
                local relX = math.clamp((inputObj.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(relX, 0, 1, 0)
                knob.Position = UDim2.new(relX, -5, 0.5, -5)
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
        {Name = "Delta Green (Default)", Color = Color3.fromRGB(0, 220, 140)},
        {Name = "Vibrant Cyan", Color = Color3.fromRGB(0, 200, 255)},
        {Name = "Delta Purple", Color = Color3.fromRGB(130, 80, 250)},
        {Name = "Hot Crimson", Color = Color3.fromRGB(240, 60, 80)},
        {Name = "Amber Orange", Color = Color3.fromRGB(250, 140, 40)},
        {Name = "Clean Frost", Color = Color3.fromRGB(240, 240, 245)},
    }
    
    for _, preset in ipairs(colorPresets) do
        themesTab:CreateButton(preset.Name, function()
            updateThemeColors(preset.Color)
        end)
    end
    
    return Window
end

local MyWindow = NovaUI:CreateWindow("Delta UI")
local MainTab = MyWindow:CreateTab("Main Workspace")
MainTab:CreateButton("Test Button", function()
    print("Button pressed!")
end)
MainTab:CreateToggle("Test Toggle", false, function(state)
    print("Toggle state:", state)
end)
MainTab:CreateSlider("Test Slider", 0, 100, 50, function(value)
    print("Slider value:", value)
end)

return NovaUI
