local ScatheLib = {}

-- Утилиты для очистки предыдущих экземпляров
if ScreenGui_ then ScreenGui_:Destroy() end
if Scathe_ then Scathe_:Destroy() end

-- Сервисы
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")

-- Определение CoreGui
local CoreGui
if RunService:IsStudio() then
    CoreGui = Players.LocalPlayer:WaitForChild("PlayerGui")
else
    CoreGui = game:GetService("CoreGui")
end

-- Иконки для уведомлений
local Warning_ = "http://www.roblox.com/asset/?id=3192540038"
local Success_ = "http://www.roblox.com/asset/?id=279548030"
local Error_ = "http://www.roblox.com/asset/?id=2022095309"

-- Предзагрузка иконок
ContentProvider:PreloadAsync({Success_, Warning_, Error_})

-- Вспомогательные функции
function ScatheLib:UICorner(instance, num)
    local UIC = Instance.new("UICorner")
    UIC.CornerRadius = UDim.new(0, num or 8)
    UIC.Parent = instance
    return UIC
end

function ScatheLib:UIPad(instance, left, top, right, bottom)
    local UIP = Instance.new("UIPadding")
    UIP.PaddingLeft = UDim.new(0, left or 0)
    UIP.PaddingTop = UDim.new(0, top or 0)
    UIP.PaddingRight = UDim.new(0, right or 0)
    UIP.PaddingBottom = UDim.new(0, bottom or 0)
    UIP.Parent = instance
    return UIP
end

function ScatheLib:UIList(instance, padding, align, sortOrder)
    local UIL = Instance.new("UIListLayout")
    UIL.Padding = UDim.new(0, padding or 0)
    UIL.HorizontalAlignment = align or "Center"
    UIL.SortOrder = sortOrder or "LayoutOrder"
    UIL.Parent = instance
    return UIL
end

