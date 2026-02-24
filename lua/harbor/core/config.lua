local utils = require("harbor.utils")
local Config = {}
Config.__index = Config

---@class ConfigOpts
---@field bay { length: number, history: number }
---@field dock { length: number }

function Config:new()
    local instance = setmetatable({
    }, self)

    instance.opts = {
        bay = {
            length = 2,
            history = 5,
        },
        dock = {
            length = 4,
        },
    }

    return instance
end

---@param partial_config ConfigOpts
function Config:load(partial_config)
    if partial_config.bay ~= nil then
        self.opts.bay = utils.table.merge(self.opts.bay, partial_config.bay)
    end

    if partial_config.dock ~= nil then
        self.opts.dock = utils.table.merge(self.opts.dock, partial_config.dock)
    end
end

return Config
