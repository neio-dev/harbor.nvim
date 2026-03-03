---@class WindowAdapter
local M = {}

---@param win any
---@return unknown
M.get_cursor = function(win)
    return vim.api.nvim_win_get_cursor(win)
end

M.get_current = function()
    return vim.api.nvim_get_current_win()
end

return M
