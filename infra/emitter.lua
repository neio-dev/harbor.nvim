---@class Emitter
---@field event_bus table
local M = {
}

M.__index = M

---@return Emitter
function M:new()
    local instance = setmetatable({}, self)
    instance.event_bus = {}

    return instance
end

---@enum Events
local EVENTS = {
    FLEET_ADD = "FLEET_ADD",
    FLEET_REMOVE = "FLEET_REMOVE",
    FLEET_SET = "FLEET_SET",
    SETUP = "SETUP",
}

---@param event Events
---@param cb fun(): nil
function M:on(event, cb)
    if not self.event_bus[event] then self.event_bus[event] = {} end

    table.insert(
        self.event_bus[event],
        cb
    )
end

---@param event Events
---@param ... any
function M:emit(event, ...)
    if not self.event_bus[event] then return end

    for _, eachCallback in ipairs(self.event_bus[event]) do
        eachCallback(...)
    end
end

return M
