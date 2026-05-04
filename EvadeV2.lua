-- โหลด WindUI
local WindUI = loadstring(game:HttpGet(
"https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

-- สร้างหน้าต่าง
local Window = WindUI:CreateWindow({
Title = "KOMAT UNITY HUB",
Icon = "rbxassetid://7733658504",
Author = "By Koman",
Folder = "KomanHub",
Size = UDim2.fromOffset(420, 320),
Transparent = true,
Theme = "Dark",
SideBarWidth = 180,
})

local SettingsTab = Window:Tab({
    Title = "ตั้งค่า",
    Icon = "settings"
})

-- =========================
-- หมวดเดียว
-- =========================
local MainMenu = Window:Tab({
Title = "เมนูหลัก",
Icon = "home"
})


local EmoteTab = Window:Tab({
    Title = "อีโมท",
    Icon = "smile"
})

-- =========================
-- หมวด อื่นๆ
-- =========================
local ExtraTab = Window:Tab({
    Title = "อื่นๆ",
    Icon = "box"
})

-- =========================
-- FARM TAB
-- =========================
local FarmTab = Window:Tab({
    Title = "ฟาร์ม",
    Icon = "coins"
})

-- =========================
-- VIEW TAB (มองต่างๆ)
-- =========================
local ViewTab = Window:Tab({
    Title = "มองต่างๆ",
    Icon = "eye"
})
 
-- =========================
-- EVENT TAB (WINDUI)
-- =========================
local EventTab = Window:Tab({
    Title = "อีเว้น",
    Icon = "zap"
})

-- =========================
-- SERVICES
-- =========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- =========================
-- AUTO JUMP (BUNNY HOP PRO)
-- =========================
local autoJump = false
local autoJumpConnection = nil

local function startAutoJump()
if autoJumpConnection then return end

autoJumpConnection = RunService.Heartbeat:Connect(function()  
    if not autoJump then return end  

    local char = player.Character  
    if not char then return end  

    local hum = char:FindFirstChild("Humanoid")  
    local hrp = char:FindFirstChild("HumanoidRootPart")  
    if not hum or not hrp then return end  

    -- Raycast ลงพื้น  
    local rayOrigin = hrp.Position  
    local rayDirection = Vector3.new(0, -6, 0)  

    local rayParams = RaycastParams.new()  
    rayParams.FilterDescendantsInstances = {char}  
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist  

    local result = workspace:Raycast(rayOrigin, rayDirection, rayParams)  

    if result then  
        local distance = (rayOrigin - result.Position).Magnitude  

        -- ใกล้พื้นแล้วเด้งทันที (ไม่แตะพื้น)  
        if distance <= 4 then  
            hum:ChangeState(Enum.HumanoidStateType.Jumping)  
        end  
    end  
end)

end

local function stopAutoJump()
if autoJumpConnection then
autoJumpConnection:Disconnect()
autoJumpConnection = nil
end
end

-- =========================
-- FLOATING GUI
-- =========================
local FloatingGui = Instance.new("ScreenGui")
FloatingGui.Name = "FloatingBounceGui"
FloatingGui.Parent = game.CoreGui

local floatingBounceButton = nil

function createBounceFloatingButton()
if floatingBounceButton then return end

local btn = Instance.new("TextButton")  
floatingBounceButton = btn  

btn.Size = UDim2.new(0,140,0,52)  
btn.Position = UDim2.new(0.5,-70,0.85,0)  
btn.AnchorPoint = Vector2.new(0.5,0)  
btn.BackgroundColor3 = Color3.fromRGB(180,220,255)  
btn.BackgroundTransparency = 0.35  
btn.TextColor3 = Color3.fromRGB(0,70,150)  
btn.Text = autoJump and "Auto Bounce: ON" or "Auto Bounce: OFF"  
btn.Font = Enum.Font.GothamBold  
btn.TextSize = 14  
btn.Parent = FloatingGui  
btn.Active = true  
btn.Draggable = true  

local corner = Instance.new("UICorner", btn)  
corner.CornerRadius = UDim.new(0,18)  

local stroke = Instance.new("UIStroke", btn)  
stroke.Thickness = 2.5  
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border  
stroke.Color = Color3.fromRGB(0,120,255)  

-- animation สี  
task.spawn(function()  
    while btn.Parent do  
        TweenService:Create(stroke, TweenInfo.new(0.8), {  
            Color = Color3.fromRGB(0,80,255)  
        }):Play()  
        task.wait(0.8)  

        TweenService:Create(stroke, TweenInfo.new(0.8), {  
            Color = Color3.fromRGB(160,230,255)  
        }):Play()  
        task.wait(0.8)  
    end  
end)  

btn.MouseButton1Click:Connect(function()  
    autoJump = not autoJump  

    if autoJump then  
        startAutoJump()  
    else  
        stopAutoJump()  
    end  

    btn.Text = autoJump and "Auto Bounce: ON" or "Auto Bounce: OFF"  
end)

end

function removeBounceFloatingButton()
if floatingBounceButton then
floatingBounceButton:Destroy()
floatingBounceButton = nil
end
end

-- =========================
-- TOGGLES
-- =========================
MainMenu:Toggle({
Title = "ออโต้กระโดด",
Desc = "Auto Jump",
Default = false,
Callback = function(state)
autoJump = state
if state then
startAutoJump()
else
stopAutoJump()
end
end
})

MainMenu:Toggle({
Title = "ออโต้กระโดด(ปุ่มลอย)",
Desc = "Auto Jump(Fb)",
Default = false,
Callback = function(state)
if state then
createBounceFloatingButton()
else
removeBounceFloatingButton()
end
end
})

-- =========================
-- INFINITY SLIDE SYSTEM (PRO)
-- =========================
local infiniteSlideEnabled = false
local cachedTables = nil
local plrModel = nil
local slideConnection = nil
local floatingSlideButton = nil

local slideFrictionValue = -8

-- =========================
-- CONFIG
-- =========================
local keys = {
"Friction","AirStrafeAcceleration","JumpHeight","RunDeaccel",
"JumpSpeedMultiplier","JumpCap","SprintCap","WalkSpeedMultiplier",
"BhopEnabled","Speed","AirAcceleration","RunAccel","SprintAcceleration"
}

local function hasAll(tbl)
if type(tbl) ~= "table" then return false end
for _, k in ipairs(keys) do
if rawget(tbl, k) == nil then return false end
end
return true
end

local function setFriction(value)
if not cachedTables then return end
for _, t in ipairs(cachedTables) do
pcall(function()
t.Friction = value
end)
end
end

local function updatePlayerModel()
local GameFolder = workspace:FindFirstChild("Game")
local PlayersFolder = GameFolder and GameFolder:FindFirstChild("Players")
if PlayersFolder then
plrModel = PlayersFolder:FindFirstChild(player.Name)
else
plrModel = nil
end
end

local function onHeartbeat()
if not plrModel then
setFriction(5)
return
end

local success, currentState = pcall(function()  
    return plrModel:GetAttribute("State")  
end)  

if success and currentState then  
    if currentState == "Slide" then  
        pcall(function()  
            plrModel:SetAttribute("State", "EmotingSlide")  
        end)  
    elseif currentState == "EmotingSlide" then  
        setFriction(slideFrictionValue)  
    else  
        setFriction(5)  
    end  
else  
    setFriction(5)  
end

end

-- =========================
-- CORE TOGGLE (เหมือน Auto Jump)
-- =========================
local function setInfiniteSlide(state)
infiniteSlideEnabled = state

if slideConnection then  
    slideConnection:Disconnect()  
    slideConnection = nil  
end  

if state then  
    cachedTables = {}  

    for _, obj in ipairs(getgc(true)) do  
        local success, result = pcall(function()  
            if hasAll(obj) then return obj end  
        end)  
        if success and result then  
            table.insert(cachedTables, result)  
        end  
    end  

    updatePlayerModel()  

    slideConnection = RunService.Heartbeat:Connect(onHeartbeat)  

    player.CharacterAdded:Connect(function()  
        task.wait(0.1)  
        updatePlayerModel()  
    end)  

else  
    cachedTables = nil  
    plrModel = nil  
    setFriction(5)  
end  

-- sync ปุ่มลอย  
if floatingSlideButton then  
    floatingSlideButton.BackgroundColor3 =  
        state and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)  

    floatingSlideButton.Text =  
        state and "Infinite Slide: ON" or "Infinite Slide: OFF"  
end

end

-- =========================
-- FLOATING BUTTON (เหมือน Auto Jump)
-- =========================
local function createSlideButton()
if floatingSlideButton then return end

local btn = Instance.new("TextButton")  
floatingSlideButton = btn  

btn.Size = UDim2.new(0,140,0,52)  
btn.Position = UDim2.new(0.5,-70,0.85,0)  
btn.AnchorPoint = Vector2.new(0.5,0)  
btn.BackgroundColor3 = Color3.fromRGB(180,220,255)  
btn.BackgroundTransparency = 0.35  
btn.TextColor3 = Color3.fromRGB(0,70,150)  
btn.Text = infiniteSlideEnabled and "Infinite Slide: ON" or "Infinite Slide: OFF"  
btn.Font = Enum.Font.GothamBold  
btn.TextSize = 14  
btn.Parent = FloatingGui  
btn.Active = true  
btn.Draggable = true  

-- มุมโค้ง  
local corner = Instance.new("UICorner", btn)  
corner.CornerRadius = UDim.new(0,18)  

-- ขอบ  
local stroke = Instance.new("UIStroke", btn)  
stroke.Thickness = 2.5  
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border  
stroke.Color = Color3.fromRGB(0,120,255)  

-- Animation สี (เหมือน Auto Jump)  
task.spawn(function()  
    while btn.Parent do  
        TweenService:Create(  
            stroke,  
            TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),  
            {Color = Color3.fromRGB(0,80,255)}  
        ):Play()  
        task.wait(0.8)  

        TweenService:Create(  
            stroke,  
            TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),  
            {Color = Color3.fromRGB(160,230,255)}  
        ):Play()  
        task.wait(0.8)  
    end  
