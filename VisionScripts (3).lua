-- VisionScripts | UI preview
-- Roblox Studio: place this file in a LocalScript under StarterPlayerScripts.
-- This is a UI-only preview. Toggles and buttons do not alter gameplay.
-- Performance: event-driven UI, no RenderStepped loops, no per-frame polling.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("VisionScripts")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "VisionScripts"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 50
gui.Parent = playerGui

-- Palette
local RED = Color3.fromRGB(133, 75, 170)
local RED_DARK = Color3.fromRGB(75, 39, 98)
local BG = Color3.fromRGB(25, 25, 28)
local PANEL = Color3.fromRGB(31, 31, 34)
local INNER = Color3.fromRGB(22, 22, 25)
local WHITE = Color3.fromRGB(239, 237, 240)
local MUTED = Color3.fromRGB(157, 154, 161)
local BORDER = Color3.fromRGB(10, 10, 12)

local function create(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local function corner(object, radius)
    create("UICorner", {CornerRadius = UDim.new(0, radius or 6)}, object)
end

local function stroke(object, color, transparency, thickness)
    create("UIStroke", {
        Color = color or BORDER,
        Transparency = transparency or 0,
        Thickness = thickness or 1
    }, object)
end

local function animate(object, properties, duration)
    local animation = TweenService:Create(
        object,
        TweenInfo.new(duration or 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )
    animation:Play()
    return animation
end

-- The intro is intentionally transparent: only the logo is shown for two seconds.
local intro = create("Frame", {
    Name = "LogoIntro",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 100
}, gui)

local logoShadow = create("TextLabel", {
    Name = "LogoGlow",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(0, 2),
    Size = UDim2.fromOffset(520, 90),
    BackgroundTransparency = 1,
    Text = "✦ Vision Scripts",
    TextColor3 = RED,
    TextTransparency = 0.45,
    Font = Enum.Font.GothamBlack,
    TextSize = 42,
    ZIndex = 100
}, intro)

local logo = create("TextLabel", {
    Name = "Logo",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(520, 90),
    BackgroundTransparency = 1,
    Text = "✦ Vision Scripts",
    TextColor3 = WHITE,
    TextStrokeColor3 = RED_DARK,
    TextStrokeTransparency = 0.25,
    Font = Enum.Font.GothamBlack,
    TextSize = 42,
    TextTransparency = 1,
    ZIndex = 101
}, intro)

-- Main window
local main = create("Frame", {
    Name = "MainWindow",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.52),
    Size = UDim2.fromOffset(900, 750),
    BackgroundColor3 = BG,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Visible = false,
    ClipsDescendants = true
}, gui)
corner(main, 9)
stroke(main, Color3.fromRGB(8, 8, 10), 0.05, 1)

local header = create("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 62),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, main)

local brandIcon = create("Frame", {
    Name = "BrandIcon",
    Position = UDim2.fromOffset(60, 15),
    Size = UDim2.fromOffset(34, 34),
    BackgroundColor3 = Color3.fromRGB(113, 65, 184),
    BorderSizePixel = 0
}, header)
corner(brandIcon, 17)
create("UIStroke", {
    Color = Color3.fromRGB(36, 20, 64),
    Thickness = 1
}, brandIcon)
create("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "◉",
    TextColor3 = Color3.fromRGB(34, 19, 56),
    Font = Enum.Font.GothamBlack,
    TextSize = 27
}, brandIcon)

local brand = create("TextLabel", {
    Position = UDim2.fromOffset(105, 0),
    Size = UDim2.fromOffset(160, 62),
    BackgroundTransparency = 1,
    Text = "Vision Scripts",
    TextColor3 = WHITE,
    Font = Enum.Font.Gotham,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local search = create("TextBox", {
    Position = UDim2.fromOffset(280, 11),
    Size = UDim2.new(1, -340, 0, 40),
    BackgroundColor3 = INNER,
    PlaceholderText = "Search",
    PlaceholderColor3 = MUTED,
    Text = "",
    TextColor3 = WHITE,
    Font = Enum.Font.Code,
    TextSize = 14,
    ClearTextOnFocus = false,
    BorderSizePixel = 0
}, header)
corner(search, 6)
stroke(search, Color3.fromRGB(55, 53, 58), 0.25, 1)

local dragMark = create("TextLabel", {
    Name = "DragMark",
    Position = UDim2.new(1, -48, 0, 7),
    Size = UDim2.fromOffset(40, 48),
    BackgroundTransparency = 1,
    Text = "✥",
    TextColor3 = Color3.fromRGB(22, 22, 25),
    Font = Enum.Font.GothamBold,
    TextSize = 34
}, header)

local sidebar = create("Frame", {
    Position = UDim2.fromOffset(0, 62),
    Size = UDim2.new(0, 275, 1, -88),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, main)

create("UIPadding", {
    PaddingTop = UDim.new(0, 16),
    PaddingLeft = UDim.new(0, 9),
    PaddingRight = UDim.new(0, 9)
}, sidebar)

create("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder
}, sidebar)

local content = create("Frame", {
    Position = UDim2.fromOffset(275, 62),
    Size = UDim2.new(1, -275, 1, -88),
    BackgroundColor3 = BG,
    BorderSizePixel = 0
}, main)

local footer = create("Frame", {
    Name = "Footer",
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.new(0, 0, 1, 0),
    Size = UDim2.new(1, 0, 0, 26),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    ZIndex = 20
}, main)

create("TextLabel", {
    Name = "FooterLabel",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "VisionScripts",
    TextColor3 = MUTED,
    Font = Enum.Font.Code,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 21
}, footer)

local left = create("ScrollingFrame", {
    Name = "LeftColumn",
    Position = UDim2.fromOffset(9, 9),
    Size = UDim2.new(0.5, -14, 1, -18),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = RED,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new()
}, content)

local right = create("ScrollingFrame", {
    Name = "RightColumn",
    Position = UDim2.new(0.5, 5, 0, 9),
    Size = UDim2.new(0.5, -14, 1, -18),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = RED,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new()
}, content)

for _, column in ipairs({left, right}) do
    create("UIListLayout", {
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, column)
end

local activeRows = {}

local function registerRow(row, settingName)
    row.Name = settingName
    row:SetAttribute("SearchName", string.lower(settingName))
    table.insert(activeRows, row)
end

local function makeCard(parent, title, icon)
    local box = create("Frame", {
        Name = title:gsub("%s+", ""),
        Size = UDim2.new(1, -3, 0, 50),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = PANEL,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, parent)
    corner(box, 7)
    stroke(box, BORDER, 0, 1)

    local headerButton = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 41),
        BackgroundColor3 = PANEL,
        BorderSizePixel = 0,
        Text = icon .. "   " .. title,
        TextColor3 = WHITE,
        Font = Enum.Font.Code,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, box)
    create("UIPadding", {PaddingLeft = UDim.new(0, 11)}, headerButton)

    local arrow = create("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -11, 0.5, 0),
        Size = UDim2.fromOffset(20, 25),
        BackgroundTransparency = 1,
        Text = "⌄",
        TextColor3 = WHITE,
        Font = Enum.Font.Gotham,
        TextSize = 22
    }, headerButton)

    local body = create("Frame", {
        Position = UDim2.fromOffset(10, 45),
        Size = UDim2.new(1, -20, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y
    }, box)
    create("UIListLayout", {Padding = UDim.new(0, 2)}, body)
    create("UIPadding", {PaddingBottom = UDim.new(0, 8)}, body)

    headerButton.MouseButton1Click:Connect(function()
        body.Visible = not body.Visible
        arrow.Text = body.Visible and "⌄" or "›"
    end)
    return body
end

local function addToggle(parent, name, default)
    local row = create("Frame", {
        Size = UDim2.new(1, -2, 0, 33),
        BackgroundTransparency = 1
    }, parent)
    registerRow(row, name)

    create("TextLabel", {
        Size = UDim2.new(1, -62, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = WHITE,
        Font = Enum.Font.Code,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    local enabled = default == true
    local button = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -1, 0.5, 0),
        Size = UDim2.fromOffset(43, 23),
        BackgroundColor3 = enabled and RED or INNER,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false
    }, row)
    corner(button, 14)
    stroke(button, Color3.fromRGB(55, 53, 58), 0.45, 1)

    local knob = create("Frame", {
        Position = UDim2.new(0, enabled and 22 or 3, 0.5, -8),
        Size = UDim2.fromOffset(16, 16),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0
    }, button)
    corner(knob, 10)

    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        animate(button, {BackgroundColor3 = enabled and RED or INNER}, 0.13)
        animate(knob, {Position = UDim2.new(0, enabled and 22 or 3, 0.5, -8)}, 0.13)
    end)
end

local function addSlider(parent, name, value, maximum, suffix)
    local row = create("Frame", {
        Size = UDim2.new(1, -2, 0, 51),
        BackgroundTransparency = 1
    }, parent)
    registerRow(row, name)

    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = WHITE,
        Font = Enum.Font.Code,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    local bar = create("Frame", {
        Position = UDim2.fromOffset(0, 24),
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundColor3 = INNER,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, row)
    corner(bar, 3)
    local ratio = math.clamp(value / maximum, 0, 1)
    local barFill = create("Frame", {
        Size = UDim2.new(ratio, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(135, 65, 166),
        BorderSizePixel = 0
    }, bar)
    corner(barFill, 3)

    local valueLabel = create("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = tostring(value) .. "/" .. tostring(maximum) .. (suffix or ""),
        TextColor3 = WHITE,
        Font = Enum.Font.Code,
        TextSize = 13,
        ZIndex = 2
    }, bar)

    local hit = create("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 3,
        AutoButtonColor = false
    }, bar)

    local dragging = false
    local function update(x)
        local width = math.max(bar.AbsoluteSize.X, 1)
        local percent = math.clamp((x - bar.AbsolutePosition.X) / width, 0, 1)
        local newValue = math.floor(percent * maximum * 10 + 0.5) / 10
        barFill.Size = UDim2.fromScale(percent, 1)
        valueLabel.Text = tostring(newValue) .. "/" .. tostring(maximum) .. (suffix or "")
    end

    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input.Position.X)
        end
    end)
    hit.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)
