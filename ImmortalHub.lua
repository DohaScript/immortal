-- ImmortalHub.lua
pcall(function()
    local old = (gethui and gethui():FindFirstChild("ImmortalHub")) or game:GetService("CoreGui"):FindFirstChild("ImmortalHub") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ImmortalHub")
    if old then old:Destroy() end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local TargetParent
if gethui then
    TargetParent = gethui()
else
    pcall(function() TargetParent = game:GetService("CoreGui") end)
end
if not TargetParent then TargetParent = LocalPlayer:WaitForChild("PlayerGui") end

local CFG = {
    AimEnabled = false, SilentAim = false, AimPart = "Head", AimFOV = 150,
    Smoothness = 0, WallCheck = false, TeamCheck = false, Triggerbot = false,
    HitboxEnabled = false, HitboxSize = 6, HitboxVis = false,
    ESP_Box = false, ESP_Name = false, ESP_Health = false, ESP_Dist = false,
    ESP_Chams = false, Tracers = false, Crosshair = false,
    Speed = false, SpeedVal = 32, Jump = false, JumpVal = 80, Fly = false,
    FlySpeed = 50, Bhop = false, Noclip = false, InfJump = false,
    GravityEnabled = false, GravityVal = 196.2, Spinbot = false,
    CamFOVEnabled = false, CamFOVVal = 90,
    Accent = Color3.fromRGB(124, 58, 237), Bg = Color3.fromRGB(244, 245, 248),
    BgTransparency = 0, MenuWidth = 560, MenuHeight = 360
}

local ThemeText, ThemeBg, ThemeBorder, ThemeStroke, ToggleCallbacks = {}, {}, {}, {}, {}
local function RegText(obj) table.insert(ThemeText, obj) return obj end
local function RegBg(obj) table.insert(ThemeBg, obj) return obj end
local function RegBorder(obj) table.insert(ThemeBorder, obj) return obj end
local function RegStroke(obj) table.insert(ThemeStroke, obj) return obj end

local function UpdateTheme(newColor)
    CFG.Accent = newColor
    for _, obj in ipairs(ThemeText) do pcall(function() obj.TextColor3 = newColor end) end
    for _, obj in ipairs(ThemeBg) do pcall(function() obj.BackgroundColor3 = newColor end) end
    for _, obj in ipairs(ThemeBorder) do pcall(function() obj.BorderColor3 = newColor end) end
    for _, obj in ipairs(ThemeStroke) do pcall(function() obj.Color = newColor end) end
    for _, cb in ipairs(ToggleCallbacks) do pcall(cb) end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImmortalHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

local FOVCircle = Instance.new("Frame")
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.Size = UDim2.new(0, CFG.AimFOV * 2, 0, CFG.AimFOV * 2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.Parent = ScreenGui

pcall(function()
    local stroke = Instance.new("UIStroke", FOVCircle)
    stroke.Thickness = 1.5
    RegStroke(stroke)
    local corner = Instance.new("UICorner", FOVCircle)
    corner.CornerRadius = UDim.new(1, 0)
end)

local CrosshairFrame = Instance.new("Frame")
CrosshairFrame.Size = UDim2.new(0, 14, 0, 14)
CrosshairFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CrosshairFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
CrosshairFrame.BackgroundTransparency = 1
CrosshairFrame.Visible = false
CrosshairFrame.Parent = ScreenGui

local CH_V = Instance.new("Frame", CrosshairFrame)
CH_V.Size = UDim2.new(0, 2, 1, 0)
CH_V.Position = UDim2.new(0.5, -1, 0, 0)
CH_V.BorderSizePixel = 0
RegBg(CH_V)

local CH_H = Instance.new("Frame", CrosshairFrame)
CH_H.Size = UDim2.new(1, 0, 0, 2)
CH_H.Position = UDim2.new(0, 0, 0.5, -1)
CH_H.BorderSizePixel = 0
RegBg(CH_H)

-- Watermark
local Watermark = Instance.new("Frame")
Watermark.Size = UDim2.new(0, 220, 0, 26)
Watermark.Position = UDim2.new(0, 15, 0, 15)
Watermark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Watermark.BorderSizePixel = 0
Watermark.Parent = ScreenGui
pcall(function() Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 6) end)
pcall(function()
    local s = Instance.new("UIStroke", Watermark)
    s.Color = Color3.fromRGB(230, 233, 240)
    s.Thickness = 1
end)

local WMText = Instance.new("TextLabel")
WMText.Size = UDim2.new(1, -10, 1, 0)
WMText.Position = UDim2.new(0, 10, 0, 0)
WMText.Text = "ImmortalHub | Creator: Immortal | FPS: 60"
WMText.TextColor3 = Color3.fromRGB(60, 64, 75)
WMText.Font = Enum.Font.GothamMedium
WMText.TextSize = 11
WMText.TextXAlignment = Enum.TextXAlignment.Left
WMText.BackgroundTransparency = 1
WMText.Parent = Watermark

-- Floating Toggle Button
local ImmortalButton = Instance.new("TextButton")
ImmortalButton.Size = UDim2.new(0, 46, 0, 46)
ImmortalButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ImmortalButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImmortalButton.Text = "IMMORTAL"
ImmortalButton.Font = Enum.Font.GothamBold
ImmortalButton.TextSize = 9
ImmortalButton.Active = true
ImmortalButton.Draggable = true
ImmortalButton.Parent = ScreenGui
RegText(ImmortalButton)
pcall(function() Instance.new("UICorner", ImmortalButton).CornerRadius = UDim.new(0, 12) end)
pcall(function()
    local s = Instance.new("UIStroke", ImmortalButton)
    s.Color = Color3.fromRGB(230, 233, 240)
    s.Thickness = 1
end)

-- Main Menu Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, CFG.MenuWidth, 0, CFG.MenuHeight)
MainFrame.Position = UDim2.new(0.5, -CFG.MenuWidth/2, 0.5, -CFG.MenuHeight/2)
MainFrame.BackgroundColor3 = CFG.Bg
MainFrame.BackgroundTransparency = CFG.BgTransparency
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
pcall(function() Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12) end)
pcall(function()
    local s = Instance.new("UIStroke", MainFrame)
    s.Color = Color3.fromRGB(225, 228, 236)
    s.Thickness = 1
end)

ImmortalButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

local function UpdateMenuSize()
    MainFrame.Size = UDim2.new(0, CFG.MenuWidth, 0, CFG.MenuHeight)
    MainFrame.Position = UDim2.new(0.5, -CFG.MenuWidth/2, 0.5, -CFG.MenuHeight/2)
end

-- Top Header Bar
local TopHeader = Instance.new("Frame")
TopHeader.Size = UDim2.new(1, 0, 0, 48)
TopHeader.Position = UDim2.new(0, 0, 0, 0)
TopHeader.BackgroundTransparency = 1
TopHeader.Parent = MainFrame

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Size = UDim2.new(0, 110, 1, 0)
LogoLabel.Position = UDim2.new(0, 16, 0, 0)
LogoLabel.Text = "⚡ Immortal"
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.TextSize = 16
LogoLabel.TextXAlignment = Enum.TextXAlignment.Left
LogoLabel.BackgroundTransparency = 1
LogoLabel.Parent = TopHeader
RegText(LogoLabel)

-- Centered Tab Bar
local NavPill = Instance.new("Frame")
NavPill.Size = UDim2.new(0, 320, 0, 32)
NavPill.Position = UDim2.new(0.5, -160, 0.5, -16)
NavPill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NavPill.Parent = TopHeader
pcall(function() Instance.new("UICorner", NavPill).CornerRadius = UDim.new(0, 16) end)
pcall(function()
    local s = Instance.new("UIStroke", NavPill)
    s.Color = Color3.fromRGB(230, 233, 240)
    s.Thickness = 1
end)

