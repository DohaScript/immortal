-- ImmortalHub.lua (Ultimate Media & Combat Edition v4)
pcall(function()
    local old = (gethui and gethui():FindFirstChild("ImmortalHub")) or game:GetService("CoreGui"):FindFirstChild("ImmortalHub") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ImmortalHub")
    if old then old:Destroy() end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function GetCamera()
    return workspace.CurrentCamera
end

local TargetParent = (gethui and gethui()) or game:GetService("CoreGui")

local CFG = {
    AimEnabled = false, AimPart = "Head", AimFOV = 150, Smoothness = 5, TeamCheck = false,
    Spinbot = false,
    HitboxEnabled = false, HitboxSize = 6, HitboxVis = false,
    ESP_Box = false, ESP_Name = false, ESP_Health = false, ESP_Dist = false, Tracers = false, Crosshair = false,
    Speed = false, SpeedVal = 32, Jump = false, JumpVal = 80, 
    Bhop = false, Noclip = false, InfJump = false, 
    GravityEnabled = false, GravityVal = 196.2, CamFOVEnabled = false, CamFOVVal = 70,
    Accent = Color3.fromRGB(124, 58, 237),
    BgColor = Color3.fromRGB(244, 245, 248),
    BgTrans = 0,
    MenuWidth = 580,
    MenuHeight = 400,
    HitmarkerEnabled = false,
    HitSoundID = "",
    KillSoundID = "",
    MusicID = "",
    MusicPitch = 1,
    MusicVolume = 1
}

local ThemeText, ThemeBg, ThemeStroke, ToggleCallbacks = {}, {}, {}, {}
local function RegText(obj) table.insert(ThemeText, obj) return obj end
local function RegBg(obj) table.insert(ThemeBg, obj) return obj end
local function RegStroke(obj) table.insert(ThemeStroke, obj) return obj end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImmortalHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

local HitSound = Instance.new("Sound", ScreenGui)
local KillSound = Instance.new("Sound", ScreenGui)
local BoomboxSound = Instance.new("Sound", ScreenGui)
BoomboxSound.Looped = true

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.Color = CFG.Accent
FOVCircle.Filled = false
FOVCircle.Radius = CFG.AimFOV

local CrosshairFrame = Instance.new("Frame", ScreenGui)
CrosshairFrame.Size = UDim2.new(0, 16, 0, 16)
CrosshairFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CrosshairFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
CrosshairFrame.BackgroundTransparency = 1
CrosshairFrame.Visible = false

local CH_V = Instance.new("Frame", CrosshairFrame)
CH_V.Size = UDim2.new(0, 2, 1, 0)
CH_V.Position = UDim2.new(0.5, -1, 0, 0)
CH_V.BorderSizePixel = 0
CH_V.BackgroundColor3 = CFG.Accent
RegBg(CH_V)

local CH_H = Instance.new("Frame", CrosshairFrame)
CH_H.Size = UDim2.new(1, 0, 0, 2)
CH_H.Position = UDim2.new(0, 0, 0.5, -1)
CH_H.BorderSizePixel = 0
CH_H.BackgroundColor3 = CFG.Accent
RegBg(CH_H)

local HitmarkerGui = Instance.new("Frame", ScreenGui)
HitmarkerGui.Size = UDim2.new(0, 20, 0, 20)
HitmarkerGui.AnchorPoint = Vector2.new(0.5, 0.5)
HitmarkerGui.Position = UDim2.new(0.5, 0, 0.5, 0)
HitmarkerGui.BackgroundTransparency = 1
HitmarkerGui.Visible = false

local HM_1 = Instance.new("Frame", HitmarkerGui)
HM_1.Size = UDim2.new(0, 8, 0, 2)
HM_1.Position = UDim2.new(0, 0, 0, 0)
HM_1.BorderSizePixel = 0
RegBg(HM_1)

local HM_2 = Instance.new("Frame", HitmarkerGui)
HM_2.Size = UDim2.new(0, 8, 0, 2)
HM_2.Position = UDim2.new(0, 12, 0, 0)
HM_2.BorderSizePixel = 0
RegBg(HM_2)

local HM_3 = Instance.new("Frame", HitmarkerGui)
HM_3.Size = UDim2.new(0, 8, 0, 2)
HM_3.Position = UDim2.new(0, 0, 0, 18)
HM_3.BorderSizePixel = 0
RegBg(HM_3)

local HM_4 = Instance.new("Frame", HitmarkerGui)
HM_4.Size = UDim2.new(0, 8, 0, 2)
HM_4.Position = UDim2.new(0, 12, 0, 18)
HM_4.BorderSizePixel = 0
RegBg(HM_4)

local function TriggerHitmarker()
    if not CFG.HitmarkerEnabled then return end
    HitmarkerGui.Visible = true
    if CFG.HitSoundID ~= "" then
        local id = tonumber(CFG.HitSoundID) or CFG.HitSoundID
        HitSound.SoundId = "rbxassetid://" .. tostring(id)
        HitSound:Play()
    end
    task.delay(0.1, function()
        HitmarkerGui.Visible = false
    end)
end

local function UpdateTheme(newColor)
    CFG.Accent = newColor
    FOVCircle.Color = newColor
    for _, obj in ipairs(ThemeText) do pcall(function() obj.TextColor3 = newColor end) end
    for _, obj in ipairs(ThemeBg) do pcall(function() obj.BackgroundColor3 = newColor end) end
    for _, obj in ipairs(ThemeStroke) do pcall(function() obj.Color = newColor end) end
    for _, cb in ipairs(ToggleCallbacks) do pcall(cb) end
end

local ImmortalButton = Instance.new("TextButton", ScreenGui)
ImmortalButton.Size = UDim2.new(0, 48, 0, 48)
ImmortalButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ImmortalButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImmortalButton.Text = "⚡"
ImmortalButton.Font = Enum.Font.GothamBold
ImmortalButton.TextSize = 18
ImmortalButton.Draggable = true
RegText(ImmortalButton)
Instance.new("UICorner", ImmortalButton).CornerRadius = UDim.new(0, 12)
local s = Instance.new("UIStroke", ImmortalButton) s.Color = Color3.fromRGB(210, 215, 225)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, CFG.MenuWidth, 0, CFG.MenuHeight)
MainFrame.Position = UDim2.new(0.5, -CFG.MenuWidth/2, 0.5, -CFG.MenuHeight/2)
MainFrame.BackgroundColor3 = CFG.BgColor
MainFrame.BackgroundTransparency = CFG.BgTrans
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
local ms = Instance.new("UIStroke", MainFrame) ms.Color = Color3.fromRGB(210, 215, 225)

ImmortalButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

local TopHeader = Instance.new("Frame", MainFrame)
TopHeader.Size = UDim2.new(1, 0, 0, 50)
TopHeader.BackgroundTransparency = 1

local TitleLabel = Instance.new("TextLabel", TopHeader)
TitleLabel.Size = UDim2.new(0, 150, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Text = "IMMORTAL HUB"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.TextColor3 = Color3.fromRGB(40, 45, 55)
TitleLabel.BackgroundTransparency = 1

local NavPill = Instance.new("Frame", TopHeader)
NavPill.Size = UDim2.new(0, 310, 0, 32)
NavPill.Position = UDim2.new(1, -325, 0.5, -16)
NavPill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", NavPill).CornerRadius = UDim.new(0, 16)
local ns = Instance.new("UIStroke", NavPill) ns.Color = Color3.fromRGB(220, 225, 235)

local NavLayout = Instance.new("UIListLayout", NavPill)
NavLayout.FillDirection = Enum.FillDirection.Horizontal
NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavLayout.VerticalAlignment = Enum.VerticalAlignment.Center
NavLayout.Padding = UDim.new(0, 4)

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -20, 1, -60)
ContentArea.Position = UDim2.new(0, 10, 0, 55)
ContentArea.BackgroundTransparency = 1

local Tabs = {}
local activeTabBtn = nil

local function CreateTab(name)
    local Page = Instance.new("Frame", ContentArea)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false

    local Btn = Instance.new("TextButton", NavPill)
    Btn.Size = UDim2.new(0, 55, 0, 24)
    Btn.BackgroundTransparency = 1
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(120, 125, 140)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 10
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 12)

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Btn.TextColor3 = Color3.fromRGB(120, 125, 140)
            t.Btn.BackgroundTransparency = 1
        end
        Page.Visible = true
        activeTabBtn = Btn
        Btn.TextColor3 = CFG.Accent
        Btn.BackgroundColor3 = Color3.fromRGB(240, 243, 250)
        Btn.BackgroundTransparency = 0
    end)

    Tabs[name] = {Page = Page, Btn = Btn}
    return Page
