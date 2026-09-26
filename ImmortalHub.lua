-- ImmortalHub.lua (Full UI Scaler Edition)
pcall(function()
    local old = (gethui and gethui():FindFirstChild("ImmortalHub")) or game:GetService("CoreGui"):FindFirstChild("ImmortalHub") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ImmortalHub")
    if old then old:Destroy() end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local function GetCamera()
    return workspace.CurrentCamera
end

local TargetParent = (gethui and gethui()) or game:GetService("CoreGui")

local CFG = {
    AimEnabled = false, AimPart = "Head", AimFOV = 150, Smoothness = 5, TeamCheck = false,
    Spinbot = false,
    HitboxEnabled = false, HitboxSize = 6, HitboxVis = false,
    HitboxTrans = 40, HitboxThroughWalls = true, HitboxMaterial = "Neon",
    ChamsEnabled = false, ChamsColor = Color3.fromRGB(255, 50, 50), ChamsMaterial = "Neon", ChamsTrans = 30,

    ESP_Box = false, ESP_Name = false, ESP_Health = false, ESP_Dist = false, Tracers = false, Crosshair = false,
    Speed = false, SpeedVal = 32, Jump = false, JumpVal = 80, 
    Bhop = false, Noclip = false, InfJump = false, 
    GravityEnabled = false, GravityVal = 50, CamFOVEnabled = false, CamFOVVal = 70,
    FakeLag = false, FakeLagVal = 0.15,
    Invisibility = false,
    PanicKey = Enum.KeyCode.Delete,
    MenuWidth = 920,
    MenuHeight = 520,
    MenuScale = 1,
    HitmarkerEnabled = false,
    HitSoundID = "", KillSoundID = "", MusicID = "", MusicPitch = 1, MusicVolume = 1,
    MacroEnabled = false, MacroCPS = 10, MacroKey = Enum.KeyCode.Q, MacroKeyPressed = false,
    Fullbright = false, FPSBoost = false, AntiAFK = false,
    ShaderMode = "Default"
}

local ThemeElements = {
    MainFrames = {},
    Sidebars = {},
    Sections = {},
    Texts = {},
    SubTexts = {},
    Accents = {}
}

local function RegisterElement(type, obj)
    if ThemeElements[type] then
        table.insert(ThemeElements[type], obj)
    end
    return obj
end

local Themes = {
    DarkMinimal = {
        Name = "Dark Minimal (MacOS)",
        MainBg = Color3.fromRGB(15, 15, 15),
        SidebarBg = Color3.fromRGB(20, 20, 20),
        SectionBg = Color3.fromRGB(18, 18, 18),
        Text = Color3.fromRGB(240, 240, 245),
        SubText = Color3.fromRGB(140, 140, 145),
        Accent = Color3.fromRGB(80, 80, 90)
    },
    OLED = {
        Name = "Pure OLED Black",
        MainBg = Color3.fromRGB(0, 0, 0),
        SidebarBg = Color3.fromRGB(5, 5, 5),
        SectionBg = Color3.fromRGB(10, 10, 10),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(150, 150, 150),
        Accent = Color3.fromRGB(50, 50, 50)
    },
    Cyberpunk = {
        Name = "Neon Cyberpunk",
        MainBg = Color3.fromRGB(13, 13, 22),
        SidebarBg = Color3.fromRGB(18, 18, 30),
        SectionBg = Color3.fromRGB(22, 22, 38),
        Text = Color3.fromRGB(240, 245, 255),
        SubText = Color3.fromRGB(130, 200, 255),
        Accent = Color3.fromRGB(0, 229, 255)
    },
    SoftGray = {
        Name = "Soft Gray Loft",
        MainBg = Color3.fromRGB(32, 34, 37),
        SidebarBg = Color3.fromRGB(40, 43, 48),
        SectionBg = Color3.fromRGB(47, 49, 54),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 185, 190),
        Accent = Color3.fromRGB(114, 137, 218)
    },
    Sunset = {
        Name = "Sunset Orange",
        MainBg = Color3.fromRGB(22, 16, 20),
        SidebarBg = Color3.fromRGB(28, 20, 26),
        SectionBg = Color3.fromRGB(35, 25, 33),
        Text = Color3.fromRGB(255, 240, 240),
        SubText = Color3.fromRGB(210, 150, 170),
        Accent = Color3.fromRGB(255, 100, 100)
    },
    Matrix = {
        Name = "Emerald Matrix",
        MainBg = Color3.fromRGB(10, 18, 14),
        SidebarBg = Color3.fromRGB(14, 25, 19),
        SectionBg = Color3.fromRGB(18, 32, 24),
        Text = Color3.fromRGB(220, 255, 235),
        SubText = Color3.fromRGB(100, 200, 140),
        Accent = Color3.fromRGB(0, 255, 100)
    }
}

local CurrentTheme = Themes.DarkMinimal

local function ApplyTheme(theme)
    CurrentTheme = theme
    for _, f in ipairs(ThemeElements.MainFrames) do pcall(function() f.BackgroundColor3 = theme.MainBg end) end
    for _, f in ipairs(ThemeElements.Sidebars) do pcall(function() f.BackgroundColor3 = theme.SidebarBg end) end
    for _, f in ipairs(ThemeElements.Sections) do pcall(function() f.BackgroundColor3 = theme.SectionBg end) end
    for _, t in ipairs(ThemeElements.Texts) do pcall(function() t.TextColor3 = theme.Text end) end
    for _, t in ipairs(ThemeElements.SubTexts) do pcall(function() t.TextColor3 = theme.SubText end) end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImmortalHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

local MenuUIScale = Instance.new("UIScale", ScreenGui)
MenuUIScale.Scale = CFG.MenuScale

