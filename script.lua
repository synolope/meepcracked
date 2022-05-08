
local Window = library:AddWindow("Preview", {
    main_color = Color3.fromRGB(41, 74, 122),
    min_size = Vector2.new(500, 600),
    toggle_key = Enum.KeyCode.RightShift,
    can_resize = true,
})
local Tab = Window:AddTab("Tab 1")