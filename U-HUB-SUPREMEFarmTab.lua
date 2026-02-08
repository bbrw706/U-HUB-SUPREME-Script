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

  -- [[ หามอน/ไอเทมที่มีปุ่มกด ในระยะโซนฟาร์ม ]]
    local targetRoot = nil
    local minDist = 999
    local zonePos = ZoneData[SelectedZoneID].Farm -- จุดศูนย์กลางโซน

    -- 1. หา "ปุ่มกด" (ProximityPrompt) ทั่วแมพเฉพาะที่อยู่ใกล้โซน
    for _, p in ipairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            local root = p.Parent:IsA("BasePart") and p.Parent or p.Parent:FindFirstChildWhichIsA("BasePart")
            if root then
                -- 2. เช็คว่าไอ้นี่อยู่ในโซนฟาร์มเราไหม (ระยะ 150 บล็อก)
                local distToZone = (root.Position - zonePos).Magnitude
                if distToZone < 150 then
                    -- 3. เช็คว่าไม่ใช่ตัวเรา และไม่ใช่ผู้เล่น
                    local model = root:FindFirstAncestorOfClass("Model")
                    if model and model ~= lp.Character and not game.Players:GetPlayerFromCharacter(model) then
                        -- 4. เลือกตัวที่ใกล้เราที่สุดเพื่อความไว
                        local distToMe = (root.Position - hrp.Position).Magnitude
                        if distToMe < minDist then
                            minDist = distToMe
                            targetRoot = root
                        end
                    end
                end
            end
        end
    end

    -- [[ 5. พุ่งไปหยิบ (จบงาน) ]]
    if targetRoot then
        -- บินไปหาเป้าหมาย
        local tween = TweenService:Create(hrp, TweenInfo.new((hrp.Position - targetRoot.Position).Magnitude/_G.FlySpeed, Enum.EasingStyle.Linear), {CFrame = targetRoot.CFrame})
        tween:Play()
        tween.Completed:Wait()

        -- สั่งหยิบ (ใช้ทั้ง fire และกดปุ่ม)
        local prompt = targetRoot:FindFirstChildWhichIsA("ProximityPrompt") or targetRoot.Parent:FindFirstChildWhichIsA("ProximityPrompt")
        if prompt then 
            fireproximityprompt(prompt) 
        end
        vInput:SendKeyEvent(true, "E", false, game)
        task.wait(0.1)
        vInput:SendKeyEvent(false, "E", false, game)
    end

   if targetRoot and not _G.IsHiding then
        local t2 = TweenService:Create(hrp, TweenInfo.new((hrp.Position - targetRoot.Position).Magnitude/_G.FlySpeed, Enum.EasingStyle.Linear), {CFrame = targetRoot.CFrame})
        t2:Play()
        t2.Completed:Wait()

        -- [[ แก้ 3 บรรทัดนี้แทนอันที่มึงเขียนผิด ]]
        local p = targetRoot.Parent:FindFirstChildWhichIsA("ProximityPrompt", true)
        if p then 
            fireproximityprompt(p) 
        end
        -- [[ -------------------------------- ]]

        vInput:SendKeyEvent(true, "E", false, game)
        firetouchinterest(hrp, targetRoot, 0)
        task.wait(0.2) 
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


-- [[ แก้ไขส่วนปลดล็อก VIP ให้เข้ากับ Fluent ]]
local VIPSection = Tabs.Main:AddSection("VIP Room / ห้องวีไอพี")

VIPSection:AddButton({
    Title = "Unlock VIP Room (ลบกำแพง)",
    Description = "ลบกำแพงกั้นห้อง VIP ออกเพื่อให้เดินเข้าไปได้",
    Callback = function()
        -- ใช้ workspace ตัวเล็ก และระบุตำแหน่งให้แม่นยำขึ้น
        local vip = game.Workspace:FindFirstChild("VIPWalls", true)
        
        if vip then
            vip:Destroy()
            -- ใช้ Fluent Notification แทน warn เพื่อให้เห็นที่หน้าจอ
            Fluent:Notify({
                Title = "U-HUB",
                Content = "ปลดล็อกห้อง VIP เรียบร้อยแล้ว!",
                Duration = 5
            })
        else
            Fluent:Notify({
                Title = "U-HUB",
                Content = "ไม่พบกำแพง VIP ในแมพนี้",
                Duration = 5
            })
        end
    end
})


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

-- [[ ตั้งค่าเริ่มต้น ]]
local InstantEnabled = true -- สั่งให้สถานะเป็น "เปิด" ทันทีในตัวแปร

