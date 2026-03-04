-- [[ 🛡️ ระบบกันโดนเตะ (Anti-AFK) ]]       ตอนนี้ถึงการทำชุบคน
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
local FPSTab      = Window:AddTab({Title = "fps", Icon = "accessibility"})
local EventTab    = Window:AddTab({Title="เกี่ยวกับอีเว้น", Icon="calendar"}) -- แถบนี้แหละ!
local SettingsTab = Window:AddTab({Title="ตั้งค่า", Icon="wrench"})


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
    Title = "เปิดระบบ U-HUB Ticket Farm (White Large)",
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
-- [ 1. เมนูหลัก: AUTO BHOP ]
-- =========================================
local BhopSection = MainTab:AddSection("ระบบกระโดด (Auto Bhop)")
local autoBhop = false
local floatingBhopButton

local function createBhopFloatingButton()
    if floatingBhopButton then return end
    floatingBhopButton = Instance.new("TextButton", FloatingGui)
    floatingBhopButton.Size = UDim2.new(0,120,0,50)
    floatingBhopButton.Position = UDim2.new(0.3,-60,0.8,0)
    floatingBhopButton.AnchorPoint = Vector2.new(0.5,0)
    floatingBhopButton.Text = "Auto Bhop: OFF"
    floatingBhopButton.Active = true
    floatingBhopButton.Draggable = true
    StyleFloatingButton(floatingBhopButton)
    floatingBhopButton.MouseButton1Click:Connect(function()
        autoBhop = not autoBhop
        floatingBhopButton.Text = autoBhop and "Auto Bhop: ON" or "Auto Bhop: OFF"
    end)
end

BhopSection:AddToggle("AutoBhopToggle", {Title="ออโต้กระโดด (ปกติ)", Default=false, Callback=function(v) autoBhop = v end})
BhopSection:AddToggle("AutoBhopFloat", {Title="ออโต้กระโดด (ปุ่มลอย)", Default=false, Callback=function(v)
    if v then createBhopFloatingButton() else if floatingBhopButton then floatingBhopButton:Destroy() floatingBhopButton=nil end end
end})
BhopSection:AddKeybind("BhopKey", {Title="ตั้งค่าปุ่มคีย์บอร์ด", Mode="Toggle", Default="B", Callback=function(v) autoBhop = v end})