end

local function addSelect(parent, name, options, default)
    local row = create("Frame", {
        Size = UDim2.new(1, -2, 0, 58),
        BackgroundTransparency = 1
    }, parent)
    registerRow(row, name)

    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = WHITE,
        Font = Enum.Font.Code,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    local button = create("TextButton", {
        Position = UDim2.fromOffset(0, 24),
        Size = UDim2.new(1, 0, 0, 31),
        BackgroundColor3 = INNER,
        BorderSizePixel = 0,
        Text = "  " .. default .. "                                      ⌄",
        TextColor3 = WHITE,
        Font = Enum.Font.Code,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)
    corner(button, 4)
    stroke(button, BORDER, 0, 1)

    local index = table.find(options, default) or 1
    button.MouseButton1Click:Connect(function()
        index = index % #options + 1
        button.Text = "  " .. options[index] .. "                                      ⌄"
    end)
end

local function addKey(parent, name, default)
    local row = create("Frame", {
        Size = UDim2.new(1, -2, 0, 35),
        BackgroundTransparency = 1
    }, parent)
    registerRow(row, name)

    create("TextLabel", {
        Size = UDim2.new(1, -54, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = WHITE,
        Font = Enum.Font.Code,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    local button = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(43, 29),
        BackgroundColor3 = INNER,
        BorderSizePixel = 0,
        Text = default,
        TextColor3 = WHITE,
        Font = Enum.Font.Code,
        TextSize = 13
    }, row)
    corner(button, 4)

    local waiting = false
    button.MouseButton1Click:Connect(function()
        waiting = true
        button.Text = "..."
    end)
    UserInputService.InputBegan:Connect(function(input, processed)
        if waiting and not processed and input.UserInputType == Enum.UserInputType.Keyboard then
            button.Text = input.KeyCode.Name
            waiting = false
        end
    end)
end

local function addButton(parent, name)
    local row = create("Frame", {
        Size = UDim2.new(1, -2, 0, 36),
        BackgroundTransparency = 1
    }, parent)
    registerRow(row, name)
    local button = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 31),
        BackgroundColor3 = INNER,
        BorderSizePixel = 0,
        Text = name,
        TextColor3 = MUTED,
        Font = Enum.Font.Code,
        TextSize = 14
    }, row)
    corner(button, 4)
    stroke(button, BORDER, 0, 1)
    button.MouseButton1Click:Connect(function()
        animate(button, {BackgroundColor3 = RED_DARK}, 0.1)
        task.delay(0.12, function()
            if button.Parent then animate(button, {BackgroundColor3 = INNER}, 0.18) end
        end)
    end)
