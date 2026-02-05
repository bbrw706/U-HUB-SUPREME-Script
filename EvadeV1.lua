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


-- =========================
-- Teleport Roof
-- =========================
local floatingTPAddButton
local function teleportRoof()
local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if root then root.CFrame += Vector3.new(0,500,0) end
end

TeleportTab:AddButton("b",{
Title="เทเลพอร์ตขึ้นหลังคา (ปกติ)",
Description="กดเพื่อขึ้นหลังคา",
Callback=teleportRoof
})

local function createTPFloatingAddButton()
if floatingTPAddButton then return end
floatingTPAddButton = Instance.new("TextButton")
floatingTPAddButton.Size=UDim2.new(0,100,0,50)
floatingTPAddButton.Position=UDim2.new(0.5,-50,0.6,0)
floatingTPAddButton.AnchorPoint=Vector2.new(0.5,0)
floatingTPAddButton.BackgroundColor3=Color3.fromRGB(0,255,100)
floatingTPAddButton.TextColor3=Color3.fromRGB(0,0,0)
floatingTPAddButton.Text="TP Roof"
floatingTPAddButton.Parent=FloatingGui
floatingTPAddButton.Active=true
floatingTPAddButton.Draggable=true
floatingTPAddButton.MouseButton1Click:Connect(teleportRoof)
end

TeleportTab:AddToggle("c",{
Title="เทเลพอร์ตขึ้นหลังคา (ปุ่มลอย)",
Description="แสดงปุ่มลอยบนหน้าจอสำหรับ Teleport Roof",
Default=false,
Callback=function(state)
if state then createTPFloatingAddButton() else
if floatingTPAddButton then floatingTPAddButton:Destroy(); floatingTPAddButton=nil end
end
end
})

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local camera = workspace.CurrentCamera

-- =========================
-- ตั้งค่า
-- =========================
getgenv().AntiAFK = true      -- เปิด/ปิดระบบ Anti-AFK + หมุนกล้อง
local afkActive = false
local afkPart
local afkLoop

-- =========================
-- AFK Money System (ของเดิม)
-- =========================

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local afkActive = false
local afkPart
local afkLoop

local function AddToggleAFKMoney()
	afkActive = not afkActive

	if afkActive then
		-- สร้าง part กันตก
		afkPart = Instance.new("Part")
		afkPart.Size = Vector3.new(8, 1, 8)
		afkPart.Position = Vector3.new(0, 6000, 0)
		afkPart.Anchored = true
		afkPart.Transparency = 1
		afkPart.Parent = workspace

		-- วนลูปย้ายผู้เล่นขึ้นไปบน part
		afkLoop = RunService.Heartbeat:Connect(function()
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character.HumanoidRootPart.CFrame = afkPart.CFrame + Vector3.new(0, 4, 0)
			end
		end)

	else
		-- ปิดระบบ
		if afkLoop then
			afkLoop:Disconnect()
			afkLoop = nil
		end
		if afkPart then
			afkPart:Destroy()
			afkPart = nil
		end
	end
end


-- =========================
-- ปุ่มเปิดระบบ
-- =========================
TeleportTab:AddButton("d",{
	Title = "AFK Money (ของเดิม)",
	Description = "ยืนบนฟ้า กันตาย/กันหลุดแมพ",
	Callback = function()
		AddToggleAFKMoney()
	end
})

-- =========================
-- Teleport to Dead Player 1s
-- =========================
local floatingDeadTPAddButton
local function teleportToDead()
local char = player.Character
if not char then return end
local root = char:FindFirstChild("HumanoidRootPart")
if not root then return end
local deadPlayer=nil
for _,plr in pairs(Players:GetPlayers()) do
local h = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
if h and h.Health==0 then
deadPlayer=plr
break
end
end
if deadPlayer and deadPlayer.Character and deadPlayer.Character:FindFirstChild("HumanoidRootPart") then
local originalCFrame=root.CFrame
root.CFrame = deadPlayer.Character.HumanoidRootPart.CFrame
task.wait(1)
root.CFrame=originalCFrame
end
end

TeleportTab:AddButton("e",{
Title="ไปหาผู้เล่นที่ล้ม (ปกติ)",
Description="วาร์ปไปผู้เล่นที่ล้ม 1 วินาที",
Callback=teleportToDead
})