-- Система уведомлений
function ScatheLib:Notification(types, name, content, time)
    task.spawn(function()
        -- Создаем ScreenGui если его нет
        if not getgenv().Scathe_ then
            local ScreenGuis = Instance.new("ScreenGui")
            ScreenGuis.Name = "ScatheNotifications"
            ScreenGuis.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            ScreenGuis.Parent = CoreGui
            getgenv().Scathe_ = ScreenGuis
            
            local Frame_ = Instance.new("Frame")
            Frame_.AnchorPoint = Vector2.new(0.5,0.5)
            Frame_.Position = UDim2.new(0.88,0,0.5,0)
            Frame_.Size = UDim2.new(1,0,1.09,0)
            Frame_.BackgroundTransparency = 1
            Frame_.Parent = ScreenGuis
            
            self:UIList(Frame_, 4, "Center")
        end
        
        local Frame_ = getgenv().Scathe_:FindFirstChild("Frame")
        
        -- Создаем уведомление
        local notification = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local bottomFrame = Instance.new("Frame")
        local bottomFrame_UICorner = Instance.new("UICorner")
        local notificationName = Instance.new("TextLabel")
        local notificationContent = Instance.new("TextLabel")
        local Icon = Instance.new("ImageLabel")

        notification.Name = "notification"
        notification.Parent = Frame_
        notification.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
        notification.BorderSizePixel = 0
        notification.AnchorPoint = Vector2.new(0.5,0.5)
        notification.Position = UDim2.new(0.5, 0, 0, 0)
        notification.Size = UDim2.new(0, 363, 0, 72)
        notification.ZIndex = 10

        self:UICorner(notification, 3)

        bottomFrame.Name = "bottomFrame"
        bottomFrame.Parent = notification
        bottomFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        bottomFrame.BorderSizePixel = 0
        bottomFrame.Position = UDim2.new(0, 0, 0.665, 0)
        bottomFrame.Size = UDim2.new(0, 362, 0, 24)
        bottomFrame.ZIndex = 10

        bottomFrame_UICorner.CornerRadius = UDim.new(0, 3)
        bottomFrame_UICorner.Parent = bottomFrame

        notificationName.Name = "notificationName"
        notificationName.Parent = notification
        notificationName.BackgroundTransparency = 1
        notificationName.Position = UDim2.new(0.140, 0, 0.098, 0)
        notificationName.Size = UDim2.new(0, 300, 0, 17)
        notificationName.Font = Enum.Font.GothamBold
        notificationName.Text = tostring(name)
        notificationName.TextScaled = true
        notificationName.TextColor3 = Color3.fromRGB(255, 255, 255)
        notificationName.TextSize = 13
        notificationName.TextXAlignment = Enum.TextXAlignment.Left
        notificationName.ZIndex = 10

        notificationContent.Name = "notificationContent"
        notificationContent.Parent = notification
        notificationContent.BackgroundTransparency = 1
        notificationContent.Position = UDim2.new(0.140, 0, 0.309, 0)
        notificationContent.Size = UDim2.new(0, 312, 0, 26)
        notificationContent.Font = Enum.Font.Gotham
        notificationContent.Text = tostring(content)
        notificationContent.TextScaled = true
        notificationContent.TextColor3 = Color3.fromRGB(150, 150, 150)
        notificationContent.TextSize = 13
        notificationContent.TextXAlignment = Enum.TextXAlignment.Left
        notificationContent.ZIndex = 10

        local typer = tostring(types)
        local types = string.lower(typer)

        if types == "warning" or types == "warn" then
            Icon.Name = "warningIcon"
            Icon.Parent = notification
            Icon.BackgroundTransparency = 1
            Icon.Position = UDim2.new(0.019, 0, 0.098, 0)
            Icon.Size = UDim2.new(0, 38, 0, 40)
            Icon.Image = Warning_
        elseif types == "success" or types == "check" then
            Icon.Name = "SuccessIcon"
            Icon.Parent = notification
            Icon.BackgroundTransparency = 1
            Icon.Position = UDim2.new(0.019, 0, 0.098, 0)
            Icon.Size = UDim2.new(0, 38, 0, 38)
            Icon.Image = Success_
        elseif types == "error" or types == "fail" then
            Icon.Name = "ErrorIcon"
            Icon.Parent = notification
            Icon.BackgroundTransparency = 1
            Icon.Position = UDim2.new(0.030, 0, 0.108, 0)
            Icon.Size = UDim2.new(0, 33, 0, 33)
            Icon.Image = Error_
        end

        -- Анимация уведомления
        local TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local Tween_ = TweenService:Create(notification, TweenInfo, {Position = UDim2.new(0.5, 0, 0.005, 0)})
        local Tweened_ = TweenService:Create(notification, TweenInfo, {Position = UDim2.new(0.5, 0, -0.15, 0)})

        Tween_:Play()
        delay(time or 4, function()
            Tweened_:Play()
            task.wait(0.5)
            notification:Destroy()
        end)
    end)
end

