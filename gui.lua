-- [[ H4XSCRIPTS - GROOVY GARDEN 2 PREMIUM ]]
-- Полная премиум-версия с кастомными уведомлениями и интро-анимацией
-- Активация/Скрытие: Правый Shift

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Защита от дубликатов (очистка старого интерфейса при перезапуске)
if CoreGui:FindFirstChild("H4xScripts_Premium") then
    CoreGui.H4xScripts_Premium:Destroy()
end

-- Создание корневого интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "H4xScripts_Premium"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Единая дизайн-палитра (Modern Dark)
local Theme = {
    Background    = Color3.fromRGB(20, 21, 20),      
    SidebarBg     = Color3.fromRGB(26, 27, 26),      
    CardBg        = Color3.fromRGB(32, 33, 32),      
    ToggleOff     = Color3.fromRGB(55, 56, 55),
    ToggleOn      = Color3.fromRGB(255, 255, 255),   
    TextMain      = Color3.fromRGB(245, 245, 245),
    TextMuted     = Color3.fromRGB(150, 155, 150),
    Border        = Color3.fromRGB(45, 46, 45),
    Accent        = Color3.fromRGB(255, 255, 255),
    Smooth        = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
    Fast          = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

-- [[ КОНТЕЙНЕР ДЛЯ СТИЛЬНЫХ УВЕДОМЛЕНИЙ ]]
local NotifyContainer = Instance.new("Frame")
NotifyContainer.Name = "Notifications"
NotifyContainer.Size = UDim2.new(0, 280, 1, -40)
NotifyContainer.Position = UDim2.new(1, -300, 0, 20)
NotifyContainer.BackgroundTransparency = 1
NotifyContainer.Parent = ScreenGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.Padding = UDim.new(0, 10)
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Parent = NotifyContainer

local function CustomNotify(title, text, duration)
    duration = duration or 4
    
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 65)
    Card.BackgroundColor3 = Theme.SidebarBg
    Card.BackgroundTransparency = 1 -- Старт с прозрачности для анимации
    Card.ClipsDescendants = true
    Card.Parent = NotifyContainer
    
    local Corner = Instance.new("UICorner", Card)
    Corner.CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", Card)
    Stroke.Color = Theme.Border
    Stroke.Thickness = 1
    Stroke.Transparency = 1
    
    local TIcon = Instance.new("TextLabel")
    TIcon.Size = UDim2.new(0, 30, 0, 30)
    TIcon.Position = UDim2.new(0, 12, 0.5, -15)
    TIcon.BackgroundTransparency = 1
    TIcon.Font = Enum.Font.GothamBold
    TIcon.Text = "⚡"
    TIcon.TextColor3 = Theme.TextMain
    TIcon.TextSize = 16
    TIcon.Parent = Card
    
    local TTitle = Instance.new("TextLabel")
    TTitle.Size = UDim2.new(1, -55, 0, 18)
    TTitle.Position = UDim2.new(0, 45, 0, 12)
    TTitle.BackgroundTransparency = 1
    TTitle.Font = Enum.Font.GothamBold
    TTitle.Text = title
    TTitle.TextColor3 = Theme.TextMain
    TTitle.TextSize = 13
    TTitle.TextXAlignment = Enum.TextXAlignment.Left
    TTitle.Parent = Card
    
    local TText = Instance.new("TextLabel")
    TText.Size = UDim2.new(1, -55, 0, 16)
    TText.Position = UDim2.new(0, 45, 0, 30)
    TText.BackgroundTransparency = 1
    TText.Font = Enum.Font.Gotham
    TText.Text = text
    TText.TextColor3 = Theme.TextMuted
    TText.TextSize = 12
    TText.TextXAlignment = Enum.TextXAlignment.Left
    TText.Parent = Card

    -- Анимация появления (Сдвиг + Проявление)
    Card.Position = UDim2.new(1, 50, 0, 0)
    TweenService:Create(Card, Theme.Smooth, {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(Stroke, Theme.Smooth, {Transparency = 0}):Play()
    
    task.wait(duration)
    
    -- Анимация ухода
    local OutTween = TweenService:Create(Card, Theme.Smooth, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)})
    TweenService:Create(Stroke, Theme.Smooth, {Transparency = 1}):Play()
    TweenService:Create(TIcon, Theme.Fast, {TextTransparency = 1}):Play()
    TweenService:Create(TTitle, Theme.Fast, {TextTransparency = 1}):Play()
    TweenService:Create(TText, Theme.Fast, {TextTransparency = 1}):Play()
    OutTween:Play()
    OutTween.Completed:Connect(function() Card:Destroy() end)
