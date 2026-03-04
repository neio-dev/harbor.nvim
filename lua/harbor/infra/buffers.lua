local buffer_adapter = require "harbor.adapters.buffer_adapter"
local window_adapter = require "harbor.adapters.window_adapter"

local buffer = {}
buffer.adapter = buffer_adapter
buffer.win_adapter = window_adapter

---@class BufData
---@field name string
---@field number number
---@field type string
---@field buf number
---@field cursor CursorPosition

---@return BufData
function buffer:get_current()
    local buf = buffer.adapter.get_current()
    local name = buffer.adapter.get_name(buf)

    return self:get(name)
end

---@param name string
---@return BufData
function buffer:get(name)
    local buf = vim.fn.bufnr(name)
    local type = vim.uv.fs_stat(name) ~= nil and vim.uv.fs_stat(name).type or nil
    local row,col = unpack(buffer.win_adapter.get_cursor(0))

    return {
        name = name,
        type = type,
        buf = buf,
        number = buf,
        cursor = { row=row, col=col }
    }
end

return buffer
