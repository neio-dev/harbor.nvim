---@class WindowAdapter
local M = {}

---@param win number
---@return [number, number]
M.get_cursor = function(win)
    return vim.api.nvim_win_get_cursor(win)
end

---@return number
M.get_current = function()
    return vim.api.nvim_get_current_win()
end

---@param win number
M.set_current = function(win)
    vim.api.nvim_set_current_win(win)
end

---@return number[]
M.list = function()
    return vim.api.nvim_list_wins()
end

---@param win number
---@return number
M.get_buf = function(win)
    return vim.api.nvim_win_get_buf(win)
end

---@param win number
---@param position CursorPosition
M.set_cursor = function(win, position)
    vim.api.nvim_win_set_cursor(win, { position.row, position.col })
end

return M
