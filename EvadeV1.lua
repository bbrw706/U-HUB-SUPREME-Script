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

-- [[ EVADE SCRIPT: FLUENT VERSION - FULL INTEGRATED PART 2 ]]
-- น้องหนึ่ง โค้ดนี้รวมฟังก์ชันใหม่ทั้งหมด พร้อมปุ่มลอยสีฟ้าและ Keybind ในตัวครับ

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

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

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

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
-- [[ 🧠 1. เตรียมสมองและตัวแปร ]]
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TotalFarmSeconds = 0
local LastTimeTick = tick()
local Platform = nil 
local TicketToggleUI 

local function FormatUHubTime(seconds)
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", hours, mins, secs)
end

-- 🧠 ฟังก์ชันสร้างฐานที่ยืน (Platform)
local function CreatePlatform(pos)
    if not getgenv().AutoTicketFarm then return end
    if not Platform or not Platform.Parent then
        Platform = Instance.new("Part")
        Platform.Name = "UHubPlatform"
        Platform.Size = Vector3.new(15, 1, 15)
        Platform.Anchored = true
        Platform.Transparency = 0.5
        Platform.Color = Color3.fromRGB(255, 105, 180) -- สีชมพู
        Platform.Material = Enum.Material.Glass
        Platform.Parent = workspace
    end
    Platform.CFrame = CFrame.new(pos.X, pos.Y - 3.5, pos.Z)
end

local function RemovePlatform()
    if Platform then Platform:Destroy(); Platform = nil end
end

-- [[ 🧠 2. ระบบฟาร์มและวาร์ป (สมองหลัก) ]]
task.spawn(function()
    while task.wait(0.2) do
        -- ถ้าปิดสวิตช์หลัก ให้หยุดทุกอย่าง
        if not getgenv().AutoTicketFarm then 
            RemovePlatform()
            continue 
        end

        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        -- 🛑 กรณีกด "หยุดชั่วคราว"
        if getgenv().Stopped then 
            hrp.CFrame = CFrame.new(hrp.Position.X, 1250, hrp.Position.Z)
            CreatePlatform(hrp.Position) -- สร้างที่ยืน
            continue 
        end

        local ticketsFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")
        local foundTicket = false
        
        if ticketsFolder then
            local allTickets = ticketsFolder:GetChildren()
            if #allTickets > 0 then
                for _, ticket in pairs(allTickets) do
                    if not getgenv().AutoTicketFarm or getgenv().Stopped then break end
                    local root = ticket:FindFirstChild("HumanoidRootPart")
                    if root and ticket.Parent then
                        foundTicket = true
                        RemovePlatform() -- ลบที่ยืนก่อนวาร์ปไปเก็บ
                        hrp.CFrame = root.CFrame * CFrame.new(0, 2, 0)
                        pcall(function() game:GetService("ReplicatedStorage").Events.CollectTicket:FireServer(ticket) end)
                        break
                    end
                end
            end
        end

        -- 🛑 กรณีไม่มีตั๋ว ให้วาร์ปขึ้นที่สูง + สร้างที่ยืน
        if not foundTicket and getgenv().AutoTicketFarm and not getgenv().Stopped then
            hrp.CFrame = CFrame.new(hrp.Position.X, 1250, hrp.Position.Z)
            CreatePlatform(hrp.Position)
        end
    end
end)

-- [[ 🧠 3. ระบบ UI และ Toggle ]]
local TicketSection = EventTab:AddSection("ระบบตั๋ว (Ticket System)")