end

local function CreateSection(parent, title, size, pos)
    local Sec = Instance.new("Frame", parent)
    Sec.Size = size
    Sec.Position = pos
    Sec.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", Sec) s.Color = Color3.fromRGB(220, 225, 235) s.Thickness = 1

    local SecTitle = Instance.new("TextLabel", Sec)
    SecTitle.Size = UDim2.new(1, -20, 0, 24)
    SecTitle.Position = UDim2.new(0, 12, 0, 8)
    SecTitle.Text = title
    SecTitle.TextColor3 = Color3.fromRGB(30, 35, 45)
    SecTitle.Font = Enum.Font.GothamBold
    SecTitle.TextSize = 12
    SecTitle.TextXAlignment = Enum.TextXAlignment.Left
    SecTitle.BackgroundTransparency = 1

    local Container = Instance.new("ScrollingFrame", Sec)
    Container.Size = UDim2.new(1, -16, 1, -38)
    Container.Position = UDim2.new(0, 8, 0, 34)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 3
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)

    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 6)
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)

    return Container
end

local function AddToggle(parent, text, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 24)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -38, 1, 0)
    Label.Position = UDim2.new(0, 4, 0, 0)
    Label.Text = text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextColor3 = Color3.fromRGB(50, 55, 65)
    Label.BackgroundTransparency = 1

    local SwitchTrack = Instance.new("TextButton", Frame)
    SwitchTrack.Size = UDim2.new(0, 28, 0, 16)
    SwitchTrack.Position = UDim2.new(1, -30, 0.5, -8)
    SwitchTrack.Text = ""
    SwitchTrack.AutoButtonColor = false
    Instance.new("UICorner", SwitchTrack).CornerRadius = UDim.new(1, 0)

    local SwitchKnob = Instance.new("Frame", SwitchTrack)
    SwitchKnob.Size = UDim2.new(0, 12, 0, 12)
    SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SwitchKnob.BorderSizePixel = 0
    Instance.new("UICorner", SwitchKnob).CornerRadius = UDim.new(1, 0)

    local st = default
    local function updateVisuals()
        if st then
            SwitchTrack.BackgroundColor3 = CFG.Accent
            SwitchKnob.Position = UDim2.new(0, 14, 0.5, -6)
        else
            SwitchTrack.BackgroundColor3 = Color3.fromRGB(210, 215, 225)
            SwitchKnob.Position = UDim2.new(0, 2, 0.5, -6)
        end
    end

    table.insert(ToggleCallbacks, updateVisuals)
    updateVisuals()

    SwitchTrack.MouseButton1Click:Connect(function()
        st = not st
        updateVisuals()
        callback(st)
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -4, 0, 32)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 0, 14)
    Label.Position = UDim2.new(0, 4, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(110, 115, 130)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local ValLabel = Instance.new("TextLabel", Frame)
    ValLabel.Size = UDim2.new(0.3, 0, 0, 14)
    ValLabel.Position = UDim2.new(0.7, -4, 0, 0)
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 10
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.BackgroundTransparency = 1
    RegText(ValLabel)

    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, -8, 0, 5)
    Bar.Position = UDim2.new(0, 4, 0, 20)
    Bar.BackgroundColor3 = Color3.fromRGB(225, 230, 240)
    Bar.BorderSizePixel = 0
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BorderSizePixel = 0
    RegBg(Fill)
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Btn = Instance.new("TextButton", Bar)
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""

    local function SetValue(val)
        val = math.clamp(math.floor(val), min, max)
        local pos = (val - min) / (max - min)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        ValLabel.Text = tostring(val)
        callback(val)
    end

    SetValue(default)

    local dragging = false
    Btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            SetValue(min + (max - min) * pos)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            SetValue(min + (max - min) * pos)
        end
    end)
end