end

-- [[ АНИМАЦИЯ ЗАГРУЗКИ (LOADING SCREEN) ]]
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(0, 320, 0, 180)
LoadingFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
LoadingFrame.BackgroundColor3 = Theme.Background
LoadingFrame.Parent = ScreenGui

Instance.new("UICorner", LoadingFrame).CornerRadius = UDim.new(0, 12)
local LStroke = Instance.new("UIStroke", LoadingFrame)
LStroke.Color = Theme.Border

local LTitle = Instance.new("TextLabel")
LTitle.Size = UDim2.new(1, 0, 0, 30)
LTitle.Position = UDim2.new(0, 0, 0, 40)
LTitle.Font = Enum.Font.GothamBold
LTitle.Text = "H4xScripts"
LTitle.TextColor3 = Theme.TextMain
LTitle.TextSize = 22
LTitle.Parent = LoadingFrame

local LStatus = Instance.new("TextLabel")
LStatus.Size = UDim2.new(1, 0, 0, 20)
LStatus.Position = UDim2.new(0, 0, 0, 75)
LStatus.Font = Enum.Font.Gotham
LStatus.Text = "Подключение к саб-системам..."
LStatus.TextColor3 = Theme.TextMuted
LStatus.TextSize = 12
LStatus.Parent = LoadingFrame

-- Полоса загрузки
local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 220, 0, 4)
BarBg.Position = UDim2.new(0.5, -110, 0, 115)
BarBg.BackgroundColor3 = Theme.CardBg
BarBg.Parent = LoadingFrame
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Theme.Accent
BarFill.Parent = BarBg
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

-- Имитация красивой загрузки ядра
task.spawn(function()
    task.wait(0.5)
    LStatus.Text = "Проверка окружения инжектора..."
    TweenService:Create(BarFill, TweenInfo.new(0.6), {Size = UDim2.new(0.4, 0, 1, 0)}):Play()
    task.wait(0.7)
    LStatus.Text = "Отрисовка Fluent UI дизайна..."
    TweenService:Create(BarFill, TweenInfo.new(0.5), {Size = UDim2.new(0.8, 0, 1, 0)}):Play()
    task.wait(0.6)
    LStatus.Text = "Успешно импортировано!"
    TweenService:Create(BarFill, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(0.4)
    
    -- Исчезновение лоадера
    TweenService:Create(LoadingFrame, Theme.Smooth, {BackgroundTransparency = 1}):Play()
    TweenService:Create(LStroke, Theme.Smooth, {Transparency = 1}):Play()
    TweenService:Create(LTitle, Theme.Fast, {TextTransparency = 1}):Play()
    TweenService:Create(LStatus, Theme.Fast, {TextTransparency = 1}):Play()
    TweenService:Create(BarBg, Theme.Fast, {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, Theme.Fast, {BackgroundTransparency = 1}):Play()
    
    task.wait(0.3)
    LoadingFrame:Destroy()
    
    -- Появление главного меню и кастомного уведомления
    ScreenGui.MainWindow.Visible = true
    task.spawn(function() CustomNotify("H4xScripts Premium", "Интерфейс инициализирован! Скрытие меню: Right Shift", 4) end)
end)


-- [[ ОСНОВНОЕ ОКНО ИНТЕРФЕЙСА ]]
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainWindow"
MainFrame.Size = UDim2.new(0, 640, 0, 460)
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -230)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = 0.15
MainFrame.Visible = false -- Скрыто, пока идет анимация лоадера
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Theme.Border

-- Верхняя панель (Шапка)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Position = UDim2.new(0, 20, 0, 10)
Title.Size = UDim2.new(0, 200, 0, 18)
Title.Font = Enum.Font.GothamBold
Title.Text = "H4xScripts"
Title.TextColor3 = Theme.TextMain
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Position = UDim2.new(0, 20, 0, 26)
Subtitle.Size = UDim2.new(0, 400, 0, 14)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Catch & Feed a Brainrot! | discord.gg/H4xScripts"
Subtitle.TextColor3 = Theme.TextMuted
Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

-- Логика Drag&Drop для окна
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Сайдбар
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 175, 1, -65)
Sidebar.Position = UDim2.new(0, 15, 0, 55)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.Parent = Sidebar

-- Контейнер страниц
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -215, 1, -65)
PageContainer.Position = UDim2.new(0, 200, 0, 55)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

local Engine = { ActiveTab = nil }

