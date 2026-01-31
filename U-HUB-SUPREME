-- [[ U-HUB SUPREME  ]]


local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
math.randomseed(tick())
local CurrentSize = UDim2.fromOffset(580, 460) -- ค่าเริ่มต้นกลาง
-- [[ 1. SETTINGS CORE - ครบถ้วนตามต้นฉบับ ]]
_G.U_HUB_CORE = {
    AutoLockNoClick = false, 
    AimPart = "Head",
    Sensitivity = 0.05,
    FovEnabled = true,
    FovRadius = 150,
    LockMode = "Normal (ระยะสายตา)",
    EspStyle = "ปิด",
    SharedColor = Color3.fromRGB(255, 0, 0),
    PovColor = Color3.fromRGB(255, 255, 255),
    ShowName = false,
    ShowDistance = false,
    MyCustomTextColor = Color3.fromRGB(255, 255, 255),
    MaxLockDistance = 1000,
    MaxEspDistance = 1500,
    ShowFOV = false
}

_G.MouseLockEnabled = false

-- [[ 2. สร้างหน้าต่างหลัก ]]
local Window = Fluent:CreateWindow({
    Title = "U-HUB SUPREME",
    SubTitle = "BY Neung",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.U 
})

-- [[ 3. ปุ่มลอยวิบวับ ]]
local function SetupLogoV50(MainBtn)
    local Container = Instance.new("Frame", MainBtn)
    Container.Size = UDim2.new(1, 0, 1, 0); Container.BackgroundTransparency = 1; Container.ClipsDescendants = true
    for i = 1, 15 do
        local d = Instance.new("Frame", Container)
        d.Size = UDim2.new(0, 1, 0, 1); d.BackgroundColor3 = Color3.fromRGB(255, 255, 255); d.Position = UDim2.new(math.random(), 0, math.random(), 0)
        task.spawn(function() while task.wait(math.random(2, 4)) do if not d then break end TweenService:Create(d, TweenInfo.new(1), {BackgroundTransparency = 1}):Play(); task.wait(1.2); TweenService:Create(d, TweenInfo.new(1), {BackgroundTransparency = 0.4}):Play() end end)
    end
    local function CreateChar(txt, color)
        local h = Instance.new("Frame", Container); h.Size = UDim2.new(1, 0, 1, 0); h.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", h); l.Text = txt; l.TextColor3 = color; l.Font = Enum.Font.GothamBold; l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
        task.spawn(function() while true do if not l then break end TweenService:Create(l, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Position = UDim2.new(0,0,0,2)}):Play(); task.wait(1.5); TweenService:Create(l, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Position = UDim2.new(0,0,0,-2)}):Play(); task.wait(1.5) end end)
        return h, l
    end
    local holderU, textU = CreateChar("U", Color3.fromRGB(0, 255, 100)); local holderN, textN = CreateChar("N", Color3.fromRGB(0, 170, 255))
    holderU.Position = UDim2.new(0,0,0,0); textU.TextSize = 35; holderN.Position = UDim2.new(-0.25,0,-0.25,0); textN.TextSize = 14
    return function(isMinimized)
        if isMinimized then TweenService:Create(holderU, TweenInfo.new(0.4), {Position = UDim2.new(0,0,0,0)}):Play(); textU.TextSize = 35; TweenService:Create(holderN, TweenInfo.new(0.4), {Position = UDim2.new(-0.25,0,-0.25,0)}):Play(); textN.TextSize = 14
        else TweenService:Create(holderN, TweenInfo.new(0.4), {Position = UDim2.new(0,0,0,0)}):Play(); textN.TextSize = 35; TweenService:Create(holderU, TweenInfo.new(0.4), {Position = UDim2.new(-0.25,0,-0.25,0)}):Play(); textU.TextSize = 14 end
    end
end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui); local MainBtn = Instance.new("Frame", ScreenGui)
MainBtn.Size = UDim2.new(0, 60, 0, 60); MainBtn.Position = UDim2.new(0.1, 0, 0.4, 0); MainBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); MainBtn.Active = true
Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(0, 12); local UpdateLogo = SetupLogoV50(MainBtn)

local dragging, dragStart, startPos, startTime
MainBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; startTime = tick(); dragStart = input.Position; startPos = MainBtn.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false
        if tick() - startTime < 0.25 then Window:Minimize(); task.wait(0.05); UpdateLogo(Window.Minimized) end end end)
    end
