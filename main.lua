-- [[ Ble1zX Hub v15.2 - FIXED + FPS BOOST ]]
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local ts = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local lighting = game:GetService("Lighting")
local runService = game:GetService("RunService")

-- === НАСТРОЙКИ ===
_G.Farm = false
_G.AutoKill = false
_G.Speed = 85
_G.SelectedField = "Strawberry Field"
_G.SelectedBear = "Black Bear"
_G.FPSBoost = false
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

-- === FPS BOOST ===
local fpsActive = false
local function enableFPS()
    if fpsActive then return end
    fpsActive = true
    -- Белые текстуры как в атласе
    for _, v in pairs(workspace:GetDescendants()) do
        pcall(function()
            if v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
            end
            if v:IsA("Texture") or v:IsA("Decal") then
                v.Transparency = 1
            end
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
            if v:IsA("SpecialMesh") then
                v.TextureId = ""
            end
        end)
    end
    -- Освещение
    pcall(function()
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        lighting.Brightness = 2
        for _, v in pairs(lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect")
            or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect")
            or v:IsA("BloomEffect") then
                v.Enabled = false
            end
        end
    end)
end

local function disableFPS()
    fpsActive = false
    pcall(function()
        lighting.GlobalShadows = true
        lighting.FogEnd = 100000
        lighting.Brightness = 1
        for _, v in pairs(lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect")
            or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect")
            or v:IsA("BloomEffect") then
                v.Enabled = true
            end
        end
    end)
end

-- === TWEEN ХЕЛПЕР ===
local currentTween = nil
local function tweenTo(pos)
    if currentTween then
        pcall(function() currentTween:Cancel() end)
        currentTween = nil
    end
    local dist = (root.Position - pos).Magnitude
    if dist < 3 then return end
    local t = dist / _G.Speed
    local tw = ts:Create(root, TweenInfo.new(t, Enum.EasingStyle.Linear), {
        CFrame = CFrame.new(pos)
    })
    currentTween = tw
    tw:Play()
    local start = tick()
    while tw.PlaybackState ~= Enum.PlaybackState.Completed do
        if tick() - start > t + 2 then pcall(function() tw:Cancel() end) break end
        task.wait(0.05)
    end
    currentTween = nil
end

local function stopTween()
    if currentTween then
        pcall(function() currentTween:Cancel() end)
        currentTween = nil
    end
end

-- === НАЙТИ УЛЕЙ ===
local function findHive()
    for _, v in pairs(workspace:GetChildren()) do
        if tostring(v.Name):find(player.Name) and tostring(v.Name):lower():find("hive") then
            if v:IsA("Model") and v.PrimaryPart then
                return v.PrimaryPart.Position
            end
        end
    end
    local ok, pos = pcall(function() return player.SpawnPos.Value.Position end)
    if ok then return pos end
    return nil
end

-- === GUI ===
local oldGui = player.PlayerGui:FindFirstChild("BLE1ZX_GUI")
if oldGui then oldGui:Destroy() end

local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "BLE1ZX_GUI"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 200, 0, 195)
main.Position = UDim2.new(0, 20, 0, 20)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 80, 80)
stroke.Thickness = 1.5

-- Заголовок
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 34)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleFix = Instance.new("Frame", titleBar)
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
titleFix.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "BLE1ZX FARM"
titleLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local hideBtn = Instance.new("TextButton", titleBar)
hideBtn.Size = UDim2.new(0, 26, 0, 26)
hideBtn.Position = UDim2.new(1, -32, 0, 4)
hideBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
hideBtn.Text = "-"
hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.TextSize = 16
hideBtn.Font = Enum.Font.GothamBold
hideBtn.BorderSizePixel = 0
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 6)

-- Контент
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -34)
content.Position = UDim2.new(0, 0, 0, 34)
content.BackgroundTransparency = 1

local statusLabel = Instance.new("TextLabel", content)
statusLabel.Size = UDim2.new(1, -20, 0, 22)
statusLabel.Position = UDim2.new(0, 10, 0, 5)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Статус: Выключен"
statusLabel.TextColor3 = Color3.fromRGB(200, 80, 80)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local pollenLabel = Instance.new("TextLabel", content)
pollenLabel.Size = UDim2.new(1, -20, 0, 20)
pollenLabel.Position = UDim2.new(0, 10, 0, 28)
pollenLabel.BackgroundTransparency = 1
pollenLabel.Text = "Pollen: -"
pollenLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
pollenLabel.TextSize = 12
pollenLabel.Font = Enum.Font.Gotham
pollenLabel.TextXAlignment = Enum.TextXAlignment.Left

local startBtn = Instance.new("TextButton", content)
startBtn.Size = UDim2.new(1, -20, 0, 34)
startBtn.Position = UDim2.new(0, 10, 0, 54)
startBtn.BackgroundColor3 = Color3.fromRGB(50, 170, 70)
startBtn.Text = "ЗАПУСТИТЬ"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextSize = 14
startBtn.Font = Enum.Font.GothamBold
startBtn.BorderSizePixel = 0
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

local stopBtn = Instance.new("TextButton", content)
stopBtn.Size = UDim2.new(1, -20, 0, 34)
stopBtn.Position = UDim2.new(0, 10, 0, 94)
stopBtn.BackgroundColor3 = Color3.fromRGB(190, 45, 45)
stopBtn.Text = "СТОП -> УЛЕЙ"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.TextSize = 14
stopBtn.Font = Enum.Font.GothamBold
stopBtn.BorderSizePixel = 0
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)

