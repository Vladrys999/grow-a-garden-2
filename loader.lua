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

-- ССЫЛКА НА ВАШ ИНТЕРФЕЙС
local mainScriptUrl = "https://raw.githubusercontent.com/Vladrys999/grow-a-garden-2/main/gui.lua"

-- Обход ошибки loadstring через кастомную функцию загрузки (совместимо со всеми инжекторами)
local function safeLoad(url)
    local success, code = pcall(game.HttpGet, game, url)
    if not success then return false, "Не удалось скачать код" end
    
    local loadMethod = loadstring or (syn and syn.loadstring) or (Fluxus and Fluxus.loadstring)
    if not loadMethod then
        return false, "Ваш инжектор не поддерживает loadstring"
    end
    
    local func, err = loadMethod(code)
    if not func then return false, err end
    
    local runSuccess, runErr = pcall(func)
    if not runSuccess then return false, runErr end
    
    return true
end

local success, err = safeLoad(mainScriptUrl)

if success then
    SendNotification("Успешно!", "Интерфейс загружен. Скрытие на ПРАВЫЙ SHIFT.", 5)
else
    SendNotification("Ошибка запуска", "Проверь консоль F9.", 5)
    warn("[Garden Engine Error]: " .. tostring(err))
end