local HitSound = Instance.new("Sound", ScreenGui)
local KillSound = Instance.new("Sound", ScreenGui)
local BoomboxSound = Instance.new("Sound", ScreenGui)
BoomboxSound.Looped = true

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
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
CH_V.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local CH_H = Instance.new("Frame", CrosshairFrame)
CH_H.Size = UDim2.new(1, 0, 0, 2)
CH_H.Position = UDim2.new(0, 0, 0.5, -1)
CH_H.BorderSizePixel = 0
CH_H.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local HitmarkerGui = Instance.new("Frame", ScreenGui)
HitmarkerGui.Size = UDim2.new(0, 20, 0, 20)
HitmarkerGui.AnchorPoint = Vector2.new(0.5, 0.5)
HitmarkerGui.Position = UDim2.new(0.5, 0, 0.5, 0)
HitmarkerGui.BackgroundTransparency = 1
HitmarkerGui.Visible = false

for _, pos in ipairs({
    UDim2.new(0, 0, 0, 0), UDim2.new(0, 12, 0, 0),
    UDim2.new(0, 0, 0, 18), UDim2.new(0, 12, 0, 18)
}) do
    local hm = Instance.new("Frame", HitmarkerGui)
    hm.Size = UDim2.new(0, 8, 0, 2)
    hm.Position = pos
    hm.BorderSizePixel = 0
    hm.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end

local function TriggerHitmarker()
    if not CFG.HitmarkerEnabled then return end
    HitmarkerGui.Visible = true
    if CFG.HitSoundID ~= "" then
        HitSound.SoundId = "rbxassetid://" .. tostring(tonumber(CFG.HitSoundID) or CFG.HitSoundID)
        HitSound:Play()
    end
    task.delay(0.1, function() HitmarkerGui.Visible = false end)
end

local ESP_List = {}

local function PanicClean()
    FOVCircle.Visible = false
    CrosshairFrame.Visible = false
    BoomboxSound:Stop()
    for _, d in pairs(ESP_List) do
        for _, obj in pairs(d) do pcall(function() obj:Remove() end) end
    end
    ScreenGui:Destroy()
end

local ImmortalButton = Instance.new("TextButton", ScreenGui)
ImmortalButton.Size = UDim2.new(0, 44, 0, 44)
ImmortalButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ImmortalButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ImmortalButton.Text = "⚡"
ImmortalButton.Font = Enum.Font.GothamBold
ImmortalButton.TextSize = 18
ImmortalButton.TextColor3 = Color3.fromRGB(240, 240, 245)
ImmortalButton.Draggable = true
Instance.new("UICorner", ImmortalButton).CornerRadius = UDim.new(0, 10)
local sBtn = Instance.new("UIStroke", ImmortalButton) sBtn.Color = Color3.fromRGB(40, 40, 40) sBtn.Thickness = 1

ImmortalButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe then
        if input.KeyCode == Enum.KeyCode.Insert then
            MainFrame.Visible = not MainFrame.Visible
        elseif input.KeyCode == CFG.PanicKey then
            PanicClean()
        elseif input.KeyCode == CFG.MacroKey then
            CFG.MacroKeyPressed = true
        end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == CFG.MacroKey then
        CFG.MacroKeyPressed = false
    end
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundTransparency = 1

local DotsContainer = Instance.new("Frame", TopBar)
DotsContainer.Size = UDim2.new(0, 60, 1, 0)
DotsContainer.Position = UDim2.new(0, 14, 0, 0)
DotsContainer.BackgroundTransparency = 1

local DotColors = {Color3.fromRGB(255, 95, 87), Color3.fromRGB(254, 188, 46), Color3.fromRGB(40, 200, 64)}
for i = 1, 3 do
    local dot = Instance.new("Frame", DotsContainer)
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(0, (i-1)*16, 0.5, -5)
    dot.BackgroundColor3 = DotColors[i]
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
end

local AppTitle = RegisterElement("SubTexts", Instance.new("TextLabel", TopBar))
AppTitle.Size = UDim2.new(0, 300, 1, 0)
AppTitle.Position = UDim2.new(0, 80, 0, 0)
AppTitle.Text = "ImmortalHub - Scalable Edition"
AppTitle.Font = Enum.Font.GothamMedium
AppTitle.TextSize = 11
AppTitle.TextColor3 = CurrentTheme.SubText
AppTitle.TextXAlignment = Enum.TextXAlignment.Left
AppTitle.BackgroundTransparency = 1

local Sidebar = RegisterElement("Sidebars", Instance.new("ScrollingFrame", MainFrame))
Sidebar.Size = UDim2.new(0, 175, 1, -36)
Sidebar.Position = UDim2.new(0, 0, 0, 36)
Sidebar.BackgroundColor3 = CurrentTheme.SidebarBg
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 680)

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.Padding = UDim.new(0, 4)

local Divider1 = Instance.new("Frame", MainFrame)
Divider1.Size = UDim2.new(0, 1, 1, -36)
Divider1.Position = UDim2.new(0, 175, 0, 36)
Divider1.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Divider1.BorderSizePixel = 0

local PreviewPanel = RegisterElement("Sidebars", Instance.new("Frame", MainFrame))
PreviewPanel.Size = UDim2.new(0, 170, 1, -36)
PreviewPanel.Position = UDim2.new(1, -170, 0, 36)
PreviewPanel.BackgroundColor3 = CurrentTheme.SidebarBg
PreviewPanel.BorderSizePixel = 0

local Divider2 = Instance.new("Frame", MainFrame)
Divider2.Size = UDim2.new(0, 1, 1, -36)
Divider2.Position = UDim2.new(1, -170, 0, 36)
Divider2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Divider2.BorderSizePixel = 0

local PreviewTitle = RegisterElement("SubTexts", Instance.new("TextLabel", PreviewPanel))
PreviewTitle.Size = UDim2.new(1, 0, 0, 30)
PreviewTitle.Position = UDim2.new(0, 0, 0, 8)
PreviewTitle.Text = "Character Profile"
PreviewTitle.Font = Enum.Font.GothamBold
PreviewTitle.TextSize = 11
PreviewTitle.TextColor3 = CurrentTheme.Text
PreviewTitle.BackgroundTransparency = 1

local AvatarImage = Instance.new("ImageLabel", PreviewPanel)
AvatarImage.Size = UDim2.new(0, 130, 0, 130)
AvatarImage.Position = UDim2.new(0.5, -65, 0, 40)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Image = "rbxassetid://0"
Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(0, 10)