local NavLayout = Instance.new("UIListLayout")
NavLayout.FillDirection = Enum.FillDirection.Horizontal
NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavLayout.VerticalAlignment = Enum.VerticalAlignment.Center
NavLayout.Padding = UDim.new(0, 4)
NavLayout.Parent = NavPill

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -24, 1, -60)
ContentArea.Position = UDim2.new(0, 12, 0, 52)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Tabs = {}
local activeTabBtn = nil

local function CreateTab(name)
    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = ContentArea

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 58, 0, 24)
    Btn.BackgroundTransparency = 1
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(130, 135, 150)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 11
    Btn.Parent = NavPill
    pcall(function() Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 12) end)

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Btn.TextColor3 = Color3.fromRGB(130, 135, 150)
            t.Btn.BackgroundTransparency = 1
        end
        Page.Visible = true
        activeTabBtn = Btn
        Btn.TextColor3 = CFG.Accent
        Btn.BackgroundColor3 = Color3.fromRGB(240, 242, 248)
        Btn.BackgroundTransparency = 0
    end)

    Tabs[name] = {Page = Page, Btn = Btn}
    return Page
end

table.insert(ToggleCallbacks, function()
    if activeTabBtn then activeTabBtn.TextColor3 = CFG.Accent end
end)

local function CreateSection(parent, title, size, pos)
    local Sec = Instance.new("Frame")
    Sec.Size = size
    Sec.Position = pos
    Sec.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Sec.Parent = parent
    pcall(function() Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 10) end)
    pcall(function()
        local s = Instance.new("UIStroke", Sec)
        s.Color = Color3.fromRGB(230, 233, 242)
        s.Thickness = 1
    end)

    local SecTitle = Instance.new("TextLabel")
    SecTitle.Size = UDim2.new(1, -20, 0, 22)
    SecTitle.Position = UDim2.new(0, 12, 0, 8)
    SecTitle.Text = title
    SecTitle.TextColor3 = Color3.fromRGB(25, 28, 36)
    SecTitle.Font = Enum.Font.GothamBold
    SecTitle.TextSize = 13
    SecTitle.TextXAlignment = Enum.TextXAlignment.Left
    SecTitle.BackgroundTransparency = 1
    SecTitle.Parent = Sec

    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -16, 1, -36)
    Container.Position = UDim2.new(0, 8, 0, 32)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 3
    Container.ScrollBarImageColor3 = Color3.fromRGB(200, 205, 218)
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.Parent = Sec

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 6)
    Layout.Parent = Container

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 5)
    end)

    return Container
end

