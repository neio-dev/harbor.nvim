local Ship = require("harbor.domain.ship")
local Commands = {}

---@alias CommandDef [string, fun(): nil, { desc: string }]

---@param harbor Harbor
---@return CommandDef[]
local function get_commands(harbor)
    return {
        {
            "HrbSessionPath",
            function()
                print(harbor.sessions:get_session_path())
            end,
            { desc = "Print current session path" },
        },
        {
            "HrbLighthouse",
            function()
                harbor.lighthouse:input()
            end,
            { desc = "Show Lighthouse prompt" },
        },
        {
            "HrbClear",
            function()
                harbor.fleets.dock:remove(1)
                harbor.fleets.dock:remove(2)
                harbor.fleets.dock:remove(3)
                harbor.fleets.dock:remove(4)
                harbor.fleets.bay:remove(1)
                harbor.fleets.bay:remove(2)
                harbor.fleets.bay:remove(3)
            end,
            { desc = "Show Lighthouse prompt" },
        },

        {
            "HrbDock",
            function()
                local to_print = ""
                for i, v in ipairs(harbor.fleets.dock:get()) do
                    local val = v.value ~= nil and v.value or "empty"
                    to_print = to_print .. val .. ", "
                end
                print("Dock", "[", to_print, "]")
            end,
            { desc = "Get dock list" }
        },
        {
            "HrbDev",
            function()
                local path = "/home/dev/.config/nvim/lua/harbor"
                harbor.fleets.dock.ships = { EMPTY, EMPTY, EMPTY, EMPTY }
                harbor.fleets.bay.ships = { EMPTY, EMPTY, EMPTY }
                harbor.fleets.dock:set(Ship:new(path .. "/harbor.lua"))
                harbor.fleets.dock:set(Ship:new(path .. "/fleet.lua"))
                harbor.fleets.dock:set(Ship:new(path .. "/notes.md"))
                harbor.fleets.dock:set(Ship:new(path .. "/types.lua"))
                harbor.fleets.bay:set(Ship:new(path .. "/dock.lua"))
                harbor.fleets.bay:set(Ship:new(path .. "/bay.lua"))
                harbor.fleets.bay:set(Ship:new(path .. "/sessions.lua"))
            end,
            { desc = "Load test harbor session" }
        },
        {
            "HrbCurrentList",
            function()
                print(harbor:get_current_list())
            end,
            { desc = "Print current list" }

        },
        {
            "HrbLoad",
            function()
                harbor.sessions:load()
            end,
            { desc = "Load harbor sessions" }
        },
        {
            "HrbSave",
            function()
                harbor.sessions:save()
            end,
            { desc = "Save harbor sessions" }
        },
        {
            "HrbAdd",
            function()
                harbor.fleets.dock:set()
                local to_print = ""
                for i, v in ipairs(harbor.fleets.dock:get()) do
                    local val = v.value ~= nil and v.value or "empty"
                    to_print = to_print .. val .. ", "
                end
                print("Dock", "[", to_print, "]")
            end,
            { desc = "Add current buffer to dock" }
        },
        {
            "HrbRemove",
            function(opt)
                harbor.fleets.dock:remove(opt.args and tonumber(opt.args) or nil)
                local to_print = ""
                for i, v in ipairs(harbor.fleets.dock:get()) do
                    local val = v.value ~= nil and v.value or "empty"
                    to_print = to_print .. val .. ", "
                end
                print("Dock", "[", to_print, "]")
            end,
            { desc = "Remove current buffer to dock", nargs = 1 }
        }, {
        "HrbShow",
        function(opt)
            harbor.fleets.bay:show(opt.args)
        end,
        { desc = "Show docked ship", nargs = 1 }
    },
    }
end

---@param command CommandDef
local function create_command(command)
    local name, callback, opts = unpack(command)
    vim.api.nvim_create_user_command(name, callback, opts)
end


---@param harbor Harbor
function Commands:init(harbor)
    for _, value in ipairs(get_commands(harbor)) do
        create_command(value)
    end
end

return Commands