end)  

-- กดปุ่ม  
btn.MouseButton1Click:Connect(function()  
    setInfiniteSlide(not infiniteSlideEnabled)  
end)

end

local function removeSlideButton()
if floatingSlideButton then
floatingSlideButton:Destroy()
floatingSlideButton = nil
end
end

-- =========================
-- WINDUI TOGGLES (เหมือน Auto Jump เป๊ะ)
-- =========================
MainMenu:Toggle({
Title = "อินฟินิต สไลด์",
Desc = "Infinity Slide",
Default = false,
Callback = function(state)
setInfiniteSlide(state)
end
})

MainMenu:Toggle({
Title = "อินฟินิต สไลด์(ปุ่มลอย)",
Desc = "Infinity Slide(Fb)",
Default = false,
Callback = function(state)
if state then
createSlideButton()
else
removeSlideButton()
setInfiniteSlide(false)
end
end
})

-- =========================
-- AUTO TRIP SYSTEM (PRO)
-- =========================
local autoTrip = false
local autoTripConnection = nil

local bounceHeight = 100
local bounceDistance = 6

local floatingTripButton = nil

-- =========================
-- RAYCAST หลายจุด
-- =========================
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Blacklist

local function isNearGround(hrp, char)
rayParams.FilterDescendantsInstances = {char}

local offsets = {  
    Vector3.new(0, -bounceDistance, 0),  
    Vector3.new(2, -bounceDistance, 0),  
    Vector3.new(-2, -bounceDistance, 0),  
    Vector3.new(0, -bounceDistance, 2),  
    Vector3.new(0, -bounceDistance, -2)  
}  

for _, offset in pairs(offsets) do  
    local result = workspace:Raycast(hrp.Position, offset, rayParams)  
    if result and result.Instance and result.Instance.CanCollide then  
        return true  
    end  
end  

return false

end

-- =========================
-- CORE
-- =========================
local function startAutoTrip()
if autoTripConnection then return end

autoTripConnection = RunService.Heartbeat:Connect(function()  
    if not autoTrip then return end  

    local char = player.Character  
    if not char then return end  

    local hrp = char:FindFirstChild("HumanoidRootPart")  
    if not hrp then return end  

    local vel = hrp.Velocity  

    -- ต้อง "ตกแรง" + ใกล้พื้น  
    if vel.Y < -35 and isNearGround(hrp, char) then  
        hrp.Velocity = Vector3.new(vel.X, bounceHeight, vel.Z)  
    end  
end)

end

local function stopAutoTrip()
if autoTripConnection then
autoTripConnection:Disconnect()
autoTripConnection = nil
end
end

-- =========================
-- FLOATING BUTTON
-- =========================
local function createTripButton()
if floatingTripButton then return end

local btn = Instance.new("TextButton")  
floatingTripButton = btn  

btn.Size = UDim2.new(0,140,0,52)  
btn.Position = UDim2.new(0.5,-70,0.75,0)  
btn.AnchorPoint = Vector2.new(0.5,0)  
btn.BackgroundColor3 = Color3.fromRGB(180,220,255)  
btn.BackgroundTransparency = 0.35  
btn.TextColor3 = Color3.fromRGB(0,70,150)  
btn.Text = autoTrip and "Auto Trip: ON" or "Auto Trip: OFF"  
btn.Font = Enum.Font.GothamBold  
btn.TextSize = 14  
btn.Parent = FloatingGui  
btn.Active = true  
btn.Draggable = true  

local corner = Instance.new("UICorner", btn)  
corner.CornerRadius = UDim.new(0,18)  

local stroke = Instance.new("UIStroke", btn)  
stroke.Thickness = 2.5  
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border  
stroke.Color = Color3.fromRGB(0,120,255)  

task.spawn(function()  
    while btn.Parent do  
        TweenService:Create(stroke, TweenInfo.new(0.8), {  
            Color = Color3.fromRGB(0,80,255)  
        }):Play()  
        task.wait(0.8)  

        TweenService:Create(stroke, TweenInfo.new(0.8), {  
            Color = Color3.fromRGB(160,230,255)  
        }):Play()  
        task.wait(0.8)  
    end  
end)  

btn.MouseButton1Click:Connect(function()  
    autoTrip = not autoTrip  

    if autoTrip then  
        startAutoTrip()  
    else  
        stopAutoTrip()  
    end  

    btn.Text = autoTrip and "Auto Trip: ON" or "Auto Trip: OFF"  
end)

end

local function removeTripButton()
if floatingTripButton then
floatingTripButton:Destroy()
floatingTripButton = nil
end
end

-- =========================
-- WINDUI
-- =========================
MainMenu:Toggle({
Title = "ออโต้ทริป",
Desc = "Auto Trip",
Default = false,
Callback = function(state)
autoTrip = state
if state then
startAutoTrip()
else
stopAutoTrip()
end
end
})

