-- [[ Ble1zX Hub v11.0 - ULTIMATE EDITION ]]
-- Оптимизировано для JJSploit

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local ts = game:GetService("TweenService")
local vim = game:GetService("VirtualInputManager")

-- === НАСТРОЙКИ (ГЛОБАЛЬНЫЕ) ===
_G.Farm = false
_G.AutoKill = false
_G.Speed = 85
_G.AntiAFK = true
_G.AutoMemory = false
_G.SelectedField = "Strawberry Field"
_G.SelectedBear = "Black Bear"
_G.CT = "Dark"

_G.Targets = {
    ["Ladybug"]=false,["Rhino"]=false,["Spider"]=false,["Mantis"]=false,
    ["Werewolf"]=false,["Mondo Chick"]=false,["Coconut Crab"]=false,["Vicious Bee"]=false
}
_G.MemMatch = {["Common"]=false,["Night"]=false,["Mega"]=false,["Extreme"]=false}

-- === ТАБЛИЦА КООРДИНАТ ===
local Fields = {
    ["Sunflower Field"] = Vector3.new(-210, 5, 185),
    ["Strawberry Field"] = Vector3.new(-175, 20, 15),
    ["Pineapple Patch"] = Vector3.new(260, 25, -150),
    ["Coconut Field"] = Vector3.new(-255, 71, 460),
    ["Mountain Top"] = Vector3.new(75, 176, -165)
}

local Bears = {
    ["Black Bear"] = Vector3.new(-80, 5, 230),
    ["Mother Bear"] = Vector3.new(-180, 5, 240),
    ["Brown Bear"] = Vector3.new(280, 45, 235),
    ["Science Bear"] = Vector3.new(200, 100, 50),
    ["Polar Bear"] = Vector3.new(-105, 120, -50),
    ["Spirit Bear"] = Vector3.new(-360, 100, 480),
    ["Bucko Bee"] = Vector3.new(300, 60, 110),
    ["Riley Bee"] = Vector3.new(-300, 60, 200)
}

local Toys = {
    ["Stocking"] = Vector3.new(285, 46, 230),
    ["Samovar"] = Vector3.new(-200, 20, -50),
    ["Feast"] = Vector3.new(-180, 5, 200),
    ["Candle"] = Vector3.new(-40, 20, -10),
    ["Clock"] = Vector3.new(200, 100, 50),
    ["Blue Booster"] = Vector3.new(290, 60, 115),
    ["Red Booster"] = Vector3.new(-305, 60, 205)
}

-- === ИНТЕРФЕЙС ===
local sg = Instance.new("ScreenGui", player.PlayerGui); sg.Name = "Ble1zX_Hub"
local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 420, 0, 500); main.Position = UDim2.new(0.5, -210, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); main.Active = true; main.Draggable = true; Instance.new("UICorner", main)

local topBar = Instance.new("TextLabel", main); topBar.Size = UDim2.new(1, 0, 0, 35); topBar.Text = "   Ble1zX Hub v11.0"; topBar.TextColor3 = Color3.new(1,1,1)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35); topBar.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", topBar)

local themes = {
    Dark = {bg = Color3.fromRGB(20, 20, 20), btn = Color3.fromRGB(45, 45, 45), txt = Color3.new(1,1,1), on = Color3.fromRGB(0, 170, 0), off = Color3.fromRGB(170, 0, 0)},
    Atlas = {bg = Color3.fromRGB(10, 10, 25), btn = Color3.fromRGB(0, 85, 170), txt = Color3.new(1,1,1), on = Color3.fromRGB(0, 200, 255), off = Color3.fromRGB(35, 35, 70)}
}

local allElements = {}
local function applyTheme(k)
    local t = themes[k or "Dark"]; main.BackgroundColor3 = t.bg; topBar.TextColor3 = t.txt
    for _, el in pairs(allElements) do
        if el:IsA("TextButton") then
            el.TextColor3 = t.txt
            if el:GetAttribute("IsToggle") then el.BackgroundColor3 = el:GetAttribute("Active") and t.on or t.off
            else el.BackgroundColor3 = t.btn end
        elseif el:IsA("TextLabel") then el.TextColor3 = t.txt end
    end
end

local function createP() 
    local p = Instance.new("ScrollingFrame", main); p.Size = UDim2.new(1,0,0.8,0); p.Position = UDim2.new(0,0,0.2,0); 
    p.BackgroundTransparency = 1; p.CanvasSize = UDim2.new(0,0,4,0); p.Visible = false; p.ScrollBarThickness = 4; return p 
end

local farmP, killP, questP, toysP, miscP, themeP = createP(), createP(), createP(), createP(), createP(), createP()
farmP.Visible = true

local function btn(p, text, y, func, isT)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.9, 0, 0, 32); b.Position = UDim2.new(0.05, 0, 0, y); b.Text = text
    Instance.new("UICorner", b); if isT then b:SetAttribute("IsToggle", true); b:SetAttribute("Active", false) end
    b.MouseButton1Click:Connect(function() func(b) end); table.insert(allElements, b); return b
end

-- ТАБЫ
local function tBtn(t, x, p)
    local b = btn(main, t, 40, function() farmP.Visible=(p==1); killP.Visible=(p==2); questP.Visible=(p==3); toysP.Visible=(p==4); miscP.Visible=(p==5); themeP.Visible=(p==6) end)
    b.Size = UDim2.new(0.15, 0, 0, 28); b.Position = UDim2.new(x, 0, 0.1, 0)
