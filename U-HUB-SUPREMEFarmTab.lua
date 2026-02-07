local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local vInput = game:GetService("VirtualInputManager")
local lp = game.Players.LocalPlayer
math.randomseed(tick())

-- [[ 1. CONFIGURATION & VARIABLES ]]
_G.FlySpeed = 400 
_G.AutoFarm = false
_G.IsHiding = false
_G.FlySequence = false
local SelectedZoneID = 1
local HomePos = Vector3.new(127.51, 3.49, 11.21)

local Locations = {
    ["จุดที่ 1"] = Vector3.new(197.34, -2.51, -94.93),
    ["จุดที่ 2"] = Vector3.new(286.41, -2.51, 21.26),
    ["จุดที่ 3"] = Vector3.new(399.71, -2.51, 118.11),
    ["จุดที่ 4"] = Vector3.new(540.42, -2.51, 15.88),
    ["จุดที่ 5"] = Vector3.new(756.99, -2.51, 2.76),
    ["จุดที่ 6"] = Vector3.new(1074.24, -2.51, -10.50),
    ["จุดที่ 7"] = Vector3.new(1553.90, -2.51, -106.57),
    ["จุดที่ 8"] = Vector3.new(2245.50, -2.51, -19.42),
    ["จุดที่ 9"] = Vector3.new(2600.67, -2.51, -14.11)
}

local ZoneData = {
    [1] = {Farm = Vector3.new(229.04, 3.49, -18.49), Safe = Locations["จุดที่ 1"]},
    [2] = {Farm = Vector3.new(348.37, 3.49, -4.69),  Safe = Locations["จุดที่ 2"]},
    [3] = {Farm = Vector3.new(458.68, 3.49, 12.43),  Safe = Locations["จุดที่ 3"]},
    [4] = {Farm = Vector3.new(616.35, 3.49, 3.81),   Safe = Locations["จุดที่ 4"]},
    [5] = {Farm = Vector3.new(840.69, 3.49, 26.67),  Safe = Locations["จุดที่ 5"]},
    [6] = {Farm = Vector3.new(1266.16, 3.49, 4.94),  Safe = Locations["จุดที่ 6"]},
    [7] = {Farm = Vector3.new(1788.45, 3.49, -0.41), Safe = Locations["จุดที่ 7"]},
    [8] = {Farm = Vector3.new(2426.10, 3.49, -7.20), Safe = Locations["จุดที่ 8"]},
    [9] = {Farm = Vector3.new(2782.53, 3.49, -9.53), Safe = Locations["จุดที่ 9"]}
}

