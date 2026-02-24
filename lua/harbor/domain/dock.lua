local Fleet = require("harbor.domain.fleet")

---@class Dock: Fleet
---@field bay Bay
---@field harbor Harbor
local Dock = setmetatable({}, { __index = Fleet })
Dock.__index = Dock

---@param harbor any
---@return Dock
function Dock:new(harbor)
    ---@class Dock
    local instance = Fleet.new(
        self,
        harbor,
        "dock",
        harbor.config.opts.dock.length or 4,
        RESOLVE.replace
    )

    return instance
end

---@param _ship Ship
---@param index? number
function Dock:set(_ship, index)
    local fleet = Fleet.set(self, _ship, index)
    if fleet.ship == nil or fleet.ship == EMPTY then return end
    index = self:get_ship_index(fleet.ship and fleet.ship.value or nil)
    vim.notify("Ship [" .. fleet.ship:format_name() .. "] docked to slot #" .. index)

    local bay = self.harbor.bay
    if bay ~= nil and fleet.ship ~= nil then
        local bay_ship_index = bay:get_ship_index(fleet.ship.value)
        if bay_ship_index ~= nil then
            bay:remove(bay_ship_index)
        end

        if fleet.previous_ship ~= nil and fleet.previous_ship ~= EMPTY then
            bay:set(fleet.previous_ship)
        end
    end
end

---@param index number
function Dock:show(index)
    self.harbor.bay:close_split()
    Fleet.show(self, index)
end

---@param target string|number|Ship
function Dock:remove(target)
    local remove_data = Fleet.remove(self, target)
    local bay = self.harbor.bay
    vim.notify("Ship [" .. remove_data.previous_ship:format_name() .. "] removed from slot #" .. remove_data.index)

    if bay ~= nil and remove_data.previous_ship ~= nil then
        bay:set(remove_data.previous_ship)
    end
end

return Dock
