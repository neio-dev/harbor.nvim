local Dock = require("harbor.domain.dock")
local Bay = require("harbor.domain.bay")
local Ship = require("harbor.domain.ship")
local emitter = require("harbor.infra.emitter")
local SessionManager = require("harbor.infra.sessions")
local Commands = require("harbor.core.commands")
local Config = require("harbor.core.config")
local Extensions = require("harbor.extensions")
local Lighthouse = require("harbor.core.lighthouse")
local buffer = require("harbor.infra.buffers")
local utils = require("harbor.utils")

require("harbor.types")

---@class Harbor
local Harbor = {}
Harbor.__index = Harbor
Harbor.emitter = emitter
---@return Harbor
function Harbor:new()
    ---@class Harbor
    local instance = setmetatable({
        active_ship = nil,
        fleets = {},
    }, self)

    instance.config = Config:new()

    return instance
end

function Harbor:set_default_keybinds()
    -- add current buf to next available dock index or input for replace
    vim.keymap.set("n", "<leader>a", function() self.fleets.dock:set() end)
    --dev testing
    vim.keymap.set("n", "<leader>hd", function() vim.cmd("HrbDev") end)
    --cycle bay to the right
    vim.keymap.set("n", "<C-h>", function() self.fleets.bay:cycle(false) end)
    --cycle bay to the left
    vim.keymap.set("n", "<C-j>", function() self.fleets.bay:cycle(true) end)
    vim.keymap.set("n", "<C-t>", function() self.lighthouse:input() end)
    --remove current ship from current list
    vim.keymap.set("n", "<leader><leader>x", function() self:get_current_list():remove() end)

    vim.keymap.set("n", "<C-n>", function() self.fleets.dock:show(1) end)
    vim.keymap.set("n", "<C-e>", function() self.fleets.dock:show(2) end)
    vim.keymap.set("n", "<C-i>", function() self.fleets.dock:show(3) end)
    vim.keymap.set("n", "<C-o>", function() self.fleets.dock:show(4) end)
    vim.keymap.set("n", "<leader><C-n>", function() self.fleets.bay:show(1) end)
    vim.keymap.set("n", "<leader><C-e>", function() self.fleets.bay:show(2) end)
    vim.keymap.set("n", "<leader><C-i>", function() self.fleets.bay:show(3) end)
end

function Harbor:set_autocommands()
    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
            local curr_buf = buffer:get_current()
            if curr_buf.type ~= "file" then
                return
            end

            local main_list = self.fleets.dock
            local temp_list = self.fleets.bay
            local main_index = main_list:get_ship_index(curr_buf.name)
            local temp_index = temp_list:get_ship_index(curr_buf.name)

            if main_index ~= nil or (temp_index ~= nil and temp_index <= temp_list.length) then
                return
            end

            temp_list:set(Ship:new(curr_buf.name))
        end
    })
end

---@return Dock|Bay|nil
function Harbor:get_current_list()
    if self.active_ship == nil then return nil end

    return self.fleets[self.active_ship.current_list]
end

function Harbor:set_hl_groups()
end

---@param partial_config ConfigOpts
function Harbor:setup(partial_config)
    self.config:load(partial_config)
    self:attach_fleet(Bay:new(self))
    self:attach_fleet(Dock:new(self))
    self.extensions = Extensions(self)
    self.sessions = SessionManager:new(self)
    self.lighthouse = Lighthouse:new(self)

    emitter.emit("SETUP", self.config.opts)
    self:set_autocommands()
    Commands:init(self)
    self:set_hl_groups()
    self.sessions:load()
end

---@param fleet Fleet
function Harbor:attach_fleet(fleet)
    if self.fleets[fleet.name] then
        utils.error("Fleet name is already in use")
        return
    end

    self.fleets[fleet.name] = fleet
end

return Harbor