-- [[ 2. CORE FUNCTIONS (FIXED BUG) ]]
function HoldGrabLogic(zoneId)
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local zonePos = ZoneData[zoneId].Farm
    
    -- บินไปโซนที่มึงเลือก
    local t1 = TweenService:Create(hrp, TweenInfo.new((hrp.Position - zonePos).Magnitude/_G.FlySpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(zonePos)})
    t1:Play()
    t1.Completed:Wait()
    task.wait(0.5)

    -- หามอน (แก้บั๊ก: จำกัดระยะแค่ 150 บล็อก ไม่ให้บินข้ามไปโซน 6)
    local targetRoot = nil
    local minDist = 150 
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("TextLabel") and (v.Text:lower():find("lv") or v.Text:lower():find("level")) then
            local model = v:FindFirstAncestorOfClass("Model")
            if model and model ~= char then
                local r = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
                if r then
                    local dist = (r.Position - hrp.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        targetRoot = r
                    end
                end
            end
        end
    end

    if targetRoot and not _G.IsHiding then
        local t2 = TweenService:Create(hrp, TweenInfo.new((hrp.Position - targetRoot.Position).Magnitude/_G.FlySpeed, Enum.EasingStyle.Linear), {CFrame = targetRoot.CFrame})
        t2:Play()
        t2.Completed:Wait()
        vInput:SendKeyEvent(true, "E", false, game)
        firetouchinterest(hrp, targetRoot, 0)
        task.wait(0.1)
        vInput:SendKeyEvent(false, "E", false, game)
        firetouchinterest(hrp, targetRoot, 1)
        task.wait(0.2)
    end
    TweenService:Create(hrp, TweenInfo.new((hrp.Position - HomePos).Magnitude/_G.FlySpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(HomePos)}):Play()
end

-- [[ 3. GUI INITIALIZATION ]]
local Window = Fluent:CreateWindow({
    Title = "U-HUB SUPREME ",
    SubTitle = "BY Neung",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.U 
})

local Tabs = {
    Main = Window:AddTab({ Title = "Home / หน้าหลัก", Icon = "home" }),
    Farm = Window:AddTab({ Title = "Auto Fly / บินวน", Icon = "map" }),
    Settings = Window:AddTab({ Title = "Settings / ตั้งค่า", Icon = "settings" })
}

-- [[ 4. UI COMPONENTS (HOME) ]]
Tabs.Main:AddDropdown("ZoneSelector", {
    Title = "เลือกโซนฟาร์ม",
    Values = {"โซน 1", "โซน 2", "โซน 3", "โซน 4", "โซน 5", "โซน 6", "โซน 7", "โซน 8", "โซน 9"},
    Default = "โซน 1",
    Callback = function(v) SelectedZoneID = tonumber(v:match("%d+")) end
})

Tabs.Main:AddButton({
    Title = "ไปหยิบมอน (ครั้งเดียว)",
    Callback = function() task.spawn(function() HoldGrabLogic(SelectedZoneID) end) end
})

Tabs.Main:AddToggle("FarmToggle", {
    Title = "เปิดออโต้ฟาร์มวนลูป",
    Default = false,
    Callback = function(v) 
        _G.AutoFarm = v 
        if v then 
            task.spawn(function()
                while _G.AutoFarm do
                    if not _G.IsHiding then HoldGrabLogic(SelectedZoneID) end
                    task.wait(1)
                end
            end)
        end 
    end
})

-- [[ 5. UI COMPONENTS (AUTO FLY) ]]
Tabs.Farm:AddToggle("TsunamiFly400", {
    Title = "บินวนจุดเซฟอัตโนมัติ (Speed 400)",
    Default = false,
    Callback = function(v)
        _G.FlySequence = v
        if v then
            task.spawn(function()
                local LocList = {Locations["จุดที่ 1"], Locations["จุดที่ 2"], Locations["จุดที่ 3"], Locations["จุดที่ 4"], Locations["จุดที่ 5"], Locations["จุดที่ 6"], Locations["จุดที่ 7"], Locations["จุดที่ 8"], Locations["จุดที่ 9"]}
                while _G.FlySequence do
                    for _, pos in pairs(LocList) do
                        if not _G.FlySequence then break end
                        local root = lp.Character.HumanoidRootPart
                        local tween = TweenService:Create(root, TweenInfo.new((root.Position - pos).Magnitude/400, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
                        tween:Play()
                        repeat task.wait() until (root.Position - pos).Magnitude < 7 or not _G.FlySequence
                        task.wait(0.5)
                    end
                end
            end)
        end
    end
})

local SelectPoint = Tabs.Farm:AddDropdown("WarpDropdown", {
    Title = "วาร์ปไปจุดที่เลือก",
    Values = {"ปิด","จุดที่ 1", "จุดที่ 2", "จุดที่ 3", "จุดที่ 4", "จุดที่ 5", "จุดที่ 6", "จุดที่ 7", "จุดที่ 8", "จุดที่ 9"},
    Default = "ปิด",
})

SelectPoint:OnChanged(function(Value)
    if Value == "ปิด" then return end
    local targetPos = Locations[Value]
    local hrp = lp.Character.HumanoidRootPart
    TweenService:Create(hrp, TweenInfo.new((hrp.Position - targetPos).Magnitude/_G.FlySpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)}):Play()
    task.wait(2)
    SelectPoint:SetValue("ปิด")
end)

-- [[ 6. UI COMPONENTS (SETTINGS) ]]
Tabs.Settings:AddSlider("FlySpeedSlider", {
    Title = "ปรับความเร็วการบิน",
    Default = 400, Min = 100, Max = 1000, Rounding = 0,
    Callback = function(v) _G.FlySpeed = v end
})

-- [[ 7. LOGO & WINDOW DRAG SYSTEM ]]
local function SetupLogoV50(MainBtn)
    local Container = Instance.new("Frame", MainBtn)
    Container.Size = UDim2.new(1, 0, 1, 0); Container.BackgroundTransparency = 1; Container.ClipsDescendants = true
    local function CreateChar(txt, color)
        local h = Instance.new("Frame", Container); h.Size = UDim2.new(1, 0, 1, 0); h.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", h); l.Text = txt; l.TextColor3 = color; l.Font = Enum.Font.GothamBold; l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
        task.spawn(function() while true do
            TweenService:Create(l, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Position = UDim2.new(0,0,0,2)}):Play()
            task.wait(1.5)
            TweenService:Create(l, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Position = UDim2.new(0,0,0,-2)}):Play()
            task.wait(1.5)
        end end)
        return h, l
    end
    local holderU, textU = CreateChar("U", Color3.fromRGB(0, 255, 100))
    local holderN, textN = CreateChar("N", Color3.fromRGB(0, 170, 255))
    holderU.Position = UDim2.new(0,0,0,0); textU.TextSize = 35
    holderN.Position = UDim2.new(-0.25,0,-0.25,0); textN.TextSize = 14
    return function(isMinimized)
        if isMinimized then
            TweenService:Create(holderU, TweenInfo.new(0.4), {Position = UDim2.new(0,0,0,0)}):Play(); textU.TextSize = 35
            TweenService:Create(holderN, TweenInfo.new(0.4), {Position = UDim2.new(-0.25,0,-0.25,0)}):Play(); textN.TextSize = 14
        else
            TweenService:Create(holderN, TweenInfo.new(0.4), {Position = UDim2.new(0,0,0,0)}):Play(); textN.TextSize = 35
            TweenService:Create(holderU, TweenInfo.new(0.4), {Position = UDim2.new(-0.25,0,-0.25,0)}):Play(); textU.TextSize = 14
        end
    end
