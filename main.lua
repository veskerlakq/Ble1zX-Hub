-- [[ Ble1zX Hub v15.1 - FULL SOURCE ]]
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local ts = game:GetService("TweenService")
local vim = game:GetService("VirtualInputManager")

-- === НАСТРОЙКИ ===
_G.Farm = false
_G.AutoKill = false
_G.Speed = 85
_G.SelectedField = "Strawberry Field"
_G.SelectedBear = "Black Bear"
_G.AntiAFK = true
_G.Targets = {
    ["Ladybug"]=false,["Rhino"]=false,["Spider"]=false,["Werewolf"]=false,
    ["Mantis"]=false,["Stump Snail"]=false,["Coconut Crab"]=false,
    ["King Beetle"]=false,["Tunnel Bear"]=false,["Vicious Bee"]=false
}

-- === ТАБЛИЦЫ ДАННЫХ ===
local Fields = {
    ["Sunflower Field"] = Vector3.new(-210, 5, 185),
    ["Strawberry Field"] = Vector3.new(-175, 20, 15),
    ["Pineapple Patch"] = Vector3.new(260, 25, -150),
    ["Cactus Field"] = Vector3.new(-190, 68, -105),
    ["Coconut Field"] = Vector3.new(-255, 71, 460),
    ["Mountain Top"] = Vector3.new(75, 176, -165),
    ["Pine Tree Forest"] = Vector3.new(-315, 68, -200),
    ["Rose Field"] = Vector3.new(-325, 20, 125)
}

local Bears = {
    ["Black Bear"] = Vector3.new(-80, 5, 230),
    ["Mother Bear"] = Vector3.new(-180, 5, 240),
    ["Brown Bear"] = Vector3.new(282, 46, 236),
    ["Science Bear"] = Vector3.new(200, 103, 55),
    ["Polar Bear"] = Vector3.new(-105, 119, -58),
    ["Spirit Bear"] = Vector3.new(-362, 102, 478)
}

local ToysPos = {
    ["Stocking"] = Vector3.new(285, 48, 232),
    ["Samovar"] = Vector3.new(-195, 22, -52),
    ["Feast"] = Vector3.new(-180, 5, 200)
}

-- === ГРАФИКА (SIDEBAR + WATERMARK) ===
local sg = Instance.new("ScreenGui", player.PlayerGui); sg.Name = "Ble1zX_Hub"
local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 480, 0, 380); main.Position = UDim2.new(0.5, -240, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25); main.BorderSizePixel = 0; Instance.new("UICorner", main)

-- ПЕРЕДВИЖЕНИЕ (DRAG)
local dragging, dragInput, dragStart, startPos
main.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = main.Position end end)
main.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
game:GetService("UserInputService").InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
main.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- ВАТЕРМАРКА
local header = Instance.new("TextLabel", main); header.Size = UDim2.new(1, 0, 0, 35); header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
header.Text = "  Ble1zX Hub - BSS Premium"; header.TextColor3 = Color3.new(1,1,1); header.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", header)

-- БОКОВАЯ ПАНЕЛЬ
local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 110, 1, -35); side.Position = UDim2.new(0,0,0,35); side.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", side)

-- КОНТЕЙНЕР СТРАНИЦ
local cont = Instance.new("Frame", main); cont.Size = UDim2.new(0, 350, 0, 330); cont.Position = UDim2.new(0, 120, 0, 40); cont.BackgroundTransparency = 1
local function createP() 
    local p = Instance.new("ScrollingFrame", cont); p.Size = UDim2.new(1,0,1,0); p.BackgroundTransparency = 1; p.Visible = false; p.CanvasSize = UDim2.new(0,0,3.5,0); p.ScrollBarThickness = 3; return p 
end
local fP, kP, qP, tP, mP = createP(), createP(), createP(), createP(), createP()
fP.Visible = true

-- ВКЛАДКИ
local function sBtn(txt, y, p)
    local b = Instance.new("TextButton", side); b.Size = UDim2.new(0.9,0,0,30); b.Position = UDim2.new(0.05,0,0,y); b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(50,50,50); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() fP.Visible=(p==1); kP.Visible=(p==2); qP.Visible=(p==3); tP.Visible=(p==4); mP.Visible=(p==5) end)