MainMenu:Toggle({
Title = "ออโต้ทริป(ปุ่มลอย)",
Desc = "Auto Trip(Fb)",
Default = false,
Callback = function(state)
if state then
createTripButton()
else
removeTripButton()
autoTrip = false
stopAutoTrip()
end
end
})

-- =========================
-- SLIDER
-- =========================
MainMenu:Slider({
Title = "ความสูงเด้ง",
Desc = "Bounce Height",
Value = {
Min = 50,
Max = 200,
Default = 100
},
Callback = function(val)
bounceHeight = val
end
})

-- =========================
-- LAG SWITCH SYSTEM
-- =========================
local floatingLagButton = nil

local function lagSwitch(duration)
local start = tick()
while tick() - start < duration do
for i = 1, 200000 do -- ปรับให้คุม 0.5 วิได้จริง
local _ = math.random()
end
end
end

-- =========================
-- ปุ่มปกติ (WindUI)
-- =========================
MainMenu:Button({
Title = "แลคสวิตซ์",
Desc = "Lag 0.5s",
Callback = function()
lagSwitch(0.5)
end
})

-- =========================
-- ปุ่มลอย (สไตล์เดียวกับมึง)
-- =========================
local function createLagFloatingButton()
if floatingLagButton then return end

local btn = Instance.new("TextButton")  
floatingLagButton = btn  

btn.Size = UDim2.new(0,140,0,52)  
btn.Position = UDim2.new(0.5,-70,0.65,0)  
btn.AnchorPoint = Vector2.new(0.5,0)  
btn.BackgroundColor3 = Color3.fromRGB(180,220,255)  
btn.BackgroundTransparency = 0.35  
btn.TextColor3 = Color3.fromRGB(0,70,150)  
btn.Text = "Lag Switch"  
btn.Font = Enum.Font.GothamBold  
btn.TextSize = 14  
btn.Parent = FloatingGui  
btn.Active = true  
btn.Draggable = true  

-- มุมโค้ง  
local corner = Instance.new("UICorner", btn)  
corner.CornerRadius = UDim.new(0,18)  

-- ขอบ  
local stroke = Instance.new("UIStroke", btn)  
stroke.Thickness = 2.5  
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border  
stroke.Color = Color3.fromRGB(0,120,255)  

-- animation สี  
task.spawn(function()  
    while btn.Parent do  
        TweenService:Create(  
            stroke,  
            TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),  
            {Color = Color3.fromRGB(0,80,255)}  
        ):Play()  
        task.wait(0.8)  

        TweenService:Create(  
            stroke,  
            TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),  
            {Color = Color3.fromRGB(160,230,255)}  
        ):Play()  
        task.wait(0.8)  
    end  
end)  

-- กดปุ่ม  
btn.MouseButton1Click:Connect(function()  
    lagSwitch(0.5)  
end)

end

local function removeLagFloatingButton()
if floatingLagButton then
floatingLagButton:Destroy()
floatingLagButton = nil
end
end

-- =========================
-- Toggle ปุ่มลอย
-- =========================
MainMenu:Toggle({
Title = "แลคสวิตซ์(ปุ่มลอย)",
Desc = "Lag Switch(Fb)",
Default = false,
Callback = function(state)
if state then
createLagFloatingButton()
else
removeLagFloatingButton()
end
end
})


-- =========================
-- AUTO CARRY SYSTEM
-- =========================
local autoCarry = false
local autoCarryConnection = nil
local floatingCarryButton = nil

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function startAutoCarry()
    if autoCarryConnection then return end

    autoCarryConnection = RunService.Heartbeat:Connect(function()
        if not autoCarry then return end

        local char = player.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local otherHRP = plr.Character.HumanoidRootPart
                local dist = (hrp.Position - otherHRP.Position).Magnitude

                if dist <= 20 then
                    pcall(function()
                        ReplicatedStorage:WaitForChild("Events")
                            :WaitForChild("Character")
                            :WaitForChild("Interact")
                            :FireServer("Carry", nil, plr.Name)
                    end)
                    task.wait(0.05)
                end
            end
        end
    end)
end

local function stopAutoCarry()
    if autoCarryConnection then
        autoCarryConnection:Disconnect()
        autoCarryConnection = nil
    end
end

MainMenu:Toggle({
    Title = "ออโต้อุ้ม",
    Desc = "Auto Carry",
    Default = false,
    Callback = function(state)
        autoCarry = state
        if state then
            startAutoCarry()
        else
            stopAutoCarry()
        end
    end
})

-- =========================
-- FLOATING AUTO CARRY (FIX)
-- =========================
local floatingCarryButton = nil

local function createCarryButton()
    -- ลบของเก่าทิ้งก่อนเสมอ (กันซ้อน)
    if floatingCarryButton then
        floatingCarryButton:Destroy()
        floatingCarryButton = nil
    end

    local btn = Instance.new("TextButton")
    floatingCarryButton = btn

    btn.Size = UDim2.new(0,140,0,52)
    btn.Position = UDim2.new(0.5,-70,0.55,0)
    btn.AnchorPoint = Vector2.new(0.5,0)
    btn.BackgroundColor3 = Color3.fromRGB(180,220,255)
    btn.BackgroundTransparency = 0.35
    btn.TextColor3 = Color3.fromRGB(0,70,150)
    btn.Text = autoCarry and "Auto Carry: ON" or "Auto Carry: OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = FloatingGui
    btn.Active = true
    btn.Draggable = true

    -- มุมโค้ง
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,18)

    -- ขอบ
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 2.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(0,120,255)

    -- animation สี
    task.spawn(function()
        while btn.Parent do
            TweenService:Create(
                stroke,
                TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Color = Color3.fromRGB(0,80,255)}
            ):Play()
            task.wait(0.8)

            TweenService:Create(
                stroke,
                TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Color = Color3.fromRGB(160,230,255)}
            ):Play()
            task.wait(0.8)
        end
    end)

    -- กดปุ่ม toggle
    btn.MouseButton1Click:Connect(function()
        autoCarry = not autoCarry

        if autoCarry then
            startAutoCarry()
        else
            stopAutoCarry()
        end

        btn.Text = autoCarry and "Auto Carry: ON" or "Auto Carry: OFF"
    end)
end

local function removeCarryButton()
    if floatingCarryButton then
        floatingCarryButton:Destroy()
        floatingCarryButton = nil
    end
end

MainMenu:Toggle({
    Title = "ออโต้อุ้ม(ปุ่มลอย)",
    Desc = "Auto Carry(Fb)",
    Default = false,
    Callback = function(state)
        if state then
            createCarryButton()
        else
            removeCarryButton()
            autoCarry = false
            stopAutoCarry()
        end
    end
})


-- =========================
-- Services
-- =========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- =========================
-- Settings
-- =========================
local currentSettings = {
    Speed = 1500,
    JumpCap = 1,
    AirStrafeAcceleration = 187
}

getgenv().ApplyMode = "Not Optimized"
getgenv().AutoApplySettings = true

-- =========================
-- Clamp กันพัง
-- =========================
local MAX_VALUE = 30000

local function safe(val)
    val = tonumber(val) or 0
    if val > MAX_VALUE then return MAX_VALUE end
    if val < 0 then return 0 end
    return val
end

