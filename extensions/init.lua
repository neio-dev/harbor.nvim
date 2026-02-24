local lualine_extension = require("harbor.extensions.builtins.lualine")
local telescope_extension = require("harbor.extensions.builtins.telescope")

---@param harbor Harbor
---@return table
local function Extensions(harbor)
    return {
        lualine = lualine_extension:setup(),
        telescope = telescope_extension:setup(harbor),
    }
end

return Extensions
