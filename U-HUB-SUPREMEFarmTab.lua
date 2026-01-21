-- [[ U-HUB SUPREME : FARM MODULE V2 ]]
local Window = _G.Window
local Fluent = _G.Fluent

-- 📍 [1. ตู้เก็บข้อมูลมอนสเตอร์] แยกไว้ตรงนี้เพื่อให้แก้ง่ายๆ
local MonsterData = {
    ["Monkey (Level 1)"] = CFrame.new(-1613, 36, 147),
    ["Gorilla (Level 10)"] = CFrame.new(-1250, 6, 450),
    ["Pirate (Level 20)"] = CFrame.new(-1145, 14, 3852) -- เพิ่มได้เรื่อยๆ เลยครับ
}

-- สร้างลิสต์ชื่อมอนสเตอร์เอาไว้ใส่ในเมนู
local MonsterList = {}
for Name, _ in pairs(MonsterData) do
    table.insert(MonsterList, Name)
end

-- [[ 2. สร้างหน้าเมนู ]]
local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "rbxassetid://4483345998" })
}

-- [[ 3. ตัวเลือกมอนสเตอร์ (Dropdown) ]]
local Dropdown = Tabs.Main:AddDropdown("SelectedMonster", {
    Title = "เลือกมอนสเตอร์ที่ต้องการ",
    Values = MonsterList,
    Multi = false,
    Default = 1,
})

Dropdown:OnChanged(function(Value)
    _G.TargetMonster = Value -- จำไว้ว่าบอสหนึ่งเลือกตัวไหน
end)

-- [[ 4. ปุ่มเปิด/ปิดฟาร์ม ]]
local Toggle = Tabs.Main:AddToggle("AutoFarm", {Title = "เริ่มฟาร์ม (Auto Farm)", Default = false})

Toggle:OnChanged(function()
    _G.AutoFarm = Toggle.Value
end)

-- [[ 5. ระบบบิน (Tween) ]]
_G.TweenSpeed = 300
local function TweenTo(TargetCFrame)
    local Character = game.Players.LocalPlayer.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local Distance = (TargetCFrame.Position - Character.HumanoidRootPart.Position).Magnitude
        local Info = TweenInfo.new(Distance / _G.TweenSpeed, Enum.EasingStyle.Linear)
        local Tween = game:GetService("TweenService"):Create(Character.HumanoidRootPart, Info, {CFrame = TargetCFrame})
        Tween:Play()
    end
end

-- [[ 6. ระบบฟาร์ม (Loop) ]]
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm and _G.TargetMonster then
            pcall(function()
                -- ไปหยิบพิกัดจาก "ตู้เก็บข้อมูล" ตามชื่อที่เลือกใน Dropdown
                local TargetPos = MonsterData[_G.TargetMonster]
                
                if TargetPos then
                    TweenTo(TargetPos) -- บินไป
                    -- สั่งยิงดาเมจ (Fast Attack)
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("Combat", "Attack")
                end
            end)
        end
    end
end)