local function createDeadTPFloatingAddButton()
if floatingDeadTPAddButton then return end
floatingDeadTPAddButton = Instance.new("TextButton")
floatingDeadTPAddButton.Size=UDim2.new(0,100,0,50)
floatingDeadTPAddButton.Position=UDim2.new(0.5,-50,0.8,0)
floatingDeadTPAddButton.AnchorPoint=Vector2.new(0.5,0)
floatingDeadTPAddButton.BackgroundColor3=Color3.fromRGB(0,255,255)
floatingDeadTPAddButton.TextColor3=Color3.fromRGB(0,0,0)
floatingDeadTPAddButton.Text="Dead TP"
floatingDeadTPAddButton.Parent=FloatingGui
floatingDeadTPAddButton.Active=true
floatingDeadTPAddButton.Draggable=true
floatingDeadTPAddButton.MouseButton1Click:Connect(teleportToDead)
end

TeleportTab:AddToggle("f",{
Title="ไปหาผู้เล่นที่ล้ม (ปุ่มลอย)",
Description="แสดงปุ่มลอยบนหน้าจอสำหรับ Dead TP",
Default=false,
Callback=function(state)
if state then createDeadTPFloatingAddButton() else
if floatingDeadTPAddButton then floatingDeadTPAddButton:Destroy(); floatingDeadTPAddButton=nil end
end
end
})



-- =========================
-- Wall Hack (ทะลุกำแพงด้านหน้า/ด้านข้างจริง)
-- =========================
local wallHackActive = false
local floatingWallAddButton
local wallPartsOriginalCollide = {} -- เก็บค่า CanCollide เดิม

local function setWallHack(state)
    wallHackActive = state
    if not wallHackActive then
        -- รีเซ็ตค่า CanCollide ทุกชิ้นที่เราจำไว้
        for part, collide in pairs(wallPartsOriginalCollide) do
            if part and part.Parent then
                part.CanCollide = collide
            end
        end
        wallPartsOriginalCollide = {}
    end
end

local function AddToggleWallHack()
    setWallHack(not wallHackActive)
    if floatingWallAddButton then
        floatingWallAddButton.Text = wallHackActive and "Wall Hack: ON" or "Wall Hack: OFF"
    end
end

task.spawn(function()
    while true do
        if wallHackActive then
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    local origin = root.Position
                    local forwardDir = root.CFrame.LookVector -- ด้านหน้าตัวละคร
                    for _, part in pairs(workspace:GetDescriptionendants()) do
                        if part:IsA("BasePart") then
                            local toPart = part.Position - origin
                            local forwardDist = forwardDir:Dot(toPart)
                            local horizontalDist = (Vector3.new(toPart.X,0,toPart.Z)).Magnitude
                            local verticalDist = toPart.Y
                            -- เช็คเฉพาะกำแพงด้านหน้า/ด้านข้าง ไม่รวมพื้น/เพดาน
                            if forwardDist > 0 and forwardDist < 5 and horizontalDist < 3 and verticalDist > -2 and verticalDist < 5 then
                                if wallPartsOriginalCollide[part] == nil then
                                    wallPartsOriginalCollide[part] = part.CanCollide
                                end
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.05)
    end
end)

-- ปุ่มลอย Wall Hack
local function createWallFloatingAddButton()
    if floatingWallAddButton then return end
    floatingWallAddButton = Instance.new("TextButton")
    floatingWallAddButton.Size = UDim2.new(0,100,0,50)
    floatingWallAddButton.Position = UDim2.new(0.2,-50,0.6,0)
    floatingWallAddButton.AnchorPoint = Vector2.new(0.5,0)
    floatingWallAddButton.BackgroundColor3 = Color3.fromRGB(100,255,100)
    floatingWallAddButton.TextColor3 = Color3.fromRGB(0,0,0)
    floatingWallAddButton.Text = wallHackActive and "Wall Hack: ON" or "Wall Hack: OFF"
    floatingWallAddButton.Parent = FloatingGui
    floatingWallAddButton.Active = true
    floatingWallAddButton.Draggable = true
    floatingWallAddButton.MouseButton1Click:Connect(AddToggleWallHack)
end

-- ปุ่มปกติ
ExtraTab:AddButton("g",{
    Title="Wall Hack (ปกติ)",
    Description="ทะลุกำแพงด้านหน้า/ด้านข้างจริง",
    Callback=AddToggleWallHack
})

-- ปุ่มลอย
ExtraTab:AddToggle("h",{
    Title="Wall Hack (ปุ่มลอย)",
    Description="แสดงปุ่มลอยบนหน้าจอสำหรับ Wall Hack",
    Default=false,
    Callback=function(state)
        if state then
            createWallFloatingAddButton()
        else
            if floatingWallAddButton then
                floatingWallAddButton:Destroy()
                floatingWallAddButton = nil
            end
            setWallHack(false)
        end
    end
})

