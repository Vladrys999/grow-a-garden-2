-- [[ H4XSCRIPTS - GROOVY GARDEN 2 REMASTERED ]]
-- Фикс разметки UI + Рабочий автофарм. Скрытие: Правый Shift

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- Защита от дубликатов
if CoreGui:FindFirstChild("H4xScripts_Premium") then
    CoreGui.H4xScripts_Premium:Destroy()
end

-- Настройки автоматизации
_G.AutoPump = false
_G.AutoCollectCash = false
_G.AutoCollectFruit = false
_G.FruitInterval = 10

-- Корневой GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "H4xScripts_Premium"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Theme = {
    Background    = Color3.fromRGB(22, 23, 22),      
    SidebarBg     = Color3.fromRGB(28, 29, 28),      
    CardBg        = Color3.fromRGB(34, 35, 34),      
    ToggleOff     = Color3.fromRGB(60, 62, 60),
    ToggleOn      = Color3.fromRGB(255, 255, 255),   
    TextMain      = Color3.fromRGB(245, 245, 245),
    TextMuted     = Color3.fromRGB(150, 155, 150),
    Border        = Color3.fromRGB(48, 50, 48),
    Accent        = Color3.fromRGB(255, 255, 255),
    Smooth        = TweenInfo.new(0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
}

-- [[ КАСТОМНЫЕ УВЕДОМЛЕНИЯ ]]
local NotifyContainer = Instance.new("Frame")
NotifyContainer.Size = UDim2.new(0, 280, 1, -40)
NotifyContainer.Position = UDim2.new(1, -300, 0, 20)
NotifyContainer.BackgroundTransparency = 1
NotifyContainer.Parent = ScreenGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.Padding = UDim.new(0, 8)
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Parent = NotifyContainer

local function CustomNotify(title, text)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 55)
    Card.BackgroundColor3 = Theme.SidebarBg
    Card.BackgroundTransparency = 0.1
    Card.Parent = NotifyContainer
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", Card) s.Color = Theme.Border
    
    local TTitle = Instance.new("TextLabel")
    TTitle.Size = UDim2.new(1, -20, 0, 18)
    TTitle.Position = UDim2.new(0, 12, 0, 8)
    TTitle.BackgroundTransparency = 1
    TTitle.Font = Enum.Font.GothamBold
    TTitle.Text = title
    TTitle.TextColor3 = Theme.TextMain
    TTitle.TextSize = 13
    TTitle.TextXAlignment = Enum.TextXAlignment.Left
    TTitle.Parent = Card
    
    local TText = Instance.new("TextLabel")
    TText.Size = UDim2.new(1, -20, 0, 16)
    TText.Position = UDim2.new(0, 12, 0, 24)
    TText.BackgroundTransparency = 1
    TText.Font = Enum.Font.Gotham
    TText.Text = text
    TText.TextColor3 = Theme.TextMuted
    TText.TextSize = 11
    TText.TextXAlignment = Enum.TextXAlignment.Left
    TText.Parent = Card

    task.spawn(function()
        task.wait(3.5)
        TweenService:Create(Card, Theme.Smooth, {BackgroundTransparency = 1}):Play()
        TweenService:Create(s, Theme.Smooth, {Transparency = 1}):Play()
        TweenService:Create(TTitle, Theme.Smooth, {TextTransparency = 1}):Play()
        TweenService:Create(TText, Theme.Smooth, {TextTransparency = 1}):Play()
        task.wait(0.3)
        Card:Destroy()
    end)
end

-- [[ АНИМАЦИЯ ЗАГРУЗКИ ]]
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(0, 300, 0, 150)
LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
LoadingFrame.BackgroundColor3 = Theme.Background
LoadingFrame.Parent = ScreenGui
Instance.new("UICorner", LoadingFrame).CornerRadius = UDim.new(0, 10)
local LStroke = Instance.new("UIStroke", LoadingFrame) LStroke.Color = Theme.Border

local LTitle = Instance.new("TextLabel")
LTitle.Size = UDim2.new(1, 0, 0, 30)
LTitle.Position = UDim2.new(0, 0, 0, 35)
LTitle.Font = Enum.Font.GothamBold
LTitle.Text = "H4xScripts"
LTitle.TextColor3 = Theme.TextMain
LTitle.TextSize = 20
LTitle.Parent = LoadingFrame

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 200, 0, 4)
BarBg.Position = UDim2.new(0.5, -100, 0, 85)
BarBg.BackgroundColor3 = Theme.CardBg
BarBg.Parent = LoadingFrame
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Theme.Accent
BarFill.Parent = BarBg
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

-- [[ ГЛАВНОЕ ОКНО ]]
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainWindow"
MainFrame.Size = UDim2.new(0, 630, 0, 450)
MainFrame.Position = UDim2.new(0.5, -315, 0.5, -225)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = 0.12
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame) MainStroke.Color = Theme.Border

-- Шапка (Header)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Position = UDim2.new(0, 20, 0, 12)
Title.Size = UDim2.new(0, 150, 0, 18)
Title.Font = Enum.Font.GothamBold
Title.Text = "H4xScripts"
Title.TextColor3 = Theme.TextMain
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Position = UDim2.new(0, 20, 0, 28)
Subtitle.Size = UDim2.new(0, 300, 0, 14)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Groovy Garden 2 | discord.gg/H4xScripts"
Subtitle.TextColor3 = Theme.TextMuted
Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

