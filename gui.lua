-- [[ PREMIUM DARK UI FRAMEWORK ]]
-- Inspired by Modern Fluent Design / H4x Layout
-- Keybind: Right Shift

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Создание корневого интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FluentUI_Engine"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Цветовая палитра из референса
local Theme = {
    Background = Color3.fromRGB(25, 26, 25),      -- Глубокий темный
    SidebarBg  = Color3.fromRGB(32, 33, 32),      -- Выделенная панель
    CardBg     = Color3.fromRGB(36, 37, 36),      -- Тон карточек
    ToggleOff  = Color3.fromRGB(60, 61, 60),
    ToggleOn   = Color3.fromRGB(240, 240, 240),   -- Белые стильные переключатели
    TextMain   = Color3.fromRGB(245, 245, 245),
    TextMuted  = Color3.fromRGB(160, 165, 160),
    Border     = Color3.fromRGB(50, 51, 50),
    FastTween  = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

-- Создание основного окна
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainWindow"
MainFrame.Size = UDim2.new(0, 620, 0, 440)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -220)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = 0.15 -- Легкая прозрачность
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Border
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Реализация перетаскивания (Drag)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Левое меню (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 180, 1, -40)
Sidebar.Position = UDim2.new(0, 15, 0, 20)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.Parent = Sidebar

-- Контейнер для правого контента (Страницы)
local PageContainer = Instance.new("Frame")
PageContainer.Name = "Pages"
PageContainer.Size = UDim2.new(1, -220, 1, -40)
PageContainer.Position = UDim2.new(0, 205, 0, 20)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

-- Функция создания разделов и элементов
local Engine = { Tabs = {}, ActiveTab = nil }

function Engine:CreateTab(name, isDefault)
    local Tab = {}
    
    -- Кнопка в меню
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 38)
    TabButton.BackgroundColor3 = Theme.CardBg
    TabButton.BackgroundTransparency = isDefault and 0.4 or 1
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.Text = "   " .. name
    TabButton.TextColor3 = isDefault and Theme.TextMain or Theme.TextMuted
    TabButton.TextSize = 14
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Parent = Sidebar
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = TabButton
    
    -- Страница контента
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = isDefault or false
    Page.ScrollBarThickness = 0
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Parent = PageContainer
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 12)
    PageLayout.Parent = Page
    PageLayout.Changed:Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
    end)
    
    Tab.Page = Page
    Tab.Button = TabButton
    
    if isDefault then Engine.ActiveTab = Tab end
    
    -- Переключение вкладок
    TabButton.MouseButton1Click:Connect(function()
        if Engine.ActiveTab == Tab then return end
        if Engine.ActiveTab then
            Engine.ActiveTab.Page.Visible = false
            TweenService:Create(Engine.ActiveTab.Button, Theme.FastTween, {BackgroundTransparency = 1, TextColor3 = Theme.TextMuted}):Play()
        end
        Engine.ActiveTab = Tab
        Page.Visible = true
        TweenService:Create(TabButton, Theme.FastTween, {BackgroundTransparency = 0.4, TextColor3 = Theme.TextMain}):Play()
    end)

    -- Вспомогательная функция для заголовков групп
    function Tab:AddGroupLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamBold
        Label.Text = text
        Label.TextColor3 = Theme.TextMain
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Page
    end

    -- Элемент: Переключатель (Toggle)
    function Tab:AddToggle(text, callback)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, -5, 0, 44)
        Row.BackgroundColor3 = Theme.CardBg
        Row.BackgroundTransparency = 0.3
        Row.Parent = Page
        Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 10)
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.Position = UDim2.new(0, 14, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamMedium
        Label.Text = text
        Label.TextColor3 = Theme.TextMain
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Row
        
        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(0, 40, 0, 22)
        ToggleBtn.Position = UDim2.new(1, -54, 0.5, -11)
        ToggleBtn.BackgroundColor3 = Theme.ToggleOff
        ToggleBtn.Text = ""
        ToggleBtn.Parent = Row
        Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
        
        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 16, 0, 16)
        Circle.Position = UDim2.new(0, 3, 0.5, -8)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.Parent = ToggleBtn
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
        
        local enabled = false
        ToggleBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            local targetPos = enabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            local targetColor = enabled and Theme.ToggleOn or Theme.ToggleOff
            
            TweenService:Create(Circle, Theme.FastTween, {Position = targetPos}):Play()
            TweenService:Create(ToggleBtn, Theme.FastTween, {BackgroundColor3 = targetColor}):Play()
            
            pcall(callback, enabled)
        end)
    end

    -- Элемент: Поле ввода (TextBox)
    function Tab:AddTextBox(text, placeholder, callback)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, -5, 0, 44)
        Row.BackgroundColor3 = Theme.CardBg
        Row.BackgroundTransparency = 0.3
        Row.Parent = Page
        Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 10)
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -120, 1, 0)
        Label.Position = UDim2.new(0, 14, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamMedium
        Label.Text = text
        Label.TextColor3 = Theme.TextMain
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Row
        
        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(0, 90, 0, 26)
        Input.Position = UDim2.new(1, -104, 0.5, -13)
        Input.BackgroundColor3 = Theme.Background
        Input.Font = Enum.Font.Gotham
        Input.Text = placeholder
        Input.TextColor3 = Theme.TextMain
        Input.TextSize = 13
        Input.ClipsDescendants = true
        Input.Parent = Row
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", Input).Color = Theme.Border
        
        Input.FocusLost:Connect(function()
            pcall(callback, Input.Text)
        end)
    end

    return Tab
end

-- [[ НАПОЛНЕНИЕ ИНТЕРФЕЙСА СОГЛАСНО СКРИНШОТУ ]]

local MainTab = Engine:CreateTab("Main", true)
local UpgradeTab = Engine:CreateTab("Upgrade Tab", false)
local MiscTab = Engine:CreateTab("Misc", false)
local DupeTab = Engine:CreateTab("Dupe", false)
local PlayerTab = Engine:CreateTab("Local Player", false)

-- Вкладка: Main
MainTab:AddGroupLabel("Main")
MainTab:AddToggle("Auto Pump", function(state)
    print("Auto Pump статус:", state)
end)
MainTab:AddToggle("Auto Collect Cash", function(state)
    print("Auto Collect Cash статус:", state)
end)

MainTab:AddGroupLabel("Auto Collect")
MainTab:AddTextBox("Collect Fruit Every", "10", function(text)
    print("Интервал сбора фруктов:", text)
end)
MainTab:AddToggle("Auto Collect Fruit", function(state)
    print("Auto Collect Fruit статус:", state)
end)

-- Горячая клавиша скрытия меню (Правый Shift)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