-- =========================
-- Teleport To Player (ปกติ + ลอย)
-- =========================
local floatingTPPlayerAddButton
local function teleportToPlayer(targetPlayer)
local char = player.Character
if not char then return end
local root = char:FindFirstChild("HumanoidRootPart")
if not root then return end
if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
root.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
end
end

local function createTPPlayerMenu()
-- สร้าง UI แบบ Simple Folder / Frame
local menuGui = PlayerGui:FindFirstChild("TPPlayerMenu")
if menuGui then menuGui:Destroy() end

menuGui = Instance.new("ScreenGui")  
menuGui.Name = "TPPlayerMenu"  
menuGui.Parent = PlayerGui  
menuGui.ResetOnSpawn = false  

local frame = Instance.new("Frame")  
frame.Size = UDim2.new(0,200,0,300)  
frame.Position = UDim2.new(0.5,-100,0.3,0)  
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)  
frame.Parent = menuGui  

local layout = Instance.new("UIListLayout")  
layout.Parent = frame  
layout.SortOrder = Enum.SortOrder.LayoutOrder  
layout.Padding = UDim.new(0,5)  

for _, plr in pairs(Players:GetPlayers()) do  
    if plr ~= player then  
        local btn = Instance.new("TextButton")  
        btn.Size = UDim2.new(1,0,0,30)  
        btn.Text = plr.Name  
        btn.BackgroundColor3 = Color3.fromRGB(100,100,255)  
        btn.TextColor3 = Color3.fromRGB(255,255,255)  
        btn.Parent = frame  
        btn.MouseButton1Click:Connect(function()  
            teleportToPlayer(plr)  
            menuGui:Destroy()  
        end)  
    end  
end

end


-- ปุ่มปกติ
TeleportTab:AddButton("i",{
Title="TeleTo Player (ปกติ)",
Description="เลือกผู้เล่นแล้วเทเลพอร์ตไปหา",
Callback=createTPPlayerMenu
})

-- ปุ่มลอย
local function createFloatingTPPlayerAddButton()
if floatingTPPlayerAddButton then return end
floatingTPPlayerAddButton = Instance.new("TextButton")
floatingTPPlayerAddButton.Size = UDim2.new(0,120,0,50)
floatingTPPlayerAddButton.Position = UDim2.new(0.5,-60,0.75,0)
floatingTPPlayerAddButton.AnchorPoint = Vector2.new(0.5,0)
floatingTPPlayerAddButton.BackgroundColor3 = Color3.fromRGB(150,0,255)
floatingTPPlayerAddButton.TextColor3 = Color3.fromRGB(255,255,255)
floatingTPPlayerAddButton.Text = "TeleTo Player"
floatingTPPlayerAddButton.Parent = FloatingGui
floatingTPPlayerAddButton.Active = true
floatingTPPlayerAddButton.Draggable = true
floatingTPPlayerAddButton.MouseButton1Click:Connect(createTPPlayerMenu)
end

TeleportTab:AddToggle("j",{
Title="TeleTo Player (ปุ่มลอย)",
Description="แสดงปุ่มลอยบนหน้าจอสำหรับ TeleTo Player",
Default=false,
Callback=function(state)
if state then createFloatingTPPlayerAddButton() else
if floatingTPPlayerAddButton then floatingTPPlayerAddButton:Destroy(); floatingTPPlayerAddButton=nil end
end
end
})


-- =========================
-- Moon Mode (ปุ่มปกติ + ปุ่มลอย)
-- =========================
local moonModeActive = false
local floatingMoonAddButton

local function AddToggleMoonMode()
moonModeActive = not moonModeActive
if floatingMoonAddButton then
floatingMoonAddButton.Text = moonModeActive and "Moon Mode: ON" or "Moon Mode: OFF"
end
end

task.spawn(function()
while true do
if moonModeActive then
local char = player.Character
if char then
local root = char:FindFirstChild("HumanoidRootPart")
local humanoid = char:FindFirstChildOfClass("Humanoid")
if root and humanoid then
if humanoid.FloorMaterial == Enum.Material.Air and root.Velocity.Y < 0 then
root.Velocity = Vector3.new(root.Velocity.X, root.Velocity.Y * 0.3, root.Velocity.Z)
end
end
end
end
task.wait(0.05)
end
end)

