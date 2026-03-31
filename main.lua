-- Ble1zX Hub v6.0 (ALL-IN-ONE EDITION)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- ИНИЦИАЛИЗАЦИЯ НАСТРОЕК
_G.Farm = false
_G.AutoKill = false
_G.Speed = 85
_G.SelectedField = "Strawberry Field"
_G.CT = "Dark"
_G.Targets = {["Ladybug"]=false,["Rhino"]=false,["Spider"]=false,["Coconut Crab"]=false,["Vicious Bee"]=false}
_G.MemMatch = {["Common"]=false,["Night"]=false,["Mega"]=false,["Extreme"]=false}
_G.Fields = {
    ["Sunflower Field"] = Vector3.new(-210, 5, 185),
    ["Strawberry Field"] = Vector3.new(-175, 20, 15),
    ["Pineapple Patch"] = Vector3.new(260, 25, -150),
    ["Coconut Field"] = Vector3.new(-255, 71, 460)
}

-- ГРАФИЧЕСКИЙ ИНТЕРФЕЙС
local sg = Instance.new("ScreenGui", player.PlayerGui); sg.Name = "Ble1zX_Hub"
local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 400, 0, 450); main.Position = UDim2.new(0.5, -200, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); main.Active = true; main.Draggable = true; Instance.new("UICorner", main)

local topBar = Instance.new("TextLabel", main); topBar.Size = UDim2.new(1, 0, 0, 35); topBar.Text = "   Ble1zX Hub v6.0"; topBar.TextColor3 = Color3.new(1,1,1)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35); topBar.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", topBar)

local themes = {
    Dark = {bg = Color3.fromRGB(20, 20, 20), btn = Color3.fromRGB(45, 45, 45), txt = Color3.new(1,1,1), on = Color3.fromRGB(0, 170, 0), off = Color3.fromRGB(170, 0, 0)},
    Atlas = {bg = Color3.fromRGB(10, 10, 25), btn = Color3.fromRGB(0, 85, 170), txt = Color3.new(1,1,1), on = Color3.fromRGB(0, 200, 255), off = Color3.fromRGB(35, 35, 70)}
}

local allElements = {}
local function applyTheme(k)
    local t = themes[k or "Dark"]; main.BackgroundColor3 = t.bg
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
    p.BackgroundTransparency = 1; p.CanvasSize = UDim2.new(0,0,2.5,0); p.Visible = false; p.ScrollBarThickness = 4; return p 
end
local farmP, killP, miscP, themeP = createP(), createP(), createP(), createP(); farmP.Visible = true

local function btn(p, text, y, func, isT)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.9, 0, 0, 32); b.Position = UDim2.new(0.05, 0, 0, y); b.Text = text
    Instance.new("UICorner", b); if isT then b:SetAttribute("IsToggle", true); b:SetAttribute("Active", false) end
    b.MouseButton1Click:Connect(function() func(b) end); table.insert(allElements, b); return b
end

-- НАВИГАЦИЯ
local function tBtn(t, x, p)
    local b = btn(main, t, 40, function() farmP.Visible=(p==1); killP.Visible=(p==2); miscP.Visible=(p==3); themeP.Visible=(p==4) end)
    b.Size = UDim2.new(0.23, 0, 0, 30); b.Position = UDim2.new(x, 0, 0.1, 0)
end
tBtn("Farm", 0.02, 1); tBtn("Kill", 0.27, 2); tBtn("Misc", 0.52, 3); tBtn("Theme", 0.77, 4)

-- КОНТЕНТ ВКЛАДОК
btn(farmP, "Auto Farm: OFF", 10, function(b) _G.Farm = not _G.Farm; b:SetAttribute("Active", _G.Farm); b.Text = _G.Farm and "Auto Farm: ON" or "Auto Farm: OFF"; applyTheme(_G.CT) end, true)
btn(farmP, "Field: Strawberry Field", 50, function(b)
    local l = {"Sunflower Field", "Strawberry Field", "Pineapple Patch", "Coconut Field"}; local i = table.find(l, _G.SelectedField) or 1
    i = i + 1; if i > #l then i = 1 end; _G.SelectedField = l[i]; b.Text = "Field: ".._G.SelectedField
end)

btn(killP, "MASTER KILL: OFF", 10, function(b) _G.AutoKill = not _G.AutoKill; b:SetAttribute("Active", _G.AutoKill); b.Text = _G.AutoKill and "MASTER KILL: ON" or "MASTER KILL: OFF"; applyTheme(_G.CT) end, true)
local ky = 50; for name, _ in pairs(_G.Targets) do
    btn(killP, name..": OFF", ky, function(b) _G.Targets[name] = not _G.Targets[name]; b:SetAttribute("Active", _G.Targets[name]); b.Text = name..(_G.Targets[name] and ": ON" or ": OFF"); applyTheme(_G.CT) end, true)
    ky = ky + 40
end

local memFrame = Instance.new("Frame", miscP); memFrame.Size = UDim2.new(1,0,0,0); memFrame.Position = UDim2.new(0,0,0,45); memFrame.BackgroundTransparency = 1; memFrame.ClipsDescendants = true
btn(miscP, "Memory Match Menu [+/-]", 10, function() memFrame.Size = memFrame.Size.Y.Offset == 0 and UDim2.new(1,0,0,170) or UDim2.new(1,0,0,0) end)
local my = 0; for name, _ in pairs(_G.MemMatch) do
    btn(memFrame, name.." Match: OFF", my, function(b) _G.MemMatch[name] = not _G.MemMatch[name]; b:SetAttribute("Active", _G.MemMatch[name]); b.Text = name.." Match: "..(_G.MemMatch[name] and "ON" or "OFF"); applyTheme(_G.CT) end, true)
    my = my + 40
end

btn(themeP, "Dark Theme", 10, function() _G.CT="Dark"; applyTheme("Dark") end)
btn(themeP, "Atlas Theme", 50, function() _G.CT="Atlas"; applyTheme("Atlas") end)

-- ЛОГИКА МОБОВ
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

-- ЛОГИКА ФАРМА
spawn(function()
    while true do 
        task.wait(0.5)
        if _G.Farm then
            local t = _G.Fields[_G.SelectedField]
            game:GetService("TweenService"):Create(root, TweenInfo.new((root.Position-t).Magnitude/_G.Speed), {CFrame = CFrame.new(t)}):Play()
            task.wait((root.Position-t).Magnitude/_G.Speed)
            while _G.Farm and player.CoreStats.Pollen.Value < player.CoreStats.Capacity.Value do
                local tool = char:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
                if tool then tool.Parent = char; tool:Activate() end
                game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("CollectPollen")
                for _, v in pairs(game.Workspace.Collectibles:GetChildren()) do if (root.Position-v.Position).Magnitude < 55 then hum:MoveTo(v.Position) end end
                task.wait(0.4)
            end
            local h = player.SpawnPos.Value.Position
            game:GetService("TweenService"):Create(root, TweenInfo.new((root.Position-h).Magnitude/_G.Speed), {CFrame = CFrame.new(h)}):Play()
            task.wait((root.Position-h).Magnitude/_G.Speed); repeat task.wait(1); game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking") until player.CoreStats.Pollen.Value == 0 or not _G.Farm
        end
    end
end)

applyTheme("Dark")
print("Ble1zX Hub Loaded!")
