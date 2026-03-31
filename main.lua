-- [[ Ble1zX Hub v13.0 - FINAL ULTIMATE EDITION ]]
-- Оптимизировано под JJSploit (Sidebar, Quests, Kill, Toys)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local ts = game:GetService("TweenService")
local vim = game:GetService("VirtualInputManager")

-- === ГЛОБАЛЬНЫЕ НАСТРОЙКИ ===
_G.Farm = false
_G.AutoQuest = false
_G.AutoKill = false
_G.Speed = 85
_G.SelectedField = "Strawberry Field"
_G.SelectedBear = "Black Bear"
_G.AntiAFK = true

_G.Targets = {
    ["Ladybug"]=false, ["Rhino"]=false, ["Spider"]=false, ["Werewolf"]=false,
    ["Mantis"]=false, ["Stump Snail"]=false, ["Coconut Crab"]=false, 
    ["King Beetle"]=false, ["Tunnel Bear"]=false, ["Vicious Bee"]=false
}

-- === ТАБЛИЦЫ КООРДИНАТ ===
local Fields = {
    ["Sunflower Field"] = Vector3.new(-210, 5, 185),
    ["Strawberry Field"] = Vector3.new(-175, 20, 15),
    ["Pineapple Patch"] = Vector3.new(260, 25, -150),
    ["Cactus Field"] = Vector3.new(-190, 68, -105),
    ["Coconut Field"] = Vector3.new(-255, 71, 460)
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
    ["Samovar"] = Vector3.new(-195, 22, -52)
}

-- === ГРАФИЧЕСКИЙ ИНТЕРФЕЙС (SIDEBAR) ===
local sg = Instance.new("ScreenGui", player.PlayerGui); sg.Name = "Ble1zX_v13"
local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 450, 0, 380); main.Position = UDim2.new(0.5, -225, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); main.Active = true; main.Draggable = true; Instance.new("UICorner", main)

-- Боковая панель
local sideBar = Instance.new("Frame", main); sideBar.Size = UDim2.new(0, 110, 1, 0); sideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", sideBar)

local container = Instance.new("Frame", main); container.Size = UDim2.new(0, 320, 0.9, 0); container.Position = UDim2.new(0.27, 0, 0.05, 0); container.BackgroundTransparency = 1

local function createP()
    local p = Instance.new("ScrollingFrame", container); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false
    p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0,0,2.5,0); return p
end

local farmP, killP, questP, toysP, miscP = createP(), createP(), createP(), createP(), createP()
farmP.Visible = true

-- Кнопки вкладок
local function sBtn(txt, y, p)
    local b = Instance.new("TextButton", sideBar); b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = UDim2.new(0.05, 0, 0, y)
    b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(45, 45, 45); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() 
        farmP.Visible=(p==1); killP.Visible=(p==2); questP.Visible=(p==3); toysP.Visible=(p==4); miscP.Visible=(p==5) 
    end)
end
sBtn("Farm", 40, 1); sBtn("Kill", 85, 2); sBtn("Quests", 130, 3); sBtn("Toys", 175, 4); sBtn("Misc", 220, 5)

-- Кнопки-переключатели (Toggles)
local function createToggle(p, name, y, func, isT)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.9, 0, 0, 32); b.Position = UDim2.new(0.05, 0, 0, y)
    b.Text = name .. ": OFF"; b.BackgroundColor3 = Color3.fromRGB(150,0,0); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        local state = func()
        b.Text = name .. (state and ": ON" or ": OFF")
        b.BackgroundColor3 = state and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
    end)
    return b
end

-- === НАПОЛНЕНИЕ FARM ===
createToggle(farmP, "Auto Farm", 10, function() _G.Farm = not _G.Farm return _G.Farm end)
for name, pos in pairs(Fields) do
    local b = Instance.new("TextButton", farmP); b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = UDim2.new(0.05, 0, 0, 50 + (table.find({1},1)*40)) -- упрощено для списка
    b.Text = name; b.MouseButton1Click:Connect(function() _G.SelectedField = name end); Instance.new("UICorner", b)
end

-- === НАПОЛНЕНИЕ KILL (ГРУППЫ) ===
local mFrame = Instance.new("Frame", killP); mFrame.Size = UDim2.new(1,0,0,150); mFrame.Position = UDim2.new(0,0,0,40); mFrame.BackgroundTransparency = 1
createToggle(mFrame, "Ladybug", 0, function() _G.Targets["Ladybug"] = not _G.Targets["Ladybug"] return _G.Targets["Ladybug"] end)
createToggle(mFrame, "Spider", 35, function() _G.Targets["Spider"] = not _G.Targets["Spider"] return _G.Targets["Spider"] end)

-- === ЛОГИКА ДИАЛОГОВ (КВЕСТЫ) ===
local function interactWithNPC(pos)
    ts:Create(root, TweenInfo.new((root.Position-pos).Magnitude/_G.Speed), {CFrame = CFrame.new(pos)}):Play()
    task.wait((root.Position-pos).Magnitude/_G.Speed + 0.5)
    local start = tick()
    while tick() - start < 6 do
        vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.2)
        vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        task.wait(0.3)
    end
end

createToggle(questP, "Auto Quest", 10, function() 
    _G.AutoQuest = not _G.AutoQuest 
    if _G.AutoQuest then interactWithNPC(Bears[_G.SelectedBear]) _G.AutoQuest = false end
    return _G.AutoQuest 
end)

-- === ЛОГИКА TOYS (Looting) ===
local function useToy(name)
    local pos = ToysPos[name]
    ts:Create(root, TweenInfo.new((root.Position-pos).Magnitude/_G.Speed), {CFrame = CFrame.new(pos)}):Play()
    task.wait((root.Position-pos).Magnitude/_G.Speed + 0.5)
    vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(1)
    for i = 1, 15 do
        for _, v in pairs(game.Workspace.Collectibles:GetChildren()) do
            if (root.Position - v.Position).Magnitude < 50 then hum:MoveTo(v.Position) end
        end
        task.wait(0.4)
    end
end
Instance.new("TextButton", toysP).MouseButton1Click:Connect(function() useToy("Stocking") end)

-- === ОСНОВНЫЕ ЦИКЛЫ (Farm & Kill) ===
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
                task.wait(0.5)
            end
            local h = player.SpawnPos.Value.Position
            ts:Create(root, TweenInfo.new((root.Position-h).Magnitude/_G.Speed), {CFrame = CFrame.new(h)}):Play()
            task.wait((root.Position-h).Magnitude/_G.Speed); repeat task.wait(1); game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking") until player.CoreStats.Pollen.Value == 0 or not _G.Farm
        end
    end
end)

spawn(function()
    while task.wait(0.2) do
        for _, v in pairs(game.Workspace.Monsters:GetChildren()) do
            for k, s in pairs(_G.Targets) do 
                if s and v.Name:find(k) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then root.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 19, 0) end 
            end
        end
    end
end)

print("Ble1zX Hub v13.0 LOADED! Use Sidebar to navigate.")
