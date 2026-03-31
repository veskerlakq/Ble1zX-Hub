-- Ble1zX Hub v3.0 (Kill Tab & Priority Fix)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

_G.Farm = false
_G.AutoKill = false -- Главный рубильник
_G.Speed = 85
_G.SelectedField = "Strawberry Field"
_G.AntiAFK = true
_G.AutoMemory = false

-- Таблица целей (по умолчанию всё выключено)
_G.Targets = {
    ["Ladybug"] = false, ["Rhino"] = false, ["Mantis"] = false, 
    ["Spider"] = false, ["Werewolf"] = false, ["King Beetle"] = false, 
    ["Tunnel Bear"] = false, ["Coconut Crab"] = false, ["Commando Chick"] = false
}

local Fields = {
    ["Sunflower Field"] = Vector3.new(-210, 5, 185),
    ["Strawberry Field"] = Vector3.new(-175, 20, 15),
    ["Pineapple Patch"] = Vector3.new(260, 25, -150),
    ["Coconut Field"] = Vector3.new(-255, 71, 460),
    ["Mountain Top"] = Vector3.new(75, 176, -165)
}

-- ГРАФИКА
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "Ble1zX_Hub"
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 380, 0, 420); main.Position = UDim2.new(0.5, -190, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25); main.Active = true; main.Draggable = true
Instance.new("UICorner", main)

local topBar = Instance.new("TextLabel", main)
topBar.Size = UDim2.new(1, 0, 0, 35); topBar.Text = "   Ble1zX Hub - Kill Update"; topBar.TextColor3 = Color3.new(1,1,1)
topBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45); topBar.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", topBar)

-- ТЕМЫ
local themes = {
    Dark = {bg = Color3.fromRGB(25, 25, 25), btn = Color3.fromRGB(50, 50, 50), txt = Color3.new(1,1,1), on = Color3.fromRGB(0, 160, 0), off = Color3.fromRGB(160, 0, 0)},
    Atlas = {bg = Color3.fromRGB(12, 12, 24), btn = Color3.fromRGB(0, 90, 160), txt = Color3.new(1,1,1), on = Color3.fromRGB(0, 190, 255), off = Color3.fromRGB(40, 40, 70)}
}

local allElements = {}
local function applyTheme(tKey)
    local t = themes[tKey] or themes.Dark; main.BackgroundColor3 = t.bg
    for _, el in pairs(allElements) do
        if el:IsA("TextButton") then
            el.TextColor3 = t.txt
            if el:GetAttribute("IsToggle") then el.BackgroundColor3 = el:GetAttribute("Active") and t.on or t.off
            else el.BackgroundColor3 = t.btn end
        elseif el:IsA("TextLabel") then el.TextColor3 = t.txt end
    end
end

-- ВКЛАДКИ
local function createP() 
    local p = Instance.new("ScrollingFrame", main); p.Size = UDim2.new(1,0,0.75,0); p.Position = UDim2.new(0,0,0.25,0); 
    p.BackgroundTransparency = 1; p.CanvasSize = UDim2.new(0,0,2,0); p.Visible = false; p.ScrollBarThickness = 4; return p 
end
local farmP = createP(); farmP.Visible = true
local killP = createP()
local miscP = createP()
local themeP = createP()

local function btn(p, text, y, func, isT)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = UDim2.new(0.05, 0, 0, y); b.Text = text
    Instance.new("UICorner", b); if isT then b:SetAttribute("IsToggle", true); b:SetAttribute("Active", false) end
    b.MouseButton1Click:Connect(function() func(b) end); table.insert(allElements, b); return b
end

-- ТАБЫ
local function tBtn(t, x, p)
    local b = btn(main, t, 40, function() farmP.Visible=(p==1); killP.Visible=(p==2); miscP.Visible=(p==3); themeP.Visible=(p==4) end)
    b.Size = UDim2.new(0.23, 0, 0, 30); b.Position = UDim2.new(x, 0, 0.1, 0)
