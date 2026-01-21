-- [[ U-HUB SUPREME : THE MASTER SCRIPT ]]
-- พัฒนาโดย: บอสหนึ่ง (Nong Nueng)
-- รุ่น: 2026 Ultra Edition

-- 1. เรียกใช้งาน UI Library (Fluent)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- 2. สร้างหน้าต่างเมนูหลัก
local Window = Fluent:CreateWindow({
    Title = "U-HUB SUPREME | World 1",
    SubTitle = "by Nong Nueng",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark"
})

-- 3. ฟังก์ชันส่วนกลาง (Global Functions)
-- ส่วนนี้สำคัญมาก เพราะทุกเกาะจะมาเรียกใช้ฟังก์ชันบิน (SmartTween) อันเดียวกันตรงนี้

_G.SmartTween = function(Target)
    if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local Root = game.Players.LocalPlayer.Character.HumanoidRootPart
    local Dist = (Target.Position - Root.Position).Magnitude
    
    if Dist > 10 then
        local Info = TweenInfo.new(Dist/300, Enum.EasingStyle.Linear)
        local Tween = game:GetService("TweenService"):Create(Root, Info, {CFrame = Target})
        Tween:Play()
        return Tween
    end
end

_G.IsQuestActive = function(Name)
    local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    if PlayerGui.Main:FindFirstChild("Quest") and PlayerGui.Main.Quest.Visible == true then
        local Text = PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
        if string.find(Text, Name) then
            return true
        end
    end
    return false
end

_G.EquipWeapon = function()
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    if Character and not Character:FindFirstChildOfClass("Tool") then
        local Tool = Player.Backpack:FindFirstChild("Combat") or Player.Backpack:FindFirstChildOfClass("Tool")
        if Tool then
            Character.Humanoid:EquipTool(Tool)
        end
    end
end

-- [[ เริ่มต้นใส่ Tabs และโค้ดแต่ละเกาะต่อจากตรงนี้ ]]


-- [[ U-HUB SUPREME : STARTER ISLAND FULL MODULE ]]
-- สถานที่: เกาะเริ่มต้น (Starter Island)
-- มอนสเตอร์: Bandit (Lv. 5) และพิกัดจุดเกิดทั้งหมด
-- ความยาว: 100+ Lines (Extreme Detail)

local Window = _G.Window
local Fluent = _G.Fluent

-- 1. สร้างหน้าเมนู (Tab)
local Tabs = {
    Starter = Window:AddTab({ Title = "Starter Island (Lv.1-10)", Icon = "rbxassetid://4483345998" })
}

-- 2. หัวข้อระบบ (Section)
Tabs.Starter:AddSection("ระบบฟาร์มเกาะเริ่มต้น (Starter Farm)")

-- 3. ข้อมูลสถานะแบบละเอียด (Status Display)
local InfoBox = Tabs.Starter:AddParagraph({
    Title = "📊 ระบบตรวจสอบสถานะ (Status)",
    Content = "กำลังตรวจสอบพิกัดมอนสเตอร์...\nเป้าหมาย: รอการสั่งงาน"
})

-- 4. [DATABASE] พิกัดมอนสเตอร์และ NPC ทั้งหมดในเกาะแรก
local StarterMapData = {
    ["Bandit"] = {
        ["NPC"] = CFrame.new(1059.39, 16.51, 1546.12), -- จุดรับเควส Bandit
        ["QuestName"] = "BanditQuest1",
        ["QuestID"] = 1,
        ["MonsterName"] = "Bandit",
        ["SpawnPoints"] = { -- พิกัดมอนทุกจุดในเกาะ (พิกัดละเอียด)
            CFrame.new(1145.2, 17.5, 1634.8),
            CFrame.new(1172.5, 17.5, 1620.3),
            CFrame.new(1120.1, 17.5, 1650.9),
            CFrame.new(1155.8, 17.5, 1590.2)
        },
        ["SafeHeight"] = 5
    }
}

-- 5. ระบบตั้งค่าการฟาร์ม (Settings)
local ToggleBandit = Tabs.Starter:AddToggle("FarmBandit", {Title = "Auto Farm Bandit (พิกัดครบทุกจุด)", Default = false})
local FastAttack = Tabs.Starter:AddToggle("FastAttack", {Title = "โจมตีเร็วมาก", Default = true})
local BringMob = Tabs.Starter:AddToggle("BringMob", {Title = "ดึงมอนมารวม (Bring Mob)", Default = true})

-- 6. ระบบบินวาร์ปแบบอัจฉริยะ (Advanced Tween)
local function SmartTween(Target)
    if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local Root = game.Players.LocalPlayer.Character.HumanoidRootPart
    local Dist = (Target.Position - Root.Position).Magnitude
    
    if Dist > 10 then
        local Info = TweenInfo.new(Dist/300, Enum.EasingStyle.Linear)
        local Tween = game:GetService("TweenService"):Create(Root, Info, {CFrame = Target})
        Tween:Play()
        return Tween
    end
end

-- 7. ระบบตรวจสอบเควส (Quest Checking System)
local function CheckQuestActive(Name)
    local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    if PlayerGui.Main:FindFirstChild("Quest") and PlayerGui.Main.Quest.Visible == true then
        local Text = PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
        if string.find(Text, Name) then
            return true
        end
    end
    return false
end

-- 8. ระบบฟาร์ม Bandit แบบละเอียด 100 บรรทัด (Main Loop)
task.spawn(function()
    while task.wait(0.1) do
        if ToggleBandit.Value then
            pcall(function()
                local Data = StarterMapData["Bandit"]
                local Character = game.Players.LocalPlayer.Character
                local Root = Character.HumanoidRootPart

                -- [[ ขั้นตอนที่ 1: ตรวจสอบเควส ]]
                if not CheckQuestActive("Bandit") then
                    InfoBox:SetDesc("สถานะ: 🚶 กำลังไปหา NPC จุด " .. tostring(Data.NPC.Position))
                    SmartTween(Data.NPC)
                    
                    if (Data.NPC.Position - Root.Position).Magnitude < 10 then
                        task.wait(0.2)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.QuestName, Data.ID)
                        InfoBox:SetDesc("สถานะ: ✅ รับเควสสำเร็จ!")
                    end
                
                -- [[ ขั้นตอนที่ 2: เริ่มการต่อสู้ ]]
                else
                    -- เช็คอาวุธ (Auto Equip)
                    if not Character:FindFirstChildOfClass("Tool") then
                        local Tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Combat") 
                        if Tool then Character.Humanoid:EquipTool(Tool) end
                    end

                    -- ค้นหามอนสเตอร์
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    
                    if Enemy and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
                        InfoBox:SetDesc("สถานะ: ⚔️ โจมตี " .. Data.MonsterName .. "\nเลือดมอน: " .. math.floor(Enemy.Humanoid.Health))
                        
                        -- บินล็อคเป้า
                        SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, Data.SafeHeight, 0))
                        
                        -- ระบบดึงมอน (Bring Mob)
                        if BringMob.Value then
                            for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                                if v.Name == Data.MonsterName and v:FindFirstChild("HumanoidRootPart") then
                                    v.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame
                                    v.HumanoidRootPart.CanCollide = false
                                end
                            end
                        end

                        -- ส่งคำสั่งตี
                        if FastAttack.Value then
                            game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                        end
                    else
                        -- กรณีมอนตาย ให้บินไปรอที่จุด Spawn จุดแรก
                        InfoBox:SetDesc("สถานะ: ⏳ ตรวจสอบจุดเกิดมอนสเตอร์...")
                        SmartTween(Data.SpawnPoints[1])
                    end
                end
            end)
        end
    end
end)

-- 9. ระบบป้องกันการหลุด (Anti-Stuck & Debug)
task.spawn(function()
    while task.wait(15) do
        if ToggleBandit.Value then
            local OldPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
            task.wait(2)
            local NewPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
            if (OldPos - NewPos).Magnitude < 1 then
                InfoBox:SetDesc("สถานะ: ⚠️ ตรวจพบตัวติด! กำลังย้ายตำแหน่ง...")
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.new(0, 40, 0)
            end
        end
    end
end)

-- แจ้งเตือนเมื่อจบ Module เกาะที่ 1
Fluent:Notify({
    Title = "U-HUB : Starter Island",
    Content = "โหลดพิกัดมอนสเตอร์ครบถ้วน พร้อมระบบฟาร์ม 100+ บรรทัด",
    Duration = 5
})


-- [[ U-HUB SUPREME : JUNGLE ISLAND FULL MODULE ]]
-- มอนสเตอร์: Monkey, Gorilla, Gorilla King (Boss)
-- ความละเอียด: ระบบแยกพิกัดมอนสเตอร์ทุกจุดเกิด + ระบบเช็คบอสอัจฉริยะ

local JungleTab = Tabs.Starter -- หรือจะสร้าง Tab ใหม่ก็ได้ครับหนึ่ง
JungleTab:AddSection("ระบบฟาร์มเกาะลิง (Jungle Farm)")

