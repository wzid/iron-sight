local anim8 = require 'libs.anim8'
require 'objects.list'

local bullet_speed = 2000
local bird_speed = 800
local bird_fall_speed = 490

Game = {
    focused = false,
    bullets = List:new(),
    remove_bullets = List:new(),
    arm = { x = 0, y = 0, angle = 0 },
    birds = List:new(),
    remove_birds = List:new(),
    score = 0,
    show_bird_time = love.timer.getTime(),
}
Game.__index = Game

local bird_grid

function Game.load()
    Game.arm = { x = 125, y = Height - 170, angle = 0 }
    bird_grid = anim8.newGrid(25, 24, Images.bird:getWidth(), Images.bird:getHeight())
end


function Game.draw()
    love.graphics.push()
    love.graphics.translate(Game.arm.x + 4, Game.arm.y + 23)
    love.graphics.rotate(Game.arm.angle)
    love.graphics.translate(-(Game.arm.x + 4), -(Game.arm.y + 23))
    love.graphics.draw(Images.arm, Game.arm.x, Game.arm.y, 0, 5.5, 5.5)
    love.graphics.pop()

    love.graphics.draw(Images.cowboy, 15, Height - 222, 0, 5.5, 5.5)

    if Game.bullets:len() > 0 then
        for _, bullet in Game.bullets:iterate() do
            love.graphics.setColor(Color:new(193, 108, 91):unpack())
            love.graphics.rectangle("fill", bullet.x, bullet.y, 10, 5)
            love.graphics.setColor(255, 255, 255)
        end
    end

    -- actual game
    if not Game.focused then return end

    love.graphics.print("Score: " .. Game.score, 10, 10)

    for _, bird in Game.birds:iterate() do
        bird.animate:draw(Images.bird, bird.x, bird.y, 0, 5, 5)
    end
end

function Game.update(dt)
    local mx, my = love.mouse.getPosition()
    local dx, dy = mx - Game.arm.x, my - Game.arm.y
    Game.arm.angle = math.max(-1.57075, math.min(1.57075, math.atan2(dy, dx)))

    if not Music.bg:isPlaying() then
        love.audio.play(Music.bg)
    end

    -- Update bullets
    if Game.bullets:len() > 0 then
        for i, bullet in Game.bullets:iterate() do
            -- Update bullet position based on its speed and angle
            bullet.x = bullet.x + (bullet.speed * math.cos(bullet.angle)) * dt
            bullet.y = bullet.y + (bullet.speed * math.sin(bullet.angle)) * dt

            -- Check if bullet is off-screen and mark for removal
            if bullet.x > Width or bullet.y > Height or bullet.x < 0 or bullet.y < 0 then
                Game.remove_bullets:append(i)
            end
        end

        -- Remove bullets marked for deletion
        if Game.remove_bullets:len() > 0 then
            for _, index in Game.remove_bullets:iterate() do
                Game.bullets:remove(index)
            end
            Game.remove_bullets:clear()
        end
    end

    if not Game.focused then return end

    -- Bird spawn logic
    if love.timer.getTime() > Game.show_bird_time then
        local bird_x = Width + 10
        local bird_y = math.random(Height / 2)
        local bird_speed_addon = math.random(0, 200)
        Game.birds:append({ x = bird_x, y = bird_y, speed = bird_speed + bird_speed_addon, shot = false, animate = anim8.newAnimation(bird_grid('1-10', 1), 0.1) })
        Game.show_bird_time = love.timer.getTime() + math.random(0, 2)
    end

    for _, bird in Game.birds:iterate() do
        bird.animate:update(dt)
    end

    -- Bird movement logic
    for i, bird in Game.birds:iterate() do
        if bird.shot then
            bird.y = bird.y + bird_fall_speed * dt
        else
            bird.x = bird.x - bird.speed * dt
        end

        if bird.x < -100 or bird.y > Height + 100 then
            Game.remove_birds:append(i)
        end

        if Game.bullets:len() > 0 then
            for bullet_i, bullet in Game.bullets:iterate() do
                if bullet.x < bird.x + 25 * 5 and bullet.x > bird.x and bullet.y < bird.y + 24 * 5 and bullet.y > bird.y then
                    bird.animate = anim8.newAnimation(bird_grid('11-13', 1), .1, "pauseAtEnd")
                    bird.shot = true
                    Game.score = Game.score + 1
                    Game.remove_bullets:append(bullet_i)
                end
            end
        end
    end

    -- Remove birds marked for deletion
    if Game.remove_birds:len() > 0 then
        for _, index in Game.remove_birds:iterate() do
            Game.birds:remove(index)
        end
        Game.remove_birds:clear()
    end

end

function Game.mousepressed(mx, my, btn, touch)
    if btn == 1 then
        local dx, dy = mx - Game.arm.x, my - Game.arm.y
        local shot_angle = math.max(-1.57075, math.min(1.57075, math.atan2(dy, dx)))
        local angle = shot_angle - .19

        local distance_to_gun = 78
        love.audio.play(Music.shoot)

        local bullet_x = (Game.arm.x + 4) + (distance_to_gun * math.cos(angle))
        local bullet_y = (Game.arm.y + 23) + (distance_to_gun * math.sin(angle))
        Game.bullets:append({ x = bullet_x, y = bullet_y, angle = shot_angle, speed = bullet_speed })
    end
end