end
tBtn("Farm", 0.02, 1); tBtn("Kill", 0.18, 2); tBtn("Quest", 0.34, 3); tBtn("Toys", 0.50, 4); tBtn("Misc", 0.66, 5); tBtn("Theme", 0.82, 6)

-- === ЛОГИКА ФАРМА ===
btn(farmP, "Auto Farm: OFF", 10, function(b) _G.Farm = not _G.Farm; b:SetAttribute("Active", _G.Farm); b.Text = _G.Farm and "Auto Farm: ON" or "Auto Farm: OFF"; applyTheme(_G.CT) end, true)
btn(farmP, "Field: Strawberry Field", 50, function(b)
    local l = {"Sunflower Field", "Strawberry Field", "Pineapple Patch", "Coconut Field", "Mountain Top"}
    local i = table.find(l, _G.SelectedField) or 1; i = i + 1; if i > #l then i = 1 end
    _G.SelectedField = l[i]; b.Text = "Field: ".._G.SelectedField
end)

spawn(function()
    while true do 
        task.wait(0.5); if _G.Farm then
            local t = Fields[_G.SelectedField]
            ts:Create(root, TweenInfo.new((root.Position-t).Magnitude/_G.Speed), {CFrame = CFrame.new(t)}):Play()
            task.wait((root.Position-t).Magnitude/_G.Speed)
            while _G.Farm and player.CoreStats.Pollen.Value < player.CoreStats.Capacity.Value do
                local tool = char:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
                if tool then tool.Parent = char; tool:Activate() end
                game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("CollectPollen")
                for _, v in pairs(game.Workspace.Collectibles:GetChildren()) do if (root.Position-v.Position).Magnitude < 55 then hum:MoveTo(v.Position) end end
                task.wait(0.4)
            end
            local h = player.SpawnPos.Value.Position
            ts:Create(root, TweenInfo.new((root.Position-h).Magnitude/_G.Speed), {CFrame = CFrame.new(h)}):Play()
            task.wait((root.Position-h).Magnitude/_G.Speed); repeat task.wait(1); game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking") until player.CoreStats.Pollen.Value == 0 or not _G.Farm
        end
    end
end)

-- === ЛОГИКА KILL ===
btn(killP, "MASTER KILL: OFF", 10, function(b) _G.AutoKill = not _G.AutoKill; b:SetAttribute("Active", _G.AutoKill); b.Text = _G.AutoKill and "MASTER KILL: ON" or "MASTER KILL: OFF"; applyTheme(_G.CT) end, true)
local ky = 50; for name, _ in pairs(_G.Targets) do
    btn(killP, name..": OFF", ky, function(b) _G.Targets[name] = not _G.Targets[name]; b:SetAttribute("Active", _G.Targets[name]); b.Text = name..(_G.Targets[name] and ": ON" or ": OFF"); applyTheme(_G.CT) end, true)
    ky = ky + 40
end

spawn(function()
    while task.wait(0.2) do
        if _G.AutoKill then
            for _, v in pairs(game.Workspace.Monsters:GetChildren()) do
                for k, s in pairs(_G.Targets) do 
                    if s and v.Name:find(k) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then 
                        root.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 19, 0) 
                    end 
                end
            end
        end
    end
end)

-- === КВЕСТЫ ===
btn(questP, "Go to NPC & Talk", 10, function()
    local pos = Bears[_G.SelectedBear]
    ts:Create(root, TweenInfo.new((root.Position-pos).Magnitude/_G.Speed), {CFrame = CFrame.new(pos)}):Play()
    task.wait((root.Position-pos).Magnitude/_G.Speed)
    vim:SendKeyEvent(true, Enum.KeyCode.E, false, game); task.wait(0.1); vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end)

btn(questP, "Bear: Black Bear", 50, function(b)
    local l = {"Black Bear", "Mother Bear", "Brown Bear", "Science Bear", "Polar Bear", "Spirit Bear"}
    local i = table.find(l, _G.SelectedBear) or 1; i = i + 1; if i > #l then i = 1 end
    _G.SelectedBear = l[i]; b.Text = "Bear: ".._G.SelectedBear
end)

-- === TOYS (BEESMAS) ===
btn(toysP, "Use Stocking", 10, function()
    local pos = Toys["Stocking"]
    ts:Create(root, TweenInfo.new((root.Position-pos).Magnitude/_G.Speed), {CFrame = CFrame.new(pos)}):Play()
    task.wait((root.Position-pos).Magnitude/_G.Speed)
    vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
end)

btn(toysP, "Use Samovar", 50, function()
    local pos = Toys["Samovar"]
    ts:Create(root, TweenInfo.new((root.Position-pos).Magnitude/_G.Speed), {CFrame = CFrame.new(pos)}):Play()
    task.wait((root.Position-pos).Magnitude/_G.Speed)
    vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
end)

-- === MISC (ANTI-AFK & MEMORY) ===
btn(miscP, "Anti-AFK: ON", 10, function(b) _G.AntiAFK = not _G.AntiAFK; b:SetAttribute("Active", _G.AntiAFK); b.Text = _G.AntiAFK and "Anti-AFK: ON" or "Anti-AFK: OFF"; applyTheme(_G.CT) end, true):SetAttribute("Active", true)

player.Idled:Connect(function()
    if _G.AntiAFK then
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1); game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- === THEMES ===
btn(themeP, "Dark Theme", 10, function() _G.CT="Dark"; applyTheme("Dark") end)
btn(themeP, "Atlas Theme", 50, function() _G.CT="Atlas"; applyTheme("Atlas") end)

applyTheme("Dark")
print("Ble1zX Hub v11.0 LOADED!")