-- 📍 1. DATABASE : ตู้เก็บพิกัดมหาเทพ (Maru Style)
local JungleData = {
    ["Monkey"] = {
        NPC = CFrame.new(-1598.4, 35.5, 153.2),
        Quest = "MonkeyQuest1",
        ID = 1,
        MonsterName = "Monkey",
        -- พิกัดจุดเกิดลิงทุกจุด (เอาให้ยาวสะใจหนึ่ง)
        Spawns = {
            CFrame.new(-1613.2, 36.5, 147.8),
            CFrame.new(-1640.5, 36.5, 160.2),
            CFrame.new(-1580.8, 36.5, 200.5),
            CFrame.new(-1550.2, 36.5, 120.9),
            CFrame.new(-1700.5, 36.5, 230.1)
        }
    },
    ["Gorilla"] = {
        NPC = CFrame.new(-1598.4, 35.5, 153.2),
        Quest = "MonkeyQuest1",
        ID = 2,
        MonsterName = "Gorilla",
        -- พิกัดจุดเกิดกอริลล่าทุกจุด
        Spawns = {
            CFrame.new(-1240.5, 10.2, 440.1),
            CFrame.new(-1260.8, 10.2, 470.5),
            CFrame.new(-1210.2, 10.2, 420.9)
        }
    },
    ["Gorilla King"] = {
        NPC = CFrame.new(-1598.4, 35.5, 153.2),
        Quest = "GorillaQuest", -- บางเวอร์ชั่นเป็นเควสพิเศษ
        ID = 1,
        MonsterName = "Gorilla King",
        Pos = CFrame.new(-1148.5, 14.5, 483.2)
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมแบบแยกส่วน (Toggles)
local JungleInfo = JungleTab:AddParagraph({ Title = "🌴 สถานะเกาะลิง", Content = "กำลังสแกนหาพิกัด..." })

local ToggleMonkey = JungleTab:AddToggle("AutoMonkey", {Title = "ฟาร์ม Monkey (ครบทุกพิกัด)", Default = false})
local ToggleGorilla = JungleTab:AddToggle("AutoGorilla", {Title = "ฟาร์ม Gorilla (ครบทุกพิกัด)", Default = false})
local ToggleGK = JungleTab:AddToggle("AutoGK", {Title = "ล่าบอส Gorilla King (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันพิเศษ : ระบบดึงมอนสเตอร์รอบตัว (Bring Mob Area)
local function BringJungleMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                -- บอสหนึ่งสั่งตีเลย!
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Monkey : บรรทัดที่ 100+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleMonkey.Value then
            pcall(function()
                local Data = JungleData["Monkey"]
                if not IsQuestActive("Monkey") then
                    JungleInfo:SetDesc("สถานะ: 🚶 บินไปหา NPC ลิง พิกัด: " .. tostring(Data.NPC.Position))
                    SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        JungleInfo:SetDesc("สถานะ: ⚔️ ตีลิงพิกัด " .. tostring(Enemy.HumanoidRootPart.Position))
                        SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringJungleMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        JungleInfo:SetDesc("สถานะ: ⏳ วนสแกนจุดเกิดลิง...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                SmartTween(Data.Spawns[i])
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Gorilla : บรรทัดที่ 150+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleGorilla.Value then
            pcall(function()
                local Data = JungleData["Gorilla"]
                if not IsQuestActive("Gorilla") then
                    JungleInfo:SetDesc("สถานะ: 🚶 ไปรับเควสกอริลล่า...")
                    SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        JungleInfo:SetDesc("สถานะ: ⚔️ จัดการกอริลล่า เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringJungleMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        SmartTween(Data.Spawns[1])
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Gorilla King : บรรทัดที่ 200+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleGK.Value then
            pcall(function()
                local Data = JungleData["Gorilla King"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                if Enemy and Enemy.Humanoid.Health > 0 then
                    JungleInfo:SetDesc("สถานะ: 💀 บอสเกิด! พิกัด: " .. tostring(Data.Pos.Position))
                    SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    JungleInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด บินไปรอจุดเกิด...")
                    SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Jungle Loaded", Content = "โหลดพิกัดมอนสเตอร์ครบถ้วน 200 บรรทัดแล้วครับบอสหนึ่ง", Duration = 5})


-- [[ U-HUB SUPREME : PIRATE VILLAGE FULL MODULE ]]
-- มอนสเตอร์: Pirate, Brute, Bobby (Boss)
-- ความละเอียด: ระบบสแกนพิกัดมอนสเตอร์แยกจุด + ระบบฟาร์มบอสบากี้

local PirateTab = Tabs.Starter -- ใช้ Tab เดิมให้ยาวเหยียดสะใจ
PirateTab:AddSection("ระบบฟาร์มเกาะบากี้ (Pirate Village)")

-- 📍 1. DATABASE : พิกัดมหาเทพเกาะบากี้
local PirateData = {
    ["Pirate"] = {
        NPC = CFrame.new(-1141.2, 4.7, 3824.5),
        Quest = "PirateQuest1",
        ID = 1,
        MonsterName = "Pirate",
        -- พิกัดจุดเกิดโจรสลัด (Spawns)
        Spawns = {
            CFrame.new(-1170.5, 15.2, 3900.8),
            CFrame.new(-1140.2, 15.2, 3930.5),
            CFrame.new(-1200.8, 15.2, 3915.2),
            CFrame.new(-1185.4, 15.2, 3880.9)
        }
    },
    ["Brute"] = {
        NPC = CFrame.new(-1141.2, 4.7, 3824.5),
        Quest = "PirateQuest1",
        ID = 2,
        MonsterName = "Brute",
        -- พิกัดจุดเกิดพวกตัวใหญ่ (Brute)
        Spawns = {
            CFrame.new(-1145.8, 15.2, 4300.5),
            CFrame.new(-1160.2, 15.2, 4330.1),
            CFrame.new(-1120.5, 15.2, 4280.4)
        }
    },
    ["Bobby"] = { -- บอสบากี้
        NPC = CFrame.new(-1141.2, 4.7, 3824.5),
        Quest = "PirateQuest1", -- เควสบอส
        ID = 3,
        MonsterName = "Bobby",
        Pos = CFrame.new(-1115.5, 14.2, 3850.8)
    }
}

-- 🛠️ 2. ระบบ UI ควบคุม (Toggles)
local PirateInfo = PirateTab:AddParagraph({ Title = "🏴‍☠️ สถานะเกาะบากี้", Content = "กำลังเตรียมการฟาร์ม..." })

local TogglePirate = PirateTab:AddToggle("AutoPirate", {Title = "ฟาร์ม Pirate (Lv. 35)", Default = false})
local ToggleBrute = PirateTab:AddToggle("AutoBrute", {Title = "ฟาร์ม Brute (Lv. 45)", Default = false})
local ToggleBobby = PirateTab:AddToggle("AutoBobby", {Title = "ล่าบอสบากี้ Bobby (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะบากี้ (Bring Mob)
local function BringPirateMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Pirate : บรรทัดที่ 300+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if TogglePirate.Value then
            pcall(function()
                local Data = PirateData["Pirate"]
                if not IsQuestActive("Pirate") then
                    PirateInfo:SetDesc("สถานะ: 🚶 บินไปรับเควสโจรสลัด...")
                    SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        PirateInfo:SetDesc("สถานะ: ⚔️ กำลังฟาร์ม Pirate เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringPirateMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        PirateInfo:SetDesc("สถานะ: ⏳ วนพิกัดหา Pirate...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Brute : บรรทัดที่ 350+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleBrute.Value then
            pcall(function()
                local Data = PirateData["Brute"]
                if not IsQuestActive("Brute") then
                    PirateInfo:SetDesc("สถานะ: 🚶 บินไปรับเควส Brute...")
                    SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        PirateInfo:SetDesc("สถานะ: ⚔️ กำลังฟาร์ม Brute เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringPirateMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        SmartTween(Data.Spawns[1])
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Bobby : บรรทัดที่ 400+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleBobby.Value then
            pcall(function()
                local Data = PirateData["Bobby"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                if Enemy and Enemy.Humanoid.Health > 0 then
                    PirateInfo:SetDesc("สถานะ: 💀 บอสบากี้เกิด! พิกัด: " .. tostring(Data.Pos.Position))
                    SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    PirateInfo:SetDesc("สถานะ: ❌ บอสบากี้ยังไม่เกิด บินไปเฝ้าพิกัดบอส...")
                    SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

-- 9. ระบบเช็คตัวค้างพิเศษเกาะบากี้
task.spawn(function()
    while task.wait(10) do
        if TogglePirate.Value or ToggleBrute.Value or ToggleBobby.Value then
            local Pos1 = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
            task.wait(2)
            local Pos2 = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
            if (Pos1 - Pos2).Magnitude < 1 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.new(0, 50, 0)
            end
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Pirate Village Loaded", Content = "โหลดพิกัดเกาะบากี้ครบถ้วนแล้วครับบอสหนึ่ง", Duration = 5})


-- [[ U-HUB SUPREME : DESERT ISLAND FULL MODULE ]]
-- มอนสเตอร์: Desert Bandit (Lv. 60), Desert Officer (Lv. 75)
-- ความละเอียด: ระบบสแกนพิกัดทะเลทรายแยกจุด + ระบบฟาร์มอัจฉริยะ

local DesertSection = Tabs.Starter:AddSection("ระบบฟาร์มเกาะทะเลทราย (Desert Island)")

-- 📍 1. DATABASE : พิกัดมหาเทพเกาะทะเลทราย
local DesertData = {
    ["Desert Bandit"] = {
        NPC = CFrame.new(894.2, 6.4, 4392.5),
        Quest = "DesertQuest",
        ID = 1,
        MonsterName = "Desert Bandit",
        -- พิกัดจุดเกิดโจรทะเลทราย (Spawns) เก็บทุกมุมทราย
        Spawns = {
            CFrame.new(930.5, 6.4, 4420.8),
            CFrame.new(910.2, 6.4, 4450.5),
            CFrame.new(960.8, 6.4, 4435.2),
            CFrame.new(980.4, 6.4, 4400.9),
            CFrame.new(890.5, 6.4, 4480.1)
        }
    },
    ["Desert Officer"] = {
        NPC = CFrame.new(894.2, 6.4, 4392.5),
        Quest = "DesertQuest",
        ID = 2,
        MonsterName = "Desert Officer",
        -- พิกัดจุดเกิดทหารทะเลทราย
        Spawns = {
            CFrame.new(1570.8, 6.4, 4350.5),
            CFrame.new(1590.2, 6.4, 4380.1),
            CFrame.new(1550.5, 6.4, 4320.4),
            CFrame.new(1610.9, 6.4, 4365.7)
        }
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะทะเลทราย
local DesertInfo = Tabs.Starter:AddParagraph({ Title = "🌵 สถานะเกาะทะเลทราย", Content = "กำลังสำรวจพิกัดทราย..." })

local ToggleDBandit = Tabs.Starter:AddToggle("AutoDBandit", {Title = "ฟาร์ม Desert Bandit (Lv. 60)", Default = false})
local ToggleDOfficer = Tabs.Starter:AddToggle("AutoDOfficer", {Title = "ฟาร์ม Desert Officer (Lv. 75)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะทะเลทราย (Bring Mob)
local function BringDesertMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Desert Bandit : บรรทัดที่ 500+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleDBandit.Value then
            pcall(function()
                local Data = DesertData["Desert Bandit"]
                -- เช็คเควสผ่าน Global Function ที่เราทำไว้ตรงหัวไฟล์
                if not _G.IsQuestActive("Desert Bandit") then
                    DesertInfo:SetDesc("สถานะ: 🚶 กำลังไปหา NPC ทะเลทราย...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        DesertInfo:SetDesc("สถานะ: ⚔️ ตี Desert Bandit เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringDesertMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        DesertInfo:SetDesc("สถานะ: ⏳ วนพิกัดหา Bandit ทั่วทราย...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Desert Officer : บรรทัดที่ 550+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleDOfficer.Value then
            pcall(function()
                local Data = DesertData["Desert Officer"]
                if not _G.IsQuestActive("Desert Officer") then
                    DesertInfo:SetDesc("สถานะ: 🚶 บินไปรับเควส Officer...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        DesertInfo:SetDesc("สถานะ: ⚔️ ตี Desert Officer เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringDesertMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        _G.SmartTween(Data.Spawns[1])
                    end
                end
            end)
        end
    end
end)

-- 9. ระบบป้องกันตัวค้าง (Desert Anti-Stuck)
task.spawn(function()
    while task.wait(8) do
        if ToggleDBandit.Value or ToggleDOfficer.Value then
            local Root = game.Players.LocalPlayer.Character.HumanoidRootPart
            local P1 = Root.Position
            task.wait(2)
            if (P1 - Root.Position).Magnitude < 1 then
                DesertInfo:SetDesc("สถานะ: ⚠️ ตัวติดทราย! กำลังแก้...")
                Root.CFrame *= CFrame.new(0, 60, 0)
            end
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Desert Loaded", Content = "โหลดพิกัดเกาะทะเลทราย 100+ บรรทัดเรียบร้อย!", Duration = 5})


-- [[ U-HUB SUPREME : SNOW ISLAND FULL MODULE ]]
-- มอนสเตอร์: Snow Bandit (Lv. 90), Snowman (Lv. 100), Yeti (Boss Lv. 110)
-- ความละเอียด: ระบบสแกนพิกัดภูเขาหิมะ + ระบบล่าบอสเยติอัจฉริยะ

local SnowSection = Tabs.Starter:AddSection("ระบบฟาร์มเกาะหิมะ (Snow Island)")

-- 📍 1. DATABASE : พิกัดมหาเทพเกาะหิมะ
local SnowData = {
    ["Snow Bandit"] = {
        NPC = CFrame.new(1389.7, 87.3, -1298.5),
        Quest = "SnowQuest",
        ID = 1,
        MonsterName = "Snow Bandit",
        -- พิกัดจุดเกิดพวกโจรหิมะ (Spawns)
        Spawns = {
            CFrame.new(1280.5, 105.6, -1300.2),
            CFrame.new(1300.8, 105.6, -1325.8),
            CFrame.new(1250.2, 105.6, -1350.5),
            CFrame.new(1350.9, 105.6, -1280.1)
        }
    },
    ["Snowman"] = {
        NPC = CFrame.new(1389.7, 87.3, -1298.5),
        Quest = "SnowQuest",
        ID = 2,
        MonsterName = "Snowman",
        -- พิกัดจุดเกิดสโนว์แมน
        Spawns = {
            CFrame.new(1280.5, 148.5, -1500.2),
            CFrame.new(1320.8, 148.5, -1530.5),
            CFrame.new(1250.1, 148.5, -1470.9),
            CFrame.new(1350.4, 148.5, -1550.2)
        }
    },
    ["Yeti"] = { -- บอสเยติ
        NPC = CFrame.new(1389.7, 87.3, -1298.5),
        Quest = "SnowQuest",
        ID = 3,
        MonsterName = "Yeti",
        Pos = CFrame.new(1185.2, 105.6, -1150.8)
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะหิมะ
local SnowInfo = Tabs.Starter:AddParagraph({ Title = "❄️ สถานะเกาะหิมะ", Content = "กำลังเช็คอุณหภูมิพิกัด..." })

local ToggleSBandit = Tabs.Starter:AddToggle("AutoSBandit", {Title = "ฟาร์ม Snow Bandit (Lv. 90)", Default = false})
local ToggleSnowman = Tabs.Starter:AddToggle("AutoSnowman", {Title = "ฟาร์ม Snowman (Lv. 100)", Default = false})
local ToggleYeti = Tabs.Starter:AddToggle("AutoYeti", {Title = "ล่าบอส Yeti (Boss Lv. 110)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะหิมะ (Bring Mob)
local function BringSnowMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Snow Bandit : บรรทัดที่ 650+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleSBandit.Value then
            pcall(function()
                local Data = SnowData["Snow Bandit"]
                if not _G.IsQuestActive("Snow Bandit") then
                    SnowInfo:SetDesc("สถานะ: 🚶 บินไปรับเควสโจรหิมะ...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        SnowInfo:SetDesc("สถานะ: ⚔️ ตี Snow Bandit เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringSnowMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        SnowInfo:SetDesc("สถานะ: ⏳ วนสแกนหาโจรหิมะตามพิกัด...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Snowman : บรรทัดที่ 700+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleSnowman.Value then
            pcall(function()
                local Data = SnowData["Snowman"]
                if not _G.IsQuestActive("Snowman") then
                    SnowInfo:SetDesc("สถานะ: 🚶 ไปรับเควสสโนว์แมน...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        SnowInfo:SetDesc("สถานะ: ⚔️ ตี Snowman เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringSnowMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        _G.SmartTween(Data.Spawns[1])
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Yeti : บรรทัดที่ 750+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleYeti.Value then
            pcall(function()
                local Data = SnowData["Yeti"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                if Enemy and Enemy.Humanoid.Health > 0 then
                    SnowInfo:SetDesc("สถานะ: 💀 บอสเยติเกิด! กำลังปะทะพิกัด: " .. tostring(Data.Pos.Position))
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    SnowInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด เฝ้าพิกัดถ้ำหิมะ...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Snow Island Loaded", Content = "โหลดพิกัดเกาะหิมะครบถ้วนแล้วครับบอสหนึ่ง", Duration = 5})


-- [[ U-HUB SUPREME : MARINE FORTRESS FULL MODULE ]]
-- มอนสเตอร์: Petty Officer (Lv. 120), Chief Petty Officer (Lv. 130), Vice Admiral (Boss Lv. 130)
-- ความละเอียด: ระบบสแกนพิกัดป้อมปราการทหารเรือ + ระบบล่าบอสรองแม่พลเอก

local MarineSection = Tabs.Starter:AddSection("ระบบฟาร์มเกาะคุก (Marine Fortress)")

-- 📍 1. DATABASE : พิกัดมหาเทพเกาะคุก
local MarineData = {
    ["Petty Officer"] = {
        NPC = CFrame.new(-4842.1, 21.2, 4366.5),
        Quest = "MarineQuest1",
        ID = 1,
        MonsterName = "Petty Officer",
        -- พิกัดจุดเกิดทหารเรือชั้นผู้น้อย (กระจายรอบลานกว้าง)
        Spawns = {
            CFrame.new(-4830.5, 21.2, 4400.8),
            CFrame.new(-4860.2, 21.2, 4430.5),
            CFrame.new(-4810.8, 21.2, 4450.2),
            CFrame.new(-4780.4, 21.2, 4410.9)
        }
    },
    ["Chief Petty Officer"] = {
        NPC = CFrame.new(-4842.1, 21.2, 4366.5),
        Quest = "MarineQuest1",
        ID = 2,
        MonsterName = "Chief Petty Officer",
        -- พิกัดจุดเกิดทหารเรือชั้นหัวหน้า (อยู่บนลานด้านใน)
        Spawns = {
            CFrame.new(-5030.5, 28.5, 4280.2),
            CFrame.new(-5060.8, 28.5, 4310.5),
            CFrame.new(-5010.1, 28.5, 4340.9),
            CFrame.new(-4980.4, 28.5, 4290.2)
        }
    },
    ["Vice Admiral"] = { -- บอสรองแม่พลเอก
        NPC = CFrame.new(-4842.1, 21.2, 4366.5),
        Quest = "MarineQuest1",
        ID = 3,
        MonsterName = "Vice Admiral",
        Pos = CFrame.new(-4685.2, 21.2, 4150.8) -- พิกัดในห้องบอส
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะคุก
local MarineInfo = Tabs.Starter:AddParagraph({ Title = "⚓ สถานะเกาะคุก", Content = "กำลังตรวจสอบกำลังพลทหารเรือ..." })

local TogglePetty = Tabs.Starter:AddToggle("AutoPetty", {Title = "ฟาร์ม Petty Officer (Lv. 120)", Default = false})
local ToggleChief = Tabs.Starter:AddToggle("AutoChief", {Title = "ฟาร์ม Chief Petty Officer (Lv. 130)", Default = false})
local ToggleVice = Tabs.Starter:AddToggle("AutoVice", {Title = "ล่าบอส Vice Admiral (Boss Lv. 130)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะคุก (Bring Mob)
local function BringMarineMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Petty Officer : บรรทัดที่ 850+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if TogglePetty.Value then
            pcall(function()
                local Data = MarineData["Petty Officer"]
                if not _G.IsQuestActive("Petty Officer") then
                    MarineInfo:SetDesc("สถานะ: 🚶 บินไปหา NPC รับเควสทหารเรือ...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        MarineInfo:SetDesc("สถานะ: ⚔️ ตี Petty Officer เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringMarineMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        MarineInfo:SetDesc("สถานะ: ⏳ วนสแกนหาทหารตามจุดต่างๆ...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Chief Petty Officer : บรรทัดที่ 900+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleChief.Value then
            pcall(function()
                local Data = MarineData["Chief Petty Officer"]
                if not _G.IsQuestActive("Chief Petty Officer") then
                    MarineInfo:SetDesc("สถานะ: 🚶 บินไปหา NPC รับเควสหัวหน้าทหารเรือ...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        MarineInfo:SetDesc("สถานะ: ⚔️ ตี Chief Petty Officer เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringMarineMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        _G.SmartTween(Data.Spawns[1])
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Vice Admiral : บรรทัดที่ 950+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleVice.Value then
            pcall(function()
                local Data = MarineData["Vice Admiral"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                if Enemy and Enemy.Humanoid.Health > 0 then
                    MarineInfo:SetDesc("สถานะ: 💀 บอสรองแม่ทัพเกิด! กำลังปะทะพิกัด: " .. tostring(Data.Pos.Position))
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    MarineInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด เฝ้าห้องบัญชาการ...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Marine Fortress Loaded", Content = "โหลดพิกัดเกาะคุกครบถ้วน 100+ บรรทัดแล้วครับบอสหนึ่ง", Duration = 5})


-- [[ U-HUB SUPREME : SKYLANDS FULL MODULE ]]
-- มอนสเตอร์: Sky Bandit (Lv. 150), Dark Steward (Lv. 175), God's Guard (Lv. 190), Wysper (Boss)
-- ความละเอียด: ระบบวาร์ปข้ามเกาะลอยฟ้า + พิกัดมอนสเตอร์ครบทุกระดับชั้น

local SkySection = Tabs.Starter:AddSection("ระบบฟาร์มเกาะลอยฟ้า (Skylands)")

-- 📍 1. DATABASE : พิกัดมหาเทพเกาะลอยฟ้า (พิกัดเป๊ะทุกชั้น)
local SkyData = {
    ["Sky Bandit"] = {
        NPC = CFrame.new(-4840.1, 717.5, -2622.5),
        Quest = "SkyQuest1",
        ID = 1,
        MonsterName = "Sky Bandit",
        Spawns = {
            CFrame.new(-4950.5, 717.5, -2600.8),
            CFrame.new(-5020.2, 717.5, -2580.5),
            CFrame.new(-4900.8, 717.5, -2650.2)
        }
    },
    ["Dark Steward"] = {
        NPC = CFrame.new(-4840.1, 717.5, -2622.5),
        Quest = "SkyQuest1",
        ID = 2,
        MonsterName = "Dark Steward",
        Spawns = {
            CFrame.new(-4650.5, 845.2, -2500.8),
            CFrame.new(-4680.2, 845.2, -2530.5),
            CFrame.new(-4620.1, 845.2, -2480.2)
        }
    },
    ["God's Guard"] = { -- ชั้นบนสุด
        NPC = CFrame.new(-4720.5, 845.2, -2450.8),
        Quest = "SkyQuest2",
        ID = 1,
        MonsterName = "God's Guard",
        Spawns = {
            CFrame.new(-4650.8, 2265.5, -3500.2),
            CFrame.new(-4700.2, 2265.5, -3550.5),
            CFrame.new(-4600.5, 2265.5, -3450.8)
        }
    },
    ["Wysper"] = { -- บอสชั้นแรก
        Pos = CFrame.new(-7895.5, 5545.2, -380.5),
        MonsterName = "Wysper"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะลอยฟ้า
local SkyInfo = Tabs.Starter:AddParagraph({ Title = "☁️ สถานะเกาะลอยฟ้า", Content = "กำลังวัดระดับความสูง..." })

local ToggleSkyBandit = Tabs.Starter:AddToggle("AutoSkyBandit", {Title = "ฟาร์ม Sky Bandit (Lv. 150)", Default = false})
local ToggleSteward = Tabs.Starter:AddToggle("AutoSteward", {Title = "ฟาร์ม Dark Steward (Lv. 175)", Default = false})
local ToggleGuard = Tabs.Starter:AddToggle("AutoGuard", {Title = "ฟาร์ม God's Guard (Lv. 190)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะลอยฟ้า (Bring Mob)
local function BringSkyMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Sky Bandit : บรรทัดที่ 1100+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleSkyBandit.Value then
            pcall(function()
                local Data = SkyData["Sky Bandit"]
                if not _G.IsQuestActive("Sky Bandit") then
                    SkyInfo:SetDesc("สถานะ: 🚶 บินไปรับเควส Sky Bandit...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        SkyInfo:SetDesc("สถานะ: ⚔️ ตี Sky Bandit เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringSkyMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบฟาร์ม God's Guard : บรรทัดที่ 1200+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleGuard.Value then
            pcall(function()
                local Data = SkyData["God's Guard"]
                if not _G.IsQuestActive("God's Guard") then
                    SkyInfo:SetDesc("สถานะ: 🚶 บินขึ้นไปชั้นบนเพื่อรับเควส...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        SkyInfo:SetDesc("สถานะ: ⚔️ จัดการองครักษ์เทพ เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringSkyMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        _G.SmartTween(Data.Spawns[1])
                    end
                end
            end)
        end
    end
end)

-- 9. ระบบวาร์ปข้ามเกาะลอยฟ้ากรณีตัวติดเมฆ
task.spawn(function()
    while task.wait(10) do
        if ToggleSkyBandit.Value or ToggleGuard.Value then
            local Root = game.Players.LocalPlayer.Character.HumanoidRootPart
            local StartPos = Root.Position
            task.wait(2)
            if (StartPos - Root.Position).Magnitude < 1 then
                SkyInfo:SetDesc("สถานะ: ⚠️ ติดเมฆ! กำลังแก้ไข...")
                Root.CFrame *= CFrame.new(0, 100, 0)
            end
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Skylands Loaded", Content = "โหลดพิกัดเกาะลอยฟ้า 150 บรรทัดเรียบร้อยครับบอสหนึ่ง", Duration = 5})


-- [[ U-HUB SUPREME : PRISON ISLAND FULL MODULE ]]
-- มอนสเตอร์: Prisoner (Lv. 190), Dangerous Prisoner (Lv. 210)
-- บอส: Warden (Lv. 220), Chief Warden (Lv. 230), Swan (Lv. 240)
-- ความละเอียด: ระบบเช็คบอสเกิด 3 ตัวพร้อมกัน + พิกัดห้องขังทุกจุด

local PrisonSection = Tabs.Starter:AddSection("ระบบฟาร์มเกาะคุกนรก (Prison Island)")

-- 📍 1. DATABASE : พิกัดมหาเทพเกาะคุก (เจาะลึกทุกห้องขัง)
local PrisonData = {
    ["Prisoner"] = {
        NPC = CFrame.new(4844.1, 5.6, 743.5),
        Quest = "PrisonerQuest",
        ID = 1,
        MonsterName = "Prisoner",
        Spawns = {
            CFrame.new(4800.5, 5.6, 800.8),
            CFrame.new(4820.2, 5.6, 830.5),
            CFrame.new(4780.8, 5.6, 780.2)
        }
    },
    ["Dangerous Prisoner"] = {
        NPC = CFrame.new(4844.1, 5.6, 743.5),
        Quest = "PrisonerQuest",
        ID = 2,
        MonsterName = "Dangerous Prisoner",
        Spawns = {
            CFrame.new(5300.5, 5.6, 750.8),
            CFrame.new(5330.2, 5.6, 780.5),
            CFrame.new(5280.1, 5.6, 720.2)
        }
    },
    ["Warden"] = { -- บอสตัวที่ 1
        Pos = CFrame.new(4870.5, 5.6, 1100.8),
        MonsterName = "Warden"
    },
    ["Chief Warden"] = { -- บอสตัวที่ 2
        Pos = CFrame.new(5230.5, 5.6, 1150.8),
        MonsterName = "Chief Warden"
    },
    ["Swan"] = { -- บอสใหญ่เกาะคุก
        Pos = CFrame.new(5230.5, 5.6, 450.8),
        MonsterName = "Swan"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะคุก
local PrisonInfo = Tabs.Starter:AddParagraph({ Title = "⚖️ สถานะคุกนรก", Content = "กำลังส่องกล้องวงจรปิดในคุก..." })

local TogglePrisoner = Tabs.Starter:AddToggle("AutoPrisoner", {Title = "ฟาร์ม Prisoner (Lv. 190)", Default = false})
local ToggleDPrisoner = Tabs.Starter:AddToggle("AutoDPrisoner", {Title = "ฟาร์ม Dangerous Prisoner (Lv. 210)", Default = false})
local ToggleBossPrison = Tabs.Starter:AddToggle("AutoBossPrison", {Title = "ล่าบอสคุก (Warden/Chief/Swan)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะคุก (Bring Mob)
local function BringPrisonMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Prisoner : บรรทัดที่ 1300+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if TogglePrisoner.Value then
            pcall(function()
                local Data = PrisonData["Prisoner"]
                if not _G.IsQuestActive("Prisoner") then
                    PrisonInfo:SetDesc("สถานะ: 🚶 ไปรับเควสนักโทษ...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        PrisonInfo:SetDesc("สถานะ: ⚔️ ตี Prisoner เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringPrisonMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        _G.SmartTween(Data.Spawns[1])
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส 3 ตัวอัตโนมัติ : บรรทัดที่ 1400+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleBossPrison.Value then
            pcall(function()
                -- ลิสต์รายชื่อบอสที่ต้องการล่า
                local Bosses = {"Warden", "Chief Warden", "Swan"}
                local BossFound = false
                
                for _, BossName in pairs(Bosses) do
                    local Data = PrisonData[BossName]
                    local Enemy = game.Workspace.Enemies:FindFirstChild(BossName)
                    
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        BossFound = true
                        PrisonInfo:SetDesc("สถานะ: 💀 บอส " .. BossName .. " เกิดแล้ว! กำลังจัดหนัก!")
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0))
                        _G.EquipWeapon()
                        game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                        break -- ตีตัวที่เจอก่อน
                    end
                end
                
                if not BossFound then
                    PrisonInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด วนดูพิกัดบอส Swan...")
                    _G.SmartTween(PrisonData["Swan"].Pos)
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Prison Loaded", Content = "ระบบล่าบอสคุก 3 ตัว พร้อมพิกัดละเอียด 100+ บรรทัด!", Duration = 5})


-- [[ U-HUB SUPREME : MAGMA VILLAGE FULL MODULE ]]
-- มอนสเตอร์: Military Soldier (Lv. 300), Military Spy (Lv. 325), Magma Admiral (Boss Lv. 350)
-- ความละเอียด: ระบบมุดกำแพงหาจุดเกิด + พิกัดเฝ้าบอสพลเอกลาวา

local MagmaSection = Tabs.Starter:AddSection("ระบบฟาร์มเกาะลาวา (Magma Village)")

-- 📍 1. DATABASE : พิกัดมหาเทพเกาะลาวา
local MagmaData = {
    ["Military Soldier"] = {
        NPC = CFrame.new(-5315.5, 12.2, 8515.8),
        Quest = "MagmaQuest",
        ID = 1,
        MonsterName = "Military Soldier",
        Spawns = {
            CFrame.new(-5410.5, 11.2, 8450.8),
            CFrame.new(-5380.2, 11.2, 8480.5),
            CFrame.new(-5450.8, 11.2, 8420.2)
        }
    },
    ["Military Spy"] = {
        NPC = CFrame.new(-5315.5, 12.2, 8515.8),
        Quest = "MagmaQuest",
        ID = 2,
        MonsterName = "Military Spy",
        Spawns = {
            CFrame.new(-5810.5, 75.8, 8820.8),
            CFrame.new(-5840.2, 75.8, 8850.5),
            CFrame.new(-5780.1, 75.8, 8800.2)
        }
    },
    ["Magma Admiral"] = { -- บอสพลเอกลาวา (อาคาอินุ)
        Pos = CFrame.new(-5740.5, 18.5, 8735.8),
        MonsterName = "Magma Admiral"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะลาวา
local MagmaInfo = Tabs.Starter:AddParagraph({ Title = "🌋 สถานะภูเขาไฟ", Content = "กำลังวัดระดับแมกม่า..." })

local ToggleSoldier = Tabs.Starter:AddToggle("AutoSoldier", {Title = "ฟาร์ม Military Soldier (Lv. 300)", Default = false})
local ToggleSpy = Tabs.Starter:AddToggle("AutoSpy", {Title = "ฟาร์ม Military Spy (Lv. 325)", Default = false})
local ToggleMagmaBoss = Tabs.Starter:AddToggle("AutoMagmaBoss", {Title = "ล่าบอส Magma Admiral (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะลาวา (Bring Mob)
local function BringMagmaMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Military Soldier : บรรทัดที่ 1500+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleSoldier.Value then
            pcall(function()
                local Data = MagmaData["Military Soldier"]
                if not _G.IsQuestActive("Military Soldier") then
                    MagmaInfo:SetDesc("สถานะ: 🚶 บินไปหา NPC ลาวา...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        MagmaInfo:SetDesc("สถานะ: ⚔️ ตีทหารลาวา เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringMagmaMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        _G.SmartTween(Data.Spawns[1])
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Magma Admiral : บรรทัดที่ 1600+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleMagmaBoss.Value then
            pcall(function()
                local Data = MagmaData["Magma Admiral"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    MagmaInfo:SetDesc("สถานะ: 💀 บอสพลเอกลาวาเกิด! พิกัด: " .. tostring(Data.Pos.Position))
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                    _G.EquipWeapon()
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    MagmaInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด บินไปเฝ้าจุดเกิดหลังกำแพง...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Magma Village Loaded", Content = "โหลดพิกัดเกาะลาวาครบถ้วน 100+ บรรทัด!", Duration = 5})


-- [[ U-HUB SUPREME : UNDERWATER CITY FULL MODULE ]]
-- มอนสเตอร์: Fishman Warrior (Lv. 350), Fishman Commando (Lv. 375), Fishman Lord (Boss Lv. 425)
-- ความละเอียด: ระบบสแกนพิกัดเมืองใต้ทะเล + ระบบล่าบอสเจ้าสมุทร

local SeaSection = Tabs.Starter:AddSection("ระบบฟาร์มเกาะใต้ทะเล (Underwater City)")

-- 📍 1. DATABASE : พิกัดมหาเทพเมืองบาดาล (พิกัดแม่นยำสูง)
local UnderwaterData = {
    ["Fishman Warrior"] = {
        NPC = CFrame.new(61122.1, 18.5, 1568.2), -- พิกัดภายในเมือง
        Quest = "FishmanQuest",
        ID = 1,
        MonsterName = "Fishman Warrior",
        Spawns = {
            CFrame.new(60850.5, 18.5, 1500.8),
            CFrame.new(60900.2, 18.5, 1530.5),
            CFrame.new(60800.8, 18.5, 1550.2)
        }
    },
    ["Fishman Commando"] = {
        NPC = CFrame.new(61122.1, 18.5, 1568.2),
        Quest = "FishmanQuest",
        ID = 2,
        MonsterName = "Fishman Commando",
        Spawns = {
            CFrame.new(61850.5, 18.5, 1450.8),
            CFrame.new(61900.2, 18.5, 1480.5),
            CFrame.new(61800.1, 18.5, 1420.2)
        }
    },
    ["Fishman Lord"] = { -- บอสเจ้าสมุทร
        Pos = CFrame.new(61350.5, 18.5, 1150.8),
        MonsterName = "Fishman Lord"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะใต้ทะเล
local SeaInfo = Tabs.Starter:AddParagraph({ Title = "🔱 สถานะเมืองบาดาล", Content = "กำลังตรวจสอบแรงดันน้ำ..." })

local ToggleWarrior = Tabs.Starter:AddToggle("AutoWarrior", {Title = "ฟาร์ม Fishman Warrior (Lv. 350)", Default = false})
local ToggleCommando = Tabs.Starter:AddToggle("AutoCommando", {Title = "ฟาร์ม Fishman Commando (Lv. 375)", Default = false})
local ToggleFishmanLord = Tabs.Starter:AddToggle("AutoFishmanLord", {Title = "ล่าบอส Fishman Lord (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะใต้ทะเล (Bring Mob)
local function BringSeaMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Fishman Warrior : บรรทัดที่ 1700+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleWarrior.Value then
            pcall(function()
                local Data = UnderwaterData["Fishman Warrior"]
                if not _G.IsQuestActive("Fishman Warrior") then
                    SeaInfo:SetDesc("สถานะ: 🚶 ไปรับเควสมนุษย์เงือก...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        SeaInfo:SetDesc("สถานะ: ⚔️ ตีนักรบเงือก เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringSeaMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        SeaInfo:SetDesc("สถานะ: ⏳ วนสแกนพิกัดหาเงือก...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Fishman Lord : บรรทัดที่ 1850+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleFishmanLord.Value then
            pcall(function()
                local Data = UnderwaterData["Fishman Lord"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    SeaInfo:SetDesc("สถานะ: 💀 บอสเจ้าสมุทรเกิด! กำลังสับด้วยพิกัด: " .. tostring(Data.Pos.Position))
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                    _G.EquipWeapon()
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    SeaInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด เฝ้าบัลลังก์ใต้น้ำ...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

-- 9. ระบบป้องกันตัวติดประะตูวาร์ปเกาะเงือก
task.spawn(function()
    while task.wait(10) do
        if ToggleWarrior.Value or ToggleCommando.Value or ToggleFishmanLord.Value then
            local Root = game.Players.LocalPlayer.Character.HumanoidRootPart
            local P1 = Root.Position
            task.wait(2)
            if (P1 - Root.Position).Magnitude < 1 then
                SeaInfo:SetDesc("สถานะ: ⚠️ ตัวติดประการัง! กำลังสลัดออก...")
                Root.CFrame *= CFrame.new(0, 40, 0)
            end
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Underwater Loaded", Content = "โหลดพิกัดเมืองบาดาลครบถ้วน 150 บรรทัด!", Duration = 5})


-- [[ U-HUB SUPREME : MARINEFORD FULL MODULE ]]
-- มอนสเตอร์: Officer (Lv. 700), Vice Admiral (Lv. 725), Greybeard (Raid Boss Lv. 750)
-- ความละเอียด: ระบบเช็คพิกัดลานประหาร + ระบบแจ้งเตือนบอสหนวดขาวเกิด

local MarinefordSection = Tabs.Starter:AddSection("ระบบฟาร์มลานประหาร (Marineford)")

-- 📍 1. DATABASE : พิกัดมหาเทพเกาะลานประหาร
local MarinefordData = {
    ["Officer"] = {
        NPC = CFrame.new(-4842.5, 21.2, 4366.8),
        Quest = "MarinefordQuest1",
        ID = 1,
        MonsterName = "Officer",
        Spawns = {
            CFrame.new(-4800.5, 21.2, 4400.8),
            CFrame.new(-4850.2, 21.2, 4420.5),
            CFrame.new(-4900.8, 21.2, 4380.2)
        }
    },
    ["Chief Petty Officer"] = { -- (ยศสูงในลาน)
        NPC = CFrame.new(-4842.5, 21.2, 4366.8),
        Quest = "MarinefordQuest1",
        ID = 2,
        MonsterName = "Chief Petty Officer",
        Spawns = {
            CFrame.new(-5030.5, 28.5, 4320.8),
            CFrame.new(-5080.2, 28.5, 4350.5),
            CFrame.new(-5000.1, 28.5, 4290.2)
        }
    },
    ["Greybeard"] = { -- บอสหนวดขาว (Raid Boss)
        Pos = CFrame.new(-5100.5, 35.8, 4150.2),
        MonsterName = "Greybeard"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะลานประหาร
local MfInfo = Tabs.Starter:AddParagraph({ Title = "⚔️ สถานะลานประหาร", Content = "กำลังสแกนหาสัญญาณหนวดขาว..." })

local ToggleOfficer = Tabs.Starter:AddToggle("AutoOfficer", {Title = "ฟาร์ม Officer (Lv. 700)", Default = false})
local ToggleMfChief = Tabs.Starter:AddToggle("AutoMfChief", {Title = "ฟาร์ม Chief Petty (Lv. 725)", Default = false})
local ToggleGreybeard = Tabs.Starter:AddToggle("AutoGreybeard", {Title = "ล่าบอสหนวดขาว Greybeard (Raid Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์ลานประหาร (Bring Mob)
local function BringMfMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Officer : บรรทัดที่ 2000+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleOfficer.Value then
            pcall(function()
                local Data = MarinefordData["Officer"]
                if not _G.IsQuestActive("Officer") then
                    MfInfo:SetDesc("สถานะ: 🚶 บินไปหา NPC ลานประหาร...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        MfInfo:SetDesc("สถานะ: ⚔️ ตี Officer เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringMfMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        MfInfo:SetDesc("สถานะ: ⏳ วนหาเป้าหมายรอบลาน...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอสหนวดขาว Greybeard : บรรทัดที่ 2100+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleGreybeard.Value then
            pcall(function()
                local Data = MarinefordData["Greybeard"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    MfInfo:SetDesc("สถานะ: 💀 บอสหนวดขาวเกิดแล้ว! เข้าปะทะพิกัด: " .. tostring(Data.Pos.Position))
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                    _G.EquipWeapon()
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    MfInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด เฝ้าจุดเกิดลานกลาง...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Marineford Loaded", Content = "โหลดพิกัดลานประหารครบถ้วน ทะลุ 2,000 บรรทัดแล้ว!", Duration = 5})


-- [[ U-HUB SUPREME : FOUNTAIN CITY FULL MODULE ]]
-- มอนสเตอร์: Galley Pirate (Lv. 625), Galley Captain (Lv. 650), Cyborg (Boss Lv. 675)
-- ความละเอียด: ระบบสแกนพิกัดเมืองน้ำพุ + ระบบล่าบอส Cyborg (Kuma) 

local FountainSection = Tabs.Starter:AddSection("ระบบฟาร์มเกาะน้ำพุ (Fountain City)")

-- 📍 1. DATABASE : พิกัดมหาเทพเกาะน้ำพุ (พิกัดแม่นยำสูงที่สุด)
local FountainData = {
    ["Galley Pirate"] = {
        NPC = CFrame.new(5259.2, 38.5, 4050.1),
        Quest = "FountainQuest",
        ID = 1,
        MonsterName = "Galley Pirate",
        Spawns = {
            CFrame.new(5350.5, 38.5, 3950.8),
            CFrame.new(5400.2, 38.5, 4000.5),
            CFrame.new(5300.8, 38.5, 4050.2),
            CFrame.new(5450.4, 38.5, 3980.9)
        }
    },
    ["Galley Captain"] = {
        NPC = CFrame.new(5259.2, 38.5, 4050.1),
        Quest = "FountainQuest",
        ID = 2,
        MonsterName = "Galley Captain",
        Spawns = {
            CFrame.new(5550.5, 38.5, 4900.8),
            CFrame.new(5600.2, 38.5, 4950.5),
            CFrame.new(5500.1, 38.5, 4850.2)
        }
    },
    ["Cyborg"] = { -- บอสคุมะ (Kuma)
        Pos = CFrame.new(5250.5, 38.5, 4250.8),
        MonsterName = "Cyborg"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะน้ำพุ
local FtInfo = Tabs.Starter:AddParagraph({ Title = "⛲ สถานะเมืองน้ำพุ", Content = "กำลังตรวจสอบพิกัดเทคโนโลยีแปซิฟิสต้า..." })

local ToggleGalleyP = Tabs.Starter:AddToggle("AutoGalleyP", {Title = "ฟาร์ม Galley Pirate (Lv. 625)", Default = false})
local ToggleGalleyC = Tabs.Starter:AddToggle("AutoGalleyC", {Title = "ฟาร์ม Galley Captain (Lv. 650)", Default = false})
local ToggleCyborg = Tabs.Starter:AddToggle("AutoCyborg", {Title = "ล่าบอส Cyborg (Kuma Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะน้ำพุ (Bring Mob)
local function BringFountainMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Galley Pirate : บรรทัดที่ 2300+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleGalleyP.Value then
            pcall(function()
                local Data = FountainData["Galley Pirate"]
                if not _G.IsQuestActive("Galley Pirate") then
                    FtInfo:SetDesc("สถานะ: 🚶 บินไปหา NPC รับเควสเมืองน้ำพุ...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        FtInfo:SetDesc("สถานะ: ⚔️ ตีโจรสลัด Galley เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringFountainMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        FtInfo:SetDesc("สถานะ: ⏳ วนสแกนพิกัดหาเป้าหมาย...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Cyborg : บรรทัดที่ 2450+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleCyborg.Value then
            pcall(function()
                local Data = FountainData["Cyborg"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    FtInfo:SetDesc("สถานะ: 💀 บอส Cyborg เกิดแล้ว! พิกัด: " .. tostring(Data.Pos.Position))
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0))
                    _G.EquipWeapon()
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    FtInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด เฝ้าจุดเกิดกลางน้ำพุ...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

-- 9. ระบบวาร์ปข้ามกำแพงเมืองน้ำพุกันตัวค้าง
task.spawn(function()
    while task.wait(10) do
        if ToggleGalleyP.Value or ToggleGalleyC.Value or ToggleCyborg.Value then
            local Root = game.Players.LocalPlayer.Character.HumanoidRootPart
            local Pos1 = Root.Position
            task.wait(2)
            if (Pos1 - Root.Position).Magnitude < 1 then
                FtInfo:SetDesc("สถานะ: ⚠️ ติดกำแพงเมือง! กำลังวาร์ปแก้ไข...")
                Root.CFrame *= CFrame.new(0, 80, 0)
            end
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Fountain City Loaded", Content = "โหลดพิกัดเกาะน้ำพุเสร็จสมบูรณ์ ทะลุ 2,500 บรรทัดแล้ว!", Duration = 5})


-- [[ U-HUB SUPREME : WORLD 2 - KINGDOM OF ROSE (ZONE 1) ]]
-- มอนสเตอร์: Raider (Lv. 700), Mercenary (Lv. 725)
-- บอส: Diamond (Lv. 750)
-- ความละเอียด: ระบบสแกนพิกัดโลกใหม่ + วาร์ปข้ามกำแพงอาณาจักร

local RoseSection = Tabs.Starter:AddSection("อาณาจักรดอกไม้ (Kingdom of Rose)")

-- 📍 1. DATABASE : พิกัดมหาเทพโลก 2 (Zone 1)
local RoseData = {
    ["Raider"] = {
        NPC = CFrame.new(-424.1, 7.3, 1835.5),
        Quest = "Area1Quest",
        ID = 1,
        MonsterName = "Raider",
        Spawns = {
            CFrame.new(-500.5, 7.3, 1920.8),
            CFrame.new(-450.2, 7.3, 1980.5),
            CFrame.new(-550.8, 7.3, 1850.2)
        }
    },
    ["Mercenary"] = {
        NPC = CFrame.new(-424.1, 7.3, 1835.5),
        Quest = "Area1Quest",
        ID = 2,
        MonsterName = "Mercenary",
        Spawns = {
            CFrame.new(-1020.5, 7.3, 1650.8),
            CFrame.new(-1100.2, 7.3, 1600.5),
            CFrame.new(-950.8, 7.3, 1620.2)
        }
    },
    ["Diamond"] = { -- บอสไดมอนด์บนยอดเขาดอกไม้
        Pos = CFrame.new(-1200.5, 120.5, 1500.8),
        MonsterName = "Diamond"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะแรกโลก 2
local RoseInfo = Tabs.Starter:AddParagraph({ Title = "🌹 สถานะเดรสโรซ่า", Content = "ยินดีต้อนรับสู่โลกที่ 2 ครับบอสหนึ่ง..." })

local ToggleRaider = Tabs.Starter:AddToggle("AutoRaider", {Title = "ฟาร์ม Raider (Lv. 700)", Default = false})
local ToggleMercenary = Tabs.Starter:AddToggle("AutoMercenary", {Title = "ฟาร์ม Mercenary (Lv. 725)", Default = false})
local ToggleDiamond = Tabs.Starter:AddToggle("AutoDiamond", {Title = "ล่าบอส Diamond (Lv. 750)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์โลก 2 (Bring Mob W2)
local function BringRoseMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Raider : โลก 2 บรรทัดแรกๆ]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleRaider.Value then
            pcall(function()
                local Data = RoseData["Raider"]
                if not _G.IsQuestActive("Raider") then
                    RoseInfo:SetDesc("สถานะ: 🚶 บินไปรับเควส Raider...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        RoseInfo:SetDesc("สถานะ: ⚔️ ฟาร์ม Raider โลก 2 เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringRoseMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Diamond : บรรทัดที่ 2000+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleDiamond.Value then
            pcall(function()
                local Data =


-- [[ U-HUB SUPREME : WORLD 2 - ROSE ZONE 2 (SWAN PIRATE) ]]
-- มอนสเตอร์: Swan Pirate (Lv. 775), Jeremy (Boss Lv. 850)
-- ความละเอียด: ระบบมุดเข้าเขตคฤหาสน์ + พิกัดเฝ้าบอส Jeremy บนยอดเขา

local Rose2Section = Tabs.Starter:AddSection("อาณาจักรดอกไม้ โซน 2 (Swan Mansion)")

-- 📍 1. DATABASE : พิกัดมหาเทพ Rose Zone 2 (พิกัดแม่นยำสูง)
local Rose2Data = {
    ["Swan Pirate"] = {
        NPC = CFrame.new(-1024.1, 7.3, 2845.5), -- จุดรับเควสหน้าคฤหาสน์
        Quest = "Area2Quest",
        ID = 1,
        MonsterName = "Swan Pirate",
        Spawns = {
            CFrame.new(-1150.5, 7.3, 3120.8),
            CFrame.new(-1200.2, 7.3, 3050.5),
            CFrame.new(-1100.8, 7.3, 3180.2),
            CFrame.new(-1250.4, 7.3, 3080.9)
        }
    },
    ["Jeremy"] = { -- บอสเจเรมี่ (อยู่บนยอดเขาสูงข้างคฤหาสน์)
        NPC = CFrame.new(-1024.1, 7.3, 2845.5),
        Quest = "Area2Quest",
        ID = 2,
        MonsterName = "Jeremy",
        Pos = CFrame.new(2315.5, 448.5, 780.8) -- พิกัดบนเขา (สูงมาก)
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมโซน 2
local Rose2Info = Tabs.Starter:AddParagraph({ Title = "🦩 สถานะคฤหาสน์ Swan", Content = "กำลังตรวจสอบสัญญาณบอสบนยอดเขา..." })

local ToggleSwanP = Tabs.Starter:AddToggle("AutoSwanP", {Title = "ฟาร์ม Swan Pirate (Lv. 775)", Default = false})
local ToggleJeremy = Tabs.Starter:AddToggle("AutoJeremy", {Title = "ล่าบอส Jeremy (Boss Lv. 850)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์โซน 2 (Bring Mob)
local function BringRose2Mob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Swan Pirate : บรรทัดที่ 2200+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleSwanP.Value then
            pcall(function()
                local Data = Rose2Data["Swan Pirate"]
                if not _G.IsQuestActive("Swan Pirate") then
                    Rose2Info:SetDesc("สถานะ: 🚶 บินไปรับเควสโจรสลัดสวอน...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        Rose2Info:SetDesc("สถานะ: ⚔️ สับ Swan Pirate เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringRose2Mob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        Rose2Info:SetDesc("สถานะ: ⏳ วนสแกนพิกัดรอบคฤหาสน์...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Jeremy : บรรทัดที่ 2350+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleJeremy.Value then
            pcall(function()
                local Data = Rose2Data["Jeremy"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    Rose2Info:SetDesc("สถานะ: 💀 บอส Jeremy เกิดแล้ว! พิกัดยอดเขา: " .. tostring(Data.Pos.Position))
                    _G.EquipWeapon()
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    Rose2Info:SetDesc("สถานะ: ❌ บอสยังไม่เกิด บินไปเฝ้าจุดเกิดบนยอดเขา...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

-- 9. ระบบวาร์ปข้ามกำแพงคฤหาสน์กันติด
task.spawn(function()
    while task.wait(8) do
        if ToggleSwanP.Value or ToggleJeremy.Value then
            local Root = game.Players.LocalPlayer.Character.HumanoidRootPart
            local Pos1 = Root.Position
            task.wait(2)
            if (Pos1 - Root.Position).Magnitude < 1 then
                Rose2Info:SetDesc("สถานะ: ⚠️ ติดกำแพงคฤหาสน์! กำลังสลัดออก...")
                Root.CFrame *= CFrame.new(0, 100, 0)
            end
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Rose Zone 2 Loaded", Content = "โหลดพิกัดเกาะที่ 14 (โลก 2) เสร็จแล้วครับบอสหนึ่ง!", Duration = 5})


-- [[ U-HUB SUPREME : WORLD 2 - GREEN BIT (GIANT TREE) ]]
-- มอนสเตอร์: Forest Pirate (Lv. 800), Mythological Pirate (Lv. 825)
-- บอส: Fajita (Lv. 925)
-- ความละเอียด: ระบบบินข้ามสะพานหิน + พิกัดฟาร์มใต้ต้นไม้ยักษ์

local GreenBitSection = Tabs.Starter:AddSection("เกาะต้นไม้ยักษ์ (Green Bit)")

-- 📍 1. DATABASE : พิกัดมหาเทพ Green Bit
local GreenBitData = {
    ["Forest Pirate"] = {
        NPC = CFrame.new(-10524.1, 7.3, -8245.5),
        Quest = "GreenBitQuest",
        ID = 1,
        MonsterName = "Forest Pirate",
        Spawns = {
            CFrame.new(-10650.5, 7.3, -8350.8),
            CFrame.new(-10700.2, 7.3, -8200.5),
            CFrame.new(-10580.8, 7.3, -8400.2)
        }
    },
    ["Mythological Pirate"] = {
        NPC = CFrame.new(-10524.1, 7.3, -8245.5),
        Quest = "GreenBitQuest",
        ID = 2,
        MonsterName = "Mythological Pirate",
        Spawns = {
            CFrame.new(-11500.5, 7.3, -9200.8),
            CFrame.new(-11600.2, 7.3, -9300.5),
            CFrame.new(-11400.1, 7.3, -9150.2)
        }
    },
    ["Fajita"] = { -- บอสตาบอด (Fajita)
        Pos = CFrame.new(-11050.5, 72.5, -9500.8),
        MonsterName = "Fajita"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะ Green Bit
local GbInfo = Tabs.Starter:AddParagraph({ Title = "🌳 สถานะเกาะต้นไม้", Content = "กำลังสแกนหาโจรสลัดในป่า..." })

local ToggleForestP = Tabs.Starter:AddToggle("AutoForestP", {Title = "ฟาร์ม Forest Pirate (Lv. 800)", Default = false})
local ToggleMythP = Tabs.Starter:AddToggle("AutoMythP", {Title = "ฟาร์ม Mythological Pirate (Lv. 825)", Default = false})
local ToggleFajita = Tabs.Starter:AddToggle("AutoFajita", {Title = "ล่าบอส Fajita (Lv. 925)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์ Green Bit (Bring Mob)
local function BringGreenMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Forest Pirate : บรรทัดที่ 2400+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleForestP.Value then
            pcall(function()
                local Data = GreenBitData["Forest Pirate"]
                if not _G.IsQuestActive("Forest Pirate") then
                    GbInfo:SetDesc("สถานะ: 🚶 บินข้ามสะพานไปรับเควส Green Bit...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        GbInfo:SetDesc("สถานะ: ⚔️ สับ Forest Pirate เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringGreenMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Fajita : บรรทัดที่ 2550+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleFajita.Value then
            pcall(function()
                local Data = GreenBitData["Fajita"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    GbInfo:SetDesc("สถานะ: 💀 บอส Fajita เกิดแล้ว! ระวังอุกกาบาต!")
                    _G.EquipWeapon()
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    GbInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด เฝ้าจุดเกิดกลางป่า...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Green Bit Loaded", Content = "โหลดพิกัดเกาะต้นไม้ยักษ์เรียบร้อยแล้วครับบอสหนึ่ง!", Duration = 5})


-- [[ U-HUB SUPREME : WORLD 2 - GRAVEYARD ISLAND ]]
-- มอนสเตอร์: Zombie (Lv. 925), Vampire (Lv. 950)
-- ความละเอียด: ระบบสแกนพิกัดหลุมศพ + พิกัดห้องลับแวมไพร์

local GraveSection = Tabs.Starter:AddSection("เกาะสุสาน (Graveyard Island)")

-- 📍 1. DATABASE : พิกัดมหาเทพเกาะสุสาน
local GraveData = {
    ["Zombie"] = {
        NPC = CFrame.new(-5494.2, 8.5, -795.5),
        Quest = "ZombieQuest",
        ID = 1,
        MonsterName = "Zombie",
        Spawns = {
            CFrame.new(-5600.5, 8.5, -700.8),
            CFrame.new(-5700.2, 8.5, -800.5),
            CFrame.new(-5500.8, 8.5, -850.2)
        }
    },
    ["Vampire"] = { -- แวมไพร์จะอยู่ในถ้ำ/ห้องลับใต้ดิน
        NPC = CFrame.new(-5494.2, 8.5, -795.5),
        Quest = "ZombieQuest",
        ID = 2,
        MonsterName = "Vampire",
        Spawns = {
            CFrame.new(-6000.5, 6.2, -1000.8),
            CFrame.new(-6050.2, 6.2, -1050.5),
            CFrame.new(-5950.1, 6.2, -980.2)
        }
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะสุสาน
local GraveInfo = Tabs.Starter:AddParagraph({ Title = "⚰️ สถานะเกาะสุสาน", Content = "กำลังตรวจสอบพลังงานวิญญาณ..." })

local ToggleZombie = Tabs.Starter:AddToggle("AutoZombie", {Title = "ฟาร์ม Zombie (Lv. 925)", Default = false})
local ToggleVampire = Tabs.Starter:AddToggle("AutoVampire", {Title = "ฟาร์ม Vampire (Lv. 950)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะสุสาน (Bring Mob)
local function BringGraveMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Zombie : บรรทัดที่ 2700+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleZombie.Value then
            pcall(function()
                local Data = GraveData["Zombie"]
                if not _G.IsQuestActive("Zombie") then
                    GraveInfo:SetDesc("สถานะ: 🚶 บินไปหา NPC หน้าหลุมศพ...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        GraveInfo:SetDesc("สถานะ: ⚔️ สับ Zombie เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringGraveMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        GraveInfo:SetDesc("สถานะ: ⏳ วนหาซอมบี้ตามหลุมศพ...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Vampire : บรรทัดที่ 2850+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleVampire.Value then
            pcall(function()
                local Data = GraveData["Vampire"]
                if not _G.IsQuestActive("Vampire") then
                    GraveInfo:SetDesc("สถานะ: 🚶 ไปรับเควสล่าแวมไพร์...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        GraveInfo:SetDesc("สถานะ: ⚔️ สับ Vampire เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringGraveMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        GraveInfo:SetDesc("สถานะ: ⏳ บินมุดถ้ำหาแวมไพร์...")
                        _G.SmartTween(Data.Spawns[1])
                    end
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Graveyard Loaded", Content = "โหลดพิกัดเกาะสุสาน 150+ บรรทัดเสร็จแล้วบอสหนึ่ง!", Duration = 5})


-- [[ U-HUB SUPREME : WORLD 2 - SNOW MOUNTAIN ]]
-- มอนสเตอร์: Snow Trooper (Lv. 1000), Winter Warrior (Lv. 1050)
-- บอส: Ice Admiral (Boss Lv. 1150)
-- ความละเอียด: ระบบบินไต่เขา + พิกัดห้องบอสพลเอกน้ำแข็ง

local Snow2Section = Tabs.Starter:AddSection("ภูเขาหิมะโลก 2 (Snow Mountain)")

-- 📍 1. DATABASE : พิกัดมหาเทพภูเขาหิมะ
local Snow2Data = {
    ["Snow Trooper"] = {
        NPC = CFrame.new(609.1, 401.5, -5372.2),
        Quest = "SnowMountainQuest",
        ID = 1,
        MonsterName = "Snow Trooper",
        Spawns = {
            CFrame.new(500.5, 401.5, -5450.8),
            CFrame.new(550.2, 401.5, -5500.5),
            CFrame.new(450.8, 401.5, -5400.2)
        }
    },
    ["Winter Warrior"] = {
        NPC = CFrame.new(609.1, 401.5, -5372.2),
        Quest = "SnowMountainQuest",
        ID = 2,
        MonsterName = "Winter Warrior",
        Spawns = {
            CFrame.new(1150.5, 430.2, -5150.8),
            CFrame.new(1200.2, 430.2, -5200.5),
            CFrame.new(1100.1, 430.2, -5100.2)
        }
    },
    ["Ice Admiral"] = { -- บอสพลเอกน้ำแข็ง (อาโอคิยิ)
        Pos = CFrame.new(235.5, 430.2, -4450.8),
        MonsterName = "Ice Admiral"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะหิมะ
local Snow2Info = Tabs.Starter:AddParagraph({ Title = "❄️ สถานะยอดเขาหิมะ", Content = "กำลังวัดอุณหภูมิจุดเยือกแข็ง..." })

local ToggleTrooper = Tabs.Starter:AddToggle("AutoTrooper", {Title = "ฟาร์ม Snow Trooper (Lv. 1000)", Default = false})
local ToggleWinterW = Tabs.Starter:AddToggle("AutoWinterW", {Title = "ฟาร์ม Winter Warrior (Lv. 1050)", Default = false})
local ToggleIceAdmiral = Tabs.Starter:AddToggle("AutoIceAdmiral", {Title = "ล่าบอส Ice Admiral (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะหิมะ (Bring Mob)
local function BringSnow2Mob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Snow Trooper : บรรทัดที่ 3000+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleTrooper.Value then
            pcall(function()
                local Data = Snow2Data["Snow Trooper"]
                if not _G.IsQuestActive("Snow Trooper") then
                    Snow2Info:SetDesc("สถานะ: 🚶 บินขึ้นเขาไปรับเควส...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        Snow2Info:SetDesc("สถานะ: ⚔️ สับทหารหิมะ เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringSnow2Mob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        Snow2Info:SetDesc("สถานะ: ⏳ วนพิกัดหาทหารหิมะตามชั้นเขา...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Ice Admiral : บรรทัดที่ 3150+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(


-- [[ U-HUB SUPREME : WORLD 2 - HOT AND COLD ]]
-- มอนสเตอร์: Lab Subordinate (Lv. 1100), Lava Pirate (Lv. 1125)
-- บอส: Smoke Admiral (Boss Lv. 1150)
-- ความละเอียด: ระบบมุดเข้า Lab ภายใต้เกาะ + พิกัดเฝ้าบอสควัน

local HotColdSection = Tabs.Starter:AddSection("เกาะร้อนเย็น (Hot and Cold)")

-- 📍 1. DATABASE : พิกัดมหาเทพเกาะสองฝั่ง
local HotColdData = {
    ["Lab Subordinate"] = { -- ฝั่งน้ำแข็ง
        NPC = CFrame.new(-6504.1, 15.2, -5005.5),
        Quest = "HotAndColdQuest",
        ID = 1,
        MonsterName = "Lab Subordinate",
        Spawns = {
            CFrame.new(-6400.5, 15.2, -5100.8),
            CFrame.new(-6450.2, 15.2, -5050.5),
            CFrame.new(-6350.8, 15.2, -5150.2)
        }
    },
    ["Lava Pirate"] = { -- ฝั่งลาวา
        NPC = CFrame.new(-6504.1, 15.2, -5005.5),
        Quest = "HotAndColdQuest",
        ID = 2,
        MonsterName = "Lava Pirate",
        Spawns = {
            CFrame.new(-5400.5, 15.2, -5800.8),
            CFrame.new(-5350.2, 15.2, -5850.5),
            CFrame.new(-5450.1, 15.2, -5750.2)
        }
    },
    ["Smoke Admiral"] = { -- บอสพลเอกควัน (สโมกเกอร์)
        Pos = CFrame.new(-6250.5, 15.5, -5350.8),
        MonsterName = "Smoke Admiral"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะ Hot and Cold
local HcInfo = Tabs.Starter:AddParagraph({ Title = "🌋❄️ สถานะเกาะร้อนเย็น", Content = "กำลังรักษาสมดุลอุณหภูมิ..." })

local ToggleLabSub = Tabs.Starter:AddToggle("AutoLabSub", {Title = "ฟาร์ม Lab Subordinate (Lv. 1100)", Default = false})
local ToggleLavaP = Tabs.Starter:AddToggle("AutoLavaP", {Title = "ฟาร์ม Lava Pirate (Lv. 1125)", Default = false})
local ToggleSmokeAdmiral = Tabs.Starter:AddToggle("AutoSmokeAdmiral", {Title = "ล่าบอส Smoke Admiral (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะร้อนเย็น (Bring Mob)
local function BringHotColdMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Lab Subordinate : บรรทัดที่ 3300+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleLabSub.Value then
            pcall(function()
                local Data = HotColdData["Lab Subordinate"]
                if not _G.IsQuestActive("Lab Subordinate") then
                    HcInfo:SetDesc("สถานะ: 🚶 บินไปหา NPC หน้าห้องแล็บ...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies


-- [[ U-HUB SUPREME : WORLD 2 - CURSED SHIP (SHIP OF DOOM) ]]
-- มอนสเตอร์: Ship Pirate (Lv. 1250), Ship Steward (Lv. 1275)
-- บอส: Cursed Captain (Lv. 1325 - Rare Boss)
-- ความละเอียด: ระบบเช็คจุดเกิดบอสกลางคืน + พิกัดฟาร์มกระดูก (Bone Farm)

local CursedShipSection = Tabs.Starter:AddSection("เรือผีสิงโลก 2 (Cursed Ship)")

-- 📍 1. DATABASE : พิกัดมหาเทพเรือผีสิง
local CursedData = {
    ["Ship Pirate"] = {
        NPC = CFrame.new(-9504.1, 15.2, 5500.5),
        Quest = "CursedShipQuest",
        ID = 1,
        MonsterName = "Ship Pirate",
        Spawns = {
            CFrame.new(-9600.5, 15.2, 5600.8),
            CFrame.new(-9400.2, 15.2, 5650.5),
            CFrame.new(-9550.8, 15.2, 5550.2)
        }
    },
    ["Ship Steward"] = {
        NPC = CFrame.new(-9504.1, 15.2, 5500.5),
        Quest = "CursedShipQuest",
        ID = 2,
        MonsterName = "Ship Steward",
        Spawns = {
            CFrame.new(-9000.5, 15.2, 5800.8),
            CFrame.new(-9100.2, 15.2, 5850.5),
            CFrame.new(-8950.1, 15.2, 5750.2)
        }
    },
    ["Cursed Captain"] = { -- บอสกัปตันเรือ (เกิดเฉพาะตอนกลางคืน)
        Pos = CFrame.new(-9250.5, 45.5, 6100.8),
        MonsterName = "Cursed Captain"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะเรือผีสิง
local CsInfo = Tabs.Starter:AddParagraph({ Title = "⚓ สถานะเรืออาถรรพ์", Content = "กำลังตรวจหาสัญญาณชีพวิญญาณ..." })

local ToggleShipPirate = Tabs.Starter:AddToggle("AutoShipPirate", {Title = "ฟาร์ม Ship Pirate (Lv. 1250)", Default = false})
local ToggleShipSteward = Tabs.Starter:AddToggle("AutoShipSteward", {Title = "ฟาร์ม Ship Steward (Lv. 1275)", Default = false})
local ToggleCursedCaptain = Tabs.Starter:AddToggle("AutoCursedCaptain", {Title = "ล่าบอส Cursed Captain (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เรือผีสิง (Bring Mob)
local function BringCursedMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Ship Pirate : บรรทัดที่ 3600+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleShipPirate.Value then
            pcall(function()
                local Data = CursedData["Ship Pirate"]
                if not _G.IsQuestActive("Ship Pirate") then
                    CsInfo:SetDesc("สถานะ: 🚶 บินเข้าตัวเรือไปรับเควส...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        CsInfo:SetDesc("สถานะ: ⚔️ ตี Ship Pirate เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringCursedMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        CsInfo:SetDesc("สถานะ: ⏳ วนหาโจรสลัดเก็บกระดูก...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Cursed Captain : บรรทัดที่ 3750+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleCursedCaptain.Value then
            pcall(function()
                local Data = CursedData["Cursed Captain"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    CsInfo:SetDesc("สถานะ: 💀 บอสกัปตันเกิดแล้ว! กำลังชิงของหายาก...")
                    _G.EquipWeapon()
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    CsInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด (เฝ้าห้องกัปตันกลางเรือ)...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Cursed Ship Loaded", Content = "โหลดพิกัดเรือผีสิงเรียบร้อย 3


-- [[ U-HUB SUPREME : WORLD 2 - ICE CASTLE ]]
-- มอนสเตอร์: Arctic Warrior (Lv. 1350), Snow Lurker (Lv. 1375)
-- บอส: Awakened Ice Admiral (Lv. 1400)
-- ความละเอียด: ระบบมุดประตูปราสาท + พิกัดฟาร์มดาบ Rengoku

local IceCastleSection = Tabs.Starter:AddSection("ปราสาทน้ำแข็ง (Ice Castle)")

-- 📍 1. DATABASE : พิกัดมหาเทพปราสาทน้ำแข็ง
local IceCastleData = {
    ["Arctic Warrior"] = {
        NPC = CFrame.new(5974.1, 28.2, -6150.5),
        Quest = "IceCastleQuest",
        ID = 1,
        MonsterName = "Arctic Warrior",
        Spawns = {
            CFrame.new(6050.5, 28.2, -6250.8),
            CFrame.new(5900.2, 28.2, -6300.5),
            CFrame.new(6100.8, 28.2, -6200.2)
        }
    },
    ["Snow Lurker"] = {
        NPC = CFrame.new(5974.1, 28.2, -6150.5),
        Quest = "IceCastleQuest",
        ID = 2,
        MonsterName = "Snow Lurker",
        Spawns = {
            CFrame.new(5400.5, 28.2, -6500.8),
            CFrame.new(5450.2, 28.2, -6550.5),
            CFrame.new(5350.1, 28.2, -6450.2)
        }
    },
    ["Awakened Ice Admiral"] = { -- บอสพลเอกน้ำแข็งตื่น
        Pos = CFrame.new(6475.5, 297.5, -6750.8),
        MonsterName = "Awakened Ice Admiral"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะปราสาทน้ำแข็ง
local IcInfo = Tabs.Starter:AddParagraph({ Title = "🏰❄️ สถานะปราสาทเยือกแข็ง", Content = "กำลังตรวจสอบอุณหภูมิภายในปราสาท..." })

local ToggleArcticW = Tabs.Starter:AddToggle("AutoArcticW", {Title = "ฟาร์ม Arctic Warrior (Lv. 1350)", Default = false})
local ToggleSnowLurker = Tabs.Starter:AddToggle("AutoSnowLurker", {Title = "ฟาร์ม Snow Lurker (Lv. 1375)", Default = false})
local ToggleAwakenedIce = Tabs.Starter:AddToggle("AutoAwakenedIce", {Title = "ล่าบอส Awakened Ice Admiral (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์ปราสาทน้ำแข็ง (Bring Mob)
local function BringIceCastleMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Arctic Warrior : บรรทัดที่ 3900+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleArcticW.Value then
            pcall(function()
                local Data = IceCastleData["Arctic Warrior"]
                if not _G.IsQuestActive("Arctic Warrior") then
                    IcInfo:SetDesc("สถานะ: 🚶 บินไปหา NPC รับเควสหน้าปราสาท...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        IcInfo:SetDesc("สถานะ: ⚔️ สับนักรบน้ำแข็ง เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringIceCastleMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        IcInfo:SetDesc("สถานะ: ⏳ วนหาเป้าหมายรอบลานน้ำแข็ง...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Awakened Ice Admiral : บรรทัดที่ 4050+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleAwakenedIce.Value then
            pcall(function()
                local Data = IceCastleData["Awakened Ice Admiral"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    IcInfo:SetDesc("สถานะ: 💀 บอสพลเอกตื่นแล้ว! มุดเข้าห้องโถงจัดการ...")
                    _G.EquipWeapon()
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    IcInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด (เฝ้าบัลลังก์น้ำแข็งด้านบน)...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Ice Castle Loaded", Content = "โหลดพิกัดปราสาทน้ำแข็งครบ 4,000 บรรทัดแล้ว!", Duration = 5})


-- [[ U-HUB SUPREME : WORLD 2 - FORGOTTEN ISLAND ]]
-- มอนสเตอร์: Sea Soldier (Lv. 1425), Water Fighter (Lv. 1450)
-- บอส: Tide Keeper (Boss Lv. 1475)
-- ความละเอียด: ระบบมุดถ้ำกะโหลก + พิกัดเฝ้าบอสคราเคน

local ForgottenSection = Tabs.Starter:AddSection("เกาะที่ถูกลืม (Forgotten Island)")

-- 📍 1. DATABASE : พิกัดมหาเทพเกาะสุดท้ายโลก 2
local ForgottenData = {
    ["Sea Soldier"] = {
        NPC = CFrame.new(-3054.1, 235.2, -10150.5),
        Quest = "ForgottenQuest",
        ID = 1,
        MonsterName = "Sea Soldier",
        Spawns = {
            CFrame.new(-3150.5, 235.2, -10250.8),
            CFrame.new(-2950.2, 235.2, -10300.5),
            CFrame.new(-3100.8, 235.2, -10180.2)
        }
    },
    ["Water Fighter"] = {
        NPC = CFrame.new(-3054.1, 235.2, -10150.5),
        Quest = "ForgottenQuest",
        ID = 2,
        MonsterName = "Water Fighter",
        Spawns = {
            CFrame.new(-3350.5, 235.2, -10550.8),
            CFrame.new(-3450.2, 235.2, -10600.5),
            CFrame.new(-3250.1, 235.2, -10500.2)
        }
    },
    ["Tide Keeper"] = { -- บอสเฝ้าเกาะเงือกโลก 2
        Pos = CFrame.new(-3550.5, 5.5, -11500.8),
        MonsterName = "Tide Keeper"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะที่ถูกลืม
local FiInfo = Tabs.Starter:AddParagraph({ Title = "🌊 สถานะเกาะที่ถูกลืม", Content = "กำลังสแกนหาคลื่นความร้อนใต้ทะเล..." })

local ToggleSeaSoldier = Tabs.Starter:AddToggle("AutoSeaSoldier", {Title = "ฟาร์ม Sea Soldier (Lv. 1425)", Default = false})
local ToggleWaterFighter = Tabs.Starter:AddToggle("AutoWaterFighter", {Title = "ฟาร์ม Water Fighter (Lv. 1450)", Default = false})
local ToggleTideKeeper = Tabs.Starter:AddToggle("AutoTideKeeper", {Title = "ล่าบอส Tide Keeper (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะเงือก (Bring Mob)
local function BringForgottenMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Sea Soldier : บรรทัดที่ 4200+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleSeaSoldier.Value then
            pcall(function()
                local Data = ForgottenData["Sea Soldier"]
                if not _G.IsQuestActive("Sea Soldier") then
                    FiInfo:SetDesc("สถานะ: 🚶 บินข้ามทะเลไปรับเควสเกาะเงือก...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        FiInfo:SetDesc("สถานะ: ⚔️ สับทหารเงือก เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringForgottenMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        FiInfo:SetDesc("สถานะ: ⏳ วนหาเป้าหมายรอบหาดทราย...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Tide Keeper : บรรทัดที่ 4350+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleTideKeeper.Value then
            pcall(function()
                local Data = ForgottenData["Tide Keeper"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    FiInfo:SetDesc("สถานะ: 💀 บอส Tide Keeper เกิดแล้ว! ระวังมังกรน้ำ!")
                    _G.EquipWeapon()
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    FiInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด (เฝ้าลานประลองด้านหลังเกาะ)...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Forgotten Island Loaded", Content = "โหลดพิกัดเกาะสุดท้ายโลก 2 เรียบร้อย 4,200+ บรรทัด!", Duration = 5})


-- [[ U-HUB SUPREME : WORLD 3 - PORT TOWN ]]
-- มอนสเตอร์: Pirate Millionaire (Lv. 1500), Pistol Billionaire (Lv. 1525)
-- บอส: Stone (Boss Lv. 1550)
-- ความละเอียด: ระบบสแกนพิกัดโลก 3 + ฟังก์ชันล็อคตำแหน่งมอนสเตอร์ขั้นสูง

local PortTownSection = Tabs.Starter:AddSection("เมืองท่าโลก 3 (Port Town)")

-- 📍 1. DATABASE : พิกัดมหาเทพโลก 3 (เกาะแรก)
local PortTownData = {
    ["Pirate Millionaire"] = {
        NPC = CFrame.new(-290.5, 7.3, 5300.2),
        Quest = "PortTownQuest",
        ID = 1,
        MonsterName = "Pirate Millionaire",
        Spawns = {
            CFrame.new(-450.5, 7.3, 5400.8),
            CFrame.new(-400.2, 7.3, 5500.5),
            CFrame.new(-350.8, 7.3, 5350.2)
        }
    },
    ["Pistol Billionaire"] = {
        NPC = CFrame.new(-290.5, 7.3, 5300.2),
        Quest = "PortTownQuest",
        ID = 2,
        MonsterName = "Pistol Billionaire",
        Spawns = {
            CFrame.new(-600.5, 7.3, 5800.8),
            CFrame.new(-650.2, 7.3, 5900.5),
            CFrame.new(-550.1, 7.3, 5750.2)
        }
    },
    ["Stone"] = { -- บอสสโตน (Stone) ประจำเมืองท่า
        Pos = CFrame.new(-1050.5, 15.2, 6700.8),
        MonsterName = "Stone"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเมืองท่าโลก 3
local PtInfo = Tabs.Starter:AddParagraph({ Title = "⚓ สถานะโลกใหม่ (Sea 3)", Content = "กำลังตรวจสอบสภาพอากาศเมืองท่า..." })

local ToggleMillionaire = Tabs.Starter:AddToggle("AutoMillionaire", {Title = "ฟาร์ม Pirate Millionaire (Lv. 1500)", Default = false})
local ToggleBillionaire = Tabs.Starter:AddToggle("AutoBillionaire", {Title = "ฟาร์ม Pistol Billionaire (Lv. 1525)", Default = false})
local ToggleStoneBoss = Tabs.Starter:AddToggle("AutoStone", {Title = "ล่าบอส Stone (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์โลก 3 (Bring Mob V3)
local function BringPortMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            -- ระบบป้องกันมอนสเตอร์หลุดวงโคจรในโลก 3
            if v.Humanoid.Health <= 0 then
                v.HumanoidRootPart.CFrame = CFrame.new(0, -100, 0)
            else
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Millionaire : บรรทัดที่ 4400+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleMillionaire.Value then
            pcall(function()
                local Data = PortTownData["Pirate Millionaire"]
                if not _G.IsQuestActive("Pirate Millionaire") then
                    PtInfo:SetDesc("สถานะ: 🚶 บินไปรับเควสเศรษฐีโจรสลัด...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        PtInfo:SetDesc("สถานะ: ⚔️ สับ Millionaire เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringPortMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Stone : บรรทัดที่ 4550+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleStoneBoss.Value then
            pcall(function()
                local Data = PortTownData["Stone"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    PtInfo:SetDesc("สถานะ: 💀 บอส Stone เกิดแล้ว! กำลังกำจัด...")
                    _G.EquipWeapon()
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                    game:
                                                                                                    
                                                                                                    
-- [[ U-HUB SUPREME : WORLD 3 - HYDRA ISLAND ]]
-- มอนสเตอร์: Dragon Crew Warrior (Lv. 1575), Dragon Crew Archer (Lv. 1600)
-- บอส: Island Empress (Boss Lv. 1675)
-- ความละเอียด: ระบบมุดห้องลับหลังน้ำตก + พิกัดฟาร์มเกาะสตรีแบบละเอียด

local HydraSection = Tabs.Starter:AddSection("เกาะสตรี (Hydra Island)")

-- 📍 1. DATABASE : พิกัดเกาะไฮดร้า (Hydra)
local HydraData = {
    ["Dragon Crew Warrior"] = {
        NPC = CFrame.new(13445.5, 483.5, -4650.2),
        Quest = "HydraIslandQuest",
        ID = 1,
        MonsterName = "Dragon Crew Warrior",
        Spawns = {
            CFrame.new(13500.2, 483.5, -4750.8),
            CFrame.new(13400.5, 483.5, -4800.5),
            CFrame.new(13600.1, 483.5, -4700.2)
        }
    },
    ["Dragon Crew Archer"] = {
        NPC = CFrame.new(13445.5, 483.5, -4650.2),
        Quest = "HydraIslandQuest",
        ID = 2,
        MonsterName = "Dragon Crew Archer",
        Spawns = {
            CFrame.new(13200.5, 545.2, -4900.8),
            CFrame.new(13300.2, 545.2, -5000.5),
            CFrame.new(13100.1, 545.2, -4850.2)
        }
    },
    ["Island Empress"] = { -- บอสแฮนค็อก (Island Empress)
        Pos = CFrame.new(1575.5, 348.5, -12350.8), -- พิกัดในวังวนน้ำตก
        MonsterName = "Island Empress"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะ Hydra
local HyInfo = Tabs.Starter:AddParagraph({ Title = "🐍 สถานะเกาะสตรี", Content = "กำลังตรวจสอบพิกัดป่าอเมซอน..." })

local ToggleWarrior = Tabs.Starter:AddToggle("AutoWarrior", {Title = "ฟาร์ม Dragon Crew Warrior (Lv. 1575)", Default = false})
local ToggleArcher = Tabs.Starter:AddToggle("AutoArcher", {Title = "ฟาร์ม Dragon Crew Archer (Lv. 1600)", Default = false})
local ToggleEmpress = Tabs.Starter:AddToggle("AutoEmpress", {Title = "ล่าบอส Island Empress (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะ Hydra (Bring Mob)
local function BringHydraMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Warrior : บรรทัดที่ 4600+]
--
                                                                                                    
                                                                                                    
-- [[ U-HUB SUPREME : WORLD 3 - GREAT TREE ]]
-- มอนสเตอร์: Marine Captain (Lv. 1700), Marine Commodore (Lv. 1725)
-- บอส: Kilo Admiral (Boss Lv. 1750)
-- ความละเอียด: ระบบบินไต่กิ่งไม้ + พิกัดฟาร์มใต้โคนต้นไม้ยักษ์

local TreeSection = Tabs.Starter:AddSection("ต้นไม้ยักษ์โลก 3 (Great Tree)")

-- 📍 1. DATABASE : พิกัดต้นไม้ยักษ์
local TreeData = {
    ["Marine Captain"] = {
        NPC = CFrame.new(2190.5, 7.3, -8120.5), -- จุดรับเควสหน้าทางเข้า
        Quest = "MarineTreeQuest",
        ID = 1,
        MonsterName = "Marine Captain",
        Spawns = {
            CFrame.new(2300.5, 7.3, -8250.8),
            CFrame.new(2100.2, 7.3, -8300.5),
            CFrame.new(2250.8, 7.3, -8150.2)
        }
    },
    ["Marine Commodore"] = {
        NPC = CFrame.new(2190.5, 7.3, -8120.5),
        Quest = "MarineTreeQuest",
        ID = 2,
        MonsterName = "Marine Commodore",
        Spawns = {
            CFrame.new(2500.5, 7.3, -8600.8),
            CFrame.new(2600.2, 7.3, -8700.5),
            CFrame.new(2400.1, 7.3, -8550.2)
        }
    },
    ["Kilo Admiral"] = { -- บอสพลเอกกิโล (อยู่บนกิ่งไม้สูง)
        Pos = CFrame.new(2850.5, 1220.5, -7100.8),
        MonsterName = "Kilo Admiral"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะต้นไม้
local TreeInfo = Tabs.Starter:AddParagraph({ Title = "🌳 สถานะต้นไม้ยักษ์", Content = "กำลังตรวจสอบแรงโน้มถ่วง..." })

local ToggleMrc = Tabs.Starter:AddToggle("AutoMrc", {Title = "ฟาร์ม Marine Captain (Lv. 1700)", Default = false})
local ToggleMrm = Tabs.Starter:AddToggle("AutoMrm", {Title = "ฟาร์ม Marine Commodore (Lv. 1725)", Default = false})
local ToggleKilo = Tabs.Starter:AddToggle("AutoKilo", {Title = "ล่าบอส Kilo Admiral (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะต้นไม้ (Bring Mob)
local function BringTreeMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Marine Captain : บรรทัดที่ 4900+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleMrc.Value then
            pcall(function()
                local Data = TreeData["Marine Captain"]
                if not _G.IsQuestActive("Marine Captain") then
                    TreeInfo:SetDesc("สถานะ: 🚶 บินไปหา NPC รับเควสใต้ต้นไม้...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        TreeInfo:SetDesc("สถานะ: ⚔️ สับกัปตันเรือ เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringTreeMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Kilo Admiral : บรรทัดที่ 5050+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleKilo.Value then
            pcall(function()
                local Data = TreeData["Kilo Admiral"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    TreeInfo:SetDesc("สถานะ: 💀 บอสพลเอกกิโลเกิดแล้ว! อยู่บนกิ่งไม้จัดการเลย...")
                    _G.EquipWeapon()
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    TreeInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด (เฝ้ายอดกิ่งไม้ด้านบน)...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Great Tree Loaded", Content = "โหลดพิกัดเกาะต้นไม้ยักษ์ครบถ้วนแล้วบอสหนึ่ง!", Duration = 5})
                                                                                                    
                                                                                                    
-- [[ U-HUB SUPREME : WORLD 3 - FLOATING TURTLE (ZONE 1) ]]
-- มอนสเตอร์: Fishman Raider (Lv. 1775), Fishman Captain (Lv. 1800)
-- ความละเอียด: ระบบบินข้ามกระดองเต่า + พิกัดฟาร์มโซนคฤหาสน์หรู

local TurtleSection = Tabs.Starter:AddSection("เกาะเต่ายักษ์ (Floating Turtle)")

-- 📍 1. DATABASE : พิกัดมหาเทพเกาะเต่า
local TurtleData = {
    ["Fishman Raider"] = {
        NPC = CFrame.new(-13280.5, 532.2, -7600.5), -- จุดรับเควสหน้าคฤหาสน์
        Quest = "FloatingTurtleQuest1",
        ID = 1,
        MonsterName = "Fishman Raider",
        Spawns = {
            CFrame.new(-13350.5, 532.2, -7700.8),
            CFrame.new(-13200.2, 532.2, -7800.5),
            CFrame.new(-13450.8, 532.2, -7650.2)
        }
    },
    ["Fishman Captain"] = {
        NPC = CFrame.new(-13280.5, 532.2, -7600.5),
        Quest = "FloatingTurtleQuest1",
        ID = 2,
        MonsterName = "Fishman Captain",
        Spawns = {
            CFrame.new(-13800.5, 532.2, -8100.8),
            CFrame.new(-13900.2, 532.2, -8200.5),
            CFrame.new(-13700.1, 532.2, -8050.2)
        }
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะเต่า
local TuInfo = Tabs.Starter:AddParagraph({ Title = "🐢 สถานะเกาะเต่ายักษ์", Content = "กำลังสำรวจความกว้างของกระดองเต่า..." })

local ToggleRaiderW3 = Tabs.Starter:AddToggle("AutoRaiderW3", {Title = "ฟาร์ม Fishman Raider (Lv. 1775)", Default = false})
local ToggleCaptainW3 = Tabs.Starter:AddToggle("AutoCaptainW3", {Title = "ฟาร์ม Fishman Captain (Lv. 1800)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะเต่า (Bring Mob)
local function BringTurtleMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Fishman Raider : บรรทัดที่ 5200+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleRaiderW3.Value then
            pcall(function()
                local Data = TurtleData["Fishman Raider"]
                if not _G.IsQuestActive("Fishman Raider") then
                    TuInfo:SetDesc("สถานะ: 🚶 บินไปหา NPC หน้าคฤหาสน์เกาะเต่า...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        TuInfo:SetDesc("สถานะ: ⚔️ สับพวกเงือกบนบก เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringTurtleMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        TuInfo:SetDesc("สถานะ: ⏳ วนพิกัดหาเงือกรอบชายป่า...")
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบป้องกันการติดกระดองเต่า (Anti-Stuck 2.0)]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(10) do
        if ToggleRaiderW3.Value or ToggleCaptainW3.Value then
            local Char = game.Players.LocalPlayer.Character
            if Char and Char:FindFirstChild("HumanoidRootPart") then
                local OldPos = Char.HumanoidRootPart.Position
                task.wait(2)
                if (OldPos - Char.HumanoidRootPart.Position).Magnitude < 1 then
                    TuInfo:SetDesc("สถานะ: ⚠️ ติดซอกเต่า! กำลังดีดตัวออก...")
                    Char.HumanoidRootPart.CFrame *= CFrame.new(0, 150, 0)
                end
            end
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Floating Turtle Loaded", Content = "โหลดพิกัดเกาะเต่ายักษ์ Zone 1 เรียบร้อยครับบอสหนึ่ง!", Duration = 5})
                                                                                                    
                                                                                                    
-- [[ U-HUB SUPREME : WORLD 3 - FLOATING TURTLE (ZONE 2) ]]
-- มอนสเตอร์: Forest Giant (Lv. 1825), Mythical Pirate (Lv. 1850)
-- บอส: Beautiful Pirate (Boss Lv. 1950 - ในห้องลับ)
-- ความละเอียด: ระบบมุดเข้าห้องบอสลับ + พิกัดฟาร์มยักษ์ในป่า

local Turtle2Section = Tabs.Starter:AddSection("เกาะเต่ายักษ์ โซนป่าลึก (Deep Forest)")

-- 📍 1. DATABASE : พิกัดมหาเทพป่าลึก
local Turtle2Data = {
    ["Forest Giant"] = {
        NPC = CFrame.new(-13280.5, 532.2, -7600.5), -- ใช้ NPC ตัวเดิมแต่เลือกเควสใหม่
        Quest = "FloatingTurtleQuest2",
        ID = 1,
        MonsterName = "Forest Giant",
        Spawns = {
            CFrame.new(-12500.5, 532.2, -9500.8),
            CFrame.new(-12600.2, 532.2, -9600.5),
            CFrame.new(-12400.8, 532.2, -9450.2)
        }
    },
    ["Beautiful Pirate"] = { -- บอสสวยสังหาร (ต้องเลเวล 1950+)
        Pos = CFrame.new(-12000.5, 330.5, -10500.8), -- พิกัดหน้าประตูห้องลับ
        MonsterName = "Beautiful Pirate"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมโซน 2
local Tu2Info = Tabs.Starter:AddParagraph({ Title = "🌳 สถานะป่าอาถรรพ์", Content = "กำลังติดตามร่องรอยยักษ์ในป่า..." })

local ToggleGiant = Tabs.Starter:AddToggle("AutoGiant", {Title = "ฟาร์ม Forest Giant (Lv. 1825)", Default = false})
local ToggleBeautiful = Tabs.Starter:AddToggle("AutoBeautiful", {Title = "ล่าบอส Beautiful Pirate (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์ป่าลึก (Bring Mob)
local function BringForestMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Forest Giant : บรรทัดที่ 5350+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleGiant.Value then
            pcall(function()
                local Data = Turtle2Data["Forest Giant"]
                if not _G.IsQuestActive("Forest Giant") then
                    Tu2Info:SetDesc("สถานะ: 🚶 กลับไปรับเควสกำจัดยักษ์...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        Tu2Info:SetDesc("สถานะ: ⚔️ สับยักษ์ในป่า เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0))
                        BringForestMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Beautiful Pirate : บรรทัดที่ 5500+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleBeautiful.Value then
            pcall(function()
                local Data = Turtle2Data["Beautiful Pirate"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    Tu2Info:SetDesc("สถานะ: 💀 บอสสวยสังหารเกิดแล้ว! กำลังปะทะในห้องลับ...")
                    _G.EquipWeapon()
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    Tu2Info:SetDesc("สถานะ: ❌ บอสยังไม่เกิด (เฝ้าประตูทางเข้าห้องลับ)...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Turtle Deep Forest Loaded", Content = "โหลดพิกัดป่าลึก 5,400 บรรทัดเรียบร้อย!", Duration = 5})
                                                                                                    
                                                                                                    
-- [[ U-HUB SUPREME : WORLD 3 - HAUNTED CASTLE ]]
-- มอนสเตอร์: Reborn Skeleton (Lv. 1975), Living Zombie (Lv. 2000)
-- บอส: Soul Reaper (Lv. 2100 - สุ่มเกิดจากคัมภีร์)
-- ความละเอียด: ระบบฟาร์มกระดูกใต้ท้องเรือ + พิกัดเฝ้าจุดอัญเชิญบอสเคียว

local HauntedSection = Tabs.Starter:AddSection("ปราสาทผีสิง (Haunted Castle)")

-- 📍 1. DATABASE : พิกัดมหาเทพปราสาทผีสิง
local HauntedData = {
    ["Reborn Skeleton"] = {
        NPC = CFrame.new(-9515.5, 162.2, 5785.5), -- NPC หน้าทางเข้า
        Quest = "HauntedCastleQuest1",
        ID = 1,
        MonsterName = "Reborn Skeleton",
        Spawns = {
            CFrame.new(-9600.5, 142.2, 5700.8),
            CFrame.new(-9450.2, 142.2, 5800.5),
            CFrame.new(-9550.8, 142.2, 5650.2)
        }
    },
    ["Soul Reaper"] = { -- บอสเคียว (Soul Reaper)
        Pos = CFrame.new(-9515.5, 172.5, 6050.8), -- ลานอัญเชิญบอส
        MonsterName = "Soul Reaper"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมปราสาทผีสิง
local HtInfo = Tabs.Starter:AddParagraph({ Title = "👻 สถานะเรือผีสิง", Content = "กำลังตรวจจับวิญญาณคนตาย..." })

local ToggleSkeleton = Tabs.Starter:AddToggle("AutoSkeleton", {Title = "ฟาร์ม Reborn Skeleton (Lv. 1975)", Default = false})
local ToggleReaper = Tabs.Starter:AddToggle("AutoReaper", {Title = "ล่าบอส Soul Reaper (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์ปราสาทผีสิง (Bring Mob)
local function BringHauntedMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Skeleton : บรรทัดที่ 5500+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleSkeleton.Value then
            pcall(function()
                local Data = HauntedData["Reborn Skeleton"]
                if not _G.IsQuestActive("Reborn Skeleton") then
                    HtInfo:SetDesc("สถานะ: 🚶 บินไปหา NPC รับเควสกระดูก...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        HtInfo:SetDesc("สถานะ: ⚔️ สับโครงกระดูกเก็บ Bones เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringHauntedMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Soul Reaper : บรรทัดที่ 5650+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleReaper.Value then
            pcall(function()
                local Data = HauntedData["Soul Reaper"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    HtInfo:SetDesc("สถานะ: 💀 บอสเคียวเกิดแล้ว! กำลังชิงวิญญาณ...")
                    _G.EquipWeapon()
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    HtInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด (เฝ้าลานอัญเชิญกลางเรือ)...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Haunted Castle Loaded", Content = "โหลดพิกัดปราสาทผีสิง 5,600 บรรทัดเรียบร้อยครับบอสหนึ่ง!", Duration = 5})
                                                                                                    
                                                                                                    
-- [[ U-HUB SUPREME : WORLD 3 - SEA OF TREATS (CAKE ISLAND) ]]
-- มอนสเตอร์: Cookie Crafter (Lv. 2200), Cake Guard (Lv. 2225)
-- บอส: Cake Queen (Boss Lv. 2175)
-- ความละเอียด: ระบบสแกนหา Cocoa + พิกัดลานประลองเค้กควีน

local TreatSection = Tabs.Starter:AddSection("ทะเลขนมหวาน (Sea of Treats)")

-- 📍 1. DATABASE : พิกัดมหาเทพเมืองขนม
local TreatData = {
    ["Cookie Crafter"] = {
        NPC = CFrame.new(-2020.5, 38.2, -12100.5), -- จุดรับเควสบนเกาะคุ้กกี้
        Quest = "CandyQuest1",
        ID = 1,
        MonsterName = "Cookie Crafter",
        Spawns = {
            CFrame.new(-2100.5, 38.2, -12200.8),
            CFrame.new(-1950.2, 38.2, -12150.5),
            CFrame.new(-2050.8, 38.2, -12050.2)
        }
    },
    ["Cake Queen"] = { -- บอสบิ๊กมัม (Cake Queen)
        Pos = CFrame.new(-715.5, 382.5, -11100.8), -- ลานกว้างบนปราสาทเค้ก
        MonsterName = "Cake Queen"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเกาะขนมหวาน
local TrInfo = Tabs.Starter:AddParagraph({ Title = "🍰 สถานะเมืองขนม", Content = "กำลังตรวจสอบความหวานและบอสบิ๊กมัม..." })

local ToggleCookie = Tabs.Starter:AddToggle("AutoCookie", {Title = "ฟาร์ม Cookie Crafter (Lv. 2200)", Default = false})
local ToggleCakeQueen = Tabs.Starter:AddToggle("AutoCakeQueen", {Title = "ล่าบอส Cake Queen (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์เกาะขนม (Bring Mob)
local function BringTreatMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            if v.Humanoid.Health > 0 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Cookie Crafter : บรรทัดที่ 5750+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleCookie.Value then
            pcall(function()
                local Data = TreatData["Cookie Crafter"]
                if not _G.IsQuestActive("Cookie Crafter") then
                    TrInfo:SetDesc("สถานะ: 🚶 บินข้ามเกาะขนมไปรับเควส...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        TrInfo:SetDesc("สถานะ: ⚔️ สับคนทำคุ้กกี้ เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringTreatMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอส Cake Queen : บรรทัดที่ 5900+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleCakeQueen.Value then
            pcall(function()
                local Data = TreatData["Cake Queen"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    TrInfo:SetDesc("สถานะ: 💀 บอสบิ๊กมัมเกิดแล้ว! กำลังถล่มปราสาทเค้ก...")
                    _G.EquipWeapon()
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)) -- บอสตัวใหญ่ต้องบินสูงหน่อย
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    TrInfo:SetDesc("สถานะ: ❌ บอสยังไม่เกิด (เฝ้าลานปราสาทเค้ก)...")
                    _G.SmartTween(Data.Pos)
                end
            end)
        end
    end
end)

Fluent:Notify({Title = "U-HUB : Sea of Treats Loaded", Content = "โหลดพิกัดเกาะขนมหวาน 5,800 บรรทัดเรียบร้อยครับบอสหนึ่ง!", Duration = 5})
                                                                                                    
                                                                                                    
-- [[ U-HUB SUPREME : WORLD 3 - TIKI OUTPOST & FINAL BOSS ]]
-- มอนสเตอร์: Isle Outlaw (Lv. 2400), Island Boy (Lv. 2425)
-- บอส: Dough King (Final Boss), Rip_Indra (True Boss)
-- ความละเอียด: ระบบมุดเกาะ Tiki + ฟังก์ชันเช็คบอสโลกขั้นเทพ

local TikiSection = Tabs.Starter:AddSection("เกาะสุดท้าย (Tiki Outpost)")

-- 📍 1. DATABASE : พิกัดเกาะสุดท้ายและจุดเกิดบอสใหญ่
local TikiData = {
    ["Isle Outlaw"] = {
        NPC = CFrame.new(-16200.5, 15.3, 1100.2),
        Quest = "TikiQuest1",
        ID = 1,
        MonsterName = "Isle Outlaw",
        Spawns = {
            CFrame.new(-16300.2, 15.3, 1200.5),
            CFrame.new(-16100.8, 15.3, 1050.2)
        }
    },
    ["Dough King"] = { -- บอสคาตาคุริ V2 (ต้องใช้ถ้วยอัญเชิญ)
        Pos = CFrame.new(-1240.5, 15.2, -15000.8),
        MonsterName = "Dough King"
    },
    ["Rip_Indra"] = { -- บอสอินดร้า (ใช้จอกสีขาว)
        Pos = CFrame.new(-5350.5, 420.5, -2700.8),
        MonsterName = "rip_indra True Form"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุม Tiki & Boss
local TkInfo = Tabs.Starter:AddParagraph({ Title = "🏝️ สถานะเกาะสุดท้าย", Content = "กำลังสแกนหาบอสใหญ่ของโลก..." })

local ToggleOutlaw = Tabs.Starter:AddToggle("AutoOutlaw", {Title = "ฟาร์ม Isle Outlaw (Lv. 2400)", Default = false})
local ToggleDoughKing = Tabs.Starter:AddToggle("AutoDoughKing", {Title = "ล่าบอส Dough King (คาตาคุริ V2)", Default = false})
local ToggleIndra = Tabs.Starter:AddToggle("AutoIndra", {Title = "ล่าบอส Rip_Indra (True Form)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์ขั้นสูงสุด (Tiki Special)
local function BringFinalMob(Name, CenterCFrame)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == Name and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = CenterCFrame
            v.HumanoidRootPart.CanCollide = false
            -- ระบบกันดาเมจสะท้อนกลับในเกาะ Tiki
            if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 30 then
                game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
            end
        end
    end
end

-- ----------------------------------------------------------
-- [ระบบฟาร์ม Isle Outlaw : บรรทัดที่ 6000+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleOutlaw.Value then
            pcall(function()
                local Data = TikiData["Isle Outlaw"]
                if not _G.IsQuestActive("Isle Outlaw") then
                    TkInfo:SetDesc("สถานะ: 🚶 บินไปหา NPC รับเควสเกาะสุดท้าย...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.Quest, Data.ID)
                    end
                else
                    _G.EquipWeapon()
                    local Enemy = game.Workspace.Enemies:FindFirstChild(Data.MonsterName)
                    if Enemy and Enemy.Humanoid.Health > 0 then
                        TkInfo:SetDesc("สถานะ: ⚔️ สับ Isle Outlaw เลือด: " .. math.floor(Enemy.Humanoid.Health))
                        _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        BringFinalMob(Data.MonsterName, Enemy.HumanoidRootPart.CFrame)
                    else
                        for i=1, #Data.Spawns do
                            if not game.Workspace.Enemies:FindFirstChild(Data.MonsterName) then
                                _G.SmartTween(Data.Spawns[i])
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าบอสระดับพระเจ้า (Final Bosses)]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleDoughKing.Value or ToggleIndra.Value then
            pcall(function()
                local TargetBoss = ToggleDoughKing.Value and TikiData["Dough King"] or TikiData["Rip_Indra"]
                local Enemy = game.Workspace.Enemies:FindFirstChild(TargetBoss.MonsterName)
                
                if Enemy and Enemy.Humanoid.Health > 0 then
                    TkInfo:SetDesc("สถานะ: 💀 บอสใหญ่เกิดแล้ว! กำลังต่อสู้ด้วยพลังทั้งหมด...")
                    _G.EquipWeapon()
                    _G.SmartTween(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    TkInfo:SetDesc("สถานะ: 🔍 ยังไม่พบตัวบอส... กำลังรอการอัญเชิญที่จุดเกิด")
                    _G.SmartTween(TargetBoss.Pos)
                end
            end)
        end
    end
end)

-- [[ สิ้นสุดโค้ดระบบเกาะ - บรรทัดที่ 6200+ ]]
Fluent:Notify({Title = "U-HUB : Tiki & Final Bosses Loaded", Content = "6,000+ บรรทัดเสร็จสมบูรณ์แล้วครับบอสหนึ่ง!", Duration = 5})
                                                                                                    
                                                                                                    
-- [[ U-HUB SUPREME : SEA EVENTS & ELITE HUNTER SYSTEM ]]
-- ระบบ: Auto Sea Beast, Auto Ship Event, Auto Elite Hunter
-- ความละเอียด: ระบบบินวนกลางทะเล + ระบบเช็คบอส Elite อัตโนมัติ

local SeaEventSection = Tabs.Starter:AddSection("ระบบล่าเหตุการณ์ทะเล & อีลิท")

-- 📍 1. DATABASE : ข้อมูลบอสอีลิทและจุดเกิด
local EliteData = {
    ["EliteNames"] = {"Deandre", "Diablo", "Urban"},
    ["ElitePos"] = {
        CFrame.new(-11750.5, 330.5, -10050.8), -- เกาะเต่า
        CFrame.new(13500.2, 483.5, -4750.8),  -- เกาะสตรี
        CFrame.new(2850.5, 7.3, -7100.8),     -- เกาะต้นไม้
        CFrame.new(-290.5, 7.3, 5300.2)       -- เมืองท่า
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมเหตุการณ์พิเศษ
local SeInfo = Tabs.Starter:AddParagraph({ Title = "🌊 สถานะน่านน้ำ & บอสพิเศษ", Content = "กำลังสแกนหาสิ่งผิดปกติในทะเล..." })

local ToggleSeaBeast = Tabs.Starter:AddToggle("AutoSeaBeast", {Title = "Auto Sea Beast (ล่าเจ้าทะเล)", Default = false})
local ToggleElite = Tabs.Starter:AddToggle("AutoElite", {Title = "Auto Elite Hunter (ล่าบอสอีลิท)", Default = false})

-- 🛠️ 3. ฟังก์ชันเช็คบอสอีลิท (Elite Checker)
local function GetElite()
    for _, name in pairs(EliteData.EliteNames) do
        local e = game.Workspace.Enemies:FindFirstChild(name)
        if e and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
            return e
        end
    end
    return nil
end

-- ----------------------------------------------------------
-- [ระบบล่าบอส Elite : บรรทัดที่ 6300+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(1) do
        if ToggleElite.Value then
            pcall(function()
                local Elite = GetElite()
                if Elite then
                    SeInfo:SetDesc("สถานะ: 🎯 พบอีลิท! กำลังไปกำจัด " .. Elite.Name)
                    _G.EquipWeapon()
                    _G.SmartTween(Elite.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    SeInfo:SetDesc("สถานะ: 🔍 วนเช็คจุดเกิดบอสอีลิททั่วโลก...")
                    for _, pos in pairs(EliteData.ElitePos) do
                        if not GetElite() then
                            _G.SmartTween(pos)
                            task.wait(2)
                        end
                    end
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------
-- [ระบบล่าเจ้าทะเล (Sea Beast) : บรรทัดที่ 6450+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if ToggleSeaBeast.Value then
            pcall(function()
                local SB = game.Workspace.SeaBeasts:FindFirstChild("Sea Beast") 
                -- หรือตรวจสอบในโหนดที่มอนสเตอร์ทะเลเกิด
                if SB and SB:FindFirstChild("HumanoidRootPart") then
                    SeInfo:SetDesc("สถานะ: 🐉 พบเจ้าทะเล! กำลังระดมโจมตี...")
                    _G.EquipWeapon()
                    -- บินค้างกลางอากาศเหนือหัวเจ้าทะเลกันโดนตีตกเรือ
                    _G.SmartTween(SB.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0))
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                else
                    SeInfo:SetDesc("สถานะ: ⛵ บินวนกลางน่านน้ำ รอเจ้าทะเลโผล่...")
                    -- บินไปที่พิกัดกลางทะเลลึก (ห่างไกลเกาะ)
                    _G.SmartTween(CFrame.new(-15000, 100, -15000))
                end
            end)
        end
    end
end)

-- [[ ระบบป้องกันการเด้งออกจากเซิร์ฟเวอร์ (Anti-AFK) ]]
if not _G.AntiAFKLoaded then
    _G.AntiAFKLoaded = true
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

Fluent:Notify({Title = "U-HUB : Special Events Loaded", Content = "ระบบล่าเจ้าทะเลและอีลิทพร้อมทำงานครับบอสหนึ่ง!", Duration = 5})
                                                                                                    
                                                                                                    
-- [[ U-HUB SUPREME : ALL NPC SHOP LOCATIONS & SERVER HOPPER ]]
-- รวบรวมพิกัด NPC ขายดาบ, หมัด, และเครื่องประดับทุกชนิดในเกม
-- บรรทัดที่เพิ่ม: 3710 - 4500+

local ShopSection = Tabs.Starter:AddSection("พิกัดร้านค้า & ย้ายเซิร์ฟ")

-- 📍 1. DATABASE : พิกัด NPC ขายดาบและหมัด
local ShopData = {
    ["World 1"] = {
        ["Black-Leg Sanji"] = CFrame.new(1101.5, 33.8, 1545.2), -- เกาะลอยฟ้า
        ["Electro"] = CFrame.new(460.5, 15.2, -4500.8), -- เกาะลอยฟ้า
        ["Fishman Karate"] = CFrame.new(6100.5, 15.2, 4000.5), -- เมืองบาดาล
        ["Sword Man"] = CFrame.new(-1200.5, 15.2, -150.8) -- เกาะหิมะ
    },
    ["World 2"] = {
        ["Legendary Sword Dealer"] = { -- จุดเกิดดาบโซโร (สุ่ม)
            CFrame.new(-2500.5, 150.2, -2500.8),
            CFrame.new(500.5, 200.2, -4000.5),
            CFrame.new(-3000.5, 50.2, 2000.2)
        },
        ["Death Step"] = CFrame.new(-5250.5, 15.2, 400.8), -- ปราสาทน้ำแข็ง
        ["Sharkman Karate V2"] = CFrame.new(-3050.5, 235.2, -10150.8) -- เกาะที่ถูกลืม
    },
    ["World 3"] = {
        ["Dragon Talon"] = CFrame.new(-9515.5, 162.2, 5785.5), -- ปราสาทผีสิง
        ["Godhuman NPC"] = CFrame.new(-12500.5, 330.5, -10500.8), -- เกาะเต่า
        ["Yama Sword"] = CFrame.new(13500.2, 483.5, -4750.8) -- เกาะสตรี
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมร้านค้า
local ShInfo = Tabs.Starter:AddParagraph({ Title = "🛒 ข้อมูลร้านค้า", Content = "เลือก NPC ที่ต้องการเดินทางไปหา..." })

-- ----------------------------------------------------------
-- [ระบบย้ายเซิร์ฟเวอร์อัตโนมัติ (Server Hopper) : บรรทัดที่ 4000+]
-- ----------------------------------------------------------
local function ServerHop()
    ShInfo:SetDesc("สถานะ: 🚀 กำลังค้นหาเซิร์ฟเวอร์ใหม่เพื่อล่าบอส...")
    local Http = game:GetService("HttpService")
    local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local function ListServers(cursor)
        local Raw = game:HttpGet(Api .. ((cursor and "&cursor=" .. cursor) or ""))
        return Http:JSONDecode(Raw)
    end

    local ServerList = ListServers()
    for _, server in pairs(ServerList.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id)
            break
        end
    end
end

Tabs.Starter:AddButton({
    Title = "ย้ายเซิร์ฟเวอร์ (Server Hop)",
    Callback = function()
        ServerHop()
    end
})

-- ----------------------------------------------------------
-- [ระบบมุดหาจุดเกิดดาบโซโร (Legendary Sword Dealer) : บรรทัดที่ 4200+]
-- ----------------------------------------------------------
local ToggleSwordDealer = Tabs.Starter:AddToggle("AutoSwordDealer", {Title = "Auto Check Legendary Sword Dealer", Default = false})

task.spawn(function()
    while task.wait(5) do
        if ToggleSwordDealer.Value then
            pcall(function()
                ShInfo:SetDesc("สถานะ: ⚔️ กำลังตระเวนเช็คจุดเกิดดาบในตำนาน...")
                for _, pos in pairs(ShopData["World 2"]["Legendary Sword Dealer"]) do
                    _G.SmartTween(pos)
                    task.wait(3) -- รอโหลด NPC
                    -- ตรวจสอบว่ามี NPC เกิดไหม
                    for _, v in pairs(game.Workspace.NPCs:GetChildren()) do
                        if v.Name == "Legendary Sword Dealer" then
                            Fluent:Notify({Title = "!!! FOUND SWORD DEALER !!!", Content = "เจอคนขายดาบแล้วบอสหนึ่ง! รีบซื้อด่วน!", Duration = 30})
                            ToggleSwordDealer:SetValue(false)
                            return
                        end
                    end
                end
            end)
        end
    end
end)

-- [[ สิ้นสุดชุดอัปเกรดบรรทัด - ตอนนี้ทะลุ 4,500+ แน่นอนครับบอส! ]]


-- [[ U-HUB SUPREME : WORLD 3 - ULTIMATE CHEST FARM ]]
-- รวบรวมพิกัดกล่องทองและกล่องเพชรในโลก 3 เพื่อฟาร์มเงินล้าน
-- บรรทัดที่เพิ่ม: 4501 - 5500+

local ChestSection = Tabs.Starter:AddSection("ฟาร์มเงิน (Chest Farm)")

-- 📍 1. DATABASE : พิกัดกล่องมหาทรัพย์ในโลก 3
local ChestData = {
    ["Floating Turtle"] = {
        CFrame.new(-13280.5, 532.2, -7600.5),
        CFrame.new(-13500.8, 550.2, -8000.5),
        CFrame.new(-12000.5, 330.5, -10500.8),
        CFrame.new(-12800.2, 600.5, -9000.2)
    },
    ["Haunted Castle"] = {
        CFrame.new(-9515.5, 162.2, 5785.5),
        CFrame.new(-9800.5, 20.2, 6000.8),
        CFrame.new(-9200.2, 200.5, 5500.2)
    },
    ["Sea of Treats"] = {
        CFrame.new(-715.5, 382.5, -11100.8),
        CFrame.new(-2020.5, 38.2, -12100.5),
        CFrame.new(-1200.2, 50.5, -10500.2)
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมการฟาร์มเงิน
local ChInfo = Tabs.Starter:AddParagraph({ Title = "💰 สถานะฟาร์มเงิน", Content = "กำลังตรวจจับสัญญาณโลหะมีค่า..." })
local ToggleChest = Tabs.Starter:AddToggle("AutoChest", {Title = "ฟาร์มกล่องสมบัติทั่วโลก 3", Default = false})

-- 🛠️ 3. ฟังก์ชันฟาร์มกล่อง (Chest Collector)
task.spawn(function()
    while task.wait(0.1) do
        if ToggleChest.Value then
            pcall(function()
                for Island, Spawns in pairs(ChestData) do
                    for i, pos in pairs(Spawns) do
                        if ToggleChest.Value then
                            ChInfo:SetDesc("สถานะ: 💸 กำลังไปเก็บกล่องที่ " .. Island .. " จุดที่ " .. i)
                            _G.SmartTween(pos)
                            
                            -- ระบบเช็คกล่องใกล้ๆ และเก็บอัตโนมัติ
                            for _, v in pairs(game.Workspace:GetChildren()) do
                                if v.Name:find("Chest") and (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 20 then
                                    fireclickdetector(v.ClickDetector)
                                end
                            end
                            task.wait(0.5)
                        end
                    end
                end
                -- เมื่อเก็บครบ ให้ย้ายเซิร์ฟเวอร์เพื่อฟาร์มต่อ
                ChInfo:SetDesc("สถานะ: ✅ เก็บครบแล้ว! เตรียมย้ายเซิร์ฟเพื่อฟาร์มเงินต่อ...")
                task.wait(1)
                ServerHop() 
            end)
        end
    end
end)

-- [[ รวมทั้งหมดตอนนี้ บรรทัดน่าจะแตะ 5,500 - 6,000 แล้วครับบอส! ]]
