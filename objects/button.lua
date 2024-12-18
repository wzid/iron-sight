---@class Button
Button = { x = 0, y = 0, scale = 0, width = 0, height = 0, on_click = nil }
Button.__index = Button

-- todo: add lambda functionality for an action when the button is pressed
-- not sure how to do that in lua rn

--- Creates a new instance of the Button class and returns it
---@param x number
---@param y number
---@param scale number
---@return Button
function Button:new(x, y, scale, on_click_action)
    local button = { x = x, y = y, scale = scale, on_click = on_click_action }
    setmetatable(button, self)

    button.width = Images.button:getWidth() * scale
    button.height = Images.button:getHeight() * scale
    return button
end

---Draws the button at specified location with scale
---@param text string
function Button:draw(text)
    love.graphics.draw(Images.button, self.x, self.y, 0, self.scale, self.scale)

    local custom_text = love.graphics.newText(Fonts.regular_lg, text)
    local text_width = custom_text:getWidth()
    local text_height = custom_text:getHeight()

    love.graphics.setColor(0, 0, 0)
    love.graphics.draw(custom_text, self.x + (self.width / 2) - (text_width / 2),
        self.y + (self.height / 2) - (text_height / 2), 0)
    love.graphics.setColor(255, 255, 255)
end

---Given x and y coordinates check if they are inside the button
---@param mx number
---@param my number
---@return boolean
function Button:is_inside(mx, my)
    return mx < self.x + self.width and mx > self.x and my < self.y + self.height and my > self.y
end

---When the mouse is pressed check if the button is clicked
---@param mx number
---@param my number
---@param btn number
---@param touch any not sure what this is
function Button:on_mousepressed(mx, my, btn, touch)
    if btn == 1 and self:is_inside(mx, my) then
        if self.on_click then self.on_click() end
    end
end