task.spawn(function()
    local RunService = game:GetService("RunService")
    while true do
        RunService.Heartbeat:Wait()
        if autoBhop then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid and root then
                local ray = Ray.new(root.Position, Vector3.new(0, -4, 0))
                local hit = workspace:FindPartOnRay(ray, char)
                if hit then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
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
local floatingLagButton

local function lagSwitch(duration)
    local start = tick()
    while tick()-start < duration do 
        for i=1,1e7 do local a=math.random() end 
    end
end

local function createLagFloatingButton()
    if floatingLagButton then return end
    floatingLagButton = Instance.new("TextButton", FloatingGui)
    floatingLagButton.Size = UDim2.new(0,100,0,50)
    floatingLagButton.Position = UDim2.new(0.7,-50,0.8,0)
    floatingLagButton.AnchorPoint = Vector2.new(0.5,0)
    floatingLagButton.Text = "Lag Switch"
    floatingLagButton.Active = true
    floatingLagButton.Draggable = true
    StyleFloatingButton(floatingLagButton) -- ใช้ฟังก์ชันแต่งสีฟ้าที่น้องสั่ง
    
    floatingLagButton.MouseButton1Click:Connect(function() 
        lagSwitch(0.5) 
    end)
end

LagSection:AddButton({
    Title = "Lag Switch (กดครั้งเดียว)", 
    Callback = function() lagSwitch(0.5) end
})

-- แก้ไขตรงนี้: ใส่ตัวแปร v เพื่อเช็คสถานะเปิด/ปิดปุ่มลอย
LagSection:AddToggle("LagFloatToggle", {
    Title = "Lag Switch (ปุ่มลอย)", 
    Default = false, 
    Callback = function(v)
        if v then 
            createLagFloatingButton() 
        else 
            if floatingLagButton then 
                floatingLagButton:Destroy() 
                floatingLagButton = nil 
            end 
        end
    end
})

LagSection:AddKeybind("LagKey", {
    Title = "ตั้งค่าปุ่มคีย์บอร์ด (กดค้าง)", 
    Mode = "Hold", 
    Default = "Z", 
    Callback = function(v) 
        if v then lagSwitch(0.5) end 
    end
})

-------------------------------------------------------------------------
-- [[ ✅ แก้ไขส่วนที่ Error: สร้าง Section และรวมระบบเกิดใหม่ ]]
-------------------------------------------------------------------------

-- 1. สร้าง Section ใน MainTab ก่อนจะไปสร้างปุ่ม (ป้องกัน Error บรรทัด 519)
local RespawnSection = MainTab:AddSection("ระบบจัดการตัวละคร")

-- 2. ตัวแปรสำหรับระบบเกิดใหม่ (Auto Revive)
getgenv().AutoRespawnEnabled = false 
local lastSavedPosition = nil
local autoRespawnMethod = "Fake Revive"

-- 3. ปุ่ม Toggle สำหรับเปิด-ปิด (ในเมนู)
RespawnSection:AddToggle("RespawnToggle", {
    Title = "ออโต้รีสปอน (Auto Revive)", 
    Default = false, 
    Callback = function(v) 
        getgenv().AutoRespawnEnabled = v 
    end
})

-- 4. Dropdown เลือกวิธี (ตามโค้ดเดิมน้องหนึ่ง)
RespawnSection:AddDropdown("RespawnMethod", {
    Title = "วิธีรีสปอน", 
    Values = {"Random", "Fake Revive"}, 
    CurrentValue = "Fake Revive", 
    Callback = function(v) 
        autoRespawnMethod = v 
    end
})

-- 5. สมองของระบบ (Auto Revive Logic)
local function setupAutoRevive(character)
    task.defer(function()
        local hrp = character:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end

        -- เก็บตำแหน่งล่าสุด
        task.spawn(function()
            while character and character.Parent do
                if hrp and hrp.Parent then lastSavedPosition = hrp.Position end
                task.wait(0.5)
            end
        end)

        -- เช็คตอนล้ม
        character:GetAttributeChangedSignal("Downed"):Connect(function()
            if not getgenv().AutoRespawnEnabled or character:GetAttribute("Downed") ~= true then return end
            
            task.wait(3) -- รอ 3 วิ
            pcall(function() 
                game:GetService("ReplicatedStorage").Events.Player.ChangePlayerMode:FireServer(true) 
            end)

            -- วาร์ปกลับจุดเดิม
            local newChar = player.CharacterAdded:Wait()
            local newHRP = newChar:WaitForChild("HumanoidRootPart", 5)
            if lastSavedPosition and newHRP then 
                newHRP.CFrame = CFrame.new(lastSavedPosition) 
            end
        end)
    end)
end

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
-- [ EXTRA: WALL HACK ]
-- =========================================
local WallSection = ExtraTab:AddSection("ระบบทะลุกำแพง")
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
    if floatingWallButton then floatingWallButton.Text = wallHackActive and "Wall Hack: ON" or "Wall Hack: OFF" end
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

WallSection:AddToggle("WallHackToggle", {Title="Wall Hack (ปกติ)", Default=false, Callback=setWallHack})

local function createWallFloatingButton()
    if floatingWallButton then return end
    floatingWallButton = Instance.new("TextButton", FloatingGui)
    floatingWallButton.Size = UDim2.new(0,100,0,50)
    floatingWallButton.Position = UDim2.new(0.2,-50,0.6,0)
    floatingWallButton.Text = "Wall Hack: OFF"
    floatingWallButton.Draggable = true
    floatingWallButton.Active = true
    StyleNeungButton(floatingWallButton)
    floatingWallButton.MouseButton1Click:Connect(toggleWallHack)
end

WallSection:AddToggle("WallFloat", {Title="Wall Hack (ปุ่มลอย)", Default=false, Callback=function(v)
    if v then createWallFloatingButton() else if floatingWallButton then floatingWallButton:Destroy(); floatingWallButton=nil end setWallHack(false) end
end})

WallSection:AddKeybind("WallKey", {Title="ปุ่ม Wall Hack", Mode="Toggle", Default="K", Callback=setWallHack})

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
    bg.Size = UDim2.fromScale(1,1); bg.BackgroundColor3 = Color3.fromRGB(255, 105, 180); bg.BackgroundTransparency = 0.25
    
    local text = Instance.new("TextLabel", bg)
    text.Name = "InfoText"; text.Size = UDim2.fromScale(1,1); text.BackgroundTransparency = 1; text.TextColor3 = Color3.new(1,1,1)
    text.TextScaled = true; text.Font = Enum.Font.GothamBold
    text.Text = "U-HUB\nกำลังเตรียมตัว..."

    local heartL = Instance.new("TextLabel", bg)
    heartL.Text = "💖"; heartL.Size = UDim2.fromScale(0.1, 0.1); heartL.Position = UDim2.fromScale(0.1, 0.5); heartL.BackgroundTransparency = 1; heartL.TextScaled = true
    local heartR = heartL:Clone(); heartR.Parent = bg; heartR.Position = UDim2.fromScale(0.8, 0.5)
    
    return gui
end

-- [[ 🎡 3. สร้างระบบ Toggle ]]
local TicketSection = EventTab:AddSection("ระบบตั๋ว (Ticket System)")

local TicketToggleUI = TicketSection:AddToggle("UHubTicketToggle", {
    Title = "เปิดระบบ U-HUB Ticket Farm",
    Description = "ฟาร์มตั๋ว + นับคะแนน + ที่ยืน [N] ปิด/เปิด",
    Default = false,
    Callback = function(state)
        getgenv().AutoTicketFarm = state
        ManagePlatform(state)
        
        if state then
            LastTimeTick = tick()
            local ui = CreateUHubUI()
            game:GetService("Lighting").Ambient = Color3.fromRGB(255, 150, 200)

            task.spawn(function()
                while getgenv().AutoTicketFarm do
                    -- เช็ค UI
                    if not LocalPlayer.PlayerGui:FindFirstChild("UHubOverlay") then ui = CreateUHubUI() end
                    
                    -- อัปเดตข้อมูล UI (เวลา + คะแนน)
                    if ui and ui:FindFirstChild("InfoText", true) then
                        local currentTick = tick()
                        _G.TotalFarmSeconds = _G.TotalFarmSeconds + (currentTick - LastTimeTick)
                        LastTimeTick = currentTick
                        ui:FindFirstChild("InfoText", true).Text = string.format(
                            "U-HUB\nAUTO TICKET\nคะแนนที่เก็บได้: %d ใบ\nเวลาสะสม: %s",
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
                                    -- วาร์ปเก็บตั๋ว
                                    hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                                    ManagePlatform(true, part.Position) -- ย้ายที่ยืนไปรอง
                                    
                                    _G.TicketScore = _G.TicketScore + 1 -- บวกคะแนน
                                    task.wait(1) -- เวลารอเก็บ
                                end
                            end
                        else
                            -- ถ้าไม่มีตั๋ว ให้วาร์ปขึ้นที่สูงไปรอ
                            hrp.CFrame = CFrame.new(hrp.Position.X, 1250, hrp.Position.Z)
                            ManagePlatform(true, hrp.Position)
                        end
                    end
                    task.wait(0.5)
                end
            end)

            Fluent:Notify({Title = "U-HUB", Content = "เริ่มฟาร์มแล้ว! เก็บให้เรียบนะน้องหนึ่ง", Duration = 2})
        else
            -- ปิดระบบ
            if LocalPlayer.PlayerGui:FindFirstChild("UHubOverlay") then LocalPlayer.PlayerGui.UHubOverlay:Destroy() end
            game:GetService("Lighting").Ambient = Color3.fromRGB(127, 127, 127)
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
                                        label.TextScaled = true
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
                                        if dist <= 20 then
                                            label.TextColor3 = Color3.fromRGB(255, 50, 50) -- แดงจัด (อันตรายมาก)
                                        elseif dist <= 70 then
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
local FPSSection = FPSTab:AddSection("เพิ่มความลื่น (Optimization)")

FPSSection:AddButton({Title = "แสดง FPS", Callback = function()
    -- Logic แสดง FPS ใน ScreenGui ที่น้องส่งมา
end})

FPSSection:AddButton({Title = "ลดกราฟฟิก V.1 (เรียบเนียน)", Callback = function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic; obj.Reflectance = 0 end
    end
end})

FPSSection:AddButton({Title = "ลดกราฟฟิก V.2 (ลบเอฟเฟกต์)", Callback = function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Decal") then obj:Destroy() end
    end
end})


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
                textLabel.Text = string.format("🆘 %s\n%d studs", plr.Name, dist)
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
    Title = "เปิดใช้งาน Auto Bounce",
    Default = false,
    Callback = function(Value)
        getgenv().BounceEnabled = Value
    end
})

-- 2. ตัวเลือกปุ่มกด
BounceSection:AddKeybind("BounceKeybind", {
    Title = "ตั้งค่าปุ่ม Hotkey",
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
-- [ 📺 ระบบหน้าจอยืดแบบแยกช่องคำนวณ ]
-- =========================================
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- ค่าเริ่มต้น
getgenv().ResWidth = 2000
getgenv().ResHeight = 2500
getgenv().ScreenStretchActive = false

local ScreenStretchConn

-- [[ 🧠 ฟังก์ชันคำนวณสัดส่วน ]]
local function GetCalculatedStretch()
    if getgenv().ResWidth > 0 and getgenv().ResHeight > 0 then
        return getgenv().ResWidth / getgenv().ResHeight
    end
    return 1
end

local function UpdateStretch()
    if ScreenStretchConn then ScreenStretchConn:Disconnect() end
    ScreenStretchConn = RunService.RenderStepped:Connect(function()
        if Camera and getgenv().ScreenStretchActive then
            local ratio = GetCalculatedStretch()
            -- ใช้ค่าที่คำนวณได้ไปยืดแกน Y (หรือเปลี่ยนไป X ตามชอบ)
            Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, ratio, 0, 0, 0, 1)
        end
    end)
end

-- [[ UI ในหมวดของเสริม ]]
local StretchSection = ExtraTab:AddSection("หน้าจอยืด (แยกช่องคำนวณ) ถ้ากดค่าเริ่มต้นแล้วไม่เข้าให้ใส่ตัวเลขเดิม")

StretchSection:AddToggle("ScreenStretchToggle", {
    Title = "เปิดระบบหน้าจอยืด",
    Default = false,
    Callback = function(state)
        getgenv().ScreenStretchActive = state
        if state then UpdateStretch() else
            if ScreenStretchConn then ScreenStretchConn:Disconnect() ScreenStretchConn = nil end
        end
    end
})

-- ช่องที่ 1: ความกว้าง (Width)
StretchSection:AddInput("InputWidth", {
    Title = "1. พิมพ์ความกว้าง (Width)",
    Default = "2000",
    Numeric = true,
    Callback = function(Value)
        getgenv().ResWidth = tonumber(Value) or 1080
    end
})

-- ช่องที่ 2: ความสูง (Height)
StretchSection:AddInput("InputHeight", {
    Title = "2. พิมพ์ความสูง (Height)",
    Default = "2500",
    Numeric = true,
    Callback = function(Value)
        getgenv().ResHeight = tonumber(Value) or 1080
    end
})

StretchSection:AddParagraph({
    Title = "📝 สูตรที่ใช้คำนวณ",
    Content = "ระบบจะเอา: [ความกว้าง] ÷ [ความสูง]\nตัวอย่าง: 1080 ÷ 1080 = 1.0 (ปกติ)\nตัวอย่าง: 800 ÷ 1080 = 0.74 (ยืดขึ้น)"
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

-- พี่เปลี่ยนชื่อคำสั่งให้ตรงกับสคริปต์น้องแล้วนะ
MainTab:AddToggle("AutoReviveToggle", {
    Title = "ออโต้ชุบเพื่อน",
    Description = "ชุบผู้เล่นที่ล้มอัตโนมัติเมื่ออยู่ใกล้ (ระยะ 15 studs)",
    Default = false,
    Callback = function(state)
        autoReviveEnabled = state
        if state then
            startAutoRevive()
            print("U-HUB: ระบบออโต้ชุบเปิดทำงาน")
        else
            stopAutoRevive()
            print("U-HUB: ระบบออโต้ชุบปิดทำงาน")
        end
    end
})

-- =========================
-- 🧠 ส่วนที่ 1: ตั้งค่าและฟังก์ชัน (Logic)
-- =========================
local REVIVE_RANGE = 15 -- ระยะชุบ
local REVIVE_CHECK_DELAY = 0.1 -- ความถี่ในการเช็ค (วินาที)
local autoReviveEnabled = false
local reviveLoop = nil

-- ฟังก์ชันเริ่มระบบชุบ (ใช้ task.spawn ตามโครงสร้างที่น้องส่งมา)
local function startAutoRevive()
    if reviveLoop then return end

    autoReviveEnabled = true
    reviveLoop = task.spawn(function()  
        while autoReviveEnabled do  
            local char = LocalPlayer.Character  
            local hrp = char and char:FindFirstChild("HumanoidRootPart")  

            if hrp then  
                for _, pl in ipairs(Players:GetPlayers()) do  
                    if pl ~= LocalPlayer and isPlayerDowned(pl) then -- ใช้ฟังก์ชันเช็คที่สร้างไว้ก่อนหน้า
                        local pChar = pl.Character  
                        local pHrp = pChar and pChar:FindFirstChild("HumanoidRootPart")  
                        if pHrp then  
                            local dist = (hrp.Position - pHrp.Position).Magnitude  
                            if dist <= REVIVE_RANGE then  
                                pcall(function()  
                                    interactEvent:FireServer("Revive", true, pl.Name)  
                                end)  
                            end  
                        end  
                    end  
                end  
            end  

            task.wait(REVIVE_CHECK_DELAY)  
        end  
        reviveLoop = nil  
    end)
end

-- ฟังก์ชันหยุดระบบชุบ
local function stopAutoRevive()
    autoReviveEnabled = false
    -- loop จะหลุดเองเพราะเงื่อนไข while autoReviveEnabled เป็น false
end




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

