require 'game'
require 'menu'
require 'libs.sound'
require 'objects.list'
require 'objects.color'
require 'objects.button'
require 'resources'

function love.load()
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