local function AddToggle(parent, text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 22)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -38, 1, 0)
    Label.Position = UDim2.new(0, 4, 0, 0)
    Label.Text = text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextColor3 = Color3.fromRGB(45, 48, 58)
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local SwitchTrack = Instance.new("TextButton")
    SwitchTrack.Size = UDim2.new(0, 28, 0, 16)
    SwitchTrack.Position = UDim2.new(1, -30, 0.5, -8)
    SwitchTrack.Text = ""
    SwitchTrack.AutoButtonColor = false
    SwitchTrack.Parent = Frame
    pcall(function() Instance.new("UICorner", SwitchTrack).CornerRadius = UDim.new(1, 0) end)

    local SwitchKnob = Instance.new("Frame")
    SwitchKnob.Size = UDim2.new(0, 12, 0, 12)
    SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SwitchKnob.BorderSizePixel = 0
    SwitchKnob.Parent = SwitchTrack
    pcall(function() Instance.new("UICorner", SwitchKnob).CornerRadius = UDim.new(1, 0) end)

    local st = default
    local function updateVisuals()
        if st then
            SwitchTrack.BackgroundColor3 = CFG.Accent
            SwitchKnob.Position = UDim2.new(0, 14, 0.5, -6)
        else
            SwitchTrack.BackgroundColor3 = Color3.fromRGB(210, 214, 224)
            SwitchKnob.Position = UDim2.new(0, 2, 0.5, -6)
        end
    end

    table.insert(ToggleCallbacks, updateVisuals)
    updateVisuals()

    SwitchTrack.MouseButton1Click:Connect(function()
        st = not st
        updateVisuals()
        pcall(callback, st)
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -4, 0, 28)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 0, 14)
    Label.Position = UDim2.new(0, 4, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(110, 115, 130)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(0.3, 0, 0, 14)
    ValLabel.Position = UDim2.new(0.7, -4, 0, 0)
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 10
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.BackgroundTransparency = 1
    ValLabel.Parent = Frame
    RegText(ValLabel)

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -8, 0, 5)
    Bar.Position = UDim2.new(0, 4, 0, 18)
    Bar.BackgroundColor3 = Color3.fromRGB(225, 228, 236)
    Bar.BorderSizePixel = 0
    Bar.Parent = Frame
    pcall(function() Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0) end)

    local Fill = Instance.new("Frame")
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar
    RegBg(Fill)
    pcall(function() Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0) end)

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = Bar

    local function SetValue(val)
        val = math.clamp(math.floor(val), min, max)
        local pos = (val - min) / (max - min)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        ValLabel.Text = tostring(val)
        pcall(callback, val)
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

local CombatTab = CreateTab("Combat")
local VisTab = CreateTab("Visuals")
local MoveTab = CreateTab("Movement")
local ThemeTab = CreateTab("Themes")
local ConfigTab = CreateTab("Configs")

Tabs["Combat"].Page.Visible = true
activeTabBtn = Tabs["Combat"].Btn
Tabs["Combat"].Btn.TextColor3 = CFG.Accent
Tabs["Combat"].Btn.BackgroundColor3 = Color3.fromRGB(240, 242, 248)
Tabs["Combat"].Btn.BackgroundTransparency = 0