-- =========================
-- หา table เป้าหมาย (เหมือนเดิมแต่ stable)
-- =========================
local requiredFields = {
    Friction=true, AirStrafeAcceleration=true, JumpHeight=true, RunDeaccel=true,
    JumpSpeedMultiplier=true, JumpCap=true, SprintCap=true, WalkSpeedMultiplier=true,
    BhopEnabled=true, Speed=true, AirAcceleration=true, RunAccel=true, SprintAcceleration=true
}

local cachedTables
local lastScan = 0
local SCAN_COOLDOWN = 5

local function getMatchingTables()
    local now = tick()

    if cachedTables and (now - lastScan < SCAN_COOLDOWN) then
        return cachedTables
    end

    local result = {}

    for _, obj in ipairs(getgc(true)) do
        if typeof(obj) == "table" then
            local ok = true

            for field in pairs(requiredFields) do
                if rawget(obj, field) == nil then
                    ok = false
                    break
                end
            end

            if ok then
                table.insert(result, obj)
            end
        end
    end

    cachedTables = result
    lastScan = now

    return result
end

-- =========================
-- Apply
-- =========================
local function applyToTables()
    local mode = getgenv().ApplyMode
    local tables = getMatchingTables()

    for _, tbl in ipairs(tables) do
        if typeof(tbl) == "table" then
            pcall(function()

                if mode == "Not Optimized" then
                    tbl.Speed = currentSettings.Speed
                    tbl.JumpCap = currentSettings.JumpCap
                    tbl.AirStrafeAcceleration = currentSettings.AirStrafeAcceleration
                else
                    if tbl.Speed ~= currentSettings.Speed then
                        tbl.Speed = currentSettings.Speed
                    end
                    if tbl.JumpCap ~= currentSettings.JumpCap then
                        tbl.JumpCap = currentSettings.JumpCap
                    end
                    if tbl.AirStrafeAcceleration ~= currentSettings.AirStrafeAcceleration then
                        tbl.AirStrafeAcceleration = currentSettings.AirStrafeAcceleration
                    end
                end

            end)
        end
    end
end

-- auto refresh กันค่าหลุด
RunService.Heartbeat:Connect(function()
    if getgenv().AutoApplySettings then
        applyToTables()
    end
end)

-- =========================
-- WINDUI SETTINGS TAB
-- =========================

SettingsTab:Slider({
    Title = "Speed",
    Value = {
        Min = 1450,
        Max = 30000,
        Default = currentSettings.Speed
    },
    Callback = function(val)
        currentSettings.Speed = safe(val)
        applyToTables()
    end
})

SettingsTab:Slider({
    Title = "Jump Cap",
    Value = {
        Min = 0.1,
        Max = 30000,
        Default = currentSettings.JumpCap
    },
    Callback = function(val)
        currentSettings.JumpCap = safe(val)
        applyToTables()
    end
})

SettingsTab:Slider({
    Title = "Strafe Acceleration",
    Value = {
        Min = 200,
        Max = 30000,
        Default = currentSettings.AirStrafeAcceleration
    },
    Callback = function(val)
        currentSettings.AirStrafeAcceleration = safe(val)
        applyToTables()
    end
})

-- =========================
-- Apply Mode dropdown
-- =========================
SettingsTab:Dropdown({
    Title = "Apply Method",
    Values = {"Not Optimized", "Optimized"},
    Default = "Not Optimized",
    Callback = function(option)
        getgenv().ApplyMode = option
        cachedTables = nil
        applyToTables()
    end
})

-- =========================
-- Respawn fix
-- =========================
player.CharacterAdded:Connect(function()
    task.wait(1)
    cachedTables = nil
    applyToTables()
end)


-- =========================
-- FAKE REVIVE SYSTEM (FIXED)
-- =========================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

getgenv().AutoRespawnEnabled = false
local autoRespawnMethod = "Fake Revive"

local lastSavedPosition = nil
local running = false

-- =========================
-- SAVE POSITION LOOP
-- =========================
local function trackPosition(char)
    task.spawn(function()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)

        while char and char.Parent do
            if hrp then
                lastSavedPosition = hrp.Position
            end
            task.wait(0.25)
        end
    end)
end

-- =========================
-- FAKE REVIVE CORE
-- =========================
local function fakeRevive()
    if running then return end
    running = true

    task.spawn(function()
        while getgenv().AutoRespawnEnabled do
            local char = player.Character
            if not char then
                task.wait(1)
                continue
            end

            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")

            -- 🔥 ตรวจแบบ universal แทน Downed (กันพัง)
            local isDead = hum and hum.Health <= 0

            if isDead then
                task.wait(2)

                -- 🔁 พยายาม revive ผ่าน remote (ถ้ามี)
                pcall(function()
                    local ev = ReplicatedStorage:FindFirstChild("Events")
                    if ev then
                        local playerFolder = ev:FindFirstChild("Player")
                        local change = playerFolder and playerFolder:FindFirstChild("ChangePlayerMode")
                        if change then
                            change:FireServer(true)
                        end
                    end
                end)

                -- ⏳ รอ character ใหม่
                local newChar
                repeat
                    newChar = player.Character
                    task.wait()
                until newChar and newChar:FindFirstChild("HumanoidRootPart")

                -- 📍 คืนตำแหน่ง
                if lastSavedPosition then
                    newChar.HumanoidRootPart.CFrame = CFrame.new(lastSavedPosition + Vector3.new(0,3,0))
                end
            end

            task.wait(1)
        end

        running = false
    end)
end

-- =========================
-- INIT CHARACTER
-- =========================
if player.Character then
    trackPosition(player.Character)
end

player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    trackPosition(char)
end)

MainMenu:Toggle({
    Title = "ออโต้รีสปอน",
    Desc = "Fake Revive System (save position + revive attempt)",
    Default = false,
    Callback = function(state)
        getgenv().AutoRespawnEnabled = state

        if state then
            fakeRevive()
        end
    end
})

MainMenu:Dropdown({
    Title = "โหมดรีสปอน",
    Desc = "Respawn method",
    Options = {"Fake Revive", "Random"},
    Default = "Fake Revive",
    Callback = function(opt)
        autoRespawnMethod = opt
    end
})

-- =========================
-- SPIN SYSTEM
-- =========================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local spinEnabled = false
local spinConnection = nil

local function stopSpin()
    spinEnabled = false

    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end

    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
        end
    end
end

local function startSpin()
    if spinConnection then return end

    spinConnection = RunService.Heartbeat:Connect(function()
        if not spinEnabled then return end

        local char = player.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- 🌀 หมุนแกน Y ความเร็ว 100
        hrp.AssemblyAngularVelocity = Vector3.new(0, 100, 0)
    end)
end

MainMenu:Toggle({
    Title = "หมุนตัว (Spin)",
    Desc = "Spin character with angular velocity 100",
    Default = false,
    Callback = function(state)
        spinEnabled = state

        if state then
            startSpin()
        else
            stopSpin()
        end
    end
})

-- =========================
-- WARP BOT SMART ESCAPE
-- =========================

local warpBotActive = false
local warpBotConnection = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- เก็บตำแหน่งเดิม
local savedCFrame = nil
local isEscaping = false

