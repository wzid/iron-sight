Fonts = {}
Images = {}
Music = {}

function Load_Resources()
    local tex = "resources/textures/"
    Images.arm = love.graphics.newImage(tex .. "arm.png")
    Images.cowboy = love.graphics.newImage(tex .."cowboy.png")
    Images.button = love.graphics.newImage(tex .. "button.png")
    Images.bird = love.graphics.newImage(tex .. "birds.png")
    Images.cursor = love.graphics.newImage(tex .. "cursor.png")

    for _, image in pairs(Images) do image:setFilter("nearest", "nearest") end

    Fonts.regular = love.graphics.newFont("resources/fonts/pixel-times.ttf", 28)
    Fonts.regular_lg = love.graphics.newFont("resources/fonts/pixel-times.ttf", 38)
    Fonts.bold = love.graphics.newFont("resources/fonts/pixel-times-bold.ttf", 55)

    for _, font in pairs(Fonts) do font:setFilter("nearest", "nearest") end

    Music.bg = love.audio.newSource("resources/sounds/desert-snake.wav", "stream")
    Music.bg:setLooping(true)
    Music.bg:setVolume(0.4)
    love.audio.play(Music.bg)

    Music.shoot = love.audio.newSource("resources/sounds/shoot.wav", "static")
    Music.shoot:setVolume(0.5)

    love.graphics.setFont(Fonts.regular)
    love.graphics.setDefaultFilter("nearest", "nearest")
end
