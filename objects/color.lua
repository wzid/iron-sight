---@class Color rgb color class for converting values to float values
Color = {r = 0, g = 0, b = 0, a = 255}
Color.__index = Color

--- Creates a new instance of the Color class and returns it
---@param r number red: 0 - 255
---@param g number green: 0 - 255
---@param b number blue: 0 - 255
---@param a? number alpha: 0 - 255
---@return Color
function Color:new(r, g, b, a)
    local color = {}
    setmetatable(color, self)

    color.r = r
    color.g = g
    color.b = b
    color.a = a or 255
    return color
end

--- Returns 4 values representing the red, green, blue, and alpha
function Color:unpack()
    return self.r / 255, self.g / 255, self.b / 255, self.a / 255
end