local fpsBtn = Instance.new("TextButton", content)
fpsBtn.Size = UDim2.new(1, -20, 0, 34)
fpsBtn.Position = UDim2.new(0, 10, 0, 134)
fpsBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
fpsBtn.Text = "FPS BOOST: OFF"
fpsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsBtn.TextSize = 14
fpsBtn.Font = Enum.Font.GothamBold
fpsBtn.BorderSizePixel = 0
Instance.new("UICorner", fpsBtn).CornerRadius = UDim.new(0, 8)

-- === GUI ЛОГИКА ===
local hidden = false
hideBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    content.Visible = not hidden
    main.Size = hidden and UDim2.new(0, 200, 0, 34) or UDim2.new(0, 200, 0, 195)
    hideBtn.Text = hidden and "+" or "-"
end)

local function setStatus(text, color)
    statusLabel.Text = "Статус: " .. text
    statusLabel.TextColor3 = color
end

startBtn.MouseButton1Click:Connect(function()
    _G.Farm = true
    setStatus("Фармит", Color3.fromRGB(80, 220, 100))
end)

stopBtn.MouseButton1Click:Connect(function()
    _G.Farm = false
    stopTween()
    setStatus("Летит к улью...", Color3.fromRGB(255, 200, 50))
    spawn(function()
        local hivePos = findHive()
        if hivePos then
            tweenTo(hivePos + Vector3.new(0, 3, 0))
        end
        setStatus("Выключен", Color3.fromRGB(200, 80, 80))
    end)
end)

fpsBtn.MouseButton1Click:Connect(function()
    _G.FPSBoost = not _G.FPSBoost
    if _G.FPSBoost then
        enableFPS()
        fpsBtn.Text = "FPS BOOST: ON"
        fpsBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    else
        disableFPS()
        fpsBtn.Text = "FPS BOOST: OFF"
        fpsBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    end
end)

-- === ОБНОВЛЕНИЕ POLLEN ===
spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            local pollen = player.CoreStats.Pollen.Value
            local capacity = player.CoreStats.Capacity.Value
            pollenLabel.Text = string.format("Pollen: %d / %d", pollen, capacity)
        end)
    end
end)

-- === СПРИНКЛЕР (кнопка 1) ===
spawn(function()
    while true do
        task.wait(10)
        if _G.Farm then
            pcall(function()
                keypress(0x31)
                task.wait(0.1)
                keyrelease(0x31)
            end)
        end
    end
end)

-- === КОПАНИЕ ===
spawn(function()
    while true do
        task.wait(0.2)
        if _G.Farm then
            pcall(function()
                local tool = char:FindFirstChildOfClass("Tool")
                    or player.Backpack:FindFirstChildOfClass("Tool")
                if tool then
                    tool.Parent = char
                    tool:Activate()
                end
            end)
        end
    end
end)

-- === АВТО КИЛЛ ===
spawn(function()
    while task.wait(0.2) do
        if _G.AutoKill then
            pcall(function()
                for _, v in pairs(workspace.Monsters:GetChildren()) do
                    for k, s in pairs(_G.Targets) do
                        if s and v.Name:find(k) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            root.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 19, 0)
                        end
                    end
                end
            end)
        end
    end
end)

-- === КОНВЕРТАЦИЯ ===
local function convertHoney()
    local hivePos = findHive()
    if not hivePos then
        warn("[BSS] Улей не найден")
        return
    end

    setStatus("К улью...", Color3.fromRGB(255, 200, 50))
    tweenTo(hivePos + Vector3.new(0, 3, 0))
    if not _G.Farm then return end
    task.wait(1)

    local pollen = player.CoreStats.Pollen
    local before = pollen.Value

    pcall(function() RS.Events.PlayerHiveCommand:FireServer("ConvertHoney") end)
    task.wait(2)

    if pollen.Value >= before then
        pcall(function() root.CFrame = root.CFrame * CFrame.new(0, 0, 2) end)
        task.wait(0.5)
        pcall(function() RS.Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking") end)
    end

    local timeout = tick()
    while pollen.Value > 0 and _G.Farm and (tick() - timeout) < 30 do
        task.wait(1)
    end

    if _G.Farm then
        setStatus("Фармит", Color3.fromRGB(80, 220, 100))
    end
end

-- === MAIN LOOP ===
spawn(function()
    while true do
        task.wait(0.5)
        if not _G.Farm then continue end

        pcall(function()
            local fieldPos = Fields[_G.SelectedField] or Fields["Strawberry Field"]
            local pollen = player.CoreStats.Pollen
            local capacity = player.CoreStats.Capacity

            tweenTo(fieldPos)
            if not _G.Farm then return end

            while _G.Farm and pollen.Value < capacity.Value do
                pcall(function()
                    for _, v in pairs(workspace.Collectibles:GetChildren()) do
                        if (root.Position - v.Position).Magnitude < 55 then
                            tweenTo(v.Position)
                            if not _G.Farm then return end
                        end
                    end
                end)

                pcall(function()
                    local tool = char:FindFirstChildOfClass("Tool")
                        or player.Backpack:FindFirstChildOfClass("Tool")
                    if tool then tool.Parent = char; tool:Activate() end
                end)

                pcall(function()
                    RS.Events.PlayerHiveCommand:FireServer("CollectPollen")
                end)

                task.wait(0.4)
            end

            if _G.Farm and pollen.Value >= capacity.Value then
                convertHoney()
            end
        end)
    end
end)

print("Ble1zX Hub v15.2 LOADED")1