task.spawn(function()
    pcall(function()
        local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        AvatarImage.Image = content
    end)
end)

local ProfileName = RegisterElement("Texts", Instance.new("TextLabel", PreviewPanel))
ProfileName.Size = UDim2.new(1, -10, 0, 24)
ProfileName.Position = UDim2.new(0, 5, 0, 178)
ProfileName.Text = LocalPlayer.Name
ProfileName.Font = Enum.Font.GothamBold
ProfileName.TextSize = 11
ProfileName.TextColor3 = CurrentTheme.Text
ProfileName.BackgroundTransparency = 1
ProfileName.TextTruncate = Enum.TextTruncate.AtEnd

local ProfileStatus = RegisterElement("SubTexts", Instance.new("TextLabel", PreviewPanel))
ProfileStatus.Size = UDim2.new(1, -10, 0, 50)
ProfileStatus.Position = UDim2.new(0, 5, 0, 202)
ProfileStatus.Text = "Status: Active & Secure\nImmortalHub Engine v4.0\nFPS: 60"
ProfileStatus.Font = Enum.Font.GothamMedium
ProfileStatus.TextSize = 9
ProfileStatus.TextColor3 = CurrentTheme.SubText
ProfileStatus.BackgroundTransparency = 1
ProfileStatus.TextWrapped = true

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -346, 1, -36)
ContentArea.Position = UDim2.new(0, 176, 0, 36)
ContentArea.BackgroundTransparency = 1

local Tabs = {}
local activeTabBtn = nil

local function CreateTab(name, icon)
    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Page.CanvasSize = UDim2.new(0, 0, 0, 440)

    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.FillDirection = Enum.FillDirection.Horizontal
    PageLayout.Padding = UDim.new(0, 12)
    PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(1, -16, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.BackgroundTransparency = 1
    Btn.Text = "   " .. (icon or "📁") .. "   " .. name
    Btn.TextColor3 = Color3.fromRGB(140, 140, 140)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 11
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    RegisterElement("SubTexts", Btn)

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Btn.TextColor3 = CurrentTheme.SubText
            t.Btn.BackgroundTransparency = 1
        end
        Page.Visible = true
        activeTabBtn = Btn
        Btn.TextColor3 = CurrentTheme.Text
        Btn.BackgroundTransparency = 0
        Btn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    end)

    Tabs[name] = {Page = Page, Btn = Btn}
    return Page
end

local function CreateSection(parent, title, customWidth)
    local Sec = RegisterElement("Sections", Instance.new("Frame", parent))
    Sec.Size = UDim2.new(0, customWidth or 260, 0, 430)
    Sec.BackgroundColor3 = CurrentTheme.SectionBg
    Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", Sec) s.Color = Color3.fromRGB(30, 30, 30) s.Thickness = 1

    local SecTitle = RegisterElement("Texts", Instance.new("TextLabel", Sec))
    SecTitle.Size = UDim2.new(1, -20, 0, 30)
    SecTitle.Position = UDim2.new(0, 12, 0, 6)
    SecTitle.Text = title
    SecTitle.TextColor3 = CurrentTheme.Text
    SecTitle.Font = Enum.Font.GothamBold
    SecTitle.TextSize = 11
    SecTitle.TextXAlignment = Enum.TextXAlignment.Left
    SecTitle.BackgroundTransparency = 1

    local Container = Instance.new("ScrollingFrame", Sec)
    Container.Size = UDim2.new(1, -12, 1, -40)
    Container.Position = UDim2.new(0, 6, 0, 36)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 2
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)

    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 8)
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 15)
    end)

    return Container
end

local function AddToggle(parent, text, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 26)
    Frame.BackgroundTransparency = 1

    local Label = RegisterElement("SubTexts", Instance.new("TextLabel", Frame))
    Label.Size = UDim2.new(1, -38, 1, 0)
    Label.Position = UDim2.new(0, 6, 0, 0)
    Label.Text = text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextColor3 = CurrentTheme.SubText
    Label.BackgroundTransparency = 1

    local SwitchTrack = Instance.new("TextButton", Frame)
    SwitchTrack.Size = UDim2.new(0, 30, 0, 16)
    SwitchTrack.Position = UDim2.new(1, -32, 0.5, -8)
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
            SwitchTrack.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            SwitchKnob.Position = UDim2.new(0, 15, 0.5, -6)
        else
            SwitchTrack.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            SwitchKnob.Position = UDim2.new(0, 3, 0.5, -6)
        end
    end
    updateVisuals()

    SwitchTrack.MouseButton1Click:Connect(function()
        st = not st
        updateVisuals()
        callback(st)
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -4, 0, 36)
    Frame.BackgroundTransparency = 1

    local Label = RegisterElement("SubTexts", Instance.new("TextLabel", Frame))
    Label.Size = UDim2.new(0.7, 0, 0, 16)
    Label.Position = UDim2.new(0, 6, 0, 0)
    Label.Text = text
    Label.TextColor3 = CurrentTheme.SubText
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local ValLabel = RegisterElement("Texts", Instance.new("TextLabel", Frame))
    ValLabel.Size = UDim2.new(0.3, 0, 0, 16)
    ValLabel.Position = UDim2.new(0.7, -6, 0, 0)
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 10
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.TextColor3 = CurrentTheme.Text
    ValLabel.BackgroundTransparency = 1

    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, -12, 0, 5)
    Bar.Position = UDim2.new(0, 6, 0, 22)
    Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Bar.BorderSizePixel = 0
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
    Fill.BorderSizePixel = 0
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Btn = Instance.new("TextButton", Bar)
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""

    local function SetValue(val)
        val = math.clamp(val, min, max)
        local pos = (val - min) / (max - min)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        ValLabel.Text = tostring(math.floor(val * 100 + 0.5) / 100)
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

    local Box = RegisterElement("Texts", Instance.new("TextBox", Frame))
    Box.Size = UDim2.new(1, 0, 1, 0)
    Box.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Box.PlaceholderText = placeholder
    Box.Text = ""
    Box.Font = Enum.Font.GothamMedium
    Box.TextSize = 10
    Box.TextColor3 = CurrentTheme.Text
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)

    Box.FocusLost:Connect(function(enter)
        if enter then callback(Box.Text) end
    end)
