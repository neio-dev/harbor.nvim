local utils = require "harbor.utils"
local buffer_adapter = require "harbor.adapters.buffer_adapter"
local window_adapter = require "harbor.adapters.window_adapter"

---@class Ship
local Ship = {}

Ship.__index = Ship
Ship.buffer_adapter = buffer_adapter
Ship.win_adapter = window_adapter

---@param name string
---@param cursor_position? CursorPosition
---@param current_list? PossibleList
---@return Ship
function Ship:new(name, cursor_position, current_list)
    if not name then
        utils.error("name is required", ERROR_TYPES.ShipError)
    end

    if cursor_position and (cursor_position.row == 0) then cursor_position.row = 1 end

    local ship = setmetatable({
        value = name,
        open_once = false,
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
    local buf = self.buffer_adapter.get_nbr(self.value)

    if buf == -1 then
        buf = self.buffer_adapter.add(self.value)
        self.buffer_adapter.load(buf)
    end

    return buf
end

function Ship:save_cursor()
    local row, col = unpack(self.win_adapter.get_cursor(
        self.win_adapter.get_current()
    ))
    self.position.row = row
    self.position.col = col
end

return Ship
