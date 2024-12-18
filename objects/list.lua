---@class List
List = { data = {} }
List.__index = List

---Creates a new instance of the List class and returns it
---@return List
function List:new()
    local list = { data = {} }
    setmetatable(list, self)
    return list
end

---Appends a value to the end of the list
---@param value any
function List:append(value)
    table.insert(self.data, value)
end

---Insert an item at a specific index
---@param i number
---@param value any
function List:insert(i, value)
    if i < 1 or i > #self.data + 1 then
        error("Index out of bounds")
    end
    table.insert(self.data, i, value)
end

---Returns the value at index i
---@param i number
---@return any
function List:get(i)
    if i < 1 or i > #self.data then
        error("Index out of bounds")
    end
    return self.data[i]
end

---Removes an element a specified index
---@param i number
function List:remove(i)
    if i < 1 or i > #self.data then
        error("Index out of bounds")
    end
    return table.remove(self.data, i)
end

---Set an item at a specific index
---@param i number
---@param value any
function List:set(i, value)
    if i < 1 or i > #self.data then
        error("Index out of bounds")
    end
    self.data[i] = value
end

---Clears the list from all elements
function List:clear()
    self.data = {}
end

---@return integer length
function List:len()
    return #self.data
end

---Check if the list is empty
---@return boolean
function List:is_empty()
    return #self.data == 0
end

---Returns an iterator for the list
---@return function
function List:iterate()
    local i = 0
    return function()
        i = i + 1
        if i <= #self.data then
            return i, self.data[i]
        end
    end
end