TicketToggleUI = TicketSection:AddToggle("UHubTicketToggle", {
    Title = "เปิดระบบ U-HUB Ticket Farm",
    Description = "กด [N] เพื่อปิด/เปิดฟาร์ม",
    Default = false,
    Callback = function(state)
        getgenv().AutoTicketFarm = state
        
        if not state then
            getgenv().Stopped = true
            if game.Players.LocalPlayer.PlayerGui:FindFirstChild("UHubOverlay") then game.Players.LocalPlayer.PlayerGui.UHubOverlay:Destroy() end
            if game.Players.LocalPlayer.PlayerGui:FindFirstChild("UHubStopBtn") then game.Players.LocalPlayer.PlayerGui.UHubStopBtn:Destroy() end
            RemovePlatform()
            game:GetService("Lighting").Ambient = Color3.fromRGB(127, 127, 127)
            
            -- วาร์ปลงพื้น
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(hrp.Position.X, 10, hrp.Position.Z) end
            return
        end

        getgenv().Stopped = false
        LastTimeTick = tick()
        game:GetService("Lighting").Ambient = Color3.fromRGB(255,150,200)

        -- สร้าง UI Overlay สวยๆ
        local gui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
        gui.Name = "UHubOverlay"; gui.IgnoreGuiInset = true
        local bg = Instance.new("Frame", gui)
        bg.Size = UDim2.fromScale(1,1); bg.BackgroundColor3 = Color3.fromRGB(255,105,180); bg.BackgroundTransparency = 0.25
        local text = Instance.new("TextLabel", bg)
        text.Size = UDim2.fromScale(1,1); text.BackgroundTransparency = 1; text.TextColor3 = Color3.new(1,1,1)
        text.TextScaled = true; text.Font = Enum.Font.GothamBold

        -- หัวใจกุ๊กกิ๊ก
        local heartL = Instance.new("TextLabel", bg)
        heartL.Text = "💖"; heartL.Size = UDim2.fromScale(0.1, 0.1); heartL.Position = UDim2.fromScale(0.1, 0.5); heartL.BackgroundTransparency = 1; heartL.TextScaled = true
        local heartR = heartL:Clone(); heartR.Parent = bg; heartR.Position = UDim2.fromScale(0.8, 0.5)

        task.spawn(function()
            while getgenv().AutoTicketFarm and not getgenv().Stopped do
                local currentTick = tick()
                TotalFarmSeconds = TotalFarmSeconds + (currentTick - LastTimeTick)
                LastTimeTick = currentTick
                text.Text = "U-HUB\nAUTO TICKET\nฟาร์มตั๋ววาเลนไทน์\nเวลาสะสม: " .. FormatUHubTime(TotalFarmSeconds)
                task.wait(1)
            end
        end)

        -- ปุ่มลอย
        local btnGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
        btnGui.Name = "UHubStopBtn"; btnGui.ResetOnSpawn = false
        local button = Instance.new("TextButton", btnGui)
        button.Size = UDim2.fromOffset(150,45); button.Position = UDim2.fromScale(0.5,0.8); button.AnchorPoint = Vector2.new(0.5,0.5)
        button.Text = "หยุดฟาร์ม"; button.BackgroundColor3 = Color3.fromRGB(255,20,147); button.TextColor3 = Color3.new(1,1,1)
        button.TextScaled = true; button.Font = Enum.Font.GothamBold; Instance.new("UICorner", button); button.Draggable = true; button.Active = true

        button.MouseButton1Click:Connect(function()
            getgenv().Stopped = not getgenv().Stopped
            if getgenv().Stopped then
                button.Text = "เริ่มฟาร์มต่อ"; button.BackgroundColor3 = Color3.fromRGB(0, 170, 255); bg.Visible = false
            else
                button.Text = "หยุดฟาร์ม"; button.BackgroundColor3 = Color3.fromRGB(255,20,147); bg.Visible = true; LastTimeTick = tick()
            end
        end)
    end
})

-- [[ 🧠 4. ระบบปุ่ม N ]]
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.N then
        if TicketToggleUI then TicketToggleUI:SetValue(not getgenv().AutoTicketFarm) end
    end
end)

TicketSection:AddKeybind("AutoTicketKey", {Title = "ปุ่มฟาร์มตั๋ว", Default = "N", Callback = function(v) getgenv().AutoTicketFarm = v end})

-- =========================================
-- [ VISUALS: ESP NEXTBOT ]
-- =========================================
local NextbotSection = VisualsTab:AddSection("มองศัตรู (Nextbot)")

NextbotSection:AddToggle("NextbotESPToggle", {Title = "มองเน็กบอท", Default = false, Callback = function(v) _G.NextbotESPEnabled = v end})

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

-- =========================================
-- [ TELEPORT: MOUSE CLICK ]
-- =========================================
local TPMouseSection = TeleportTab:AddSection("วาร์ปตามเมาส์")
local teleportEnabled = false
local floatingTeleportButton

local function runTeleportClick()
    local mouse = player:GetMouse()
    if teleportEnabled then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
    end
end

TPMouseSection:AddToggle("TPClickToggle", {Title = "เปิด Teleport Mode", Default = false, Callback = function(v) teleportEnabled = v end})