local function createMoonFloatingAddButton()
if floatingMoonAddButton then return end
floatingMoonAddButton = Instance.new("TextButton")
floatingMoonAddButton.Size = UDim2.new(0,100,0,50)
floatingMoonAddButton.Position = UDim2.new(0.8,-50,0.6,0)
floatingMoonAddButton.AnchorPoint = Vector2.new(0.5,0)
floatingMoonAddButton.BackgroundColor3 = Color3.fromRGB(100,100,255)
floatingMoonAddButton.TextColor3 = Color3.fromRGB(255,255,255)
floatingMoonAddButton.Text = moonModeActive and "Moon Mode: ON" or "Moon Mode: OFF"
floatingMoonAddButton.Parent = FloatingGui
floatingMoonAddButton.Active = true
floatingMoonAddButton.Draggable = true
floatingMoonAddButton.MouseButton1Click:Connect(AddToggleMoonMode)
end

ExtraTab:AddButton("k",{
Title="Moon Mode (ปกติ)",
Description="ตกช้าๆจากที่สูง โดยไม่แข็งตัว",
Callback=AddToggleMoonMode
})

ExtraTab:AddToggle("l",{
Title="Moon Mode (ปุ่มลอย)",
Description="แสดงปุ่มลอยบนหน้าจอสำหรับ Moon Mode",
Default=false,
Callback=function(state)
if state then createMoonFloatingAddButton() else
if floatingMoonAddButton then floatingMoonAddButton:Destroy(); floatingMoonAddButton=nil end
moonModeActive=false
end
end
})

-- =========================
-- Extra Tab - Run External Script
-- =========================
ExtraTab:AddButton("m",{
Title = "Run External Script",
Description = "กดเพื่อรันสคริปต์จาก Pastebin",
Callback = function()
local success, err = pcall(function()
loadstring(game:HttpGet("https://pastebin.com/raw/GHDdPh2c"))()
end)
if not success then
warn("เกิดข้อผิดพลาดในการรันสคริปต์: "..tostring(err))
end
end
})

-- =========================
-- Player ESP (Visuals)
-- =========================
local playerESPActive = false
local ESPBoxes = {}

local function createESPForPlayer(targetPlayer)
    if targetPlayer == player then return end
    local char = targetPlayer.Character
    if not char then return end

    local head = char:FindFirstChild("Head")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not head or not root then return end

    -- TextLabel บนหัว
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPBillboard"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.StudsOffset = Vector3.new(0,2,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Text = targetPlayer.Name
    label.Parent = billboard

    -- Box รอบตัว
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = root
    box.Size = root.Size
    box.Color = BrickColor.new("White")
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Parent = root

    ESPBoxes[targetPlayer] = {Billboard=billboard, Box=box}
end

local function removeESPForPlayer(targetPlayer)
    if ESPBoxes[targetPlayer] then
        if ESPBoxes[targetPlayer].Billboard then ESPBoxes[targetPlayer].Billboard:Destroy() end
        if ESPBoxes[targetPlayer].Box then ESPBoxes[targetPlayer].Box:Destroy() end
        ESPBoxes[targetPlayer] = nil
    end
end

local function AddTogglePlayerESP(state)
    playerESPActive = state
    if state then
        for _, plr in pairs(Players:GetPlayers()) do
            createESPForPlayer(plr)
        end
    else
        for plr, _ in pairs(ESPBoxes) do
            removeESPForPlayer(plr)
        end
    end
end

