---@class List
List = {__len = 0, data = {}}

---Creates a new instance of the List class and returns it
---@return List
function List:new()
    local list = {}
    setmetatable(list, self)
    self.__index = self

    list.__len = 0
    list.data = {}

    return list
end

---Appends a value to the end of the list
---@param v any
function List:append(v)
    -- lua is one indexed
    self.data[self.__len + 1] = v
    self.__len = self.__len + 1
end


---Returns the value at index i
---@param i number
---@return any
function List:get(i)
    if i > self.__len or i < 1 then
        error("index out of bounds - List:get")
    end
    return self.data[i]
end

-- 

---Removes an element a specified index
---
---O(n) operation because we have to move everything down the list
---@param index number
function List:remove(index)
    if index > self.__len then
        error("index out of bounds - List:remove")
    end
    
    for i = index + 1, self.__len do
        self.data[i-1] = self.data[i]
    end

    -- remove the last element
    table.remove(self.data, self.__len)
    self.__len = self.__len - 1
end

---Prints the length of the list along with every elemtn
function List:print_list()
    print('len:', self.__len)
    for i = 1, self.__len do
        print(self.data[i])
    end
end

---Clears the list from all elements
---
---O(N) operation
function List:clear()
    while self.__len > 0 do
        table.remove(self.data, self.__len)
        self.__len = self.__len - 1
    end
end

---@return integer length
function List:len()
    return self.__len
end