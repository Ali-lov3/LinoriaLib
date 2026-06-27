local Law = {}
Law.__index = Law

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

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

function Law:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Law.cc"
    local size = config.Size or UDim2.new(0, 560, 0, 420)
    local useTypeWriter = config.TypeWriter or false

    local screenGui = Create("ScreenGui", {
        Name = "LawCC",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game:GetService("CoreGui")
    })

    local mainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = size,
        Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2),
        BackgroundColor3 = Color3.fromRGB(18, 18, 26),
        BorderSizePixel = 0,
        Parent = screenGui
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = mainFrame })
    Create("UIStroke", {
        Color = Color3.fromRGB(60, 60, 85),
        Thickness = 1,
        Parent = mainFrame
    })

    local titleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Color3.fromRGB(13, 13, 20),
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = titleBar })
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Color3.fromRGB(13, 13, 20),
        BorderSizePixel = 0,
        Parent = titleBar
    })

    local accentLine = Create("Frame", {
        Size = UDim2.new(0, 48, 0, 2),
        Position = UDim2.new(0, 12, 1, -2),
        BackgroundColor3 = Color3.fromRGB(108, 84, 255),
        BorderSizePixel = 0,
        Parent = titleBar
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = accentLine })

    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(240, 240, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    if useTypeWriter then
        task.spawn(function()
            while task.wait() do
                for i = 1, #title do
                    titleLabel.Text = string.sub(title, 1, i)
                    task.wait(0.07)
                end
                task.wait(1.8)
                for i = #title, 0, -1 do
                    titleLabel.Text = string.sub(title, 1, i)
                    task.wait(0.045)
                end
                task.wait(0.4)
            end
        end)
    end

    local dragging, dragInput, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    local tabBar = Create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, -24, 0, 30),
        Position = UDim2.new(0, 12, 0, 44),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        Parent = tabBar
    })

    local separator = Create("Frame", {
        Size = UDim2.new(1, -24, 0, 1),
        Position = UDim2.new(0, 12, 0, 78),
        BackgroundColor3 = Color3.fromRGB(40, 40, 58),
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local contentArea = Create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -24, 1, -92),
        Position = UDim2.new(0, 12, 0, 84),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })

    local window = {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        TabBar = tabBar,
        ContentArea = contentArea,
        Tabs = {}
    }

    function window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"

        local tabButton = Create("TextButton", {
            Name = tabName,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = Color3.fromRGB(28, 28, 40),
            BorderSizePixel = 0,
            Text = tabName,
            TextColor3 = Color3.fromRGB(155, 155, 175),
            TextSize = 13,
            Font = Enum.Font.GothamSemibold,
            Parent = tabBar
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tabButton })
        Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            Parent = tabButton
        })

        local tabContent = Create("Frame", {
            Name = tabName .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = contentArea
        })

        local leftCol = Create("ScrollingFrame", {
            Name = "LeftCol",
            Size = UDim2.new(0.5, -5, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Color3.fromRGB(108, 84, 255),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = tabContent
        })
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = leftCol
        })

        local rightCol = Create("ScrollingFrame", {
            Name = "RightCol",
            Size = UDim2.new(0.5, -5, 1, 0),
            Position = UDim2.new(0.5, 5, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Color3.fromRGB(108, 84, 255),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = tabContent
        })
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = rightCol
        })

        local tab = {
            Button = tabButton,
            Content = tabContent,
            LeftCol = leftCol,
            RightCol = rightCol
        }

        function tab:CreateGroupBox(gbConfig)
            gbConfig = gbConfig or {}
            local gbName = gbConfig.Name or "Group"
            local side = gbConfig.Side or "Left"
            local parentCol = (side == "Right") and rightCol or leftCol

            local gb = Create("Frame", {
                Name = gbName,
                Size = UDim2.new(1, -4, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Color3.fromRGB(24, 24, 34),
                BorderSizePixel = 0,
                Parent = parentCol
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = gb })
            Create("UIStroke", {
                Color = Color3.fromRGB(45, 45, 65),
                Thickness = 1,
                Parent = gb
            })
            Create("UIPadding", {
                PaddingTop = UDim.new(0, 32),
                PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                Parent = gb
            })

            local groupLabel = Create("TextLabel", {
                Name = "GroupLabel",
                Size = UDim2.new(1, -20, 0, 22),
                Position = UDim2.new(0, 10, 0, 6),
                BackgroundTransparency = 1,
                Text = gbName,
                TextColor3 = Color3.fromRGB(108, 84, 255),
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = gb
            })

            local labelUnderline = Create("Frame", {
                Size = UDim2.new(1, -20, 0, 1),
                Position = UDim2.new(0, 10, 0, 28),
                BackgroundColor3 = Color3.fromRGB(45, 45, 65),
                BorderSizePixel = 0,
                Parent = gb
            })

            local itemList = Create("Frame", {
                Name = "ItemList",
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent = gb
            })
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6),
                Parent = itemList
            })

            local groupbox = { ItemList = itemList }

            function groupbox:AddToggle(tConfig)
                tConfig = tConfig or {}
                local tName = tConfig.Name or "Toggle"
                local default = tConfig.Default or false
                local callback = tConfig.Callback or function() end

                local state = default

                local row = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Parent = itemList
                })

                Create("TextLabel", {
                    Size = UDim2.new(1, -48, 1, 0),
                    BackgroundTransparency = 1,
                    Text = tName,
                    TextColor3 = Color3.fromRGB(205, 205, 220),
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = row
                })

                local track = Create("Frame", {
                    Size = UDim2.new(0, 38, 0, 20),
                    Position = UDim2.new(1, -38, 0.5, -10),
                    BackgroundColor3 = state and Color3.fromRGB(108, 84, 255) or Color3.fromRGB(45, 45, 62),
                    BorderSizePixel = 0,
                    Parent = row
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })

                local knob = Create("Frame", {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Parent = track
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })
                Create("UIStroke", {
                    Color = Color3.fromRGB(200, 200, 220),
                    Thickness = 0.5,
                    Parent = knob
                })

                local tweenInfo = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                local hitbox = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = row
                })

                hitbox.MouseButton1Click:Connect(function()
                    state = not state
                    TweenService:Create(track, tweenInfo, {
                        BackgroundColor3 = state and Color3.fromRGB(108, 84, 255) or Color3.fromRGB(45, 45, 62)
                    }):Play()
                    TweenService:Create(knob, tweenInfo, {
                        Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                    }):Play()
                    callback(state)
                end)

                local element = {}
                function element:GetState() return state end
                function element:SetState(value)
                    state = value
                    TweenService:Create(track, tweenInfo, {
                        BackgroundColor3 = state and Color3.fromRGB(108, 84, 255) or Color3.fromRGB(45, 45, 62)
                    }):Play()
                    TweenService:Create(knob, tweenInfo, {
                        Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                    }):Play()
                    callback(state)
                end
                return element
            end

            function groupbox:AddButton(bConfig)
                bConfig = bConfig or {}
                local bName = bConfig.Name or "Button"
                local callback = bConfig.Callback or function() end

                local btn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(108, 84, 255),
                    BorderSizePixel = 0,
                    Text = bName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    Parent = itemList
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })

                local pressedColor = Color3.fromRGB(80, 60, 200)
                local normalColor = Color3.fromRGB(108, 84, 255)
                local hoverColor = Color3.fromRGB(125, 100, 255)
                local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad)

                btn.MouseEnter:Connect(function()
                    TweenService:Create(btn, tweenInfo, { BackgroundColor3 = hoverColor }):Play()
                end)
                btn.MouseLeave:Connect(function()
                    TweenService:Create(btn, tweenInfo, { BackgroundColor3 = normalColor }):Play()
                end)
                btn.MouseButton1Down:Connect(function()
                    TweenService:Create(btn, tweenInfo, { BackgroundColor3 = pressedColor }):Play()
                end)
                btn.MouseButton1Up:Connect(function()
                    TweenService:Create(btn, tweenInfo, { BackgroundColor3 = hoverColor }):Play()
                end)
                btn.MouseButton1Click:Connect(function()
                    callback()
                end)
            end

            return groupbox
        end

        table.insert(window.Tabs, tab)

        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs) do
                t.Content.Visible = false
                TweenService:Create(t.Button, TweenInfo.new(0.12), {
                    BackgroundColor3 = Color3.fromRGB(28, 28, 40),
                    TextColor3 = Color3.fromRGB(155, 155, 175)
                }):Play()
            end
            tabContent.Visible = true
            TweenService:Create(tabButton, TweenInfo.new(0.12), {
                BackgroundColor3 = Color3.fromRGB(108, 84, 255),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end)

        if #window.Tabs == 1 then
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Color3.fromRGB(108, 84, 255)
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        return tab
    end

    return window
end

return Law