local function startWarpBot()
	if warpBotConnection then return end

	warpBotConnection = RunService.Heartbeat:Connect(function()
		if not warpBotActive then return end

		local char = player.Character
		if not char then return end

		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local folder = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
		if not folder then return end

		-- 🔍 หา bot ใกล้ตัว
		local nearBot = false

		for _, npc in ipairs(folder:GetChildren()) do
			if npc:GetAttribute("Team") == "Nextbot" then
				local npcPart = npc:FindFirstChild("Root") or npc:FindFirstChild("HumanoidRootPart")
				if npcPart and (npcPart.Position - root.Position).Magnitude <= 10 then
					nearBot = true
					break
				end
			end
		end

		-- =========================
		-- 🚨 เจอบอท → หนีขึ้นฟ้า
		-- =========================
		if nearBot and not isEscaping then
			savedCFrame = root.CFrame
			isEscaping = true

			root.CFrame = root.CFrame + Vector3.new(0, 120, 0) -- ขึ้นฟ้า
		end

		-- =========================
		-- 🛑 ตอนอยู่บนฟ้า → ล็อคตำแหน่ง
		-- =========================
		if isEscaping then
			root.AssemblyLinearVelocity = Vector3.new(0,0,0)

			-- 🔍 เช็คข้างล่างว่ายังมี bot ไหม
			local stillDanger = false

			for _, npc in ipairs(folder:GetChildren()) do
				if npc:GetAttribute("Team") == "Nextbot" then
					local npcPart = npc:FindFirstChild("Root") or npc:FindFirstChild("HumanoidRootPart")
					if npcPart and savedCFrame then
						if (npcPart.Position - savedCFrame.Position).Magnitude <= 12 then
							stillDanger = true
							break
						end
					end
				end
			end

			-- =========================
			-- ✅ ปลอดภัยแล้ว → กลับที่เดิม
			-- =========================
			if not stillDanger and savedCFrame then
				root.CFrame = savedCFrame
				isEscaping = false
				savedCFrame = nil
			end
		end

	end)
end

local function stopWarpBot()
	if warpBotConnection then
		warpBotConnection:Disconnect()
		warpBotConnection = nil
	end

	isEscaping = false
	savedCFrame = nil
end

MainMenu:Toggle({
	Title = "วาร์ปหนีบอท",
	Desc = "Auto escape above when Nextbot is near",
	Default = false,
	Callback = function(state)
		warpBotActive = state

		if state then
			startWarpBot()
		else
			stopWarpBot()
		end
	end
})

-- =========================
-- SERVICES
-- =========================
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage:WaitForChild("Events", 10)
local CharacterFolder = Events and Events:WaitForChild("Character", 10)
local EmoteRemote = CharacterFolder and CharacterFolder:WaitForChild("Emote", 10)
local PassCharacterInfo = CharacterFolder and CharacterFolder:WaitForChild("PassCharacterInfo", 10)
local remoteSignal = PassCharacterInfo and PassCharacterInfo.OnClientEvent

-- =========================
-- VARIABLES
-- =========================
local currentEmote = ""
local selectEmote = ""
local emoteEnabled = false
local pendingSlot = nil
local currentTag = nil
local blockOriginalEmote = false

-- =========================
-- READ TAG
-- =========================
local function readTagFromFolder(f)
    if not f then return nil end
    local a = f:GetAttribute("Tag")
    if a ~= nil then return a end
    local o = f:FindFirstChild("Tag")
    if o and o:IsA("ValueBase") then return o.Value end
    return nil
end

local function onRespawn()
    currentTag = nil
    pendingSlot = nil

    task.spawn(function()
        local startTime = tick()
        while tick() - startTime < 10 do
            if workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players") then
                local pf = workspace.Game.Players:FindFirstChild(player.Name)
                if pf then
                    currentTag = readTagFromFolder(pf)
                    if currentTag then break end
                end
            end
            task.wait(0.5)
        end
    end)
end

-- =========================
-- FIRE EMOTE
-- =========================
local function fireSelect()
    if not currentTag then return end
    local b = tonumber(currentTag)
    if not b then return end
    if selectEmote == "" then return end

    local buf = buffer.create(2)
    buffer.writeu8(buf, 0, b)
    buffer.writeu8(buf, 1, 17)

    if remoteSignal then
        firesignal(remoteSignal, buf, { selectEmote })
    end
end

-- =========================
-- HOOK SYSTEM
-- =========================
if EmoteRemote and PassCharacterInfo then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = { ... }

        if method == "FireServer" and self == EmoteRemote then
            if emoteEnabled and args[1] == currentEmote then
                pendingSlot = true
                blockOriginalEmote = true

                task.spawn(function()
                    task.wait(0.1)
                    blockOriginalEmote = false
                    if pendingSlot then
                        pendingSlot = nil
                        fireSelect()
                    end
                end)

                if blockOriginalEmote then
                    return nil
                end
            end
        end

        return oldNamecall(self, ...)
    end)

    if player.Character then
        onRespawn()
    end

    player.CharacterAdded:Connect(function()
        task.wait(1)
        onRespawn()
    end)
end

-- =========================
-- UI INPUT
-- =========================
local inputCurrent = ""
local inputSelect = ""

EmoteTab:Input({
    Title = "ชื่อท่าที่จะกด",
    Desc = "Current Emote",
    Placeholder = "เช่น Dance1",
    Callback = function(text)
        inputCurrent = text
    end
})

EmoteTab:Input({
    Title = "ชื่อท่าที่จะออก",
    Desc = "Select Emote",
    Placeholder = "เช่น Dance2",
    Callback = function(text)
        inputSelect = text
    end
})

-- =========================
-- TOGGLE เปิดระบบ
-- =========================
EmoteTab:Toggle({
    Title = "เปิดใช้งาน Auto Emote",
    Desc = "Auto Replace Emote",
    Default = false,
    Callback = function(state)
        emoteEnabled = state

        if state then
            currentEmote = inputCurrent:gsub("%s+", "")
            selectEmote = inputSelect:gsub("%s+", "")
        else
            currentEmote = ""
            selectEmote = ""
        end
    end
})

-- =========================
-- RESET
-- =========================
EmoteTab:Button({
    Title = "รีเซ็ตค่า",
    Desc = "Reset Emote",
    Callback = function()
        currentEmote = ""
        selectEmote = ""
        emoteEnabled = false
        inputCurrent = ""
        inputSelect = ""
    end
})

-- =========================
-- AUTO REVIVE (WINDUI VERSION)
-- =========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local interactEvent = ReplicatedStorage:WaitForChild("Events")
    :WaitForChild("Character")
    :WaitForChild("Interact")

local autoReviveEnabled = false
local reviveRange = 15
local reviveConnection = nil

-- =========================
-- ตรวจ Downed
-- =========================
local function isPlayerDowned(plr)
    local char = plr.Character
    if not char then return false end
    return char:GetAttribute("Downed") == true
end

-- =========================
-- START
-- =========================
local function startAutoRevive()
    if reviveConnection then return end

    reviveConnection = RunService.Heartbeat:Connect(function()
        if not autoReviveEnabled then return end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= player and isPlayerDowned(pl) then
                local pChar = pl.Character
                local pHrp = pChar and pChar:FindFirstChild("HumanoidRootPart")

                if pHrp then
                    local dist = (hrp.Position - pHrp.Position).Magnitude

                    if dist <= reviveRange then
                        pcall(function()
                            interactEvent:FireServer("Revive", true, pl.Name)
                        end)
                    end
                end
            end
        end
    end)
end

-- =========================
-- STOP
-- =========================
local function stopAutoRevive()
    if reviveConnection then
        reviveConnection:Disconnect()
        reviveConnection = nil
    end
