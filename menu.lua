MainMenu = { focused = true }
MainMenu.__index = MainMenu



function MainMenu.load()
    local button_scale = 4
    local button_width = Images.button:getWidth() * button_scale

    Play_Button = Button:new(Width / 2 - (button_width / 2), 210, button_scale, function()
        MainMenu.focused = false
        Game.focused = true
    end)
    Quit_Button = Button:new(Width / 2 - (button_width / 2), 320, button_scale, function ()
        love.event.quit()
    end)
end

function MainMenu.draw()
    if not MainMenu.focused then return end
    love.graphics.printf("Iron Sight", Fonts.bold, 0, 100, Width, "center")

    Play_Button:draw("Play")
    love.graphics.setColor(Color:new(255, 85, 85):unpack())
    Quit_Button:draw("Quit")
end

function MainMenu.on_mousepressed(mx, my, btn, touch)
    if MainMenu.focused then
        Play_Button:on_mousepressed(mx, my, btn, touch)
        Quit_Button:on_mousepressed(mx, my, btn, touch)
    end
end