-- Combat Sections
local CombSec1 = CreateSection(CombatTab, "Aimbot Settings", UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local CombSec2 = CreateSection(CombatTab, "Targeting & Hitbox", UDim2.new(0.49, 0, 1, 0), UDim2.new(0.51, 0, 0, 0))

AddToggle(CombSec1, "Enable Aimbot", CFG.AimEnabled, function(v) CFG.AimEnabled = v FOVCircle.Visible = v end)
AddToggle(CombSec1, "Silent Aim", CFG.SilentAim, function(v) CFG.SilentAim = v end)
AddSlider(CombSec1, "Smoothness", 0, 20, CFG.Smoothness, function(v) CFG.Smoothness = v end)
AddSlider(CombSec1, "FOV Radius", 40, 450, CFG.AimFOV, function(v) CFG.AimFOV = v FOVCircle.Size = UDim2.new(0, v * 2, 0, v * 2) end)
AddToggle(CombSec1, "Wall Check", CFG.WallCheck, function(v) CFG.WallCheck = v end)
AddToggle(CombSec1, "Team Check", CFG.TeamCheck, function(v) CFG.TeamCheck = v end)
AddToggle(CombSec1, "Triggerbot", CFG.Triggerbot, function(v) CFG.Triggerbot = v end)

local TargetBtn = Instance.new("TextButton", CombSec2)
TargetBtn.Size = UDim2.new(1, -8, 0, 24)
TargetBtn.BackgroundColor3 = Color3.fromRGB(240, 242, 248)
TargetBtn.Text = "Target: " .. CFG.AimPart
TargetBtn.Font = Enum.Font.GothamMedium
TargetBtn.TextSize = 11
RegText(TargetBtn)
pcall(function() Instance.new("UICorner", TargetBtn).CornerRadius = UDim.new(0, 6) end)

TargetBtn.MouseButton1Click:Connect(function()
    CFG.AimPart = (CFG.AimPart == "Head") and "HumanoidRootPart" or "Head"
    TargetBtn.Text = "Target: " .. CFG.AimPart
end)

AddToggle(CombSec2, "Enable Hitbox", CFG.HitboxEnabled, function(v) CFG.HitboxEnabled = v end)
AddSlider(CombSec2, "Hitbox Size", 2, 30, CFG.HitboxSize, function(v) CFG.HitboxSize = v end)
AddToggle(CombSec2, "Visible Hitbox", CFG.HitboxVis, function(v) CFG.HitboxVis = v end)

-- Visuals Sections
local VisSec1 = CreateSection(VisTab, "ESP Elements", UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local VisSec2 = CreateSection(VisTab, "Screen & World", UDim2.new(0.49, 0, 1, 0), UDim2.new(0.51, 0, 0, 0))

AddToggle(VisSec1, "Box ESP", CFG.ESP_Box, function(v) CFG.ESP_Box = v end)
AddToggle(VisSec1, "Name ESP", CFG.ESP_Name, function(v) CFG.ESP_Name = v end)
AddToggle(VisSec1, "Health Bar & Text", CFG.ESP_Health, function(v) CFG.ESP_Health = v end)
AddToggle(VisSec1, "Distance ESP", CFG.ESP_Dist, function(v) CFG.ESP_Dist = v end)
AddToggle(VisSec1, "Chams ESP", CFG.ESP_Chams, function(v) CFG.ESP_Chams = v end)

AddToggle(VisSec2, "Snaplines / Tracers", CFG.Tracers, function(v) CFG.Tracers = v end)
AddToggle(VisSec2, "Custom Crosshair", CFG.Crosshair, function(v) CFG.Crosshair = v CrosshairFrame.Visible = v end)
AddToggle(VisSec2, "Custom Cam FOV", CFG.CamFOVEnabled, function(v) CFG.CamFOVEnabled = v end)
AddSlider(VisSec2, "Field of View", 70, 120, CFG.CamFOVVal, function(v) CFG.CamFOVVal = v end)

-- Movement Sections
local MoveSec1 = CreateSection(MoveTab, "Speed & Flight", UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local MoveSec2 = CreateSection(MoveTab, "Physics & Trolls", UDim2.new(0.49, 0, 1, 0), UDim2.new(0.51, 0, 0, 0))

AddToggle(MoveSec1, "WalkSpeed Hack", CFG.Speed, function(v) CFG.Speed = v end)
AddSlider(MoveSec1, "Speed Value", 16, 200, CFG.SpeedVal, function(v) CFG.SpeedVal = v end)
AddToggle(MoveSec1, "Jump Boost", CFG.Jump, function(v) CFG.Jump = v end)
AddSlider(MoveSec1, "Jump Value", 50, 300, CFG.JumpVal, function(v) CFG.JumpVal = v end)
AddToggle(MoveSec1, "Fly Hack", CFG.Fly, function(v) CFG.Fly = v end)
AddSlider(MoveSec1, "Fly Speed", 10, 200, CFG.FlySpeed, function(v) CFG.FlySpeed = v end)

AddToggle(MoveSec2, "Noclip (WallPass)", CFG.Noclip, function(v) CFG.Noclip = v end)
AddToggle(MoveSec2, "Infinite Jump", CFG.InfJump, function(v) CFG.InfJump = v end)
AddToggle(MoveSec2, "Auto Bhop", CFG.Bhop, function(v) CFG.Bhop = v end)
AddToggle(MoveSec2, "Custom Gravity", CFG.GravityEnabled, function(v) CFG.GravityEnabled = v end)
AddSlider(MoveSec2, "Gravity Level", 0, 300, CFG.GravityVal, function(v) CFG.GravityVal = v end)
AddToggle(MoveSec2, "Spinbot", CFG.Spinbot, function(v) CFG.Spinbot = v end)

UserInputService.JumpRequest:Connect(function()
    if CFG.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeStat