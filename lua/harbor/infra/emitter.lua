---@class Emitter
---@field event_bus table
local M = {
}

M.event_bus = {}

---@enum Events
local EVENTS = {
    FLEET_ADD = "FLEET_ADD",
    FLEET_REMOVE = "FLEET_REMOVE",
    FLEET_SET = "FLEET_SET",
    SETUP = "SETUP",
}

---@param event Events
---@param cb fun(): nil
M.on = function(event, cb)
    if not M.event_bus[event] then M.event_bus[event] = {} end

    table.insert(
        M.event_bus[event],
        cb
    )
end

---@param event Events
---@param ... any
M.emit = function(event, ...)
    if not M.event_bus[event] then return end

    for _, eachCallback in ipairs(M.event_bus[event]) do
        eachCallback(...)
    end
end

return M