end

-- =========================
-- 🔘 TOGGLE (MainMenu)
-- =========================
MainMenu:Toggle({
    Title = "ออโต้ชุบเพื่อน",
    Desc = "Auto Revive nearby teammates",
    Default = false,
    Callback = function(state)
        autoReviveEnabled = state

        if state then
            startAutoRevive()
        else
            stopAutoRevive()
        end
    end
})


-- =========================
-- DAY / NIGHT SYSTEM
-- =========================
local Lighting = game:GetService("Lighting")

ExtraTab:Button({
    Title = "กลางวัน",
    Desc = "Set time to day (12:00)",
    Callback = function()
        Lighting.ClockTime = 12
    end
})

ExtraTab:Button({
    Title = "กลางคืน",
    Desc = "Set time to night (22:00)",
    Callback = function()
        Lighting.ClockTime = 22
    end
})

-- =========================
-- AFK REVIVE FARM (FIXED FOR YOUR WINDUI)
-- =========================
local systemEnabled = false
local afkPart = nil
local loopConnection = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- =========================
-- SAFE REMOTE
-- =========================
local interactEvent = nil
pcall(function()
    local ev = ReplicatedStorage:WaitForChild("Events",5)
    if ev then
        local char = ev:WaitForChild("Character",5)
        if char then
            interactEvent = char:WaitForChild("Interact",5)
        end
    end
end)

-- =========================
-- AFK PART
-- =========================
local function createAFKPart()
    if afkPart then return end

    afkPart = Instance.new("Part")
    afkPart.Size = Vector3.new(10,1,10)
    afkPart.Anchored = true
    afkPart.Position = Vector3.new(0,1200,0)
    afkPart.Transparency = 1
    afkPart.CanCollide = true
    afkPart.Name = "AFK_PART"
    afkPart.Parent = workspace
end

local function removeAFKPart()
    if afkPart then
        afkPart:Destroy()
        afkPart = nil
    end
end

-- =========================
-- หา Downed Player
-- =========================
local function getDownedPlayer()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            if plr.Character:GetAttribute("Downed") == true then
                return plr
            end
        end
    end
    return nil
end

-- =========================
-- LOOP
-- =========================
local function startSystem()
    if loopConnection then return end

    loopConnection = RunService.Heartbeat:Connect(function()
        if not systemEnabled then return end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local target = getDownedPlayer()

        if target and target.Character then
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")

            if targetHRP then
                -- วาร์ปไป
                hrp.CFrame = targetHRP.CFrame + Vector3.new(0,2,0)

                -- ชุบ
                if interactEvent then
                    pcall(function()
                        interactEvent:FireServer("Revive", true, target.Name)
                    end)
                end
            end
        else
            -- กลับ AFK
            if afkPart then
                hrp.CFrame = afkPart.CFrame + Vector3.new(0,2,0)
            end
        end
    end)
end

local function stopSystem()
    if loopConnection then
        loopConnection:Disconnect()
        loopConnection = nil
    end
end

-- =========================
-- RESPAWN FIX
-- =========================
player.CharacterAdded:Connect(function()
    task.wait(1)
    if systemEnabled and afkPart then
        local hrp = player.Character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = afkPart.CFrame + Vector3.new(0,2,0)
    end
end)

-- =========================
-- ✅ WINDUI (ของมึงต้องใช้แบบนี้)
-- =========================
FarmTab:Toggle({
    Title = "ฟาร์มเงิน+เลเวล",
    Desc = "AFK + Auto Revive",
    Default = false,
    Callback = function(state)
        systemEnabled = state

        if state then
            createAFKPart()
            startSystem()
        else
            stopSystem()
            removeAFKPart()
        end
    end
})

-- =========================
-- AUTO REVIVE + WARP (LOW LAG)
-- =========================
local autoReviveFarm = false
local reviveConn = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- หา Remote กันพัง
local interactEvent = nil
pcall(function()
    local ev = ReplicatedStorage:WaitForChild("Events",5)
    if ev then
        local char = ev:WaitForChild("Character",5)
        if char then
            interactEvent = char:WaitForChild("Interact",5)
        end
    end
end)

-- ค่า
local SCAN_DELAY = 0.15 -- ยิ่งมากยิ่งลื่น
local lastScan = 0
local originalPos = nil
local isReviving = false

-- หา Downed
local function getDownedPlayer()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            if plr.Character:GetAttribute("Downed") == true then
                return plr
            end
        end
    end
    return nil
end

-- LOOP
local function startAutoReviveFarm()
    if reviveConn then return end

    reviveConn = RunService.Heartbeat:Connect(function()
        if not autoReviveFarm then return end
        if tick() - lastScan < SCAN_DELAY then return end
        lastScan = tick()

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local target = getDownedPlayer()

        if target and target.Character then
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")

            if targetHRP then
                if not isReviving then
                    -- จำตำแหน่งเดิม
                    originalPos = hrp.CFrame
                    isReviving = true
                end

                -- วาร์ปไปติดตัว
                hrp.CFrame = targetHRP.CFrame + Vector3.new(0,2,0)

                -- ชุบ
                if interactEvent then
                    pcall(function()
                        interactEvent:FireServer("Revive", true, target.Name)
                    end)
                end

                -- ถ้าฟื้นแล้ว
                if target.Character:GetAttribute("Downed") ~= true then
                    task.wait(0.2)
                    if originalPos then
                        hrp.CFrame = originalPos
                    end
                    isReviving = false
                end
            end
        end
    end)
end

local function stopAutoReviveFarm()
    if reviveConn then
        reviveConn:Disconnect()
        reviveConn = nil
    end
    isReviving = false
end

-- =========================
-- WINDUI (หมวดฟาร์ม)
-- =========================
FarmTab:Toggle({
    Title = "ออโต้ชุบเพื่อน",
    Desc = "Auto Revive Player (Warp)",
    Default = false,
    Callback = function(state)
        autoReviveFarm = state

        if state then
            startAutoReviveFarm()
        else
            stopAutoReviveFarm()
        end
    end
})


-- =========================
-- BOT ESP + TRACER SYSTEM
-- =========================
local botESPEnabled = false
local espObjects = {}

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local function clearESP()
    for _, v in ipairs(espObjects) do
        if v then v:Destroy() end
    end
    espObjects = {}
end

local function getRoot()
    local char = lp.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function addESP(npc)
    if not botESPEnabled then return end

    local root = npc:FindFirstChild("Root") or npc:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if root:FindFirstChild("BotESP") then return end

    -- ===== LABEL =====
    local bb = Instance.new("BillboardGui")
    bb.Name = "BotESP"
    bb.Size = UDim2.new(0, 120, 0, 40)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = root

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = "🤖 บอท"
    txt.TextColor3 = Color3.fromRGB(255, 70, 70)
    txt.TextStrokeTransparency = 0
    txt.Font = Enum.Font.GothamBold
    txt.TextScaled = true
    txt.Parent = bb

    table.insert(espObjects, bb)

    -- ===== TRACER =====
    local charRoot = getRoot()
    if not charRoot then return end

    local a0 = Instance.new("Attachment", root)
    local a1 = Instance.new("Attachment", charRoot)

    local beam = Instance.new("Beam")
    beam.Attachment0 = a1
    beam.Attachment1 = a0
    beam.Width0 = 0.12
    beam.Width1 = 0.12
    beam.Color = ColorSequence.new(Color3.fromRGB(0,170,255))
    beam.FaceCamera = true
    beam.LightEmission = 1
    beam.Parent = charRoot

    table.insert(espObjects, beam)
    table.insert(espObjects, a0)
    table.insert(espObjects, a1)