end

local CombatTab = CreateTab("Combat", "🎯")
local VisTab = CreateTab("Visuals", "👁️")
local MoveTab = CreateTab("Movement", "⚡")
local ShaderTab = CreateTab("Shaders", "🌄")
local FFlagsTab = CreateTab("FFlags", "🚩")
local MiscTab = CreateTab("Misc", "⚙️")
local ThemeTab = CreateTab("Theme", "🎨")
local PlayersTab = CreateTab("Players", "👥")
local ExecutorTab = CreateTab("Executor", "💻")
local ServerTab = CreateTab("Server", "🌐")
local MacroTab = CreateTab("Macro", "⌨️")
local MusicTab = CreateTab("Music", "🎵")

Tabs["Combat"].Page.Visible = true
activeTabBtn = Tabs["Combat"].Btn
Tabs["Combat"].Btn.TextColor3 = Color3.fromRGB(240, 240, 245)
Tabs["Combat"].Btn.BackgroundTransparency = 0
Tabs["Combat"].Btn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)

local CombSec1 = CreateSection(CombatTab, "Aimbot Settings")
local CombSec2 = CreateSection(CombatTab, "Hitbox Modifiers")
AddToggle(CombSec1, "Enable Aimbot", CFG.AimEnabled, function(v) CFG.AimEnabled = v FOVCircle.Visible = v end)
AddSlider(CombSec1, "Smoothness", 1, 20, CFG.Smoothness, function(v) CFG.Smoothness = v end)
AddSlider(CombSec1, "FOV Radius", 40, 400, CFG.AimFOV, function(v) CFG.AimFOV = v FOVCircle.Radius = v end)
AddToggle(CombSec1, "Team Check", CFG.TeamCheck, function(v) CFG.TeamCheck = v end)
AddToggle(CombSec1, "Custom Hitmarker", CFG.HitmarkerEnabled, function(v) CFG.HitmarkerEnabled = v end)
AddTextBox(CombSec1, "Hit Sound ID", function(txt) CFG.HitSoundID = txt end)
AddTextBox(CombSec1, "Kill Sound ID", function(txt) CFG.KillSoundID = txt end)

AddToggle(CombSec2, "Hitbox Expander", CFG.HitboxEnabled, function(v) CFG.HitboxEnabled = v end)
AddSlider(CombSec2, "Hitbox Size", 2, 25, CFG.HitboxSize, function(v) CFG.HitboxSize = v end)
AddToggle(CombSec2, "Glow Material", CFG.HitboxVis, function(v) CFG.HitboxVis = v end)
AddSlider(CombSec2, "Transparency", 0, 100, CFG.HitboxTrans, function(v) CFG.HitboxTrans = v end)

local VisSec1 = CreateSection(VisTab, "ESP Elements")
local VisSec2 = CreateSection(VisTab, "Wallhack & Chams")
AddToggle(VisSec1, "Corner Box ESP", CFG.ESP_Box, function(v) CFG.ESP_Box = v end)
AddToggle(VisSec1, "Name ESP", CFG.ESP_Name, function(v) CFG.ESP_Name = v end)
AddToggle(VisSec1, "Health Bar", CFG.ESP_Health, function(v) CFG.ESP_Health = v end)
AddToggle(VisSec1, "Distance ESP", CFG.ESP_Dist, function(v) CFG.ESP_Dist = v end)
AddToggle(VisSec1, "Tracers", CFG.Tracers, function(v) CFG.Tracers = v end)
AddToggle(VisSec1, "Custom Crosshair", CFG.Crosshair, function(v) CrosshairFrame.Visible = v CFG.Crosshair = v end)

AddToggle(VisSec2, "Player Wallhack (Chams)", CFG.ChamsEnabled, function(v) CFG.ChamsEnabled = v end)
AddSlider(VisSec2, "Chams Transparency", 0, 100, CFG.ChamsTrans, function(v) CFG.ChamsTrans = v end)
AddToggle(VisSec2, "Custom Cam FOV", CFG.CamFOVEnabled, function(v) CFG.CamFOVEnabled = v end)
AddSlider(VisSec2, "FOV Value", 70, 120, CFG.CamFOVVal, function(v) CFG.CamFOVVal = v end)

local MoveSec1 = CreateSection(MoveTab, "Speed & Jump")
local MoveSec2 = CreateSection(MoveTab, "Physics & Tricks")
AddToggle(MoveSec1, "WalkSpeed Hack", CFG.Speed, function(v) CFG.Speed = v end)
AddSlider(MoveSec1, "Speed Value", 16, 150, CFG.SpeedVal, function(v) CFG.SpeedVal = v end)
AddToggle(MoveSec1, "Jump Boost", CFG.Jump, function(v) CFG.Jump = v end)
AddSlider(MoveSec1, "Jump Value", 50, 250, CFG.JumpVal, function(v) CFG.JumpVal = v end)

AddToggle(MoveSec2, "Modify Gravity", CFG.GravityEnabled, function(v) CFG.GravityEnabled = v end)
AddSlider(MoveSec2, "Gravity Force", 0, 300, CFG.GravityVal, function(v) CFG.GravityVal = v end)
AddToggle(MoveSec2, "Auto Bhop", CFG.Bhop, function(v) CFG.Bhop = v end)
AddToggle(MoveSec2, "Infinite Jump", CFG.InfJump, function(v) CFG.InfJump = v end)
AddToggle(MoveSec2, "Spinbot", CFG.Spinbot, function(v) CFG.Spinbot = v end)
AddToggle(MoveSec2, "Noclip", CFG.Noclip, function(v) CFG.Noclip = v end)

local ShaderSec1 = CreateSection(ShaderTab, "Environment & Shaders")
local ShaderSec2 = CreateSection(ShaderTab, "Atmosphere & Color Correction")

