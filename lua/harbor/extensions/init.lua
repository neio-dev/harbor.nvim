local utils = require("harbor.utils")
local telescope_extension = require("harbor.extensions.builtins.telescope")

---@param harbor Harbor
---@return table
local function Extensions(harbor)
    local extensions = {}
    local enabled_extensions = harbor.config.opts.extensions or {}

    if utils.table.contains(enabled_extensions, "lualine") then
        local lualine_extension = require("harbor.extensions.builtins.lualine")
        extensions.lualine = lualine_extension:setup(harbor)
    end

    if utils.table.contains(enabled_extensions, "telescope") then
        local telescope_extension = require("harbor.extensions.builtins.telescope")
        extensions.telescope = telescope_extension:setup(harbor)
    end

    return extensions
end

return Extensions
