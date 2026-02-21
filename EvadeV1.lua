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
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Sidebar line
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0,1,1,0)
SidebarLine.Position = UDim2.new(0,140,0,0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(60,60,60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Parent = game:GetService("CoreGui")

-- Tabs
local MainTab     = Window:AddTab({Title="เมนูหลัก", Icon="star"})
local TeleportTab = Window:AddTab({Title="เทเลพอร์ต", Icon="navigation"})
local VisualsTab  = Window:AddTab({Title="มองต่างๆ", Icon="eye"})
local ExtraTab    = Window:AddTab({Title="ของเสริม", Icon="tag"})
local FPSTab      = Window:AddTab({Title="FPS", Icon="speedometer"})
local EventTab    = Window:AddTab({Title="เกี่ยวกับอีเว้น", Icon="calendar"})
local SettingsTab = Window:AddTab({Title="ตั้งค่า", Icon="wrench"})

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
-- =========================================
-- [ 4. เมนูหลัก: AUTO RESPAWN ]
-- =========================================
local RespawnSection = MainTab:AddSection("ระบบคืนชีพ (Auto Respawn)")
getgenv().AutoRespawnEnabled = false
local autoRespawnMethod = "Fake Revive"
local lastSavedPosition
local floatingRespawnButton

local function createRespawnFloatingButton()
    if floatingRespawnButton then return end
    floatingRespawnButton = Instance.new("TextButton", FloatingGui)
    floatingRespawnButton.Size = UDim2.new(0,120,0,50)
    floatingRespawnButton.Position = UDim2.new(0.8,0,0.8,0)
    floatingRespawnButton.Text = "Auto Respawn"
    floatingRespawnButton.Active = true
    floatingRespawnButton.Draggable = true
    StyleFloatingButton(floatingRespawnButton)
    floatingRespawnButton.MouseButton1Click:Connect(function()
        getgenv().AutoRespawnEnabled = not getgenv().AutoRespawnEnabled
        floatingRespawnButton.BackgroundTransparency = getgenv().AutoRespawnEnabled and 0.1 or 0.4
    end)
end

RespawnSection:AddToggle("RespawnToggle", {Title="ออโต้รีสปอน (ปกติ)", Default=false, Callback=function(v) getgenv().AutoRespawnEnabled = v end})
RespawnSection:AddToggle("RespawnFloat", {Title="ออโต้รีสปอน (ปุ่มลอย)", Default=false, Callback=function(v)
    if v then createRespawnFloatingButton() else if floatingRespawnButton then floatingRespawnButton:Destroy() floatingRespawnButton=nil end end
end})
RespawnSection:AddDropdown("RespawnMethod", {Title="วิธีรีสปอน", Values={"Random","Fake Revive"}, CurrentValue="Fake Revive", Callback=function(v) autoRespawnMethod = v end})

local function setupAutoRevive(character)
    task.defer(function()
        character:WaitForChild("HumanoidRootPart",5)
        task.spawn(function()
            while character and character.Parent do
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then character:SetAttribute("LastPosition", hrp.Position) end
                task.wait(0.2)
            end
        end)
        character:GetAttributeChangedSignal("Downed"):Connect(function()
            if not getgenv().AutoRespawnEnabled or character:GetAttribute("Downed") ~= true then return end
            if autoRespawnMethod ~= "Fake Revive" then return end
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then lastSavedPosition = hrp.Position end
            task.wait(3)
            pcall(function() game:GetService("ReplicatedStorage").Events.Player.ChangePlayerMode:FireServer(true) end)
            local newChar = player.CharacterAdded:Wait()
            local newHRP = newChar:WaitForChild("HumanoidRootPart", 5)
            if lastSavedPosition and newHRP then newHRP.CFrame = CFrame.new(lastSavedPosition) end
        end)
    end)
end
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

-- =========================================
-- [ 6. ของเสริม: AFK MONEY ]
-- =========================================
local ExtraSection = ExtraTab:AddSection("ระบบฟาร์ม")
local afkPart, afkLoop

ExtraSection:AddToggle("AFKMoneyToggle", {Title="เปิดฟาร์มเงิน AFK", Default=false, Callback=function(v)
    if v then
        afkPart = Instance.new("Part", workspace)
        afkPart.Size, afkPart.Position, afkPart.Anchored, afkPart.Transparency = Vector3.new(8, 1, 8), Vector3.new(0, 6000, 0), true, 1
        afkLoop = game:GetService("RunService").Heartbeat:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = afkPart.CFrame + Vector3.new(0, 4, 0)
            end
        end)
    else
        if afkLoop then afkLoop:Disconnect() afkLoop = nil end
        if afkPart then afkPart:Destroy() afkPart = nil end
    end
end})