function Engine:CreateTab(name, icon, isDefault)
    local Tab = {}
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 36)
    TabButton.BackgroundColor3 = Theme.CardBg
    TabButton.BackgroundTransparency = isDefault and 0.4 or 1
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.Text = "   " .. icon .. "  " .. name
    TabButton.TextColor3 = isDefault and Theme.TextMain or Theme.TextMuted
    TabButton.TextSize = 13
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Parent = Sidebar
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = isDefault or false
    Page.ScrollBarThickness = 0
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Parent = PageContainer
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.Parent = Page
    PageLayout.Changed:Connect(function() Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10) end)
    
    TabButton.MouseButton1Click:Connect(function()
        if Engine.ActiveTab == Tab then return end
        if Engine.ActiveTab then
            Engine.ActiveTab.Page.Visible = false
            TweenService:Create(Engine.ActiveTab.Button, Theme.Smooth, {BackgroundTransparency = 1, TextColor3 = Theme.TextMuted}):Play()
        end
        Engine.ActiveTab = Tab
        Page.Visible = true
        TweenService:Create(TabButton, Theme.Smooth, {BackgroundTransparency = 0.4, TextColor3 = Theme.TextMain}):Play()
    end)
    
    Tab.Page = Page
    Tab.Button = TabButton
    if isDefault then Engine.ActiveTab = Tab end

    function Tab:AddGroupLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 22)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamBold
        Label.Text = text
        Label.TextColor3 = Theme.TextMain
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Page
    end

    function Tab:AddToggle(text, callback)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, -5, 0, 44)
        Row.BackgroundColor3 = Theme.CardBg
        Row.BackgroundTransparency = 0.4
        Row.Parent = Page
        Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", Row) s.Color = Theme.Border s.Thickness = 0.6
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamMedium
        Label.Text = text
        Label.TextColor3 = Theme.TextMain
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Row
        
        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(0, 38, 0, 20)
        ToggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
        ToggleBtn.BackgroundColor3 = Theme.ToggleOff
        ToggleBtn.Text = ""
        ToggleBtn.Parent = Row
        Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
        
        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 14, 0, 14)
        Circle.Position = UDim2.new(0, 3, 0.5, -7)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.Parent = ToggleBtn
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
        
        local active = false
        ToggleBtn.MouseButton1Click:Connect(function()
            active = not active
            local targetPos = active and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            local targetColor = active and Theme.ToggleOn or Theme.ToggleOff
            local circleColor = active and Theme.Background or Color3.fromRGB(255, 255, 255)
            
            TweenService:Create(Circle, Theme.Smooth, {Position = targetPos, BackgroundColor3 = circleColor}):Play()
            TweenService:Create(ToggleBtn, Theme.Smooth, {BackgroundColor3 = targetColor}):Play()
            
            task.spawn(function() CustomNotify(text, active and "Функция активирована" or "Функция отключена", 2) end)
            pcall(callback, active)
        end)
    end

    function Tab:AddTextBox(text, placeholder, callback)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, -5, 0, 44)
        Row.BackgroundColor3 = Theme.CardBg
        Row.BackgroundTransparency = 0.4
        Row.Parent = Page
        Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 8)
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -120, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamMedium
        Label.Text = text
        Label.TextColor3 = Theme.TextMain
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Row
        
        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(0, 80, 0, 24)
        Input.Position = UDim2.new(1, -92, 0.5, -12)
        Input.BackgroundColor3 = Theme.Background
        Input.Font = Enum.Font.Gotham
        Input.Text = placeholder
        Input.TextColor3 = Theme.TextMain
        Input.TextSize = 12
        Input.Parent = Row
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 4)
        
        Input.FocusLost:Connect(function()
            pcall(callback, Input.Text)
        end)
    end

    return Tab
end

-- Вкладки
local MainTab   = Engine:CreateTab("Main", "⟨ ⟩", true)
local UpgradeTab= Engine:CreateTab("Upgrade Tab", "⛏", false)
local MiscTab   = Engine:CreateTab("Misc", "📍", false)
local DupeTab   = Engine:CreateTab("Dupe", "🗂", false)
local PlayerTab = Engine:CreateTab("Local Player", "⚙", false)

-- Компоненты Main
MainTab:AddGroupLabel("Main")
MainTab:AddToggle("Auto Pump", function(state) end)
MainTab:AddToggle("Auto Collect Cash", function(state) end)

MainTab:AddGroupLabel("Auto Collect")
MainTab:AddTextBox("Collect Fruit Every", "10", function(val) end)
MainTab:AddToggle("Auto Collect Fruit", function(state) end)

-- Переключатель Right Shift
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
