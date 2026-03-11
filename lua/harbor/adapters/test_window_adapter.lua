---@class TestWindowAdapter: WindowAdapter
local M = {}

---@param win any
---@return unknown
M.get_cursor = function(win)
    return { 25, 25 }
end

M.get_current = function()
    return 2
end

M.set_current = function(win)
end

M.list = function()
    return { 2, 5, 4 }
end

M.get_buf = function(win)
    return 2
end

M.set_cursor = function(win, position)
end

return M
