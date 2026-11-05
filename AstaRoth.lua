local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

repeat task.wait() until Players.LocalPlayer

local player = Players.LocalPlayer
local success, result = pcall(function()
    return player:GetMouse()
end)

local mouse = success and result or nil

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "AstaRoth",
    SubTitle = "Attack on Titan: Revolution ( Paid Version )",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local TrayIcon = {}
TrayIcon.isVisible = true
TrayIcon.connection = nil

function TrayIcon:CreateIcon()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TrayIconGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")

    local iconFrame = Instance.new("Frame")
    iconFrame.Name = "TrayIcon"
    iconFrame.Size = UDim2.new(0, 50, 0, 50)
    iconFrame.Position = UDim2.new(1, -60, 0, 10)
    iconFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 212)
    iconFrame.BorderSizePixel = 0
    iconFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = iconFrame

    local iconText = Instance.new("TextLabel")
    iconText.Size = UDim2.new(1, 0, 1, 0)
    iconText.Position = UDim2.new(0, 0, 0, 0)
    iconText.BackgroundTransparency = 1
    iconText.Text = "A"
    iconText.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconText.TextScaled = true
    iconText.Font = Enum.Font.GothamBold
    iconText.Parent = iconFrame

    local hoverTween = nil
    iconFrame.MouseEnter:Connect(function()
        if hoverTween then hoverTween:Cancel() end
        hoverTween = TweenService:Create(iconFrame,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 55, 0, 55), BackgroundColor3 = Color3.fromRGB(16, 110, 190)}
        )
        hoverTween:Play()
    end)

    iconFrame.MouseLeave:Connect(function()
        if hoverTween then hoverTween:Cancel() end
        hoverTween = TweenService:Create(iconFrame,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 50, 0, 50), BackgroundColor3 = Color3.fromRGB(0, 120, 212)}
        )
        hoverTween:Play()
    end)

    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.Position = UDim2.new(0, 0, 0, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = iconFrame

    clickDetector.MouseButton1Click:Connect(function()
        self:ToggleUI()
        local clickTween = TweenService:Create(iconFrame,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {Size = UDim2.new(0, 45, 0, 45)}
        )
        clickTween:Play()
        clickTween.Completed:Connect(function()
            local returnTween = TweenService:Create(iconFrame,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {Size = UDim2.new(0, 50, 0, 50)}
            )
            returnTween:Play()
        end)
    end)

    self.gui = screenGui
    self.frame = iconFrame
    self.text = iconText
    self:CreateTooltip()
end

function TrayIcon:CreateTooltip()
    local tooltip = Instance.new("Frame")
    tooltip.Name = "Tooltip"
    tooltip.Size = UDim2.new(0, 200, 0, 30)
    tooltip.Position = UDim2.new(1, -210, 0.5, -15)
    tooltip.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    tooltip.BorderSizePixel = 0
    tooltip.Visible = false
    tooltip.Parent = self.frame

    local tooltipCorner = Instance.new("UICorner")
    tooltipCorner.CornerRadius = UDim.new(0, 5)
    tooltipCorner.Parent = tooltip

    local tooltipText = Instance.new("TextLabel")
    tooltipText.Size = UDim2.new(1, -10, 1, 0)
    tooltipText.Position = UDim2.new(0, 5, 0, 0)
    tooltipText.BackgroundTransparency = 1
    tooltipText.Text = "Click to toggle UI visibility"
    tooltipText.TextColor3 = Color3.fromRGB(255, 255, 255)
    tooltipText.TextScaled = true
    tooltipText.Font = Enum.Font.Gotham
    tooltipText.Parent = tooltip

    self.frame.MouseEnter:Connect(function() tooltip.Visible = true end)
    self.frame.MouseLeave:Connect(function() tooltip.Visible = false end)
end

function TrayIcon:ToggleUI()
    if self.isVisible then self:HideUI() else self:ShowUI() end
end

function TrayIcon:HideUI()
    if Window and Window.Root then
        Window.Root.Visible = false
        self.isVisible = false
        self.text.Text = "H"
        self.frame.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
        Fluent:Notify({ Title = "UI Hidden", Content = "Click the tray icon to show UI again", Duration = 3 })
    end
end

function TrayIcon:ShowUI()
    if Window and Window.Root then
        Window.Root.Visible = true
        self.isVisible = true
        self.text.Text = "A"
        self.frame.BackgroundColor3 = Color3.fromRGB(0, 120, 212)
        Fluent:Notify({ Title = "UI Shown", Content = "UI is now visible", Duration = 2 })
    end
end

TrayIcon:CreateIcon()

--//==============================\\--
--||         TABS SETUP           ||--
--\\==============================//--

local Tabs = {
    Main          = Window:AddTab({ Title = "Main(Risky)",               Icon = "" }),
    Ts            = Window:AddTab({ Title = "Thunder Spears(Risky)",     Icon = "" }),
    AutoFarmSafe  = Window:AddTab({ Title = "Auto Farm Safe",            Icon = "" }),
    AutoJoin      = Window:AddTab({ Title = "Auto Join",                 Icon = "" }),
    Servers       = Window:AddTab({ Title = "Servers",                   Icon = "" }),
    Prestiger     = Window:AddTab({ Title = "Prestiger",                 Icon = "" }),
    Misc          = Window:AddTab({ Title = "Misc",                      Icon = "" }),
    Esp           = Window:AddTab({ Title = "Titans Esp",                Icon = "" }),
    Settings      = Window:AddTab({ Title = "Settings",                  Icon = "" }),
}

--//==============================\\--
--||      AUTO FARM SAFE TAB      ||--
--\\==============================//--

do
    local LP = Players.LocalPlayer

    -- ── Game Status HUD ──────────────────────────────────────────────────────
    local _G_save = _G_save or {}
    _G.save = _G.save or {}

    local PlayerGui_AFS = LP:WaitForChild("PlayerGui")
    local old_AFS = PlayerGui_AFS:FindFirstChild("GameStatsHUD")
    if old_AFS then old_AFS:Destroy() end

    local ScreenGui_AFS = Instance.new("ScreenGui")
    ScreenGui_AFS.Name = "GameStatsHUD"
    ScreenGui_AFS.ResetOnSpawn = false
    ScreenGui_AFS.IgnoreGuiInset = true
    ScreenGui_AFS.Parent = PlayerGui_AFS
    ScreenGui_AFS.Enabled = _G.save.ShowStatus or false

    local MainFrame_AFS = Instance.new("Frame")
    MainFrame_AFS.Parent = ScreenGui_AFS
    MainFrame_AFS.AnchorPoint = Vector2.new(0, 1)
    MainFrame_AFS.Position = UDim2.new(0.02, 0, 0.97, 0)
    MainFrame_AFS.Size = UDim2.new(0, 260, 0, 0)
    MainFrame_AFS.AutomaticSize = Enum.AutomaticSize.Y
    MainFrame_AFS.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    MainFrame_AFS.BackgroundTransparency = 0.08
    MainFrame_AFS.ClipsDescendants = true

    local Corner_AFS = Instance.new("UICorner")
    Corner_AFS.CornerRadius = UDim.new(0, 14)
    Corner_AFS.Parent = MainFrame_AFS

    local Stroke_AFS = Instance.new("UIStroke")
    Stroke_AFS.Thickness = 1.5
    Stroke_AFS.Color = Color3.fromRGB(0, 200, 255)
    Stroke_AFS.Transparency = 0.6
    Stroke_AFS.Parent = MainFrame_AFS

    local Grad_AFS = Instance.new("UIGradient")
    Grad_AFS.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 26)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 10))
    })
    Grad_AFS.Rotation = 135
    Grad_AFS.Parent = MainFrame_AFS

    local Padding_AFS = Instance.new("UIPadding")
    Padding_AFS.PaddingTop    = UDim.new(0, 0)
    Padding_AFS.PaddingBottom = UDim.new(0, 10)
    Padding_AFS.PaddingLeft   = UDim.new(0, 10)
    Padding_AFS.PaddingRight  = UDim.new(0, 10)
    Padding_AFS.Parent = MainFrame_AFS

    local UIList_AFS = Instance.new("UIListLayout")
    UIList_AFS.Padding = UDim.new(0, 5)
    UIList_AFS.SortOrder = Enum.SortOrder.LayoutOrder
    UIList_AFS.Parent = MainFrame_AFS

    local Header_AFS = Instance.new("Frame")
    Header_AFS.Size = UDim2.new(1, 0, 0, 32)
    Header_AFS.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    Header_AFS.BackgroundTransparency = 0.85
    Header_AFS.LayoutOrder = 0
    Header_AFS.Parent = MainFrame_AFS

    local HeaderCorner_AFS = Instance.new("UICorner")
    HeaderCorner_AFS.CornerRadius = UDim.new(0, 10)
    HeaderCorner_AFS.Parent = Header_AFS

    local HeaderGrad_AFS = Instance.new("UIGradient")
    HeaderGrad_AFS.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 210, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 255))
    })
    HeaderGrad_AFS.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.6),
        NumberSequenceKeypoint.new(1, 0.85)
    })
    HeaderGrad_AFS.Rotation = 90
    HeaderGrad_AFS.Parent = Header_AFS

    local HeaderLabel_AFS = Instance.new("TextLabel")
    HeaderLabel_AFS.Size = UDim2.new(1, 0, 1, 0)
    HeaderLabel_AFS.BackgroundTransparency = 1
    HeaderLabel_AFS.TextColor3 = Color3.fromRGB(180, 240, 255)
    HeaderLabel_AFS.Font = Enum.Font.GothamBold
    HeaderLabel_AFS.TextSize = 11
    HeaderLabel_AFS.TextXAlignment = Enum.TextXAlignment.Center
    HeaderLabel_AFS.Text = "◈  GAME STATUS  ◈"
    HeaderLabel_AFS.Parent = Header_AFS

    local AccentLine_AFS = Instance.new("Frame")
    AccentLine_AFS.Size = UDim2.new(0.6, 0, 0, 1)
    AccentLine_AFS.Position = UDim2.new(0.2, 0, 1, 0)
    AccentLine_AFS.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    AccentLine_AFS.BackgroundTransparency = 0.3
    AccentLine_AFS.BorderSizePixel = 0
    AccentLine_AFS.Parent = Header_AFS

    local function CreateRow_AFS(icon, accentColor)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 30)
        Row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Row.BackgroundTransparency = 0.95
        Row.Parent = MainFrame_AFS

        local RowCorner = Instance.new("UICorner")
        RowCorner.CornerRadius = UDim.new(0, 8)
        RowCorner.Parent = Row

        local RowStroke = Instance.new("UIStroke")
        RowStroke.Thickness = 1
        RowStroke.Color = accentColor
        RowStroke.Transparency = 0.75
        RowStroke.Parent = Row

        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(0, 3, 0.6, 0)
        Bar.Position = UDim2.new(0, 0, 0.2, 0)
        Bar.BackgroundColor3 = accentColor
        Bar.BackgroundTransparency = 0.1
        Bar.BorderSizePixel = 0
        Bar.Parent = Row

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(0, 4)
        BarCorner.Parent = Bar

        local IconLabel = Instance.new("TextLabel")
        IconLabel.Size = UDim2.new(0, 24, 1, 0)
        IconLabel.Position = UDim2.new(0, 8, 0, 0)
        IconLabel.BackgroundTransparency = 1
        IconLabel.TextColor3 = accentColor
        IconLabel.Font = Enum.Font.GothamBold
        IconLabel.TextSize = 13
        IconLabel.Text = icon
        IconLabel.Parent = Row

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.new(1, -38, 1, 0)
        TextLabel.Position = UDim2.new(0, 34, 0, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextColor3 = Color3.fromRGB(220, 230, 245)
        TextLabel.Font = Enum.Font.Gotham
        TextLabel.TextSize = 12
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.Text = "—"
        TextLabel.Parent = Row
        return TextLabel
    end

    local ModeText_AFS = CreateRow_AFS("👀", Color3.fromRGB(255, 200, 60))
    local DiffText_AFS = CreateRow_AFS("⚡", Color3.fromRGB(255, 80, 80))
    local ObjText_AFS  = CreateRow_AFS("💡", Color3.fromRGB(60, 210, 255))
    local TimeText_AFS = CreateRow_AFS("🕛", Color3.fromRGB(80, 255, 140))

    local function FormatTime_AFS(sec)
        if not sec or sec <= 0 then return "00:00" end
        local m = math.floor(sec / 60)
        local s = sec % 60
        return string.format("%02d:%02d", m, s)
    end

    local PREFIX_AFS = {
        [ModeText_AFS] = "MODE",
        [DiffText_AFS] = "DIFF",
        [ObjText_AFS]  = "TARGET",
        [TimeText_AFS] = "TIME"
    }
    local function SetText_AFS(label, value)
        label.Text = PREFIX_AFS[label] .. "  ›  " .. value
    end

    task.spawn(function()
        while true do
            local mode = workspace:GetAttribute("Type")      or "Waiting..."
            local diff = workspace:GetAttribute("Difficulty") or "N/A"
            local obj  = workspace:GetAttribute("Objective")  or "None"
            local time = workspace:GetAttribute("Seconds")    or 0
            SetText_AFS(ModeText_AFS, mode)
            SetText_AFS(DiffText_AFS, diff)
            SetText_AFS(ObjText_AFS, obj)
            SetText_AFS(TimeText_AFS, FormatTime_AFS(time))
            task.wait(0.25)
        end
    end)

    -- ── Auto Farm Safe Tab UI ─────────────────────────────────────────────────
    Tabs.AutoFarmSafe:AddSection("Farming Options")

    Tabs.AutoFarmSafe:AddToggle("ShowStatus_AFS", {
        Title = "Show Game Status",
        Description = "Display game status overlay",
        Default = _G.save.ShowStatus or false,
        Callback = function(v)
            _G.save.ShowStatus = v
            ScreenGui_AFS.Enabled = v
        end
    })

    -- ── Auto Farm Titan (Safe) ────────────────────────────────────────────────
    if game.PlaceId ~= 14916516914 then
        local BladeUI_AFS      = LP.PlayerGui.Interface.HUD.Main.Top["7"].Blades
        local Gradient_AFS     = BladeUI_AFS.Inner.Bar.Gradient
        local SetsLabel_AFS    = BladeUI_AFS.Sets

        local function TweenTo_AFS(cf, speed)
            local char = LP.Character if not char then return end
            local hrp  = char:FindFirstChild("HumanoidRootPart")
            local hum  = char:FindFirstChild("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end
            local distance = (hrp.Position - cf.Position).Magnitude
            local t = distance / speed
            local tween = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = cf})
            tween:Play()
            return tween
        end

        local function GetHRP_AFS()
            local char = LP.Character if not char then return nil end
            local hrp  = char:FindFirstChild("HumanoidRootPart")
            local hum  = char:FindFirstChild("Humanoid")
            if not hrp or not hum then return nil end
            if hum.Health <= 0 then return nil end
            return hrp
        end

        local function Refill_AFS()
            local refillPart = nil
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    if v.Name:lower():find("refill") or v.Name:lower():find("fill") then
                        local display = v:FindFirstChild("Display")
                        if display then
                            local ok, title = pcall(function() return display.Main.Top.Title.Text end)
                            if ok then
                                if title == "REFILLS: 0 / 3 [R]" then
                                else refillPart = v break end
                            end
                        end
                    end
                end
            end
            if not refillPart then return end
            TweenTo_AFS(refillPart.CFrame, 6000)
            pcall(function()
                game:GetService("ReplicatedStorage").Assets.Remotes.POST:FireServer("Attacks", "Reload", refillPart)
            end)
        end

        local function ChangeBlade_AFS()
            pcall(function()
                game:GetService("ReplicatedStorage").Assets.Remotes.GET:InvokeServer("Blades", "Reload")
            end)
        end

        local function CheckBlade_AFS()
            local x = Gradient_AFS.Offset.X
            if x < 0 then
                local bladeOk = false
                pcall(function()
                    local rig   = workspace.Characters[LP.Name]["Rig_" .. LP.Name]
                    local blade = rig.LeftHand.Blade_1
                    if blade.Transparency == 0 then bladeOk = true end
                end)
                if bladeOk then return false end
                if SetsLabel_AFS.Text == "0 / 3" then Refill_AFS() else ChangeBlade_AFS() end
                return true
            end
            return false
        end

        local function GetClosestTitan_AFS()
            local closestNape, closestEyes, closestTitan
            local distance = math.huge
            local origin
            local attackTitan = workspace:FindFirstChild("Unclimbable")
                and workspace.Unclimbable:FindFirstChild("Background")
                and workspace.Unclimbable.Background:FindFirstChild("Attack_Titan")
            local boat = workspace:FindFirstChild("Unclimbable")
                and workspace.Unclimbable:FindFirstChild("Objective")
                and workspace.Unclimbable.Objective:FindFirstChild("Boat1")
            if attackTitan then
                origin = attackTitan.PrimaryPart or attackTitan:FindFirstChildWhichIsA("BasePart")
            elseif boat then
                origin = boat.PrimaryPart or boat:FindFirstChildWhichIsA("BasePart")
            else
                origin = GetHRP_AFS()
            end
            if not origin then return end
            for _, Titan in pairs(workspace.Titans:GetChildren()) do
                if Titan:IsA("Model") then
                    local humanoid = Titan:FindFirstChild("Humanoid")
                    local hitboxes = Titan:FindFirstChild("Hitboxes")
                    local hit      = hitboxes and hitboxes:FindFirstChild("Hit")
                    local nape     = hit and hit:FindFirstChild("Nape")
                    local eyes     = hit and Titan:FindFirstChild("Head")
                    if humanoid and humanoid.Health > 0 and nape and eyes
                        and nape:IsA("BasePart") and eyes:IsA("BasePart") then
                        local mag = (origin.Position - eyes.Position).Magnitude
                        if mag < distance then
                            distance     = mag
                            closestNape  = nape
                            closestEyes  = eyes
                            closestTitan = Titan
                        end
                    end
                end
            end
            return closestNape, closestEyes, closestTitan
        end

        local function Attack_AFS()
            local POST2 = game:GetService("ReplicatedStorage").Assets.Remotes.POST
            local Nape, Eyes, Titan = GetClosestTitan_AFS()
            if not Titan then return end
            local SaveHit = {}
            local PositionHit = {"Nape", "Eyes"}
            POST2:FireServer("Attacks", "Slash", true)
            if Titan:FindFirstChild("Hitboxes") then
                local HitRandom = math.random(1, #PositionHit)
                local Hit = Titan.Hitboxes.Hit[PositionHit[HitRandom]]
                if #SaveHit >= #PositionHit then SaveHit = {} end
                if not table.find(SaveHit, Hit.Name) then
                    table.insert(SaveHit, Hit.Name)
                    POST2:FireServer("Hitboxes", "Register", Hit, Titan:GetAttribute("Distance") + 1000, 1)
                end
            end
            POST2:FireServer("Attacks", "Slash", false)
        end

        task.spawn(function()
            while task.wait(0.01) do
                if _G.save.AutoFarmTitan_AFS then
                    pcall(function()
                        if game:GetService("Players").LocalPlayer.PlayerGui.Interface.Skip.Visible then
                            local skipBtn = game:GetService("Players").LocalPlayer.PlayerGui.Interface.Skip.Interact
                            game:GetService("GuiService").SelectedObject = skipBtn
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                            task.wait(0.05)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                        end
                        local hrp = GetHRP_AFS() if not hrp then return end
                        if CheckBlade_AFS() then return end
                        local Nape, Eyes, Titan = GetClosestTitan_AFS()
                        if not Nape or not Eyes or not Titan then return end
                        local targetCF = Eyes.CFrame * CFrame.new(0, 125, 125)
                        local dist = (hrp.Position - targetCF.Position).Magnitude
                        if dist <= 195 then
                            hrp.CFrame = targetCF
                            Attack_AFS()
                        else
                            local savedY = hrp.Position.Y
                            local tween  = TweenTo_AFS(targetCF, 6000)
                            if tween then
                                local fallConn = game:GetService("RunService").Heartbeat:Connect(function()
                                    local h = GetHRP_AFS()
                                    if h and h.Position.Y < savedY - 10 then
                                        h.CFrame = CFrame.new(h.Position.X, savedY, h.Position.Z)
                                    end
                                end)
                                tween.Completed:Wait()
                                fallConn:Disconnect()
                                Attack_AFS()
                            else
                                Attack_AFS()
                            end
                        end
                    end)
                end
            end
        end)

        Gradient_AFS:GetPropertyChangedSignal("Offset"):Connect(function()
            if _G.save.AutoFarmTitan_AFS then CheckBlade_AFS() end
        end)

        local ButtonRetry_AFS = game:GetService("Players").LocalPlayer.PlayerGui.Interface.Rewards.Main.Info.Main.Buttons.Retry
        local ButtonLeave_AFS = game:GetService("Players").LocalPlayer.PlayerGui.Interface.Rewards.Main.Info.Main.Buttons.Leave_2

        local function PressButton_AFS(d)
            game:GetService("GuiService").SelectedObject = d
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.05)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        end

        spawn(function()
            while task.wait() do
                if _G.save.Retry_AFS then
                    if game:GetService("Players").LocalPlayer.PlayerGui.Interface.Rewards.Visible == true then
                        if _G.save.AutoJoinMissionBoost_AFS then
                            if game:GetService("Players").LocalPlayer.PlayerGui.Interface.Rewards.Visible then
                                if game:GetService("Players").LocalPlayer.PlayerGui.Interface.Rewards.Main.Info.Main.Boost.Visible then
                                    PressButton_AFS(ButtonRetry_AFS)
                                else
                                    PressButton_AFS(ButtonLeave_AFS)
                                end
                            end
                        elseif not _G.save.AutoJoinMissionBoost_AFS then
                            PressButton_AFS(ButtonRetry_AFS)
                        end
                    end
                elseif _G.save.Leave_AFS then
                    if game:GetService("Players").LocalPlayer.PlayerGui.Interface.Rewards.Visible == true then
                        PressButton_AFS(ButtonLeave_AFS)
                    end
                end
            end
        end)
    end

    Tabs.AutoFarmSafe:AddToggle("AutoFarmTitan_AFS", {
        Title = "Auto Farm Titan",
        Description = "Automatically farms titans (Safe)",
        Default = false,
        Callback = function(v) _G.save.AutoFarmTitan_AFS = v end
    })

    RunService.Stepped:Connect(function()
        pcall(function()
            local char = LP.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if _G.save.AutoFarmTitan_AFS and LP.Character then
                if hrp and not char:FindFirstChild("Highlight_AFS") then
                    local hl = Instance.new("Highlight")
                    hl.Name             = "Highlight_AFS"
                    hl.FillColor        = Color3.fromRGB(0, 9, 255)
                    hl.OutlineColor     = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.8
                    hl.OutlineTransparency = 0
                    hl.Parent           = char
                end
            else
                if LP.Character and LP.Character:FindFirstChild("Highlight_AFS") then
                    LP.Character.Highlight_AFS:Destroy()
                end
            end
        end)
    end)

    Tabs.AutoFarmSafe:AddToggle("AutoVoteRetry_AFS", {
        Title = "Auto Vote Retry",
        Description = "Automatically votes to retry",
        Default = false,
        Callback = function(v) _G.save.Retry_AFS = v end
    })

    Tabs.AutoFarmSafe:AddToggle("AutoVoteLeave_AFS", {
        Title = "Auto Vote Leave",
        Description = "Automatically votes to leave to lobby",
        Default = false,
        Callback = function(v) _G.save.Leave_AFS = v end
    })

    -- ── Chest Options ─────────────────────────────────────────────────────────
    Tabs.AutoFarmSafe:AddSection("Chest Options")

    Tabs.AutoFarmSafe:AddDropdown("SelectChests_AFS", {
        Title = "Select Chests",
        Values = {"Red Chest", "Purple Chest"},
        Multi = true,
        Default = _G.save.SelectChests or {"Red Chest"},
        Callback = function(v) _G.save.SelectChests = v end
    })

    Tabs.AutoFarmSafe:AddToggle("AutoOpenChests_AFS", {
        Title = "Auto Open Chests",
        Description = "Automatically opens chests",
        Default = _G.save.AutoOpenChests or false,
        Callback = function(v) _G.save.AutoOpenChests = v end
    })