end

local function scanBots()
    local folder = workspace:FindFirstChild("Game")
        and workspace.Game:FindFirstChild("Players")

    if not folder then return end

    for _, npc in ipairs(folder:GetChildren()) do
        if npc:GetAttribute("Team") == "Nextbot" then
            addESP(npc)
        end
    end
end

task.spawn(function()
    while true do
        if botESPEnabled then
            scanBots()
        end
        task.wait(1)
    end
end)

-- =========================
-- WINDUI TOGGLE (แบบมึงใช้จริง)
-- =========================
ViewTab:Toggle({
    Title = "มองหาบอท + เส้น",
    Desc = "ESP Nextbot + Blue tracer",
    Default = false,

    Callback = function(state)
        botESPEnabled = state

        if state then
            scanBots()
        else
            clearESP()
        end
    end
})

-- =========================
-- PLAYER ESP (NAME TAG)
-- =========================
local playerESPEnabled = false
local espObjects = {}

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local function clearESP()
    for _, v in ipairs(espObjects) do
        if v then v:Destroy() end
    end
    espObjects = {}
end

local function addESP(plr)
    if not playerESPEnabled then return end
    if plr == lp then return end
    if not plr.Character then return end

    local char = plr.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if root:FindFirstChild("PlayerESP") then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "PlayerESP"
    bb.Size = UDim2.new(0, 150, 0, 40)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = root

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = plr.Name -- 👈 ชื่อผู้เล่น
    txt.TextColor3 = Color3.fromRGB(0, 170, 255)
    txt.TextStrokeTransparency = 0
    txt.Font = Enum.Font.GothamBold
    txt.TextScaled = true
    txt.Parent = bb

    table.insert(espObjects, bb)
end

local function scanPlayers()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp then
            addESP(plr)
        end
    end
end

task.spawn(function()
    while true do
        if playerESPEnabled then
            scanPlayers()
        end
        task.wait(1)
    end
end)

-- =========================
-- WINDUI TOGGLE
-- =========================
ViewTab:Toggle({
    Title = "มองหาผู้เล่น",
    Desc = "Show all players name (except you)",
    Default = false,

    Callback = function(state)
        playerESPEnabled = state

        if state then
            scanPlayers()
        else
            clearESP()
        end
    end
})

-- =========================
-- DOWNED PLAYER ESP
-- =========================
local downedESPEnabled = false
local espObjects = {}

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local function clearESP()
    for _, v in ipairs(espObjects) do
        if v then v:Destroy() end
    end
    espObjects = {}
end

local function isDowned(plr)
    return plr.Character and plr.Character:GetAttribute("Downed") == true
end

local function addESP(plr)
    if not downedESPEnabled then return end
    if plr == lp then return end
    if not isDowned(plr) then return end

    local char = plr.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if root:FindFirstChild("DownedESP") then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "DownedESP"
    bb.Size = UDim2.new(0, 120, 0, 40)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = root

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = "💀 ล้ม"
    txt.TextColor3 = Color3.fromRGB(255, 0, 0) -- 🔴 สีแดง
    txt.TextStrokeTransparency = 0
    txt.Font = Enum.Font.GothamBold
    txt.TextScaled = true
    txt.Parent = bb

    table.insert(espObjects, bb)
end

local function scanDowned()
    for _, plr in ipairs(Players:GetPlayers()) do
        addESP(plr)
    end
end

task.spawn(function()
    while true do
        if downedESPEnabled then
            scanDowned()
        end
        task.wait(0.8)
    end
end)

-- =========================
-- WINDUI TOGGLE
-- =========================
ViewTab:Toggle({
    Title = "มองหาผู้เล่นล้ม",
    Desc = "Show downed players only",
    Default = false,

    Callback = function(state)
        downedESPEnabled = state

        if state then
            scanDowned()
        else
            clearESP()
        end
    end
})

-- =========================
-- FLOOR REFLECT (WINDUI)
-- =========================
local floorReflectOn = false
local originalParts = {}
local processed = false

local function enableFloorReflect()
    if processed then return end
    processed = true

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if not originalParts[obj] then
                originalParts[obj] = {
                    Material = obj.Material,
                    Reflectance = obj.Reflectance
                }
            end

            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0.3
        end
    end
end

local function disableFloorReflect()
    for obj, data in pairs(originalParts) do
        if obj and obj.Parent then
            obj.Material = data.Material
            obj.Reflectance = data.Reflectance
        end
    end

    originalParts = {}
    processed = false
end

-- =========================
-- WINDUI TOGGLE
-- =========================
ExtraTab:Toggle({
    Title = "พื้นใส",
    Desc = "Make map reflective",
    Default = false,

    Callback = function(state)
        floorReflectOn = state

        if state then
            enableFloorReflect()
        else
            disableFloorReflect()
        end
    end
})

-- =========================
-- VISUAL TICKET ESP (FULL SCAN)
-- =========================
local ticketESPEnabled = false
local espCache = {}

local function clearESP()
    for _, v in ipairs(espCache) do
        if v then v:Destroy() end
    end
    espCache = {}
end

local function addESP(part)
    if not part then return end
    if part:FindFirstChild("VisualESP") then return end

    local gui = Instance.new("BillboardGui")
    gui.Name = "VisualESP"
    gui.Size = UDim2.new(0, 130, 0, 40)
    gui.StudsOffset = Vector3.new(0, 2, 0)
    gui.AlwaysOnTop = true
    gui.Parent = part

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = "🎟️ Ticket"
    txt.TextColor3 = Color3.fromRGB(255, 220, 0)
    txt.TextStrokeTransparency = 0
    txt.Font = Enum.Font.GothamBold
    txt.TextScaled = true
    txt.Parent = gui

    table.insert(espCache, gui)
end

local function scanVisuals()
    for _, obj in ipairs(workspace:GetDescendants()) do
        -- 🔥 เป้าหมายจริง = "Visual"
        if obj.Name == "Visual" then
            if obj:IsA("Model") then
                local root =
                    obj.PrimaryPart
                    or obj:FindFirstChildWhichIsA("BasePart", true)

                if root then
                    addESP(root)
                end
            elseif obj:IsA("BasePart") then
                addESP(obj)
            end
        end
    end
end

-- =========================
-- LOOP เบาเครื่อง
-- =========================
task.spawn(function()
    while true do
        if ticketESPEnabled then
            scanVisuals()
        end
        task.wait(1.5)
    end
end)

-- =========================
-- WINDUI TOGGLE
-- =========================
EventTab:Toggle({
    Title = "🎟️ มองหาเหรียญอีเว้นท์",
    Desc = "Find Visual model (Ticket inside)",
    Default = false,

    Callback = function(state)
        ticketESPEnabled = state

        if state then
            scanVisuals()
        else
            clearESP()
        end
    end
})

-- =========================
-- AUTO EVENT FARM (WINDUI FIX)
-- =========================
local autoEventFarm = false
local farmThread

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local function stopFarm()
    autoEventFarm = false
    farmThread = nil
end

