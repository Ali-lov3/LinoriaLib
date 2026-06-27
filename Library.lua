local Law = {}
Law.__index = Law

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Icons = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Orvez83/IconFinder/refs/heads/main/Icons/Lucide-Icons.lua"
))()

local C = {
    BG      = Color3.fromRGB(14, 14, 18),
    SIDEBAR = Color3.fromRGB(10, 10, 14),
    PANEL   = Color3.fromRGB(18, 18, 24),
    SECTION = Color3.fromRGB(22, 22, 30),
    ELEMENT = Color3.fromRGB(30, 30, 42),
    ACCENT  = Color3.fromRGB(215, 50, 50),
    ACCENT2 = Color3.fromRGB(170, 35, 35),
    BORDER  = Color3.fromRGB(35, 35, 50),
    TXT     = Color3.fromRGB(230, 230, 240),
    TXT2    = Color3.fromRGB(130, 130, 150),
    WHITE   = Color3.fromRGB(255, 255, 255),
}

local TF = TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function New(class, props)
    local o = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then o[k] = v end
    end
    if props.Parent then o.Parent = props.Parent end
    return o
end

local function Rnd(p, r)  New("UICorner", { CornerRadius = UDim.new(0, r or 6), Parent = p }) end
local function Brdr(p, c) New("UIStroke", { Color = c or C.BORDER, Thickness = 1, Parent = p }) end
local function Tw(o, t)   TweenService:Create(o, TF, t):Play() end

local function Icon(parent, name, size, color)
    local asset = Icons[name]
    if asset then
        return New("ImageLabel", {
            Size = UDim2.new(0, size or 18, 0, size or 18),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
            Image = asset,
            ImageColor3 = color or C.TXT2,
            Parent = parent
        })
    else
        return New("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = color or C.TXT2,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            Parent = parent
        })
    end
end

local function RadioCircle(parent, active)
    local outer = New("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = parent
    })
    local ring = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = outer
    })
    Rnd(ring, 6)
    New("UIStroke", {
        Color = active and C.ACCENT or C.TXT2,
        Thickness = 1.5,
        Parent = ring
    })
    local dot = New("Frame", {
        Size = UDim2.new(0, 6, 0, 6),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = C.ACCENT,
        BorderSizePixel = 0,
        Visible = active,
        Parent = ring
    })
    Rnd(dot, 3)
    return { Outer = outer, Ring = ring, Dot = dot, Stroke = ring:FindFirstChildWhichIsA("UIStroke") }
end