end

local function addDescription(parent, text)
    local label = create("TextLabel", {
        Size = UDim2.new(1, -2, 0, 42),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = WHITE,
        Font = Enum.Font.Code,
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    }, parent)
    return label
end

local function clearColumns()
    for _, child in ipairs(left:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for _, child in ipairs(right:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    table.clear(activeRows)
end

local function buildOffense()
    local shooting = makeCard(left, "Shooting", "◎")
    addToggle(shooting, "Auto Time", true)
    addToggle(shooting, "Shot Glide", true)
    addSlider(shooting, "Shot Glide Multiplier", 1.2, 10)
    addToggle(shooting, "Layup Glide", false)
    addSlider(shooting, "Layup Glide Multiplier", 5, 10)
    addToggle(shooting, "Anti Contest", false)
    addSlider(shooting, "Anti Contest Height", 11, 20)
    addToggle(shooting, "Invisible Anti Contest", false)
    addSlider(shooting, "Invisible Anti Contest Distance", 1, 10)
    addToggle(shooting, "Auto Shoot", false)
    addSlider(shooting, "Auto Shoot Range", 40, 40)
    addToggle(shooting, "Show Range", false)
    addToggle(shooting, "Auto Self Lob", false)

    local physics = makeCard(left, "Physics", "ϟ")
    addToggle(physics, "Speed", false)
    addSlider(physics, "Speed Multiplier", 1, 10)
    addToggle(physics, "Jump", false)

    local dribbling = makeCard(right, "Dribbling", "✣")
    addToggle(dribbling, "No Dribble Delay", false)
    addToggle(dribbling, "Dribble Glide", true)
    addSlider(dribbling, "Dribble Glide Multiplier", 0.2, 10)
    addToggle(dribbling, "Anti Steal", false)
    addSlider(dribbling, "Anti Steal Distance", 5, 10)
    addSelect(dribbling, "Macro 1 - Select Moves", {"---", "Behind The Back", "Crossover", "Spin Move", "Stepback"}, "---")
    addKey(dribbling, "Macro 1 Keybind", "Q")
    addSelect(dribbling, "Macro 1 Controller Button", {"None", "LB", "RB", "X", "Y"}, "None")
    addSelect(dribbling, "Macro 2 - Select Moves", {"Behind The Back", "Crossover", "Spin Move", "Stepback"}, "Behind The Back")
    addKey(dribbling, "Macro 2 Keybind", "T")
    addSelect(dribbling, "Macro 2 Controller Button", {"LB", "RB", "X", "Y", "None"}, "LB")
end

local function buildDefense()
    local guarding = makeCard(left, "+Guarding", "⬡")
    addToggle(guarding, "Auto Guard", false)
    addSelect(guarding, "Auto Guard Type", {"Blatant", "Legit", "Manual"}, "Blatant")
    addSlider(guarding, "Auto Guard Range", 8, 10)
    addToggle(guarding, "Contest Extender", false)
    addSlider(guarding, "Contest Extender Range", 5, 10)
    addToggle(guarding, "Auto Contest", true)
    addSlider(guarding, "Auto Contest Range", 8, 10)

    local blocking = makeCard(left, "Blocking", "⊘")
    addToggle(blocking, "Auto Block", false)
    addSlider(blocking, "Auto Block Range", 7, 10)
    addSlider(blocking, "Auto Block Delay", 0, 0.5)
    addToggle(blocking, "Block Extender", false)
    addSlider(blocking, "Block Extender Range", 5, 10)

    local stealing = makeCard(right, "Stealing", "♧")
    addToggle(stealing, "Auto Steal", false)
    addSlider(stealing, "Auto Steal Range", 4, 10)
    addToggle(stealing, "Steal Extender", false)
    addSlider(stealing, "Steal Extender Range", 5, 10)

    local ball = makeCard(right, "Ball", "◯")
    addToggle(ball, "Auto Rebound", false)
    addSlider(ball, "Auto Rebound Range", 8, 15)
    addToggle(ball, "Rebound Extender", false)
    addSlider(ball, "Rebound Extender Range", 5, 10)
    addToggle(ball, "Catch Extender", false)
    addSlider(ball, "Catch Extender Range", 5, 10)
    addToggle(ball, "Ball Mag", false)
    addSlider(ball, "Ball Mag Range", 50, 100)
end

local function buildAnti()
    local anti = makeCard(left, "Anti Features", "◈")
    local settings = {
        {"Anti Blow By", true}, {"Anti Bump", true},
        {"Anti Reach Slowdown", true}, {"Anti Block Freeze", true},
        {"Anti Pickup Freeze", false}, {"Anti Pass Freeze", false},
        {"Anti Catch Freeze", false}, {"Anti Collision", false},
        {"Anti Screen", true}, {"Anti Box Out Push", true},
        {"Anti Guard Slowdown", true}, {"Anti Post Slowdown", false},
        {"Anti Out Of Bounds", false}
    }
    for _, setting in ipairs(settings) do
        addToggle(anti, setting[1], setting[2])
    end
end

local function buildMisc()
    local misc = makeCard(left, "Miscellaneous", "☷")
    addButton(misc, "Name Spoofer")
    addToggle(misc, "Show Contest", true)
    addToggle(misc, "Spinbot", false)
    addKey(misc, "Spinbot Keybind", "N")
    addSlider(misc, "Spinbot Speed", 10, 30)

    local farm = makeCard(left, "Farm", "▣")
    addToggle(farm, "Auto Requeue", false)
    addDescription(farm, "Joins the Rec queue from anywhere, readies you up and leaves the court when a game ends.")
    addToggle(farm, "Auto Play", false)
    addDescription(farm, "Plays your Rec games for you, on any device.")

    local changers = makeCard(left, "Changers", "♙")
    addToggle(changers, "OVR Changer", false)
    addSlider(changers, "OVR Value", 99, 99)
    addToggle(changers, "Record Changer", false)
    addSlider(changers, "Record (Wins-Losses)", 0, 100)

    buildAnti()

    local cosmetics = makeCard(right, "Cosmetics", "♧")
    addToggle(cosmetics, "Unlock All", true)

    local teleports = makeCard(right, "Teleports", "⌖")
    for _, place in ipairs({
        "Main Menu", "Plaza", "Plaza - Rec", "Plaza - Blacktop",
        "Plaza - League", "Park", "Public Gym", "Private Gym", "Blacktop"
    }) do
        addButton(teleports, place)
    end
end

local function buildSettings()
    local ui = makeCard(left, "UI Settings", "⚙")
    addToggle(ui, "Animations", true)
    addToggle(ui, "Sound Effects", false)
    addToggle(ui, "Compact Mode", false)
    addToggle(ui, "Remember Position", true)
    local info = makeCard(right, "About", "✦")
    addDescription(info, "VisionScripts UI preview. Controls are visual placeholders and are not connected to game actions.")
end

local categories = {
    {"Offense Features", "ϟ"},
    {"Defense Features", "⬡"},
    {"Miscellaneous", "☷"},
    {"UI Settings", "⚙"}
}

local currentCategory = "Offense Features"

local function applySearch()
    local query = string.lower(search.Text)
    for _, row in ipairs(activeRows) do
        local name = row:GetAttribute("SearchName") or ""
        row.Visible = query == "" or string.find(name, query, 1, true) ~= nil
    end
end

local function selectCategory(category)
    currentCategory = category
    for _, button in ipairs(sidebar:GetChildren()) do
        if button:IsA("TextButton") then
            local selected = button.Name == category
            button.BackgroundColor3 = selected and RED_DARK or PANEL
            button.TextColor3 = selected and WHITE or MUTED
        end
    end

    clearColumns()
    if category == "Offense Features" then
        buildOffense()
    elseif category == "Defense Features" then
        buildDefense()
    elseif category == "Miscellaneous" then
        buildMisc()
    elseif category == "UI Settings" then
        buildSettings()
    end
    applySearch()
end

for index, item in ipairs(categories) do
    local category, icon = item[1], item[2]
    local button = create("TextButton", {
        Name = category,
        LayoutOrder = index,
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = PANEL,
        BorderSizePixel = 0,
        Text = icon .. "   " .. category,
        TextColor3 = MUTED,
        Font = Enum.Font.Code,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, sidebar)
    corner(button, 6)
    button.MouseButton1Click:Connect(function()
        search.Text = ""
        selectCategory(category)
    end)
end

search:GetPropertyChangedSignal("Text"):Connect(applySearch)

-- Dragging is input-driven; no frame polling.
local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- The reference design uses a drag mark rather than minimize/close buttons.

-- Build content before the splash finishes so the UI is ready immediately.
selectCategory("Offense Features")

task.spawn(function()
    -- Smooth logo fade-in, brief hold, then smooth fade-out.
    logo.TextTransparency = 1
    logoShadow.TextTransparency = 1
    animate(logo, {TextTransparency = 0}, 0.65)
    animate(logoShadow, {TextTransparency = 0.58}, 0.65)

    task.wait(2)

    animate(logo, {TextTransparency = 1}, 0.55)
    animate(logoShadow, {TextTransparency = 1}, 0.55)
    task.wait(0.6)

    intro:Destroy()

    -- Fade the full window in while it gently expands to its final size.
    main.Visible = true
    main.Size = UDim2.fromOffset(880, 735)
    main.BackgroundTransparency = 1

    -- Start child UI elements transparent so the entire interface appears together.
    for _, descendant in ipairs(main:GetDescendants()) do
        if descendant:IsA("GuiObject") then
            if descendant.BackgroundTransparency < 1 then
                descendant:SetAttribute("VisionFadeBackground", descendant.BackgroundTransparency)
                descendant.BackgroundTransparency = 1
            end
            if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                descendant:SetAttribute("VisionFadeText", descendant.TextTransparency)
                descendant.TextTransparency = 1
            end
            if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                descendant:SetAttribute("VisionFadeImage", descendant.ImageTransparency)
                descendant.ImageTransparency = 1
            end
        end
    end

    local windowTween = TweenService:Create(
        main,
        TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {
            Size = UDim2.fromOffset(900, 750),
            BackgroundTransparency = 0
        }
    )
    windowTween:Play()

    for _, descendant in ipairs(main:GetDescendants()) do
        if descendant:IsA("GuiObject") then
            local bg = descendant:GetAttribute("VisionFadeBackground")
            if bg ~= nil then
                TweenService:Create(
                    descendant,
                    TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                    {BackgroundTransparency = bg}
                ):Play()
                descendant:SetAttribute("VisionFadeBackground", nil)
            end

            local text = descendant:GetAttribute("VisionFadeText")
            if text ~= nil then
                TweenService:Create(
                    descendant,
                    TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                    {TextTransparency = text}
                ):Play()
                descendant:SetAttribute("VisionFadeText", nil)
            end

            local image = descendant:GetAttribute("VisionFadeImage")
            if image ~= nil then
                TweenService:Create(
                    descendant,
                    TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                    {ImageTransparency = image}
                ):Play()
                descendant:SetAttribute("VisionFadeImage", nil)
            end
        end
    end
end)

print("[VisionScripts] UI ready.")
