-- [[ 🛡️ ระบบกันโดนเตะ (Anti-AFK) ]]       ตอนนี้ถึงการทำถึงบรรทัดที่ การปรับความสูงแล็คอุ๊อุ๊
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    print("U-HUB: กันโดนเตะให้แล้วนะคัฟ")
end)

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

-------------------------------------------------------------------------
-- [[ ส่วนนี้คือหน้าเปล่าที่หนึ่งต้องการครับ ]]
-------------------------------------------------------------------------


-- [[ EVADE SCRIPT: FLUENT VERSION - NO DELETIONS & ORGANIZED ]]


-- Sidebar line
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0,1,1,0)
SidebarLine.Position = UDim2.new(0,140,0,0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(60,60,60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Parent = game:GetService("CoreGui")

-- =================================================
-- 📑 ส่วนของแถบหน้าจอ (Tabs)
-- =================================================
local MainTab     = Window:AddTab({Title="เมนูหลัก", Icon="star"})
local TeleportTab = Window:AddTab({Title="เทเลพอร์ต", Icon="navigation"})
local FarmTab     = Window:AddTab({Title="เมนูฟาร์ม", Icon="component"})
local VisualsTab  = Window:AddTab({Title="มองต่างๆ", Icon="eye"})
local ExtraTab    = Window:AddTab({Title="ของเสริม", Icon="tag"})
local EventTab    = Window:AddTab({Title="เกี่ยวกับอีเว้น", Icon="calendar"}) -- แถบนี้แหละ!



-- [[ 🎫 ระบบ U-HUB Ticket Farm V.6 (ที่ยืนใหญ่ | สีขาวทึบ | วาร์ปตัวเปล่า) ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

getgenv().AutoTicketFarm = false
local whitePlatform = nil

-- [[ 🏗️ ฟังก์ชันจัดการที่ยืนสีขาวทึบ (ขนาดใหญ่ขึ้น) ]]
local function ManageWhitePlatform(state)
    if state then
        if not whitePlatform or not whitePlatform.Parent then
            whitePlatform = Instance.new("Part")
            whitePlatform.Name = "UHubWhitePlatform"
            whitePlatform.Size = Vector3.new(12, 1, 12) -- ขยายขนาดให้ใหญ่ขึ้นตามสั่ง!
            whitePlatform.Anchored = true
            whitePlatform.CanCollide = true
            whitePlatform.Color = Color3.new(1, 1, 1) -- สีขาวทึบ
            whitePlatform.Material = Enum.Material.SmoothPlastic
            whitePlatform.Transparency = 0 
            whitePlatform.Parent = workspace
        end
    else
        if whitePlatform then
            whitePlatform:Destroy()
            whitePlatform = nil
        end
    end
end

-- [[ 🎡 ปุ่ม Toggle ]]
FarmTab:AddToggle("UHubTicketToggle", {
    Title = "ฟาร์มโทเค้นท์",
    Description = "🔥วาร์ปไปเอาโทเค้นท์นะจ๊ะ🔥",
    Default = false,
    Callback = function(state)
        getgenv().AutoTicketFarm = state
        ManageWhitePlatform(state)
        
        if state then
            task.spawn(function()
                while getgenv().AutoTicketFarm do
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    
                    local ticketFolder = workspace:FindFirstChild("Game") 
                        and workspace.Game:FindFirstChild("Effects") 
                        and workspace.Game.Effects:FindFirstChild("Tickets")
                    
                    if hrp and ticketFolder then
                        local tickets = ticketFolder:GetChildren()
                        
                        -- [[ 🏠 จังหวะไม่มีตั๋ว: ให้ยืนบนที่ยืนขาวใหญ่บนฟ้า ]]
                        if #tickets == 0 then
                            if whitePlatform then 
                                whitePlatform.CFrame = CFrame.new(0, 1000, 0) -- ย้ายที่ยืนมารอ
                                hrp.CFrame = CFrame.new(0, 1003, 0) -- วาร์ปน้องลงบนที่ยืน
                            end
                        else
                            -- [[ 🎫 จังหวะเก็บตั๋ว: วาร์ปไปแค่ตัว (ไม่ต้องเอาที่ยืนไป) ]]
                            for _, ticket in ipairs(tickets) do
                                if not getgenv().AutoTicketFarm then break end
                                
                                local target = ticket:IsA("BasePart") and ticket or ticket:FindFirstChildWhichIsA("BasePart")
                                
                                if target and target.Parent then
                                    -- ย้ายที่ยืนหนีไปไกลๆ ก่อน (จะได้ไม่เกะกะตอนเก็บ)
                                    if whitePlatform then whitePlatform.CFrame = CFrame.new(0, -500, 0) end
                                    
                                    -- วาร์ปตัวน้องหนึ่งไปที่ตั๋วตรงๆ
                                    hrp.CFrame = CFrame.new(target.Position)
                                    hrp.Velocity = Vector3.new(0,0,0) -- ล็อคตัวให้นิ่งกลางอากาศแป๊บนึง
                                    
                                    task.wait(0.7) -- รอเก็บ
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
            
            Fluent:Notify({ Title = "U-HUB", Content = "ฟาร์มแบบวาร์ปตัวเปล่าเรียบร้อยครับน้องหนึ่ง! ⚪", Duration = 2 })
        else
            ManageWhitePlatform(false)
            Fluent:Notify({ Title = "U-HUB", Content = "ปิดระบบฟาร์มแล้ว ❌", Duration = 2 })
        end
    end
})

-- [[ 🧠 1. ตั้งค่าตัวแปรหลัก ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local interactEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Character"):WaitForChild("Interact")
local changeModeEvent = ReplicatedStorage:FindFirstChild("ChangePlayerMode", true)

_G.MasterFarm = false
local lastSavedPosition = nil
local afkPart = nil

-- [[ 🛠️ 2. ฟังก์ชันสมองกล ]]

local function isPlayerDowned(plr)
    if not plr or not plr.Character then return false end
    return plr.Character:GetAttribute("Downed") == true and plr.Character:GetAttribute("BeingCarried") ~= true
end

-- [[ 🔄 3. ระบบ Auto Respawn (ออโต้เกิด) ]]
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.MasterFarm and LocalPlayer.Character then
            local char = LocalPlayer.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")

            if hrp and not char:GetAttribute("Downed") then
                lastSavedPosition = hrp.Position
            end

            if char:GetAttribute("Downed") == true then
                task.wait(3) 
                if _G.MasterFarm then
                    if changeModeEvent then changeModeEvent:FireServer(true) end
                    local newChar = LocalPlayer.CharacterAdded:Wait()
                    local newHrp = newChar:WaitForChild("HumanoidRootPart", 5)
                    if newHrp and lastSavedPosition then
                        task.wait(0.5)
                        newHrp.CFrame = CFrame.new(lastSavedPosition)
                    end
                end
            end
        end
    end
end)


FarmTab:AddToggle("UHubTicketToggle", {
    Title = "🔥 ฟาร์มเงิน",
    Description = "วาร์ปติดตัวคนล้ม + รอ 2 วิวาร์ปกลับ",
    Default = false,
    Callback = function(state)
        _G.MasterFarm = state
        
        if state then
            if not afkPart then
                afkPart = Instance.new("Part", workspace)
                afkPart.Size = Vector3.new(12, 1, 12)
                afkPart.Position = Vector3.new(0, 6000, 0)
                afkPart.Anchored = true
                afkPart.Transparency = 0.5
            end

            task.spawn(function()
                while _G.MasterFarm do
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if hrp and not char:GetAttribute("Downed") then
                        local foundTarget = false
                        
                        for _, pl in ipairs(Players:GetPlayers()) do
                            if pl ~= LocalPlayer and isPlayerDowned(pl) then
                                local pChar = pl.Character
                                local pHrp = pChar and pChar:FindFirstChild("HumanoidRootPart")
                                
                                if pHrp then
                                    local dist = (hrp.Position - pHrp.Position).Magnitude
                                    
                                    -- 1. ระยะใกล้ (ชุบปกติ)
                                    if dist <= 15 then
                                        pcall(function() interactEvent:FireServer("Revive", true, pl.Name) end)
                                    
                                    -- 2. ระยะไกล (วาร์ปล็อกตัว)
                                    else
                                        foundTarget = true
                                        task.wait(2) -- รอ 3 วิ
                                        
                                        if _G.MasterFarm and isPlayerDowned(pl) and not char:GetAttribute("Downed") then
                                            -- [[ เริ่มระบบวาร์ปล็อกเป้าหมาย ]]
                                            local lockTime = tick()
                                            while tick() - lockTime < 2.5 do -- ล็อกตัวไว้ 2.5 วิ (รวมเวลาชุบและรอก่อนวาร์ปกลับ)
                                                if not isPlayerDowned(pl) or not _G.MasterFarm or char:GetAttribute("Downed") then break end
                                                
                                                -- วาร์ปไปตำแหน่งเพื่อนปัจจุบันแบบ Real-time
                                                hrp.CFrame = pHrp.CFrame + Vector3.new(0, 3, 0)
                                                
                                                -- ส่งคำสั่งชุบย้ำๆ
                                                interactEvent:FireServer("Revive", true, pl.Name)
                                                
                                                task.wait(0.05) -- วาร์ปติดตัวถี่ยิบ (กันหลุด)
                                            end
                                            
                                            -- หลังจากล็อกตัวครบแล้ว ให้รออีกนิดตามสั่ง (รวมใน Loop ล็อกตัวแล้ว)
                                            task.wait(0.5) 
                                            
                                            -- วาร์ปกลับฐาน
                                            if afkPart and _G.MasterFarm then
                                                hrp.CFrame = afkPart.CFrame + Vector3.new(0, 5, 0)
                                            end
                                        end
                                        break
                                    end
                                end
                            end
                        end
                        
                        if not foundTarget and afkPart then
                            if (hrp.Position - afkPart.Position).Magnitude > 25 then
                                hrp.CFrame = afkPart.CFrame + Vector3.new(0, 5, 0)
                            end
                        end
                    end
                    task.wait(0.3)
                end
                if afkPart then afkPart:Destroy() afkPart = nil end
            end)
        end
    end
})


-- [[ 🧠 1. ตั้งค่าตัวแปรหลัก ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local changeModeEvent = ReplicatedStorage:FindFirstChild("ChangePlayerMode", true)
_G.MasterAFK = false
local afkPart = nil

-- [[ 🔄 2. ระบบ Auto Respawn (เกิดใหม่แล้ววาร์ปกลับขึ้นฟ้า) ]]
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.MasterAFK and LocalPlayer.Character then
            local char = LocalPlayer.Character
            if char:GetAttribute("Downed") == true then
                task.wait(3) -- รอ 3 วิ
                if _G.MasterAFK then
                    if changeModeEvent then changeModeEvent:FireServer(true) end
                    
                    local newChar = LocalPlayer.CharacterAdded:Wait()
                    local newHrp = newChar:WaitForChild("HumanoidRootPart", 5)
                    
                    if newHrp and _G.MasterAFK then
                        task.wait(0.5)
                        newHrp.CFrame = CFrame.new(0, 6005, 0) -- เกิดแล้ววาร์ปกลับขึ้นฟ้าทันที
                    end
                end
            end
        end
    end
end)

FarmTab:AddToggle("UHubTicketToggle", {
    Title = "☁️ เปิดระบบยืน AFK บนฟ้า",
    Description = "ยืนบนฟ้าฟาร์มเวล+ฟาร์มเงิน+มีที่วิ่งเล่น",
    Default = false,
    Callback = function(state)
        _G.MasterAFK = state
        
        if state then
            -- สร้างฐาน AFK บนฟ้า (ห้ามลบตามสั่ง)
            if not afkPart then
                afkPart = Instance.new("Part", workspace)
                afkPart.Size = Vector3.new(300, 1, 300)
                afkPart.Position = Vector3.new(0, 6000, 0)
                afkPart.Anchored = true
                afkPart.Transparency = 0.5
                afkPart.Color = Color3.fromRGB(0, 255, 255)
                afkPart.Name = "UHub_AFK_Platform"
            end

            -- วาร์ปขึ้นฟ้าครั้งแรก
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(0, 6005, 0)
            end

            -- [[ 🛠️ ระบบกันตก: ถ้าตกจากฐานให้วาร์ปกลับไปจุดเริ่มบนฟ้า ]]
            task.spawn(function()
                while _G.MasterAFK do
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if root and _G.MasterAFK then
                        -- ถ้าค่า Y (ความสูง) ต่ำกว่า 5950 (ตกฐาน) ให้ดึงกลับไปที่กลางฐาน
                        if root.Position.Y < 5950 then
                            root.CFrame = CFrame.new(0, 6005, 0)
                        end
                    end
                    task.wait(0.5)
                end
            end)

            Fluent:Notify({Title = "U-HUB", Content = "เริ่มระบบ AFK บนฟ้า + กันตกร่วงเรียบร้อยครับน้องหนึ่ง!", Duration = 5})
        else
            -- ปิดระบบแล้วทำลายฐาน
            if afkPart then 
                afkPart:Destroy() 
                afkPart = nil 
            end
            Fluent:Notify({Title = "U-HUB", Content = "ปิดระบบ AFK เรียบร้อย", Duration = 5})
        end
    end
})

-- =========================
-- [ 1. สร้างแถบตั้งค่า ]
-- =========================
local SettingsTab = Window:AddTab({ Title = "ตั้งค่า", Icon = "settings" })

-- =========================
-- [ 2. ตัวแปรหลัก ]
-- =========================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local isPC = not UserInputService.TouchEnabled -- เช็คว่าเป็นคอมไหม

local currentSettings = {
    Speed = 1500,
    Jump = 3,
    JumpCap = 1,
    AirStrafeAcceleration = 187
}

-- =========================
-- [ 3. เงื่อนไขการค้นหา ]
-- =========================

-- เงื่อนไขที่ 1: สำหรับมือถือ (ของเดิม 13 ข้อ)
local mobileFields = {
    Friction=true, AirStrafeAcceleration=true, JumpHeight=true, RunDeaccel=true,
    JumpSpeedMultiplier=true, JumpCap=true, SprintCap=true, WalkSpeedMultiplier=true,
    BhopEnabled=true, Speed=true, AirAcceleration=true, RunAccel=true, SprintAcceleration=true
}

-- เงื่อนไขที่ 2: สำหรับคอม (เน้นตัวแปรหลักที่ PC Executor เข้าถึงง่าย)
local pcFields = { "Speed", "JumpCap", "AirStrafeAcceleration", "Friction" }

local function getMatchingTables()
    local matched = {}
    local success, allObjects = pcall(function() return getgc(true) end)
    if not success then return matched end

    for _, obj in pairs(allObjects) do
        if typeof(obj) == "table" then
            local ok = true
            
            if isPC then
                -- [[ เงื่อนไขสำหรับคอม ]]
                for _, field in ipairs(pcFields) do
                    if rawget(obj, field) == nil then ok = false break end
                end
            else
                -- [[ เงื่อนไขสำหรับมือถือ (เดิม) ]]
                for field in pairs(mobileFields) do
                    if rawget(obj, field) == nil then ok = false break end
                end
            end
            
            if ok then table.insert(matched, obj) end
        end
    end
    return matched
end

-- ฟังก์ชันอัปเดตค่า (อัปเดตไปที่ทุก Table ที่เจอ)
local function applyToTables()
    for _, tbl in ipairs(getMatchingTables()) do
        pcall(function()
            tbl.Speed = currentSettings.Speed
            tbl.JumpCap = currentSettings.JumpCap
            tbl.AirStrafeAcceleration = currentSettings.AirStrafeAcceleration
            if tbl.Jump ~= nil then 
                tbl.Jump = currentSettings.Jump 
            end
            if tbl.JumpHeight ~= nil then 
                tbl.JumpHeight = currentSettings.Jump 
            end
        end)
    end
end

-- =========================
-- [ 4. ระบบ Auto-Update (ทำงานตลอดเวลา) ]
-- =========================
task.spawn(function()
    while true do
        applyToTables()
        task.wait(1) -- เช็คทุก 1 วินาที
    end
end)

-- =========================
-- [ 5. ช่องพิมพ์ (Input) ]
-- =========================

SettingsTab:AddInput("SpeedInput", {
    Title = "Speed (" .. (isPC and "PC Mode" or "Mobile Mode") .. ")",
    Default = tostring(currentSettings.Speed),
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        currentSettings.Speed = tonumber(Value) or 1500
        applyToTables()
    end
})

SettingsTab:AddInput("JumpInput", {
    Title = "Jump",
    Default = tostring(currentSettings.Jump),
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        currentSettings.Jump = tonumber(Value) or 3
        applyToTables()
    end
})

SettingsTab:AddInput("JumpCapInput", {
    Title = "Jump Cap",
    Default = tostring(currentSettings.JumpCap),
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        currentSettings.JumpCap = tonumber(Value) or 1
        applyToTables()
    end
})

SettingsTab:AddInput("StrafeInput", {
    Title = "Strafe Acceleration",
    Default = tostring(currentSettings.AirStrafeAcceleration),
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        currentSettings.AirStrafeAcceleration = tonumber(Value) or 187
        applyToTables()
    end
})

-- Player & GUI
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Floating GUI
local FloatingGui = PlayerGui:FindFirstChild("EvadeFloatingGui") or Instance.new("ScreenGui", PlayerGui)
FloatingGui.Name = "EvadeFloatingGui"
FloatingGui.ResetOnSpawn = false

-- ฟังก์ชันแต่งปุ่มลอย (ฟ้า + โค้ง + โปร่งแสง)
local function StyleFloatingButton(btn)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.8
    stroke.Color = Color3.new(1,1,1)
    stroke.Transparency = 0.5
    stroke.Parent = btn
    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- สีฟ้า
    btn.BackgroundTransparency = 0.4 -- โปร่งแสง
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
end

-- =========================================
-- [ 1. เตรียม Section ]
-- =========================================
local BhopSection = MainTab:AddSection("ระบบกระโดด (Auto Bhop)")
local autoBhop = false
local bhopMode = "ออโต้เด้ง"
local floatingBhopButton

-- [ 2. ฟังก์ชันปุ่มลอย ]
local function createBhopFloatingButton()
    if floatingBhopButton then return end
    floatingBhopButton = Instance.new("TextButton", FloatingGui) -- ต้องมั่นใจว่ามีตัวแปร FloatingGui ในโค้ดหลักนะครับ
    floatingBhopButton.Size = UDim2.new(0,120,0,50)
    floatingBhopButton.Position = UDim2.new(0.3,-60,0.8,0)
    floatingBhopButton.Text = "Auto Bhop: OFF"
    floatingBhopButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
    floatingBhopButton.TextColor3 = Color3.fromRGB(255,255,255)
    floatingBhopButton.Draggable = true
    floatingBhopButton.Active = true
    floatingBhopButton.MouseButton1Click:Connect(function()
        autoBhop = not autoBhop
        floatingBhopButton.Text = autoBhop and "Auto Bhop: ON" or "Auto Bhop: OFF"
    end)
end

-- [ 3. สร้างปุ่มทั้งหมดในเมนู ]

-- 🟢 ปุ่มเปิด/ปิด ปกติ
BhopSection:AddToggle("AutoBhopToggle", {
    Title = "เปิดใช้งาน (Toggle)",
    Default = false,
    Callback = function(v) autoBhop = v end
})

-- 🔵 ปุ่มเปิด/ปิด แบบปุ่มลอย
BhopSection:AddToggle("AutoBhopFloat", {
    Title = "เปิดปุ่มลอย",
    Default = false,
    Callback = function(v)
        if v then 
            createBhopFloatingButton()
        else 
            if floatingBhopButton then 
                floatingBhopButton:Destroy()
                floatingBhopButton = nil 
            end 
        end
    end
})

-- ⌨️ ช่องตั้งค่าคีย์บอร์ด (Keybind)
BhopSection:AddKeybind("BhopKey", {
    Title = "ตั้งค่าปุ่มคีย์บอร์ด",
    Mode = "Toggle",
    Default = "B",
    Callback = function(v) autoBhop = v end
})

-- 🔽 ปุ่มเลือกโหมด (Dropdown)
BhopSection:AddDropdown("BhopMode", {
    Title = "เลือกโหมดการกระโดด",
    Values = {"ออโต้เด้ง", "กระโดดเหมือนคนกด"},
    Default = "ออโต้เด้ง",
    Callback = function(v) bhopMode = v end
})

-- [ 4. Loop หลัก (แก้ไขระบบกระโดดให้ใช้ในมือถือได้) ]
task.spawn(function()
    local RunService = game:GetService("RunService")
    local player = game.Players.LocalPlayer
    
    while true do
        RunService.Heartbeat:Wait()
        if autoBhop then
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if hum and root then
                -- เช็คว่าเท้าแตะพื้นหรือไม่
                local isGrounded = hum.FloorMaterial ~= Enum.Material.Air
                
                if isGrounded then
                    if bhopMode == "ออโต้เด้ง" then
                        -- โหมด 1: เปลี่ยนสถานะโดยตรง (กระโดดรัวและต่อเนื่อง)
                        hum.JumpHeight = 2.5
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    elseif bhopMode == "กระโดดเหมือนคนกด" then
                        -- โหมด 2: สั่งให้ Humanoid กระโดดเอง (เหมือนกดปุ่ม Jump บนมือถือ)
                        -- วิธีนี้ปุ่มจะไม่หาย และใช้งานบนโทรศัพท์ได้ 100%
                        hum.Jump = true
                    end
                end
            end
        end
    end
end)

                  

-- =========================================
-- [ 2. เมนูหลัก: AUTO BOUNCE ]
-- =========================================
local BounceSection = MainTab:AddSection("ระบบเด้ง (Auto Bounce)")
local autoBounce = false
local floatingBounceButton
local bouncePower = 100
local groundCheckDistance = 6

local function createBounceFloatingButton()
    if floatingBounceButton then return end
    floatingBounceButton = Instance.new("TextButton", FloatingGui)
    floatingBounceButton.Size = UDim2.new(0,100,0,50)
    floatingBounceButton.Position = UDim2.new(0.5,-50,0.85,0)
    floatingBounceButton.AnchorPoint = Vector2.new(0.5,0)
    floatingBounceButton.Text = "Bounce: OFF"
    floatingBounceButton.Active = true
    floatingBounceButton.Draggable = true
    StyleFloatingButton(floatingBounceButton)
    floatingBounceButton.MouseButton1Click:Connect(function()
        autoBounce = not autoBounce
        floatingBounceButton.Text = autoBounce and "Bounce: ON" or "Bounce: OFF"
    end)
end

BounceSection:AddToggle("BounceToggle", {Title="ออโต้เด้ง (ปกติ)", Default=false, Callback=function(v) autoBounce = v end})
BounceSection:AddToggle("BounceFloat", {Title="ออโต้เด้ง (ปุ่มลอย)", Default=false, Callback=function(v)
    if v then createBounceFloatingButton() else if floatingBounceButton then floatingBounceButton:Destroy() floatingBounceButton=nil end end
end})
BounceSection:AddKeybind("BounceKey", {Title="ตั้งค่าปุ่มคีย์บอร์ด", Mode="Toggle", Default="V", Callback=function(v) autoBounce = v end})

task.spawn(function()
    while true do
        if autoBounce then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and root.Velocity.Y < 0 then
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {char}
                local ray = workspace:Raycast(root.Position, Vector3.new(0, -groundCheckDistance, 0), raycastParams)
                if ray then root.Velocity = Vector3.new(root.Velocity.X, bouncePower, root.Velocity.Z) end
            end
        end
        task.wait(0.03)
    end
end)

-- =========================================
-- [ 3. เมนูหลัก: LAG SWITCH ]
-- =========================================
local LagSection = MainTab:AddSection("ระบบกระตุก (Lag Switch)")
local UIS = game:GetService("UserInputService")
local floatingLagButton
local isLagging = false 
local lagKey = Enum.KeyCode.Z -- ตั้งค่าปุ่มเริ่มต้น
local lagMode = "ปกติ" -- ค่าเริ่มต้น
local jumpPowerValue = 50 -- ค่าความสูงเริ่มต้น

-- [[ ฟังก์ชันแลค (ปรับปรุงให้รองรับโหมดเด้งและเดินทะลุสำหรับปุ่มลอย) ]]
local function lagSwitch(duration)
    task.spawn(function()
        local start = tick()
        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        while tick() - start < duration do 
            -- ระบบเดินทะลุขณะแลค
            if char then
                for _, v in pairs(char:GetChildren()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
            
            -- แก้บัคปุ่มลอย: เช็คโหมดถ้าเป็น "เด้งสูง" ให้เด้งด้วย
            if lagMode == "เด้งสูง" and hrp then
                hrp.Velocity = Vector3.new(0, jumpPowerValue, 0)
            end

            for i = 1, 1e6 do local a = math.random() end 
            task.wait()
        end
        
        -- คืนค่าการชน
        if char then
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end)
end

-- [[ ระบบจับสัญญาณคีย์บอร์ดโดยตรง (UIS) ]]
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == lagKey then
        isLagging = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == lagKey then
        isLagging = false
    end
end)

-- [[ 🔄 ลูปเบื้องหลัง: แก้บัคเด้งค้าง + เดินทะลุ (สำหรับกดค้าง) ]]
task.spawn(function()
    while true do
        if isLagging then
            local char = game.Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                -- เดินทะลุขณะกดค้าง
                for _, v in pairs(char:GetChildren()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end

                -- แก้บัค: เช็คโหมดก่อนเด้ง (ถ้าเป็น "ปกติ" จะไม่เด้งแล้ว)
                if lagMode == "เด้งสูง" then
                    hrp.Velocity = Vector3.new(0, jumpPowerValue, 0)
                end
            end

            for i = 1, 1e6 do local a = math.random() end
        else
            -- คืนค่าการชนเมื่อปล่อยปุ่ม
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, v in pairs(char:GetChildren()) do
                    if v:IsA("BasePart") then v.CanCollide = true end
                end
            end
        end
        task.wait()
    end
end)

-- [[ ระบบปุ่มลอย ]]
local function createLagFloatingButton()
    if floatingLagButton then return end
    floatingLagButton = Instance.new("TextButton", FloatingGui)
    floatingLagButton.Size = UDim2.fromOffset(100, 50)
    floatingLagButton.Position = UDim2.new(0.7,-50,0.8,0)
    floatingLagButton.AnchorPoint = Vector2.new(0.5,0)
    floatingLagButton.Text = "Lag Switch"
    floatingLagButton.Active = true
    floatingLagButton.Draggable = true
    StyleFloatingButton(floatingLagButton)
    
    floatingLagButton.MouseButton1Click:Connect(function() 
        lagSwitch(0.5) 
    end)
end

-- [[ UI Elements ]]
LagSection:AddButton({
    Title = "Lag Switch (กดครั้งเดียว)", 
    Callback = function() lagSwitch(0.5) end
})

LagSection:AddToggle("LagFloatToggle", {
    Title = "Lag Switch (ปุ่มลอย)", 
    Default = false, 
    Callback = function(v)
        if v then createLagFloatingButton() else 
            if floatingLagButton then floatingLagButton:Destroy() floatingLagButton = nil end 
        end
    end
})

local LagKeybind = LagSection:AddKeybind("LagKey", {
    Title = "ตั้งค่าปุ่มคีย์บอร์ด", 
    Mode = "Hold", 
    Default = "Z", 
    Callback = function(Value) end,
    ChangedCallback = function(New)
        lagKey = New 
    end
})

LagSection:AddDropdown("LagModeDropdown", {
    Title = "เลือกโหมดการแลค",
    Values = {"ปกติ", "เด้งสูง"},
    Multi = false,
    Default = "ปกติ",
    Callback = function(Value)
        lagMode = Value
        Fluent:Notify({Title = "U-HUB", Content = "เปลี่ยนเป็นโหมด: " .. Value, Duration = 2})
    end
})

LagSection:AddDropdown("JumpHeightDropdown", {
    Title = "เลือกความสูงในการดีด",
    Description = "เลือกความแรงตามสถานการณ์",
    Values = {"เริ่มต้น", "กลาง", "สูง"},
    Default = "เริ่มต้น",
    Callback = function(Value)
        if Value == "เริ่มต้น" then jumpPowerValue = 50
        elseif Value == "กลาง" then jumpPowerValue = 70
        elseif Value == "สูง" then jumpPowerValue = 100 end
        Fluent:Notify({Title = "U-HUB", Content = "ปรับความสูงเป็น: " .. Value, Duration = 1.5})
    end
})

-- [[ 🔄 ลูปเบื้องหลัง (เวอร์ชันแก้บัคเด้งค้าง + เดินทะลุ) ]]
task.spawn(function()
    while true do
        if isLagging then
            local char = game.Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                -- [[ 🛰️ ระบบเดินทะลุ (NoClip) ]]
                -- สั่งให้ร่างกายเดินทะลุสิ่งกีดขวางขณะกดแลค
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end

                -- [[ 🚀 แก้บัค: เช็คโหมดก่อนสั่งเด้ง ]]
                -- จะเด้งเฉพาะตอนเลือกโหมด "เด้งสูง" เท่านั้น
                if lagMode == "เด้งสูง" then
                    hrp.Velocity = Vector3.new(0, jumpPowerValue, 0)
                end
            end

            -- ทำให้เครื่องแลค (Lag Switch) ตามโค้ดเดิมน้องหนึ่ง
            for i = 1, 1e6 do local a = math.random() end
        else
            -- [[ 🛑 คืนค่าการชนเมื่อเลิกแลค ]]
            -- ป้องกันน้องหนึ่งตกแมพเมื่อปล่อยปุ่ม
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
        task.wait()
    end
end)
-------------------------------------------------------------------------
-- [[ ✅ แก้ไขระบบวาร์ปมั่ว: ล็อคตำแหน่งให้แม่นยำที่สุด ]]
-------------------------------------------------------------------------

-- 1. สร้าง Section ใน MainTab
local RespawnSection = MainTab:AddSection("ที่ออโต้เกิดนะจ๊ะเบบี๋😘😘")

-- 2. ตัวแปรสำหรับระบบเกิดใหม่
getgenv().AutoRespawnEnabled = false 
local lastSavedPosition = nil
local LocalPlayer = game:GetService("Players").LocalPlayer

-- 3. ปุ่ม Toggle
RespawnSection:AddToggle("RespawnToggle", {
    Title = "ออโต้รีสปอน (Auto Revive)", 
    Default = false, 
    Callback = function(v) 
        getgenv().AutoRespawnEnabled = v 
    end
})

-- 4. Dropdown วิธีรีสปอน (คงไว้ตามเดิม)
RespawnSection:AddDropdown("RespawnMethod", {
    Title = "วิธีรีสปอน", 
    Values = {"Random", "Fake Revive"}, 
    CurrentValue = "Fake Revive", 
    Callback = function(v) 
        autoRespawnMethod = v 
    end
})

-- 5. สมองของระบบ (แบบแก้บัควาร์ปมั่ว)
local function setupAutoRevive(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if not hrp or not humanoid then return end

    -- [[ 🛰️ บันทึกตำแหน่งเฉพาะตอนที่ "ยังไม่ล้ม" เท่านั้น ]]
    task.spawn(function()
        while character and character.Parent and hrp and hrp.Parent do
            -- เช็ค: ต้องไม่ล้ม (Downed ~= true) และเลือดต้องมากกว่า 0 และไม่ได้อยู่ในสถานะร่วง
            if character:GetAttribute("Downed") ~= true and humanoid.Health > 0 then
                lastSavedPosition = hrp.CFrame
            end
            task.wait(0.2) -- บันทึกถี่ขึ้นเล็กน้อยเพื่อให้ตำแหน่งล่าสุดจริงๆ
        end
    end)

    -- [[ 🔄 เช็คตอนล้มแล้วสั่งเกิดใหม่ ]]
    character:GetAttributeChangedSignal("Downed"):Connect(function()
        if not getgenv().AutoRespawnEnabled or character:GetAttribute("Downed") ~= true then return end
        
        -- ล็อคตำแหน่งไว้ทันทีที่ล้ม (ห้ามบันทึกต่อ)
        local warpBackTo = lastSavedPosition
        
        task.wait(3) -- รอ 3 วิ ตามสูตรน้องหนึ่ง
        
        pcall(function() 
            game:GetService("ReplicatedStorage").Events.Player.ChangePlayerMode:FireServer(true) 
        end)

        -- [[ 🚀 วาร์ปกลับจุดที่ล็อคไว้ ]]
        local connection
        connection = LocalPlayer.CharacterAdded:Connect(function(newChar)
            local newHRP = newChar:WaitForChild("HumanoidRootPart", 10)
            if newHRP and warpBackTo then
                -- รอให้โหลดแมพและตัวละครเสร็จสักครู่เพื่อกันวาร์ปตกแมพ
                task.wait(0.7) 
                newHRP.CFrame = warpBackTo
                Fluent:Notify({Title = "U-HUB", Content = "วาร์ปกลับจุดที่ล้มเรียบร้อย!", Duration = 2})
            end
            connection:Disconnect()
        end)
    end)
end

-- 6. เชื่อมต่อระบบ (ห้ามลบ)
if LocalPlayer.Character then setupAutoRevive(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(setupAutoRevive)
-- รันระบบ
player.CharacterAdded:Connect(setupAutoRevive)
if player.Character then setupAutoRevive(player.Character) end
-- =========================================
-- [ 5. เทเลพอร์ต ]
-- =========================================
local TPSection = TeleportTab:AddSection("จุดเทเลพอร์ต")
local floatingTPButton

local function teleportRoof()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame += Vector3.new(0,500,0) end
end

local function createTPFloatingButton()
    if floatingTPButton then return end
    floatingTPButton = Instance.new("TextButton", FloatingGui)
    floatingTPButton.Size=UDim2.new(0,100,0,50)
    floatingTPButton.Position=UDim2.new(0.5,-50,0.6,0)
    floatingTPButton.AnchorPoint=Vector2.new(0.5,0)
    floatingTPButton.Text="TP Roof"
    floatingTPButton.Active=true
    floatingTPButton.Draggable=true
    StyleFloatingButton(floatingTPButton)
    floatingTPButton.MouseButton1Click:Connect(teleportRoof)
end

TPSection:AddButton({Title="เทเลพอร์ตขึ้นหลังคา (ปกติ)", Callback=teleportRoof})
TPSection:AddToggle("TPFloat", {Title="เทเลพอร์ตขึ้นหลังคา (ปุ่มลอย)", Default=false, Callback=function(v)
    if v then createTPFloatingButton() else if floatingTPButton then floatingTPButton:Destroy() floatingTPButton=nil end end
end})
TPSection:AddKeybind("TPKey", {Title="ตั้งค่าปุ่มคีย์บอร์ด", Mode="Always", Default="T", Callback=teleportRoof})







-- ฟังก์ชันแต่งปุ่มลอย (ฟ้าโปร่งแสง + โค้ง)
local function StyleNeungButton(btn)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.new(1,1,1)
    stroke.Transparency = 0.5
    stroke.Parent = btn
    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- สีฟ้าตามสั่ง
    btn.BackgroundTransparency = 0.4 
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
end

-- =========================================
-- [ TELEPORT: DEAD PLAYER ]
-- =========================================
local DeadSection = TeleportTab:AddSection("วาร์ปไปหาคนล้ม")
local floatingDeadTPButton

local function teleportToDead()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local deadPlayer = nil
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        local h = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if h and h.Health == 0 then deadPlayer = plr; break end
    end
    if deadPlayer and deadPlayer.Character and deadPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local originalCFrame = root.CFrame
        root.CFrame = deadPlayer.Character.HumanoidRootPart.CFrame
        task.wait(1)
        root.CFrame = originalCFrame
    end
end

DeadSection:AddButton({Title="วาร์ปไปหาคนล้ม (ปกติ)", Callback=teleportToDead})

local function createDeadTPFloatingButton()
    if floatingDeadTPButton then return end
    floatingDeadTPButton = Instance.new("TextButton", FloatingGui)
    floatingDeadTPButton.Size=UDim2.new(0,100,0,50)
    floatingDeadTPButton.Position=UDim2.new(0.5,-50,0.8,0)
    floatingDeadTPButton.Text="Dead TP"
    floatingDeadTPButton.Draggable = true
    floatingDeadTPButton.Active = true
    StyleNeungButton(floatingDeadTPButton)
    floatingDeadTPButton.MouseButton1Click:Connect(teleportToDead)
end

DeadSection:AddToggle("DeadTPFloat", {Title="วาร์ปไปหาคนล้ม (ปุ่มลอย)", Default=false, Callback=function(v)
    if v then createDeadTPFloatingButton() else if floatingDeadTPButton then floatingDeadTPButton:Destroy(); floatingDeadTPButton=nil end end
end})

-- คีย์บอร์ดอยู่ฟังก์ชันเดียวกับปุ่ม
DeadSection:AddKeybind("DeadTPKey", {Title="ปุ่มวาร์ปไปหาคนล้ม", Mode="Always", Default="Y", Callback=teleportToDead})

-- =========================================


-- =========================================
-- [ EXTRA: MOON MODE ]
-- =========================================
local MoonSection = ExtraTab:AddSection("ระบบตกช้า (Moon Mode)")
local moonModeActive = false
local floatingMoonButton

MoonSection:AddToggle("MoonToggle", {Title="Moon Mode (ปกติ)", Default=false, Callback=function(v) moonModeActive = v end})

local function createMoonFloatingButton()
    if floatingMoonButton then return end
    floatingMoonButton = Instance.new("TextButton", FloatingGui)
    floatingMoonButton.Size = UDim2.new(0,100,0,50)
    floatingMoonButton.Position = UDim2.new(0.8,-50,0.6,0)
    floatingMoonButton.Text = "Moon: OFF"
    floatingMoonButton.Draggable = true
    floatingMoonButton.Active = true
    StyleNeungButton(floatingMoonButton)
    floatingMoonButton.MouseButton1Click:Connect(function()
        moonModeActive = not moonModeActive
        floatingMoonButton.Text = moonModeActive and "Moon: ON" or "Moon: OFF"
    end)
end

MoonSection:AddToggle("MoonFloat", {Title="Moon Mode (ปุ่มลอย)", Default=false, Callback=function(v)
    if v then createMoonFloatingButton() else if floatingMoonButton then floatingMoonButton:Destroy(); floatingMoonButton=nil end moonModeActive = false end
end})

task.spawn(function()
    while true do
        if moonModeActive then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if root and humanoid and humanoid.FloorMaterial == Enum.Material.Air and root.Velocity.Y < 0 then
                root.Velocity = Vector3.new(root.Velocity.X, root.Velocity.Y * 0.3, root.Velocity.Z)
            end
        end
        task.wait(0.05)
    end
end)

-- =========================================
-- [ SETTINGS: SMOOTH DASH ]
-- =========================================
local DashSection = SettingsTab:AddSection("ระบบพุ่ง (Smooth Dash)")
local dashEnabled = false
local dashSpeed = 50
local dashVelocity = nil

local function startDash()
    if dashVelocity then return end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    dashVelocity = Instance.new("BodyVelocity", root)
    dashVelocity.MaxForce = Vector3.new(400000, 0, 400000)
    task.spawn(function()
        while dashEnabled and dashVelocity and dashVelocity.Parent do
            local dir = workspace.CurrentCamera.CFrame.LookVector
            dashVelocity.Velocity = Vector3.new(dir.X, 0, dir.Z).Unit * dashSpeed
            task.wait(0.03)
        end
        if dashVelocity then dashVelocity:Destroy(); dashVelocity = nil end
    end)
end

DashSection:AddToggle("DashToggle", {Title="Smooth Dash (ปกติ)", Default=false, Callback=function(v)
    dashEnabled = v
    if v then startDash() end
end})

DashSection:AddInput("DashSpeedInput", {Title="ปรับความเร็ว Dash", Default="50", Callback=function(v) dashSpeed = tonumber(v) or 50 end})

DashSection:AddKeybind("DashKey", {Title="ปุ่ม Dash", Mode="Toggle", Default="Q", Callback=function(v)
    dashEnabled = v
    if v then startDash() end
end})


-- [[ EVADE SCRIPT: FLUENT VERSION - FINAL INTEGRATED ]]


-- ฟังก์ชันแต่งปุ่มลอย (ฟ้าโปร่งแสง + โค้ง)
local function StyleNeungButton(btn)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.new(1,1,1)
    stroke.Transparency = 0.5
    stroke.Parent = btn
    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- สีฟ้า
    btn.BackgroundTransparency = 0.4 
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
end

-- =========================================
-- [ EVENT: ESP TICKET & FARM ]
-- =========================================
-- =================================================
-- 🎫 ระบบ U-HUB Ticket Farm (Score + Platform + HH:MM:SS)
-- =================================================

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [[ 🧠 1. เตรียมตัวแปรสถานะ ]]
getgenv().AutoTicketFarm = false
if _G.TotalFarmSeconds == nil then _G.TotalFarmSeconds = 0 end
if _G.TicketScore == nil then _G.TicketScore = 0 end -- ตัวแปรนับคะแนน
local LastTimeTick = tick()
local Platform = nil 

-- ฟังก์ชันแปลงเวลา
local function FormatUHubTime(seconds)
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", hours, mins, secs)
end

-- ฟังก์ชันจัดการที่ยืน
local function ManagePlatform(state, pos)
    if state then
        if not Platform or not Platform.Parent then
            Platform = Instance.new("Part")
            Platform.Name = "UHubPlatform"
            Platform.Size = Vector3.new(15, 1, 15)
            Platform.Anchored = true
            Platform.Transparency = 0.5
            Platform.Color = Color3.fromRGB(255, 105, 180)
            Platform.Material = Enum.Material.Glass
            Platform.Parent = workspace
        end
        if pos then Platform.CFrame = CFrame.new(pos.X, pos.Y - 3.5, pos.Z) end
    else
        if Platform then Platform:Destroy(); Platform = nil end
    end
end

-- [[ 🎨 2. ฟังก์ชันจัดการ UI ]]
local function CreateUHubUI()
    if not getgenv().AutoTicketFarm then return end
    if LocalPlayer.PlayerGui:FindFirstChild("UHubOverlay") then LocalPlayer.PlayerGui.UHubOverlay:Destroy() end
    
    local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    gui.Name = "UHubOverlay"; gui.IgnoreGuiInset = true; gui.ResetOnSpawn = false 

    local bg = Instance.new("Frame", gui)
    -- [[ 🚀 จุดที่ 1: พื้นหลังดำสนิทตามสั่ง ]]
    bg.Size = UDim2.fromScale(1,1); bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0); bg.BackgroundTransparency = 0.35
    
    -- [[ ⭐ 🚀 จุดที่เพิ่ม: ระบบดาววิ่งข้ามจอ (จากโค้ดของน้องหนึ่ง) ]]
    for i = 1, 100 do
        local Star = Instance.new("Frame")
        Star.Size = UDim2.fromOffset(math.random(1, 2), math.random(1, 2))
        Star.Position = UDim2.fromScale(math.random(), math.random())
        Star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Star.BackgroundTransparency = math.random(0.3, 0.6)
        Star.BorderSizePixel = 0
        Star.Parent = bg -- เปลี่ยนจาก MainFrame เป็น bg
        local Corner = Instance.new("UICorner", Star)
        Corner.CornerRadius = UDim.new(1, 0)

        local speed = math.random(1, 2) / 2500
        game:GetService("RunService").RenderStepped:Connect(function()
            if Star and Star.Parent then
                local newX = Star.Position.X.Scale + speed
                if newX > 1 then newX = -0.01 end
                Star.Position = UDim2.fromScale(newX, Star.Position.Y.Scale)
            end
        end)
    end

    -- [[ 🌙 🚀 จุดที่เพิ่ม: ดวงจันทร์สวยๆ (จากโค้ดของน้องหนึ่ง) ]]
    local Moon = Instance.new("ImageLabel")
    Moon.Size = UDim2.fromOffset(180, 180)
    Moon.Position = UDim2.fromScale(0.85, 0.2)
    Moon.AnchorPoint = Vector2.new(0.5, 0.5)
    Moon.Image = "rbxassetid://11415840338"
    Moon.BackgroundTransparency = 1
    Moon.ImageTransparency = 0.1
    Moon.Parent = bg
    game:GetService("TweenService"):Create(Moon, TweenInfo.new(8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Position = UDim2.fromScale(0.87, 0.22)}):Play()

    local text = Instance.new("TextLabel", bg)
    text.Name = "InfoText"; text.Size = UDim2.fromScale(1,1); text.BackgroundTransparency = 1; text.TextColor3 = Color3.new(1,1,1)
    text.TextScaled = true; text.Font = Enum.Font.GothamBold
    text.Text = "U-HUB\nกำลังเตรียมตัว..."

    local heartL = Instance.new("TextLabel", bg)
    heartL.Text = ""; heartL.Size = UDim2.fromScale(0.1, 0.1); heartL.Position = UDim2.fromScale(0.1, 0.5); heartL.BackgroundTransparency = 1; heartL.TextScaled = true
    local heartR = heartL:Clone(); heartR.Parent = bg; heartR.Position = UDim2.fromScale(0.8, 0.5)
    
    return gui
end

-- [[ 🎡 3. สร้างระบบ Toggle ]]
local TicketSection = EventTab:AddSection("ระบบตั๋ว (Ticket System)")

local TicketToggleUI = TicketSection:AddToggle("UHubTicketToggle", {
    Title = "เปิดออโต้ฟาร์มตั๋วยาวๆ",
    Description = "ฟาร์มตั๋ว + นับคะแนน + ที่ยืน [N] ปิด/เปิด",
    Default = false,
    Callback = function(state)
        getgenv().AutoTicketFarm = state
        ManagePlatform(state)
        
        if state then
            LastTimeTick = tick()
            local ui = CreateUHubUI()
            
            -- [[ 🌑 ปรับแมพมืดสนิทตามสั่ง ]]
            local lt = game:GetService("Lighting")
            lt.Ambient = Color3.fromRGB(0, 0, 0)
            lt.Brightness = 0
            lt.ClockTime = 0
            lt.ExposureCompensation = -1

            task.spawn(function()
                while getgenv().AutoTicketFarm do
                    if not LocalPlayer.PlayerGui:FindFirstChild("UHubOverlay") then ui = CreateUHubUI() end
                    
                    if ui and ui:FindFirstChild("InfoText", true) then
                        local currentTick = tick()
                        _G.TotalFarmSeconds = _G.TotalFarmSeconds + (currentTick - LastTimeTick)
                        LastTimeTick = currentTick
                        ui:FindFirstChild("InfoText", true).Text = string.format(
                            "U-HUB กำลังฟาร์มให้นะคัฟ\nคะแนนที่เก็บได้: %d ใบ\nเวลาสะสม: %s",
                            _G.TicketScore, FormatUHubTime(_G.TotalFarmSeconds)
                        )
                    end

                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local ticketFolder = workspace:FindFirstChild("Game") 
                        and workspace.Game:FindFirstChild("Effects") 
                        and workspace.Game.Effects:FindFirstChild("Tickets")

                    if hrp and ticketFolder then
                        local allTickets = ticketFolder:GetChildren()
                        if #allTickets > 0 then
                            for _, ticket in ipairs(allTickets) do
                                if not getgenv().AutoTicketFarm then break end
                                local part = ticket:FindFirstChildWhichIsA("BasePart")
                                if part and part.Parent then
                                    hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                                    ManagePlatform(true, part.Position)
                                    _G.TicketScore = _G.TicketScore + 1
                                    task.wait(1)
                                end
                            end
                        else
                            hrp.CFrame = CFrame.new(hrp.Position.X, 1250, hrp.Position.Z)
                            ManagePlatform(true, hrp.Position)
                        end
                    end
                    task.wait(0.5)
                end
            end)

            Fluent:Notify({Title = "U-HUB", Content = "เริ่มฟาร์มแล้ว! เก็บให้เรียบนะน้องหนึ่ง", Duration = 2})
        else
            if LocalPlayer.PlayerGui:FindFirstChild("UHubOverlay") then LocalPlayer.PlayerGui.UHubOverlay:Destroy() end
            local lt = game:GetService("Lighting")
            lt.Ambient = Color3.fromRGB(127, 127, 127); lt.Brightness = 1; lt.ClockTime = 12; lt.ExposureCompensation = 0
            
            ManagePlatform(false)
            Fluent:Notify({Title = "U-HUB", Content = "หยุดฟาร์มแล้วครับ", Duration = 2})
        end
    end
})

-- ระบบปุ่ม N
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.N then
        TicketToggleUI:SetValue(not getgenv().AutoTicketFarm)
    end
end)
TicketSection:AddKeybind("AutoTicketKey", {Title = "ปุ่มฟาร์มตั๋ว", Default = "N", Callback = function(v) getgenv().AutoTicketFarm = v end})

-- [[ 👁️ ระบบมองเน็กบอท (U-HUB ESP Nextbot) ]]
local VisualsSection = VisualsTab:AddSection("ระบบการมองเห็น (Visuals)")

VisualsSection:AddToggle("UHubNextbotESP", {
    Title = "ESP Nextbot",
    Description = "แสดงชื่อและระยะห่างของ Nextbot ทะลุกำแพง",
    Default = false,
    Callback = function(state)
        getgenv().NextbotESPEnabled = state
        
        if not state then
            -- [[ 🛑 กรณีสั่งปิด: ลบ ESP ที่ค้างอยู่ทั้งหมด ]]
            local folder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
            if folder then
                for _, npc in ipairs(folder:GetChildren()) do
                    local part = npc:FindFirstChild("Root") or npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local esp = part:FindFirstChild("UHubNextbotESP")
                        if esp then esp:Destroy() end
                    end
                end
            end
        else
            -- [[ ✅ กรณีสั่งเปิด: เริ่มลูปการทำงาน ]]
            task.spawn(function()
                local LocalPlayer = game:GetService("Players").LocalPlayer -- เพิ่มตัวแปร LocalPlayer ให้ใช้ได้จริง
                while getgenv().NextbotESPEnabled do
                    local folder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
                    if folder then
                        for _, npc in ipairs(folder:GetChildren()) do
                            -- ตรวจสอบว่าเป็น Nextbot หรือไม่
                            if npc:GetAttribute("Team") == "Nextbot" then
                                local part = npc:FindFirstChild("Root") or npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart")
                                
                                if part then
                                    local billboard = part:FindFirstChild("UHubNextbotESP")
                                    
                                    -- สร้าง BillboardGui ถ้ายังไม่มี
                                    if not billboard then
                                        billboard = Instance.new("BillboardGui")
                                        billboard.Name = "UHubNextbotESP"
                                        billboard.Adornee = part
                                        billboard.Size = UDim2.new(0, 150, 0, 50)
                                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                                        billboard.AlwaysOnTop = true
                                        billboard.Parent = part

                                        local label = Instance.new("TextLabel")
                                        label.Name = "Label"
                                        label.Size = UDim2.new(1, 0, 1, 0)
                                        label.BackgroundTransparency = 1
                                        label.TextStrokeTransparency = 0
                                        label.TextStrokeColor3 = Color3.new(0, 0, 0)
                                        
                                        -- [[ ปรับขนาดตัวหนังสือเป็น 14 ตามสั่ง ]]
                                        label.TextScaled = false -- ปิดตัวนี้เพื่อให้ TextSize ทำงาน
                                        label.TextSize = 14
                                        
                                        label.Font = Enum.Font.GothamBold
                                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                                        label.Parent = billboard
                                    end

                                    -- อัปเดตข้อความและระยะทาง
                                    local label = billboard:FindFirstChild("Label")
                                    if label then
                                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                        local dist = hrp and (part.Position - hrp.Position).Magnitude or 0
                                        
                                        label.Text = string.format("%s\n[ %.1f ]", npc.Name, dist)

                                        -- เปลี่ยนสีตามความอันตราย (ใกล้ = แดง | ไกล = ฟ้า/ม่วง)
                                        if dist <= 14 then
                                            label.TextColor3 = Color3.fromRGB(255, 50, 50) -- แดงจัด (อันตรายมาก)
                                        elseif dist <= 50 then -- แก้เงื่อนไขให้เป็นช่วงที่กว้างขึ้นตามตรรกะเดิม
                                            label.TextColor3 = Color3.fromRGB(255, 150, 0) -- ส้ม (เริ่มใกล้)
                                        else
                                            label.TextColor3 = Color3.fromRGB(180, 150, 255) -- ม่วงอ่อน (ปลอดภัย)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1) -- อัปเดตตำแหน่ง ESP ให้ลื่นไหล
                end
            end)
        end
    end
})

-- =========================================
-- [ FPS: GRAPHICS & FPS DISPLAY ]
-- =========================================
local FPSSection = SettingsTab:AddSection("เพิ่มความลื่น (Optimization)")

SettingsTab:AddButton({
    Title = "เพิ่ม fps", 
    Callback = function()
        -- ใช้สมองเดิมของน้องหนึ่งทั้งหมด
        for _, obj in ipairs(workspace:GetDescendants()) do
            -- ส่วนของ V.1 (ปรับพื้นผิว)
            if obj:IsA("BasePart") then 
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0 
            end
            
            -- ส่วนของ V.2 (ลบเอฟเฟกต์)
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Decal") then 
                obj:Destroy() 
            end
        end
        
        -- แจ้งเตือนปิดท้ายซะหน่อยให้น้องหนึ่งรู้ว่ามันทำงานแล้ว
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "U-HUB",
            Text = "บูสต์ความลื่น V.1 และ V.2 เรียบร้อย!",
            Duration = 2
        })
    end
})

FPSSection:AddToggle("MiniSpaceFPS", {
    Title = "🌌 หน้าต่างอวกาศ (FPS + Stars)",
    Default = false,
    Callback = function(state)
        local lp = game.Players.LocalPlayer
        
        -- 🛠️ ฟังก์ชันสร้างหน้าต่างจิ๋ว
        local function CreateMiniFPS()
            if lp.PlayerGui:FindFirstChild("UHub_MiniFPS") then 
                lp.PlayerGui.UHub_MiniFPS:Destroy() 
            end

            local gui = Instance.new("ScreenGui", lp.PlayerGui)
            gui.Name = "UHub_MiniFPS"
            gui.ResetOnSpawn = false

            -- 📺 ตัวหน้าต่าง (เน้นความใสเพื่อมองทะลุข้างหลังได้)
            local MainFrame = Instance.new("Frame", gui)
            MainFrame.Size = UDim2.fromOffset(180, 90) -- ปรับขนาดให้กะทัดรัดขึ้น
            MainFrame.Position = UDim2.new(0.5, -90, 0.1, 0)
            MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            MainFrame.BackgroundTransparency = 0.6 -- [🚀 จุดสำคัญ] ปรับความใสให้เห็นข้างหลังได้
            MainFrame.BorderSizePixel = 0
            MainFrame.Active = true
            MainFrame.Draggable = true -- ลากได้เหมือนเดิม
            MainFrame.ClipsDescendants = true 

            -- 🌈 ขอบโค้งมน
            local Corner = Instance.new("UICorner", MainFrame)
            Corner.CornerRadius = UDim.new(0, 15)

            -- ✨ เส้นขอบบางๆ พอให้สวย
            local Stroke = Instance.new("UIStroke", MainFrame)
            Stroke.Color = Color3.fromRGB(0, 255, 150)
            Stroke.Thickness = 1.5
            Stroke.Transparency = 0.6

            -- ⭐ ระบบดาววิ่ง (ลดเหลือ 25 ดวง ตามสั่งน้องหนึ่ง)
           -- [[ ⭐ ระบบดาววนลูป (สมองน้องหนึ่ง: ไม่โหลดใหม่ สลับพื้นที่เอา) ]]
local stars = {}

-- สร้างทิ้งไว้แค่ 25 ดวงตั้งแต่เริ่มครั้งเดียวจบ
for i = 1, 7 do
    local Star = Instance.new("Frame", MainFrame)
    Star.Size = UDim2.fromOffset(math.random(1, 2), math.random(1, 2))
    -- สุ่มตำแหน่งเริ่มต้นให้กระจายทั่วหน้าต่าง
    Star.Position = UDim2.fromScale(math.random(), math.random())
    Star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Star.BackgroundTransparency = 0.5
    Star.BorderSizePixel = 0
    Instance.new("UICorner", Star).CornerRadius = UDim.new(1, 0)
    
    -- ตั้งค่าความเร็วสุ่มไว้ในตัวดาว
    Star:SetAttribute("Speed", math.random(5, 15) / 10000)
    table.insert(stars, Star)
end

-- ⚡ ลูปเดียวคุมการ "วาร์ป" ดาว (ลื่น No.1)
task.spawn(function()
    local runConn
    runConn = game:GetService("RunService").RenderStepped:Connect(function()
        if not MainFrame or not MainFrame.Parent then runConn:Disconnect() return end
        
        for _, s in ipairs(stars) do
            if s and s.Parent then
                local speed = s:GetAttribute("Speed")
                -- คำนวณตำแหน่ง X ใหม่
                local currentX = s.Position.X.Scale + speed
                
                -- [🚀 จุดที่น้องหนึ่งสั่ง] ถ้าดาววิ่งเลยขอบขวา (1.1) 
                -- ให้วาร์ปกลับไปเริ่มที่ขอบซ้าย (-0.1) โดยไม่ต้องสร้างใหม่
                if currentX > 1.1 then 
                    currentX = -0.1 
                    -- แถม: สุ่มความสูง (Y) ใหม่ตอนวาร์ปกลับมา จะได้ดูไม่จำเจเหมือนดาวชุดเดิมเป๊ะ
                    s.Position = UDim2.fromScale(currentX, math.random())
                else
                    s.Position = UDim2.fromScale(currentX, s.Position.Y.Scale)
                end
            end
        end
    end)
end)


            -- ⏱️ ตัวเลข FPS
            local FPSLabel = Instance.new("TextLabel", MainFrame)
            FPSLabel.Size = UDim2.fromScale(1, 1)
            FPSLabel.BackgroundTransparency = 1
            FPSLabel.TextColor3 = Color3.new(1, 1, 1)
            FPSLabel.Font = Enum.Font.GothamBold
            FPSLabel.TextSize = 22
            FPSLabel.Text = "FPS: ..."
            FPSLabel.ZIndex = 2
            
            task.spawn(function()
                local lastTime = tick()
                local frames = 0
                while gui.Parent do
                    frames = frames + 1
                    local now = tick()
                    if now - lastTime >= 0.5 then
                        FPSLabel.Text = math.floor(frames / (now - lastTime)) .. " FPS"
                        frames = 0
                        lastTime = now
                    end
                    game:GetService("RunService").RenderStepped:Wait()
                end
            end)
            return gui
        end

        -- 🌙 ระบบเปิด/ปิด
        if state then
            getgenv().MiniFPSGui = CreateMiniFPS()
        else
            if getgenv().MiniFPSGui then
                getgenv().MiniFPSGui:Destroy()
                getgenv().MiniFPSGui = nil
            end
        end
    end
})


-- [ EXTRA: No clip ]
-- =========================================
local WallSection =  SettingsTab:AddSection("ระบบทะลุกำแพง")
local wallHackActive = false
local floatingWallButton
local wallPartsOriginalCollide = {}

local function setWallHack(state)
    wallHackActive = state
    if not wallHackActive then
        for part, collide in pairs(wallPartsOriginalCollide) do
            if part and part.Parent then part.CanCollide = collide end
        end
        wallPartsOriginalCollide = {}
    end
end

local function toggleWallHack()
    setWallHack(not wallHackActive)
    if floatingWallButton then floatingWallButton.Text = wallHackActive and "No clip: ON" or "No clip: OFF" end
end

task.spawn(function()
    while true do
        if wallHackActive then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local forwardDir = root.CFrame.LookVector
                for _, part in pairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local toPart = part.Position - root.Position
                        if forwardDir:Dot(toPart) > 0 and forwardDir:Dot(toPart) < 5 then
                            if wallPartsOriginalCollide[part] == nil then wallPartsOriginalCollide[part] = part.CanCollide end
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
        task.wait(0.05)
    end
end)



WallSection:AddToggle("WallHackToggle", {Title="No clip (ปกติ)", Default=false, Callback=setWallHack})

local function createWallFloatingButton()
    if floatingWallButton then return end
    floatingWallButton = Instance.new("TextButton", FloatingGui)
    floatingWallButton.Size = UDim2.new(0,100,0,50)
    floatingWallButton.Position = UDim2.new(0.2,-50,0.6,0)
    floatingWallButton.Text = "No clip: OFF"
    floatingWallButton.Draggable = true
    floatingWallButton.Active = true
    StyleNeungButton(floatingWallButton)
    floatingWallButton.MouseButton1Click:Connect(toggleWallHack)
end


-- คีย์บอร์ดสำหรับ Teleport (ใช้ Click)

-- =========================================
-- [ MAIN: AUTO CARRY ]
-- =========================================
local CarrySection = MainTab:AddSection("ระบบอุ้ม (Auto Carry)")

CarrySection:AddToggle("AutoCarryToggle", {Title = "Auto Carry", Default = false, Callback = function(v) getgenv().autoCarryEnabled = v end})
CarrySection:AddKeybind("CarryKey", {Title = "ปุ่มอุ้มอัตโนมัติ", Default = "G", Callback = function(v) getgenv().autoCarryEnabled = v end})

-- Logic Auto Carry เดิม
task.spawn(function()
    while true do
        if getgenv().autoCarryEnabled then
            for _, plr in ipairs(game.Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local dist = (player.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= 20 then
                        game:GetService("ReplicatedStorage").Events.Character.Interact:FireServer("Carry", nil, plr.Name)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- =========================
-- AUTO REVIVE FRIENDS (ไม่มีลิงก์ - ตามต้นฉบับเป๊ะ)
-- =========================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local interactEvent = ReplicatedStorage:WaitForChild("Events")
    :WaitForChild("Character")
    :WaitForChild("Interact")

local autoReviveEnabled = false
local reviveRange = 15
local reviveLoop

local function isPlayerDowned(plr)
    if not plr.Character then return false end
    return plr.Character:GetAttribute("Downed") == true
end

local function startAutoRevive()
    if reviveLoop then return end

    reviveLoop = RunService.Heartbeat:Connect(function()
        if not autoReviveEnabled then return end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer and isPlayerDowned(pl) then
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

local function stopAutoRevive()
    autoReviveEnabled = false
    if reviveLoop then
        reviveLoop:Disconnect()
        reviveLoop = nil
    end
end

-- =========================
-- เพิ่มลงใน UI (หมวด ของเสริม)
-- =========================

-- หมายเหตุ: พี่ใช้ชื่อ MainTab ตามที่น้องใช้ในโค้ดชุดล่าสุดนะครับ
MainTab:AddToggle("AutoReviveToggle", {
    Title = "ออโต้ชุบเพื่อน",
    Description = "ชุบผู้เล่นที่ล้มอัตโนมัติเมื่ออยู่ใกล้",
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

-- [[ 🧠 ส่วนที่ 1: เตรียมสมอง (โครงสร้างหลักของน้องหนึ่ง) ]]
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local downedESPEnabled = false
local downedBillboards = {}

-- ฟังก์ชันคำนวณระยะทาง
local function getDistance(part)
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and part then
        return math.floor((lp.Character.HumanoidRootPart.Position - part.Position).Magnitude)
    end
    return 0
end

-- ฟังก์ชันล้าง ESP คนล้ม (ห้ามลบ)
local function clearDownedESP()
    for _, billboard in pairs(downedBillboards) do
        if billboard then billboard:Destroy() end
    end
    downedBillboards = {}
end

-- ฟังก์ชันอัปเดตคนล้ม (ปรับขนาดให้พอดี)
local function updateDownedESP()
    clearDownedESP() 
    if not downedESPEnabled then return end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            local isDowned = (humanoid and humanoid.Health <= 0) or plr.Character:GetAttribute("Downed") == true

            if root and isDowned then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "DownedESP"
                billboard.Adornee = root
                billboard.Size = UDim2.new(0, 120, 0, 40) -- ขยับขนาดขึ้นมาหน่อย
                billboard.StudsOffset = Vector3.new(0, 3.5, 0)
                billboard.AlwaysOnTop = true 
                billboard.Parent = root

                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                local dist = getDistance(root)
                textLabel.Text = string.format("%s\n%d studs", plr.Name, dist)
                textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                textLabel.TextSize = 13 -- ปรับขนาดจาก 10 เป็น 13 (อ่านง่ายขึ้นเยอะ)
                textLabel.Font = Enum.Font.GothamBlack
                textLabel.TextStrokeTransparency = 0.5 -- เพิ่มขอบดำนิดนึงให้อ่านง่าย
                textLabel.Parent = billboard

                downedBillboards[plr] = billboard
            end
        end
    end
end

task.spawn(function()
    while true do
        if downedESPEnabled then updateDownedESP() end
        task.wait(0.5)
    end
end)

-- [[ 👤 2. ฟังก์ชัน ESP ผู้เล่น (ปรับขนาดใหม่) ]]
local playerESPEnabled = false

local function updatePlayerESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local char = p.Character
            local head = char:FindFirstChild("Head")
            
            if head then
                local billboard = head:FindFirstChild("UHubESP")
                local highlight = char:FindFirstChild("UHubHighlight")

                if playerESPEnabled then
                    if not billboard then
                        billboard = Instance.new("BillboardGui", head)
                        billboard.Name = "UHubESP"
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0, 120, 0, 40)
                        billboard.ExtentsOffset = Vector3.new(0, 3.5, 0)
                        
                        local text = Instance.new("TextLabel", billboard)
                        text.Name = "Label"
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.TextColor3 = Color3.fromRGB(255, 255, 255)
                        text.Font = Enum.Font.GothamBold
                        text.TextSize = 17 
                        text.TextStrokeTransparency = 0.7
                        text.Parent = billboard
                    end
                    
                    local label = billboard:FindFirstChild("Label")
                    if label then
                        local dist = getDistance(head)
                        label.RichText = true
                        label.Text = string.format("%s\n<font color='rgb(255,0,0)'>%d studs</font>", p.Name, dist)
                    end

                    if not highlight then
                        highlight = Instance.new("Highlight", char)
                        highlight.Name = "UHubHighlight"
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                else
                    if billboard then billboard:Destroy() end
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        if playerESPEnabled then updatePlayerESP() end
        task.wait(0.1)
    end
end)

-- [[ 🧠 3. ปุ่มกดในหน้า VisualsTab ]]
VisualsTab:AddToggle("ESPToggle", {
    Title = "มองผู้เล่น (ESP Player)",
    Description = "แสดงชื่อและกรอบตัวละครผู้เล่นคนอื่น",
    Default = false,
    Callback = function(state)
        playerESPEnabled = state
        if not state then updatePlayerESP() end -- ล้างค่าทันทีที่ปิด
    end
})

-- [[ 🧠 4. ลูปให้ทำงานตลอดเวลา ]]
game:GetService("RunService").RenderStepped:Connect(function()
    if playerESPEnabled then
        updatePlayerESP()
    end
end)


-- [[ 🧠 ส่วนที่ 2: ตัว Toggle ใน Fluent UI (ใส่ใน VisualsTab) ]]
local DownedToggle = VisualsTab:AddToggle("DownedESP", {
    Title = "มองผู้เล่นที่ล้ม",
    Description = "แสดงข้อความสีแดงเหนือหัวผู้เล่นที่ล้ม",
    Default = false
})

DownedToggle:OnChanged(function()
    downedESPEnabled = DownedToggle.Value
    if not downedESPEnabled then
        clearDownedESP() -- ถ้าปิดสวิตช์ ให้ลบป้ายแดงๆ ออกทันที
    end
end)

-- [[ 🧠 ส่วนที่ 1: ตัวแปรควบคุม ]]
local ticketESPEnabled = false

-- ฟังก์ชันคำนวณระยะทาง
local function getDistance(pos)
    local char = game.Players.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    return hrp and (pos - hrp.Position).Magnitude or nil
end

-- ฟังก์ชันสร้างป้าย ESP (ปรับให้ตัวหนังสือพอดีตา)
local function createESP(part)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TicketESP"
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 120, 0, 40) -- ปรับให้เล็กลงหน่อยไม่ให้เกะกะ
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true -- มองทะลุได้ชัวร์
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.Name = "TicketLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextStrokeTransparency = 0.5
    label.TextSize = 13 -- ขนาดกลางๆ เท่ากับ ESP คนที่น้องชอบ
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.fromRGB(255, 105, 180) -- สีชมพู U-HUB
    label.Parent = billboard

    return billboard
end

-- [[ 🧠 ส่วนที่ 2: ตัวปุ่มใน Fluent UI ]]
local TicketESPToggle = EventTab:AddToggle("TicketESP_Simple", {
    Title = "มองตั๋ว (ESP Ticket)",
    Description = "แสดงตำแหน่งตั๋วและระยะทาง",
    Default = false
})

TicketESPToggle:OnChanged(function()
    ticketESPEnabled = TicketESPToggle.Value
    
    if ticketESPEnabled then
        task.spawn(function()
            while ticketESPEnabled do
                local ticketFolder = workspace:FindFirstChild("Game") 
                    and workspace.Game:FindFirstChild("Effects") 
                    and workspace.Game.Effects:FindFirstChild("Tickets")
                
                if ticketFolder then
                    for _, ticketModel in ipairs(ticketFolder:GetChildren()) do
                        local part = ticketModel:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local billboard = part:FindFirstChild("TicketESP") or createESP(part)
                            local label = billboard:FindFirstChild("TicketLabel")
                            
                            if label then
                                local dist = getDistance(part.Position)
                                -- พี่เอาระบบนับแต้มออกแล้ว เหลือแค่ป้ายตั๋วกับระยะทางครับ
                                label.Text = string.format("🎫 TICKET\n[%.0f studs]", dist or 0)
                            end
                        end
                    end
                end
                task.wait(0.2)
            end
            
            -- ล้าง ESP เมื่อปิดปุ่ม
            local ticketFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")
            if ticketFolder then
                for _, t in pairs(ticketFolder:GetChildren()) do
                    local p = t:FindFirstChildWhichIsA("BasePart")
                    if p and p:FindFirstChild("TicketESP") then p.TicketESP:Destroy() end
                end
            end
        end)
    end
end)


-- [[ 🎫 ระบบมองตั๋ว (U-HUB Ticket ESP - Black Edition) ]]


local ticketESPEnabled = false

-- ฟังก์ชันสร้างป้าย ESP (สีดำตามสั่ง)
local function createTicketESP(part)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TicketESP"
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.Name = "TicketLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    -- ปรับสีดำตามที่น้องหนึ่งต้องการ
    label.TextColor3 = Color3.fromRGB(0, 0, 0) 
    -- เพิ่มขอบขาวนิดนึงเพื่อให้มองเห็นในที่มืดได้
    label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.8
    label.TextSize = 13 
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    return billboard
end

local TicketESPToggle = VisualsTab:AddToggle("UHubTicketESP", {
    Title = "มองตั๋ว",
    Description = "แสดงตำแหน่งตั๋วด้วยข้อความสีดำ",
    Default = false
})

TicketESPToggle:OnChanged(function()
    ticketESPEnabled = TicketESPToggle.Value
    
    if ticketESPEnabled then
        task.spawn(function()
            while ticketESPEnabled do
                local ticketFolder = workspace:FindFirstChild("Game") 
                    and workspace.Game:FindFirstChild("Effects") 
                    and workspace.Game.Effects:FindFirstChild("Tickets")
                
                if ticketFolder then
                    for _, ticketModel in ipairs(ticketFolder:GetChildren()) do
                        local part = ticketModel:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local billboard = part:FindFirstChild("TicketESP") or createTicketESP(part)
                            local label = billboard:FindFirstChild("TicketLabel")
                            
                            if label then
                                -- ดึงฟังก์ชัน getDistance จากส่วนสมองหลักที่น้องมีอยู่แล้ว
                                local char = lp.Character
                                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                                local dist = hrp and (part.Position - hrp.Position).Magnitude or 0
                                
                                label.Text = string.format("🎫 TICKET\n[ %.0f studs ]", dist)
                            end
                        end
                    end
                end
                task.wait(0.2)
            end
            
            -- ลบ ESP ทิ้งเมื่อปิดใช้งาน
            local ticketFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")
            if ticketFolder then
                for _, t in pairs(ticketFolder:GetChildren()) do
                    local p = t:FindFirstChildWhichIsA("BasePart")
                    if p and p:FindFirstChild("TicketESP") then p.TicketESP:Destroy() end
                end
            end
        end)
    end
end)

-- =============================
-- ของเสริม : Korblox / Headless (เวอร์ชันแก้ตายแล้วหาย)
-- =============================

local player = game.Players.LocalPlayer

-- เก็บสถานะปุ่ม
local extraStatus = {
    Korblox = false,
    Headless = false,
}

-- ฟังก์ชันเอาไว้รันสคริปต์ทุกครั้งที่ต้องการ
local function applyBodyMod()
    getgenv().Setting = {
        ["Body"] = {
            ["Korblox"] = extraStatus.Korblox,
            ["Headless"] = extraStatus.Headless,
        },
    }

    -- โหลดสคริปต์ลิงก์ (ชุด headless/korblox)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/khen791/script-khen/refs/heads/main/KorbloxAndHeadless.txt", true))()
end

-- ฟังก์ชันรอเกิดใหม่ แล้วใช้ของเสริมให้อัตโนมัติ
player.CharacterAdded:Connect(function()
    task.wait(1) -- รอให้ตัวโหลดครบ
    applyBodyMod()
end)

-- =============================
-- ปุ่ม Korblox
-- =============================
ExtraTab:AddToggle("KorbloxToggle", {
    Title = "ขากุด (Korblox)",
    Description = "เปิด/ปิด ขากุด โดยใช้สคริปต์จากลิงก์",
    Default = false,
    Callback = function(state)
        extraStatus.Korblox = state
        applyBodyMod()
    end
})

-- =============================
-- ปุ่ม Headless
-- =============================
ExtraTab:AddToggle("HeadlessToggle", {
    Title = "หัวล่องหน (Headless)",
    Description = "เปิด/ปิด หัวล่องหน โดยใช้สคริปต์จากลิงก์",
    Default = false,
    Callback = function(state)
        extraStatus.Headless = state
        applyBodyMod()
    end
})

-- =========================
-- ลบความมืดออก / เพิ่มแสง
-- =========================
ExtraTab:AddButton({
    Title = "ลบมืดออก",
    Description = "ทำให้ Map สว่าง และตัดเงาออกทั้งหมด",
    Callback = function()
        local Lighting = game:GetService("Lighting")

        -- ปรับแสงให้สว่าง
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.Brightness = 3
        Lighting.ExposureCompensation = 1

        -- ปิด Shadow
        Lighting.GlobalShadows = false

        -- ลบเอฟเฟกต์มืดทั้งหมด เช่น ColorCorrection, DepthOfField, Bloom, SunRays
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("ColorCorrectionEffect")
            or v:IsA("DepthOfFieldEffect")
            or v:IsA("BloomEffect")
            or v:IsA("SunRaysEffect")
            or v:IsA("Atmosphere")
            or v:IsA("Sky") then
                v:Destroy()
            end
        end
    end
})




-- [[ ⚙️ ตัวแปรควบคุม - ปรับสเกลใหม่ตามเซิร์ฟวี ]]
getgenv().BounceEnabled = false
getgenv().BounceHeight = 350 -- เริ่มต้นให้ที่ 350 (กำลังดีสำหรับสายโดด)
local bounceDistance = 10 -- เพิ่มระยะแสกนพื้นให้กว้างขึ้น

-- [[ 🧠 สมองการเด้ง (เน้นแรงส่ง Velocity แบบสะใจ) ]]
local function IsNearGround(hrp)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {hrp.Parent}
    -- แสกนพื้น 3 จุด (ซ้าย ขวา กลาง)
    local offsets = {
        Vector3.new(0,-bounceDistance,0),
        Vector3.new(2,-bounceDistance,0),
        Vector3.new(-2,-bounceDistance,0)
    }
    for _,offset in ipairs(offsets) do
        local r = workspace:Raycast(hrp.Position, offset, rayParams)
        if r and r.Instance and r.Instance.CanCollide then return true end
    end
    return false
end

task.spawn(function()
    while true do
        if getgenv().BounceEnabled then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel = hrp.Velocity
                -- เช็คจังหวะตก (Y < -20) เพื่อทำการ Bounce
                if vel.Y < -20 and IsNearGround(hrp) then
                    -- สั่งดีดตัวด้วยแรงส่งที่น้องตั้งค่าไว้
                    hrp.Velocity = Vector3.new(vel.X, getgenv().BounceHeight, vel.Z)
                    
                    -- Effect พุ่ง (Particle)
                    local fx = Instance.new("ParticleEmitter")
                    fx.Texture = "rbxassetid://241594180"
                    fx.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
                    fx.Lifetime = NumberRange.new(0.3)
                    fx.Speed = NumberRange.new(50)
                    fx.SpreadAngle = Vector2.new(180, 180)
                    fx.Parent = hrp
                    game:GetService("Debris"):AddItem(fx, 0.3)
                end
            end
        end
        task.wait()
    end
end)

-- =========================================
-- [ 📺 ส่วนของเมนู Fluent UI ]
-- =========================================
local BounceSection = MainTab:AddSection("ระบบออโต้เด้ง (สูงๆ)")

-- 1. สวิตช์ เปิด/ปิด
local BounceToggle = BounceSection:AddToggle("BounceToggle", {
    Title = "เปิดใช้งาน",
    Default = false,
    Callback = function(Value)
        getgenv().BounceEnabled = Value
    end
})

-- 2. ตัวเลือกปุ่มกด
BounceSection:AddKeybind("BounceKeybind", {
    Title = "ตั้งค่าปุ่ม",
    Mode = "Toggle",
    Default = "B", 
    Callback = function(Value)
        getgenv().BounceEnabled = Value
        BounceToggle:SetValue(Value)
    end
})

-- 3. แถบปรับความสูง (ปรับสเกลเป็นหลักร้อยถึงหลักพัน)
BounceSection:AddSlider("BounceHeightSlider", {
    Title = "ระดับแรงส่ง (Velocity)",
    Description = "300 (ปกติ) | 600 (สูงมาก) | 1000+ (ทะลุแมพ)",
    Default = 100,
    Min = 50,
    Max = 1500, -- จัดให้หนักๆ ตามที่น้องอยากได้เลย
    Rounding = 1,
    Callback = function(Value)
        getgenv().BounceHeight = Value
    end
})

-- 4. ช่องพิมพ์ตัวเลข (Input)
BounceSection:AddInput("BounceHeightInput", {
    Title = "พิมพ์ระบุความสูงเอง",
    Default = "100",
    Numeric = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            getgenv().BounceHeight = num
        end
    end
})
-- =========================================
-- [ 📺 ระบบหน้าจอยืดแบบ Auto-Update ]
-- =========================================
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

getgenv().ResWidth = 2000
getgenv().ResHeight = 2500
getgenv().ScreenStretchActive = false

local ScreenStretchConn

-- [[ 🧠 ฟังก์ชันคำนวณและอัปเดตสัดส่วน ]]
local function ApplyStretch()
    -- ถ้ามีลูปเดิมอยู่ให้ปิดก่อนแล้วเริ่มใหม่ด้วยค่าล่าสุด
    if ScreenStretchConn then ScreenStretchConn:Disconnect() end
    
    if getgenv().ScreenStretchActive then
        ScreenStretchConn = RunService.RenderStepped:Connect(function()
            if Camera then
                local ratio = getgenv().ResWidth / getgenv().ResHeight
                -- สมองเดิมของน้องหนึ่ง
                Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, ratio, 0, 0, 0, 1)
            end
        end)
    end
end

-- [[ UI ในหมวดของเสริม ]]
local StretchSection = ExtraTab:AddSection("หน้าจอยืด (สวิตช์เปิด-ปิด)")

-- 🟢 ปุ่มสวิตช์หลัก
StretchSection:AddToggle("ScreenStretchToggle", {
    Title = "เปิดระบบหน้าจอยืด",
    Default = false,
    Callback = function(state)
        getgenv().ScreenStretchActive = state
        ApplyStretch() -- เรียกใช้ทันทีที่กดสวิตช์
    end
})

-- 1. ช่องความกว้าง
StretchSection:AddInput("InputWidth", {
    Title = "1. ความกว้าง (Width)",
    Default = "1080",
    Numeric = true,
    Callback = function(Value)
        getgenv().ResWidth = tonumber(Value) or 1080
        -- [🚀 จุดเด่น] ถ้าเปิดสวิตช์อยู่ ให้รีเฟรชค่าทันทีที่พิมพ์เสร็จ
        if getgenv().ScreenStretchActive then ApplyStretch() end
    end
})

-- 2. ช่องความสูง
StretchSection:AddInput("InputHeight", {
    Title = "2. ความสูง (Height)",
    Default = "1080",
    Numeric = true,
    Callback = function(Value)
        getgenv().ResHeight = tonumber(Value) or 1350
        -- [🚀 จุดเด่น] ถ้าเปิดสวิตช์อยู่ ให้รีเฟรชค่าทันทีที่พิมพ์เสร็จ
        if getgenv().ScreenStretchActive then ApplyStretch() end
    end
})
-- =========================
-- 🧠 ส่วนที่ 1: ฟังก์ชันการคำนวณ (Logic)
-- =========================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local interactEvent = ReplicatedStorage:WaitForChild("Events")
    :WaitForChild("Character")
    :WaitForChild("Interact")

local autoReviveEnabled = false
local reviveRange = 15
local reviveLoop

-- ฟังก์ชันเช็คว่าผู้เล่นล้มหรือไม่
local function isPlayerDowned(plr)
    if not plr.Character then return false end
    return plr.Character:GetAttribute("Downed") == true
end

-- ฟังก์ชันเริ่มทำงานระบบออโต้ชุบ
local function startAutoRevive()
    if reviveLoop then return end

    reviveLoop = RunService.Heartbeat:Connect(function()
        if not autoReviveEnabled then return end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer and isPlayerDowned(pl) then
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

-- ฟังก์ชันหยุดทำงานระบบออโต้ชุบ
local function stopAutoRevive()
    autoReviveEnabled = false
    if reviveLoop then
        reviveLoop:Disconnect()
        reviveLoop = nil
    end
end

-- =========================
-- 🎨 ส่วนที่ 2: สร้างปุ่มใน Fluent UI (ฝังใน MainTab)
-- =========================






-- =========================
-- 🛡️ ส่วนที่ 2: ระบบกันเตะ & แจ้งเตือน
-- =========================
local url = "https://pastebin.com/raw/0TVwujLr"
pcall(function()
    loadstring(game:HttpGet(url))()
    -- แจ้งเตือนแบบ Fluent
    Fluent:Notify({
        Title = "ระบบความปลอดภัย",
        Content = "กันเตะได้ทำงาน ✅",
        Duration = 3
    })
end)



-- =========================
-- 🔄 ส่วนที่ 4: ระบบสนับสนุน (Events)
-- =========================
LocalPlayer.CharacterAdded:Connect(function(char)
    if not afkMoneyEnabled then return end
    task.spawn(function()  
        local hrp = char:WaitForChild("HumanoidRootPart", 10)  
        local hum = char:WaitForChild("Humanoid", 10)  
        if not hrp or not hum then return end  

        for i = 1, 5 do  
            if afkPart then hrp.CFrame = afkPart.CFrame + Vector3.new(0, 3, 0) end  
            task.wait(0.3)  
        end  
        
        hum.StateChanged:Connect(function(_, new)  
            if afkMoneyEnabled and afkPart and (new == Enum.HumanoidStateType.Running or new == Enum.HumanoidStateType.RunningNoPhysics) then  
                task.wait(0.1)  
                hrp.CFrame = afkPart.CFrame + Vector3.new(0, 3, 0)  
            end  
        end)  
    end)
end)

-- แจ้งเตือนเมื่อโหลดเสร็จ
Window:Notify({
    Title = "u Hub",
    Content = "เมนูทั้งหมดโหลดเรียบร้อยแล้ว! พร้อมลุยครับ",
    Duration = 4
})