-- ฟังก์ชันกลางสำหรับเปลี่ยนค่าปุ่ม
local function ApplyInstant(obj)
    if obj:IsA("ProximityPrompt") then
        if InstantEnabled then
            obj.HoldDuration = 0
            obj.RequiresLineOfSight = false
        else
            obj.HoldDuration = 0.5 -- กลับเป็นค่าปกติเวลาปิด
            obj.RequiresLineOfSight = true
        end
    end
end

-- 1. รันทันทีที่โหลดสคริปต์ (ไม่ต้องรอใครสั่ง)
for _, v in pairs(workspace:GetDescendants()) do
    ApplyInstant(v)
end

-- 2. ดักของที่เกิดใหม่ให้กดไวตลอดเวลา
workspace.DescendantAdded:Connect(ApplyInstant)

-- 3. ตัวปุ่ม Toggle ในเมนู (จะขึ้นว่าเปิดอยู่แล้ว)
Tabs.Settings:AddToggle("InstantInteract", {
    Title = "Instant Interaction (กดไวสัด)", 
    Default = true, -- สวิตช์เปิดค้างไว้ให้เลย
    Callback = function(Value)
        InstantEnabled = Value
        -- ถ้ามึงไปมือบอนกดปิด/เปิดใหม่ มันก็จะอัปเดตให้ทันที
        for _, v in pairs(workspace:GetDescendants()) do
            ApplyInstant(v)
        end
    end
})

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



-- [[ 8. สร้างแถบใหม่ (Fluent Style) ]]
local Tabs = {
    Main = Tabs.Main,
    Farm = Tabs.Farm,
    Settings = Tabs.Settings,
    -- เพิ่ม 2 แถบที่มึงขอ
    Event = Window:AddTab({ Title = "Event / กิจกรรม", Icon = "star" }),

}



