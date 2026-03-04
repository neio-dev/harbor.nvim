local utils = require "harbor.utils"
---@class TestBufferAdapter: BufferAdapter
local M = {}

M.buffers = {}
M.loaded_buffers = {}
M.current_buf = 5

M.get_nbr = function(buf_value)
    return utils.table.get_index(M.buffers, buf_value) or -1
end

M.add = function(buf_value)
    table.insert(M.buffers, buf_value)

    return #M.buffers
end

M.load = function(buf_nbr)
    table.insert(M.loaded_buffers, buf_nbr)
end

M.is_loaded = function(buf_nbr)
    return utils.table.contains(M.loaded_buffers, buf_nbr) and 1 or 0
end

M.get_current = function()
    return M.current_buf
end

M.set_current = function(buf_nbr)
    M.current_buf = buf_nbr
end

M.get_name = function(buf_nbr)
    return M.buffers[buf_nbr]
end

return M
