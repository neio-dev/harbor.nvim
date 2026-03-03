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

return M
