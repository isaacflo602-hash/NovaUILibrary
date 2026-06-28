local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Window = NovaUI:CreateWindow("Nova Engine")
local MainTab = Window:CreateTab("Player")

local originalSize = UDim2.new(0, 520, 0, 440)
local originalPosition = UDim2.new(0.5, -260, 0.5, -220)
local isFullScreen = false

local mainFrame = Window.MainFrame 
local screenGui = Window.ScreenGui   

Window.CloseButton.MouseButton1Click:Connect(function()
    local confirmOverlay = Instance.new("Frame")
    confirmOverlay.Size = UDim2.new(1, 0, 1, 0)
    confirmOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    confirmOverlay.BackgroundTransparency = 0.4
    confirmOverlay.Parent = mainFrame
    
    local confirmBox = Instance.new("Frame")
    confirmBox.Size = UDim2.new(0, 300, 0, 120)
    confirmBox.Position = UDim2.new(0.5, -150, 0.5, -60)
    confirmBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    confirmBox.Parent = confirmOverlay
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 0, 50)
    txt.Text = "Are you sure you wanna unload this script?"
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.TextSize = 14
    txt.BackgroundTransparency = 1
    txt.Parent = confirmBox
    
    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0, 100, 0, 35)
    yesBtn.Position = UDim2.new(0.2, 0, 0.6, 0)
    yesBtn.Text = "Yes"
    yesBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    yesBtn.Parent = confirmBox
    
    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0, 100, 0, 35)
    noBtn.Position = UDim2.new(0.55, 0, 0.6, 0)
    noBtn.Text = "No"
    noBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    noBtn.Parent = confirmBox
    
    yesBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    noBtn.MouseButton1Click:Connect(function()
        confirmOverlay:Destroy()
    end)
end)

Window.MinimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    
    local openBtn = Instance.new("TextButton")
    openBtn.Size = UDim2.new(0, 50, 0, 50)
    openBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
    openBtn.BackgroundColor3 = Color3.fromRGB(124, 92, 252)
    openBtn.Text = "Open"
    openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    openBtn.Parent = screenGui
    
    openBtn.Active = true
    openBtn.Draggable = true
    
    openBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        openBtn:Destroy() 
    end)
end)

Window.FullScreenButton.MouseButton1Click:Connect(function()
    if not isFullScreen then
        originalSize = mainFrame.Size
        originalPosition = mainFrame.Position
        
        mainFrame.Position = UDim2.new(0, 0, 0, 0)
        mainFrame.Size = UDim2.new(1, 0, 1, 0)
        isFullScreen = true
    else
        mainFrame.Size = originalSize
        mainFrame.Position = originalPosition
        isFullScreen = false
    end
end)