local function AddTextBox(parent, placeholder, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -4, 0, 30)
    Frame.BackgroundTransparency = 1

    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(1, 0, 1, 0)
    Box.BackgroundColor3 = Color3.fromRGB(240, 243, 250)
    Box.PlaceholderText = placeholder
    Box.Text = ""
    Box.Font = Enum.Font.GothamMedium
    Box.TextSize = 11
    Box.TextColor3 = Color3.fromRGB(40, 45, 55)
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
    local st = Instance.new("UIStroke", Box) st.Color = Color3.fromRGB(220, 225, 235)

    Box.FocusLost:Connect(function(enter)
        if enter then
            callback(Box.Text)
        end
    end)
end

local CombatTab = CreateTab("Combat")
local VisTab = CreateTab("Visuals")
local MoveTab = CreateTab("Movement")
local MusicTab = CreateTab("Music")
local ThemeTab = CreateTab("Themes")

Tabs["Combat"].Page.Visible = true
activeTabBtn = Tabs["Combat"].Btn
Tabs["Combat"].Btn.TextColor3 = CFG.Accent
Tabs["Combat"].Btn.BackgroundColor3 = Color3.fromRGB(240, 243, 250)
Tabs["Combat"].Btn.BackgroundTransparency = 0

-- Combat Section
local CombSec1 = CreateSection(CombatTab, "Aimbot & Hits", UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local CombSec2 = CreateSection(CombatTab, "Hitbox Expander", UDim2.new(0.49, 0, 1, 0), UDim2.new(0.51, 0, 0, 0))

AddToggle(CombSec1, "Enable Aimbot", CFG.AimEnabled, function(v) CFG.AimEnabled = v FOVCircle.Visible = v end)
AddSlider(CombSec1, "Smoothness", 1, 20, CFG.Smoothness, function(v) CFG.Smoothness = v end)
AddSlider(CombSec1, "FOV Radius", 40, 400, CFG.AimFOV, function(v) CFG.AimFOV = v FOVCircle.Radius = v end)
AddToggle(CombSec1, "Team Check", CFG.TeamCheck, function(v) CFG.TeamCheck = v end)

AddToggle(CombSec1, "Custom Hitmarker", CFG.HitmarkerEnabled, function(v) CFG.HitmarkerEnabled = v end)
AddTextBox(CombSec1, "Hit Sound ID (Audio)", function(txt) CFG.HitSoundID = txt end)
AddTextBox(CombSec1, "Kill Sound ID (Audio)", function(txt) CFG.KillSoundID = txt end)

local TargetBtn = Instance.new("TextButton", CombSec2)
TargetBtn.Size = UDim2.new(1, -8, 0, 26)
TargetBtn.BackgroundColor3 = Color3.fromRGB(240, 243, 250)
TargetBtn.Text = "Target Part: " .. CFG.AimPart
TargetBtn.Font = Enum.Font.GothamMedium
TargetBtn.TextSize = 11
RegText(TargetBtn)
Instance.new("UICorner", TargetBtn).CornerRadius = UDim.new(0, 6)
TargetBtn.MouseButton1Click:Connect(function()
    CFG.AimPart = (CFG.AimPart == "Head") and "HumanoidRootPart" or "Head"
    TargetBtn.Text = "Target Part: " .. CFG.AimPart
end)

AddToggle(CombSec2, "Hitbox Expander", CFG.HitboxEnabled, function(v) CFG.HitboxEnabled = v end)
AddSlider(CombSec2, "Hitbox Size", 2, 25, CFG.HitboxSize, function(v) CFG.HitboxSize = v end)
AddToggle(CombSec2, "Glow Expander (Cyber)", CFG.HitboxVis, function(v) CFG.HitboxVis = v end)

-- Visuals Section
local VisSec1 = CreateSection(VisTab, "ESP Elements", UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local VisSec2 = CreateSection(VisTab, "Screen Overlay", UDim2.new(0.49, 0, 1, 0), UDim2.new(0.51, 0, 0, 0))

AddToggle(VisSec1, "Corner Box ESP", CFG.ESP_Box, function(v) CFG.ESP_Box = v end)
AddToggle(VisSec1, "Name ESP", CFG.ESP_Name, function(v) CFG.ESP_Name = v end)
AddToggle(VisSec1, "Health Bar", CFG.ESP_Health, function(v) CFG.ESP_Health = v end)
AddToggle(VisSec1, "Distance ESP", CFG.ESP_Dist, function(v) CFG.ESP_Dist = v end)
AddToggle(VisSec2, "Tracers (Snaplines)", CFG.Tracers, function(v) CFG.Tracers = v end)
AddToggle(VisSec2, "Custom Crosshair", CFG.Crosshair, function(v) CrosshairFrame.Visible = v CFG.Crosshair = v end)
AddToggle(VisSec2, "Custom Cam FOV", CFG.CamFOVEnabled, function(v) CFG.CamFOVEnabled = v end)
AddSlider(VisSec2, "Camera FOV Value", 70, 120, CFG.CamFOVVal, function(v) CFG.CamFOVVal = v end)

-- Movement Section
local MoveSec1 = CreateSection(MoveTab, "Speed & Jump", UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local MoveSec2 = CreateSection(MoveTab, "Tricks & Physics", UDim2.new(0.49, 0, 1, 0), UDim2.new(0.51, 0, 0, 0))

AddToggle(MoveSec1, "WalkSpeed Hack", CFG.Speed, function(v) CFG.Speed = v end)
AddSlider(MoveSec1, "Speed Value", 16, 150, CFG.SpeedVal, function(v) CFG.SpeedVal = v end)
AddToggle(MoveSec1, "Jump Boost", CFG.Jump, function(v) CFG.Jump = v end)
AddSlider(MoveSec1, "Jump Value", 50, 250, CFG.JumpVal, function(v) CFG.JumpVal = v end)

AddToggle(MoveSec2, "Auto Bhop (Auto Jump)", CFG.Bhop, function(v) CFG.Bhop = v end)
AddToggle(MoveSec2, "Infinite Jump", CFG.InfJump, function(v) CFG.InfJump = v end)
AddToggle(MoveSec2, "Spinbot", CFG.Spinbot, function(v) CFG.Spinbot = v end)
AddToggle(MoveSec2, "Noclip", CFG.Noclip, function(v) CFG.Noclip = v end)
AddToggle(MoveSec2, "Custom Gravity", CFG.GravityEnabled, function(v) CFG.GravityEnabled = v end)
AddSlider(MoveSec2, "Gravity Level", 0, 300, CFG.GravityVal, function(v) CFG.GravityVal = v end)

-- Music Section
local MusicSec = CreateSection(MusicTab, "Boombox Player", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))

AddTextBox(MusicSec, "Enter Music ID (Audio)", function(txt)
    CFG.MusicID = txt
    local id = tonumber(txt) or txt
    BoomboxSound.SoundId = "rbxassetid://" .. tostring(id)
    BoomboxSound:Play()
end)

AddToggle(MusicSec, "Play / Pause Music", false, function(v)
    if v then
        if CFG.MusicID ~= "" then BoomboxSound:Play() end
    else
        BoomboxSound:Pause()
    end
end)

AddSlider(MusicSec, "Music Volume", 0, 100, 100, function(v)
    CFG.MusicVolume = v / 100
    BoomboxSound.Volume = CFG.MusicVolume
end)

AddSlider(MusicSec, "Music Pitch (Speed)", 50, 200, 100, function(v)
    CFG.MusicPitch = v / 100
    BoomboxSound.PlaybackSpeed = CFG.MusicPitch
end)

-- Themes Section
local ThemeSec1 = CreateSection(ThemeTab, "Color Presets", UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local ThemeSec2 = CreateSection(ThemeTab, "Menu Customizer", UDim2.new(0.49, 0, 1, 0), UDim2.new(0.51, 0, 0, 0))

local colors = {
    {"Purple Accent", Color3.fromRGB(124, 58, 237)},
    {"Blue Accent", Color3.fromRGB(37, 99, 235)},
    {"Green Accent", Color3.fromRGB(16, 185, 129)},
    {"Red Accent", Color3.fromRGB(239, 68, 68)},
    {"Orange Accent", Color3.fromRGB(249, 115, 22)},
    {"Dark Neutral", Color3.fromRGB(50, 55, 65)}
}
for _, col in ipairs(colors) do
    local btn = Instance.new("TextButton", ThemeSec1)
    btn.Size = UDim2.new(1, -8, 0, 28)
    btn.BackgroundColor3 = col[2]
    btn.Text = col[1]
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() UpdateTheme(col[2]) end)
end

AddSlider(ThemeSec2, "Menu Transparency", 0, 80, 0, function(v)
    CFG.BgTrans = v / 100
    MainFrame.BackgroundTransparency = CFG.BgTrans
end)

AddSlider(ThemeSec2, "Menu Width", 450, 700, 580, function(v)
    CFG.MenuWidth = v
    MainFrame.Size = UDim2.new(0, CFG.MenuWidth, 0, CFG.MenuHeight)
end)

AddSlider(ThemeSec2, "Menu Height", 300, 500, 400, function(v)
    CFG.MenuHeight = v
    MainFrame.Size = UDim2.new(0, CFG.MenuWidth, 0, CFG.MenuHeight)
end)

-- НОВЫЙ ИДЕАЛЬНЫЙ ESP (Написан с нуля)
local ESP_List = {}

local function CreateESP(player)
    if ESP_List[player] then return end
    local drawings = {
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        HealthBg = Drawing.new("Line"),
        Health = Drawing.new("Line"),
        Dist = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }

    drawings.Box.Thickness = 1.5
    drawings.Box.Filled = false
    drawings.BoxOutline.Thickness = 2.5
    drawings.BoxOutline.Color = Color3.fromRGB(0, 0, 0)
    drawings.BoxOutline.Filled = false

    drawings.Name.Size = 13
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Name.Color = Color3.fromRGB(255, 255, 255)

    drawings.Dist.Size = 12
    drawings.Dist.Center = true
    drawings.Dist.Outline = true
    drawings.Dist.Color = Color3.fromRGB(220, 220, 220)

    drawings.HealthBg.Thickness = 3
    drawings.Health.Thickness = 1.5

    drawings.Tracer.Thickness = 1.5

    ESP_List[player] = drawings
end

Players.PlayerRemoving:Connect(function(player)
    if ESP_List[player] then
        for _, obj in pairs(ESP_List[player]) do pcall(function() obj:Remove() end) end
        ESP_List[player] = nil
    end
end)

local TrackedHealth = {}
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local lastHp = TrackedHealth[player] or hum.MaxHealth
                if hum.Health < lastHp then
                    TriggerHitmarker()
                    if hum.Health <= 0 and lastHp > 0 and CFG.KillSoundID ~= "" then
                        local kid = tonumber(CFG.KillSoundID) or CFG.KillSoundID
                        KillSound.SoundId = "rbxassetid://" .. tostring(kid)
                        KillSound:Play()
                    end
                end
                TrackedHealth[player] = hum.Health
            end
        end
    end
end)

-- MAIN ENGINE LOOP
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local cam = GetCamera()
    if not cam then return end

    if FOVCircle.Visible then
        FOVCircle.Position = cam.ViewportSize / 2
    end

    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if hum then
        if CFG.Speed then hum.WalkSpeed = CFG.SpeedVal end
        if CFG.Jump then
            pcall(function() hum.JumpPower = CFG.JumpVal end)
            pcall(function() hum.JumpHeight = CFG.JumpVal / 3 end)
        end

        if CFG.Bhop then
            if hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end

    workspace.Gravity = CFG.GravityEnabled and CFG.GravityVal or 196.2
    if CFG.CamFOVEnabled then cam.FieldOfView = CFG.CamFOVVal end

    if CFG.Spinbot and root then
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(55), 0)
    end

    if CFG.Noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    -- УЛУЧШЕННЫЙ GLOW EXPANDER (Мягкое кибернетическое свечение)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local pRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if pRoot then
                if CFG.HitboxEnabled then
                    pRoot.Size = Vector3.new(CFG.HitboxSize, CFG.HitboxSize, CFG.HitboxSize)
                    pRoot.CanCollide = false
                    pRoot.Transparency = CFG.HitboxVis and 0.45 or 1
                    if CFG.HitboxVis then
                        pRoot.Material = Enum.Material.Neon -- Настоящий неоновый Glow-эффект
                        pRoot.Color = CFG.Accent
                    end
                else
                    pRoot.Size = Vector3.new(2, 2, 1)
                    pRoot.Transparency = 1
                end
            end
        end
    end

    -- НОВЫЙ ЧЕТКИЙ И ТОЧНЫЙ ESP (Корректное отображение под любым FOV)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not ESP_List[player] then CreateESP(player) end
            local d = ESP_List[player]
            local pChar = player.Character
            local pRoot = pChar and pChar:FindFirstChild("HumanoidRootPart")
            local pHum = pChar and pChar:FindFirstChildOfClass("Humanoid")

            local visible = false
            if pChar and pRoot and pHum and pHum.Health > 0 then
                local head = pChar:FindFirstChild("Head")
                local topWorld = head and (head.Position + Vector3.new(0, 0.7, 0)) or (pRoot.Position + Vector3.new(0, 2, 0))
                local bottomWorld = pRoot.Position - Vector3.new(0, 2.7, 0)

                local topVector, topOnScreen = cam:WorldToViewportPoint(topWorld)
                local botVector, botOnScreen = cam:WorldToViewportPoint(bottomWorld)

                if topOnScreen or botOnScreen then
                    visible = true
                    local height = math.abs(botVector.Y - topVector.Y)
                    local width = height / 2
                    local pos = Vector2.new(botVector.X - width / 2, topVector.Y)

                    if CFG.ESP_Box then
                        d.BoxOutline.Size = Vector2.new(width, height)
                        d.BoxOutline.Position = pos
                        d.BoxOutline.Visible = true

                        d.Box.Size = Vector2.new(width, height)
                        d.Box.Position = pos
                        d.Box.Color = CFG.Accent
                        d.Box.Visible = true
                    else
                        d.Box.Visible = false
                        d.BoxOutline.Visible = false
                    end

                    if CFG.ESP_Name then
                        d.Name.Text = player.Name
                        d.Name.Position = Vector2.new(pos.X + width / 2, pos.Y - 16)
                        d.Name.Visible = true
                    else
                        d.Name.Visible = false
                    end

                    if CFG.ESP_Health then
                        local hpPct = math.clamp(pHum.Health / pHum.MaxHealth, 0, 1)
                        d.HealthBg.From = Vector2.new(pos.X - 6, pos.Y)
                        d.HealthBg.To = Vector2.new(pos.X - 6, pos.Y + height)
                        d.HealthBg.Visible = true

                        d.Health.From = Vector2.new(pos.X - 6, pos.Y + height)
                        d.Health.To = Vector2.new(pos.X - 6, (pos.Y + height) - (height * hpPct))
                        d.Health.Color = Color3.fromRGB(255 - (hpPct * 255), hpPct * 255, 0)
                        d.Health.Visible = true
                    else
                        d.HealthBg.Visible = false
                        d.Health.Visible = false
                    end

                    if CFG.ESP_Dist then
                        local dist = root and (root.Position - pRoot.Position).Magnitude or 0
                        d.Dist.Text = math.floor(dist) .. "m"
                        d.Dist.Position = Vector2.new(pos.X + width / 2, pos.Y + height + 2)
                        d.Dist.Visible = true
                    else
                        d.Dist.Visible = false
                    end

                    if CFG.Tracers then
                        d.Tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                        d.Tracer.To = Vector2.new(botVector.X, botVector.Y)
                        d.Tracer.Color = CFG.Accent
                        d.Tracer.Visible = true
                    else
                        d.Tracer.Visible = false
                    end
                end
            end

            if not visible then
                for _, obj in pairs(d) do obj.Visible = false end
            end
        end
    end

    if CFG.AimEnabled then
        local target, shortest = nil, CFG.AimFOV
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and (not CFG.TeamCheck or player.Team ~= LocalPlayer.Team) then
                local pChar = player.Character
                local pPart = pChar and pChar:FindFirstChild(CFG.AimPart)
                local pHum = pChar and pChar:FindFirstChildOfClass("Humanoid")
                if pPart and pHum and pHum.Health > 0 then
                    local screenPos, onScreen = cam:WorldToViewportPoint(pPart.Position)
                    if onScreen then
                        local screenCenter = cam.ViewportSize / 2
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if dist < shortest then
                            shortest = dist
                            target = pPart
                        end
                    end
                end
            end
        end
        if target then
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, target.Position), 1 / CFG.Smoothness)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum and CFG.InfJump then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