local function ApplySkybox(mode)
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if not sky then sky = Instance.new("Sky", Lighting) end

    if mode == "Morning" then
        Lighting.ClockTime = 8 Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(150, 140, 130)
        Lighting.ColorShift_Top = Color3.fromRGB(255, 200, 150)
        Lighting.ColorShift_Bottom = Color3.fromRGB(100, 90, 80)
        sky.SkyboxBk = "rbxassetid://626496924" sky.SkyboxDn = "rbxassetid://626496970"
        sky.SkyboxFt = "rbxassetid://626496887" sky.SkyboxLf = "rbxassetid://626497042"
        sky.SkyboxRt = "rbxassetid://626497092" sky.SkyboxUp = "rbxassetid://626496799"
        sky.StarCount = 0
    elseif mode == "Day" then
        Lighting.ClockTime = 14 Lighting.Brightness = 2.5
        Lighting.OutdoorAmbient = Color3.fromRGB(130, 130, 130)
        Lighting.ColorShift_Top = Color3.fromRGB(240, 245, 255)
        Lighting.ColorShift_Bottom = Color3.fromRGB(120, 130, 140)
        sky.SkyboxBk = "rbxassetid://1013721414" sky.SkyboxDn = "rbxassetid://1013721438"
        sky.SkyboxFt = "rbxassetid://1013721481" sky.SkyboxLf = "rbxassetid://1013721526"
        sky.SkyboxRt = "rbxassetid://1013721564" sky.SkyboxUp = "rbxassetid://1013721606"
        sky.StarCount = 0
    elseif mode == "Evening" then
        Lighting.ClockTime = 18.5 Lighting.Brightness = 1.2
        Lighting.OutdoorAmbient = Color3.fromRGB(120, 80, 70)
        Lighting.ColorShift_Top = Color3.fromRGB(255, 120, 80)
        Lighting.ColorShift_Bottom = Color3.fromRGB(80, 40, 50)
        sky.SkyboxBk = "rbxassetid://141740540" sky.SkyboxDn = "rbxassetid://141740547"
        sky.SkyboxFt = "rbxassetid://141740535" sky.SkyboxLf = "rbxassetid://141740549"
        sky.SkyboxRt = "rbxassetid://141740554" sky.SkyboxUp = "rbxassetid://141740560"
        sky.StarCount = 1000
    elseif mode == "Night" then
        Lighting.ClockTime = 0 Lighting.Brightness = 0.3
        Lighting.OutdoorAmbient = Color3.fromRGB(30, 35, 50)
        Lighting.ColorShift_Top = Color3.fromRGB(50, 70, 120)
        Lighting.ColorShift_Bottom = Color3.fromRGB(10, 15, 30)
        sky.SkyboxBk = "rbxassetid://12064107" sky.SkyboxDn = "rbxassetid://12064115"
        sky.SkyboxFt = "rbxassetid://12064121" sky.SkyboxLf = "rbxassetid://12064129"
        sky.SkyboxRt = "rbxassetid://12064137" sky.SkyboxUp = "rbxassetid://12064147"
        sky.StarCount = 5000
    elseif mode == "Default" then
        Lighting.ClockTime = 14 Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
        Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
        if sky then sky:Destroy() end
    end
end

local shaderModes = {"Default", "Morning", "Day", "Evening", "Night"}
for _, modeName in ipairs(shaderModes) do
    local sBtn = Instance.new("TextButton", ShaderSec1)
    sBtn.Size = UDim2.new(1, -4, 0, 32)
    sBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    sBtn.Text = "🌄  Shader: " .. modeName
    sBtn.Font = Enum.Font.GothamMedium
    sBtn.TextSize = 10
    sBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
    sBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", sBtn).CornerRadius = UDim.new(0, 6)
    RegisterElement("Texts", sBtn)

    sBtn.MouseButton1Click:Connect(function()
        CFG.ShaderMode = modeName
        ApplySkybox(modeName)
    end)
end

local ccEffect = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", Lighting)
AddToggle(ShaderSec2, "Cinematic Contrast", false, function(v)
    ccEffect.Contrast = v and 0.2 or 0
    ccEffect.Saturation = v and 0.15 or 0
end)

AddToggle(ShaderSec2, "HDR Bloom Effect", false, function(v)
    local bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", Lighting)
    bloom.Enabled = v bloom.Intensity = 0.4 bloom.Size = 24
end)

local FFlagSec1 = CreateSection(FFlagsTab, "Custom FFlags Runner", 532)
local FFlagSec2 = CreateSection(FFlagsTab, "Popular FFlag Presets")

local FFlagBox = RegisterElement("Texts", Instance.new("TextBox", FFlagSec1))
FFlagBox.Size = UDim2.new(1, -8, 0, 200)
FFlagBox.Position = UDim2.new(0, 4, 0, 32)
FFlagBox.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
FFlagBox.PlaceholderText = '{\n  "DFIntTaskSchedulerTargetFps": 240,\n  "FFlagDebugGraphicsDisableDirect3D11": false\n}'
FFlagBox.Text = ""
FFlagBox.MultiLine = true
FFlagBox.ClearTextOnFocus = false
FFlagBox.TextXAlignment = Enum.TextXAlignment.Left
FFlagBox.TextYAlignment = Enum.TextYAlignment.Top
FFlagBox.Font = Enum.Font.Code
FFlagBox.TextSize = 11
FFlagBox.TextColor3 = CurrentTheme.Text
Instance.new("UICorner", FFlagBox).CornerRadius = UDim.new(0, 6)

local ApplyFFlagsBtn = Instance.new("TextButton", FFlagSec1)
ApplyFFlagsBtn.Size = UDim2.new(1, -8, 0, 32)
ApplyFFlagsBtn.Position = UDim2.new(0, 4, 0, 242)
ApplyFFlagsBtn.BackgroundColor3 = Color3.fromRGB(50, 90, 50)
ApplyFFlagsBtn.Text = "Apply Custom FFlags (JSON)"
ApplyFFlagsBtn.Font = Enum.Font.GothamBold
ApplyFFlagsBtn.TextSize = 11
ApplyFFlagsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ApplyFFlagsBtn).CornerRadius = UDim.new(0, 6)