end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; MainBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- [[ 4. TABS ]]
local Tabs = { 
    Combat = Window:AddTab({ Title = "Combat", Icon = "target" }), 
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "ghost" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [[ COMBAT ]]
Tabs.Combat:AddToggle("AutoLock", {Title = "Auto Lock (ไม่ต้องกด)", Default = false}):OnChanged(function(Value) _G.U_HUB_CORE.AutoLockNoClick = Value end)
Tabs.Combat:AddToggle("MainLockSystem", {Title = "เปิดวงกลม + ล็อคปกติ", Default = false}):OnChanged(function(Value) _G.U_HUB_CORE.ShowFOV = Value; _G.MouseLockEnabled = Value end)
Tabs.Combat:AddSlider("Smooth", { Title = "Lock Speed", Default = 0.05, Min = 0.01, Max = 1, Rounding = 2, Callback = function(Value) _G.U_HUB_CORE.Sensitivity = Value end})
Tabs.Combat:AddDropdown("AimPartDropdown", { Title = "เลือกจุดที่จะล็อค", Values = {"Head", "HumanoidRootPart"}, Default = "Head", Callback = function(v) _G.U_HUB_CORE.AimPart = v end })
Tabs.Combat:AddDropdown("MouseSpecial", { Title = "โหมดความโหด", Values = {"Normal (ระยะสายตา)", "Hardcore (ล็อคโหด)"}, Default = "Normal (ระยะสายตา)", Callback = function(Value) _G.U_HUB_CORE.LockMode = Value end })

-- [[ VISUALS ]]
Tabs.Visuals:AddToggle("ShowFovBtn", {Title = "แสดงวงกลม POV", Default = true}):OnChanged(function(Value) _G.U_HUB_CORE.FovEnabled = Value end)
Tabs.Visuals:AddSlider("FOVSize", { Title = "POV Radius", Default = 150, Min = 50, Max = 800, Rounding = 0, Callback = function(Value) _G.U_HUB_CORE.FovRadius = Value end})
Tabs.Visuals:AddColorpicker("POVColor", {Title = "POV Color", Default = Color3.fromRGB(255, 255, 255)}):OnChanged(function(Value) _G.U_HUB_CORE.PovColor = Value end)

-- [[ ESP ]]
Tabs.ESP:AddDropdown("ESP_Style", { Title = "เลือกรูปแบบ ESP", Values = {"ปิด", "Normal (เส้นขอบ)", "Hardcore (เรืองแสง)"}, Default = "ปิด", Callback = function(Value) _G.U_HUB_CORE.EspStyle = Value end })
Tabs.ESP:AddColorpicker("MainColor", {Title = "เปลี่ยนสี ESP", Default = Color3.fromRGB(255, 0, 0)}):OnChanged(function(Value) _G.U_HUB_CORE.SharedColor = Value end)
Tabs.ESP:AddToggle("ShowName", {Title = "แสดงชื่อ", Default = false}):OnChanged(function(v) _G.U_HUB_CORE.ShowName = v end)
Tabs.ESP:AddToggle("ShowDist", {Title = "แสดงระยะ", Default = false}):OnChanged(function(v) _G.U_HUB_CORE.ShowDistance = v end)
Tabs.ESP:AddColorpicker("TextColor", {Title = "สีตัวอักษร", Default = Color3.fromRGB(255, 255, 255)}):OnChanged(function(v) _G.U_HUB_CORE.MyCustomTextColor = v end)

-- [[ SETTINGS ]]
Tabs.Settings:AddSlider("LockDistSlider", { Title = "ระยะการล็อคเป้า (เมตร)", Default = 1000, Min = 50, Max = 4500, Rounding = 0, Callback = function(v) _G.U_HUB_CORE.MaxLockDistance = v end})
Tabs.Settings:AddSlider("EspDistSlider", { Title = "ระยะ ESP (เมตร)", Default = 1500, Min = 50, Max = 10000, Rounding = 0, Callback = function(v) _G.U_HUB_CORE.MaxEspDistance = v end})
Tabs.Settings:AddButton({ Title = "ลบ เมนู", Callback = function() Window:Destroy(); ScreenGui:Destroy(); if _G.FOV_Circle then _G.FOV_Circle:Remove() end end })

if not _G.FOV_Circle then
    _G.FOV_Circle = Drawing.new("Circle")
    _G.FOV_Circle.Thickness = 1; _G.FOV_Circle.NumSides = 100; _G.FOV_Circle.Filled = false; _G.FOV_Circle.Visible = false
end

local function GetTarget(Point)
    local Target, Closest = nil, _G.U_HUB_CORE.FovRadius
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChildOfClass("Humanoid") and v.Character.Humanoid.Health > 0 then
            local Part = v.Character:FindFirstChild(_G.U_HUB_CORE.AimPart) or v.Character:FindFirstChild("Head") or v.Character:FindFirstChild("HumanoidRootPart")
            if Part then
                local Mag = (LocalPlayer.Character.HumanoidRootPart.Position - Part.Position).Magnitude
                if Mag <= _G.U_HUB_CORE.MaxLockDistance then
                    local Pos, OnScreen = Camera:WorldToViewportPoint(Part.Position)
                    if OnScreen then
                        local Dist = (Point - Vector2.new(Pos.X, Pos.Y)).Magnitude
                        if Dist < Closest then
                            if _G.U_HUB_CORE.LockMode == "Hardcore (ล็อคโหด)" then
                                Closest = Dist; Target = Part
                            else
                                local RayParams = RaycastParams.new()
                                RayParams.FilterType = Enum.RaycastFilterType.Exclude
                                RayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
                                local Result = workspace:Raycast(Camera.CFrame.Position, (Part.Position - Camera.CFrame.Position), RayParams)
                                if Result == nil or Result.Instance:IsDescendantOf(v.Character) then
                                    Closest = Dist; Target = Part
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return Target
end


RunService.RenderStepped:Connect(function()
    local MousePos = UserInputService:GetMouseLocation()
    local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    if _G.FOV_Circle then
        _G.FOV_Circle.Visible = (_G.U_HUB_CORE.ShowFOV or _G.U_HUB_CORE.AutoLockNoClick) and _G.U_HUB_CORE.FovEnabled
        _G.FOV_Circle.Radius = _G.U_HUB_CORE.FovRadius
        _G.FOV_Circle.Color = _G.U_HUB_CORE.PovColor
        _G.FOV_Circle.Position = _G.U_HUB_CORE.AutoLockNoClick and Center or MousePos
    end

    local LockTarget = nil
    if _G.U_HUB_CORE.AutoLockNoClick then
        LockTarget = GetTarget(Center)
    elseif _G.MouseLockEnabled then
        LockTarget = GetTarget(MousePos)
    end

    if LockTarget then
        local TargetCF = CFrame.new(Camera.CFrame.Position, LockTarget.Position)
        Camera.CFrame = Camera.CFrame:Lerp(TargetCF, _G.U_HUB_CORE.Sensitivity)
    end

    -- ESP SYSTEM
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            
          
            if dist <= _G.U_HUB_CORE.MaxEspDistance then
                local hl = player.Character:FindFirstChild("U_ESP")
                if _G.U_HUB_CORE.EspStyle ~= "ปิด" then
                    if not hl then hl = Instance.new("Highlight", player.Character); hl.Name = "U_ESP" end
                    hl.FillTransparency = (_G.U_HUB_CORE.EspStyle == "Hardcore (เรืองแสง)" and 0.5 or 1)
                    hl.OutlineColor = _G.U_HUB_CORE.SharedColor
                elseif hl then hl:Destroy() end
                
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local b = head:FindFirstChild("U_B")
                    if _G.U_HUB_CORE.ShowName or _G.U_HUB_CORE.ShowDistance then
                        if not b then
                            b = Instance.new("BillboardGui", head); b.Name = "U_B"; b.Size = UDim2.new(0,100,0,50); b.AlwaysOnTop = true; b.StudsOffset = Vector3.new(0,2,0)
                            local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.Font = "GothamBold"; l.TextSize = 14; l.OutlineAlpha = 1
                        end
                        b.TextLabel.Text = (_G.U_HUB_CORE.ShowName and player.Name or "") .. (_G.U_HUB_CORE.ShowDistance and "\n["..math.floor(dist).."m]" or "")
                        b.TextLabel.TextColor3 = _G.U_HUB_CORE.MyCustomTextColor
                    elseif b then b:Destroy() end
                end
            else
                -- ถ้าเกินระยะ ให้ลบ ESP ออก (เพื่อให้ Slider มันทำงานได้จริง)
                if player.Character:FindFirstChild("U_ESP") then player.Character.U_ESP:Destroy() end
                if player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("U_B") then player.Character.Head.U_B:Destroy() end
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

