require 'game'
require 'menu'
require 'libs.sound'
require 'objects.list'
require 'objects.color'
require 'objects.button'
require 'resources'

function love.load()
    love.mouse.setVisible(false)

    math.randomseed(os.time())
    -- anim8 = require 'libs.anim8'
    love.window.setTitle("Iron Sight")
    Width, Height, _ = love.window.getMode()

    local bg_color = Color:new(33, 33, 33, 255)
    love.graphics.setBackgroundColor(bg_color:unpack())

    Load_Resources()
    MainMenu.load()
    Game.load()
end

function love.draw()
    -- only draws the main menu if it is focused
    love.graphics.draw(Images.cursor, love.mouse.getX() - Images.cursor:getWidth() / 2, 
        love.mouse.getY() - Images.cursor:getHeight() / 2)

    MainMenu.draw()
    Game.draw()
end

function love.update(dt)
    Game.update(dt)
end

function love.mousepressed(mx, my, btn, touch)
    MainMenu.on_mousepressed(mx, my, btn, touch)
    Game.mousepressed(mx, my, btn, touch)
end
