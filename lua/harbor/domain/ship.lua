---@class Ship
local Ship = {}

Ship.__index = Ship

---@param name string
---@param cursor_position? CursorPosition
---@param current_list? PossibleList
---@return Ship
function Ship:new(name, cursor_position, current_list)
    if cursor_position and (cursor_position.row == 0) then cursor_position.row = 1 end
    local ship = setmetatable({
        value = name,
        position = cursor_position or { col = 0, row = 1 },
        current_list = current_list
    }, self)
    return ship
end

---@return string
function Ship:format_name()
    return self.value:match("([^/]+)$")
end

---@return integer
function Ship:get_buf()
    local buf = vim.fn.bufnr(self.value)

    if buf == -1 then
        buf = vim.fn.bufadd(self.value)
        vim.fn.bufload(buf)
    end

    return buf
end

function Ship:update_cursor()
    local row, col = unpack(vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win()))

    self.position.row = row
    self.position.col = col
end

return Ship
