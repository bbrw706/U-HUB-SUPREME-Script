local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
math.randomseed(tick())

local Window = Fluent:CreateWindow({
    Title = "U-HUB SUPREME ",
    SubTitle = "BY Neung",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.U 
})

-- [[ ระบบลากหน้าต่าง Fluent สำหรับมือถือ ]]
task.spawn(function()
    local Gui = game.CoreGui:WaitForChild("Fluent")
    local MainFrame = Gui:FindFirstChild("Main", true)
    if MainFrame then
        local dragging, dragStart, startPos
        MainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = MainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
end)

-- [[ ฟังก์ชันจัดการโลโก้สลับตำแหน่ง (U/N Hybrid Drag) ]]
local function SetupLogoV50(MainBtn)
    local Container = Instance.new("Frame", MainBtn)
    Container.Size = UDim2.new(1, 0, 1, 0); Container.BackgroundTransparency = 1; Container.ClipsDescendants = true
    for i = 1, 15 do
        local d = Instance.new("Frame", Container)
        d.Size = UDim2.new(0, 1, 0, 1); d.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        d.Position = UDim2.new(math.random(), 0, math.random(), 0); d.BackgroundTransparency = 0.5
        task.spawn(function()
            while task.wait(math.random(2, 4)) do
                TweenService:Create(d, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
                task.wait(1.2)
                TweenService:Create(d, TweenInfo.new(1), {BackgroundTransparency = 0.4}):Play()
            end
        end)
    end
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

-- [[ ปุ่มลอยจัดการ Input ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainBtn = Instance.new("Frame", ScreenGui)
MainBtn.Size = UDim2.new(0, 60, 0, 60); MainBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
MainBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); MainBtn.ClipsDescendants = true; MainBtn.Active = true
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

-- [[ สร้าง Tabs แยกไว้หน้าตาแบบยาวๆ ]]
local Tabs = {
    Main = Window:AddTab({ Title = "Home / หน้าหลัก", Icon = "home" }),
    Farm = Window:AddTab({ Title = "Auto Fly / บินวน", Icon = "map" }),
    Settings = Window:AddTab({ Title = "Settings / ตั้งค่า", Icon = "settings" })
}


_G.FlySequence = false

Tabs.Farm:AddToggle("TsunamiFly400", {
    Title = "ไปออโต้ (Speed 400)",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.FlySequence = Value
        if Value then
            task.spawn(function()
                local Locations = {
                    Vector3.new(197.34, -2.41, -94.93), Vector3.new(286.41, -2.41, 21.26),
                    Vector3.new(399.71, -2.41, 118.11), Vector3.new(540.42, -2.41, 15.88),
                    Vector3.new(756.99, -2.41, 2.76), Vector3.new(1074.24, -2.41, -10.50),
                    Vector3.new(1553.90, -2.41, -106.57), Vector3.new(2245.50, -2.41, -19.42),
                    Vector3.new(2600.67, -2.41, -14.11)
                }
                while _G.FlySequence do
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and char.Humanoid.Health > 0 then
                        for i = 1, #Locations do
                            if not _G.FlySequence or char.Humanoid.Health <= 0 then break end
                            local targetPos = Locations[i]
                            local root = char.HumanoidRootPart
                            local dist = (root.Position - targetPos).Magnitude
                            
                            if dist > 5 then
                                local tween = game:GetService("TweenService"):Create(root, TweenInfo.new(dist/400, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
                                tween:Play()
                                repeat task.wait() 
                                    if not _G.FlySequence then tween:Cancel() break end
                                until (root.Position - targetPos).Magnitude < 7 or char.Humanoid.Health <= 0
                            end
                            if _G.FlySequence then task.wait(0.5) end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})


-- [[ 1. ตั้งค่าเริ่มต้น ]]
local FlySpeed = 400 -- ค่าเริ่มต้นตามที่มึงสั่ง
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

-- [[ 2. สร้าง Slider ปรับความเร็ว ]]
local SpeedSlider = Tabs.Settings:AddSlider("FlySpeedSlider", {
    Title = "ปรับความเร็วการบิน",
    Description = "ค่าเริ่มต้น 400 (ระวังโดนเตะถ้าเร็วไปสัด)",
    Default = 400,
    Min = 100,
    Max = 1000,
    Rounding = 0, -- เอาเลขกลมๆ
    Callback = function(Value)
        FlySpeed = Value
    end
})

-- [[ 3. Dropdown พร้อมระบบบินตามความเร็ว Slider ]]
local SelectPoint = Tabs.Farm:AddDropdown("WarpDropdown", {
    Title = "วาร์ปไปจุดที่เลือก",
    Values = {"ปิด","จุดที่ 1", "จุดที่ 2", "จุดที่ 3", "จุดที่ 4", "จุดที่ 5", "จุดที่ 6", "จุดที่ 7", "จุดที่ 8", "จุดที่ 9"},
    Multi = false,
    Default = "ปิด",
})

SelectPoint:OnChanged(function(Value)
    if Value == "ปิด" then return end
    
    local targetPos = Locations[Value]
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        local dist = (root.Position - targetPos).Magnitude
        
        -- ใช้ FlySpeed จาก Slider มาคำนวณเวลาบิน
        local tween = game:GetService("TweenService"):Create(root, TweenInfo.new(dist/FlySpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
        tween:Play()
        
        task.spawn(function()
            tween.Completed:Wait()
            task.wait(0.1)
            SelectPoint:SetValue("ปิด")
        end)
    end
end)


-- [[ 1. พิกัดโซน 1-9 (จุดที่มึงจะบินกลับมาพัก) ]]
local Zones = {
    ["โซน 1"] = Vector3.new(197.34, -2.51, -94.93),
    ["โซน 2"] = Vector3.new(286.41, -2.51, 21.26),
    ["โซน 3"] = Vector3.new(399.71, -2.51, 118.11),
    ["โซน 4"] = Vector3.new(540.42, -2.51, 15.88),
    ["โซน 5"] = Vector3.new(756.99, -2.51, 2.76),
    ["โซน 6"] = Vector3.new(1074.24, -2.51, -10.50),
    ["โซน 7"] = Vector3.new(1553.90, -2.51, -106.57),
    ["โซน 8"] = Vector3.new(2245.50, -2.51, -19.42),
    ["โซน 9"] = Vector3.new(2600.67, -2.51, -14.11)
}

local SelectedZone = "โซน 1"

-- [[ 2. ฟังก์ชันหาของ "อะไรก็ได้" ที่อยู่ในรัศมีโซน ]]
local function GetAnyInZone(zonePos)
    local target = nil
    local scanRadius = 350 -- ปรับรัศมีวงกว้างของโซนได้ตรงนี้สัด

    for _, v in pairs(workspace:GetChildren()) do
        pcall(function()
            -- เช็คว่ามันเป็น Object ที่มีพิกัด (Part หรือ Model)
            local pos = (v:IsA("BasePart") and v.Position) or (v:FindFirstChildOfClass("Part") and v:FindFirstChildOfClass("Part").Position)
            
            if pos then
                -- เช็คว่าไอเทมนี้อยู่ในโซนที่เราเลือกมั้ย
                local distFromZone = (pos - zonePos).Magnitude
                if distFromZone <= scanRadius then
                    target = v -- เจอตัวแรกในเขตโซน เอาตัวนี้เลยสัด!
                    return
                end
            end
        end)
        if target then break end -- ถ้าเจอแล้วหยุดลูปทันที จะได้ไวๆ
    end
    return target
end

-- [[ 3. Dropdown เลือกโซนประจำการ ]]
local ZoneSelect = Tabs.Farm:AddDropdown("ZoneSelector", {
    Title = "เลือกโซนประจำการ",
    Values = {"โซน 1", "โซน 2", "โซน 3", "โซน 4", "โซน 5", "โซน 6", "โซน 7", "โซน 8", "โซน 9"},
    Default = "โซน 1",
})

ZoneSelect:OnChanged(function(Value)
    SelectedZone = Value
end)

-- [[ 4. ปุ่มฉกของในโซนแบบเน้นไว ]]
Tabs.Farm:AddButton({
    Title = "ฉกของที่ใกล้ที่สุดในโซน -> กลับจุดเดิม",
    Callback = function()
        local root = game.Players.LocalPlayer.Character.HumanoidRootPart
        local zonePos = Zones[SelectedZone]
        local speed = FlySpeed or 400

        if not root then return end

        -- 1. บินไปที่จุดประจำการของโซนนั้นก่อน
        local toZone = game:GetService("TweenService"):Create(root, TweenInfo.new((root.Position - zonePos).Magnitude/speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(zonePos)})
        toZone:Play()

        toZone.Completed:Connect(function()
            task.wait(0.1)
            -- 2. หาของอะไรก็ได้ในเขตโซน
            local target = GetAnyInZone(zonePos)

            if target then
                local targetPos = target:IsA("BasePart") and target.Position or target:FindFirstChildOfClass("Part").Position
                
                -- 3. บินไปฉกทันที
                local toTarget = game:GetService("TweenService"):Create(root, TweenInfo.new((root.Position - targetPos).Magnitude/speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
                toTarget:Play()

                toTarget.Completed:Connect(function()
                    task.wait(0.2) -- จังหวะเก็บ
                    -- 4. บินดีดกลับมาที่จุดเดิมในโซน
                    game:GetService("TweenService"):Create(root, TweenInfo.new((root.Position - zonePos).Magnitude/speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(zonePos)}):Play()
                end)
            else
                Fluent:Notify({Title = "U-HUB", Content = "โซนนี้ว่างเปล่า ไม่มีของให้ฉกเลยสัด!", Duration = 2})
            end
        end)
    end
})


-- [[ ฟังก์ชันสแกนหา Object ทุกอย่างที่อยู่ในโซนแบบละเอียด ]]
local function ForceFindTarget(zonePos)
    local target = nil
    local minDistance = 500 -- รัศมีวงกว้าง (ปรับเพิ่มได้สัด)
    
    -- ใช้ GetDescendants เพื่อหาของที่ซ่อนอยู่ใน Folder อีกที
    for _, v in pairs(workspace:GetDescendants()) do
        pcall(function()
            -- เช็คว่ามันเป็น Part หรือ Model ที่เรา "หยิบ" ได้
            if v:IsA("BasePart") or v:IsA("Model") then
                local pos = v:IsA("BasePart") and v.Position or v:FindFirstChildOfClass("Part").Position
                
                if pos then
                    local distFromZone = (pos - zonePos).Magnitude
                    -- ถ้ามันอยู่ในเขตโซน และ ไม่ใช่ตัวเราเอง
                    if distFromZone < minDistance and not v:IsDescendantOf(game.Players.LocalPlayer.Character) then
                        -- เน้นตัวที่มีชื่อว่า Berry หรือมี Value ข้างใน (มึงแก้ชื่อเบนรอดตรงนี้ถ้ามึงรู้ชื่อจริงมัน)
                        if v.Name:find("Berry") or v:FindFirstChildOfClass("ValueBase") or v.Name:find("เบนรอด") then
                            target = v
                            return
                        end
                    end
                end
            end
        end)
        if target then break end
    end
    return target
end

-- [[ ปุ่มกด: พุ่งไปฉก -> ดีดกลับ ]]
Tabs.Farm:AddButton({
    Title = "บังคับบินไปหยิบเบนรอด -> กลับจุดเดิม",
    Callback = function()
        local root = game.Players.LocalPlayer.Character.HumanoidRootPart
        local homePos = Zones[SelectedZone] -- จุดที่มึงเลือกใน Dropdown
        local speed = FlySpeed or 400

        if not root or not homePos then return end

        -- สแกนหาเป้าหมาย
        local target = ForceFindTarget(homePos)

        if target then
            local targetPos = target:IsA("BasePart") and target.Position or target:FindFirstChildOfClass("Part").Position
            
            -- บินไปฉก
            local toTarget = game:GetService("TweenService"):Create(root, TweenInfo.new((root.Position - targetPos).Magnitude/speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
            
            Fluent:Notify({Title = "U-HUB", Content = "เจอแล้วสัด! กำลังพุ่งไปที่: " .. target.Name, Duration = 2})
            toTarget:Play()

            toTarget.Completed:Connect(function()
                task.wait(0.5) -- จังหวะเก็บ (เพิ่มเวลาให้มันเก็บติดหน่อย)
                -- บินกลับมาที่เดิม
                game:GetService("TweenService"):Create(root, TweenInfo.new((root.Position - homePos).Magnitude/speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(homePos)}):Play()
            end)
        else
            Fluent:Notify({Title = "Error", Content = "โค้ดยังมองไม่เห็นเบนรอดในโซนนี้เลยสัด!", Duration = 3})
        end
    end
})