end
tBtn("Farm", 0.02, 1); tBtn("Kill", 0.27, 2); tBtn("Misc", 0.52, 3); tBtn("Theme", 0.77, 4)

-- FARM CONTENT
btn(farmP, "Auto Farm: OFF", 10, function(b) _G.Farm = not _G.Farm; b:SetAttribute("Active", _G.Farm); b.Text = _G.Farm and "Auto Farm: ON" or "Auto Farm: OFF"; applyTheme(_G.CT) end, true)
btn(farmP, "Field: Strawberry Field", 55, function(b)
    local l = {"Sunflower Field", "Strawberry Field", "Pineapple Patch", "Coconut Field", "Mountain Top"}
    local i = table.find(l, _G.SelectedField) or 1; i = i + 1; if i > #l then i = 1 end
    _G.SelectedField = l[i]; b.Text = "Field: ".._G.SelectedField
end)

-- KILL CONTENT
btn(killP, "MASTER AUTO KILL: OFF", 10, function(b) _G.AutoKill = not _G.AutoKill; b:SetAttribute("Active", _G.AutoKill); b.Text = _G.AutoKill and "MASTER KILL: ON" or "MASTER KILL: OFF"; applyTheme(_G.CT) end, true)
local y = 55
for name, _ in pairs(_G.Targets) do
    btn(killP, name..": OFF", y, function(b) 
        _G.Targets[name] = not _G.Targets[name]
        b:SetAttribute("Active", _G.Targets[name]); b.Text = name..(_G.Targets[name] and ": ON" or ": OFF"); applyTheme(_G.CT)
    end, true)
    y = y + 45
end

-- MISC & THEME
btn(miscP, "Memory Match: OFF", 10, function(b) _G.AutoMemory = not _G.AutoMemory; b:SetAttribute("Active", _G.AutoMemory); b.Text = _G.AutoMemory and "Memory Match: ON" or "Memory Match: OFF"; applyTheme(_G.CT) end, true)
btn(themeP, "Dark Theme", 10, function() _G.CT="Dark"; applyTheme("Dark") end)
btn(themeP, "Atlas Theme", 55, function() _G.CT="Atlas"; applyTheme("Atlas") end)

-- ЛОГИКА KILL (Исправленная)
spawn(function()
    while task.wait(0.1) do
        if _G.AutoKill then
            for _, v in pairs(game.Workspace.Monsters:GetChildren()) do
                local tName = nil
                for k, _ in pairs(_G.Targets) do if v.Name:find(k) and _G.Targets[k] then tName = k break end end
                
                if tName and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    root.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 19, 0)
                    task.wait(0.2)
                end
            end
        end
    end
end)

-- ЛОГИКА FARM & LOOT
spawn(function()
    while true do
        task.wait(0.5)
        if _G.Farm then
            local target = Fields[_G.SelectedField]
            game:GetService("TweenService"):Create(root, TweenInfo.new((root.Position-target).Magnitude/_G.Speed), {CFrame = CFrame.new(target)}):Play()
            task.wait((root.Position-target).Magnitude/_G.Speed)
            while _G.Farm and player.CoreStats.Pollen.Value < player.CoreStats.Capacity.Value do
                local t = char:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
                if t then t.Parent = char; t:Activate() end
                game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("CollectPollen")
                for _, v in pairs(game.Workspace.Collectibles:GetChildren()) do
                    if (root.Position - v.Position).Magnitude < 55 then hum:MoveTo(v.Position) end
                end
                task.wait(0.4)
            end
            local h = player.SpawnPos.Value.Position
            game:GetService("TweenService"):Create(root, TweenInfo.new((root.Position-h).Magnitude/_G.Speed), {CFrame = CFrame.new(h)}):Play()
            task.wait((root.Position-h).Magnitude/_G.Speed)
            repeat task.wait(1); game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking") until player.CoreStats.Pollen.Value == 0 or not _G.Farm
        end
    end
end)

applyTheme("Dark")

