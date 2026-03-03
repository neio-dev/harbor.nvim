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

return M