end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainBtn = Instance.new("Frame", ScreenGui)
MainBtn.Size = UDim2.new(0, 60, 0, 60); MainBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
MainBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); MainBtn.Active = true
Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(0, 12)
local UpdateLogo = SetupLogoV50(MainBtn)

local dragging, dragStart, startPos, startTime
MainBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; startTime = tick(); dragStart = input.Position; startPos = MainBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if tick() - startTime < 0.25 then
                    Window:Minimize()
                    task.wait(0.05)
                    UpdateLogo(Window.Minimized)
                end
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- [[ 8. TSUNAMI PROTECTION ]]
task.spawn(function()
    while task.wait(0.5) do
        local water = workspace:FindFirstChild("Tsunami") or workspace:FindFirstChild("Water")
        if water and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = lp.Character.HumanoidRootPart
            if (water.Position - hrp.Position).Magnitude < 450 then
                _G.IsHiding = true
                hrp.CFrame = CFrame.new(ZoneData[SelectedZoneID].Safe)
                repeat task.wait(1) until not workspace:FindFirstChild("Tsunami") and not workspace:FindFirstChild("Water")
                task.wait(2)
                _G.IsHiding = false
            end
        end
    end
end)


Tabs.Settings:AddDropdown("WindowSize", {
    Title = "ปรับขนาดเมนู",
    Values = {"เล็ก", "กลาง", "ใหญ่"},
    Default = "กลาง",
    Callback = function(Value)
        -- เช็คว่าตัวแปร Window ของน้องมีอยู่จริงไหม
        if Window and Window.Root then
            local NewSize
            if Value == "เล็ก" then 
                NewSize = UDim2.fromOffset(480, 360)
            elseif Value == "กลาง" then 
                NewSize = UDim2.fromOffset(580, 460)
            elseif Value == "ใหญ่" then 
                NewSize = UDim2.fromOffset(800, 600) 
            end
            
            -- สั่งปรับขนาดไปที่ตัว Frame หลักของ UI เลย
            Window.Root.Size = NewSize
        end
    end
})

-- [[ ปุ่มเปลี่ยนปุ่มเมนู แบบโชว์ให้กดเปลี่ยนได้ ]]
Tabs.Settings:AddKeybind("MenuBind", {
    Title = "ตั้งค่าปุ่มเปิด/ปิดเมนู",
    Default = "...",
    Mode = "Toggle",
    Callback = function() Window:Minimize() end
})

-- [[ ⚡ สคริปต์ FORCE BOOST (แปลงจาก FastFlags เป๊ะๆ) ⚡ ]]

