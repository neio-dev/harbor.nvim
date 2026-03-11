local M = {}

---@param tbl table
---@return table
M.shallow_copy = function(tbl)
    local res = {}

    for key, value in pairs(tbl) do
        if type(value) == "table" then
            res[key] = M.shallow_copy(value)
        else
            res[key] = value
        end
    end

    return res
end

---@param initial table
---@param to_merge table
---@return table
M.merge = function(initial, to_merge)
    local res = M.shallow_copy(initial)

    for key, value in pairs(to_merge) do
        if type(res[key]) == "table" and type(value) == "table" then
            res[key] = M.merge(res[key], value)
        else
            res[key] = value
        end
    end

    return res
end

---@param haystack {}
---@param needle any
---@return boolean
M.contains = function(haystack, needle)
    for _, iteratedValue in ipairs(haystack) do
        if needle == iteratedValue then
            return true
        end
    end

    return false
end

---@param haystack {}
---@param needle any
---@return integer?
M.get_index = function(haystack, needle)
    for index, iteratedValue in ipairs(haystack) do
        if needle == iteratedValue then
            return index
        end
    end

    return nil
end

return M
