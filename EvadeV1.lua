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

local Tabs = {
    -- หนึ่งสามารถสร้าง Tab ใหม่ตรงนี้ได้เลย เช่น Combat หรือ Visuals
}

-- Sidebar line
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0,1,1,0)
SidebarLine.Position = UDim2.new(0,140,0,0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(60,60,60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Parent = game:GetService("CoreGui")

-- Tabs
local SettingsTab = Window:AddTab({Title="ตั้งค่า", Icon="wrench"})
local MainTab     = Window:AddTab({Title="เมนูหลัก", Icon="star"})
local TeleportTab = Window:AddTab({Title="เทเลพอร์ต", Icon="navigation"})
local VisualsTab  = Window:AddTab({Title="มองต่างๆ", Icon="eye"})
local ExtraTab    = Window:AddTab({Title="ของเสริม", Icon="tag"})
local FPSTab      = Window:AddTab({Title="FPS", Icon="speedometer"})
local EventTab    = Window:AddTab({Title="เกี่ยวกับอีเว้น", Icon="calendar"})


-- Player & GUI
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Floating GUI
local FloatingGui = PlayerGui:FindFirstChild("EvadeFloatingGui")
if not FloatingGui then
FloatingGui = Instance.new("ScreenGui")
FloatingGui.Name = "EvadeFloatingGui"
FloatingGui.Parent = PlayerGui
FloatingGui.ResetOnSpawn = false
FloatingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
end


-- =========================
-- Auto Bhop (No Ground Touch)
-- =========================
local autoBhop = false
local floatingBhopAddButton

-- ปุ่มลอย
local function createBhopFloatingAddButton()
    if floatingBhopAddButton then return end
    floatingBhopAddButton = Instance.new("TextButton")
    floatingBhopAddButton.Size = UDim2.new(0,120,0,50)
    floatingBhopAddButton.Position = UDim2.new(0.3,-60,0.8,0)
    floatingBhopAddButton.AnchorPoint = Vector2.new(0.5,0)
    floatingBhopAddButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
    floatingBhopAddButton.TextColor3 = Color3.fromRGB(255,255,255)
    floatingBhopAddButton.Text = "Auto Bhop: OFF"
    floatingBhopAddButton.Parent = FloatingGui
    floatingBhopAddButton.Active = true
    floatingBhopAddButton.Draggable = true
    floatingBhopAddButton.MouseButton1Click:Connect(function()
        autoBhop = not autoBhop
        floatingBhopAddButton.Text = autoBhop and "Auto Bhop: ON" or "Auto Bhop: OFF"
    end)
end

local function removeBhopFloatingAddButton()
    if floatingBhopAddButton then
        floatingBhopAddButton:Destroy()
        floatingBhopAddButton=nil
    end
end

-- AddToggle ปกติใน MainTab
MainTab:AddToggle("001",{
    Title="ออโต้กระโดด (ปกติ)",
    Description="เด้งขึ้นอัตโนมัติแบบไม่แตะพื้น",
    Default=false,
    Callback=function(state)
        autoBhop = state
    end
})

-- AddToggle ปุ่มลอย
MainTab:AddToggle("002",{
    Title="ออโต้กระโดด (ปุ่มลอย)",
    Description="แสดงปุ่มลอยสำหรับ Auto Bhop",
    Default=false,
    Callback=function(state)
        if state then createBhopFloatingAddButton() else removeBhopFloatingAddButton(); autoBhop=false end
    end
})

-- ระบบ Auto Bhop แบบไม่แตะพื้น
task.spawn(function()
    local RunService = game:GetService("RunService")
    local rayDistance = 4 -- ระยะใกล้พื้นที่จะทำให้เด้ง
    while true do
        RunService.Heartbeat:Wait()
        if autoBhop then
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if humanoid and root then
                    -- ยิง Ray ลงไปดูว่ามีพื้นใกล้แค่ไหน
                    local rayOrigin = root.Position
                    local rayDir = Vector3.new(0, -rayDistance, 0)
                    local ray = Ray.new(rayOrigin, rayDir)
                    local hit, pos = workspace:FindPartOnRay(ray, char)

                    if hit then
                        -- กระโดดทันทีเพื่อไม่ให้แตะพื้น
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end
    end
end)

-- =========================
-- Lag Switch
-- =========================
local floatingLagAddButton
local function lagSwitch(duration)
local start = tick()
while tick()-start < duration do
for i=1,1e7 do local a=math.random() end
end
end

MainTab:AddButton({
Title="Lag Switch (ปกติ)",
Description="กดแล้วค้างกระตุก 0.5 วินาที",
Callback=function() lagSwitch(0.5) end
})

local function createLagFloatingAddButton()
if floatingLagAddButton then return end
floatingLagAddButton = Instance.new("TextButton")
floatingLagAddButton.Size=UDim2.new(0,100,0,50)
floatingLagAddButton.Position=UDim2.new(0.7,-50,0.8,0)
floatingLagAddButton.AnchorPoint=Vector2.new(0.5,0)
floatingLagAddButton.BackgroundColor3=Color3.fromRGB(255,100,0)
floatingLagAddButton.TextColor3=Color3.fromRGB(255,255,255)
floatingLagAddButton.Text="Lag Switch"
floatingLagAddButton.Parent=FloatingGui
floatingLagAddButton.Active=true
floatingLagAddButton.Draggable=true
floatingLagAddButton.MouseButton1Click:Connect(function() lagSwitch(0.5) end)
end

local function removeLagFloatingAddButton()
if floatingLagAddButton then
floatingLagAddButton:Destroy()
floatingLagAddButton=nil
end
end



MainTab:AddToggle("003",{
Title="Lag Switch (ปุ่มลอย)",
Description="แสดงปุ่มลอยบนหน้าจอสำหรับ Lag Switch",
Default=false,
Callback=function(state)
if state then createLagFloatingAddButton() else removeLagFloatingAddButton() end
end
})

-- =========================
-- Auto Bounce (แม่นยำสูง)
-- =========================
local autoBounce = false
local floatingBounceAddButton
local bouncePower = 100 -- ความแรงการเด้ง
local groundCheckDistance = 6 -- ระยะเช็คใกล้พื้น (studs)

task.spawn(function()
    local RunService = game:GetService("RunService")
    while true do
        if autoBounce then
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if root and humanoid then
                    -- ใช้ raycast ตรวจพื้น
                    local rayOrigin = root.Position
                    local rayDirection = Vector3.new(0, -groundCheckDistance, 0)
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescriptionendantsInstances = {char}
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                    local ray = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

                    -- ถ้า raycast เจอพื้นและกำลังตก
                    if ray and root.Velocity.Y < 0 then
                        -- ปรับแรงเด้งตามความสูง/ความเร็วได้
                        root.Velocity = Vector3.new(root.Velocity.X, bouncePower, root.Velocity.Z)
                    end
                end
            end
        end
        task.wait(0.03) -- ลด delay เล็กน้อยให้ตอบสนองเร็วขึ้น
    end
end)

-- ปุ่มปกติ
MainTab:AddToggle("004",{
    Title="ออโต้เด้ง (ปกติ)",
    Description="เด้งอัตโนมัติเมื่อกำลังตกและใกล้พื้น (แม่นยำกว่าเดิม)",
    Default=false,
    Callback=function(state) autoBounce = state end
})

-- ปุ่มลอย
local function createBounceFloatingAddButton()
    if floatingBounceAddButton then return end
    floatingBounceAddButton = Instance.new("TextButton")
    floatingBounceAddButton.Size = UDim2.new(0,100,0,50)
    floatingBounceAddButton.Position = UDim2.new(0.5,-50,0.85,0)
    floatingBounceAddButton.AnchorPoint = Vector2.new(0.5,0)
    floatingBounceAddButton.BackgroundColor3 = Color3.fromRGB(255,0,150)
    floatingBounceAddButton.TextColor3 = Color3.fromRGB(255,255,255)
    floatingBounceAddButton.Text = autoBounce and "Auto Bounce: ON" or "Auto Bounce: OFF"
    floatingBounceAddButton.Parent = FloatingGui
    floatingBounceAddButton.Active = true
    floatingBounceAddButton.Draggable = true
    floatingBounceAddButton.MouseButton1Click:Connect(function()
        autoBounce = not autoBounce
        floatingBounceAddButton.Text = autoBounce and "Auto Bounce: ON" or "Auto Bounce: OFF"
    end)
end

MainTab:AddToggle("005",{
    Title="ออโต้เด้ง (ปุ่มลอย)",
    Description="แสดงปุ่มลอยสำหรับ Auto Bounce (แม่นยำกว่าเดิม)",
    Default=false,
    Callback=function(state)
        if state then createBounceFloatingAddButton() else
            if floatingBounceAddButton then floatingBounceAddButton:Destroy(); floatingBounceAddButton=nil end
            autoBounce=false
        end
    end
})

-- =========================
-- Auto Respawn (Fake Revive)
-- =========================
getgenv().AutoRespawnEnabled = false
local autoRespawnMethod = "Fake Revive"
local respawnConnection
local lastSavedPosition
local floatingRespawnAddButton

-- ฟังก์ชันสร้างปุ่มลอย
local function createRespawnFloatingAddButton()
    if floatingRespawnAddButton then return end
    floatingRespawnAddButton = Instance.new("TextButton")
    floatingRespawnAddButton.Size = UDim2.new(0,120,0,50)
    floatingRespawnAddButton.Position = UDim2.new(0.8,0,0.8,0)
    floatingRespawnAddButton.BackgroundColor3 = Color3.fromRGB(255,80,80)
    floatingRespawnAddButton.TextColor3 = Color3.new(1,1,1)
    floatingRespawnAddButton.Font = Enum.Font.GothamBold
    floatingRespawnAddButton.Text = "Auto Respawn"
    floatingRespawnAddButton.Parent = FloatingGui -- ต้องมี FloatingGui ในเกม
    floatingRespawnAddButton.ZIndex = 10
    floatingRespawnAddButton.Active = true
    floatingRespawnAddButton.Draggable = true
    floatingRespawnAddButton.MouseButton1Click:Connect(function()
        getgenv().AutoRespawnEnabled = not getgenv().AutoRespawnEnabled
        floatingRespawnAddButton.BackgroundColor3 = getgenv().AutoRespawnEnabled and Color3.fromRGB(80,255,80) or Color3.fromRGB(255,80,80)
    end)
end

local function removeRespawnFloatingAddButton()
    if floatingRespawnAddButton then
        floatingRespawnAddButton:Destroy()
        floatingRespawnAddButton = nil
    end
end

-- ฟังก์ชันตั้งค่า Auto Revive สำหรับตัวละคร
local function setupAutoRevive(character)
    task.defer(function()
        character:WaitForChild("HumanoidRootPart",5)
        character:WaitForChild("Humanoid",5)
        -- เก็บตำแหน่งล่าสุด
        task.spawn(function()
            while character and character.Parent do
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    character:SetAttribute("LastPosition", hrp.Position)
                end
                task.wait(0.2)
            end
        end)

        -- ตรวจ Downed
        character:GetAttributeChangedSignal("Downed"):Connect(function()
            if not getgenv().AutoRespawnEnabled then return end
            if character:GetAttribute("Downed") ~= true then return end
            if autoRespawnMethod ~= "Fake Revive" then return end

            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then lastSavedPosition = hrp.Position end

            task.wait(3)
            local start = tick()
            repeat
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Events",9e9)
                        :WaitForChild("Player",9e9)
                        :WaitForChild("ChangePlayerMode",9e9)
                        :FireServer(true)
                end)
                task.wait(1)
            until character:GetAttribute("Downed") ~= true or tick() - start > 1

            local newChar
            repeat
                newChar = game:GetService("Players").LocalPlayer.Character
                task.wait()
            until newChar and newChar:FindFirstChild("HumanoidRootPart")

            local newHRP = newChar:FindFirstChild("HumanoidRootPart")
            if lastSavedPosition and newHRP then
                newHRP.CFrame = CFrame.new(lastSavedPosition)
                task.wait(0.5)
            end
        end)
    end)
end

-- เรียก setup สำหรับตัวละครปัจจุบันและใหม่
local player = game:GetService("Players").LocalPlayer
if player.Character then setupAutoRevive(player.Character) end
player.CharacterAdded:Connect(setupAutoRevive)

-- =========================
-- ปุ่มปกติใน MainTab
-- =========================
MainTab:AddToggle("006",{
    Title="ออโต้รีสปอน (ปกติ)",
    Description="Respawn อัตโนมัติจนกว่าจะปิด",
    Default=false,
    Callback=function(state)
        getgenv().AutoRespawnEnabled = state

        if respawnConnection then
            respawnConnection:Disconnect()
            respawnConnection = nil
        end

        if state then
            -- เรียก setupAutoRevive สำหรับตัวละครปัจจุบัน
            if player.Character then setupAutoRevive(player.Character) end
        end
    end
})

-- =========================
-- Dropdown: วิธีรีสปอน
-- =========================
MainTab:AddDropdown({
    Title="วิธีรีสปอน",
    Options={"Random","Fake Revive"},
    CurrentOption={autoRespawnMethod},
    MultipleOptions=false,
    Callback=function(opt)
        autoRespawnMethod = opt[1]
    end
})

-- =========================
-- ปุ่มลอย
-- =========================
MainTab:AddToggle("007",{
    Title="ออโต้รีสปอน (ปุ่มลอย)",
    Description="แสดงปุ่มลอยบนหน้าจอสำหรับ Auto Respawn",
    Default=false,
    Callback=function(state)
        if state then createRespawnFloatingAddButton() else
            removeRespawnFloatingAddButton()
            getgenv().AutoRespawnEnabled = false
        end
    end
})


