-- =========================
-- Load UI Fluent
-- =========================
local  Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local TweenService = game:GetService("TweenService")

local UserInputService = game:GetService("UserInputService")

math.randomseed(tick())

-- =========================
-- Main Window
-- =========================
local Window = Fluent:CreateWindow({
    Title = "U-HUB SUPREME",    -- ชื่อเมนูใหญ่
    Description = "by Nong Nueng", -- ชื่อแบรนด์มึง (ตัวเล็กด้านล่าง)
    Icon = 105059922903197,
    TabWidth = 160,             -- ความกว้างแถบเมนูข้างๆ
    Size = UDim2.fromOffset(580, 460), -- ขนาดหน้าต่าง
    Acrylic = true,             -- เอฟเฟกต์ใสๆ (true = เปิด / false = ปิด)
    Theme = "Dark",             -- โทนสี (Dark, Light, Rose, etc.)
    MinimizeKey = Enum.KeyCode.LeftControl -- ปุ่มพับเมนู
})

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

TeleportTab:AddButton({
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

TeleportTab:AddToggle({
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
TeleportTab:AddButton({
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

TeleportTab:AddButton({
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

TeleportTab:AddToggle({
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
ExtraTab:AddButton({
    Title="Wall Hack (ปกติ)",
    Description="ทะลุกำแพงด้านหน้า/ด้านข้างจริง",
    Callback=AddToggleWallHack
})

-- ปุ่มลอย
ExtraTab:AddToggle({
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
TeleportTab:AddButton({
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

TeleportTab:AddToggle({
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

ExtraTab:AddButton({
Title="Moon Mode (ปกติ)",
Description="ตกช้าๆจากที่สูง โดยไม่แข็งตัว",
Callback=AddToggleMoonMode
})

ExtraTab:AddToggle({
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
ExtraTab:AddButton({
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
VisualsTab:AddToggle({
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
SettingsTab:AddToggle({
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
SettingsTab:AddInput({
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

SettingsTab:AddToggle({
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
EventTab:AddToggle({
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
VisualsTab:AddButton({
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
FPSTab:AddButton({
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
TeleportTab:AddToggle({
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
TeleportTab:AddToggle({
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
FPSTab:AddButton({
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
FPSTab:AddButton({
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
FPSTab:AddButton({
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
EventTab:AddToggle({
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



-- =========================
-- SYSTEM: Auto Carry Logic
-- =========================

getgenv().autoCarryEnabled = false
getgenv().autoCarryConnection = nil

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- ฟังก์ชันเริ่มอุ้มแบบจริง
local function startAutoCarry()
    if getgenv().autoCarryConnection then return end

    getgenv().autoCarryConnection = RunService.Heartbeat:Connect(function()
        if not getgenv().autoCarryEnabled then return end

        local char = localPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local otherHRP = plr.Character.HumanoidRootPart
                local dist = (hrp.Position - otherHRP.Position).Magnitude

                if dist <= 20 then
                    pcall(function()
                        ReplicatedStorage.Events.Character.Interact:FireServer("Carry", nil, plr.Name)
                    end)
                    task.wait(0.05)
                end
            end
        end
    end)
end

-- ฟังก์ชันหยุดอุ้ม
local function stopAutoCarry()
    if getgenv().autoCarryConnection then
        getgenv().autoCarryConnection:Disconnect()
        getgenv().autoCarryConnection = nil
    end
end


-- =========================
-- ปุ่มในเมนู MainTab
-- =========================
MainTab:AddToggle("008",{
    Title="Auto Carry",
    Description="เปิด/ปิดการอุ้มผู้เล่นอัตโนมัติ",
    Default=false,
    Callback=function(state)
        getgenv().autoCarryEnabled = state

        if state then 
            startAutoCarry()
        else
            stopAutoCarry()
        end

        -- อัปเดตปุ่มลอยถ้ามี
        if getgenv().floatingCarryAddButton then
            getgenv().floatingCarryAddButton.Text = state and "Auto Carry: ON" or "Auto Carry: OFF"
            getgenv().floatingCarryAddButton.BackgroundColor3 =
                state and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
        end
    end
})


-- =========================
-- ปุ่มลอย Floating AddButton
-- =========================
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local FloatingGui = PlayerGui:FindFirstChild("EvadeFloatingGui")
if not FloatingGui then
    FloatingGui = Instance.new("ScreenGui")
    FloatingGui.Name = "EvadeFloatingGui"
    FloatingGui.ResetOnSpawn = false
    FloatingGui.Parent = PlayerGui
end


local function createCarryFloatingAddButton()
    if getgenv().floatingCarryAddButton then
        getgenv().floatingCarryAddButton:Destroy()
        getgenv().floatingCarryAddButton = nil
        return
    end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,150,0,50)
    btn.Position = UDim2.new(0.25,0,0.3,0)
    btn.BackgroundColor3 = getgenv().autoCarryEnabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Text = getgenv().autoCarryEnabled and "Auto Carry: ON" or "Auto Carry: OFF"
    btn.Parent = FloatingGui
    btn.Active = true
    btn.Draggable = true

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 3
    stroke.Color = Color3.new(1,1,1)

    getgenv().floatingCarryAddButton = btn

    btn.MouseButton1Click:Connect(function()
        getgenv().autoCarryEnabled = not getgenv().autoCarryEnabled

        if getgenv().autoCarryEnabled then
            startAutoCarry()
        else
            stopAutoCarry()
        end

        btn.Text = getgenv().autoCarryEnabled and "Auto Carry: ON" or "Auto Carry: OFF"
        btn.BackgroundColor3 =
            getgenv().autoCarryEnabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)
end


MainTab:AddButton({
    Title="ดึงปุ่ม Auto Carry",
    Description="สร้าง/ลบปุ่มลอยอุ้มผู้เล่น",
    Callback=createCarryFloatingAddButton
})

-- =========================
-- Infinite Slide (MainTab + Floating)
-- =========================
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

-- ตัวแปรเก็บสถานะ
local infiniteSlideEnabled = false
local slideFrictionDefault = -8
local cachedTables
local plrModel
local slideConnection
local floatingSlideAddButton

-- ฟังก์ชันช่วย
local keys = {
    "Friction","AirStrafeAcceleration","JumpHeight","RunDeaccel",
    "JumpSpeedMultiplier","JumpCap","SprintCap","WalkSpeedMultiplier",
    "BhopEnabled","Speed","AirAcceleration","RunAccel","SprintAcceleration"
}

local function hasAll(tbl)
    if type(tbl) ~= "table" then return false end
    for _, k in ipairs(keys) do if rawget(tbl, k) == nil then return false end end
    return true
end

local function setFriction(Default)
    if not cachedTables then return end
    for _, t in ipairs(cachedTables) do
        pcall(function() t.Friction = Default end)
    end
end

local function updatePlayerModel()
    local GameFolder = workspace:FindFirstChild("Game")
    local PlayersFolder = GameFolder and GameFolder:FindFirstChild("Players")
    if PlayersFolder then
        plrModel = PlayersFolder:FindFirstChild(player.Name)
    else
        plrModel = nil
    end
end

local function onHeartbeat()
    if not plrModel then setFriction(5); return end
    local success, currentState = pcall(function() return plrModel:GetAttribute("State") end)
    if success and currentState then
        if currentState == "Slide" then
            pcall(function() plrModel:SetAttribute("State", "EmotingSlide") end)
        elseif currentState == "EmotingSlide" then
            setFriction(slideFrictionDefault)
        else
            setFriction(5)
        end
    else
        setFriction(5)
    end
end

-- ฟังก์ชันเปิด/ปิด Infinite Slide
local function AddToggleInfiniteSlide()
    infiniteSlideEnabled = not infiniteSlideEnabled

    if slideConnection then slideConnection:Disconnect(); slideConnection=nil end

    if infiniteSlideEnabled then
        cachedTables = {}
        for _, obj in ipairs(getgc(true)) do
            local success, result = pcall(function() if hasAll(obj) then return obj end end)
            if success and result then table.insert(cachedTables, result) end
        end
        updatePlayerModel()
        slideConnection = RunService.Heartbeat:Connect(onHeartbeat)
        player.CharacterAdded:Connect(function() wait(0.1); updatePlayerModel() end)
    else
        cachedTables = nil
        plrModel = nil
        setFriction(5)
    end

    -- อัปเดตปุ่มลอย
    if floatingSlideAddButton then
        floatingSlideAddButton.BackgroundColor3 = infiniteSlideEnabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
        floatingSlideAddButton.Text = infiniteSlideEnabled and "Infinite Slide: ON" or "Infinite Slide: OFF"
    end
end

-- =========================
-- ปุ่มปกติใน MainTab
MainTab:AddToggle("009",{
    Title="Infinite Slide",
    Description="เปิด/ปิด Infinite Slide",
    Default=false,
    Callback=function(state)
        AddToggleInfiniteSlide()
    end
})

-- =========================
-- Slider ปรับค่า Slide Friction ใน MainTab
SettingsTab:Slider({
    Title="Slide Friction",
    Description="ปรับค่าแรงสไลด์ (ต่ำ=เร็วกว่า)",
    Min=-500,
    Max=-1,
    Default=slideFrictionDefault,
    Callback=function(val)
        slideFrictionDefault = val
    end
})

-- =========================
-- ปุ่มลอยใน FloatingGui
local FloatingGui = PlayerGui:FindFirstChild("EvadeFloatingGui")
if not FloatingGui then
    FloatingGui = Instance.new("ScreenGui")
    FloatingGui.Name = "EvadeFloatingGui"
    FloatingGui.Parent = PlayerGui
    FloatingGui.ResetOnSpawn = false
    FloatingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
end

local function createSlideFloatingAddButton()
    if floatingSlideAddButton then return end
    floatingSlideAddButton = Instance.new("TextButton")
    floatingSlideAddButton.Size = UDim2.new(0,150,0,50)
    floatingSlideAddButton.Position = UDim2.new(0.8,0,0.3,0)
    floatingSlideAddButton.AnchorPoint = Vector2.new(0.5,0.5)
    floatingSlideAddButton.BackgroundColor3 = infiniteSlideEnabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    floatingSlideAddButton.TextColor3 = Color3.fromRGB(255,255,255)
    floatingSlideAddButton.Text = infiniteSlideEnabled and "Infinite Slide: ON" or "Infinite Slide: OFF"
    floatingSlideAddButton.TextScaled = true
    floatingSlideAddButton.Parent = FloatingGui
    floatingSlideAddButton.Active = true
    floatingSlideAddButton.Draggable = true
    Instance.new("UICorner", floatingSlideAddButton).CornerRadius = UDim.new(0,12)
    local border = Instance.new("UIStroke", floatingSlideAddButton)
    border.Thickness = 3
    border.Color = Color3.fromRGB(255,255,255)

    floatingSlideAddButton.MouseButton1Click:Connect(AddToggleInfiniteSlide)
end

MainTab:AddButton({
    Title="ดึงปุ่ม Infinite Slide",
    Description="สร้างปุ่มลอยสำหรับ Infinite Slide",
    Callback=createSlideFloatingAddButton
})

-- =========================
-- ตัวแปรหลัก
-- =========================
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local currentSettings = {
    Speed = 1500,
    JumpCap = 1,
    AirStrafeAcceleration = 187
}

-- =========================
-- ฟังก์ชันค้นหา Table ที่ตรงเงื่อนไข
-- =========================
local requiredFields = {
    Friction=true, AirStrafeAcceleration=true, JumpHeight=true, RunDeaccel=true,
    JumpSpeedMultiplier=true, JumpCap=true, SprintCap=true, WalkSpeedMultiplier=true,
    BhopEnabled=true, Speed=true, AirAcceleration=true, RunAccel=true, SprintAcceleration=true
}

local function getMatchingTables()
    local matched = {}
    for _, obj in pairs(getgc(true)) do
        if typeof(obj) == "table" then
            local ok = true
            for field in pairs(requiredFields) do
                if rawget(obj, field) == nil then ok = false break end
            end
            if ok then
                table.insert(matched, obj)
            end
        end
    end
    return matched
end

-- ฟังก์ชันอัปเดตค่า
local function applyToTables()
    for _, tbl in ipairs(getMatchingTables()) do
        pcall(function()
            tbl.Speed = currentSettings.Speed
            tbl.JumpCap = currentSettings.JumpCap
            tbl.AirStrafeAcceleration = currentSettings.AirStrafeAcceleration
        end)
    end
end

-- =========================
-- สร้าง Slider ใน SettingsTab
-- =========================

-- Speed
SettingsTab:Slider({
    Title = "Speed",
    Min = 1450,
    Max = 1000000,
    Default = currentSettings.Speed,
    Callback = function(val)
        currentSettings.Speed = val
        applyToTables()
    end
})

-- JumpCap
SettingsTab:Slider({
    Title = "Jump Cap",
    Min = 0.1,
    Max = 5000,
    Default = currentSettings.JumpCap,
    Callback = function(val)
        currentSettings.JumpCap = val
        applyToTables()
    end
})

-- Strafe Acceleration
SettingsTab:Slider({
    Title = "Strafe Acceleration",
    Min = 200,
    Max = 1000000,
    Default = currentSettings.AirStrafeAcceleration,
    Callback = function(val)
        currentSettings.AirStrafeAcceleration = val
        applyToTables()
    end
})

-- Dropdown Apply Method
getgenv().ApplyMode = "Not Optimized"
SettingsTab:Dropdown({
    Title = "Apply Method",
    Options = {"Not Optimized", "Optimized"},
    Default = {getgenv().ApplyMode},
    MultipleOptions = false,
    Callback = function(option)
        getgenv().ApplyMode = option[1]
    end
})

-- =========================
-- อัปเดตทุกครั้งที่เกิดใหม่
-- =========================
player.CharacterAdded:Connect(function()
    task.wait(1)
    applyToTables()
end)

-- =========================
-- มองผู้เล่นที่ล้ม
-- =========================
local downedESPEnabled = false
local downedBillboards = {}

local function updateDownedESP()
    -- ลบของเก่า
    for plr, billboard in pairs(downedBillboards) do
        if billboard then billboard:Destroy() end
    end
    downedBillboards = {}

    if not downedESPEnabled then return end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and root and humanoid.Health <= 0 then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "DownedESP"
                billboard.Adornee = root
                billboard.Size = UDim2.new(0, 150, 0, 50)
                billboard.StudsOffset = Vector3.new(0,3,0)
                billboard.AlwaysOnTop = true
                billboard.Parent = root

                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1,0,1,0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = "ล้ม"
                textLabel.TextColor3 = Color3.fromRGB(255,0,0)
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.GothamBlack
                textLabel.Parent = billboard

                downedBillboards[plr] = billboard
            end
        end
    end
end

-- อัพเดตทุก 0.5 วินาที
task.spawn(function()
    while true do
        if downedESPEnabled then
            updateDownedESP()
        else
            -- ลบ billboard ทุกอันถ้าไม่ได้เปิด
            for plr, billboard in pairs(downedBillboards) do
                if billboard then billboard:Destroy() end
            end
            downedBillboards = {}
        end
        task.wait(0.5)
    end
end)

-- AddToggle ใน VisualsTab
VisualsTab:AddToggle({
    Title="มองผู้เล่นที่ล้ม",
    Description="แสดงข้อความ 'ล้ม' สีแดงเหนือหัวผู้เล่นที่มีเลือด 0",
    Default=false,
    Callback=function(state)
        downedESPEnabled = state
    end
})

EventTab:AddButton({
    Title = "เก็บตั๋วเรียบแมพ",
    Description = "เทเลพอร์ตเก็บตั๋วทีละตัวจนหมด",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local character = LocalPlayer.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local ticketFolder = workspace:FindFirstChild("Game")
            and workspace.Game:FindFirstChild("Effects")
            and workspace.Game.Effects:FindFirstChild("Tickets")
        if not ticketFolder then return end

        -- เริ่มเก็บตั๋ว
        task.spawn(function()
            while true do
                local tickets = {}
                for _, ticketModel in ipairs(ticketFolder:GetChildren()) do
                    if ticketModel:IsA("Model") then
                        local part = ticketModel:FindFirstChildWhichIsA("BasePart")
                        if part then
                            table.insert(tickets, part)
                        end
                    end
                end

                if #tickets == 0 then
                    break -- ถ้าไม่มีตั๋วแล้ว หยุด
                end

                for _, part in ipairs(tickets) do
                    if hrp and part then
                        -- เทเลพอร์ตไปที่ตั๋ว
                        hrp.CFrame = CFrame.new(part.Position + Vector3.new(0,3,0))
                        task.wait(1) -- รอเวลาเก็บ
                    end
                end
            end
        end)
    end
})

-- =========================
-- Recording & Smooth Playback
-- =========================
local ExtraTab = ExtraTab -- ใช้ tab ของของเสริม
local recording = false
local playing = false
local recordedFrames = {}
local recordStartTime = 0
local displayTimeLabel

local TweenService = game:GetService("TweenService")
local PlayerGui = player:WaitForChild("PlayerGui")

-- ฟังก์ชันอัปเดตเวลาบนหน้าจอ
local function updateTimeLabel()
    if not displayTimeLabel then
        displayTimeLabel = Instance.new("TextLabel")
        displayTimeLabel.Size = UDim2.new(0,150,0,50)
        displayTimeLabel.Position = UDim2.new(0.5,-75,0,50)
        displayTimeLabel.BackgroundTransparency = 0.5
        displayTimeLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
        displayTimeLabel.TextColor3 = Color3.fromRGB(255,255,255)
        displayTimeLabel.TextScaled = true
        displayTimeLabel.Parent = PlayerGui
    end
end

-- =========================
-- ปุ่ม 1: Record
-- =========================
ExtraTab:AddButton({
    Title="เริ่มอัดการเคลื่อนไหว",
    Description="กดเพื่อเริ่ม/หยุดอัดการเคลื่อนไหว",
    Callback=function()
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        recording = not recording
        if recording then
            recordedFrames = {}
            recordStartTime = tick()
            updateTimeLabel()
            displayTimeLabel.Text = "0.0s"
            
            -- เริ่มบันทึก
            task.spawn(function()
                while recording do
                    local time = tick() - recordStartTime
                    displayTimeLabel.Text = string.format("%.1fs", time)
                    table.insert(recordedFrames, hrp.CFrame)
                    task.wait(0.1)
                end
                if displayTimeLabel then displayTimeLabel:Destroy(); displayTimeLabel=nil end
            end)
        end
    end
})

-- =========================
-- ปุ่ม 2: Playback Smooth
-- =========================
ExtraTab:AddButton({
    Title="เล่นการเคลื่อนไหว (ลื่น)",
    Description="กดเพื่อเริ่ม/หยุดเล่นการเคลื่อนไหวที่บันทึก",
    Callback=function()
        local char = player.Character
        if not char or #recordedFrames == 0 then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        playing = not playing
        task.spawn(function()
            while playing do
                for i = 1, #recordedFrames-1 do
                    if not playing then break end
                    local startCFrame = recordedFrames[i]
                    local endCFrame = recordedFrames[i+1]
                    local tween = TweenService:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame=endCFrame})
                    tween:Play()
                    tween.Completed:Wait()
                end
            end
        end)
    end
})

-- =========================
-- ปุ่ม 3: Reset
-- =========================
ExtraTab:AddButton({
    Title="รีเซ็ตการเคลื่อนไหว",
    Description="ล้างข้อมูลการอัดทั้งหมด",
    Callback=function()
        recordedFrames = {}
        recording = false
        playing = false
        if displayTimeLabel then displayTimeLabel:Destroy(); displayTimeLabel=nil end
    end
})

-- =========================
-- ระบบลบและคืนค่า Part "Barrier" กับ "MapBarrier"
-- =========================

local workspace = game:GetService("Workspace")

local hiddenParts = {}  -- เก็บ Part ที่ถูกลบไว้เพื่อเอากลับคืน
local deleteAddToggle = false

-- ฟังก์ชันค้นหา Part ทั้งแมพ
local function findParts()
    local found = {}
    local function scan(parent)
        for _, obj in ipairs(parent:GetChildren()) do
            if obj:IsA("BasePart") and (obj.Name == "Barrier" or obj.Name == "MapBarrier") then
                table.insert(found, obj)
            end
            scan(obj)
        end
    end
    scan(workspace)
    return found
end

-- ลบทุก Barrier + MapBarrier
local function deleteAll()
    for _, part in ipairs(findParts()) do
        if part and part.Parent then
            hiddenParts[part] = {
                Parent = part.Parent,
                CFrame = part.CFrame,
                Transparency = part.Transparency,
                CanCollide = part.CanCollide
            }
            part.Parent = nil
        end
    end
end

-- คืนค่า Barrier + MapBarrier ที่ถูกลบ
local function restoreAll()
    for part, data in pairs(hiddenParts) do
        if part then
            part.Parent = data.Parent
            part.CFrame = data.CFrame
            part.Transparency = data.Transparency
            part.CanCollide = data.CanCollide
        end
    end
    hiddenParts = {}
end

-- =========================
-- ปุ่มในหมวด ExtraTab
-- =========================
ExtraTab:AddToggle({
    Title = "ลบ/คืนค่า Barrier & MapBarrier",
    Description = "กดเพื่อสลับลบหรือคืนค่า Part ทั้งหมด",
    Default = false,
    Callback = function(state)
        deleteAddToggle = state
        if deleteAddToggle then
            deleteAll()
        else
            restoreAll()
        end
    end
})

-- =========================
-- ปุ่ม ออโต้เก็บไก่งวง
-- =========================
local autoTurkey = false
local autoTurkeyThread

EventTab:AddToggle({
    Title = "ออโต้เก็บไก่งวง",
    Description = "เทเลพอร์ตไป Nextbot ชื่อ Turkey อัตโนมัติ",
    Default = false,
    Callback = function(state)
        autoTurkey = state

        if autoTurkey then
            autoTurkeyThread = coroutine.create(function()
                local player = game.Players.LocalPlayer
                while autoTurkey do
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        local turkeyNPC
                        -- หา Nextbot ชื่อ Turkey
                        local folder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
                        if folder then
                            for _, npc in ipairs(folder:GetChildren()) do
                                if npc.Name == "Turkey" then
                                    turkeyNPC = npc
                                    break
                                end
                            end
                        end

                        if turkeyNPC and turkeyNPC.Parent then
                            local targetPart = turkeyNPC:FindFirstChild("Root") or turkeyNPC:FindFirstChild("HumanoidRootPart") or turkeyNPC:FindFirstChild("Head")
                            if targetPart then
                                hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0) -- ยกขึ้นเล็กน้อย
                            end
                        else
                            -- ถ้า Turkey หายไป ให้เทเลพอร์ตขึ้นสูง
                            hrp.CFrame = CFrame.new(hrp.Position.X, 1300, hrp.Position.Z)
                        end
                    end
                    task.wait(0.5)
                end
            end)
            coroutine.resume(autoTurkeyThread)
        else
            autoTurkey = false
            if autoTurkeyThread and coroutine.status(autoTurkeyThread) ~= "dead" then
                coroutine.close(autoTurkeyThread)
                autoTurkeyThread = nil
            end
        end
    end
})

-- =========================
-- ปุ่ม วาปหนีบอท
-- =========================
local warpBotActive = false
local warpBotCoroutine

ExtraTab:AddToggle({
    Title = "วาปหนีบอท",
    Description = "เมื่อเน็กบอทใกล้ จะวาปไปผู้เล่นที่สูงที่สุด",
    Default = false,
    Callback = function(state)
        warpBotActive = state

        if warpBotActive then
            -- เริ่ม coroutine ตรวจ Nextbot
            warpBotCoroutine = coroutine.create(function()
                local RunService = game:GetService("RunService")
                local LocalPlayer = game:GetService("Players").LocalPlayer
                local Players = game:GetService("Players")
                while warpBotActive do
                    task.wait(0.1)
                    local char = LocalPlayer.Character
                    if not char then continue end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then continue end

                    -- ตรวจ Nextbot ใกล้ตัว
                    local folder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
                    if folder then
                        for _, npc in ipairs(folder:GetChildren()) do
                            if npc:GetAttribute("Team") == "Nextbot" then
                                local npcPart = npc:FindFirstChild("Root") or npc:FindFirstChild("HumanoidRootPart")
                                if npcPart and (npcPart.Position - root.Position).Magnitude <= 10 then
                                    -- หา Player ที่อยู่สูงที่สุด
                                    local targetPlayer = nil
                                    local maxY = -math.huge
                                    for _, plr in ipairs(Players:GetPlayers()) do
                                        if plr ~= LocalPlayer and plr.Character then
                                            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                                            if hrp then
                                                if hrp.Position.Y > maxY then
                                                    maxY = hrp.Position.Y
                                                    targetPlayer = hrp
                                                end
                                            end
                                        end
                                    end
                                    -- วาร์ปไป Player สูงที่สุด
                                    if targetPlayer then
                                        root.CFrame = targetPlayer.CFrame + Vector3.new(0,2,0)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            coroutine.resume(warpBotCoroutine)
        else
            -- ปิดระบบ
            if warpBotCoroutine and coroutine.status(warpBotCoroutine) ~= "dead" then
                coroutine.close(warpBotCoroutine)
            end
            warpBotCoroutine = nil
        end
    end
})

-- =========================
-- ปุ่ม เปลี่ยนเป็นกลางวัน
-- =========================
ExtraTab:AddButton({
    Title = "เปลี่ยนเป็นกลางวัน",
    Description = "ตั้งเวลา Map เป็น 12:00",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        Lighting.ClockTime = 12 -- ตั้งเวลาเที่ยงวัน
        print("ตั้งเวลาเป็นกลางวัน 12:00 เรียบร้อย")
    end
})

-- =========================
-- ปุ่ม เปลี่ยนเป็นกลางคืน
-- =========================
ExtraTab:AddButton({
    Title = "เปลี่ยนเป็นกลางคืน",
    Description = "ตั้งเวลา Map เป็น 22:00",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        Lighting.ClockTime = 22 -- ตั้งเวลา 22:00
        print("ตั้งเวลาเป็นกลางคืน 22:00 เรียบร้อย")
    end
})

local AutoCarryEnabled = false
local CarryConnection

TeleportTab:AddToggle({
    Title = "เก็บผู้เล่นที่ล้ม",
    Description = "เทเลพอร์ตไปหาผู้เล่นที่ล้มและอุ้ม",
    Default = false,
    Callback = function(state)
        AutoCarryEnabled = state

        if CarryConnection then
            CarryConnection:Disconnect()
            CarryConnection = nil
        end

        if state then
            CarryConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not AutoCarryEnabled then return end
                local localChar = game.Players.LocalPlayer.Character
                local hrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                -- เก็บตำแหน่งเดิม
                local originalCFrame = hrp.CFrame

                -- หา player ที่ล้ม
                local fallenPlayers = {}
                for _, plr in ipairs(game.Players:GetPlayers()) do
                    if plr ~= game.Players.LocalPlayer and plr.Character then
                        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health <= 0 then
                            table.insert(fallenPlayers, plr)
                        end
                    end
                end

                -- ถ้าเจอคนล้ม
                if #fallenPlayers > 0 then
                    -- เลือกคนที่ไม่ใช่คนใกล้ที่สุด (สุ่ม)
                    local target = fallenPlayers[math.random(1, #fallenPlayers)]
                    local targetHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        -- เทเลพอร์ตไปยังผู้เล่นนั้น
                        hrp.CFrame = targetHRP.CFrame + Vector3.new(0,3,0)

                        -- ใช้ระบบ Auto Carry
                        pcall(function()
                            game:GetService("ReplicatedStorage"):WaitForChild("Events")
                                :WaitForChild("Character")
                                :WaitForChild("Interact")
                                :FireServer("Carry", nil, target.Name)
                        end)

                        task.wait(0.5) -- เวลารออุ้ม

                        -- เทเลพอร์ตกลับ
                        hrp.CFrame = originalCFrame
                        task.wait(0.3) -- เว้นเวลาสักนิดก่อนวนต่อ
                    end
                end
            end)
        end
    end
})

-- =========================================
-- ตัวแปรบิน
-- =========================================
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer

local flying = false
local flyForce, flyGyro

-- ค่าเริ่มต้นของความเร็วบิน
local FlySpeed = 1.5


-- =========================================
-- ฟังก์ชันเริ่มบิน
-- =========================================
local function StartFly()
    local char = player.Character
    if not char then return end

    local human = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not human or not root then return end

    flying = true

    flyForce = Instance.new("BodyVelocity")
    flyGyro = Instance.new("BodyGyro")

    flyGyro.P = 10000
    flyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    flyGyro.CFrame = root.CFrame

    flyForce.Velocity = Vector3.new()
    flyForce.MaxForce = Vector3.new(100000, 100000, 100000)

    flyForce.Parent = root
    flyGyro.Parent = root

    human.PlatformStand = true
    human.AutoRotate = false

    task.spawn(function()
        while flying do
            task.wait()

            local FV = Camera.CFrame:VectorToWorldSpace(Vector3.new(0, 0, -1))
            local SV = Camera.CFrame:VectorToWorldSpace(Vector3.new(-1, 0, 0))
            local move = human.MoveDirection

            local push =
                (FV * (60 * FlySpeed) * -move.Z)
                + (SV * (40 * FlySpeed) * -move.X)

            flyGyro.CFrame = CFrame.new(Vector3.new(), FV)
            flyForce.Velocity = flyForce.Velocity:Lerp(push, 0.2)
        end
    end)
end

-- =========================================
-- ฟังก์ชันหยุดบิน
-- =========================================
local function StopFly()
    flying = false

    local char = player.Character
    if not char then return end
    local human = char:FindFirstChildOfClass("Humanoid")

    if flyForce then flyForce:Destroy() end
    if flyGyro then flyGyro:Destroy() end

    if human then
        human.PlatformStand = false
        human.AutoRotate = true
    end
end


-- =========================================
-- ปุ่มบินในหมวดเมนูหลัก
-- =========================================

MainTab:AddButton({
    Title = "บิน (Fly)",
    Description = "เปิด/ปิดระบบบิน",
    Callback = function()
        flying = not flying
        if flying then
            StartFly()
        else
            StopFly()
        end
    end
})

-- =========================================
-- ช่องใส่ความเร็วอยู่ใต้ปุ่มบิน
-- =========================================

MainTab:AddInput({
    Title = "ความเร็วบิน (Speed)",
    Default = tostring(FlySpeed),
    Placeholder = "1.5",
    Callback = function(txt)
        local num = tonumber(txt)
        if num then
            FlySpeed = num
        end
    end
})

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
ExtraTab:AddToggle({
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
ExtraTab:AddToggle({
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

-- ตัวแปรสถานะรันสคริปต์
local fakeEdashRunning = false
local fakeEdashConnection

-- ปุ่มในหมวด ของเสริม
ExtraTab:AddButton({
    Title = "เสกท่าเวล100 ของปลอม❌(ของคนอื่น)",
    Description = "กดเพื่อเปิด/ปิดสคริปต์ fake edash",
    Callback = function()
        if not fakeEdashRunning then
            -- ========== เริ่มรันสคริปต์ ==========
            fakeEdashRunning = true
            print("Fake Edash เริ่มทำงาน!")

            -- โหลดสคริปต์จากลิ้ง
            local source = game:HttpGet("https://raw.githubusercontent.com/G4V3S/S/refs/heads/main/fake%20edash.lua")
            fakeEdashConnection = loadstring(source)

            -- รัน
            task.spawn(function()
                pcall(fakeEdashConnection)
            end)

        else
            -- ========== ปิดสคริปต์ ==========
            fakeEdashRunning = false
            print("Fake Edash ถูกปิดแล้ว!")

            -- พยายามหยุดสคริปต์โดยรีโหลด environment
            fakeEdashConnection = nil
        end
    end
})

-- =========================
-- Bounce AddButton (Auto Trimp Style)
-- =========================
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local bounceEnabled = false
local bounceHeight = 100
local bounceDistance = 8

local function isNearGround(hrp)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescriptionendantsInstances = {hrp.Parent}

    local offsets = {
        Vector3.new(0,-bounceDistance,0),
        Vector3.new(2,-bounceDistance,0),
        Vector3.new(-2,-bounceDistance,0),
        Vector3.new(0,-bounceDistance,2),
        Vector3.new(0,-bounceDistance,-2)
    }

    for _,offset in ipairs(offsets) do
        local r = workspace:Raycast(hrp.Position, offset, rayParams)
        if r and r.Instance and r.Instance.CanCollide then
            return true
        end
    end
    return false
end

-- ทำงานตลอดจนกว่าจะปิด
task.spawn(function()
    while true do
        if bounceEnabled then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    
                    local vel = hrp.Velocity
                    if vel.Y < -35 and isNearGround(hrp) then
                        hrp.Velocity = Vector3.new(vel.X, bounceHeight, vel.Z)

                        local fx = Instance.new("ParticleEmitter")
                        fx.Texture = "rbxassetid://241594180"
                        fx.Lifetime = NumberRange.new(0.3)
                        fx.Speed = NumberRange.new(40)
                        fx.Rate = 200
                        fx.Parent = hrp
                        Debris:AddItem(fx,0.3)
                    end
                end
            end
        end
        task.wait()
    end
end)

-- ========= ปุ่มลอย =========
local floatingBounceAddButton
local autoBounce = false

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
        bounceEnabled = autoBounce
        floatingBounceAddButton.Text = autoBounce and "Auto Bounce: ON" or "Auto Bounce: OFF"
    end)
end



-- ========= ปุ่มในเมนูหลัก =========
MainTab:AddToggle("010",{
    Title = "ออโต้ทริป",
    Description = "เด้งอัตโนมัติแบบตรวจพื้นแม่นยำ",
    Default = false,
    Callback = function(v)
        bounceEnabled = v
    end
})

-- ========= ปุ่มลอยในเมนูหลัก =========
MainTab:AddToggle("011",{
    Title="ออโต้เด้ง (ปุ่มลอย)",
    Description="แสดงปุ่มลอยสำหรับ Auto Bounce (แม่นยำกว่าเดิม)",
    Default=false,
    Callback=function(state)
        if state then 
            createBounceFloatingAddButton()
        else
            if floatingBounceAddButton then
                floatingBounceAddButton:Destroy()
                floatingBounceAddButton=nil
            end
            autoBounce=false
            bounceEnabled=false
        end
    end
})




-- =========================
-- AddToggle ปิดข้อความตรงจอ (อยู่ในหมวด ของเสริม)
-- =========================
local infoVisible = true

ExtraTab:AddToggle({
    Title = "เปิดแฟ้มอีโมท(เสกท่า)",
    Description = "รันสคริปต์ Emote จาก Pastebin",
    Callback = function()
        local url = "https://pastebin.com/raw/DSZCMGqh" -- ใช้ raw link ของ Pastebin
        local success, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        if not success then
            warn("ไม่สามารถรันสคริปต์ Emote ได้: "..tostring(err))
        end
    end
})




-- =========================
-- ปุ่มหน้าจอยืด (Stretch Screen) ในหมวดของเสริม
-- =========================
getgenv().ScreenStretchActive = false
getgenv().Resolution = { [".gg/scripters"] = 0.65 }
local Camera = workspace.CurrentCamera
local ScreenStretchConn

ExtraTab:AddToggle({
    Title = "หน้าจอยืด",
    Description = "เปิด/ปิด ปรับแกน Y ของกล้อง",
    Default = false,
    Callback = function(state)
        if state then
            if not ScreenStretchConn then
                getgenv().ScreenStretchActive = true
                ScreenStretchConn = game:GetService("RunService").RenderStepped:Connect(function()
                    if Camera and getgenv().ScreenStretchActive then
                        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution[".gg/scripters"], 0, 0, 0, 1)
                    end
                end)
            end
            print("หน้าจอยืด เปิดแล้ว")
        else
            getgenv().ScreenStretchActive = false
            if ScreenStretchConn then
                ScreenStretchConn:Disconnect()
                ScreenStretchConn = nil
            end
            print("หน้าจอยืด ปิดแล้ว")
        end
    end
})



-- =========================
-- AUTO REVIVE FRIENDS (ไม่มีลิงก์)
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
-- AddToggle (อยู่ในหมวด ของเสริม)
-- =========================

MainTab:AddToggle("012",{
    Title = "ออโต้ชุบเพื่อน",
    Description = "ชุบผู้เล่นที่ล้มอัตโนมัติเมื่ออยู่ใกล้",
    Callback = function(state)
        autoReviveEnabled = state
        if state then
            startAutoRevive()
        else
            stopAutoRevive()
        end
    end
})

-- =========================
-- SERVICES
-- =========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- =========================
-- CONFIG
-- =========================
local REVIVE_RANGE = 15
local REVIVE_CHECK_DELAY = 0.3
local AFK_TELEPORT_DELAY = 1.5
local AFK_HEIGHT = 1200

-- =========================
-- VARIABLES
-- =========================
local autoReviveEnabled = false
local afkMoneyEnabled = false

local reviveLoop = nil
local afkLoop = nil
local afkPart = nil

local interactEvent =
ReplicatedStorage:WaitForChild("Events")
:WaitForChild("Character")
:WaitForChild("Interact")

-- =========================
-- UTILS
-- =========================
local function isDowned(plr)
local char = plr.Character
if not char then return false end
return char:GetAttribute("Downed") == true
end

-- =========================
-- AFK PART
-- =========================
local function createAFKPart()
if afkPart then return end

afkPart = Instance.new("Part")  
afkPart.Name = "AFK_PART"  
afkPart.Size = Vector3.new(25, 2, 25)  
afkPart.Anchored = true  
afkPart.CanCollide = true  
afkPart.Material = Enum.Material.Neon  
afkPart.Color = Color3.fromRGB(0, 170, 255)  
afkPart.Position = Vector3.new(0, AFK_HEIGHT, 0)  
afkPart.Parent = workspace

end

local function tpToAFKPart(hrp)
if afkPart and hrp then
hrp.CFrame = afkPart.CFrame + Vector3.new(0, 3, 0)
end
end

-- =========================
-- AUTO REVIVE
-- =========================
local function startAutoRevive()
if reviveLoop then return end

reviveLoop = task.spawn(function()  
    while autoReviveEnabled do  
        local char = LocalPlayer.Character  
        local hrp = char and char:FindFirstChild("HumanoidRootPart")  

        if hrp then  
            for _, pl in ipairs(Players:GetPlayers()) do  
                if pl ~= LocalPlayer and isDowned(pl) then  
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

local function stopAutoRevive()
autoReviveEnabled = false
end

-- =========================
-- AFK MONEY SYSTEM
-- =========================
local function startAFKMoney()
if afkLoop then return end

createAFKPart()  

afkLoop = task.spawn(function()  
    while afkMoneyEnabled do  
        local char = LocalPlayer.Character  
        local hrp = char and char:FindFirstChild("HumanoidRootPart")  

        if not hrp then  
            task.wait(0.5)  
            continue  
        end  

        local found = false  

        for _, pl in ipairs(Players:GetPlayers()) do  
            if pl ~= LocalPlayer and isDowned(pl) then  
                local pChar = pl.Character  
                local pHrp = pChar and pChar:FindFirstChild("HumanoidRootPart")  
                if pHrp then  
                    found = true  
                    repeat  
                        hrp.CFrame = pHrp.CFrame + Vector3.new(0, 3, 0)  
                        pcall(function()  
                            interactEvent:FireServer("Revive", true, pl.Name)  
                        end)  
                        task.wait(0.4)  
                    until not isDowned(pl) or not afkMoneyEnabled  
                end  
            end  
        end  

        if not found then  
            tpToAFKPart(hrp)  
        end  

        task.wait(AFK_TELEPORT_DELAY)  
    end  
    afkLoop = nil  
end)

end

local function stopAFKMoney()
afkMoneyEnabled = false
if afkPart then
afkPart:Destroy()
afkPart = nil
end
end

-- =========================
-- RESPAWN FIX (สำคัญสุด)
-- =========================
LocalPlayer.CharacterAdded:Connect(function(char)
if not afkMoneyEnabled then return end

task.spawn(function()  
    local hrp = char:WaitForChild("HumanoidRootPart", 10)  
    local hum = char:WaitForChild("Humanoid", 10)  
    if not hrp or not hum then return end  

    -- วาร์ปซ้ำ กันเกมดึงกลับ  
    for i = 1, 5 do  
        if afkPart then  
            hrp.CFrame = afkPart.CFrame + Vector3.new(0, 3, 0)  
        end  
        task.wait(0.3)  
    end  

    -- ดักตอนฟื้นจริง  
    hum.StateChanged:Connect(function(_, new)  
        if afkMoneyEnabled and afkPart then  
            if new == Enum.HumanoidStateType.Running  
            or new == Enum.HumanoidStateType.RunningNoPhysics then  
                task.wait(0.1)  
                hrp.CFrame = afkPart.CFrame + Vector3.new(0, 3, 0)  
            end  
        end  
    end)  
end)

end)

-- =========================
-- UI AddToggleS
-- =========================
TeleportTab:AddToggle({
Title = "Auto Revive",
Description = "ชุบเพื่อนที่ล้มใกล้ตัว",
Callback = function(state)
autoReviveEnabled = state
if state then
startAutoRevive()
else
stopAutoRevive()
end
end
})

TeleportTab:AddToggle({
Title = "AFK Money (New)",
Description = "เสก Part + วาร์ปชุบอัตโนมัติ",
Callback = function(state)
afkMoneyEnabled = state
if state then
startAFKMoney()
else
stopAFKMoney()
end
end
})

-- =========================
-- LOAD SCRIPT FROM PASTEBIN WITH NOTIFY
-- =========================

local url = "https://pastebin.com/raw/0TVwujLr"

local success, err = pcall(function()
    loadstring(game:HttpGet(url))()
end)

if success then
    -- สร้างข้อความแจ้งเตือน
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local PlayerGui = player:WaitForChild("PlayerGui")

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NotifyScript"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(0,300,0,50)
    TextLabel.Position = UDim2.new(0.5,-150,0.1,0)
    TextLabel.BackgroundTransparency = 0.5
    TextLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
    TextLabel.TextColor3 = Color3.fromRGB(0,255,0)
    TextLabel.TextScaled = true
    TextLabel.Text = "กันเตะได้ทำงาน ✅"
    TextLabel.Parent = ScreenGui

    -- ค่อยๆ หายไปใน 3 วิ
    task.delay(3, function()
        if ScreenGui then
            ScreenGui:Destroy()
        end
    end)
else
    warn("ไม่สามารถรันสคริปต์จาก Pastebin ได้: "..tostring(err))
end

-- =========================
-- Camera Part System (SettingsTab)
-- =========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local camPart
local partEnabled = false
local viewEnabled = false

-- สร้าง Part กล้อง
local function createCameraPart()
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	camPart = Instance.new("Part")
	camPart.Name = "CameraPart"
	camPart.Size = Vector3.new(2,2,2)
	camPart.Anchored = true
	camPart.CanCollide = false
	camPart.Material = Enum.Material.SmoothPlastic
	camPart.Color = Color3.fromRGB(0,0,0)

	local cf = camera.CFrame
	camPart.CFrame = cf + (cf.LookVector * 6)
	camPart.Parent = workspace
end

-- ปุ่ม 1: สร้าง / ลบ Part กล้อง
SettingsTab:AddButton({
	Title = "สร้าง / ลบ กล้อง",
	Description = "สร้าง Part กล้องไว้ตรงหน้า (กดซ้ำเพื่อลบ)",
	Callback = function()
		if not partEnabled then
			createCameraPart()
			partEnabled = true
		else
			if camPart then
				camPart:Destroy()
				camPart = nil
			end
			partEnabled = false

			if viewEnabled then
				camera.CameraType = Enum.CameraType.Custom
				if player.Character then
					camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
				end
				viewEnabled = false
			end
		end
	end
})

-- ปุ่ม 2: สลับมุมมอง
SettingsTab:AddButton({
	Title = "สลับมุมมองกล้อง",
	Description = "กล้อง ↔ ตัวละคร",
	Callback = function()
		if not camPart then return end

		if not viewEnabled then
			camera.CameraType = Enum.CameraType.Scriptable
			camera.CFrame = camPart.CFrame
			viewEnabled = true
		else
			camera.CameraType = Enum.CameraType.Custom
			if player.Character then
				camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
			end
			viewEnabled = false
		end
	end
})

-- อัปเดตกล้องตาม Part
RunService.RenderStepped:Connect(function()
	if viewEnabled and camPart then
		camera.CFrame = camPart.CFrame
	end
end)

-- กันพังตอนเกิดใหม่
player.CharacterAdded:Connect(function(char)
	task.wait(0.2)
	camera.CameraType = Enum.CameraType.Custom
	camera.CameraSubject = char:WaitForChild("Humanoid")
	viewEnabled = false
end)

-- =========================
-- พื้นใส (Reflectance AddToggle)
-- =========================
local floorReflectOn = false
local originalParts = {}

local function enableFloorReflect()
	for _, obj in pairs(workspace:GetDescriptionendants()) do
		if obj:IsA("BasePart") then
			-- เก็บค่าเดิม
			if not originalParts[obj] then
				originalParts[obj] = {
					Material = obj.Material,
					Reflectance = obj.Reflectance
				}
			end
			obj.Material = Enum.Material.SmoothPlastic
			obj.Reflectance = 0.3
		end
	end
end

local function disableFloorReflect()
	for obj, data in pairs(originalParts) do
		if obj and obj.Parent then
			obj.Material = data.Material
			obj.Reflectance = data.Reflectance
		end
	end
	originalParts = {}
end

ExtraTab:AddToggle({
	Title = "พื้นใส",
	Description = "ทำให้ Part ทั้งแมพสะท้อนแสง",
	Default = false,
	Callback = function(state)
		floorReflectOn = state
		if state then
			enableFloorReflect()
		else
			disableFloorReflect()
		end
	end
})


-- =========================
-- Notify
-- =========================
Window:Notify({
Title="Evade Hub",
Description="เมนูทั้งหมดโหลดเรียบร้อยแล้ว! เปิด/ปิดเมนูได้ทั้ง Desktop และ มือถือ",
Time=4
})