ApplyFFlagsBtn.MouseButton1Click:Connect(function()
    local text = FFlagBox.Text
    local success, parsed = pcall(function()
        return HttpService:JSONDecode(text)
    end)
    if success and type(parsed) == "table" then
        if setfflag then
            for flagName, flagVal in pairs(parsed) do
                pcall(function() setfflag(flagName, tostring(flagVal)) end)
            end
        end
    end
end)

local fflagPresets = {
    {"Unlock FPS (240)", '{"DFIntTaskSchedulerTargetFps": 240}'},
    {"Disable PostFX / Shaders", '{"FFlagDebugForceFutureIsBrightPhase3": false}'},
    {"Remove Textures & Materials", '{"FIntTerrainMaterialBudget": 0}'},
    {"Enable Special Lighting", '{"FFlagDebugGraphicsEnableVulkan": true}'}
}

for _, preset in ipairs(fflagPresets) do
    local pBtn = Instance.new("TextButton", FFlagSec2)
    pBtn.Size = UDim2.new(1, -4, 0, 32)
    pBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    pBtn.Text = "⚡ " .. preset[1]
    pBtn.Font = Enum.Font.GothamMedium
    pBtn.TextSize = 10
    pBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
    pBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)
    RegisterElement("Texts", pBtn)

    pBtn.MouseButton1Click:Connect(function()
        FFlagBox.Text = preset[2]
        local success, parsed = pcall(function() return HttpService:JSONDecode(preset[2]) end)
        if success and setfflag then
            for k, v in pairs(parsed) do
                pcall(function() setfflag(k, tostring(v)) end)
            end
        end
    end)
end

local MiscSec1 = CreateSection(MiscTab, "Stealth Tools")
local MiscSec2 = CreateSection(MiscTab, "Safety")
AddToggle(MiscSec1, "Fake Lag", CFG.FakeLag, function(v) CFG.FakeLag = v end)
AddSlider(MiscSec1, "Lag Intensity", 5, 50, 15, function(v) CFG.FakeLagVal = v / 100 end)
AddToggle(MiscSec1, "Invisibility", CFG.Invisibility, function(v)
    CFG.Invisibility = v
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = v and 0.85 or (part.Name == "HumanoidRootPart" and 1 or 0)
            end
        end
    end
end)

local PanicBtnUI = Instance.new("TextButton", MiscSec2)
PanicBtnUI.Size = UDim2.new(1, -4, 0, 32)
PanicBtnUI.BackgroundColor3 = Color3.fromRGB(50, 25, 25)
PanicBtnUI.Text = "Unload Hub (Panic Delete)"
PanicBtnUI.Font = Enum.Font.GothamBold
PanicBtnUI.TextSize = 10
PanicBtnUI.TextColor3 = Color3.fromRGB(255, 100, 100)
Instance.new("UICorner", PanicBtnUI).CornerRadius = UDim.new(0, 6)
PanicBtnUI.MouseButton1Click:Connect(PanicClean)

local ThemeSec1 = CreateSection(ThemeTab, "Visual Presets")
local ThemeSec2 = CreateSection(ThemeTab, "Interface Style & Scale")

for _, themeData in pairs(Themes) do
    local tBtn = Instance.new("TextButton", ThemeSec1)
    tBtn.Size = UDim2.new(1, -4, 0, 32)
    tBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    tBtn.Text = "🎨  " .. themeData.Name
    tBtn.Font = Enum.Font.GothamMedium
    tBtn.TextSize = 10
    tBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
    tBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 6)
    RegisterElement("Texts", tBtn)

    tBtn.MouseButton1Click:Connect(function()
        ApplyTheme(themeData)
    end)
end

AddSlider(ThemeSec2, "Menu Scale (Size)", 0.5, 1.5, CFG.MenuScale, function(v)
    CFG.MenuScale = v
    MenuUIScale.Scale = v
end)

local PlayersSec = CreateSection(PlayersTab, "Online Players Manager", 532)
local PlayersContainer = Instance.new("ScrollingFrame", PlayersSec)
PlayersContainer.Size = UDim2.new(1, -8, 1, -36)
PlayersContainer.Position = UDim2.new(0, 4, 0, 32)
PlayersContainer.BackgroundTransparency = 1
PlayersContainer.ScrollBarThickness = 2
PlayersContainer.CanvasSize = UDim2.new(0, 0, 0, 0)

local PlayersLayout = Instance.new("UIListLayout", PlayersContainer)
PlayersLayout.Padding = UDim.new(0, 6)
PlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayersContainer.CanvasSize = UDim2.new(0, 0, 0, PlayersLayout.AbsoluteContentSize.Y + 10)
end)

local function RefreshPlayerList()
    for _, child in ipairs(PlayersContainer:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local pRow = Instance.new("Frame", PlayersContainer)
            pRow.Size = UDim2.new(1, 0, 0, 36)
            pRow.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Instance.new("UICorner", pRow).CornerRadius = UDim.new(0, 6)

            local pLbl = RegisterElement("Texts", Instance.new("TextLabel", pRow))
            pLbl.Size = UDim2.new(0.4, 0, 1, 0)
            pLbl.Position = UDim2.new(0, 10, 0, 0)
            pLbl.Text = plr.Name
            pLbl.Font = Enum.Font.GothamMedium
            pLbl.TextSize = 11
            pLbl.TextXAlignment = Enum.TextXAlignment.Left
            pLbl.TextColor3 = CurrentTheme.Text
            pLbl.BackgroundTransparency = 1

            local pHp = RegisterElement("SubTexts", Instance.new("TextLabel", pRow))
            pHp.Size = UDim2.new(0.2, 0, 1, 0)
            pHp.Position = UDim2.new(0.4, 0, 0, 0)
            pHp.Text = "HP: --"
            pHp.Font = Enum.Font.GothamMedium
            pHp.TextSize = 10
            pHp.TextXAlignment = Enum.TextXAlignment.Center
            pHp.TextColor3 = CurrentTheme.SubText
            pHp.BackgroundTransparency = 1

            task.spawn(function()
                while pRow and pRow.Parent do
                    pcall(function()
                        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                            pHp.Text = "HP: " .. math.floor(plr.Character.Humanoid.Health)
                        else
                            pHp.Text = "HP: Dead"
                        end
                    end)
                    task.wait(1)
                end
            end)

            local tpBtn = Instance.new("TextButton", pRow)
            tpBtn.Size = UDim2.new(0, 80, 0, 24)
            tpBtn.Position = UDim2.new(1, -86, 0.5, -12)
            tpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            tpBtn.Text = "Teleport"
            tpBtn.Font = Enum.Font.GothamBold
            tpBtn.TextSize = 10
            tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 4)

            tpBtn.MouseButton1Click:Connect(function()
                local tChar = plr.Character
                local myChar = LocalPlayer.Character
                if tChar and tChar:FindFirstChild("HumanoidRootPart") and myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = tChar.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end
            end)
        end
    end
