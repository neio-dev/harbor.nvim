---@class BufferAdapter
local M = {}

M.get_nbr = function(buf_value)
    return vim.fn.bufnr(buf_value)
end

M.add = function(buf_value)
    return vim.fn.bufadd(buf_value)
end

M.load = function(buf_nbr)
    return vim.fn.bufload(buf_nbr)
end

M.get_current = function()
    return vim.api.nvim_get_current_buf()
end

M.set_current = function(buf_nbr)
    vim.api.nvim_set_current_buf(buf_nbr)
end

M.get_name = function(buf_nbr)
    return vim.api.nvim_buf_get_name(buf_nbr)
end

return M