-- Update ESP เมื่อผู้เล่นเข้ามาหรือออก
Players.PlayerAdded:Connect(function(plr)
    if playerESPActive then
        plr.CharacterAdded:Connect(function()
            createESPForPlayer(plr)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    removeESPForPlayer(plr)
end)

-- =========================
-- ปุ่มใน VisualsTab
-- =========================
VisualsTab:AddToggle("n",{
    Title="มองผู้เล่น",
    Description="แสดงชื่อบนหัวและกรอบรอบลำตัว",
    Default=false,
    Callback=AddTogglePlayerESP
})

-- =========================
-- Smooth Dash (แก้กระตุกกลางอากาศ)
-- =========================
local dashEnabled = false
local dashSpeed = 50 -- ความเร็วเริ่มต้น
local floatingDashAddButton
local dashVelocity = nil

-- ฟังก์ชันเปิด Dash
local function startDash()
    if dashVelocity then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    dashVelocity = Instance.new("BodyVelocity")
    dashVelocity.MaxForce = Vector3.new(400000, 0, 400000)
    dashVelocity.P = 1250
    dashVelocity.Parent = root

    -- อัปเดตทิศทางเรื่อย ๆ
    task.spawn(function()
        while dashEnabled and dashVelocity and dashVelocity.Parent do
            local cam = workspace.CurrentCamera
            if cam and root then
                local dir = cam.CFrame.LookVector
                dir = Vector3.new(dir.X, 0, dir.Z)
                if dir.Magnitude > 0 then dir = dir.Unit end
                dashVelocity.Velocity = dir * dashSpeed
            end
            task.wait(0.03)
        end
        if dashVelocity then
            dashVelocity:Destroy()
            dashVelocity = nil
        end
    end)
end

-- =========================
-- GUI AddToggle
SettingsTab:AddToggle("o",{
    Title="Smooth Dash (ปกติ)",
    Description="พุ่งตามมุมมองแบบลื่น ไม่กระตุก",
    Default=false,
    Callback=function(state)
        dashEnabled = state
        if state then
            startDash()
        elseif dashVelocity then
            dashVelocity:Destroy()
            dashVelocity = nil
        end
    end
})

-- AddInput ปรับความเร็ว
SettingsTab:AddInput("p",{
    Title="Dash Speed",
    Description="ปรับความเร็ว Dash",
    Placeholder=tostring(dashSpeed),
    Callback=function(txt)
        local num = tonumber(txt)
        if num then dashSpeed = num end
    end
})

-- =========================
-- ปุ่มลอย
local function createFloatingDashAddButton()
    if floatingDashAddButton then return end
    floatingDashAddButton = Instance.new("TextButton")
    floatingDashAddButton.Size = UDim2.new(0,120,0,50)
    floatingDashAddButton.Position = UDim2.new(0.5,-60,0.3,0)
    floatingDashAddButton.AnchorPoint = Vector2.new(0.5,0)
    floatingDashAddButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
    floatingDashAddButton.TextColor3 = Color3.fromRGB(255,255,255)
    floatingDashAddButton.Text = dashEnabled and "Dash: ON" or "Dash: OFF"
    floatingDashAddButton.Parent = FloatingGui
    floatingDashAddButton.Active = true
    floatingDashAddButton.Draggable = true

    floatingDashAddButton.MouseButton1Click:Connect(function()
        dashEnabled = not dashEnabled
        floatingDashAddButton.Text = dashEnabled and "Dash: ON" or "Dash: OFF"
        if dashEnabled then
            startDash()
        elseif dashVelocity then
            dashVelocity:Destroy()
            dashVelocity = nil
        end
    end)
end

SettingsTab:AddToggle("q",{
    Title="Smooth Dash (ปุ่มลอย)",
    Description="แสดงปุ่มลอยสำหรับ Smooth Dash",
    Default=false,
    Callback=function(state)
        if state then
            createFloatingDashAddButton()
        else
            if floatingDashAddButton then
                floatingDashAddButton:Destroy()
                floatingDashAddButton = nil
            end
            dashEnabled = false
            if dashVelocity then
                dashVelocity:Destroy()
                dashVelocity = nil
            end
        end
    end
})


-- =========================
-- ปุ่ม มองตั๋ว (ESP Ticket)
-- =========================
EventTab:AddToggle("r",{
    Title = "มองตั๋ว (ESP Ticket)",
    Description = "แสดงตำแหน่งตั๋วทั้งหมดในแมพ",
    Default = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local ticketESPThread

        local function getDistance(pos)
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            return hrp and (pos - hrp.Position).Magnitude or nil
        end

        local function createESP(part)
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "TicketESP"
            billboard.Adornee = part
            billboard.Size = UDim2.new(0, 180, 0, 25)
            billboard.StudsOffset = Vector3.new(0, 3.2, 0)
            billboard.AlwaysOnTop = true
            billboard.LightInfluence = 0
            billboard.Parent = part

            local label = Instance.new("TextLabel")
            label.Name = "Ticket"
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextStrokeTransparency = 0.25
            label.TextScaled = true
            label.Font = Enum.Font.GothamSemibold
            label.TextColor3 = Color3.fromRGB(255, 255, 150) -- สีเหลืองอ่อน
            label.Text = "Ticket"
            label.Parent = billboard

            return billboard
        end

        local function removeAllTicketESP()
            local ticketFolder = workspace:FindFirstChild("Game") 
                and workspace.Game:FindFirstChild("Effects") 
                and workspace.Game.Effects:FindFirstChild("Tickets")
            if ticketFolder then
                for _, ticketModel in ipairs(ticketFolder:GetChildren()) do
                    if ticketModel:IsA("Model") then
                        local part = ticketModel:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local existing = part:FindFirstChild("TicketESP")
                            if existing then existing:Destroy() end
                        end
                    end
                end
            end
        end

        if state then
            -- เปิดระบบ ESP
            ticketESPThread = task.spawn(function()
                while state do
                    local ticketFolder = workspace:FindFirstChild("Game") 
                        and workspace.Game:FindFirstChild("Effects") 
                        and workspace.Game.Effects:FindFirstChild("Tickets")
                    if ticketFolder then
                        for _, ticketModel in ipairs(ticketFolder:GetChildren()) do
                            if ticketModel:IsA("Model") then
                                local part = ticketModel:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    local billboard = part:FindFirstChild("TicketESP") or createESP(part)
                                    local label = billboard and billboard:FindFirstChild("Ticket")
                                    if label then
                                        local dist = getDistance(part.Position)
                                        if dist then
                                            label.Text = string.format("%s\n%.0f studs", ticketModel.Name, dist)
                                        else
                                            label.Text = ticketModel.Name
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            -- ปิดระบบ ESP
            removeAllTicketESP()
        end
    end
})

-- =========================
-- ปุ่ม มองเน็กบอท (ESP Nextbot)
-- =========================
VisualsTab:AddButton("s",{
    Title = "มองเน็กบอท",
    Description = "เปิด/ปิด ESP Nextbot",
    Callback = function()
        local LocalPlayer = game:GetService("Players").LocalPlayer

        -- เช็คว่าเปิดอยู่หรือไม่
        if _G.NextbotESPEnabled then
            -- ปิด ESP
            _G.NextbotESPEnabled = false
            if _G.NextbotESPThread and coroutine.status(_G.NextbotESPThread) ~= "dead" then
                coroutine.close(_G.NextbotESPThread)
                _G.NextbotESPThread = nil
            end

            -- ลบ ESP ทุกอัน
            local folder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
            if folder then
                for _, npc in ipairs(folder:GetChildren()) do
                    local part = (npc:IsA("Model") and (npc:FindFirstChild("Root") or npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart"))) or nil
                    if part then
                        local esp = part:FindFirstChild("NextbotESP")
                        if esp then esp:Destroy() end
                    end
                end
            end

            print("🛑 ESP Nextbot ปิดแล้ว")
        else
            -- เปิด ESP
            _G.NextbotESPEnabled = true

            _G.NextbotESPThread = coroutine.create(function()
                while _G.NextbotESPEnabled do
                    local folder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
                    if folder then
                        for _, npc in ipairs(folder:GetChildren()) do
                            if npc:GetAttribute("Team") == "Nextbot" then
                                local part = (npc:IsA("Model") and (npc:FindFirstChild("Root") or npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart"))) or nil
                                if part then
                                    local billboard = part:FindFirstChild("NextbotESP")
                                    if not billboard then
                                        billboard = Instance.new("BillboardGui")
                                        billboard.Name = "NextbotESP"
                                        billboard.Adornee = part
                                        billboard.Size = UDim2.new(0, 180, 0, 25)
                                        billboard.StudsOffset = Vector3.new(0, 3.2, 0)
                                        billboard.AlwaysOnTop = true
                                        billboard.LightInfluence = 0
                                        billboard.Parent = part

                                        local label = Instance.new("TextLabel")
                                        label.Name = "Label"
                                        label.Size = UDim2.new(1, 0, 1, 0)
                                        label.BackgroundTransparency = 1
                                        label.TextStrokeTransparency = 0.25
                                        label.TextScaled = true
                                        label.Font = Enum.Font.GothamSemibold
                                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                                        label.Parent = billboard
                                    end

                                    local label = billboard:FindFirstChild("Label")
                                    if label then
                                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                        local dist = hrp and (part.Position - hrp.Position).Magnitude or nil
                                        if dist then
                                            label.Text = string.format("%s\n%.0f studs", npc.Name, dist)
                                            -- กำหนดสีตามระยะทาง
                                            if dist <= 12 then
                                                label.TextColor3 = Color3.fromRGB(50, 50, 50)
                                            elseif dist <= 60 then
                                                local t = (dist - 6) / 14
                                                label.TextColor3 = Color3.fromRGB(255, 120 + (255 - 120) * t, 120)
                                            else
                                                label.TextColor3 = Color3.fromRGB(200, 150, 255)
                                            end
                                        else
                                            label.Text = npc.Name
                                            label.TextColor3 = Color3.fromRGB(255, 255, 255)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
            coroutine.resume(_G.NextbotESPThread)
            print("✅ ESP Nextbot เปิดแล้ว")
        end
    end
})

-- =========================
-- ปุ่มแสดง FPS
-- =========================
FPSTab:AddButton("t",{
    Title = "แสดง FPS",
    Description = "กดเพื่อเปิด/ปิดการแสดง FPS",
    Callback = function()
        local player = game.Players.LocalPlayer
        local playerGui = player:WaitForChild("PlayerGui")

        -- ตรวจสอบว่ามีอยู่แล้วไหม
        local existingGui = playerGui:FindFirstChild("FPSGui")
        if existingGui then
            existingGui:Destroy()
            return
        end

        -- สร้าง ScreenGui
        local fpsGui = Instance.new("ScreenGui")
        fpsGui.Name = "FPSGui"
        fpsGui.ResetOnSpawn = false
        fpsGui.Parent = playerGui

        -- กรอบแสดง FPS
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 200, 0, 100)
        frame.Position = UDim2.new(1, -210, 0, 10) -- มุมบนขวา
        frame.BackgroundTransparency = 0.5
        frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
        frame.Parent = fpsGui

        -- Label FPS ของเรา
        local fpsLabel = Instance.new("TextLabel")
        fpsLabel.Size = UDim2.new(1, -10, 0, 30)
        fpsLabel.Position = UDim2.new(0, 5, 0, 5)
        fpsLabel.BackgroundTransparency = 1
        fpsLabel.TextColor3 = Color3.fromRGB(255,255,255)
        fpsLabel.TextScaled = true
        fpsLabel.Font = Enum.Font.GothamSemibold
        fpsLabel.Text = "FPS: 0"
        fpsLabel.Parent = frame

        -- Label สำหรับผู้เล่นอื่น
        local othersLabel = Instance.new("TextLabel")
        othersLabel.Size = UDim2.new(1, -10, 1, -40)
        othersLabel.Position = UDim2.new(0, 5, 0, 35)
        othersLabel.BackgroundTransparency = 1
        othersLabel.TextColor3 = Color3.fromRGB(180,180,255)
        othersLabel.TextScaled = true
        othersLabel.Font = Enum.Font.GothamSemibold
        othersLabel.Text = "Players FPS:"
        othersLabel.TextWrapped = true
        othersLabel.TextYAlignment = Enum.TextYAlignment.Top
        othersLabel.Parent = frame

        -- อัปเดต FPS
        local lastTime = tick()
        local frameCount = 0
        local runService = game:GetService("RunService")

        runService.RenderStepped:Connect(function()
            frameCount += 1
            local now = tick()
            if now - lastTime >= 1 then
                fpsLabel.Text = "FPS: " .. frameCount
                frameCount = 0
                lastTime = now

                -- อัปเดต FPS ของผู้เล่นอื่น (จำลองตัวอย่าง)
                local players = game.Players:GetPlayers()
                local otherText = "Players FPS:\n"
                for _, p in pairs(players) do
                    if p ~= player then
                        otherText = otherText .. p.Name .. ": ?\n" -- จริง ๆ ต้องมีระบบเก็บ FPS ของแต่ละคน
                    end
                end
                othersLabel.Text = otherText
            end
        end)
    end
})

-- =========================
-- ปุ่ม Teleport
-- =========================
local teleportEnabled = false
local floatingTeleportAddButton

-- ฟังก์ชันเปิด Teleport Mode
local function startTeleport()
    local UIS = game:GetService("UserInputService")
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()

    local function onClick()
        if teleportEnabled then
            local targetPos = mouse.Hit.Position + Vector3.new(0, 3, 0) -- ยกขึ้นเล็กน้อย
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(targetPos)
                end
            end
        end
    end

    -- เชื่อม Event
    local clickConnection = mouse.AddButton1Down:Connect(onClick)
    
    -- คืนค่าปิด
    return clickConnection
end

local teleportConnection

-- =========================
-- ปุ่มปกติในหมวด Teleport
TeleportTab:AddToggle("u",{
    Title = "คริป Teleport",
    Description  = "กดเพื่อเปิด/ปิด Teleport Mode",
    Default = false,
    Callback = function(state)
        teleportEnabled = state
        if state then
            teleportConnection = startTeleport()
        elseif teleportConnection then
            teleportConnection:Disconnect()
            teleportConnection = nil
        end
    end
})

-- =========================
-- ปุ่มลอย
local function createFloatingTeleportAddButton()
    if floatingTeleportAddButton then return end

    floatingTeleportAddButton = Instance.new("TextButton")
    floatingTeleportAddButton.Size = UDim2.new(0, 140, 0, 50)
    floatingTeleportAddButton.Position = UDim2.new(0.5, -70, 0.4, 0)
    floatingTeleportAddButton.AnchorPoint = Vector2.new(0.5, 0)
    floatingTeleportAddButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    floatingTeleportAddButton.TextColor3 = Color3.fromRGB(255,255,255)
    floatingTeleportAddButton.Text = teleportEnabled and "Teleport: ON" or "Teleport: OFF"
    floatingTeleportAddButton.Parent = FloatingGui
    floatingTeleportAddButton.Active = true
    floatingTeleportAddButton.Draggable = true

    floatingTeleportAddButton.MouseButton1Click:Connect(function()
        teleportEnabled = not teleportEnabled
        floatingTeleportAddButton.Text = teleportEnabled and "Teleport: ON" or "Teleport: OFF"
        if teleportEnabled then
            teleportConnection = startTeleport()
        elseif teleportConnection then
            teleportConnection:Disconnect()
            teleportConnection = nil
        end
    end)
end

-- ปุ่ม AddToggle สำหรับลอย
TeleportTab:AddToggle("v",{
    Title = "คริป Teleport (ปุ่มลอย)",
    Description  = "แสดงปุ่มลอยสำหรับ Teleport",
    Default = false,
    Callback = function(state)
        if state then
            createFloatingTeleportAddButton()
        else
            if floatingTeleportAddButton then
                floatingTeleportAddButton:Destroy()
                floatingTeleportAddButton = nil
            end
            teleportEnabled = false
            if teleportConnection then
                teleportConnection:Disconnect()
                teleportConnection = nil
            end
        end
    end
})

-- =========================
-- ปุ่ม Reduce Graphics V.1
-- =========================
FPSTab:AddButton("v",{
    Title = "ลดกราฟฟิก V.1",
    Description  = "ทุก Part เรียบเนียน",
    Callback = function()
        for _, obj in ipairs(workspace:GetDescriptionendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            end
        end
        print("✅ ลดกราฟฟิก V.1 เรียบร้อย")
    end
})

-- =========================
-- ปุ่ม Reduce Graphics V.2
-- =========================
FPSTab:AddButton("x",{
    Title = "ลดกราฟฟิก V.2",
    Description  = "เรียบเนียน + ลบหมอกและเอฟเฟกต์",
    Callback = function()
        -- เรียบเนียนเหมือน V.1
        for _, obj in ipairs(workspace:GetDescriptionendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            end
        end

        -- ลบหมอก/เอฟเฟกต์จาก Lighting
        local Lighting = game:GetService("Lighting")
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.GlobalShadows = false
        print("✅ ลดกราฟฟิก V.2 เรียบร้อย")
    end
})

-- =========================
-- ปุ่ม เพิ่มแสงหน้าจอ
-- =========================
FPSTab:AddButton("w",{
    Title = "เพิ่มแสงหน้าจอ",
    Description  = "หน้าจอสว่างขึ้นเล็กน้อย",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        Lighting.Brightness = (Lighting.Brightness or 2) + 1 -- เพิ่มทีละ 1
        print("✅ เพิ่มแสงเรียบร้อย")
    end
})

-- =========================
-- AUTO TICKET FARM (EventTab)
-- =========================
EventTab:AddToggle("y",{
Title = "Auto Ticket Farm",
Description = "เก็บตั๋วอัตโนมัติทั้งเซิร์ฟ",
Default = false,
Callback = function(state)
getgenv().AutoTicketFarm = state
if state then
task.spawn(function()
while getgenv().AutoTicketFarm do
task.wait(0.1)
if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
local hrp = player.Character.HumanoidRootPart
local ticketsFolder = workspace:FindFirstChild("Game")
and workspace.Game:FindFirstChild("Effects")
and workspace.Game.Effects:FindFirstChild("Tickets")
if ticketsFolder then
for _, ticket in pairs(ticketsFolder:GetChildren()) do
if not getgenv().AutoTicketFarm then break end
local root = ticket:FindFirstChild("HumanoidRootPart")
if root then
local pos = root.Position
local downPos = CFrame.new(pos.X, pos.Y - 15, pos.Z)
local upPos = CFrame.new(pos.X, pos.Y + 2, pos.Z)

hrp.CFrame = downPos
task.wait(0.15)
hrp.CFrame = upPos
task.wait(0.05)

local success = false    
                            if game:GetService("ReplicatedStorage"):FindFirstChild("Events")     
                               and game.ReplicatedStorage.Events:FindFirstChild("CollectTicket") then    
                                local ok, _ = pcall(function()    
                                    game.ReplicatedStorage.Events.CollectTicket:FireServer(ticket)    
                                end)    
                                success = ok    
                            end    

                            local startTime = tick()    
                            repeat task.wait(0.05) until not ticket.Parent or tick() - startTime > 2    
                            if not ticket.Parent or success then    
                                hrp.CFrame = CFrame.new(pos.X, 1300, pos.Z)    
                                task.wait(0.3)    
                            end    
                        end    
                    end    
                end    
            end    
        end    
    end)    
end

end

})