function Law:CreateWindow(cfg)
    cfg = cfg or {}
    local title     = cfg.Title      or "Law.cc"
    local subtitle  = cfg.Subtitle   or ""
    local logo      = cfg.Logo       or string.sub(title, 1, 2):upper()
    local logoIcon  = cfg.LogoIcon
    local typewrite = cfg.TypeWriter  or false
    local wSize     = cfg.Size       or UDim2.new(0, 640, 0, 450)

    local gui = New("ScreenGui", {
        Name = "LawCC", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Parent = game:GetService("CoreGui")
    })

    local openBtn = New("TextButton", {
        Size = UDim2.new(0, 44, 0, 44),
        Position = UDim2.new(0, 14, 0.5, -22),
        BackgroundColor3 = C.ACCENT, BorderSizePixel = 0,
        Text = "", ZIndex = 20, Visible = false, Parent = gui
    })
    Rnd(openBtn, 8)
    if logoIcon and Icons[logoIcon] then
        New("ImageLabel", {
            Size = UDim2.new(0, 22, 0, 22),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
            Image = Icons[logoIcon],
            ImageColor3 = C.WHITE,
            ZIndex = 21, Parent = openBtn
        })
    else
        New("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Text = logo, TextColor3 = C.WHITE, TextSize = 13,
            Font = Enum.Font.GothamBold, ZIndex = 21, Parent = openBtn
        })
    end

    local root = New("Frame", {
        Name = "Root", Size = wSize,
        Position = UDim2.new(0.5, -wSize.X.Offset/2, 0.5, -wSize.Y.Offset/2),
        BackgroundColor3 = C.BG, BorderSizePixel = 0,
        ClipsDescendants = true, Parent = gui
    })
    Rnd(root, 10)
    Brdr(root)

    local drag, dragS, posS
    root.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; dragS = i.Position; posS = root.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragS
            root.Position = UDim2.new(posS.X.Scale, posS.X.Offset + d.X, posS.Y.Scale, posS.Y.Offset + d.Y)
        end
    end)

    local sidebar = New("Frame", {
        Name = "Sidebar", Size = UDim2.new(0, 52, 1, 0),
        BackgroundColor3 = C.SIDEBAR, BorderSizePixel = 0, Parent = root
    })
    New("Frame", {
        Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = C.BORDER, BorderSizePixel = 0, Parent = sidebar
    })

    local logoBox = New("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = C.ACCENT, BorderSizePixel = 0, Parent = sidebar
    })
    if logoIcon and Icons[logoIcon] then
        New("ImageLabel", {
            Size = UDim2.new(0, 24, 0, 24),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
            Image = Icons[logoIcon],
            ImageColor3 = C.WHITE,
            Parent = logoBox
        })
    else
        New("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Text = logo, TextColor3 = C.WHITE, TextSize = 15,
            Font = Enum.Font.GothamBold, Parent = logoBox
        })
    end

    local navList = New("Frame", {
        Size = UDim2.new(1, 0, 1, -52), Position = UDim2.new(0, 0, 0, 52),
        BackgroundTransparency = 1, Parent = sidebar
    })
    New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = navList })
    New("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), Parent = navList })

    local content = New("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -52, 1, 0), Position = UDim2.new(0, 52, 0, 0),
        BackgroundColor3 = C.PANEL, BorderSizePixel = 0, Parent = root
    })

    local topBar = New("Frame", {
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundColor3 = C.SIDEBAR, BorderSizePixel = 0, Parent = content
    })
    New("Frame", {
        Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = C.BORDER, BorderSizePixel = 0, Parent = topBar
    })

    local titleLbl = New("TextLabel", {
        Size = UDim2.new(1, -56, 0, 20), Position = UDim2.new(0, 14, 0, 8),
        BackgroundTransparency = 1, Text = title,
        TextColor3 = C.TXT, TextSize = 15, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = topBar
    })
    local subLbl = New("TextLabel", {
        Size = UDim2.new(1, -56, 0, 14), Position = UDim2.new(0, 14, 0, 30),
        BackgroundTransparency = 1, Text = subtitle,
        TextColor3 = C.TXT2, TextSize = 10, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = topBar
    })

    local xBtn = New("TextButton", {
        Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -34, 0, 15),
        BackgroundColor3 = C.ELEMENT, BorderSizePixel = 0,
        Text = "", Parent = topBar
    })
    Rnd(xBtn, 5)
    Icon(xBtn, "x", 14, C.TXT2)
    xBtn.MouseButton1Click:Connect(function() root.Visible = false; openBtn.Visible = true end)
    openBtn.MouseButton1Click:Connect(function() root.Visible = true; openBtn.Visible = false end)

    local tabRow = New("Frame", {
        Size = UDim2.new(1, 0, 0, 38), Position = UDim2.new(0, 0, 0, 54),
        BackgroundColor3 = C.SIDEBAR, BorderSizePixel = 0, Parent = content
    })
    New("Frame", {
        Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = C.BORDER, BorderSizePixel = 0, Parent = tabRow
    })

    local tabHolder = New("Frame", {
        Size = UDim2.new(1, 0, 1, -92), Position = UDim2.new(0, 0, 0, 92),
        BackgroundTransparency = 1, ClipsDescendants = true, Parent = content
    })

    if typewrite then
        task.spawn(function()
            while task.wait() do
                for i = 1, #title do titleLbl.Text = string.sub(title, 1, i); task.wait(0.07) end
                task.wait(2)
                for i = #title, 0, -1 do titleLbl.Text = string.sub(title, 1, i); task.wait(0.05) end
                task.wait(0.4)
            end
        end)
    end

    local win = {
        Gui = gui, Root = root,
        NavList = navList, TabRow = tabRow, TabHolder = tabHolder,
        TitleLbl = titleLbl, SubLbl = subLbl,
        Pages = {}
    }

    function win:CreatePage(pc)
        pc = pc or {}
        local pName = pc.Name     or "Page"
        local pSub  = pc.Subtitle or ""
        local pIcon = pc.Icon

        local navBtn = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 44),
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Text = "", Parent = navList
        })
        local navImg = Icon(navBtn, pIcon or "square", 20, C.TXT2)

        local indicator = New("Frame", {
            Size = UDim2.new(0, 3, 0, 22), Position = UDim2.new(0, 0, 0.5, -11),
            BackgroundColor3 = C.ACCENT, BorderSizePixel = 0, Visible = false, Parent = navBtn
        })
        Rnd(indicator, 2)

        local pageFrame = New("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1, Visible = false, Parent = tabHolder
        })

        local innerTabScroll = New("ScrollingFrame", {
            Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.X,
            Visible = false, Parent = tabRow
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6),
            Parent = innerTabScroll
        })

        local page = {
            NavBtn = navBtn, NavImg = navImg, Indicator = indicator,
            Frame = pageFrame, TabScrollFrame = innerTabScroll,
            Name = pName, Subtitle = pSub, Tabs = {}
        }

        function page:CreateTab(tc)
            tc = tc or {}
            local tName = tc.Name or "Tab"
            local tIcon = tc.Icon

            local tBtn = New("TextButton", {
                Size = UDim2.new(0, 0, 0, 26), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Text = "", Parent = innerTabScroll
            })

            local tBtnInner = New("Frame", {
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1, Parent = tBtn
            })
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6),
                Parent = tBtnInner
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 10),
                Parent = tBtn
            })

            local radioHolder = New("Frame", {
                Size = UDim2.new(0, 12, 0, 12),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Parent = tBtnInner
            })
            local radioData = RadioCircle(radioHolder, false)

            local tImgHolder
            if tIcon and Icons[tIcon] then
                tImgHolder = New("Frame", {
                    Size = UDim2.new(0, 14, 0, 14),
                    BackgroundTransparency = 1, Parent = tBtnInner
                })
                New("ImageLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Image = Icons[tIcon],
                    ImageColor3 = C.TXT2,
                    Parent = tImgHolder
                })
            end

            local tLbl = New("TextLabel", {
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1, Text = tName,
                TextColor3 = C.TXT2, TextSize = 11, Font = Enum.Font.GothamSemibold,
                Parent = tBtnInner
            })

            local tContent = New("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1, BorderSizePixel = 0,
                ScrollBarThickness = 2, ScrollBarImageColor3 = C.ACCENT,
                CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
                Visible = false, Parent = pageFrame
            })
            New("UIPadding", {
                PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
                Parent = tContent
            })

            local cols = New("Frame", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, Parent = tContent
            })

            local leftCol = New("Frame", {
                Size = UDim2.new(0.5, -5, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, Parent = cols
            })
            New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = leftCol })

            local rightCol = New("Frame", {
                Size = UDim2.new(0.5, -5, 0, 0), Position = UDim2.new(0.5, 5, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = cols
            })
            New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = rightCol })

            local tab = { Btn = tBtn, Content = tContent, L = leftCol, R = rightCol, Img = tImgHolder, Lbl = tLbl, Radio = radioData }

            function tab:CreateSection(sc)
                sc = sc or {}
                local sName    = sc.Name or "Section"
                local side     = sc.Side or "Left"
                local col      = (side == "Right") and rightCol or leftCol
                local subTabs  = sc.Tabs

                local box = New("Frame", {
                    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = C.SECTION, BorderSizePixel = 0, Parent = col
                })
                Rnd(box, 6)
                Brdr(box)

                local secHead = New("Frame", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1, Parent = box
                })

                if subTabs and #subTabs > 0 then
                    local headLayout = New("Frame", {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1, Parent = secHead
                    })
                    New("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 0),
                        Parent = headLayout
                    })

                    local subTabBtns = {}
                    local subTabFrames = {}

                    for i, stName in ipairs(subTabs) do
                        local stBtn = New("TextButton", {
                            Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                            BackgroundTransparency = 1, BorderSizePixel = 0,
                            Text = stName,
                            TextColor3 = i == 1 and C.TXT or C.TXT2,
                            TextSize = 12, Font = Enum.Font.GothamSemibold,
                            Parent = headLayout
                        })
                        New("UIPadding", {
                            PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
                            Parent = stBtn
                        })

                        local stUnder = New("Frame", {
                            Size = UDim2.new(1, -24, 0, 2),
                            AnchorPoint = Vector2.new(0.5, 1),
                            Position = UDim2.new(0.5, 0, 1, 0),
                            BackgroundColor3 = C.ACCENT,
                            BorderSizePixel = 0,
                            Visible = i == 1,
                            Parent = stBtn
                        })
                        Rnd(stUnder, 1)

                        local stContent = New("Frame", {
                            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundTransparency = 1,
                            Visible = i == 1,
                            Parent = box
                        })
                        local stItems = New("Frame", {
                            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundTransparency = 1, Parent = stContent
                        })
                        New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = stItems })
                        New("UIPadding", {
                            PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 8),
                            PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
                            Parent = stItems
                        })

                        table.insert(subTabBtns, { Btn = stBtn, Under = stUnder })
                        table.insert(subTabFrames, stContent)

                        stBtn.MouseButton1Click:Connect(function()
                            for j, d in ipairs(subTabBtns) do
                                d.Btn.TextColor3 = C.TXT2
                                d.Under.Visible = false
                                subTabFrames[j].Visible = false
                            end
                            stBtn.TextColor3 = C.TXT
                            stUnder.Visible = true
                            stContent.Visible = true
                        end)
                    end

                    New("Frame", {
                        Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, 31),
                        BackgroundColor3 = C.BORDER, BorderSizePixel = 0, Parent = box
                    })

                    local sec = {}
                    local activeSubTab = 1

                    local function getItems(tabIdx)
                        local stContent = subTabFrames[tabIdx]
                        if stContent then
                            return stContent:FindFirstChild("Frame")
                        end
                        return nil
                    end

                    local function makeSecAPI(itemsFrame)
                        local s = {}

                        local function Row(lbl, rowIcon, hasGear)
                            local r = New("Frame", {
                                Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Parent = itemsFrame
                            })
                            local inner = New("Frame", {
                                Size = UDim2.new(0.6, 0, 1, 0),
                                BackgroundTransparency = 1, Parent = r
                            })
                            New("UIListLayout", {
                                FillDirection = Enum.FillDirection.Horizontal,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5),
                                Parent = inner
                            })
                            if rowIcon and Icons[rowIcon] then
                                New("ImageLabel", {
                                    Size = UDim2.new(0, 13, 0, 13),
                                    BackgroundTransparency = 1,
                                    Image = Icons[rowIcon],
                                    ImageColor3 = C.TXT2,
                                    Parent = inner
                                })
                            end
                            New("TextLabel", {
                                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                                BackgroundTransparency = 1, Text = lbl,
                                TextColor3 = C.TXT2, TextSize = 12, Font = Enum.Font.Gotham,
                                TextXAlignment = Enum.TextXAlignment.Left, Parent = inner
                            })
                            if hasGear then
                                local gearHolder = New("Frame", {
                                    Size = UDim2.new(0, 16, 0, 16),
                                    Position = UDim2.new(0.6, 2, 0.5, -8),
                                    BackgroundTransparency = 1, Parent = r
                                })
                                Icon(gearHolder, "settings", 14, C.TXT2)
                            end
                            return r
                        end

                        function s:AddToggle(tc2)
                            tc2 = tc2 or {}
                            local name     = tc2.Name     or "Toggle"
                            local default  = tc2.Default  or false
                            local gear     = tc2.Gear     or false
                            local icon     = tc2.Icon
                            local callback = tc2.Callback or function() end
                            local state = default
                            local row = Row(name, icon, gear)
                            local track = New("Frame", {
                                Size = UDim2.new(0, 38, 0, 20), Position = UDim2.new(1, -38, 0.5, -10),
                                BackgroundColor3 = state and C.ACCENT or C.ELEMENT, BorderSizePixel = 0, Parent = row
                            })
                            Rnd(track, 10)
                            local knob = New("Frame", {
                                Size = UDim2.new(0, 14, 0, 14),
                                Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                                BackgroundColor3 = C.WHITE, BorderSizePixel = 0, Parent = track
                            })
                            Rnd(knob, 7)
                            local hb = New("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = row })
                            hb.MouseButton1Click:Connect(function()
                                state = not state
                                Tw(track, { BackgroundColor3 = state and C.ACCENT or C.ELEMENT })
                                Tw(knob,  { Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7) })
                                callback(state)
                            end)
                            local el = {}
                            function el:Get() return state end
                            function el:Set(v)
                                state = v
                                Tw(track, { BackgroundColor3 = state and C.ACCENT or C.ELEMENT })
                                Tw(knob,  { Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7) })
                                callback(state)
                            end
                            return el
                        end

                        function s:AddSlider(sc2)
                            sc2 = sc2 or {}
                            local name     = sc2.Name     or "Slider"
                            local min      = sc2.Min      or 0
                            local max      = sc2.Max      or 100
                            local default  = sc2.Default  or min
                            local icon     = sc2.Icon
                            local callback = sc2.Callback or function() end
                            local val = math.clamp(default, min, max)
                            local row = New("Frame", {
                                Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Parent = itemsFrame
                            })
                            local labelHolder = New("Frame", {
                                Size = UDim2.new(0.5, 0, 0, 18), Position = UDim2.new(0, 0, 0, 4),
                                BackgroundTransparency = 1, Parent = row
                            })
                            New("UIListLayout", {
                                FillDirection = Enum.FillDirection.Horizontal,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
                                Parent = labelHolder
                            })
                            if icon and Icons[icon] then
                                New("ImageLabel", {
                                    Size = UDim2.new(0, 13, 0, 13),
                                    BackgroundTransparency = 1,
                                    Image = Icons[icon], ImageColor3 = C.TXT2,
                                    Parent = labelHolder
                                })
                            end
                            New("TextLabel", {
                                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                                BackgroundTransparency = 1, Text = name,
                                TextColor3 = C.TXT2, TextSize = 12, Font = Enum.Font.Gotham,
                                TextXAlignment = Enum.TextXAlignment.Left, Parent = labelHolder
                            })
                            local valLbl = New("TextLabel", {
                                Size = UDim2.new(0, 26, 0, 16), Position = UDim2.new(1, -26, 0, 4),
                                BackgroundTransparency = 1, Text = tostring(val),
                                TextColor3 = C.TXT, TextSize = 12, Font = Enum.Font.GothamBold,
                                TextXAlignment = Enum.TextXAlignment.Right, Parent = row
                            })
                            local bar = New("Frame", {
                                Size = UDim2.new(0.46, -30, 0, 3), Position = UDim2.new(0.5, 0, 0, 16),
                                BackgroundColor3 = C.ELEMENT, BorderSizePixel = 0, Parent = row
                            })
                            Rnd(bar, 2)
                            local fill = New("Frame", {
                                Size = UDim2.new((val-min)/(max-min), 0, 1, 0),
                                BackgroundColor3 = C.ACCENT, BorderSizePixel = 0, Parent = bar
                            })
                            Rnd(fill, 2)
                            local dot = New("Frame", {
                                Size = UDim2.new(0, 11, 0, 11),
                                Position = UDim2.new((val-min)/(max-min), -5, 0.5, -5),
                                BackgroundColor3 = C.WHITE, BorderSizePixel = 0, Parent = bar
                            })
                            Rnd(dot, 6)
                            local sliding = false
                            local function upd(x)
                                local frac = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                                val = math.floor(min + frac * (max - min) + 0.5)
                                local f2 = (val-min)/(max-min)
                                fill.Size = UDim2.new(f2, 0, 1, 0)
                                dot.Position = UDim2.new(f2, -5, 0.5, -5)
                                valLbl.Text = tostring(val)
                                callback(val)
                            end
                            local hb = New("TextButton", {
                                Size = UDim2.new(1, 0, 1, 12), Position = UDim2.new(0, 0, 0, -6),
                                BackgroundTransparency = 1, Text = "", Parent = bar
                            })
                            hb.MouseButton1Down:Connect(function(x) sliding = true; upd(x) end)
                            UserInputService.InputChanged:Connect(function(i)
                                if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then upd(i.Position.X) end
                            end)
                            UserInputService.InputEnded:Connect(function(i)
                                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = false end
                            end)
                            local el = {}
                            function el:Get() return val end
                            function el:Set(v)
                                val = math.clamp(v, min, max)
                                local f = (val-min)/(max-min)
                                fill.Size = UDim2.new(f, 0, 1, 0)
                                dot.Position = UDim2.new(f, -5, 0.5, -5)
                                valLbl.Text = tostring(val)
                                callback(val)
                            end
                            return el
                        end

                        function s:AddDropdown(dc)
                            dc = dc or {}
                            local name     = dc.Name     or "Dropdown"
                            local opts     = dc.Options  or {}
                            local default  = dc.Default  or (opts[1] or "")
                            local icon     = dc.Icon
                            local callback = dc.Callback or function() end
                            local sel = default
                            local isOpen = false
                            local wrap = New("Frame", {
                                Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1,
                                ClipsDescendants = false, Parent = itemsFrame
                            })
                            local labelHolder = New("Frame", {
                                Size = UDim2.new(0.4, 0, 0, 18), Position = UDim2.new(0, 0, 0, 7),
                                BackgroundTransparency = 1, Parent = wrap
                            })
                            New("UIListLayout", {
                                FillDirection = Enum.FillDirection.Horizontal,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
                                Parent = labelHolder
                            })
                            if icon and Icons[icon] then
                                New("ImageLabel", {
                                    Size = UDim2.new(0, 13, 0, 13),
                                    BackgroundTransparency = 1,
                                    Image = Icons[icon], ImageColor3 = C.TXT2,
                                    Parent = labelHolder
                                })
                            end
                            New("TextLabel", {
                                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                                BackgroundTransparency = 1, Text = name,
                                TextColor3 = C.TXT2, TextSize = 12, Font = Enum.Font.Gotham,
                                TextXAlignment = Enum.TextXAlignment.Left, Parent = labelHolder
                            })
                            local dropBtn = New("TextButton", {
                                Size = UDim2.new(0.57, 0, 0, 22), Position = UDim2.new(0.41, 0, 0, 5),
                                BackgroundColor3 = C.ELEMENT, BorderSizePixel = 0, Text = "", Parent = wrap
                            })
                            Rnd(dropBtn, 4)
                            Brdr(dropBtn)
                            local selLbl = New("TextLabel", {
                                Size = UDim2.new(1, -22, 1, 0), Position = UDim2.new(0, 7, 0, 0),
                                BackgroundTransparency = 1, Text = sel, TextColor3 = C.TXT,
                                TextSize = 11, Font = Enum.Font.Gotham,
                                TextXAlignment = Enum.TextXAlignment.Left, Parent = dropBtn
                            })
                            local arrowHolder = New("Frame", {
                                Size = UDim2.new(0, 14, 0, 14),
                                Position = UDim2.new(1, -18, 0.5, -7),
                                BackgroundTransparency = 1, Parent = dropBtn
                            })
                            local arrowImg = Icon(arrowHolder, "chevron-down", 13, C.TXT2)
                            local listFrame = New("Frame", {
                                Size = UDim2.new(1, 0, 0, #opts * 24),
                                Position = UDim2.new(0, 0, 1, 2),
                                BackgroundColor3 = C.ELEMENT, BorderSizePixel = 0,
                                ClipsDescendants = true, ZIndex = 20,
                                Visible = false, Parent = dropBtn
                            })
                            Rnd(listFrame, 4)
                            Brdr(listFrame)
                            New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = listFrame })
                            for _, opt in ipairs(opts) do
                                local ob = New("TextButton", {
                                    Size = UDim2.new(1, 0, 0, 24),
                                    BackgroundTransparency = 1, BorderSizePixel = 0,
                                    Text = opt, TextColor3 = C.TXT2, TextSize = 11, Font = Enum.Font.Gotham,
                                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 20, Parent = listFrame
                                })
                                New("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = ob })
                                ob.MouseEnter:Connect(function() ob.TextColor3 = C.TXT end)
                                ob.MouseLeave:Connect(function() ob.TextColor3 = C.TXT2 end)
                                ob.MouseButton1Click:Connect(function()
                                    sel = opt; selLbl.Text = opt
                                    isOpen = false; listFrame.Visible = false
                                    if arrowImg and arrowImg:IsA("ImageLabel") then
                                        Tw(arrowHolder, { Rotation = 0 })
                                    end
                                    callback(sel)
                                end)
                            end
                            dropBtn.MouseButton1Click:Connect(function()
                                isOpen = not isOpen
                                listFrame.Visible = isOpen
                                if arrowImg and arrowImg:IsA("ImageLabel") then
                                    Tw(arrowHolder, { Rotation = isOpen and 180 or 0 })
                                end
                            end)
                            local el = {}
                            function el:Get() return sel end
                            function el:Set(v) sel = v; selLbl.Text = v; callback(v) end
                            return el
                        end

                        function s:AddLabel(lc)
                            lc = type(lc) == "string" and { Text = lc } or (lc or {})
                            local row = New("Frame", {
                                Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = itemsFrame
                            })
                            New("UIListLayout", {
                                FillDirection = Enum.FillDirection.Horizontal,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5),
                                Parent = row
                            })
                            if lc.Icon and Icons[lc.Icon] then
                                New("ImageLabel", {
                                    Size = UDim2.new(0, 12, 0, 12),
                                    BackgroundTransparency = 1,
                                    Image = Icons[lc.Icon], ImageColor3 = lc.Color or C.TXT2,
                                    Parent = row
                                })
                            end
                            New("TextLabel", {
                                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                                BackgroundTransparency = 1, Text = lc.Text or "",
                                TextColor3 = lc.Color or C.TXT2, TextSize = 11, Font = Enum.Font.Gotham,
                                TextXAlignment = Enum.TextXAlignment.Left, Parent = row
                            })
                        end

                        function s:AddButton(bc)
                            bc = bc or {}
                            local name     = bc.Name     or "Button"
                            local icon     = bc.Icon
                            local callback = bc.Callback or function() end
                            local btn = New("TextButton", {
                                Size = UDim2.new(1, 0, 0, 28),
                                BackgroundColor3 = C.ACCENT, BorderSizePixel = 0,
                                Text = "", Parent = itemsFrame
                            })
                            Rnd(btn, 5)
                            local btnInner = New("Frame", {
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundTransparency = 1, Parent = btn
                            })
                            New("UIListLayout", {
                                FillDirection = Enum.FillDirection.Horizontal,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6),
                                Parent = btnInner
                            })
                            if icon and Icons[icon] then
                                New("ImageLabel", {
                                    Size = UDim2.new(0, 13, 0, 13),
                                    BackgroundTransparency = 1,
                                    Image = Icons[icon], ImageColor3 = C.WHITE,
                                    Parent = btnInner
                                })
                            end
                            New("TextLabel", {
                                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                                BackgroundTransparency = 1, Text = name,
                                TextColor3 = C.WHITE, TextSize = 12, Font = Enum.Font.GothamSemibold,
                                Parent = btnInner
                            })
                            btn.MouseEnter:Connect(function() Tw(btn, { BackgroundColor3 = Color3.fromRGB(235, 65, 65) }) end)
                            btn.MouseLeave:Connect(function() Tw(btn, { BackgroundColor3 = C.ACCENT }) end)
                            btn.MouseButton1Down:Connect(function() Tw(btn, { BackgroundColor3 = C.ACCENT2 }) end)
                            btn.MouseButton1Up:Connect(function() Tw(btn, { BackgroundColor3 = C.ACCENT }) end)
                            btn.MouseButton1Click:Connect(callback)
                        end

                        return s
                    end

                    for i = 1, #subTabs do
                        local stContent = subTabFrames[i]
                        local stItemsFrame = stContent:FindFirstChild("Frame")
                        sec[subTabs[i]] = makeSecAPI(stItemsFrame)
                    end

                    return sec

                else
                    New("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6),
                        Parent = secHead
                    })
                    New("UIPadding", { PaddingLeft = UDim.new(0, 10), Parent = secHead })

                    if sc.Icon and Icons[sc.Icon] then
                        New("ImageLabel", {
                            Size = UDim2.new(0, 13, 0, 13),
                            BackgroundTransparency = 1,
                            Image = Icons[sc.Icon],
                            ImageColor3 = C.ACCENT,
                            Parent = secHead
                        })
                    end

                    New("TextLabel", {
                        Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1, Text = sName,
                        TextColor3 = C.TXT, TextSize = 12, Font = Enum.Font.GothamBold,
                        TextXAlignment = Enum.TextXAlignment.Left, Parent = secHead
                    })

                    New("Frame", {
                        Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, 31),
                        BackgroundColor3 = C.BORDER, BorderSizePixel = 0, Parent = box
                    })

                    local items = New("Frame", {
                        Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 32),
                        AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = box
                    })
                    New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = items })
                    New("UIPadding", {
                        PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 8),
                        PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
                        Parent = items
                    })

                    local sec = { Items = items }

                    local function Row(lbl, rowIcon, hasGear)
                        local r = New("Frame", {
                            Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Parent = items
                        })
                        local inner = New("Frame", {
                            Size = UDim2.new(0.6, 0, 1, 0),
                            BackgroundTransparency = 1, Parent = r
                        })
                        New("UIListLayout", {
                            FillDirection = Enum.FillDirection.Horizontal,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5),
                            Parent = inner
                        })
                        if rowIcon and Icons[rowIcon] then
                            New("ImageLabel", {
                                Size = UDim2.new(0, 13, 0, 13),
                                BackgroundTransparency = 1,
                                Image = Icons[rowIcon],
                                ImageColor3 = C.TXT2,
                                Parent = inner
                            })
                        end
                        New("TextLabel", {
                            Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                            BackgroundTransparency = 1, Text = lbl,
                            TextColor3 = C.TXT2, TextSize = 12, Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left, Parent = inner
                        })
                        if hasGear then
                            local gearHolder = New("Frame", {
                                Size = UDim2.new(0, 16, 0, 16),
                                Position = UDim2.new(0.6, 2, 0.5, -8),
                                BackgroundTransparency = 1, Parent = r
                            })
                            Icon(gearHolder, "settings", 14, C.TXT2)
                        end
                        return r
                    end

                    function sec:AddToggle(tc2)
                        tc2 = tc2 or {}
                        local name     = tc2.Name     or "Toggle"
                        local default  = tc2.Default  or false
                        local gear     = tc2.Gear     or false
                        local icon     = tc2.Icon
                        local callback = tc2.Callback or function() end
                        local state = default
                        local row = Row(name, icon, gear)
                        local track = New("Frame", {
                            Size = UDim2.new(0, 38, 0, 20), Position = UDim2.new(1, -38, 0.5, -10),
                            BackgroundColor3 = state and C.ACCENT or C.ELEMENT, BorderSizePixel = 0, Parent = row
                        })
                        Rnd(track, 10)
                        local knob = New("Frame", {
                            Size = UDim2.new(0, 14, 0, 14),
                            Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                            BackgroundColor3 = C.WHITE, BorderSizePixel = 0, Parent = track
                        })
                        Rnd(knob, 7)
                        local hb = New("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = row })
                        hb.MouseButton1Click:Connect(function()
                            state = not state
                            Tw(track, { BackgroundColor3 = state and C.ACCENT or C.ELEMENT })
                            Tw(knob,  { Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7) })
                            callback(state)
                        end)
                        local el = {}
                        function el:Get() return state end
                        function el:Set(v)
                            state = v
                            Tw(track, { BackgroundColor3 = state and C.ACCENT or C.ELEMENT })
                            Tw(knob,  { Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7) })
                            callback(state)
                        end
                        return el
                    end

                    function sec:AddSlider(sc2)
                        sc2 = sc2 or {}
                        local name     = sc2.Name     or "Slider"
                        local min      = sc2.Min      or 0
                        local max      = sc2.Max      or 100
                        local default  = sc2.Default  or min
                        local icon     = sc2.Icon
                        local callback = sc2.Callback or function() end
                        local val = math.clamp(default, min, max)
                        local row = New("Frame", {
                            Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Parent = items
                        })
                        local labelHolder = New("Frame", {
                            Size = UDim2.new(0.5, 0, 0, 18), Position = UDim2.new(0, 0, 0, 4),
                            BackgroundTransparency = 1, Parent = row
                        })
                        New("UIListLayout", {
                            FillDirection = Enum.FillDirection.Horizontal,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
                            Parent = labelHolder
                        })
                        if icon and Icons[icon] then
                            New("ImageLabel", {
                                Size = UDim2.new(0, 13, 0, 13),
                                BackgroundTransparency = 1,
                                Image = Icons[icon], ImageColor3 = C.TXT2,
                                Parent = labelHolder
                            })
                        end
                        New("TextLabel", {
                            Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                            BackgroundTransparency = 1, Text = name,
                            TextColor3 = C.TXT2, TextSize = 12, Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left, Parent = labelHolder
                        })
                        local valLbl = New("TextLabel", {
                            Size = UDim2.new(0, 26, 0, 16), Position = UDim2.new(1, -26, 0, 4),
                            BackgroundTransparency = 1, Text = tostring(val),
                            TextColor3 = C.TXT, TextSize = 12, Font = Enum.Font.GothamBold,
                            TextXAlignment = Enum.TextXAlignment.Right, Parent = row
                        })
                        local bar = New("Frame", {
                            Size = UDim2.new(0.46, -30, 0, 3), Position = UDim2.new(0.5, 0, 0, 16),
                            BackgroundColor3 = C.ELEMENT, BorderSizePixel = 0, Parent = row
                        })
                        Rnd(bar, 2)
                        local fill = New("Frame", {
                            Size = UDim2.new((val-min)/(max-min), 0, 1, 0),
                            BackgroundColor3 = C.ACCENT, BorderSizePixel = 0, Parent = bar
                        })
                        Rnd(fill, 2)
                        local dot = New("Frame", {
                            Size = UDim2.new(0, 11, 0, 11),
                            Position = UDim2.new((val-min)/(max-min), -5, 0.5, -5),
                            BackgroundColor3 = C.WHITE, BorderSizePixel = 0, Parent = bar
                        })
                        Rnd(dot, 6)
                        local sliding = false
                        local function upd(x)
                            local frac = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                            val = math.floor(min + frac * (max - min) + 0.5)
                            local f2 = (val-min)/(max-min)
                            fill.Size = UDim2.new(f2, 0, 1, 0)
                            dot.Position = UDim2.new(f2, -5, 0.5, -5)
                            valLbl.Text = tostring(val)
                            callback(val)
                        end
                        local hb = New("TextButton", {
                            Size = UDim2.new(1, 0, 1, 12), Position = UDim2.new(0, 0, 0, -6),
                            BackgroundTransparency = 1, Text = "", Parent = bar
                        })
                        hb.MouseButton1Down:Connect(function(x) sliding = true; upd(x) end)
                        UserInputService.InputChanged:Connect(function(i)
                            if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then upd(i.Position.X) end
                        end)
                        UserInputService.InputEnded:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = false end
                        end)
                        local el = {}
                        function el:Get() return val end
                        function el:Set(v)
                            val = math.clamp(v, min, max)
                            local f = (val-min)/(max-min)
                            fill.Size = UDim2.new(f, 0, 1, 0)
                            dot.Position = UDim2.new(f, -5, 0.5, -5)
                            valLbl.Text = tostring(val)
                            callback(val)
                        end
                        return el
                    end

                    function sec:AddDropdown(dc)
                        dc = dc or {}
                        local name     = dc.Name     or "Dropdown"
                        local opts     = dc.Options  or {}
                        local default  = dc.Default  or (opts[1] or "")
                        local icon     = dc.Icon
                        local callback = dc.Callback or function() end
                        local sel = default
                        local isOpen = false
                        local wrap = New("Frame", {
                            Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1,
                            ClipsDescendants = false, Parent = items
                        })
                        local labelHolder = New("Frame", {
                            Size = UDim2.new(0.4, 0, 0, 18), Position = UDim2.new(0, 0, 0, 7),
                            BackgroundTransparency = 1, Parent = wrap
                        })
                        New("UIListLayout", {
                            FillDirection = Enum.FillDirection.Horizontal,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
                            Parent = labelHolder
                        })
                        if icon and Icons[icon] then
                            New("ImageLabel", {
                                Size = UDim2.new(0, 13, 0, 13),
                                BackgroundTransparency = 1,
                                Image = Icons[icon], ImageColor3 = C.TXT2,
                                Parent = labelHolder
                            })
                        end
                        New("TextLabel", {
                            Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                            BackgroundTransparency = 1, Text = name,
                            TextColor3 = C.TXT2, TextSize = 12, Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left, Parent = labelHolder
                        })
                        local dropBtn = New("TextButton", {
                            Size = UDim2.new(0.57, 0, 0, 22), Position = UDim2.new(0.41, 0, 0, 5),
                            BackgroundColor3 = C.ELEMENT, BorderSizePixel = 0, Text = "", Parent = wrap
                        })
                        Rnd(dropBtn, 4)
                        Brdr(dropBtn)
                        local selLbl = New("TextLabel", {
                            Size = UDim2.new(1, -22, 1, 0), Position = UDim2.new(0, 7, 0, 0),
                            BackgroundTransparency = 1, Text = sel, TextColor3 = C.TXT,
                            TextSize = 11, Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left, Parent = dropBtn
                        })
                        local arrowHolder = New("Frame", {
                            Size = UDim2.new(0, 14, 0, 14),
                            Position = UDim2.new(1, -18, 0.5, -7),
                            BackgroundTransparency = 1, Parent = dropBtn
                        })
                        local arrowImg = Icon(arrowHolder, "chevron-down", 13, C.TXT2)
                        local listFrame = New("Frame", {
                            Size = UDim2.new(1, 0, 0, #opts * 24),
                            Position = UDim2.new(0, 0, 1, 2),
                            BackgroundColor3 = C.ELEMENT, BorderSizePixel = 0,
                            ClipsDescendants = true, ZIndex = 20,
                            Visible = false, Parent = dropBtn
                        })
                        Rnd(listFrame, 4)
                        Brdr(listFrame)
                        New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = listFrame })
                        for _, opt in ipairs(opts) do
                            local ob = New("TextButton", {
                                Size = UDim2.new(1, 0, 0, 24),
                                BackgroundTransparency = 1, BorderSizePixel = 0,
                                Text = opt, TextColor3 = C.TXT2, TextSize = 11, Font = Enum.Font.Gotham,
                                TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 20, Parent = listFrame
                            })
                            New("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = ob })
                            ob.MouseEnter:Connect(function() ob.TextColor3 = C.TXT end)
                            ob.MouseLeave:Connect(function() ob.TextColor3 = C.TXT2 end)
                            ob.MouseButton1Click:Connect(function()
                                sel = opt; selLbl.Text = opt
                                isOpen = false; listFrame.Visible = false
                                if arrowImg and arrowImg:IsA("ImageLabel") then
                                    Tw(arrowHolder, { Rotation = 0 })
                                end
                                callback(sel)
                            end)
                        end
                        dropBtn.MouseButton1Click:Connect(function()
                            isOpen = not isOpen
                            listFrame.Visible = isOpen
                            if arrowImg and arrowImg:IsA("ImageLabel") then
                                Tw(arrowHolder, { Rotation = isOpen and 180 or 0 })
                            end
                        end)
                        local el = {}
                        function el:Get() return sel end
                        function el:Set(v) sel = v; selLbl.Text = v; callback(v) end
                        return el
                    end

                    function sec:AddButton(bc)
                        bc = bc or {}
                        local name     = bc.Name     or "Button"
                        local icon     = bc.Icon
                        local callback = bc.Callback or function() end
                        local btn = New("TextButton", {
                            Size = UDim2.new(1, 0, 0, 28),
                            BackgroundColor3 = C.ACCENT, BorderSizePixel = 0,
                            Text = "", Parent = items
                        })
                        Rnd(btn, 5)
                        local btnInner = New("Frame", {
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1, Parent = btn
                        })
                        New("UIListLayout", {
                            FillDirection = Enum.FillDirection.Horizontal,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6),
                            Parent = btnInner
                        })
                        if icon and Icons[icon] then
                            New("ImageLabel", {
                                Size = UDim2.new(0, 13, 0, 13),
                                BackgroundTransparency = 1,
                                Image = Icons[icon], ImageColor3 = C.WHITE,
                                Parent = btnInner
                            })
                        end
                        New("TextLabel", {
                            Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                            BackgroundTransparency = 1, Text = name,
                            TextColor3 = C.WHITE, TextSize = 12, Font = Enum.Font.GothamSemibold,
                            Parent = btnInner
                        })
                        btn.MouseEnter:Connect(function() Tw(btn, { BackgroundColor3 = Color3.fromRGB(235, 65, 65) }) end)
                        btn.MouseLeave:Connect(function() Tw(btn, { BackgroundColor3 = C.ACCENT }) end)
                        btn.MouseButton1Down:Connect(function() Tw(btn, { BackgroundColor3 = C.ACCENT2 }) end)
                        btn.MouseButton1Up:Connect(function() Tw(btn, { BackgroundColor3 = C.ACCENT }) end)
                        btn.MouseButton1Click:Connect(callback)
                    end

                    function sec:AddLabel(lc)
                        lc = type(lc) == "string" and { Text = lc } or (lc or {})
                        local row = New("Frame", {
                            Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = items
                        })
                        New("UIListLayout", {
                            FillDirection = Enum.FillDirection.Horizontal,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5),
                            Parent = row
                        })
                        if lc.Icon and Icons[lc.Icon] then
                            New("ImageLabel", {
                                Size = UDim2.new(0, 12, 0, 12),
                                BackgroundTransparency = 1,
                                Image = Icons[lc.Icon], ImageColor3 = lc.Color or C.TXT2,
                                Parent = row
                            })
                        end
                        New("TextLabel", {
                            Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                            BackgroundTransparency = 1, Text = lc.Text or "",
                            TextColor3 = lc.Color or C.TXT2, TextSize = 11, Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left, Parent = row
                        })
                    end

                    return sec
                end
            end

            table.insert(page.Tabs, tab)

            tBtn.MouseButton1Click:Connect(function()
                for _, t in pairs(page.Tabs) do
                    t.Content.Visible = false
                    t.Lbl.TextColor3 = C.TXT2
                    if t.Radio then
                        t.Radio.Dot.Visible = false
                        if t.Radio.Stroke then t.Radio.Stroke.Color = C.TXT2 end
                    end
                    if t.Img then
                        local img = t.Img:FindFirstChildWhichIsA("ImageLabel")
                        if img then img.ImageColor3 = C.TXT2 end
                    end
                end
                tContent.Visible = true
                tLbl.TextColor3 = C.TXT
                if radioData then
                    radioData.Dot.Visible = true
                    if radioData.Stroke then radioData.Stroke.Color = C.ACCENT end
                end
                if tImgHolder then
                    local img = tImgHolder:FindFirstChildWhichIsA("ImageLabel")
                    if img then img.ImageColor3 = C.WHITE end
                end
            end)

            if #page.Tabs == 1 then
                tContent.Visible = true
                tLbl.TextColor3 = C.TXT
                if radioData then
                    radioData.Dot.Visible = true
                    if radioData.Stroke then radioData.Stroke.Color = C.ACCENT end
                end
                if tImgHolder then
                    local img = tImgHolder:FindFirstChildWhichIsA("ImageLabel")
                    if img then img.ImageColor3 = C.WHITE end
                end
            end

            return tab
        end

        table.insert(win.Pages, page)

        navBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(win.Pages) do
                p.Frame.Visible = false
                p.Indicator.Visible = false
                p.TabScrollFrame.Visible = false
                if p.NavImg then
                    if p.NavImg:IsA("ImageLabel") then p.NavImg.ImageColor3 = C.TXT2
                    elseif p.NavImg:IsA("TextLabel") then p.NavImg.TextColor3 = C.TXT2 end
                end
            end
            pageFrame.Visible = true
            indicator.Visible = true
            innerTabScroll.Visible = true
            if navImg then
                if navImg:IsA("ImageLabel") then navImg.ImageColor3 = C.ACCENT
                elseif navImg:IsA("TextLabel") then navImg.TextColor3 = C.ACCENT end
            end
            titleLbl.Text = pName
            subLbl.Text = pSub
            win.ActivePage = page
        end)

        if #win.Pages == 1 then
            pageFrame.Visible = true
            indicator.Visible = true
            innerTabScroll.Visible = true
            if navImg then
                if navImg:IsA("ImageLabel") then navImg.ImageColor3 = C.ACCENT
                elseif navImg:IsA("TextLabel") then navImg.TextColor3 = C.ACCENT end
            end
            titleLbl.Text = pName
            subLbl.Text = pSub
            win.ActivePage = page
        end

        return page
    end

    return win
end

return Law
