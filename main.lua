-- [[ Ble1zX Hub v14.0 - MEGA REPAIR & FULL CONTENT ]]
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local ts = game:GetService("TweenService")
local vim = game:GetService("VirtualInputManager")

-- === ГЛОБАЛКИ ===
_G.Farm = false
_G.AutoKill = false
_G.Speed = 85
_G.SelectedField = "Strawberry Field"
_G.SelectedBear = "Black Bear"
_G.AntiAFK = true
_G.Targets = {["Ladybug"]=false,["Rhino"]=false,["Spider"]=false,["Werewolf"]=false,["Mantis"]=false,["Stump Snail"]=false,["Coconut Crab"]=false,["Vicious Bee"]=false}
_G.MemMatch = {["Common"]=false,["Night"]=false,["Mega"]=false,["Extreme"]=false}

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
    ["Polar Bear"] = Vector3.new(-105, 119, -58)
}

local ToysPos = {
    ["Stocking"] = Vector3.new(285, 48, 232),
    ["Samovar"] = Vector3.new(-195, 22, -52),
    ["Feast"] = Vector3.new(-180, 5, 200)
}

-- === ГУИ С БОКОВОЙ ПАНЕЛЬЮ ===
local sg = Instance.new("ScreenGui", player.PlayerGui); sg.Name = "Ble1zX_Hub"
local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 480, 0, 380); main.Position = UDim2.new(0.5, -240, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); main.Active = true; main.Draggable = true; Instance.new("UICorner", main)

local sideBar = Instance.new("Frame", main); sideBar.Size = UDim2.new(0, 100, 1, 0); sideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", sideBar)

local container = Instance.new("Frame", main); container.Size = UDim2.new(0, 360, 0.9, 0); container.Position = UDim2.new(0.23, 0, 0.05, 0); container.BackgroundTransparency = 1

local function createPage()
    local p = Instance.new("ScrollingFrame", container); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false
    p.ScrollBarThickness = 4; p.CanvasSize = UDim2.new(0,0,3.5,0); return p
end

local farmP, killP, questP, toysP, miscP = createPage(), createPage(), createPage(), createPage(), createPage()
farmP.Visible = true

local function sBtn(txt, y, p)
    local b = Instance.new("TextButton", sideBar); b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = UDim2.new(0.05, 0, 0, y)
    b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(45, 45, 45); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() farmP.Visible=(p==1); killP.Visible=(p==2); questP.Visible=(p==3); toysP.Visible=(p==4); miscP.Visible=(p==5) end)
end
sBtn("Farm", 40, 1); sBtn("Kill", 85, 2); sBtn("Quest", 130, 3); sBtn("Toys", 175, 4); sBtn("Misc", 220, 5)

-- Функция кнопок
local function btn(p, text, y, func, isT)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.9, 0, 0, 32); b.Position = UDim2.new(0.05, 0, 0, y); b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50,50,50); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    if isT then b.BackgroundColor3 = Color3.fromRGB(150,0,0) end
    b.MouseButton1Click:Connect(function() func(b) end); return b
end

-- === FARM PAGE ===
btn(farmP, "Auto Farm: OFF", 10, function(b) 
    _G.Farm = not _G.Farm
    b.Text = "Auto Farm: " .. (_G.Farm and "ON" or "OFF")
    b.BackgroundColor3 = _G.Farm and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
end, true)

local fy = 50
for name, _ in pairs(Fields) do
    btn(farmP, name, fy, function() _G.SelectedField = name; print("Выбрано: "..name) end)
    fy = fy + 35
end

-- === KILL PAGE ===
local ky = 10
for name, _ in pairs(_G.Targets) do
    btn(killP, name..": OFF", ky, function(b) 
        _G.Targets[name] = not _G.Targets[name]
        b.Text = name .. (_G.Targets[name] and ": ON" or ": OFF")
        b.BackgroundColor3 = _G.Targets[name] and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
    end, true)
    ky = ky + 35
end

-- === QUEST PAGE ===
btn(questP, "Talk to NPC", 10, function()
    local pos = Bears[_G.SelectedBear]
    ts:Create(root, TweenInfo.new((root.Position-pos).Magnitude/_G.Speed), {CFrame = CFrame.new(pos)}):Play()
    task.wait((root.Position-pos).Magnitude/_G.Speed + 0.5)
    for i=1,15 do vim:SendKeyEvent(true, Enum.KeyCode.E, false, game); task.wait(0.2); vim:SendMouseButtonEvent(0,0,0,true,game,0); task.wait(0.1) end
end)

local qy = 50
for name, _ in pairs(Bears) do
    btn(questP, "Bear: "..name, qy, function() _G.SelectedBear = name end)
    qy = qy + 35
end

-- === TOYS PAGE ===
local ty = 10
for name, pos in pairs(ToysPos) do
    btn(toysP, "Use "..name, ty, function()
        ts:Create(root, TweenInfo.new((root.Position-pos).Magnitude/_G.Speed), {CFrame = CFrame.new(pos)}):Play()
        task.wait((root.Position-pos).Magnitude/_G.Speed + 0.5)
        vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        for i=1,10 do -- Лутаем
            for _,v in pairs(game.Workspace.Collectibles:GetChildren()) do if (root.Position-v.Position).Magnitude < 40 then hum:MoveTo(v.Position) end end
            task.wait(0.4)
        end
    end)
    ty = ty + 35
end

-- === MISC PAGE ===
btn(miscP, "Anti-AFK: ON", 10, function(b) _G.AntiAFK = not _G.AntiAFK; b.Text = "Anti-AFK: "..(_G.AntiAFK and "ON" or "OFF") end, true)
btn(miscP, "Collect Mushrooms", 50, function()
    for _,v in pairs(game.Workspace.Mushrooms:GetChildren()) do root.CFrame = v.CFrame; task.wait(0.3) end
end)

-- === ОСНОВНЫЕ ЦИКЛЫ ===
spawn(function()
    while true do
        task.wait(0.5)
        if _G.Farm then
            local t = Fields[_G.SelectedField]
            ts:Create(root, TweenInfo.new((root.Position-t).Magnitude/_G.Speed), {CFrame = CFrame.new(t)}):Play()
            task.wait((root.Position-t).Magnitude/_G.Speed)
            while _G.Farm and player.CoreStats.Pollen.Value < player.CoreStats.Capacity.Value do
                local tool = char:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
                if tool then tool.Parent = char; tool:Activate() end
                game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("CollectPollen")
                for _,v in pairs(game.Workspace.Collectibles:GetChildren()) do if (root.Position-v.Position).Magnitude < 55 then hum:MoveTo(v.Position) end end
                task.wait(0.4)
            end
            ts:Create(root, TweenInfo.new((root.Position-player.SpawnPos.Value.Position).Magnitude/_G.Speed), {CFrame = CFrame.new(player.SpawnPos.Value.Position)}):Play()
            task.wait((root.Position-player.SpawnPos.Value.Position).Magnitude/_G.Speed)
            repeat task.wait(1); game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking") until player.CoreStats.Pollen.Value == 0 or not _G.Farm
        end
    end
end)

spawn(function()
    while task.wait(0.2) do
        for _,v in pairs(game.Workspace.Monsters:GetChildren()) do
            for k,s in pairs(_G.Targets) do if s and v.Name:find(k) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then root.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,19,0) end end
        end
    end
end)

print("Ble1zX Hub v14.0 LOADED! Everything is back.")