local function startEventFarm()
    if farmThread then return end

    farmThread = task.spawn(function()
        while autoEventFarm do

            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if not hrp then
                task.wait(0.2)
                continue
            end

            local ticketsFolder =
                Workspace:FindFirstChild("Game")
                and Workspace.Game:FindFirstChild("Effects")
                and Workspace.Game.Effects:FindFirstChild("Tickets")

            local found = false

            if ticketsFolder then
                for _, ticket in ipairs(ticketsFolder:GetChildren()) do
                    local root = ticket:FindFirstChild("HumanoidRootPart") or ticket:FindFirstChildWhichIsA("BasePart")

                    if root then
                        found = true

                        -- 🚀 วาร์ปไปหา
                        hrp.CFrame = root.CFrame + Vector3.new(0,2,0)

                        -- 🎟️ เก็บตั๋ว
                        pcall(function()
                            local ev = ReplicatedStorage:FindFirstChild("Events")
                            if ev and ev:FindFirstChild("CollectTicket") then
                                ev.CollectTicket:FireServer(ticket)
                            end
                        end)

                        break
                    end
                end
            end

            -- 🌫️ ไม่มีของ → ลอยฟ้า AFK
            if not found then
                hrp.CFrame = CFrame.new(hrp.Position.X, 1200, hrp.Position.Z)
            end

            task.wait(0.25) -- 🔥 กันแลค
        end
    end)
end

-- =========================
-- WINDUI TOGGLE (ถูกต้อง)
-- =========================
EventTab:Toggle({
    Title = "ออโต้ฟาร์มอีเว้น",
    Desc = "Auto collect tickets",
    Default = false,

    Callback = function(state)
        autoEventFarm = state

        if state then
            startEventFarm()
        else
            stopFarm()
        end
    end
})

-- =========================
-- COPY LINKS BUTTONS
-- =========================

SettingsTab:Button({
    Title = "Discord",
    Desc = "Copy Discord invite link",
    Callback = function()
        pcall(function()
            setclipboard("https://discord.gg/xXxDzyJkU")
        end)
    end
})

SettingsTab:Button({
    Title = "TikTok",
    Desc = "Copy TikTok name",
    Callback = function()
        pcall(function()
            setclipboard("komat380")
        end)
    end
})

ExtraTab:Toggle({
    Title = "หน้าจอยืด",
    Desc = "เปิด/ปิด Stretch (Fixed)",
    Default = false,

    Callback = function(state)

        local Camera = workspace.CurrentCamera

        if state then
            getgenv().ScreenStretchActive = true

            task.spawn(function()
                while getgenv().ScreenStretchActive do
                    if Camera then
                        Camera.FieldOfView = 90 -- ปกติ ~70
                    end
                    task.wait(0.1)
                end
            end)

        else
            getgenv().ScreenStretchActive = false
            if Camera then
                Camera.FieldOfView = 70
            end
        end
    end
})

-- =========================
-- 1080x1080 SCRIPT LOADER
-- =========================
ExtraTab:Button({
    Title = "1080x1080",
    Desc = "Run external script",

    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/W8aaHmdv"))()
        end)
    end
})

-- =========================
-- 1080x1080 SCRIPT LOADER
-- =========================
ExtraTab:Button({
    Title = "ลบกำแพงล่องหน",
    Desc = "Remove the invisible wall",

    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/Xzinw3CU"))()
        end)
    end
})


-- =========================
-- 1080x1080 SCRIPT LOADER
-- =========================
ExtraTab:Button({
    Title = "กันโดนเตะ",
    Desc = "Anti Kick",

    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/dciRc27F"))()
        end)
    end
})

-- =========================
-- SERVICES
-- =========================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- =========================
-- DASH SYSTEM
-- =========================
local dashEnabled = false
local dashSpeed = 50
local dashVelocity = nil

-- =========================
-- RESET
-- =========================
local function resetDash()
    dashEnabled = false

    if dashVelocity then
        dashVelocity:Destroy()
        dashVelocity = nil
    end
end

player.CharacterAdded:Connect(function()
    task.wait(0.3)
    resetDash()
end)

-- =========================
-- START DASH
-- =========================
local function startDash()
    if dashVelocity then return end

    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    dashVelocity = Instance.new("BodyVelocity")
    dashVelocity.MaxForce = Vector3.new(999999, 0, 999999)
    dashVelocity.P = 1250
    dashVelocity.Parent = root

    task.spawn(function()
        while dashEnabled do
            local char = player.Character
            if not char then break end

            local root = char:FindFirstChild("HumanoidRootPart")
            local cam = workspace.CurrentCamera

            if not root or not cam then break end

            local dir = cam.CFrame.LookVector
            dir = Vector3.new(dir.X, 0, dir.Z)

            if dir.Magnitude > 0 then
                dir = dir.Unit
            end

            dashVelocity.Velocity = dir * dashSpeed
            task.wait(0.03)
        end

        if dashVelocity then
            dashVelocity:Destroy()
            dashVelocity = nil
        end
    end)
end

-- =========================
-- FLOATING BUTTON SYSTEM
-- =========================
local FloatingGui = Instance.new("ScreenGui")
FloatingGui.Name = "FloatingDashGui"
FloatingGui.Parent = game.CoreGui

local floatingDashButton = nil

local function createFloatingButton()
    if floatingDashButton then return end

    local btn = Instance.new("TextButton")
    floatingDashButton = btn

    btn.Size = UDim2.new(0,140,0,52)
    btn.Position = UDim2.new(0.5,-70,0.85,0)
    btn.AnchorPoint = Vector2.new(0.5,0)
    btn.BackgroundColor3 = Color3.fromRGB(180,220,255)
    btn.BackgroundTransparency = 0.35
    btn.TextColor3 = Color3.fromRGB(0,70,150)
    btn.Text = "Dash: OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = FloatingGui
    btn.Active = true
    btn.Draggable = true

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,18)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 2.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(0,120,255)

    -- animation สี
    task.spawn(function()
        while btn.Parent do
            TweenService:Create(stroke, TweenInfo.new(0.8), {
                Color = Color3.fromRGB(0,80,255)
            }):Play()
            task.wait(0.8)

            TweenService:Create(stroke, TweenInfo.new(0.8), {
                Color = Color3.fromRGB(160,230,255)
            }):Play()
            task.wait(0.8)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        dashEnabled = not dashEnabled

        if dashEnabled then
            btn.Text = "Dash: ON"
            startDash()
        else
            btn.Text = "Dash: OFF"
            resetDash()
        end
    end)
end

local function removeFloatingButton()
    if floatingDashButton then
        floatingDashButton:Destroy()
        floatingDashButton = nil
    end
end

-- =========================
-- TOGGLE 1: ออโต้พุ่ง (ปกติ)
-- =========================
SettingsTab:Toggle({
    Title = "ออโต้พุ่ง",
    Desc = "Auto Dash forward movement",
    Default = false,
    Callback = function(state)
        dashEnabled = state

        if state then
            startDash()
        else
            resetDash()
        end
    end
})

-- =========================
-- TOGGLE 2: ปุ่มลอย
-- =========================
SettingsTab:Toggle({
    Title = "ปุ่มแดชลอย",
    Desc = "เปิดแล้วจะมีปุ่มลอยให้กด",
    Default = false,
    Callback = function(state)
        if state then
            createFloatingButton()
        else
            removeFloatingButton()
        end
    end
})

-- =========================
-- SPEED SLIDER
-- =========================
SettingsTab:Slider({
    Title = "ความเร็วแดช",
    Desc = "ปรับสปีดพุ่ง",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(value)
        dashSpeed = value
    end
})
