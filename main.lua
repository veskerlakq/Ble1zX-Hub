-- Ble1zX Hub - Main Loader
print("Loading Ble1zX Hub...")

-- Глобальные настройки
_G.Farm = false
_G.AutoKill = false
_G.Speed = 85
_G.SelectedField = "Strawberry Field"

-- Подгружаем модули (замени ссылки на свои RAW ссылки с GitHub)
local UI = loadstring(game:HttpGet("https://githubusercontent.com"))()
local FarmLogic = loadstring(game:HttpGet("https://githubusercontent.com"))()
local KillLogic = loadstring(game:HttpGet("https://githubusercontent.com"))()

-- Запуск
UI.Create()
FarmLogic.start()
KillLogic.logic()

print("Ble1zX Hub Loaded Successfully!")
