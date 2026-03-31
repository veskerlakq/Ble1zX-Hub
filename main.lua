-- Ble1zX Hub - Main Loader
print("Loading Ble1zX Hub...")

-- Глобальные настройки
_G.Farm = false
_G.AutoKill = false
_G.Speed = 85
_G.SelectedField = "Strawberry Field"
_G.CT = "Dark"
_G.Targets = {["Ladybug"]=false,["Rhino"]=false,["Spider"]=false,["Crab"]=false,["Vicious Bee"]=false}
_G.MemMatch = {["Common"]=false,["Night"]=false,["Mega"]=false,["Extreme"]=false}
_G.Fields = {["Sunflower Field"] = Vector3.new(-210, 5, 185), ["Strawberry Field"] = Vector3.new(-175, 20, 15), ["Pineapple Patch"] = Vector3.new(260, 25, -150), ["Coconut Field"] = Vector3.new(-255, 71, 460)}

-- ЗАГРУЗКА (Исправил привязку файлов к переменным)
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/veskerlakq/Ble1zX-Hub/refs/heads/main/ui.lua"))()
local KillLogic = loadstring(game:HttpGet("https://raw.githubusercontent.com/veskerlakq/Ble1zX-Hub/refs/heads/main/kill.lua"))()
local FarmLogic = loadstring(game:HttpGet("https://raw.githubusercontent.com/veskerlakq/Ble1zX-Hub/refs/heads/main/farm.lua"))()

-- ЗАПУСК
UI.Create()      -- Создает меню
KillLogic.logic() -- Запускает поток монстров (проверь, чтобы в kill.lua была функция .logic)
FarmLogic.start() -- Запускает поток фарма (проверь, чтобы в farm.lua была функция .start)

print("Ble1zX Hub Loaded Successfully!")