end
Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(RefreshPlayerList)
task.spawn(RefreshPlayerList)

local ExecSec = CreateSection(ExecutorTab, "Custom Script Executor", 532)

local ScriptBox = RegisterElement("Texts", Instance.new("TextBox", ExecSec))
ScriptBox.Size = UDim2.new(1, -8, 0, 300)
ScriptBox.Position = UDim2.new(0, 4, 0, 32)
ScriptBox.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
ScriptBox.PlaceholderText = "-- Вставьте ваш Lua скрипт сюда..."
ScriptBox.Text = ""
ScriptBox.MultiLine = true
ScriptBox.ClearTextOnFocus = false
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.Font = Enum.Font.Code
ScriptBox.TextSize = 11
ScriptBox.TextColor3 = CurrentTheme.Text
Instance.new("UICorner", ScriptBox).CornerRadius = UDim.new(0, 6)

local ExecBtn = Instance.new("TextButton", ExecSec)
ExecBtn.Size = UDim2.new(1, -8, 0, 32)
ExecBtn.Position = UDim2.new(0, 4, 0, 342)
ExecBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
ExecBtn.Text = "Execute Script"
ExecBtn.Font = Enum.Font.GothamBold
ExecBtn.TextSize = 11
ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 6)

ExecBtn.MouseButton1Click:Connect(function()
    local code = ScriptBox.Text
    if code ~= "" then
        local fn, err = loadstring(code)
        if fn then
            pcall(fn)
        else
            warn("Executor Error: " .. tostring(err))
        end
    end
end)

local ServerSec1 = CreateSection(ServerTab, "Server Management")
local ServerSec2 = CreateSection(ServerTab, "Performance & Safety")

local function ServerHop()
    local servers = {}
    local success = pcall(function()
        servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
    end)
    if success and servers then
        for _, s in ipairs(servers) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                return
            end
        end
    end
end

local hopBtn = Instance.new("TextButton", ServerSec1)
hopBtn.Size = UDim2.new(1, -4, 0, 32)
hopBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
hopBtn.Text = "Server Hop (Find New)"
hopBtn.Font = Enum.Font.GothamBold
hopBtn.TextSize = 10
hopBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
Instance.new("UICorner", hopBtn).CornerRadius = UDim.new(0, 6)
hopBtn.MouseButton1Click:Connect(ServerHop)

local rejoinBtn = Instance.new("TextButton", ServerSec1)
rejoinBtn.Size = UDim2.new(1, -4, 0, 32)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
rejoinBtn.Text = "Rejoin Server"
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.TextSize = 10
rejoinBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0, 6)
rejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

AddToggle(ServerSec2, "Fullbright", CFG.Fullbright, function(v)
    CFG.Fullbright = v
    Lighting.Brightness = v and 2 or 1
    Lighting.ClockTime = v and 14 or 12
    Lighting.GlobalShadows = not v
end)

AddToggle(ServerSec2, "Advanced FPS Booster", CFG.FPSBoost, function(v)
    CFG.FPSBoost = v
    Lighting.GlobalShadows = not v
    Lighting.FogEnd = v and 999999 or 100000
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then effect.Enabled = not v end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = v and Enum.Material.SmoothPlastic or Enum.Material.Plastic
            if v then obj.Reflectance = 0 end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = v and 1 or 0
        end
    end
end)

AddToggle(ServerSec2, "Anti-AFK Protection", CFG.AntiAFK, function(v)
    CFG.AntiAFK = v
end)

LocalPlayer.Idled:Connect(function()
    if CFG.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0,0))
        end)
    end
end)

local MacroSec = CreateSection(MacroTab, "Auto Clicker & Keybinds")
AddToggle(MacroSec, "Enable Macro / Clicker", CFG.MacroEnabled, function(v) CFG.MacroEnabled = v end)
AddSlider(MacroSec, "CPS Speed", 1, 30, CFG.MacroCPS, function(v) CFG.MacroCPS = v end)

local KeybindBtn = RegisterElement("Texts", Instance.new("TextButton", MacroSec))
KeybindBtn.Size = UDim2.new(1, -4, 0, 32)
KeybindBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
KeybindBtn.Text = "Macro Key: " .. tostring(CFG.MacroKey.Name) .. " (Click to change)"
KeybindBtn.Font = Enum.Font.GothamMedium
KeybindBtn.TextSize = 10
KeybindBtn.TextColor3 = CurrentTheme.Text
Instance.new("UICorner", KeybindBtn).CornerRadius = UDim.new(0, 6)

local listeningForKey = false
KeybindBtn.MouseButton1Click:Connect(function()
    listeningForKey = true
    KeybindBtn.Text = "Press any key..."
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if listeningForKey and input.UserInputType == Enum.UserInputType.Keyboard then
        CFG.MacroKey = input.KeyCode
        KeybindBtn.Text = "Macro Key: " .. tostring(CFG.MacroKey.Name) .. " (Click to change)"
        listeningForKey = false
    end
end)

task.spawn(function()
    while true do
        if CFG.MacroEnabled and (CFG.MacroKeyPressed or not UserInputService:GetFocusedTextBox()) then
            pcall(function()
                if CFG.MacroKeyPressed then mouse1click() end
            end)
            task.wait(1 / CFG.MacroCPS)
        else
            task.wait(0.1)
        end
    end
end)