end

--//==============================\\--
--||         SETTINGS TAB         ||--
--\\==============================//--

Tabs.Settings:AddToggle("TrayIconToggle", {
    Title = "Show Tray Icon",
    Description = "Show/Hide the system tray icon",
    Default = true,
    Callback = function(state)
        if TrayIcon.gui then TrayIcon.gui.Enabled = state end
    end
})

Tabs.Settings:AddParagraph({
    Title = "Tray Icon Usage",
    Content = "• The tray icon appears in the top-right corner\n• Click it to hide/show the UI\n• Red icon = UI hidden, Blue icon = UI visible\n• Use Ctrl+L to minimize (default Fluent key)"
})

--//==============================\\--
--||       MAINMENU (PlaceId)     ||--
--\\==============================//--

local allowedPlaceId = 13379208636
if game.PlaceId == allowedPlaceId then
    Tabs.Mainmenu = Window:AddTab({ Title = "Mainmenu", Icon = "" })
    Tabs.Mainmenu:AddToggle("AutoRollToggle", {
        Title = "Auto Roll",
        Default = false,
        Callback = function(state) ENABLED = state end
    })
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        TrayIcon:ToggleUI()
    end
end)

game.Players.PlayerRemoving:Connect(function(plr)
    if plr == player and TrayIcon.gui then TrayIcon.gui:Destroy() end
end)