-- ย้ายป้ายเวลามาไว้ที่นี่ด้วย
Tabs.Event:AddToggle("BrainrotTimer", {
    Title = "Brainrot Event Timer (ป้ายเวลา)",
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

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local WarpTab = Window:AddTab({ Title = "วาร์ป", Icon = "map-pin" })
local MySection = WarpTab:AddSection("เลือกจุดวาร์ป")


local part1 = Instance.new("Part", workspace)
part1.Name = "1"
part1.Size = Vector3.new(10,1,10)
part1.Anchored = true
part1.CanCollide = true
part1.CFrame = CFrame.new(
	151.81601, -1.90734863e-06, -139.729675,
	1,0,0,0,1,0,0,0,1
)

-- สร้าง Part 2
local part2 = Instance.new("Part", workspace)
part2.Name = "2"
part2.Size = Vector3.new(10,1,10)
part2.Anchored = true
part2.CanCollide = true
part2.CFrame = CFrame.new(
	2280.77612, 0.0499992371, -139.261551,
	1,0,0,0,1,0,0,0,1
)

-- สร้าง Part 3
local part3 = Instance.new("Part", workspace)
part3.Name = "3"
part3.Size = Vector3.new(10,1,10)
part3.Anchored = true
part3.CanCollide = true
part3.CFrame = CFrame.new(
	2276.26221, -5.99998856, -126.776489,
	1,0,0,0,1,0,0,0,1
)

local flying = false

local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

player.CharacterAdded:Connect(function()
	flying = false
end)

local function flyTo(targetPart)
	local char = getChar()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")

	hum.PlatformStand = true

	for _,v in pairs(char:GetChildren()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end

	while char.Parent and (hrp.Position - targetPart.Position).Magnitude > 3 do
		local dir = (targetPart.Position - hrp.Position).Unit
		local speed = hum.WalkSpeed
		hrp.AssemblyLinearVelocity = dir * speed
		RunService.RenderStepped:Wait()
	end

	if char.Parent then
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.CFrame = targetPart.CFrame + Vector3.new(0,3,0)
	end
end

local function restore()
	local char = getChar()
	local hum = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")

	hum.PlatformStand = false
	hrp.AssemblyLinearVelocity = Vector3.zero

	for _,v in pairs(char:GetChildren()) do
		if v:IsA("BasePart") then
			v.CanCollide = true
		end
	end
end

local function getClosestPart()
	local char = getChar()
	local hrp = char:WaitForChild("HumanoidRootPart")

	local d1 = (hrp.Position - part1.Position).Magnitude
	local d2 = (hrp.Position - part2.Position).Magnitude
	local d3 = (hrp.Position - part3.Position).Magnitude

	if d1 <= d2 and d1 <= d3 then
		return 1
	elseif d2 <= d1 and d2 <= d3 then
		return 2
	else
		return 3
	end
end

-- =====================
-- ปุ่ม Teleport Last zone
-- =====================
 MySection:AddButton({
	Title = "Teleport Last zone",
	Callback = function()
		if flying then return end
		flying = true

		local start = getClosestPart()

		if start == 1 then
			flyTo(part1)
			flyTo(part2)
			flyTo(part3)
		elseif start == 2 then
			flyTo(part2)
			flyTo(part3)
		else
			flyTo(part3)
		end

		restore()
		flying = false
	end,
})

-- =====================
-- ปุ่ม Return to base
-- =====================
 MySection:AddButton({
	Title = "Return to base",
	Callback = function()
		if flying then return end
		flying = true

		local start = getClosestPart()

		if start == 3 then
			flyTo(part3)
			flyTo(part2)
			flyTo(part1)
		elseif start == 2 then
			flyTo(part2)
			flyTo(part1)
		else
			flyTo(part1)
		end

		restore()
		flying = false
	end,
})

-- [[ ส่วนบินแบบ 2-in-1 (ฉบับแก้ไขพิกัดครบ 9 โซนให้น้องหนึ่ง) ]]
local StartPos = CFrame.new(151.81601, -1.90734863e-06, -139.729675, 1,0,0,0,1,0,0,0,1)

local ZoneWarp = WarpTab:AddDropdown("ZoneWarpDropdown", {
    Title = "บินแบบ 2-in-1 (จุดพัก -> จุดฟาร์ม)",
    Values = {"ปิด", "โซน 1", "โซน 2", "โซน 3", "โซน 4", "โซน 5", "โซน 6", "โซน 7", "โซน 8", "โซน 9"},
    Multi = false,
    Default = "ปิด",
})

ZoneWarp:OnChanged(function(Value)
    if Value == "ปิด" then return end
    
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local FinalTarget = nil

    -- [[ 1. เช็คเงื่อนไขตามที่น้องเลือก (แก้ไข elseif ให้ถูกต้อง) ]]
    if Value == "โซน 1" then
        FinalTarget = CFrame.new(202.15524291992188, -2.5115811824798584, -128.19207763671875)
    elseif Value == "โซน 2" then
        FinalTarget = CFrame.new(289.88079833984375, -2.5115811824798584, -129.25599670410156)
    elseif Value == "โซน 3" then
        FinalTarget = CFrame.new(403.9981994628906, -2.5115814208984375, -129.32992553710938)
    elseif Value == "โซน 4" then
        FinalTarget = CFrame.new(547.9777221679688, -2.5115811824798584, -129.37744140625)
    elseif Value == "โซน 5" then
        FinalTarget = CFrame.new(761.9934692382812, -2.5115859508514404, -129.50311279296875)
    elseif Value == "โซน 6" then
        FinalTarget = CFrame.new(1083.3145751953125, -2.5115880966186523, -129.501953125)
    elseif Value == "โซน 7" then
        FinalTarget = CFrame.new(1573.9476318359375, -2.511582851409912, -129.50994873046875)
    elseif Value == "โซน 8" then
        FinalTarget = CFrame.new(2276.26221, -5.99998856, -126.776489,1,0,0,0,1,0,0,0,1)
    elseif Value == "โซน 9" then
        FinalTarget = CFrame.new(2632.862060546875, -2.511453628540039, -129.5018310546875)
    end

    -- [[ 2. เริ่มกระบวนการบินถ้ามีเป้าหมาย ]]
    if FinalTarget then
        -- ปิดการชนกันเพื่อให้บินไม่ติดขัด
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end

        -- STEP 1: บินไปจุดเริ่มต้นก่อน
        local dist1 = (hrp.Position - StartPos.Position).Magnitude
        local tween1 = TweenService:Create(hrp, TweenInfo.new(dist1 / _G.FlySpeed, Enum.EasingStyle.Linear), {CFrame = StartPos})
        tween1:Play()
        tween1.Completed:Wait()
        
        task.wait(0.2) 

        -- STEP 2: บินต่อไปที่โซนเป้าหมาย
        local dist2 = (hrp.Position - FinalTarget.Position).Magnitude
        local tween2 = TweenService:Create(hrp, TweenInfo.new(dist2 / _G.FlySpeed, Enum.EasingStyle.Linear), {CFrame = FinalTarget})
        tween2:Play()
        tween2.Completed:Wait()

        -- เปิดการชนกันกลับมาเหมือนเดิม
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end

    -- พอถึงที่หมายแล้ว ให้ Dropdown กลับเป็นคำว่า "ปิด"
    task.wait(0.1)
    ZoneWarp:SetValue("ปิด")
end)

local ZoneSection = WarpTab:AddSection("วาร์ปด่วน (แวะจุดเริ่มทุกครั้ง)")

-- [[ 1. ฟังก์ชันสร้างบล็อก (แบนและใส่ Matrix ทิศทาง) ]]
local function GetOrCreatePart(name, cf)
    local existing = workspace:FindFirstChild(name)
    if existing then 
        existing.CFrame = cf 
        return existing 
    end
    local p = Instance.new("Part", workspace)
    p.Name = name
    p.Size = Vector3.new(12, 0.1, 12)
    p.Anchored = true
    p.CanCollide = true
    p.Transparency = 0.5
    p.Color = Color3.fromRGB(0, 255, 255)
    p.CFrame = cf
    return p
end

-- [[ 2. ประกาศจุดวาร์ปพร้อมค่า Matrix 1,0,0,0,1,0,0,0,1 ]]
local P_Start = GetOrCreatePart("N_Start", CFrame.new(151.816, -2.5, -139.729, 1,0,0,0,1,0,0,0,1))
local P_Zone1 = GetOrCreatePart("N_Z1", CFrame.new(205.999, -5.50, -129.404, 1,0,0,0,1,0,0,0,1))
local P_Zone2 = GetOrCreatePart("N_Z2", CFrame.new(290.003, -5.999, -129.020, 1,0,0,0,1,0,0,0,1))
local P_Zone3 = GetOrCreatePart("N_Z3", CFrame.new(404.000, -5.999, -129.401, 1,0,0,0,1,0,0,0,1))
local P_Zone4 = GetOrCreatePart("N_Z4", CFrame.new(548.003, -5.999, -129.505, 1,0,0,0,1,0,0,0,1))
local P_Zone5 = GetOrCreatePart("N_Z5", CFrame.new(761.999, -5.999, -129.507, 1,0,0,0,1,0,0,0,1))
local P_Zone6 = GetOrCreatePart("N_Z6", CFrame.new(1083.738, -5.999, -129.507, 1,0,0,0,1,0,0,0,1))
local P_Zone7 = GetOrCreatePart("N_Z7", CFrame.new(1574.001, -5.999, -129.509, 1,0,0,0,1,0,0,0,1))
local P_Zone8 = GetOrCreatePart("N_Z8", CFrame.new(2278.997, -5.999, -129.507, 1,0,0,0,1,0,0,0,1))
local P_Zone9 = GetOrCreatePart("N_Z9", CFrame.new(2634.006, -5.999, -129.503, 1,0,0,0,1,0,0,0,1))

-- [[ 3. ฟังก์ชันหลักสำหรับปุ่มกด ]]
local function WarpTo(target)
    if flying then return end
    flying = true
    
    -- บังคับแวะจุดเริ่มก่อนทุกครั้ง
    flyTo(P_Start)
    task.wait(0.1) -- คูลดาวน์ตามสั่ง
    
    -- บินไปจุดเป้าหมาย
    flyTo(target)
    
    restore()
    flying = false
end

-- [[ 4. สร้างปุ่มกดแยกโซน (1-9) ]]
for i = 1, 9 do
    local targetPart = _G["P_Zone"..i] -- ดึงตัวแปรที่สร้างไว้ด้านบนมาใช้
    -- หมายเหตุ: เพื่อความชัวร์ พี่เขียนแยกปุ่มให้เลยแบบแมนนวลน้องจะเข้าใจง่ายกว่าครับ
end

-- พี่เขียนแยกปุ่มให้เลยนะครับ น้องหนึ่งจะได้รับไปวางได้เลย
ZoneSection:AddButton({ Title = "วาร์ป โซน 1", Callback = function() WarpTo(P_Zone1) end })
ZoneSection:AddButton({ Title = "วาร์ป โซน 2", Callback = function() WarpTo(P_Zone2) end })
ZoneSection:AddButton({ Title = "วาร์ป โซน 3", Callback = function() WarpTo(P_Zone3) end })
ZoneSection:AddButton({ Title = "วาร์ป โซน 4", Callback = function() WarpTo(P_Zone4) end })
ZoneSection:AddButton({ Title = "วาร์ป โซน 5", Callback = function() WarpTo(P_Zone5) end })
ZoneSection:AddButton({ Title = "วาร์ป โซน 6", Callback = function() WarpTo(P_Zone6) end })
ZoneSection:AddButton({ Title = "วาร์ป โซน 7", Callback = function() WarpTo(P_Zone7) end })
ZoneSection:AddButton({ Title = "วาร์ป โซน 8", Callback = function() WarpTo(P_Zone8) end })
ZoneSection:AddButton({ Title = "วาร์ป โซน 9", Callback = function() WarpTo(P_Zone9) end })
                                            --ตอนนี้เหลือแก้วิธีบินนะจ๋ะ