-- Сайдбар
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 170, 1, -70)
Sidebar.Position = UDim2.new(0, 15, 0, 60)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.Parent = Sidebar

-- Контейнер страниц
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -210, 1, -70)
PageContainer.Position = UDim2.new(0, 195, 0, 60)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

local Engine = { ActiveTab = nil }

function Engine:CreateTab(name, icon, isDefault)
    local Tab = {}
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 34)
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
    PageLayout.Padding = UDim.new(0, 8)
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
        Label.Size = UDim2.new(1, 0, 0, 24)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamBold
        Label.Text = text
        Label.TextColor3 = Theme.TextMain
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Page
    end

    function Tab:AddToggle(text, globalVar)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, -5, 0, 40)
        Row.BackgroundColor3 = Theme.CardBg
        Row.BackgroundTransparency = 0.4
        Row.Parent = Page
        Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)
        
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
        ToggleBtn.Size = UDim2.new(0, 36, 0, 18)
        ToggleBtn.Position = UDim2.new(1, -48, 0.5, -9)
        ToggleBtn.BackgroundColor3 = Theme.ToggleOff
        ToggleBtn.Text = ""
        ToggleBtn.Parent = Row
        Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
        
        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 12, 0, 12)
        Circle.Position = UDim2.new(0, 3, 0.5, -6)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.Parent = ToggleBtn
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
        
        ToggleBtn.MouseButton1Click:Connect(function()
            _G[globalVar] = not _G[globalVar]
            local targetPos = _G[globalVar] and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
            local targetColor = _G[globalVar] and Theme.ToggleOn or Theme.ToggleOff
            local circleColor = _G[globalVar] and Theme.Background or Color3.fromRGB(255, 255, 255)
            
            TweenService:Create(Circle, Theme.Smooth, {Position = targetPos, BackgroundColor3 = circleColor}):Play()
            TweenService:Create(ToggleBtn, Theme.Smooth, {BackgroundColor3 = targetColor}):Play()
            CustomNotify(text, _G[globalVar] and "Активировано" or "Отключено")
        end)
    end

    function Tab:AddTextBox(text, placeholder, globalVar)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, -5, 0, 40)
        Row.BackgroundColor3 = Theme.CardBg
        Row.BackgroundTransparency = 0.4
        Row.Parent = Page
        Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)
        
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
        Input.Size = UDim2.new(0, 70, 0, 22)
        Input.Position = UDim2.new(1, -82, 0.5, -11)
        Input.BackgroundColor3 = Theme.Background
        Input.Font = Enum.Font.Gotham
        Input.Text = placeholder
        Input.TextColor3 = Theme.TextMain
        Input.TextSize = 12
        Input.Parent = Row
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 4)
        
        Input.FocusLost:Connect(function()
            local num = tonumber(Input.Text)
            if num then _G[globalVar] = num end
        end)
    end

    return Tab
end

-- Сборка интерфейса строго по порядку
local MainTab   = Engine:CreateTab("Main", "{}", true)
local UpgradeTab= Engine:CreateTab("Upgrade Tab", "⛏", false)
local MiscTab   = Engine:CreateTab("Misc", "📍", false)
local DupeTab   = Engine:CreateTab("Dupe", "🗂", false)
local PlayerTab = Engine:CreateTab("Local Player", "⚙", false)

MainTab:AddGroupLabel("Main")
MainTab:AddToggle("Auto Pump", "AutoPump")
MainTab:AddToggle("Auto Collect Cash", "AutoCollectCash")

MainTab:AddGroupLabel("Auto Collect")
MainTab:AddTextBox("Collect Fruit Every", "10", "FruitInterval")
MainTab:AddToggle("Auto Collect Fruit", "AutoCollectFruit")

-- Перетаскивание
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

-- Анимация симулятора загрузки
task.spawn(function()
    TweenService:Create(BarFill, TweenInfo.new(1.2), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(1.3)
    LoadingFrame:Destroy()
    MainFrame.Visible = true
    CustomNotify("H4xScripts", "Скрипт успешно запущен! Меню на Right Shift")
end)

-- Скрытие на правый Shift
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- [[ ИГРОВАЯ ЛОГИКА АВТОФАРМА (РЕАЛЬНЫЕ КЛИКИ) ]]
task.spawn(function()
    while task.wait(0.3) do
        -- 1. Сбор выпавших денег/монет
        if _G.AutoCollectCash then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:find("Cash") or v.Name:find("Coin") or v:FindFirstChild("TouchTransmitter")) then
                    pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            v.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                        end
                    end)
                end
            end
        end
        
        -- 2. Нажатие на насос (Полив)
        if _G.AutoPump then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ClickDetector") and (v.Parent.Name:find("Pump") or v.Parent.Name:find("Water") or v.Parent.Name:find("Well")) then
                    fireclickdetector(v)
                end
            end
        end
    end
end)

-- 3. Сбор фруктов по кулдауну
task.spawn(function()
    while true do
        if _G.AutoCollectFruit then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ClickDetector") and (v.Parent.Name:find("Fruit") or v.Parent.Name:find("Apple") or v.Parent.Name:find("Tree")) then
                    fireclickdetector(v)
                end
            end
            task.wait(_G.FruitInterval)
        else
            task.wait(1)
        end
    end
end)