local function createFloatingTeleportButton()
    if floatingTeleportButton then return end
    floatingTeleportButton = Instance.new("TextButton", FloatingGui)
    floatingTeleportButton.Size = UDim2.new(0, 140, 0, 50)
    floatingTeleportButton.Position = UDim2.new(0.5, -70, 0.4, 0)
    floatingTeleportButton.Text = "Teleport: OFF"
    floatingTeleportButton.Active = true
    floatingTeleportButton.Draggable = true
    StyleNeungButton(floatingTeleportButton)
    floatingTeleportButton.MouseButton1Click:Connect(function()
        teleportEnabled = not teleportEnabled
        floatingTeleportButton.Text = teleportEnabled and "Teleport: ON" or "Teleport: OFF"
    end)
end

TPMouseSection:AddToggle("TPClickFloat", {Title = "ปุ่มลอย Teleport", Default = false, Callback = function(v)
    if v then createFloatingTeleportButton() else if floatingTeleportButton then floatingTeleportButton:Destroy(); floatingTeleportButton=nil end end
end})

-- คีย์บอร์ดสำหรับ Teleport (ใช้ Click)
TPMouseSection:AddKeybind("TPClickKey", {Title = "ปุ่มวาร์ป (ตามเมาส์)", Mode = "Click", Default = "MouseButton1", Callback = runTeleportClick})

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


-- [[ 🧠 ส่วนที่ 1: เตรียมสมอง (วางไว้ด้านบนสุดของสคริปต์) ]]
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local downedESPEnabled = false
local downedBillboards = {}

-- ฟังก์ชันล้าง ESP คนล้ม
local function clearDownedESP()
    for _, billboard in pairs(downedBillboards) do
        if billboard then billboard:Destroy() end
    end
    downedBillboards = {}
end

-- ฟังก์ชันอัปเดตคนล้ม
local function updateDownedESP()
    clearDownedESP() -- ลบของเก่าก่อนอัปเดตใหม่
    if not downedESPEnabled then return end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            
            -- เช็คว่าล้มไหม (เลือด 0 หรือมี Attribute "Downed" ของเกม Evade)
            local isDowned = (humanoid and humanoid.Health <= 0) or plr.Character:GetAttribute("Downed") == true

            if root and isDowned then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "DownedESP"
                billboard.Adornee = root
                billboard.Size = UDim2.new(0, 150, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = root

                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = "🆘 ล้มตรงนี้!"
                textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.GothamBlack
                textLabel.Parent = billboard

                downedBillboards[plr] = billboard
            end
        end
    end
end

-- รัน Loop อัปเดต ESP แยกต่างหาก
task.spawn(function()
    while true do
        if downedESPEnabled then
            updateDownedESP()
        end
        task.wait(0.5)
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

-- 🧠 ฟังก์ชันนับชิ้นส่วนสดๆ (1 ชิ้น = 1 คะแนน / 3 ชิ้น = 4 คะแนน)
local function getLiveTicketValue(model)
    local partsCount = 0
    -- นับเฉพาะชิ้นส่วนที่เป็นตัวหัวใจ (Mesh หรือ Part)
    for _, obj in pairs(model:GetChildren()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            partsCount = partsCount + 1
        end
    end

    if partsCount >= 3 then
        return "4"
    else
        return "1"
    end
end

-- ฟังก์ชันสร้างป้าย ESP
local function createESP(part)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TicketESP"
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 160, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.Name = "TicketLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextStrokeTransparency = 0.3
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    return billboard
end

-- [[ 🧠 ส่วนที่ 2: ตัวปุ่มใน Fluent UI ]]
local TicketESPToggle = EventTab:AddToggle("TicketESP_LiveCheck", {
    Title = "มองตั๋ว (เช็คสด 0.2 วิ)",
    Description = "นับจำนวนชิ้นหัวใจแบบ Real-time",
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
                                -- ⚡️ เช็คสดๆ ทุก 0.2 วินาที ไม่มีการล็อคค่า
                                local amount = getLiveTicketValue(ticketModel)
                                local dist = getDistance(part.Position)
                                
                                if amount == "4" then
                                    label.TextColor3 = Color3.fromRGB(255, 20, 147)
                                    label.Text = string.format("💖 4 POINTS 💖\n[%.0f studs]", dist or 0)
                                else
                                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                                    label.Text = string.format("🤍 1 POINT\n[%.0f studs]", dist or 0)
                                end
                            end
                        end
                    end
                end
                task.wait(0.2) -- ⚡️ อัปเดตไวตามสั่ง (0.2 วินาที)
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