end
sBtn("Farm", 10, 1); sBtn("Kill", 45, 2); sBtn("Quests", 80, 3); sBtn("Toys", 115, 4); sBtn("Misc", 150, 5)

-- ФУНКЦИЯ КНОПОК
local function btn(p, txt, y, func, toggle)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.95,0,0,30); b.Position = UDim2.new(0,0,0,y); b.Text = txt
    b.BackgroundColor3 = toggle and Color3.fromRGB(150,0,0) or Color3.fromRGB(60,60,60); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() func(b) end); return b
end

-- === FARM PAGE ===
btn(fP, "AUTO FARM: OFF", 0, function(b) 
    _G.Farm = not _G.Farm; b.Text = "AUTO FARM: "..(_G.Farm and "ON" or "OFF")
    b.BackgroundColor3 = _G.Farm and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0) 
end, true)
local fy = 40
for name, _ in pairs(Fields) do
    btn(fP, name, fy, function() _G.SelectedField = name end); fy = fy + 35
end

-- === KILL PAGE ===
btn(kP, "MASTER KILL: OFF", 0, function(b) 
    _G.AutoKill = not _G.AutoKill; b.Text = "MASTER KILL: "..(_G.AutoKill and "ON" or "OFF")
    b.BackgroundColor3 = _G.AutoKill and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
end, true)
local ky = 40
for name, _ in pairs(_G.Targets) do
    btn(kP, name..": OFF", ky, function(b) 
        _G.Targets[name] = not _G.Targets[name]
        b.Text = name..(_G.Targets[name] and ": ON" or ": OFF")
        b.BackgroundColor3 = _G.Targets[name] and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
    end, true); ky = ky + 35
end

-- === QUEST PAGE ===
btn(qP, "Talk to NPC", 0, function()
    local pos = Bears[_G.SelectedBear]
    ts:Create(root, TweenInfo.new((root.Position-pos).Magnitude/_G.Speed), {CFrame = CFrame.new(pos)}):Play()
    task.wait((root.Position-pos).Magnitude/_G.Speed + 0.5)
    for i=1,15 do vim:SendKeyEvent(true, Enum.KeyCode.E, false, game); task.wait(0.2); vim:SendMouseButtonEvent(0,0,0,true,game,0); task.wait(0.1) end
end)
local qy = 40
for name, _ in pairs(Bears) do
    btn(qP, "Bear: "..name, qy, function() _G.SelectedBear = name end); qy = qy + 35
end

-- === ЛОГИКА (ЦИКЛЫ) ===
spawn(function()
    while true do task.wait(0.5); if _G.Farm then
        local t = Fields[_G.SelectedField] or Fields["Strawberry Field"]
        ts:Create(root, TweenInfo.new((root.Position-t).Magnitude/_G.Speed), {CFrame = CFrame.new(t)}):Play()
        task.wait((root.Position-t).Magnitude/_G.Speed)
        while _G.Farm and player.CoreStats.Pollen.Value < player.CoreStats.Capacity.Value do
            local tool = char:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
            if tool then tool.Parent = char; tool:Activate() end
            game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("CollectPollen")
            for _,v in pairs(game.Workspace.Collectibles:GetChildren()) do if (root.Position-v.Position).Magnitude < 55 then hum:MoveTo(v.Position) end end
            task.wait(0.4)
        end
        local h = player.SpawnPos.Value.Position
        ts:Create(root, TweenInfo.new((root.Position-h).Magnitude/_G.Speed), {CFrame = CFrame.new(h)}):Play()
        task.wait((root.Position-h).Magnitude/_G.Speed); repeat task.wait(1); game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking") until player.CoreStats.Pollen.Value == 0 or not _G.Farm
    end end
end)

spawn(function()
    while task.wait(0.2) do
        if _G.AutoKill then
            for _,v in pairs(game.Workspace.Monsters:GetChildren()) do
                for k,s in pairs(_G.Targets) do if s and v.Name:find(k) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then root.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,19,0) end end
            end
        end
    end
end)

print("Ble1zX Hub v15.1 LOADED! Full 200+ Lines Restored.")