local MusicSec = CreateSection(MusicTab, "Boombox Audio")
AddTextBox(MusicSec, "Music Audio ID", function(txt)
    CFG.MusicID = txt
    BoomboxSound.SoundId = "rbxassetid://" .. tostring(tonumber(txt) or txt)
    BoomboxSound:Play()
end)
AddToggle(MusicSec, "Play / Pause", false, function(v)
    if v then if CFG.MusicID ~= "" then BoomboxSound:Play() end else BoomboxSound:Pause() end
end)
AddSlider(MusicSec, "Volume", 0, 100, 100, function(v) BoomboxSound.Volume = v / 100 end)
AddSlider(MusicSec, "Pitch", 50, 200, 100, function(v) BoomboxSound.PlaybackSpeed = v / 100 end)

local function CreateESP(player)
    if ESP_List[player] then return end
    local drawings = {
        Box = Drawing.new("Square"), BoxOutline = Drawing.new("Square"),
        Name = Drawing.new("Text"), HealthBg = Drawing.new("Line"),
        Health = Drawing.new("Line"), Dist = Drawing.new("Text"), Tracer = Drawing.new("Line")
    }
    drawings.Box.Thickness = 1.5 drawings.Box.Filled = false
    drawings.BoxOutline.Thickness = 2.5 drawings.BoxOutline.Color = Color3.fromRGB(0, 0, 0) drawings.BoxOutline.Filled = false
    drawings.Name.Size = 12 drawings.Name.Center = true drawings.Name.Outline = true drawings.Name.Color = Color3.fromRGB(255, 255, 255)
    drawings.Dist.Size = 11 drawings.Dist.Center = true drawings.Dist.Outline = true drawings.Dist.Color = Color3.fromRGB(200, 200, 200)
    drawings.HealthBg.Thickness = 3 drawings.Health.Thickness = 1.5 drawings.Tracer.Thickness = 1.5
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
                        KillSound.SoundId = "rbxassetid://" .. tostring(tonumber(CFG.KillSoundID) or CFG.KillSoundID)
                        KillSound:Play()
                    end
                end
                TrackedHealth[player] = hum.Health
            end
        end
    end
end)

local fakeLagTimer = 0
RunService.RenderStepped:Connect(function(dt)
    local char = LocalPlayer.Character
    local cam = GetCamera()
    if not cam then return end

    if FOVCircle.Visible then FOVCircle.Position = cam.ViewportSize / 2 end

    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum then
            if CFG.Speed then hum.WalkSpeed = CFG.SpeedVal end
            if CFG.Jump then
                pcall(function() hum.JumpPower = CFG.JumpVal end)
                pcall(function() hum.JumpHeight = CFG.JumpVal / 3 end)
            end
            if CFG.Bhop and hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end

        workspace.Gravity = CFG.GravityEnabled and CFG.GravityVal or 196.2

        if CFG.CamFOVEnabled then cam.FieldOfView = CFG.CamFOVVal end
        if CFG.Spinbot and root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(55), 0) end
        if CFG.Noclip then
            for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end

        if CFG.FakeLag and root then
            fakeLagTimer = fakeLagTimer + dt
            if fakeLagTimer >= CFG.FakeLagVal then
                fakeLagTimer = 0
                local oldPos = root.CFrame
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                task.wait(0.05)
            end
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    if CFG.ChamsEnabled then
                        part.Material = Enum.Material.Neon
                        part.Color = CFG.ChamsColor
                        part.Transparency = CFG.ChamsTrans / 100
                        part.LocalTransparencyModifier = part.Transparency
                    else
                        part.Transparency = 0
                        part.LocalTransparencyModifier = 0
                    end
                end
            end
        end
    end

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
                        d.BoxOutline.Size = Vector2.new(width, height) d.BoxOutline.Position = pos d.BoxOutline.Visible = true
                        d.Box.Size = Vector2.new(width, height) d.Box.Position = pos d.Box.Color = Color3.fromRGB(255, 255, 255) d.Box.Visible = true
                    else d.Box.Visible = false d.BoxOutline.Visible = false end

                    if CFG.ESP_Name then
                        d.Name.Text = player.Name d.Name.Position = Vector2.new(pos.X + width / 2, pos.Y - 15) d.Name.Visible = true
                    else d.Name.Visible = false end

                    if CFG.ESP_Health then
                        local hpPct = math.clamp(pHum.Health / pHum.MaxHealth, 0, 1)
                        d.HealthBg.From = Vector2.new(pos.X - 5, pos.Y) d.HealthBg.To = Vector2.new(pos.X - 5, pos.Y + height) d.HealthBg.Visible = true
                        d.Health.From = Vector2.new(pos.X - 5, pos.Y + height) d.Health.To = Vector2.new(pos.X - 5, (pos.Y + height) - (height * hpPct))
                        d.Health.Color = Color3.fromRGB(255 - (hpPct * 255), hpPct * 255, 0) d.Health.Visible = true
                    else d.HealthBg.Visible = false d.Health.Visible = false end

                    if CFG.ESP_Dist then
                        local dist = (char and char:FindFirstChild("HumanoidRootPart")) and (char.HumanoidRootPart.Position - pRoot.Position).Magnitude or 0
                        d.Dist.Text = math.floor(dist) .. "m" d.Dist.Position = Vector2.new(pos.X + width / 2, pos.Y + height + 2) d.Dist.Visible = true
                    else d.Dist.Visible = false end

                    if CFG.Tracers then
                        d.Tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                        d.Tracer.To = Vector2.new(botVector.X, botVector.Y)
                        d.Tracer.Color = Color3.fromRGB(255, 255, 255) d.Tracer.Visible = true
                    else d.Tracer.Visible = false end
                end
            end
            if not visible then for _, obj in pairs(d) do obj.Visible = false end end
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
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - (cam.ViewportSize / 2)).Magnitude
                        if dist < shortest then shortest = dist target = pPart end
                    end
                end
            end
        end
        if target then cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, target.Position), 1 / CFG.Smoothness) end
    end
end)

UserInputService.JumpRequest:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum and CFG.InfJump then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
