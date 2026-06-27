local Law = {}
Law.__index = Law

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ACCENT = Color3.fromRGB(220, 55, 55)
local ACCENT_DARK = Color3.fromRGB(160, 35, 35)
local BG_MAIN = Color3.fromRGB(16, 16, 20)
local BG_SIDE = Color3.fromRGB(12, 12, 16)
local BG_CONTENT = Color3.fromRGB(20, 20, 26)
local BG_SECTION = Color3.fromRGB(24, 24, 32)
local BG_ELEMENT = Color3.fromRGB(28, 28, 38)
local TEXT_PRIMARY = Color3.fromRGB(235, 235, 245)
local TEXT_SECONDARY = Color3.fromRGB(140, 140, 160)
local BORDER = Color3.fromRGB(38, 38, 52)

local TWEEN_FAST = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_MED = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    if props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function Stroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or BORDER,
        Thickness = thickness or 1,
        Parent = parent
    })
end

local function Corner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
        Parent = parent
    })
end

function Law:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Law.cc"
    local subtitle = config.Subtitle or ""
    local size = config.Size or UDim2.new(0, 620, 0, 440)
    local useTypeWriter = config.TypeWriter or false
    local logoText = config.Logo or string.sub(title, 1, 2):upper()

    local gui = Create("ScreenGui", {
        Name = "LawCC",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Parent = game:GetService("CoreGui")
    })

    local openButton = Create("TextButton", {
        Name = "OpenButton",
        Size = UDim2.new(0, 46, 0, 46),
        Position = UDim2.new(0, 16, 0.5, -23),
        BackgroundColor3 = ACCENT,
        BorderSizePixel = 0,
        Text = logoText,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        ZIndex = 10,
        Visible = false,
        Parent = gui
    })
    Corner(openButton, 8)
    Stroke(openButton, ACCENT_DARK)

    local mainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = size,
        Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2),
        BackgroundColor3 = BG_MAIN,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = gui
    })
    Corner(mainFrame, 10)
    Stroke(mainFrame, BORDER)

    local dragging, dragInput, dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    local sidebar = Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 54, 1, 0),
        BackgroundColor3 = BG_SIDE,
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local logoFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = ACCENT,
        BorderSizePixel = 0,
        Parent = sidebar
    })
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = logoText,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = logoFrame
    })

    local sidebarList = Create("Frame", {
        Size = UDim2.new(1, 0, 1, -58),
        Position = UDim2.new(0, 0, 0, 58),
        BackgroundTransparency = 1,
        Parent = sidebar
    })
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = sidebarList
    })
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        Parent = sidebarList
    })

    local contentFrame = Create("Frame", {
        Name = "ContentFrame",
        Size = UDim2.new(1, -54, 1, 0),
        Position = UDim2.new(0, 54, 0, 0),
        BackgroundColor3 = BG_CONTENT,
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundTransparency = 1,
        Parent = contentFrame
    })

    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -60, 0, 22),
        Position = UDim2.new(0, 16, 0, 10),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = TEXT_PRIMARY,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    local subtitleLabel = Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 16),
        Position = UDim2.new(0, 16, 0, 33),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = TEXT_SECONDARY,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    local closeBtn = Create("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(1, -38, 0, 16),
        BackgroundColor3 = BG_ELEMENT,
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = TEXT_SECONDARY,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = header
    })
    Corner(closeBtn, 6)
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        openButton.Visible = true
    end)
    openButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        openButton.Visible = false
    end)

    local headerLine = Create("Frame", {
        Size = UDim2.new(1, -16, 0, 1),
        Position = UDim2.new(0, 8, 0, 57),
        BackgroundColor3 = BORDER,
        BorderSizePixel = 0,
        Parent = contentFrame
    })

    local tabBarHolder = Create("Frame", {
        Name = "TabBarHolder",
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 0, 58),
        BackgroundColor3 = BG_SIDE,
        BorderSizePixel = 0,
        Parent = contentFrame
    })
    local tabBarScroll = Create("ScrollingFrame", {
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        Parent = tabBarHolder
    })
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = tabBarScroll
    })

    local tabLine = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = BORDER,
        BorderSizePixel = 0,
        Parent = tabBarHolder
    })

    local tabContentHolder = Create("Frame", {
        Name = "TabContentHolder",
        Size = UDim2.new(1, 0, 1, -95),
        Position = UDim2.new(0, 0, 0, 95),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = contentFrame
    })

    if useTypeWriter then
        task.spawn(function()
            while task.wait() do
                for i = 1, #title do
                    titleLabel.Text = string.sub(title, 1, i)
                    task.wait(0.07)
                end
                task.wait(2)
                for i = #title, 0, -1 do
                    titleLabel.Text = string.sub(title, 1, i)
                    task.wait(0.05)
                end
                task.wait(0.4)
            end
        end)
    end

    local window = {
        Gui = gui,
        MainFrame = mainFrame,
        Sidebar = sidebarList,
        TabBarScroll = tabBarScroll,
        TabContentHolder = tabContentHolder,
        TitleLabel = titleLabel,
        SubtitleLabel = subtitleLabel,
        Tabs = {},
        SidePages = {},
        ActiveSidePage = nil,
        ActiveTab = nil
    }

    function window:CreatePage(pageConfig)
        pageConfig = pageConfig or {}
        local pageName = pageConfig.Name or "Page"
        local pageIcon = pageConfig.Icon or "☰"
        local pageSubtitle = pageConfig.Subtitle or ""

        local sideBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = pageIcon,
            TextColor3 = TEXT_SECONDARY,
            TextSize = 18,
            Font = Enum.Font.GothamBold,
            Parent = sidebarList
        })

        local sideIndicator = Create("Frame", {
            Size = UDim2.new(0, 3, 0, 20),
            Position = UDim2.new(0, 0, 0.5, -10),
            BackgroundColor3 = ACCENT,
            BorderSizePixel = 0,
            Visible = false,
            Parent = sideBtn
        })
        Corner(sideIndicator, 2)

        local pageContent = Create("Frame", {
            Name = pageName .. "Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = tabContentHolder
        })

        local page = {
            SideBtn = sideBtn,
            SideIndicator = sideIndicator,
            Content = pageContent,
            Tabs = {}
        }

        local tabButtonsFrame = Create("Frame", {
            Name = "TabButtons",
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundTransparency = 1,
            Parent = pageContent
        })

        local innerTabScroll = Create("ScrollingFrame", {
            Size = UDim2.new(1, -16, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.X,
            Parent = tabButtonsFrame
        })
        Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = innerTabScroll
        })

        local innerTabContent = Create("Frame", {
            Size = UDim2.new(1, 0, 1, -36),
            Position = UDim2.new(0, 0, 0, 36),
            BackgroundTransparency = 1,
            Parent = pageContent
        })

        function page:CreateTab(tabConfig)
            tabConfig = tabConfig or {}
            local tabName = tabConfig.Name or "Tab"
            local tabIcon = tabConfig.Icon or ""
            local displayText = (tabIcon ~= "" and (tabIcon .. "  ") or "") .. tabName

            local tabBtn = Create("TextButton", {
                Size = UDim2.new(0, 0, 0, 28),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = BG_ELEMENT,
                BorderSizePixel = 0,
                Text = displayText,
                TextColor3 = TEXT_SECONDARY,
                TextSize = 12,
                Font = Enum.Font.GothamSemibold,
                Parent = innerTabScroll
            })
            Corner(tabBtn, 5)
            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12),
                Parent = tabBtn
            })

            local tabContent = Create("ScrollingFrame", {
                Name = tabName .. "Content",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = ACCENT,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                Visible = false,
                Parent = innerTabContent
            })
            Create("UIPadding", {
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12),
                Parent = tabContent
            })

            local colHolder = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent = tabContent
            })

            local leftCol = Create("Frame", {
                Name = "Left",
                Size = UDim2.new(0.5, -5, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent = colHolder
            })
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8),
                Parent = leftCol
            })

            local rightCol = Create("Frame", {
                Name = "Right",
                Size = UDim2.new(0.5, -5, 0, 0),
                Position = UDim2.new(0.5, 5, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent = colHolder
            })
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8),
                Parent = rightCol
            })

            local tab = {
                Btn = tabBtn,
                Content = tabContent,
                LeftCol = leftCol,
                RightCol = rightCol
            }

            function tab:CreateSection(sectionConfig)
                sectionConfig = sectionConfig or {}
                local sName = sectionConfig.Name or "Section"
                local side = sectionConfig.Side or "Left"
                local parentCol = side == "Right" and rightCol or leftCol

                local sectionFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = BG_SECTION,
                    BorderSizePixel = 0,
                    Parent = parentCol
                })
                Corner(sectionFrame, 7)
                Stroke(sectionFrame, BORDER)

                local sectionHeader = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Parent = sectionFrame
                })

                Create("TextLabel", {
                    Size = UDim2.new(1, -16, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1,
                    Text = sName,
                    TextColor3 = TEXT_PRIMARY,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sectionHeader
                })

                local sectionDivider = Create("Frame", {
                    Size = UDim2.new(1, -24, 0, 1),
                    Position = UDim2.new(0, 12, 0, 29),
                    BackgroundColor3 = BORDER,
                    BorderSizePixel = 0,
                    Parent = sectionFrame
                })

                local itemList = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 30),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Parent = sectionFrame
                })
                Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = itemList
                })
                Create("UIPadding", {
                    PaddingTop = UDim.new(0, 2),
                    PaddingBottom = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    Parent = itemList
                })

                local section = { ItemList = itemList }

                local function makeRow(label, showGear)
                    local row = Create("Frame", {
                        Size = UDim2.new(1, 0, 0, 34),
                        BackgroundTransparency = 1,
                        Parent = itemList
                    })
                    Create("TextLabel", {
                        Size = UDim2.new(0.55, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = label,
                        TextColor3 = TEXT_SECONDARY,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = row
                    })
                    if showGear then
                        local gear = Create("TextLabel", {
                            Size = UDim2.new(0, 18, 0, 18),
                            Position = UDim2.new(0.55, 0, 0.5, -9),
                            BackgroundTransparency = 1,
                            Text = "⚙",
                            TextColor3 = TEXT_SECONDARY,
                            TextSize = 13,
                            Font = Enum.Font.Gotham,
                            Parent = row
                        })
                    end
                    return row
                end

                function section:AddToggle(tConfig)
                    tConfig = tConfig or {}
                    local tName = tConfig.Name or "Toggle"
                    local default = tConfig.Default or false
                    local showGear = tConfig.Gear or false
                    local callback = tConfig.Callback or function() end

                    local state = default
                    local row = makeRow(tName, showGear)

                    local track = Create("Frame", {
                        Size = UDim2.new(0, 40, 0, 20),
                        Position = UDim2.new(1, -40, 0.5, -10),
                        BackgroundColor3 = state and ACCENT or Color3.fromRGB(42, 42, 58),
                        BorderSizePixel = 0,
                        Parent = row
                    })
                    Corner(track, 10)

                    local knob = Create("Frame", {
                        Size = UDim2.new(0, 14, 0, 14),
                        Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel = 0,
                        Parent = track
                    })
                    Corner(knob, 7)

                    local hitbox = Create("TextButton", {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = "",
                        Parent = row
                    })
                    hitbox.MouseButton1Click:Connect(function()
                        state = not state
                        TweenService:Create(track, TWEEN_FAST, {
                            BackgroundColor3 = state and ACCENT or Color3.fromRGB(42, 42, 58)
                        }):Play()
                        TweenService:Create(knob, TWEEN_FAST, {
                            Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                        }):Play()
                        callback(state)
                    end)

                    local el = {}
                    function el:Get() return state end
                    function el:Set(v)
                        state = v
                        TweenService:Create(track, TWEEN_FAST, {
                            BackgroundColor3 = state and ACCENT or Color3.fromRGB(42, 42, 58)
                        }):Play()
                        TweenService:Create(knob, TWEEN_FAST, {
                            Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                        }):Play()
                        callback(state)
                    end
                    return el
                end

                function section:AddSlider(sConfig)
                    sConfig = sConfig or {}
                    local sName = sConfig.Name or "Slider"
                    local min = sConfig.Min or 0
                    local max = sConfig.Max or 100
                    local default = sConfig.Default or min
                    local callback = sConfig.Callback or function() end

                    local value = math.clamp(default, min, max)

                    local row = Create("Frame", {
                        Size = UDim2.new(1, 0, 0, 34),
                        BackgroundTransparency = 1,
                        Parent = itemList
                    })

                    Create("TextLabel", {
                        Size = UDim2.new(0.45, 0, 0, 18),
                        Position = UDim2.new(0, 0, 0, 4),
                        BackgroundTransparency = 1,
                        Text = sName,
                        TextColor3 = TEXT_SECONDARY,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = row
                    })

                    local valueLabel = Create("TextLabel", {
                        Size = UDim2.new(0, 28, 0, 18),
                        Position = UDim2.new(1, -28, 0, 4),
                        BackgroundTransparency = 1,
                        Text = tostring(value),
                        TextColor3 = TEXT_PRIMARY,
                        TextSize = 12,
                        Font = Enum.Font.GothamBold,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        Parent = row
                    })

                    local trackBg = Create("Frame", {
                        Size = UDim2.new(0.48, -32, 0, 4),
                        Position = UDim2.new(0.45, 0, 0, 15),
                        BackgroundColor3 = Color3.fromRGB(42, 42, 58),
                        BorderSizePixel = 0,
                        Parent = row
                    })
                    Corner(trackBg, 2)

                    local fill = Create("Frame", {
                        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                        BackgroundColor3 = ACCENT,
                        BorderSizePixel = 0,
                        Parent = trackBg
                    })
                    Corner(fill, 2)

                    local handle = Create("Frame", {
                        Size = UDim2.new(0, 12, 0, 12),
                        Position = UDim2.new((value - min) / (max - min), -6, 0.5, -6),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel = 0,
                        Parent = trackBg
                    })
                    Corner(handle, 6)

                    local draggingSlider = false
                    local function updateSlider(inputPos)
                        local absPos = trackBg.AbsolutePosition.X
                        local absSize = trackBg.AbsoluteSize.X
                        local rel = math.clamp((inputPos - absPos) / absSize, 0, 1)
                        value = math.floor(min + rel * (max - min) + 0.5)
                        local frac = (value - min) / (max - min)
                        fill.Size = UDim2.new(frac, 0, 1, 0)
                        handle.Position = UDim2.new(frac, -6, 0.5, -6)
                        valueLabel.Text = tostring(value)
                        callback(value)
                    end

                    local hitbox = Create("TextButton", {
                        Size = UDim2.new(1, 0, 1, 10),
                        Position = UDim2.new(0, 0, 0, -5),
                        BackgroundTransparency = 1,
                        Text = "",
                        Parent = trackBg
                    })
                    hitbox.MouseButton1Down:Connect(function(x)
                        draggingSlider = true
                        updateSlider(x)
                    end)
                    hitbox.TouchLongPress:Connect(function(touches)
                        if touches[1] then
                            draggingSlider = true
                        end
                    end)
                    UserInputService.InputChanged:Connect(function(input)
                        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            updateSlider(input.Position.X)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            draggingSlider = false
                        end
                    end)

                    local el = {}
                    function el:Get() return value end
                    function el:Set(v)
                        value = math.clamp(v, min, max)
                        local frac = (value - min) / (max - min)
                        fill.Size = UDim2.new(frac, 0, 1, 0)
                        handle.Position = UDim2.new(frac, -6, 0.5, -6)
                        valueLabel.Text = tostring(value)
                        callback(value)
                    end
                    return el
                end

                function section:AddDropdown(dConfig)
                    dConfig = dConfig or {}
                    local dName = dConfig.Name or "Dropdown"
                    local options = dConfig.Options or {}
                    local default = dConfig.Default or (options[1] or "")
                    local callback = dConfig.Callback or function() end

                    local selected = default
                    local open = false

                    local container = Create("Frame", {
                        Size = UDim2.new(1, 0, 0, 34),
                        BackgroundTransparency = 1,
                        ClipsDescendants = false,
                        ZIndex = 5,
                        Parent = itemList
                    })

                    Create("TextLabel", {
                        Size = UDim2.new(0.45, 0, 0, 18),
                        Position = UDim2.new(0, 0, 0, 8),
                        BackgroundTransparency = 1,
                        Text = dName,
                        TextColor3 = TEXT_SECONDARY,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 5,
                        Parent = container
                    })

                    local dropBtn = Create("TextButton", {
                        Size = UDim2.new(0.52, 0, 0, 24),
                        Position = UDim2.new(0.46, 0, 0, 5),
                        BackgroundColor3 = BG_ELEMENT,
                        BorderSizePixel = 0,
                        Text = "",
                        ZIndex = 5,
                        Parent = container
                    })
                    Corner(dropBtn, 4)
                    Stroke(dropBtn, BORDER)

                    local selectedLabel = Create("TextLabel", {
                        Size = UDim2.new(1, -26, 1, 0),
                        Position = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        Text = selected,
                        TextColor3 = TEXT_PRIMARY,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 5,
                        Parent = dropBtn
                    })

                    local arrow = Create("TextLabel", {
                        Size = UDim2.new(0, 18, 1, 0),
                        Position = UDim2.new(1, -20, 0, 0),
                        BackgroundTransparency = 1,
                        Text = "▾",
                        TextColor3 = TEXT_SECONDARY,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        ZIndex = 5,
                        Parent = dropBtn
                    })

                    local dropList = Create("Frame", {
                        Name = "DropList",
                        Size = UDim2.new(1, 0, 0, 0),
                        Position = UDim2.new(0, 0, 1, 2),
                        BackgroundColor3 = BG_ELEMENT,
                        BorderSizePixel = 0,
                        ClipsDescendants = true,
                        ZIndex = 10,
                        Visible = false,
                        Parent = dropBtn
                    })
                    Corner(dropList, 4)
                    Stroke(dropList, BORDER)
                    Create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        ZIndex = 10,
                        Parent = dropList
                    })

                    for _, opt in ipairs(options) do
                        local optBtn = Create("TextButton", {
                            Size = UDim2.new(1, 0, 0, 26),
                            BackgroundTransparency = 1,
                            Text = opt,
                            TextColor3 = TEXT_SECONDARY,
                            TextSize = 12,
                            Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 10,
                            Parent = dropList
                        })
                        Create("UIPadding", {
                            PaddingLeft = UDim.new(0, 8),
                            Parent = optBtn
                        })
                        optBtn.MouseEnter:Connect(function()
                            optBtn.TextColor3 = TEXT_PRIMARY
                        end)
                        optBtn.MouseLeave:Connect(function()
                            optBtn.TextColor3 = TEXT_SECONDARY
                        end)
                        optBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            selectedLabel.Text = opt
                            open = false
                            dropList.Visible = false
                            TweenService:Create(arrow, TWEEN_FAST, { Rotation = 0 }):Play()
                            callback(selected)
                        end)
                    end

                    dropBtn.MouseButton1Click:Connect(function()
                        open = not open
                        dropList.Visible = open
                        dropList.Size = UDim2.new(1, 0, 0, open and (#options * 26) or 0)
                        TweenService:Create(arrow, TWEEN_FAST, { Rotation = open and 180 or 0 }):Play()
                    end)

                    local el = {}
                    function el:Get() return selected end
                    function el:Set(v)
                        selected = v
                        selectedLabel.Text = v
                        callback(v)
                    end
                    return el
                end

                function section:AddButton(bConfig)
                    bConfig = bConfig or {}
                    local bName = bConfig.Name or "Button"
                    local callback = bConfig.Callback or function() end

                    local btn = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 30),
                        BackgroundColor3 = ACCENT,
                        BorderSizePixel = 0,
                        Text = bName,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextSize = 12,
                        Font = Enum.Font.GothamSemibold,
                        Parent = itemList
                    })
                    Corner(btn, 5)

                    btn.MouseEnter:Connect(function()
                        TweenService:Create(btn, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(240, 75, 75) }):Play()
                    end)
                    btn.MouseLeave:Connect(function()
                        TweenService:Create(btn, TWEEN_FAST, { BackgroundColor3 = ACCENT }):Play()
                    end)
                    btn.MouseButton1Down:Connect(function()
                        TweenService:Create(btn, TWEEN_FAST, { BackgroundColor3 = ACCENT_DARK }):Play()
                    end)
                    btn.MouseButton1Up:Connect(function()
                        TweenService:Create(btn, TWEEN_FAST, { BackgroundColor3 = ACCENT }):Play()
                    end)
                    btn.MouseButton1Click:Connect(callback)
                end

                function section:AddLabel(lConfig)
                    lConfig = type(lConfig) == "string" and { Text = lConfig } or lConfig or {}
                    local text = lConfig.Text or ""
                    local color = lConfig.Color or TEXT_SECONDARY

                    Create("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 26),
                        BackgroundTransparency = 1,
                        Text = text,
                        TextColor3 = color,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = itemList
                    })
                end

                return section
            end

            table.insert(page.Tabs, tab)

            tabBtn.MouseButton1Click:Connect(function()
                for _, t in pairs(page.Tabs) do
                    t.Content.Visible = false
                    TweenService:Create(t.Btn, TWEEN_FAST, {
                        BackgroundColor3 = BG_ELEMENT,
                        TextColor3 = TEXT_SECONDARY
                    }):Play()
                end
                tabContent.Visible = true
                TweenService:Create(tabBtn, TWEEN_FAST, {
                    BackgroundColor3 = ACCENT,
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
            end)

            if #page.Tabs == 1 then
                tabContent.Visible = true
                tabBtn.BackgroundColor3 = ACCENT
                tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end

            return tab
        end

        table.insert(window.SidePages, page)

        sideBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(window.SidePages) do
                p.Content.Visible = false
                p.SideIndicator.Visible = false
                TweenService:Create(p.SideBtn, TWEEN_FAST, { TextColor3 = TEXT_SECONDARY }):Play()
            end
            pageContent.Visible = true
            sideIndicator.Visible = true
            TweenService:Create(sideBtn, TWEEN_FAST, { TextColor3 = ACCENT }):Play()
            titleLabel.Text = pageName
            subtitleLabel.Text = pageSubtitle
            window.ActiveSidePage = page
        end)

        if #window.SidePages == 1 then
            pageContent.Visible = true
            sideIndicator.Visible = true
            sideBtn.TextColor3 = ACCENT
            titleLabel.Text = pageName
            subtitleLabel.Text = pageSubtitle
            window.ActiveSidePage = page
        end

        return page
    end

    return window
end

return Law
