-- [[ GARDEN ENGINE v3.0 - OFFICIAL LOADER ]]
-- Репозиторий: Vladrys999/grow-a-garden-2

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Настройки лоадера
local GameID = 14361531771 -- Пример PlaceID для Groovy Garden 2 (замени на точный, если отличается)
local CurrentPlaceID = game.PlaceId

-- Красивое приветствие в консоли разработчика (F9)
print([[ 
  _      ____          _____  ______ _____  
 | |    / __ \   /\   |  __ \|  ____|  __ \ 
 | |   | |  | | /  \  | |  | | |__  | |__) |
 | |   | |  | |/ /\ \ | |  | |  __| |  _  / 
 | |___| |__| / ____ \| |__| | |____| | \ \ 
 |______\____/_/    \_\_____/|______|_|  \_\
]])
print("[Garden Engine]: Инициализация системы...")

-- Функция для отправки красивых уведомлений в игре
local function SendNotification(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end)
end

-- Проверка: та ли это игра?
if CurrentPlaceID == GameID or true then -- Удали 'or true', если хочешь жесткую привязку только к одной игре
    SendNotification("Garden Engine", "Проверка пройдена. Загрузка интерфейса...", 4)
    task.wait(1)
    
    -- ЗАГРУЗКА ОСНОВНОГО ИНТЕРФЕЙСА С ТВОЕГО ГИТХАБА
    -- Замени 'имя_файла_интерфейса.lua' на название файла с дизайном, который лежит у тебя в репе
    local mainScriptUrl = "https://raw.githubusercontent.com/Vladrys999/grow-a-garden-2/main/имя_файла_интерфейса.lua"
    
    local success, err = pcall(function()
        loadstring(game:HttpGet(mainScriptUrl))()
    end)
    
    if success then
        SendNotification("Успешно!", "Скрипт успешно запущен. Нажми INSERT.", 5)
    else
        SendNotification("Ошибка загрузки", "Не удалось скачать файлы скрипта.", 5)
        warn("[Garden Engine Error]: " .. tostring(err))
    end
else
    SendNotification("Ошибка запуска", "Скрипт не поддерживает эту игру!", 6)
    warn("[Garden Engine]: Неверный PlaceID (" .. tostring(CurrentPlaceID) .. ")")
end