local function ForceExtremeBoost()
    -- 1. ปลดล็อค FPS (พยายามฝืนให้สูงที่สุดเท่าที่ Lua ทำได้)
    setfpscap(2147483647) 

    -- 2. ตั้งค่า Rendering ให้ต่ำสุด (เลียนแบบ QualityLevel 1)
    settings().Rendering.QualityLevel = 1
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level10
    
    -- 3. ปรับระบบแสงและเงา (เลียนแบบ DisablePostFx & Voxel)
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 0
    Lighting.ExposureCompensation = 0
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") then
            v.Enabled = false
        end
    end

    -- 4. จัดการพื้นผิวและวัตถุ (เลียนแบบ TextureQuality & CSG Level)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        elseif v:IsA("Texture") or v:IsA("Decal") then
            v:Destroy() -- ลบรูปภาพพื้นผิวออกให้หมดตามสูตร
        elseif v:IsA("DataModelMesh") then
            v.LODEffortMode = Enum.LODEffortMode.Low
        end
    end

    -- 5. ปิดหญ้าและน้ำ (เลียนแบบ FRMMaxGrassDistance & WaterSlice)
    if workspace:FindFirstChildOfClass("Terrain") then
        local t = workspace.Terrain
        t.WaterWaveSize = 0
        t.WaterWaveSpeed = 0
        t.WaterReflectance = 0
        t.WaterTransparency = 0
        sethiddenproperty(t, "Decoration", false)
    end

    -- [[ ส่วนอันตราย: ถ้าอยากให้หน้าจอหายไปเลยตามสูตรเป๊ะ ให้เอา -- ออกข้างล่างนี้ ]]
     -- game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end


Tabs.Settings:AddButton({
    Title = "ภาพกาก สำหรับคนโทรศัพกัง",
    Callback = function()
        ForceExtremeBoost()
    end
})



Tabs.Settings:AddButton({
    Title = "รี เซิร์ฟ",
    Description = "กลับเข้าเซิร์ฟเวอร์เดิมแบบไวๆ",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

Tabs.Settings:AddButton({
    Title = "เปลี่ยนเซิร์ฟใหม่",
    Description = "สุ่มย้ายไปเซิร์ฟเวอร์อื่นที่คนไม่เต็ม",
    Callback = function()
        local Http = game:GetService("HttpService")
        local Tps = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        
        local function Hop()
            local Raw = game:HttpGet(Api)
            local Decode = Http:JSONDecode(Raw)
            if Decode and Decode.data then
                for _, v in pairs(Decode.data) do
                    if type(v) == "table" and v.playing < v.maxPlayers and v.id ~= game.JobId then
                        Tps:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                        break
                    end
                end
            end
        end
        
        Hop() -- เริ่มทำงานทันทีที่กดปุ่ม
    end
})

-- ส่วนหัว (ตัวแปร)
local CoinSuckerEnabled = false
local CoinSuckerConnection

-- ส่วนปุ่มใน UI
Tabs.Main:AddToggle("CoinSucker", {
    Title = "Coin Sucker (ดูดทองสัดๆ)",
    Default = false,
    Callback = function(v)
        CoinSuckerEnabled = v
        if v then
            CoinSuckerConnection = game:GetService("RunService").RenderStepped:Connect(function()
                local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj.Name == "GoldBar" and obj:IsA("Model") then
                        local p = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if p then 
                            p.AssemblyLinearVelocity = Vector3.zero
                            p.CFrame = p.CFrame:Lerp(root.CFrame * CFrame.new(0, 0, -2), 0.25) 
                        end
                    end
                end
            end)
        elseif CoinSuckerConnection then
            CoinSuckerConnection:Disconnect()
        end
    end
})


Tabs.Main:AddToggle("BrainrotTimer", {
    Title = "Brainrot Event Timer",
    Default = false,
    Callback = function(v)
        local PlayerGui = lp:WaitForChild("PlayerGui")
        if v then
            local sg = Instance.new("ScreenGui", PlayerGui)
            sg.Name = "EventTimerGUI"
            local timer = workspace:FindFirstChild("EventTimers", true)
            if timer then
                for _, p in ipairs(timer:GetDescendants()) do
                    if p:IsA("SurfaceGui") then
                        for _, g in ipairs(p:GetChildren()) do
                            local c = g:Clone()
                            c.Parent = sg
                            Instance.new("UIScale", c).Scale = 0.2
                            c.Position = UDim2.new(0.5, 0, 0.1, 0)
                            c.AnchorPoint = Vector2.new(0.5, 0.5)
                        end
                    end
                end
            end
        else
            if PlayerGui:FindFirstChild("EventTimerGUI") then PlayerGui.EventTimerGUI:Destroy() end
        end
    end
})


Tabs.Main:AddButton({
    Title = "Instant Interaction (กดไวสัด)",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.HoldDuration = 0
                v.RequiresLineOfSight = false
            end
        end
        workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("ProximityPrompt") then obj.HoldDuration = 0 obj.RequiresLineOfSight = false end
        end)
    end
})
