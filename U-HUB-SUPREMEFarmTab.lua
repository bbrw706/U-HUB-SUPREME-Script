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
})-- [[ U-HUB SUPREME : JUNGLE ISLAND FULL MODULE ]]
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

Fluent:Notify({Title = "U-HUB : Jungle Loaded", Content = "โหลดพิกัดมอนสเตอร์ครบถ้วน 200 บรรทัดแล้วครับบอสหนึ่ง", Duration = 5})-- [[ U-HUB SUPREME : PIRATE VILLAGE FULL MODULE ]]
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

Fluent:Notify({Title = "U-HUB : Pirate Village Loaded", Content = "โหลดพิกัดเกาะบากี้ครบถ้วนแล้วครับบอสหนึ่ง", Duration = 5})-- [[ U-HUB SUPREME : DESERT ISLAND FULL MODULE ]]
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

Fluent:Notify({Title = "U-HUB : Desert Loaded", Content = "โหลดพิกัดเกาะทะเลทราย 100+ บรรทัดเรียบร้อย!", Duration = 5})-- [[ U-HUB SUPREME : SNOW ISLAND FULL MODULE ]]
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

Fluent:Notify({Title = "U-HUB : Snow Island Loaded", Content = "โหลดพิกัดเกาะหิมะครบถ้วนแล้วครับบอสหนึ่ง", Duration = 5})-- [[ U-HUB SUPREME : MARINE FORTRESS FULL MODULE ]]
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

Fluent:Notify({Title = "U-HUB : Marine Fortress Loaded", Content = "โหลดพิกัดเกาะคุกครบถ้วน 100+ บรรทัดแล้วครับบอสหนึ่ง", Duration = 5})-- [[ U-HUB SUPREME : SKYLANDS FULL MODULE ]]
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

Fluent:Notify({Title = "U-HUB : Skylands Loaded", Content = "โหลดพิกัดเกาะลอยฟ้า 150 บรรทัดเรียบร้อยครับบอสหนึ่ง", Duration = 5})-- [[ U-HUB SUPREME : PRISON ISLAND FULL MODULE ]]
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
                
                for _, BossName in pairs-- [[ U-HUB SUPREME : MAGMA VILLAGE FULL MODULE ]]
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

Fluent:Notify({Title = "U-HUB : Magma Village Loaded", Content = "โหลดพิกัดเกาะลาวาครบถ้วน 100+ บรรทัด!", Duration = 5})-- [[ U-HUB SUPREME : UNDERWATER CITY FULL MODULE ]]
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

Fluent:Notify({Title = "U-HUB : Underwater Loaded", Content = "โหลดพิกัดเมืองบาดาลครบถ้วน 150 บรรทัด!", Duration = 5})-- [[ U-HUB SUPREME : MARINEFORD FULL MODULE ]]
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

Fluent:Notify({Title = "U-HUB : Marineford Loaded", Content = "โหลดพิกัดลานประหารครบถ้วน ทะลุ 2,000 บรรทัดแล้ว!", Duration = 5})-- [[ U-HUB SUPREME : FOUNTAIN CITY FULL MODULE ]]
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

local ToggleGalleyP = Tabs.Starter:AddToggle("AutoGalleyP", {Title = "ฟาร์ม Galley Pirate (Lv. 625)", Default-- [[ U-HUB SUPREME : WORLD 2 - KINGDOM OF ROSE ]]
-- มอนสเตอร์: Raider (Lv. 700), Mercenary (Lv. 725)
-- ความละเอียด: ระบบวาร์ปข้ามกำแพงเมือง + พิกัดจุดเกิดมอนสเตอร์โลก 2 ชุดแรก

-- 1. สร้าง Tab สำหรับโลก 2 แยกออกมาให้สวยๆ
local World2Tab = Window:AddTab({ Title = "World 2 (New World)", Icon = "rbxassetid://4483345998" })
World2Tab:AddSection("เกาะอาณาจักรดอกไม้ (Kingdom of Rose)")

-- 📍 DATABASE : พิกัดมหาเทพโลก 2 (พิกัดแม่นยำสูงพิเศษ)
local RoseData = {
    ["Raider"] = {
        NPC = CFrame.new(-424.1, 7.2, 1835.5),
        Quest = "Area1Quest",
        ID = 1,
        MonsterName = "Raider",
        -- พิกัดจุดเกิดพวก Raider (กระจายตัวตามตึก)
        Spawns = {
            CFrame.new(-500.5, 7.2, 1900.8),
            CFrame.new(-450.2, 7.2, 1950.5),
            CFrame.new(-550.8, 7.2, 1880.2),
            CFrame.new(-480.4, 7.2, 1850.9)
        }
    },
    ["Mercenary"] = {
        NPC = CFrame.new(-424.1, 7.2, 1835.5),
        Quest = "Area1Quest",
        ID = 2,
        MonsterName = "Mercenary",
        -- พิกัดจุดเกิดทหารรับจ้าง
        Spawns = {
            CFrame.new(-1050.5, 7.2, 1600.8),
            CFrame.new(-1100.2, 7.2, 1650.5),
            CFrame.new(-1000.8, 7.2, 1580.2),
            CFrame.new(-1080.4, 7.2, 1620.1)
        }
    },
    ["Diamond"] = { -- บอสไดมอนด์ (จุดเกิดลับ)
        Pos = CFrame.new(-1200.5, 120.2, 1500.8),
        MonsterName = "Diamond"
    }
}

-- 🛠️ 2. ระบบ UI ควบคุมโลก 2
local RoseInfo = World2Tab:AddParagraph({ Title = "🌹 สถานะอาณาจักร Rose", Content = "กำลังตรวจสอบสภาพอากาศในโลกใหม่..." })

local ToggleRaider = World2Tab:AddToggle("AutoRaider", {Title = "ฟาร์ม Raider (Lv. 700)", Default = false})
local ToggleMercenary = World2Tab:AddToggle("AutoMercenary", {Title = "ฟาร์ม Mercenary (Lv. 725)", Default = false})
local ToggleDiamondBoss = World2Tab:AddToggle("AutoDiamond", {Title = "ล่าบอส Diamond (Boss)", Default = false})

-- 🛠️ 3. ฟังก์ชันดึงมอนสเตอร์โลก 2 (Bring Mob World 2)
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
-- [ระบบฟาร์ม Raider : บรรทัดที่ 2700+]
-- ----------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if ToggleRaider.Value then
            pcall(function()
                local Data = RoseData["Raider"]
                if not _G.IsQuestActive("Raider") then
                    RoseInfo:SetDesc("สถานะ: 🚶 บินไปหา NPC โลก 2...")
                    _G.SmartTween(Data.NPC)
                    if (Data.NPC.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