--------------------------------------------------------------------------

local HttpService     = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInput    = game:GetService("VirtualInputManager")
local GuiService      = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")

local char = player.Character or player.CharacterAdded:Wait()
local hrp  = char:WaitForChild("HumanoidRootPart")

local retryRemote = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Remotes"):WaitForChild("GET")

local isFlying   = false
local bodyPos
local LocalPlayer = Players.LocalPlayer
local startDelay  = 5
local flyHeight   = 250

--//==============================\\--
--||      👑 AUTO KILL TITANS     ||--
--\\==============================//--

local Services = {
    Players         = game:GetService("Players"),
    RunService      = game:GetService("RunService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    TweenService    = game:GetService("TweenService"),
    CoreGui         = game:GetService("CoreGui")
}

local Player = {
    self      = Services.Players.LocalPlayer,
    character = nil,
    hrp       = nil,
    gui       = nil
}

local Config = {
    flySpeed              = 250,
    canHit                = true,
    isFlying              = false,
    moveMode              = "Teleportation",
    notificationsEnabled  = true,
    startDelay            = 5,
    flyHeight             = 250,
    titanKillCount        = 0,
    autoRefill            = false,
    lastBladesEmpty       = false,
    lastSpearsEmpty       = false
}

local Data = {
    notified    = {},
    activeNotifs = {},
    POST        = nil,
    refill      = nil
}

Player.character = Player.self.Character or Player.self.CharacterAdded:Wait()
Player.hrp       = Player.character:WaitForChild("HumanoidRootPart")
Player.gui       = Player.self:WaitForChild("PlayerGui")

task.spawn(function()
    local success2, result2 = pcall(function()
        return Services.ReplicatedStorage:WaitForChild("Assets", 10):WaitForChild("Remotes", 10):WaitForChild("POST", 10)
    end)
    Data.POST = success2 and result2 or nil
end)

function showKillNotification(count)
    if not Config.notificationsEnabled then return end
    local gui = Instance.new("ScreenGui")
    gui.Name = "TN_" .. tick()
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = Services.CoreGui
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 190, 0, 75)
    frame.Position = UDim2.new(1, 20, 0, 10 + (#Data.activeNotifs * 80))
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(184, 164, 101)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "Successfully\nHit:"
    label.TextColor3 = Color3.fromRGB(184, 164, 101)
    label.Font = Enum.Font.Fantasy
    label.TextScaled = true
    local counter = Instance.new("TextLabel", frame)
    counter.Size = UDim2.new(0, 60, 0.5, 0)
    counter.Position = UDim2.new(1, -65, 0, 0)
    counter.BackgroundTransparency = 1
    counter.Text = tostring(count)
    counter.TextColor3 = Color3.fromRGB(255, 255, 255)
    counter.Font = Enum.Font.Fantasy
    counter.TextScaled = true
    table.insert(Data.activeNotifs, gui)
    Services.TweenService:Create(frame, TweenInfo.new(0.35), {
        Position = UDim2.new(1, -210, 0, 10 + ((#Data.activeNotifs - 1) * 80))
    }):Play()
    task.delay(5, function()
        gui:Destroy()
        for i, v in ipairs(Data.activeNotifs) do
            if v == gui then table.remove(Data.activeNotifs, i) break end
        end
    end)
end

function getClosestValidNape()
    local titansFolder = workspace:FindFirstChild("Titans")
    if not titansFolder then return nil end
    local priorityList = {"Attack_Titan", "Female_Titan", "Armored_Titan"}
    for _, titanName in ipairs(priorityList) do
        local titan = titansFolder:FindFirstChild(titanName)
        if titan and titan:FindFirstChild("Humanoid") and titan.Humanoid.Health > 0 then
            local nape = titan:FindFirstChild("Hitboxes") and titan.Hitboxes:FindFirstChild("Hit") and titan.Hitboxes.Hit:FindFirstChild("Nape")
            if nape then return nape end
        end
    end
    local closest, minDist = nil, math.huge
    for _, titan in ipairs(titansFolder:GetChildren()) do
        if not table.find(priorityList, titan.Name) then
            local nape = titan:FindFirstChild("Hitboxes") and titan.Hitboxes:FindFirstChild("Hit") and titan.Hitboxes.Hit:FindFirstChild("Nape")
            local humanoid = titan:FindFirstChildWhichIsA("Humanoid")
            if nape and humanoid and humanoid.Health > 0 then
                local dist = (Player.hrp.Position - nape.Position).Magnitude
                if dist < minDist then closest = nape minDist = dist end
            end
        end
    end
    return closest
end

function killFromAbove()
    task.delay(Config.startDelay, function()
        Services.RunService.Heartbeat:Connect(function()
            if not Config.isFlying or not Player.character:FindFirstChild("HumanoidRootPart") then return end
            local nape = getClosestValidNape()
            if not nape then return end
            local targetPos = nape.Position + Vector3.new(0, Config.flyHeight, 0)
            if Config.moveMode == "Gliding" then
                Player.hrp.AssemblyLinearVelocity = (targetPos - Player.hrp.Position).Unit * Config.flySpeed
            else
                Player.hrp.CFrame = CFrame.new(targetPos)
            end
            if (Player.hrp.Position - nape.Position).Magnitude <= 1520 and Config.canHit then
                Config.canHit = false
                task.spawn(function()
                    local id = tostring(nape:GetDebugId())
                    if Data.POST then
                        Data.POST:FireServer("Hitboxes", "Register", nape, math.random(200, 300), math.random(20, 30) / 100)
                        Data.POST:FireServer("Attacks", "Slash", true)
                    end
                    if not Data.notified[id] then
                        Data.notified[id] = true
                        Config.titanKillCount = Config.titanKillCount + 1
                        showKillNotification(Config.titanKillCount)
                    end
                    task.wait(0.25)
                    Config.canHit = true
                end)
            end
        end)
    end)
end

--//==============================\\--
--||   👑 REFILL / RELOAD SYSTEM  ||--
--\\==============================//--

local BladeUI_S2       = nil
local Gradient_S2      = nil
local SetsLabel_S2     = nil
local autoBladeRunning = false

pcall(function()
    BladeUI_S2    = player.PlayerGui.Interface.HUD.Main.Top["7"].Blades
    Gradient_S2   = BladeUI_S2.Inner.Bar.Gradient
    SetsLabel_S2  = BladeUI_S2.Sets
end)

local function TweenTo_S2(cf, speed)
    local charRef = player.Character if not charRef then return end
    local hrpRef  = charRef:FindFirstChild("HumanoidRootPart")
    local humRef  = charRef:FindFirstChild("Humanoid")
    if not hrpRef or not humRef or humRef.Health <= 0 then return end
    local distance = (hrpRef.Position - cf.Position).Magnitude
    local t        = distance / speed
    local tween    = TweenService:Create(hrpRef, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = cf})
    tween:Play()
    return tween
end

local function FindRefillPart()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local name = v.Name:lower()
            if name:find("refill") or name:find("fill") then
                local display = v:FindFirstChild("Display")
                if display then
                    local ok, title = pcall(function() return display.Main.Top.Title.Text end)
                    if ok and title ~= "REFILLS: 0 / 3 [R]" then
                        return v
                    end
                end
            end
        end
    end
    return nil
end

local function Refill_S2()
    local refillPart = FindRefillPart()
    if not refillPart then return end
    TweenTo_S2(refillPart.CFrame, 6000)
    pcall(function()
        ReplicatedStorage.Assets.Remotes.POST:FireServer("Attacks", "Reload", refillPart)
    end)
end

local function ChangeBlade_S2()
    pcall(function()
        ReplicatedStorage.Assets.Remotes.GET:InvokeServer("Blades", "Reload")
    end)
end

local function CheckBlade_S2()
    if not Gradient_S2 then return false end
    local x = Gradient_S2.Offset.X
    if x < 0 then
        local bladeOk = false
        pcall(function()
            local rig = workspace.Characters[player.Name]["Rig_" .. player.Name]
            local blade = rig.LeftHand.Blade_1
            if blade.Transparency == 0 then bladeOk = true end
        end)
        if bladeOk then return false end
        if SetsLabel_S2 and SetsLabel_S2.Text == "0 / 3" then
            Refill_S2()
        else
            ChangeBlade_S2()
        end
        return true
    end
    return false
end

if Gradient_S2 then
    Gradient_S2:GetPropertyChangedSignal("Offset"):Connect(function()
        if autoBladeRunning then CheckBlade_S2() end
    end)
end

Tabs.Main:AddToggle("AutoBladeReload", {
    Title = "Auto Reload / Refill Blades",
    Description = "Switches blade sets automatically; teleports to refill station when all sets are empty",
    Default = false,
    Callback = function(state)
        autoBladeRunning = state
        if state then
            task.spawn(function()
                while autoBladeRunning do
                    CheckBlade_S2()
                    task.wait(0.3)
                end
            end)
        end
    end
})

Tabs.Main:AddToggle("AutoKillTitans", {
    Title = "Auto Kill Titans",
    Description = "Don't Finish the mission under 17 sec",
    Default = false,
    Callback = function(state)
        Config.isFlying = state
        if Config.isFlying then task.spawn(killFromAbove) end
    end
})

Tabs.Main:AddDropdown("MoveMode", {
    Title = "Movement Mode",
    Values = {"Teleportation", "Gliding"},
    Default = 1,
    Callback = function(option) Config.moveMode = option end
})

Tabs.Main:AddSlider("StartDelaySlider", {
    Title = "Farm Delay",
    Description = "MINIMUM 20 SECONDS For Thunder Spears / MINIMUM 10 SECONDS For Blades",
    Default = 5,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Callback = function(value) Config.startDelay = value end
})

Tabs.Main:AddSlider("FlySpeedSlider", {
    Title = "Gliding Speed",
    Default = 300,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(value) Config.flySpeed = value end
})

Tabs.Main:AddSlider("FlyHeightSlider", {
    Title = "Float Height",
    Default = 250,
    Min = 50,
    Max = 300,
    Rounding = 0,
    Callback = function(value) Config.flyHeight = value end
})

--//==============================\\--
--||           👑 AUTO Ts         ||--
--\\==============================//--

local S={Players=game:GetService("Players"),ReplicatedStorage=game:GetService("ReplicatedStorage"),RunService=game:GetService("RunService")}
local P={self=S.Players.LocalPlayer,char=nil,hrp=nil,gui=nil}
P.char,P.gui=P.self.Character or P.self.CharacterAdded:Wait(),P.self:WaitForChild("PlayerGui")
P.hrp=P.char:WaitForChild("HumanoidRootPart")

local R=S.ReplicatedStorage.Assets.Remotes
local GET,POST=R.GET,R.POST
local C={isHovering=false,hoverPos=nil,autoTSRunning=false,killMode="Safe",lastBladesEmpty=false,lastSpearsEmpty=false}

local function getSpears()
    local l=P.gui:FindFirstChild("Interface",true)and P.gui.Interface.HUD.Main.Top.Spears:FindFirstChild("Spears",true)
    if l and l:IsA("TextLabel")then
        local c=tonumber(l.Text:match("^(%d+)")or"0")
        return tostring(c),c>0
    end
    return"0",false
end

local function getNapes(limit)
    local pr={"Female_Titan","Attack_Titan","Armored_Titan"}
    local sel,out={},{}
    for _,t in ipairs(workspace.Titans:GetChildren())do
        if table.find(pr,t.Name)then
            local h,n=t:FindFirstChild("Humanoid"),t:FindFirstChild("Hitboxes")and t.Hitboxes:FindFirstChild("Hit")and t.Hitboxes.Hit:FindFirstChild("Nape")
            if h and h.Health>0 and n then
                for i=1,limit do table.insert(sel,{part=n,dist=(P.hrp.Position-n.Position).Magnitude})end
            end
        end
    end
    if#sel>0 then
        table.sort(sel,function(a,b)return a.dist<b.dist end)
        for i=1,math.min(limit,#sel)do table.insert(out,sel[i].part)end
        return out
    end
    for _,t in ipairs(workspace.Titans:GetChildren())do
        if not table.find(pr,t.Name)then
            local h,n=t:FindFirstChild("Humanoid"),t:FindFirstChild("Hitboxes")and t.Hitboxes:FindFirstChild("Hit")and t.Hitboxes.Hit:FindFirstChild("Nape")
            if h and h.Health>0 and n then
                table.insert(sel,{part=n,dist=(P.hrp.Position-n.Position).Magnitude})
            end
        end
    end
    table.sort(sel,function(a,b)return a.dist<b.dist end)
    for i=1,math.min(limit,#sel)do table.insert(out,sel[i].part)end
    return out
end

local function tpAbove(part)
    local tp=part.Position+Vector3.new(0,flyHeight,0)
    local d=(P.hrp.Position-tp).Magnitude
    if d>150 then P.char:PivotTo(CFrame.new(tp))else P.hrp.CFrame=CFrame.new(tp)end
    C.hoverPos,C.isHovering=tp,true
end

S.RunService.Heartbeat:Connect(function()
    if C.isHovering and C.hoverPos then
        P.hrp.Velocity=Vector3.zero
        P.hrp.CFrame=CFrame.new(C.hoverPos)
    end
end)

local function killLoop()
    local first=true
    while C.autoTSRunning do
        task.wait(1)
        if workspace:FindFirstChild("Debris")and workspace.Debris:FindFirstChild("Roar")then
            repeat task.wait(.1)until not workspace.Debris:FindFirstChild("Roar")
        end
        local slot,hasAmmo=getSpears()
        if hasAmmo then
            local kc=C.killMode=="Risk"and math.random(10,25)or math.random(3,10)
            local napes=getNapes(kc)
            if#napes>0 then
                tpAbove(napes[1])
                if first then task.wait(startDelay)first=false end
                GET:InvokeServer("Spears","S_Fire",slot)
                for _,n in ipairs(napes)do
                    if n and n.Position then
                        POST:FireServer("Spears","S_Explode",n.Position,0.501303055920385,450.20495501920485)
                    end
                end
            end
        end
        if not C.hoverPos then C.hoverPos=P.hrp.Position+Vector3.new(0,flyHeight,0)end
        C.isHovering=true
    end
end

Tabs.Ts:AddToggle("AutoTS_Free",{
    Title="Auto Thunder Spears",
    Default=false,
    Callback=function(s)
        C.autoTSRunning=s
        if s then task.spawn(killLoop)end
    end
})

Tabs.Ts:AddDropdown("KillModeDropdown",{
    Title="Kill Mode",
    Values={"Safe","Risk"},
    Multi=false,
    Default="Safe",
    Callback=function(v)C.killMode=v end
})

--//==============================\\--
--||        👑 AUTO Retry         ||--
--\\==============================//--

local VIM = game:GetService("VirtualInputManager")

local interface = player:FindFirstChild("PlayerGui")
    and player.PlayerGui:FindFirstChild("Interface")

local rewards     = interface and interface:FindFirstChild("Rewards")
local rewardsMain = rewards and rewards:FindFirstChild("Main")
local retryBtn    = rewardsMain
    and rewardsMain:FindFirstChild("Info")
    and rewardsMain.Info:FindFirstChild("Main")
    and rewardsMain.Info.Main:FindFirstChild("Buttons")
    and rewardsMain.Info.Main.Buttons:FindFirstChild("Retry")

local autoRetryEnabled = false

local function showDebugDot(x, y)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(0, x - 5, 0, y - 5)
    dot.BackgroundColor3 = Color3.new(1, 0, 0)
    dot.BorderSizePixel = 0
    dot.ZIndex = 10000
    dot.Name = "DebugDot"
    pcall(function() dot.Parent = game:GetService("CoreGui") end)
    game:GetService("Debris"):AddItem(dot, 2)
end

local function Retryshi()
    local pos  = retryBtn.AbsolutePosition
    local size = retryBtn.AbsoluteSize
    local inset = GuiService:GetGuiInset()
    local x = pos.X + size.X / 2 + 20
    local y
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        y = pos.Y + size.Y / 2 + 60
    else
        y = pos.Y + size.Y / 2 + inset.Y
    end
    showDebugDot(x, y)
    VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

local function shouldClickRetry()
    return retryBtn
        and rewards and rewards.Visible
        and rewardsMain and rewardsMain.Visible
        and retryBtn.Visible
        and retryBtn.AbsoluteSize.Magnitude > 10
end

task.spawn(function()
    while true do
        if autoRetryEnabled and shouldClickRetry() then
            task.wait(1)
            if shouldClickRetry() then
                Retryshi()
                task.wait(3.5)
            end
        end
        task.wait(0.5)
    end
end)

Tabs.Main:AddToggle("AutoRetryToggle", {
    Title = "Auto Retry",
    Default = false,
    Callback = function(state) autoRetryEnabled = state end
})

--//==============================\\--
--||        👑 AUTO Escape        ||--
--\\==============================//--

local escapeRunning    = false
local escapeThread     = nil
local cleanGUIThread   = nil
local lastEscapeButton = nil

Tabs.Main:AddToggle("Escape", {
    Title = "Auto Escape",
    Default = false,
    Callback = function(Value)
        escapeRunning = Value
        if escapeRunning then
            escapeThread = task.spawn(function()
                while escapeRunning do
                    local iface   = player:WaitForChild("PlayerGui"):FindFirstChild("Interface")
                    local buttons = iface and iface:FindFirstChild("Buttons")
                    if buttons then
                        local currentButtons = buttons:GetChildren()
                        if #currentButtons > 0 then
                            local newestButton = currentButtons[1]
                            if newestButton ~= lastEscapeButton then
                                lastEscapeButton = newestButton
                                POST:FireServer("Attacks", "Slash_Escape")
                            end
                        else
                            lastEscapeButton = nil
                        end
                    else
                        lastEscapeButton = nil
                    end
                    task.wait(0.1)
                end
            end)
            cleanGUIThread = task.spawn(function()
                while escapeRunning do
                    local iface   = player:WaitForChild("PlayerGui"):FindFirstChild("Interface")
                    local buttons = iface and iface:FindFirstChild("Buttons")
                    if buttons then
                        for _, btn in pairs(buttons:GetChildren()) do btn:Destroy() end
                    end
                    task.wait(0.1)
                end
            end)
        else
            escapeRunning = false
            lastEscapeButton = nil
        end
    end
})

--//==============================\\--
--||        👑 Nape extend        ||--
--\\==============================//--

local newSize   = Vector3.new(1500, 1500, 1500)
local connection

local function resizeNapes()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "Nape" then
            v.Size = newSize
            local cf = v.CFrame v.CFrame = cf
        end
    end
end

Tabs.Main:AddToggle("nape", {
    Title = "Nape extend",
    Default = false,
    Callback = function(state)
        if state then
            resizeNapes()
            connection = workspace.DescendantAdded:Connect(function(desc)
                if desc:IsA("BasePart") and desc.Name == "Nape" then
                    task.wait(0.1)
                    desc.Size = newSize
                    local cf = desc.CFrame desc.CFrame = cf
                end
            end)
        else
            if connection then connection:Disconnect() connection = nil end
        end
    end
})

--//==============================\\--
--||       👑  Titan Ripper       ||--
--\\==============================//--

local Event = ReplicatedStorage.Assets.Remotes.GET

local SkillData
local success2, result2 = pcall(function()
    return ReplicatedStorage:WaitForChild("Modules", 5)
        :WaitForChild("Storage", 5)
        :WaitForChild("Skill", 5)
end)

if success2 and result2 then SkillData = require(result2) else SkillData = {} end

local autoSkillEnabled = false

local skills = {
    ["14"] = { lastUsed = 0, initialDelay = 0 },
    ["23"] = { lastUsed = 0, initialDelay = 0.4 }
}

for skillID, info in pairs(skills) do
    task.spawn(function()
        task.wait(info.initialDelay)
        while true do
            task.wait(0.1)
            if autoSkillEnabled then
                local now = tick()
                local skillInfo = typeof(SkillData) == "table" and SkillData[skillID]
                if skillInfo and skillInfo.Cooldown then
                    if now - info.lastUsed >= skillInfo.Cooldown then
                        local ok = pcall(function()
                            Event:InvokeServer("S_Skills", "Usage", skillID, false)
                        end)
                        if ok then info.lastUsed = tick() end
                    end
                end
            end
        end
    end)
end

Tabs.Main:AddToggle("AutoSkillNapeToggle", {
    Title = "Titan Ripper",
    Default = false,
    Callback = function(state)
        autoSkillEnabled = state
        if state then
            for _, info in pairs(skills) do info.lastUsed = 0 end
            resizeNapes()
            connection = workspace.DescendantAdded:Connect(function(desc)
                if desc:IsA("BasePart") and desc.Name == "Nape" then
                    task.wait(0.1)
                    desc.Size = newSize
                    desc.CFrame = desc.CFrame
                end
            end)
        else
            if connection then connection:Disconnect() connection = nil end
        end
    end
})

--//==============================\\--
--||       👑 AUTO CLICK M1       ||--
--\\==============================//--

local autoClickEnabled = false
local autoClickDelay   = 0.1
local autoClickThread  = nil

-- Finds the on-screen attack button (mobile/UI button) if the game has one
local function findAttackButton()
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return nil end
    for _, d in ipairs(pg:GetDescendants()) do
        if d:IsA("GuiButton") and d.Visible and d.AbsoluteSize.Magnitude > 10 then
            local n = d.Name:lower()
            if n == "attack" or n == "slash" or n == "m1" or n == "atk" then
                return d
            end
        end
    end
    return nil
end

local function clickAt(x, y)
    VIM:SendMouseButtonEvent(x, y, 0, true,  game, 0)
    task.wait(0.02)
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

local function doAutoClick()
    -- 1) Click the attack button if one exists on screen
    local btn = findAttackButton()
    if btn then
        local pos, size = btn.AbsolutePosition, btn.AbsoluteSize
        local inset = GuiService:GetGuiInset()
        clickAt(pos.X + size.X / 2, pos.Y + size.Y / 2 + inset.Y)
    end

    -- 2) Always send an M1 (left click) at screen center
    local cam = workspace.CurrentCamera
    if cam then
        local vs = cam.ViewportSize
        clickAt(vs.X / 2, vs.Y / 2)
    end

    -- 3) Fire the game's own Slash remote as a backup so the hit registers
    pcall(function()
        ReplicatedStorage.Assets.Remotes.POST:FireServer("Attacks", "Slash", true)
        ReplicatedStorage.Assets.Remotes.POST:FireServer("Attacks", "Slash", false)
    end)
end

Tabs.Main:AddToggle("AutoClickM1", {
    Title = "Auto Click M1 / Attack",
    Description = "Keeps clicking M1 and the attack button while enabled",
    Default = false,
    Callback = function(state)
        autoClickEnabled = state
        if state then
            if autoClickThread then task.cancel(autoClickThread) end
            autoClickThread = task.spawn(function()
                while autoClickEnabled do
                    pcall(doAutoClick)
                    task.wait(autoClickDelay)
                end
            end)
        else
            if autoClickThread then
                task.cancel(autoClickThread)
                autoClickThread = nil
            end
        end
    end
})

Tabs.Main:AddSlider("AutoClickDelaySlider", {
    Title = "Auto Click Delay",
    Description = "Seconds between clicks (lower = faster)",
    Default = 0.1,
    Min = 0.05,
    Max = 1,
    Rounding = 2,
    Callback = function(value) autoClickDelay = value end
})

--//==============================\\--
--||         👑 Auto Roll         ||--
--\\==============================//--

local CLICK_DELAY = 0.2
local WAIT_DELAY  = 1
local ENABLED     = false

local function canClick(btn)
    return btn and btn.Visible and btn.AbsoluteSize.Magnitude > 10
end

local function isActuallyVisible(obj)
    if not obj then return false end
    local current = obj
    local Gui = player:WaitForChild("PlayerGui")
    while current and current ~= Gui do
        local success3, result3 = pcall(function() return current.Visible end)
        if success3 and not result3 then return false end
        current = current.Parent
    end
    return obj.AbsoluteSize.Magnitude > 10
end

local function clickButton(btn)
    if not btn then return false end
    local pos  = btn.AbsolutePosition
    local size = btn.AbsoluteSize
    local inset = GuiService:GetGuiInset()
    local x = pos.X + size.X / 2
    local y = pos.Y + size.Y / 2 + inset.Y
    VIM:SendMouseMoveEvent(x, y, game)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
    return true
end

local function findButton(parent, buttonName)
    if not parent then return nil end
    local function searchRecursive(obj)
        if obj.Name == buttonName and obj:IsA("GuiButton") then return obj end
        for _, child in pairs(obj:GetChildren()) do
            local result4 = searchRecursive(child)
            if result4 then return result4 end
        end
        return nil
    end
    return searchRecursive(parent)
end

local function findButtonByText(parent, text)
    if not parent then return nil end
    local function searchRecursive(obj)
        if obj:IsA("GuiButton") or obj:IsA("TextButton") then
            local hasText = obj:FindFirstChild("Text") or obj.Text
            if hasText and string.find(string.lower(tostring(hasText)), string.lower(text)) then return obj end
        end
        for _, child in pairs(obj:GetChildren()) do
            local result5 = searchRecursive(child)
            if result5 then return result5 end
        end
        return nil
    end
    return searchRecursive(parent)
end

task.spawn(function()
    local Gui = player:WaitForChild("PlayerGui")
    local interface2 = Gui:WaitForChild("Interface", 10)
    if not interface2 then return end
    local rollButton = nil
    local searchPaths = {"Customisation.Family.Buttons_2.Roll", "Roll", "RollButton"}
    for _, path in pairs(searchPaths) do
        local pathParts = string.split(path, ".")
        local current = interface2
        for _, part in pairs(pathParts) do
            if current then current = current:FindFirstChild(part) end
        end
        if current and current:IsA("GuiButton") then rollButton = current break end
    end
    if not rollButton then rollButton = findButton(interface2, "Roll") end
    if not rollButton then rollButton = findButtonByText(interface2, "roll") end
    if not rollButton then return end
    while true do
        if ENABLED then
            if canClick(rollButton) and isActuallyVisible(rollButton) then
                clickButton(rollButton)
                task.wait(CLICK_DELAY)
            else task.wait(WAIT_DELAY) end
        else task.wait(1) end
    end
end)

--//==============================\\--
--||        AUTO JOIN TAB         ||--
--\\==============================//--

local Difficulties      = {"Best For You","Easy","Normal","Hard","Severe","Aberrant"}
local DifficultiesRaids = {"Best For You","Hard","Severe","Aberrant"}
local ModifiersList     = {"No Perks","No Skills","No Memories","Nightmare","Oddball","Injury Prone","Chronic Injuries","Fog","Glass Cannon","Time Trial","Boring","Simple"}
local MissionMaps       = {"Shiganshina","Trost","Outskirts","Forest","Utgard","Docks","Stohess","Chapel"}
local MissionObjectives = {
    ["Shiganshina"]={"Skirmish","Breach","Random"},
    ["Trost"]      ={"Skirmish","Protect","Random"},
    ["Outskirts"]  ={"Skirmish","Escort","Random"},
    ["Forest"]     ={"Skirmish","Guard","Random"},
    ["Utgard"]     ={"Skirmish","Defend","Random"},
    ["Docks"]      ={"Skirmish","Stall","Random"},
    ["Stohess"]    ={"Skirmish","Random"},
    ["Chapel"]     ={"Skirmish","Random"},
}
local RaidMaps      = {"Shiganshina","Trost","Stohess"}
local RaidObjectives= {["Shiganshina"]={"Armored Titan","Colossal Titan"},["Trost"]={"Attack Titan"},["Stohess"]={"Female Titan"}}
local WaveMaps      = {"Trost"}

_G.AJ = {
    SelectMissionMap        = MissionMaps[1],
    SelectMissionObjective  = MissionObjectives[MissionMaps[1]][1],
    SelectMissionDifficulty = "Easy",
    SelectMissionModifiers  = {},
    SelectRaidMap           = RaidMaps[1],
    SelectRaidObjective     = RaidObjectives[RaidMaps[1]][1],
    SelectRaidDifficulty    = "Easy",
    SelectRaidModifiers     = {},
    SelectWaveMap           = WaveMaps[1],
    AutoJoinMission         = false,
    AutoJoinMissionBoost    = false,
    AutoJoinRaid            = false,
    AutoJoinWaves           = false,
}

local function PressButton(d)
    game:GetService("GuiService").SelectedObject = d
    VIM:SendKeyEvent(true,  Enum.KeyCode.Return, false, game)
    task.wait(0.05)
    VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
end

local function CreateAndStart(data)
    if game.PlaceId == 14916516914 then
        local ok, res = pcall(function() return GET:InvokeServer("S_Missions","Create",data) end)
        if ok and typeof(res) == "Instance" then
            task.wait(1)
            pcall(function() return GET:InvokeServer("S_Missions","Start") end)
            return true
        end
        return false
    end
end

-- Mission section
Tabs.AutoJoin:AddSection("Auto Join Missions")

local MissionObjectiveDropdown2

Tabs.AutoJoin:AddDropdown("AJ_MissionMap", {
    Title = "Select Map",
    Values = MissionMaps,
    Default = _G.AJ.SelectMissionMap,
    Callback = function(v)
        _G.AJ.SelectMissionMap = v
        local objs = MissionObjectives[v]
        if objs then _G.AJ.SelectMissionObjective = objs[1] end
        if MissionObjectiveDropdown2 then MissionObjectiveDropdown2:SetValues(MissionObjectives[v] or {}) end
    end
})

MissionObjectiveDropdown2 = Tabs.AutoJoin:AddDropdown("AJ_MissionObjective", {
    Title = "Select Objective",
    Values = MissionObjectives[_G.AJ.SelectMissionMap] or {},
    Default = _G.AJ.SelectMissionObjective,
    Callback = function(v) _G.AJ.SelectMissionObjective = v end
})

Tabs.AutoJoin:AddDropdown("AJ_MissionDifficulty", {
    Title = "Select Difficulty",
    Values = Difficulties,
    Default = _G.AJ.SelectMissionDifficulty,
    Callback = function(v) _G.AJ.SelectMissionDifficulty = v end
})

Tabs.AutoJoin:AddDropdown("AJ_MissionModifiers", {
    Title = "Select Modifiers",
    Values = ModifiersList,
    Multi = true,
    Default = _G.AJ.SelectMissionModifiers,
    Callback = function(v) _G.AJ.SelectMissionModifiers = v end
})

Tabs.AutoJoin:AddToggle("AJ_AutoJoinMission", {
    Title = "Auto Join Mission",
    Description = "Automatically joins missions",
    Default = false,
    Callback = function(v) _G.AJ.AutoJoinMission = v end
})

task.spawn(function()
    while task.wait() do
        if _G.AJ.AutoJoinMission then
            CreateAndStart({Name=_G.AJ.SelectMissionMap,Type="Missions",Difficulty=_G.AJ.SelectMissionDifficulty,Objective=_G.AJ.SelectMissionObjective,Modifiers=_G.AJ.SelectMissionModifiers,Limit=8})
        end
    end
end)

Tabs.AutoJoin:AddToggle("AJ_AutoJoinMissionBoost", {
    Title = "Auto Join Mission (Rewards Boost)",
    Description = "Automatically joins boosted missions",
    Default = false,
    Callback = function(v) _G.AJ.AutoJoinMissionBoost = v end
})

task.spawn(function()
    while task.wait() do
        if _G.AJ.AutoJoinMissionBoost then
            CreateAndStart({Name=game:GetService("Workspace"):GetAttribute("Boosted_Map"),Type="Missions",Difficulty=_G.AJ.SelectMissionDifficulty,Objective=_G.AJ.SelectMissionObjective,Modifiers=_G.AJ.SelectMissionModifiers,Limit=8})
        end
    end
end)

-- Raids section
Tabs.AutoJoin:AddSection("Auto Join Raids")

local RaidObjectiveDropdown2

Tabs.AutoJoin:AddDropdown("AJ_RaidMap", {
    Title = "Select Raid Map",
    Values = RaidMaps,
    Default = _G.AJ.SelectRaidMap,
    Callback = function(v)
        _G.AJ.SelectRaidMap = v
        local objs = RaidObjectives[v]
        if objs then _G.AJ.SelectRaidObjective = objs[1] end
        if RaidObjectiveDropdown2 then RaidObjectiveDropdown2:SetValues(RaidObjectives[v] or {}) end
    end
})

RaidObjectiveDropdown2 = Tabs.AutoJoin:AddDropdown("AJ_RaidObjective", {
    Title = "Select Raid Boss",
    Values = RaidObjectives[_G.AJ.SelectRaidMap] or {},
    Default = _G.AJ.SelectRaidObjective,
    Callback = function(v) _G.AJ.SelectRaidObjective = v end
})

Tabs.AutoJoin:AddDropdown("AJ_RaidDifficulty", {
    Title = "Select Difficulty",
    Values = DifficultiesRaids,
    Default = _G.AJ.SelectRaidDifficulty,
    Callback = function(v) _G.AJ.SelectRaidDifficulty = v end
})

Tabs.AutoJoin:AddDropdown("AJ_RaidModifiers", {
    Title = "Select Modifiers",
    Values = ModifiersList,
    Multi = true,
    Default = _G.AJ.SelectRaidModifiers,
    Callback = function(v) _G.AJ.SelectRaidModifiers = v end
})

Tabs.AutoJoin:AddToggle("AJ_AutoJoinRaid", {
    Title = "Auto Join Raid",
    Description = "Automatically joins raids",
    Default = false,
    Callback = function(v) _G.AJ.AutoJoinRaid = v end
})

task.spawn(function()
    while task.wait() do
        if _G.AJ.AutoJoinRaid then
            CreateAndStart({Name=_G.AJ.SelectRaidMap,Type="Raids",Difficulty=_G.AJ.SelectRaidDifficulty,Objective=_G.AJ.SelectRaidObjective,Modifiers=_G.AJ.SelectRaidModifiers,Limit=8})
        end
    end
end)

-- Waves section
Tabs.AutoJoin:AddSection("Auto Join Waves")

Tabs.AutoJoin:AddDropdown("AJ_WaveMap", {
    Title = "Select Wave Map",
    Values = WaveMaps,
    Default = _G.AJ.SelectWaveMap,
    Callback = function(v) _G.AJ.SelectWaveMap = v end
})

Tabs.AutoJoin:AddToggle("AJ_AutoJoinWaves", {
    Title = "Auto Join Waves",
    Description = "Automatically joins waves",
    Default = false,
    Callback = function(v) _G.AJ.AutoJoinWaves = v end
})

task.spawn(function()
    while task.wait() do
        if _G.AJ.AutoJoinWaves then
            CreateAndStart({Name=_G.AJ.SelectWaveMap,Type="Waves",Difficulty="Easy",Objective="Waves",Limit=8})
        end
    end
end)

-- Leave wrong mission auto-correct
spawn(function()
    while task.wait() do
        if _G.AJ.AutoJoinMission or _G.AJ.AutoJoinRaid or _G.AJ.AutoJoinWaves then
            for _, v in pairs(game:GetService("ReplicatedStorage").Missions:GetChildren()) do
                if v.Leader.Value == player.Name then
                    local Target = nil
                    if _G.AJ.AutoJoinMission then Target = _G.AJ.SelectMissionMap
                    elseif _G.AJ.AutoJoinMissionBoost then Target = game:GetService("Workspace"):GetAttribute("Boosted_Map")
                    elseif _G.AJ.AutoJoinRaid then Target = _G.AJ.SelectRaidMap
                    elseif _G.AJ.AutoJoinWaves then Target = _G.AJ.SelectWaveMap end
                    if v.Name ~= Target then
                        GET:InvokeServer("S_Missions","Leave")
                    end
                end
            end
        end
    end
end)

--//==============================\\--
--||        SERVERS TAB           ||--
--\\==============================//--

local TPS = TeleportService

Tabs.Servers:AddSection("Server")

Tabs.Servers:AddInput("JobIDInput", {
    Title = "JobID",
    Placeholder = "Paste Job ID here",
    Callback = function(x) _G.JobId_Textbox = x end
})

Tabs.Servers:AddToggle("AutoJoinJobID", {
    Title = "Auto Join JobID",
    Default = false,
    Callback = function(v)
        _G.AutoJoinJobID = v
        if v then
            task.spawn(function()
                while _G.AutoJoinJobID do
                    if _G.JobId_Textbox and _G.JobId_Textbox ~= "" then
                        TPS:TeleportToPlaceInstance(game.PlaceId, _G.JobId_Textbox, player)
                        Fluent:Notify({ Title="AstaRoth", Content="Joining JobID... Please wait.", Duration=3 })
                    else
                        warn("Please enter a JobID before enabling Auto Join JobID")
                        _G.AutoJoinJobID = false break
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

Tabs.Servers:AddButton({
    Title = "Join JobID",
    Callback = function()
        TPS:TeleportToPlaceInstance(game.PlaceId, _G.JobId_Textbox, player)
        Fluent:Notify({ Title="AstaRoth", Content="Joining JobID... Please wait.", Duration=3 })
    end
})

Tabs.Servers:AddButton({
    Title = "Copy JobID",
    Callback = function()
        setclipboard(game.JobId)
        Fluent:Notify({ Title="AstaRoth", Content="Copied JobID!", Duration=3 })
    end
})

Tabs.Servers:AddSection("Basic")

Tabs.Servers:AddButton({
    Title = "Rejoin",
    Description = "Re-enter the same server",
    Callback = function() TeleportService:Teleport(game.PlaceId, player) end
})

getgenv().ServerHop = function()
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local data = HttpService:JSONDecode(game:HttpGet(url))
    for _, v in ipairs(data.data or {}) do
        if v.playing < v.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, Players.LocalPlayer) return
        end
    end
end

Tabs.Servers:AddButton({
    Title = "Server Hop",
    Description = "Move to new server",
    Callback = function() getgenv().ServerHop() end
})

Tabs.Servers:AddSection("Smart Server")

Tabs.Servers:AddSlider("MaxPlayersFilter", {
    Title = "Max Players Filter",
    Min = 1,
    Max = 20,
    Default = 5,
    Rounding = 0,
    Callback = function(v) _G.SetP = v end
})

Tabs.Servers:AddButton({
    Title = "Smart Hop",
    Description = "Find server with fewest players",
    Callback = function()
        local limit = _G.SetP
        local body = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"))
        for _, v in ipairs(body.data or {}) do
            if v.playing <= limit then TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, player) break end
        end
    end
})

Tabs.Servers:AddButton({
    Title = "Low Ping Hop",
    Description = "Find lowest ping server",
    Callback = function()
        pcall(function()
            local bestServer, lowestPing = nil, math.random(50, 200)
            local body = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"))
            for _, v in ipairs(body.data or {}) do
                local ping = tonumber(v.ping)
                if ping and ping < lowestPing then lowestPing = ping bestServer = v.id end
            end
            if bestServer then TeleportService:TeleportToPlaceInstance(game.PlaceId, tostring(bestServer), player) end
        end)
    end
})

--//==============================\\--
--||        PRESTIGER TAB         ||--
--\\==============================//--

local ListMemories = {"Overslash","Gambler","Afterimages","Marksman","Amputation","Assassin","Furyforge","Quakestrike","Stormcharged","Stalwart","Surgeshot","Swiftshot","Blitzblade","Crescendo","Guardian","Deflectra","Aegisurge","Riposte","Resilience","Vengeflare","Steel","Frame","Necromantic","Thanatophobia","Mendmaster","Cooldown Blitz","Lifefeed","Vitalize","Gem","Fiend","Omnirange","Flashstep","Tactician","Bloodthief","Apotheosis"}

_G.PR = {
    SelectMemories = {ListMemories[1]},
    SelectBoost    = "Luck Boost",
    AutoPrestige   = false,
}

Tabs.Prestiger:AddSection("Prestiger Options")

Tabs.Prestiger:AddDropdown("PR_SelectMemories", {
    Title = "Select Memories",
    Values = ListMemories,
    Multi = true,
    Default = _G.PR.SelectMemories,
    Callback = function(v) _G.PR.SelectMemories = v end
})

Tabs.Prestiger:AddDropdown("PR_SelectBoost", {
    Title = "Select Boost",
    Values = {"Luck Boost","Gold Boost","EXP Boost"},
    Default = _G.PR.SelectBoost,
    Callback = function(v) _G.PR.SelectBoost = v end
})

Tabs.Prestiger:AddToggle("PR_AutoPrestige", {
    Title = "Auto Prestige",
    Description = "Automatically prestiges when ready",
    Default = false,
    Callback = function(v) _G.PR.AutoPrestige = v end
})

spawn(function()
    while task.wait() do
        if _G.PR.AutoPrestige then
            local LP2 = game:GetService("Players").LocalPlayer
            local prestige = LP2:GetAttribute("Prestige")
            local level    = LP2:GetAttribute("Level")
            local requirements = {[0]=100,[1]=125,[2]=150,[3]=175,[4]=200}
            if requirements[prestige] == level then
                if game.PlaceId ~= 14916516914 then
                    PressButton(LP2.PlayerGui.Interface.Rewards.Main.Info.Main.Buttons.Leave_2)
                elseif game.PlaceId == 14916516914 then
                    if workspace.Objects.Blackout.Memories:FindFirstChild(_G.PR.SelectBoost) then
                        if LP2.PlayerGui.Interface.Memories_Buttons.M_Confirm.Visible then
                            PressButton(LP2.PlayerGui.Interface.Memories_Buttons.M_Confirm)
                        else
                            fireclickdetector(workspace.Objects.Blackout.Memories[_G.PR.SelectBoost].Click)
                        end
                    else
                        local hasMemory = false
                        for _, name in ipairs(ListMemories) do
                            if workspace.Objects.Blackout.Memories:FindFirstChild(name) then hasMemory = true break end
                        end
                        if hasMemory then
                            local found = false
                            for _, v in pairs(workspace.Objects.Blackout.Memories:GetChildren()) do
                                for _, name in ipairs(_G.PR.SelectMemories) do
                                    if v.Name == name then
                                        if LP2.PlayerGui.Interface.Memories_Buttons.M_Confirm.Visible then
                                            PressButton(LP2.PlayerGui.Interface.Memories_Buttons.M_Confirm)
                                        else fireclickdetector(v.Click) end
                                        found = true break
                                    end
                                end
                                if found then break end
                            end
                            if not found then PressButton(LP2.PlayerGui.Interface.Memories_Buttons.M_Reroll) end
                        end
                        local hasSelectedMemory = false
                        for _, v in pairs(workspace.Objects.Blackout.Memories:GetChildren()) do
                            for _, name in ipairs(_G.PR.SelectMemories) do
                                if v.Name == name then hasSelectedMemory = true break end
                            end
                            if hasSelectedMemory then break end
                        end
                        if not hasSelectedMemory then
                            if LP2.PlayerGui.Interface.Topbar.Main.Categories.Equipment.Move.Offset.Y == 1 then
                                PressButton(LP2.PlayerGui.Interface.Topbar.Main.Categories.Equipment.Interact)
                            elseif LP2.PlayerGui.Interface.Topbar.Main.Categories.Equipment.Move.Offset.Y == 0 and LP2.PlayerGui.Interface.Equipment.Prestige.Visible == false then
                                PressButton(LP2.PlayerGui.Interface.Equipment.Categories.Prestige.Main.Interact)
                            elseif LP2.PlayerGui.Interface.Equipment.Prestige.Visible then
                                if LP2.PlayerGui.Interface.Warning.Prompt.Visible then
                                    PressButton(LP2.PlayerGui.Interface.Warning.Prompt.Main.Yes)
                                else PressButton(LP2.PlayerGui.Interface.Equipment.Prestige.B_Prestige) end
                            end
                        end
                    end
                end
            end
        end
    end
end)

--//==============================\\--
--||           MISC TAB           ||--
--\\==============================//--

getgenv().AutoHideAfterDelay = false

Tabs.Misc:AddToggle("AutoHideAfter10s", {
    Title = "Auto Hide UI (5s)",
    Default = false,
    Callback = function(state)
        getgenv().AutoHideAfterDelay = state
        if state then
            task.delay(5, function()
                if not getgenv().AutoHideAfterDelay then return end
                getgenv().AutoHideUI = true
                Window:Minimize()
            end)
        end
    end
})

local lastTap = 0
local function toggleUI()
    if Window._minimized then Window:Open() else Window:Minimize() end
end

UserInputService.TouchTap:Connect(function(_, gameProcessed)
    if gameProcessed then return end
    local now = tick()
    if now - lastTap <= 0.4 then toggleUI() end
    lastTap = now
end)

local scriptUrl = "https://pastebin.com/raw/EuX4Zsad"
local function getScript()
    if game.HttpGetAsync then return game:HttpGetAsync(scriptUrl)
    else return game:HttpGet(scriptUrl) end
end

local function run()
    task.spawn(function()
        local success6, err = pcall(function()
            local code = getScript()
            assert(code and code ~= "")
            local func = loadstring(code)
            assert(func)
            func()
        end)
        if success6 then print("Script executed successfully!")
        else warn("Error running script:", err) end
    end)
end

local function queueScript()
    local queueCode = string.format([[
        spawn(function()
            repeat wait() until game:IsLoaded()
            local success, err = pcall(function()
                local code
                if game.HttpGetAsync then
                    code = game:HttpGetAsync("%s")
                else
                    code = game:HttpGet("%s")
                end
                assert(code and code ~= "", "Failed to fetch script")
                local func = loadstring(code)
                assert(func, "Failed to compile script")
                func()
            end)
            if not success then
                warn("Auto-execute on teleport/rejoin failed:", err)
            end
        end)
    ]], scriptUrl, scriptUrl)

    if syn and syn.queue_on_teleport then syn.queue_on_teleport(queueCode)
    elseif queue_on_teleport then queue_on_teleport(queueCode)
    elseif fluxus and fluxus.queue_on_teleport then fluxus.queue_on_teleport(queueCode)
    elseif SecureLoad and SecureLoad.queue_on_teleport then SecureLoad.queue_on_teleport(queueCode)
    else warn("Your executor does not support queue_on_teleport.") end
end

Tabs.Misc:AddToggle("AutoExec", {
    Title = "Auto Execute Script",
    Default = false,
    Callback = function(state)
        if state then
            run()
            queueScript()
            Fluent:Notify({ Title = "Auto Execute", Content = "Script started and queued for teleport.", Duration = 4 })
        else
            Fluent:Notify({ Title = "Auto Execute", Content = "Toggle turned off. Script won't auto-run.", Duration = 4 })
        end
    end
})

Tabs.Misc:AddToggle("ToggleNotifications", {
    Title = "Notifications",
    Default = false,
    Callback = function(value) Config.notificationsEnabled = value end
})

-- Delete Map
local hiddenFolder = ReplicatedStorage:FindFirstChild("aristo_deletemap")
if not hiddenFolder then
    hiddenFolder = Instance.new("Folder")
    hiddenFolder.Name = "aristo_deletemap"
    hiddenFolder.Parent = ReplicatedStorage
end

Tabs.Misc:AddToggle("del", {
    Title = "Delete Map",
    Default = false,
    Callback = function(state)
        if state then
            local climbable = workspace:FindFirstChild("Climbable")
            if climbable then
                local fakeClimbable = Instance.new("Folder")
                fakeClimbable.Name = "Climbable"
                fakeClimbable.Parent = workspace
                climbable.Parent = hiddenFolder
            end
            local unclimbable = workspace:FindFirstChild("Unclimbable")
            if unclimbable then
                for _, child in ipairs(unclimbable:GetChildren()) do
                    local name = child.Name
                    local shouldKeep = (name == "Reloads" or name == "Objective" or name == "Cutscene")
                    if not shouldKeep and not child:IsA("Terrain") and not (child:IsA("BasePart") and child.Size.Magnitude > 100) then
                        pcall(function() child.Parent = hiddenFolder end)
                    end
                end
                local objective = unclimbable:FindFirstChild("Objective")
                if objective then
                    local guard = objective:FindFirstChild("Guard")
                    if guard then
                        local collider = guard:FindFirstChild("Collider")
                        if collider and collider:IsA("BasePart") then
                            collider.CanTouch    = false
                            collider.CanCollide  = false
                            collider.Transparency = 1
                        end
                    end
                end
            end
        else
            for _, item in ipairs(hiddenFolder:GetChildren()) do
                if item.Name == "Climbable" then item.Parent = workspace
                elseif item:IsA("Instance") then
                    item.Parent = workspace:FindFirstChild("Unclimbable") or workspace
                end
            end
        end
    end
})

local delaySeconds = 180
local toggleActive = false

Tabs.Misc:AddToggle("ForceRetryToggle", {
    Title = "Fail Safe",
    Default = false,
    Callback = function(state)
        toggleActive = state
        if state then
            task.delay(delaySeconds, function()
                if toggleActive then
                    pcall(function() retryRemote:InvokeServer("Functions", "Retry", "Add") end)
                end
            end)
        end
    end
})

-- Damage Text
local iface2 = player:WaitForChild("PlayerGui"):WaitForChild("Interface")
local damageConnection

Tabs.Misc:AddToggle("dmg", {
    Title = "Remove Dmg Text",
    Default = false,
    Callback = function(state)
        if state then
            for _, obj in pairs(iface2:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Name == "Number" then obj.Visible = false end
            end
            damageConnection = iface2.DescendantAdded:Connect(function(obj)
                if obj:IsA("TextLabel") and obj.Name == "Number" then obj.Visible = false end
            end)
        else
            if damageConnection then damageConnection:Disconnect() damageConnection = nil end
        end
    end
})

-- Teleport buttons
local lobbyPlaceId    = 14916516914
local mainMenuPlaceId = 13379208636

Tabs.Misc:AddButton({
    Title = "Return to Lobby",
    Callback = function() TeleportService:Teleport(lobbyPlaceId, player) end
})

Tabs.Misc:AddButton({
    Title = "Return to Main Menu",
    Callback = function() TeleportService:Teleport(mainMenuPlaceId, player) end
})

Tabs.Misc:AddButton({
    Title = "Force Retry",
    Callback = function()
        local ok, err = pcall(function()
            retryRemote:InvokeServer("Functions", "Retry", "Add")
        end)
        if not ok then warn(".") end
    end,
})

--//==============================\\--
--||    👑 AUTO MASTERY (Misc)    ||--
--\\==============================//--

local AutoMasteryEnabled = false
local attackDelay        = 0.15
local walkSpeed_AM       = 3.5

local function isTitanForm()
    local char2 = player.Character if not char2 then return false end
    local hasTotal = char2:FindFirstChild("Total") ~= nil
    local hasCopy  = char2:FindFirstChild("Copy")  ~= nil
    local has3     = char2:FindFirstChild("3")     ~= nil
    local hasMain  = char2:FindFirstChild("Main")  ~= nil
    return hasTotal and not (hasCopy or has3 or hasMain)
end

local function pressMouseCenter()
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    local screenSize = workspace.CurrentCamera.ViewportSize
    local x, y = screenSize.X / 2, screenSize.Y / 2
    VIM:SendMouseButtonEvent(x, y, 0, true,  game, 0)
    task.wait(0.03)
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

local function getClosestTitanMastery()
    local char2 = player.Character if not char2 then return nil end
    local hrp2  = char2:FindFirstChild("HumanoidRootPart") if not hrp2 then return nil end
    local closest, shortest = nil, math.huge
    for _, titan in ipairs(workspace.Titans:GetChildren()) do
        local hum  = titan:FindFirstChild("Humanoid")
        local root = titan:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.Health > 0 then
            local dist = (hrp2.Position - root.Position).Magnitude
            if dist < shortest then closest, shortest = root, dist end
        end
    end
    return closest
end

local function walkSafelyToTitan(titan)
    while titan and titan.Parent and isTitanForm() and AutoMasteryEnabled do
        local char2 = player.Character
        local hrp2  = char2 and char2:FindFirstChild("HumanoidRootPart")
        if not hrp2 then break end
        local dir    = titan.CFrame.LookVector.Unit
        local right  = titan.CFrame.RightVector.Unit
        local offset = -dir * 50 + right * 15
        local targetPos = titan.Position + offset
        if (hrp2.Position - targetPos).Magnitude <= 4 then break end
        local step = (targetPos - hrp2.Position).Unit * walkSpeed_AM
        hrp2.CFrame = CFrame.new(hrp2.Position + step, titan.Position)
        RunService.Heartbeat:Wait()
    end
end

task.spawn(function()
    while true do
        if AutoMasteryEnabled and isTitanForm() then
            local titan = getClosestTitanMastery()
            if titan then
                walkSafelyToTitan(titan)
                task.wait(0.08)
                if isTitanForm() then
                    for i = 1, 3 do pressMouseCenter() task.wait(0.1) end
                end
                task.wait(attackDelay)
            else task.wait(0.3) end
        else task.wait(0.5) end
    end
end)

Tabs.Misc:AddToggle("AutoMastery", {
    Title = "Auto Mastery",
    Description = "Auto-attacks titans while in Titan Form for mastery grinding",
    Default = false,
    Callback = function(state) AutoMasteryEnabled = state end
})

--//==============================\\--
--||            👑 ESP            ||--
--\\==============================//--

local ESPEnabled = false
local ESPColor   = Color3.fromRGB(96, 205, 255)
local ESPSize    = Vector3.new(50, 50, 50)

local function createNapeESP(nape)
    if not nape:FindFirstChild("NapeESP") then
        local esp = Instance.new("BoxHandleAdornment")
        esp.Name        = "NapeESP"
        esp.Adornee     = nape
        esp.AlwaysOnTop = true
        esp.ZIndex      = 5
        esp.Size        = ESPSize
        esp.Transparency = 0.5
        esp.Color3      = ESPColor
        esp.Parent      = nape
    end
end

local function applyNapeESP()
    local titansFolder = workspace:FindFirstChild("Titans")
    if not titansFolder then return end
    for _, titan in ipairs(titansFolder:GetChildren()) do
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit  = hitboxes:FindFirstChild("Hit")
            if hit then
                local nape = hit:FindFirstChild("Nape")
                if nape and nape:IsA("BasePart") then createNapeESP(nape) end
            end
        end
    end
end

local function removeAllNapeESP()
    local titansFolder = workspace:FindFirstChild("Titans")
    if not titansFolder then return end
    for _, titan in ipairs(titansFolder:GetChildren()) do
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit = hitboxes:FindFirstChild("Hit")
            if hit then
                local nape = hit:FindFirstChild("Nape")
                if nape and nape:FindFirstChild("NapeESP") then nape.NapeESP:Destroy() end
            end
        end
    end
end

local function updateNapeESPColor()
    local titansFolder = workspace:FindFirstChild("Titans")
    if not titansFolder then return end
    for _, titan in ipairs(titansFolder:GetChildren()) do
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit = hitboxes:FindFirstChild("Hit")
            if hit then
                local nape = hit:FindFirstChild("Nape")
                if nape then
                    local esp = nape:FindFirstChild("NapeESP")
                    if esp then esp.Color3 = ESPColor end
                end
            end
        end
    end
end

local titansFolderEsp = workspace:FindFirstChild("Titans")
if titansFolderEsp then
    titansFolderEsp.ChildAdded:Connect(function(titan)
        if not ESPEnabled then return end
        task.wait(0.5)
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit = hitboxes:FindFirstChild("Hit")
            if hit then
                local nape = hit:FindFirstChild("Nape")
                if nape then createNapeESP(nape) end
            end
        end
    end)
end

Tabs.Esp:AddToggle("NapeESP", {
    Title = "Enable Nape ESP",
    Default = false,
    Callback = function(value)
        ESPEnabled = value
        if value then applyNapeESP() else removeAllNapeESP() end
    end
})

local Colorpicker = Tabs.Esp:AddColorpicker("ESPColorPicker", {
    Title = "ESP Color",
    Default = ESPColor
})

Colorpicker:OnChanged(function(newColor)
    ESPColor = newColor
    updateNapeESPColor()
end)

Colorpicker:SetValueRGB(Color3.fromRGB(96, 205, 255))

--//==============================\\--
--||         SAVE / LOAD          ||--
--\\==============================//--

Window:SelectTab(Tabs.Main)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

Fluent:Notify({
    Title   = "AstaRoth",
    Content = "Loaded successfully! Press Ctrl to toggle UI.",
    Duration = 4,
})
