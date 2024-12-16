require 'objects/list'
require 'objects/color'
require 'objects/button'

Fonts = {}
Images = {}

-- list of bullets that are still visable
Bullets = List:new()

function love.load()
    -- anim8 = require 'libs.anim8'
    love.window.setTitle("Iron Sight")
    Width, Height, _ = love.window.getMode()

    local bg_color = Color:new(33, 33, 33, 255)
    love.graphics.setBackgroundColor(bg_color:unpack())

    Fonts.regular = love.graphics.newFont("resources/fonts/pixel-times.ttf", 38)
    Fonts.bold = love.graphics.newFont("resources/fonts/pixel-times-bold.ttf", 55)
    Fonts.regular:setFilter("nearest", "nearest")

    Images.cowboy = love.graphics.newImage("resources/textures/cowboy.png")
    Images.cowboy:setFilter("nearest", "nearest")
    Arm = { x = 125, y = Height - 170, angle = 0, dx = 0, dy = 0}

    Images.arm = love.graphics.newImage("resources/textures/arm.png")
    Images.arm:setFilter("nearest", "nearest")

    Images.button = love.graphics.newImage("resources/textures/button.png")
    Images.button:setFilter("nearest", "nearest")

    local button_scale = 4
    local button_width = Images.button:getWidth() * button_scale

    Play_Button = Button:new(Width / 2 - (button_width / 2), 210, button_scale)
    Quit_Button = Button:new(Width / 2 - (button_width / 2), 320, button_scale)

    love.graphics.setFont(Fonts.regular)
    love.graphics.setDefaultFilter("nearest", "nearest")


    BG_Music = love.audio.newSource("resources/sounds/desert-snake.wav", "stream")
    BG_Music:setVolume(0.5)
end

local to_remove = List:new()
function love.draw()
    love.graphics.printf("Iron Sight", Fonts.bold, 0, 100, Width, "center")


    Play_Button:draw("Play")

    love.graphics.setColor(Color:new(255, 85, 85):unpack())
    Quit_Button:draw("Quit")


    love.graphics.push()
    love.graphics.translate(Arm.x + 4, Arm.y + 23)
    love.graphics.rotate(Arm.angle)
    love.graphics.translate(-(Arm.x + 4), -(Arm.y + 23))
    love.graphics.draw(Images.arm, Arm.x, Arm.y, 0, 5.5, 5.5)
    love.graphics.pop()

    love.graphics.draw(Images.cowboy, 15, Height - 222, 0, 5.5, 5.5)

    if Bullets:len() > 0 then
        -- todo: look how to make it so i dont have to do bullets.data
        for i, bullet in ipairs(Bullets.data) do
            love.graphics.setColor(Color:new(193, 108, 91):unpack())
            love.graphics.rectangle("fill", bullet.x, bullet.y, 10, 5)
            love.graphics.setColor(255, 255, 255)

            -- we have the hypotenuse (how far we want to travel) with bullet.speed
            -- we also have theta, the angle and we need to solve for the x and y components
            -- x = hypotenuse * cos(theta)
            -- y = hypotenuse * sin(theta)
            bullet.x = bullet.x + (bullet.speed * math.cos(bullet.angle))
            bullet.y = bullet.y + (bullet.speed * math.sin(bullet.angle))

            if bullet.x > Width or bullet.y > Height then
                to_remove:append(i)
            end
        end

        if to_remove:len() > 0 then
            for _, index in ipairs(to_remove.data) do
                Bullets:remove(index)
            end
            to_remove:clear()
        end
    end

end


function love.update()
    local mx, my = love.mouse.getPosition()
    local dx, dy = mx - Arm.x, my - Arm.y
    Arm.angle = math.max(-1.57075, math.min(1.57075, math.atan2(dy, dx)))

    if not BG_Music:isPlaying() then
		love.audio.play(BG_Music)
	end
    
end


function love.mousepressed(mx, my, btn, touch)
    if btn == 1 then
        local bullet_speed = 7
        local dx, dy = mx - Arm.x, my - Arm.y
        local shot_angle = math.max(-1.57075, math.min(1.57075, math.atan2(dy, dx)))
        local angle = shot_angle - .19

        local distance_to_gun = 78
        -- todo: add sounds later
        local bullet_x = (Arm.x + 4) + (distance_to_gun * math.cos(angle))
        local bullet_y = (Arm.y + 23) + (distance_to_gun * math.sin(angle))
        Bullets:append({x = bullet_x, y = bullet_y, angle = shot_angle, speed = bullet_speed})
	end
end

