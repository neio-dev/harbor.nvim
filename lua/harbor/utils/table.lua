local M = {}

---@param ... table
---@return table
M.merge = function(...)
    local res = {}

    for _, table in ipairs({ ... }) do
        for k, v in pairs(table) do
            res[k] = v
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
