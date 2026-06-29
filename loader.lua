-- [[ GARDEN ENGINE v3.0 - OFFICIAL LOADER ]]
-- Репозиторий: Vladrys999/grow-a-garden-2

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

print([[ 
  _      ____          _____  ______ _____  
 | |    / __ \   /\   |  __ \|  ____|  __ \ 
 | |   | |  | | /  \  | |  | | |__  | |__) |
 | |   | |  | |/ /\ \ | |  | |  __| |  _  / 
 | |___| |__| / ____ \| |__| | |____| | \ \ 
 |______\____/_/    \_\_____/|______|_|  \_\
]])
print("[Garden Engine]: Инициализация системы...")

local function SendNotification(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end)
end

SendNotification("Garden Engine", "Загрузка интерфейса...", 4)
task.wait(1)

-- ССЫЛКА НА ВАШ ИНТЕРФЕЙС (УЖЕ НАСТРОЕНА)
local mainScriptUrl = "https://raw.githubusercontent.com/Vladrys999/grow-a-garden-2/main/gui.lua"

local success, err = pcall(function()
    loadstring(game:HttpGet(mainScriptUrl))()
end)

if success then
    SendNotification("Успешно!", "Интерфейс загружен. Если скрыт, нажми INSERT.", 5)
else
    SendNotification("Ошибка загрузки", "Проверь консоль F9.", 5)
    warn("[Garden Engine Error]: " .. tostring(err))
end