-- Создание окна GUI
function ScatheLib:CreateWindow(name)
    local ScreenGui = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame")
    local tabPreview = Instance.new("Frame")
    local topBar = Instance.new("Frame")
    local LibName = Instance.new("TextLabel")
    local Hubname = Instance.new("TextLabel")
    local tabList = Instance.new("ScrollingFrame")

    getgenv().ScreenGui_ = ScreenGui

    ScreenGui.Name = "ScatheLibWindow"
    ScreenGui.Parent = CoreGui
    ScreenGui.Enabled = true

    mainFrame.Name = "mainFrame"
    mainFrame.Parent = ScreenGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Size = UDim2.new(0, 547, 0, 385)
    mainFrame.ZIndex = 1

    self:UICorner(mainFrame, 4)

    tabPreview.Name = "tabPreview"
    tabPreview.Parent = mainFrame
    tabPreview.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabPreview.Position = UDim2.new(0.304, 0, 0.083, 0)
    tabPreview.Size = UDim2.new(0, 372, 0, 350)

    self:UICorner(tabPreview, 4)

    topBar.Name = "topBar"
    topBar.Parent = mainFrame
    topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    topBar.Size = UDim2.new(0, 548, 0, 26)

    self:UICorner(topBar, 4)

    LibName.Name = "LibName"
    LibName.Parent = topBar
    LibName.BackgroundTransparency = 1
    LibName.Position = UDim2.new(0.016, 0, 0, 0)
    LibName.Size = UDim2.new(0, 147, 0, 33)
    LibName.Font = Enum.Font.Gotham
    LibName.Text = "Scathe Lib"
    LibName.TextColor3 = Color3.fromRGB(255, 255, 255)
    LibName.TextSize = 14
    LibName.TextXAlignment = Enum.TextXAlignment.Left

    Hubname.Name = "Hubname"
    Hubname.Parent = topBar
    Hubname.BackgroundTransparency = 1
    Hubname.Position = UDim2.new(0.208, 0, 0, 0)
    Hubname.Size = UDim2.new(0, 147, 0, 33)
    Hubname.Font = Enum.Font.Gotham
    Hubname.Text = "- ".. tostring(name)
    Hubname.TextColor3 = Color3.fromRGB(213, 213, 213)
    Hubname.TextSize = 11
    Hubname.TextXAlignment = Enum.TextXAlignment.Left

    tabList.Name = "tabList"
    tabList.Parent = mainFrame
    tabList.Active = true
    tabList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabList.BorderSizePixel = 0
    tabList.Position = UDim2.new(0.014, 0, 0.083, 0)
    tabList.Size = UDim2.new(0, 147, 0, 350)
    tabList.ScrollBarThickness = 4
    tabList.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left

    self:UICorner(tabList, 4)
    self:UIList(tabList, 6)
    self:UIPad(tabList, nil, 4)

    local visibles = {}
    local tabsCreated = 0

    local Window = {}

    function Window:CreateTab(name, clicked)
        local tabBtn = Instance.new("TextButton")
        local inTab = Instance.new("ScrollingFrame")
        local designA = Instance.new("TextLabel")
        local UIGradient = Instance.new("UIGradient")
        tabsCreated = tabsCreated + 1

        tabBtn.AutoButtonColor = false
        tabBtn.Name = "tabBtn_"..name
        tabBtn.Parent = tabList
        tabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.Position = UDim2.new(0.102, 0, 0.013, 0)
        tabBtn.Size = UDim2.new(0, 118, 0, 26)
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.Text = tostring(name)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.TextSize = 11
        tabBtn.TextWrapped = true

        self:UICorner(tabBtn, 4)

        designA.Name = "designA"
        designA.Parent = tabBtn
        designA.BackgroundTransparency = 1
        designA.Size = UDim2.new(1, 0, 1, 0)
        designA.Font = Enum.Font.Gotham
        designA.Text = tostring(name)
        designA.TextWrapped = true
        designA.TextColor3 = Color3.fromRGB(255, 255, 255)
        designA.TextSize = 11

        inTab.Name = "inTab_"..name
        inTab.Parent = mainFrame
        inTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        inTab.BorderSizePixel = 0
        inTab.Position = UDim2.new(0.304, 0, 0.083, 0)
        inTab.Size = UDim2.new(0, 372, 0, 350)
        
        local inTabCanvas = self:UIList(inTab, 8)
        self:UIPad(inTab, nil, 8)
        
        local bigChunk = 0
        inTab.ChildAdded:Connect(function(child)
            if not string.find(child.ClassName, "UI") then
                inTab.CanvasSize = UDim2.new(0, 0, 0, inTabCanvas.AbsoluteContentSize.Y + inTabCanvas.Padding.Offset + bigChunk)
            end
        end)

        if tabsCreated >= 2 then
            inTab.Visible = false
        end

        UIGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(70, 26, 165)),
            ColorSequenceKeypoint.new(0.001, Color3.fromRGB(31, 29, 33)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30, 30, 30))
        })
        UIGradient.Rotation = 15
        UIGradient.Parent = tabBtn

        table.insert(visibles, inTab)

        local function tabClick()
            for _, vis in pairs(visibles) do
                for _, v in pairs(vis:GetDescendants()) do
                    if not string.find(v.ClassName, "UI") and not string.find(v.Name, "Exceptionally") then
                        v.Visible = false
                    end
                end
                vis.Visible = false
            end
            
            for _, v in pairs(inTab:GetDescendants()) do
                if not string.find(v.ClassName, "UI") then
                    v.Visible = true
                end
            end
            inTab.Visible = true
            
            if clicked then
                clicked()
            end
        end

        tabBtn.MouseButton1Click:Connect(tabClick)

        local Tab = {}

        function Tab:CreateButton(name, clicked)
            local name = name or "Button"
            local clicked = clicked or function() end
            local UIGradient = Instance.new("UIGradient")
            local designA = Instance.new("TextLabel")
            local inBtn = Instance.new("TextButton")

            inBtn.AutoButtonColor = false
            inBtn.Name = "Button_"..name
            inBtn.Parent = inTab
            inBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            inBtn.BorderSizePixel = 0
            inBtn.Position = UDim2.new(0.102, 0, 0.013, 0)
            inBtn.Size = UDim2.new(0, 325, 0, 35)
            inBtn.Font = Enum.Font.Gotham
            inBtn.Text = tostring(name)
            inBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            inBtn.TextSize = 11
            inBtn.TextWrapped = true

            ScatheLib:UICorner(inBtn, 6)

            designA.Name = "designA"
            designA.Parent = inBtn
            designA.BackgroundTransparency = 1
            designA.Size = UDim2.new(1, 0, 1, 0)
            designA.Font = Enum.Font.Gotham
            designA.Text = tostring(name)
            designA.TextWrapped = true
            designA.TextColor3 = Color3.fromRGB(255, 255, 255)
            designA.TextSize = 11

            UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(70, 26, 165)),
                ColorSequenceKeypoint.new(0.001, Color3.fromRGB(31, 29, 33)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30, 30, 30))
            })
            UIGradient.Rotation = 15
            UIGradient.Offset = Vector2.new(-0.225, 0)
            UIGradient.Parent = inBtn

            local TweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            local toHover = {BackgroundColor3 = Color3.fromRGB(200, 200, 200), Size = UDim2.new(0, 335, 0, 40)}
            local toLeave = {BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.new(0, 325, 0, 35)}
            local onHover = TweenService:Create(inBtn, TweenInfo, toHover)
            local onLeave = TweenService:Create(inBtn, TweenInfo, toLeave)

            local function hover() onHover:Play() end
            local function leave() onLeave:Play() end
            local function click()
                leave()
                pcall(clicked)
            end

            local function button_click()
                local normal_size = UDim2.new(0, 325, 0, 35)
                local bigger_size = UDim2.new(0, 335, 0, 38)
                local normal_position = inBtn.Position
                local corrected_position = inBtn.Position - UDim2.new(0.017, 0, 0.008, 0)

                inBtn:TweenSizeAndPosition(bigger_size, corrected_position, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.25, true)
                task.wait(0.2)
                inBtn:TweenSizeAndPosition(normal_size, normal_position, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.25, true)
            end

            inBtn.MouseButton1Click:Connect(button_click)
            inBtn.MouseEnter:Connect(hover)
            inBtn.MouseLeave:Connect(leave)
            inBtn.InputBegan:Connect(hover)
            inBtn.InputEnded:Connect(leave)
            inBtn.MouseButton1Click:Connect(click)

            return inBtn
        end

        function Tab:CreateToggle(name, state, clicked)
            local name = name or "Toggle"
            local clicked = clicked or function() end
            local inBtn = Instance.new("TextButton")
            local box = Instance.new("TextButton")
            local highlight = Instance.new("TextButton")
            local UIGradient = Instance.new("UIGradient")
            local designA = Instance.new("TextLabel")
            local state = state or false

            inBtn.AutoButtonColor = false
            inBtn.Name = "Toggle_"..name
            inBtn.Parent = inTab
            inBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            inBtn.BorderSizePixel = 0
            inBtn.Position = UDim2.new(0.102, 0, 0.013, 0)
            inBtn.Size = UDim2.new(0, 325, 0, 35)
            inBtn.Font = Enum.Font.Gotham
            inBtn.Text = tostring(name)
            inBtn.TextWrapped = true
            inBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            inBtn.TextSize = 11

            ScatheLib:UICorner(inBtn, 6)

            designA.Name = "designA"
            designA.Parent = inBtn
            designA.BackgroundTransparency = 1
            designA.Size = UDim2.new(1, 0, 1, 0)
            designA.Font = Enum.Font.Gotham
            designA.Text = tostring(name)
            designA.TextWrapped = true
            designA.TextColor3 = Color3.fromRGB(255, 255, 255)
            designA.TextSize = 11

            box.Name = "box"
            box.Parent = inBtn
            box.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
            box.BorderSizePixel = 0
            box.Position = UDim2.new(0.915, 0, 0.08, 0)
            box.Size = UDim2.new(0.07, 0, 0.65, 0)
            box.Text = ""

            ScatheLib:UICorner(box, 20)

            highlight.Name = "highlight"
            highlight.Parent = inBtn
            highlight.BackgroundColor3 = state and Color3.fromRGB(25, 125, 25) or Color3.fromRGB(75, 18, 18)
            highlight.BorderSizePixel = 0
            highlight.Position = UDim2.new(0.928, 0, 0.19, 0)
            highlight.Size = UDim2.new(0.045, 0, 0.4, 0)
            highlight.Text = ""

            ScatheLib:UICorner(highlight, 25)

            UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(70, 26, 165)),
                ColorSequenceKeypoint.new(0.001, Color3.fromRGB(31, 29, 33)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30, 30, 30))
            })
            UIGradient.Rotation = 15
            UIGradient.Offset = Vector2.new(-0.225, 0)
            UIGradient.Parent = inBtn

            local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            local toOpen = {BackgroundColor3 = Color3.fromRGB(25, 255, 25)}
            local toClose = {BackgroundColor3 = Color3.fromRGB(75, 18, 18)}
            local onOpen = TweenService:Create(highlight, TweenInfo, toOpen)
            local onClose = TweenService:Create(highlight, TweenInfo, toClose)

            local function highlighter()
                if state then onOpen:Play() else onClose:Play() end
            end

            local function click()
                state = not state
                highlighter()
                pcall(function() clicked(state, inBtn) end)
            end

            inBtn.MouseButton1Click:Connect(click)
            
            return inBtn, function(newState)
                state = newState
                highlighter()
            end
        end

        function Tab:CreateSlider(name, min, max, sliding, whilst)
            local inBtn = Instance.new("TextButton")
            local sliderLabel = Instance.new("TextLabel")
            local sliderFrame = Instance.new("TextButton")
            local sliderPoint = Instance.new("TextButton")
            local sliderValue = Instance.new("TextLabel")
            local UIGradient = Instance.new("UIGradient")
            local name = name or "Slider"
            local min = min or 0
            local max = max or 100
            local Whilst = whilst or false

            inBtn.Name = "Slider_"..name
            inBtn.Parent = inTab
            inBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            inBtn.BorderSizePixel = 0
            inBtn.Position = UDim2.new(0.102, 0, 0.013, 0)
            inBtn.Size = UDim2.new(0, 325, 0, 35)
            inBtn.Font = Enum.Font.Gotham
            inBtn.Text = tostring(name)
            inBtn.TextWrapped = true
            inBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            inBtn.TextSize = 11

            ScatheLib:UICorner(inBtn, 6)

            UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(70, 26, 165)),
                ColorSequenceKeypoint.new(0.001, Color3.fromRGB(31, 29, 33)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30, 30, 30))
            })
            UIGradient.Rotation = 15
            UIGradient.Offset = Vector2.new(-0.225, 0)
            UIGradient.Parent = inBtn

            sliderLabel.Name = "sliderLabel"
            sliderLabel.Parent = sliderFrame
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Position = UDim2.new(0.030, 0, -3.5, 0)
            sliderLabel.Size = UDim2.new(0, 240, 0, 33)
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.Text = tostring(name)
            sliderLabel.TextColor3 = Color3.fromRGB(213, 213, 213)
            sliderLabel.TextSize = 11
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left

            sliderFrame.Name = "sliderFrame"
            sliderFrame.Parent = inBtn
            sliderFrame.Text = ""
            sliderFrame.BackgroundColor3 = Color3.fromRGB(136, 116, 177)
            sliderFrame.Position = UDim2.new(0.06, 0, 0.625, 0)
            sliderFrame.Size = UDim2.new(0, 298, 0, 8)

            ScatheLib:UICorner(sliderFrame, 4)

            sliderPoint.Name = "sliderPoint"
            sliderPoint.Parent = sliderFrame
            sliderPoint.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderPoint.BorderSizePixel = 0
            sliderPoint.Position = UDim2.new(0.126, 0, -0.5, 0)
            sliderPoint.Size = UDim2.new(0, 10, 0, 16)
            sliderPoint.Text = ""

            ScatheLib:UICorner(sliderPoint, 3)

            sliderValue.Name = "sliderValue"
            sliderValue.Parent = sliderFrame
            sliderValue.BackgroundTransparency = 1
            sliderValue.Position = UDim2.new(0.825, 0, -3.5, 0)
            sliderValue.Size = UDim2.new(0, 45, 0, 33)
            sliderValue.Font = Enum.Font.SourceSans
            sliderValue.Text = min.." / "..max
            sliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
            sliderValue.TextSize = 13

            local down = false
            local value = min
            local mouse = Players.LocalPlayer:GetMouse()

            sliderFrame.MouseButton1Down:Connect(function()
                down = true
                if Whilst then
                    RunService.RenderStepped:Connect(function()
                        if down then
                            pcall(sliding, math.floor(value))
                        end
                    end)
                end

                while down and task.wait() do
                    local percentage = math.clamp((mouse.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                    sliderPoint:TweenPosition(UDim2.new(percentage, 0, -0.5, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.05)
                    value = (percentage * (max - min)) + min
                    sliderValue.Text = string.format("%d / %d", math.floor(value), max)
                end
            end)

            mouse.Button1Up:Connect(function()
                if down then
                    down = false
                    if not Whilst then
                        pcall(sliding, math.floor(value))
                    end
                end
            end)

            return sliderFrame, function(newValue)
                local percentage = (newValue - min) / (max - min)
                sliderPoint.Position = UDim2.new(percentage, 0, -0.5, 0)
                value = newValue
                sliderValue.Text = string.format("%d / %d", math.floor(value), max)
            end
        end

        function Tab:CreateTextbox(label, callback)
            local main = Instance.new("Frame")
            local textBox = Instance.new("TextBox")
            local bottomframe = Instance.new("Frame")
            local executeBtn = Instance.new("TextButton")
            local clearBtn = Instance.new("TextButton")
            local UIGradient = Instance.new("UIGradient")
            label = label or "Input"

            main.Name = "Textbox_"..label
            main.Parent = inTab
            main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            main.Size = UDim2.new(0, 325, 0, 71)

            ScatheLib:UICorner(main)

            textBox.Name = "textBox"
            textBox.Parent = main
            textBox.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            textBox.BorderSizePixel = 1
            textBox.BorderColor3 = Color3.fromRGB(70, 26, 165)
            textBox.Text = ""
            textBox.PlaceholderText = label
            textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            textBox.Size = UDim2.new(1, 0, 0, 40)

            bottomframe.Name = "bottomframe"
            bottomframe.Parent = textBox
            bottomframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            bottomframe.Position = UDim2.new(0, 0, 1, 0)
            bottomframe.Size = UDim2.new(1, 0, 0, 31)

            executeBtn.Name = "executeBtn"
            executeBtn.Parent = bottomframe
            executeBtn.BackgroundColor3 = Color3.fromRGB(112, 0, 168)
            executeBtn.Position = UDim2.new(0.8, 0, 0.161, 0)
            executeBtn.Size = UDim2.new(0, 58, 0, 21)
            executeBtn.Font = Enum.Font.GothamBlack
            executeBtn.Text = "Execute"
            executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            executeBtn.TextSize = 11

            ScatheLib:UICorner(executeBtn, 3)

            clearBtn.Name = "clearBtn"
            clearBtn.Parent = bottomframe
            clearBtn.BackgroundColor3 = Color3.fromRGB(112, 0, 168)
            clearBtn.Position = UDim2.new(0.6, 0, 0.161, 0)
            clearBtn.Size = UDim2.new(0, 58, 0, 21)
            clearBtn.Font = Enum.Font.GothamBlack
            clearBtn.Text = "Clear"
            clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            clearBtn.TextSize = 11

            ScatheLib:UICorner(clearBtn, 3)

            UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(70, 26, 165)),
                ColorSequenceKeypoint.new(0.001, Color3.fromRGB(30, 30, 30)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30, 30, 30))
            })
            UIGradient.Offset = Vector2.new(-0.225, 0)
            UIGradient.Rotation = 15
            UIGradient.Parent = bottomframe

            clearBtn.MouseButton1Click:Connect(function()
                textBox.Text = ""
            end)

            executeBtn.MouseButton1Click:Connect(function()
                pcall(callback, textBox.Text)
            end)

            return textBox
        end

        function Tab:CreateDropdown(name, options, callback)
            local main = Instance.new("Frame")
            local label = Instance.new("TextLabel")
            local chosenLabel = Instance.new("TextLabel")
            local corner = Instance.new("UICorner")
            local gradient = Instance.new("UIGradient")
            local toggleBtn = Instance.new("TextButton")
            local dropdown = Instance.new("Frame")
            options = options or {"Option 1", "Option 2"}

            main.Name = "Dropdown_"..name
            main.Parent = inTab
            main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            main.Position = UDim2.new(0.397, 0, 0.234, 0)
            main.Size = UDim2.new(0, 325, 0, 35)

            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = main

            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(70, 26, 165)),
                ColorSequenceKeypoint.new(0.001, Color3.fromRGB(30, 30, 30)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30, 30, 30))
            })
            gradient.Offset = Vector2.new(-0.225, 0)
            gradient.Rotation = 15
            gradient.Parent = main

            label.Name = "label"
            label.Parent = main
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0.075, 0, 0.013, 0)
            label.Size = UDim2.new(0.825, 0, 1, 0)
            label.Font = Enum.Font.Gotham
            label.Text = tostring(name)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 11
            label.TextWrapped = true

            chosenLabel.Name = "chosenLabel"
            chosenLabel.Parent = main
            chosenLabel.BackgroundTransparency = 1
            chosenLabel.Position = UDim2.new(0.075, 0, 0.1, 0)
            chosenLabel.Size = UDim2.new(0.825, 0, 0.2, 0)
            chosenLabel.Font = Enum.Font.Gotham
            chosenLabel.Text = "Select..."
            chosenLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            chosenLabel.TextSize = 10
            chosenLabel.TextXAlignment = Enum.TextXAlignment.Left

            toggleBtn.Name = "toggleBtn"
            toggleBtn.Parent = main
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Size = UDim2.new(1, 0, 1, 0)
            toggleBtn.Text = ""
            toggleBtn.ZIndex = 2

            dropdown.Name = "dropdown"
            dropdown.Parent = main
            dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            dropdown.Position = UDim2.new(0, 0, 1.05, 0)
            dropdown.Size = UDim2.new(1, 0, 0, 0)
            dropdown.Visible = false
            dropdown.ZIndex = 5

            ScatheLib:UICorner(dropdown)
            ScatheLib:UIList(dropdown, 2)
            ScatheLib:UIPad(dropdown, 2, 2, 2, 2)

            local isOpen = false
            local selectedOption = nil

            local function toggleDropdown()
                isOpen = not isOpen
                if isOpen then
                    dropdown.Visible = true
                    local targetSize = math.min(#options * 30 + 4, 150)
                    dropdown:TweenSize(UDim2.new(1, 0, 0, targetSize), "Out", "Quad", 0.2, true)
                else
                    local tween = TweenService:Create(dropdown, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, 0)
                    })
                    tween.Completed:Connect(function()
                        dropdown.Visible = false
                    end)
                    tween:Play()
                end
            end

            local function createOption(optionName)
                local optionBtn = Instance.new("TextButton")
                optionBtn.Name = optionName
                optionBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                optionBtn.Size = UDim2.new(1, -4, 0, 28)
                optionBtn.Text = optionName
                optionBtn.Font = Enum.Font.Gotham
                optionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                optionBtn.TextSize = 11
                optionBtn.ZIndex = 6

                ScatheLib:UICorner(optionBtn, 4)

                optionBtn.MouseButton1Click:Connect(function()
                    selectedOption = optionName
                    chosenLabel.Text = optionName
                    toggleDropdown()
                    if callback then
                        pcall(callback, optionName)
                    end
                end)

                return optionBtn
            end

            -- Создаем опции
            for _, option in ipairs(options) do
                createOption(option).Parent = dropdown
            end

            toggleBtn.MouseButton1Click:Connect(toggleDropdown)

            -- Методы для управления дропдауном
            local dropdownMethods = {}

            function dropdownMethods:SetOptions(newOptions)
                -- Очищаем старые опции
                for _, child in ipairs(dropdown:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                -- Добавляем новые
                for _, option in ipairs(newOptions) do
                    createOption(option).Parent = dropdown
                end
            end

            function dropdownMethods:Select(optionName)
                if table.find(options, optionName) then
                    selectedOption = optionName
                    chosenLabel.Text = optionName
                    if callback then
                        pcall(callback, optionName)
                    end
                end
            end

            function dropdownMethods:GetSelected()
                return selectedOption
            end

            return dropdownMethods
        end

        function Tab:CreateLabel(text)
            local label = Instance.new("TextLabel")
            label.Name = "Label_"..text
            label.Parent = inTab
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Font = Enum.Font.Gotham
            label.Text = text
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            return label
        end

        function Tab:CreateDivider()
            local divider = Instance.new("Frame")
            divider.Name = "Divider"
            divider.Parent = inTab
            divider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            divider.Size = UDim2.new(1, 0, 0, 1)
            divider.BorderSizePixel = 0
            
            return divider
        end

        return Tab
    end

    -- Добавляем возможность перетаскивания окна
    local dragging
    local dragInput
    local dragStart
    local startPos

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Добавляем горячие клавиши
    local function handleHotkey(input, gameProcessed)
        if gameProcessed then return end
        
        for key, func in pairs(settings.hotkeys) do
            if input.KeyCode == Enum.KeyCode[key] then
                pcall(func)
            end
        end
    end

    UserInputService.InputBegan:Connect(handleHotkey)

    -- Методы для управления окном
    function Window:SetHotkey(key, func)
        settings.hotkeys[tostring(key)] = func
        saveSettings()
    end

    function Window:ToggleVisibility()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end

    function Window:Destroy()
        ScreenGui:Destroy()
    end

    return Window
end

return ScatheLib
