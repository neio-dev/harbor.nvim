local Extension = require("harbor.extensions.extension")
local buffer = require("harbor.infra.buffers")
local utils = require("harbor.utils")
local harbor_lualine = Extension:new("lualine")

harbor_lualine.__index = harbor_lualine

local active_icon = ""

---@param ship_index number
function _G.HarborBayShow(ship_index)
    require("harbor").bay:show(ship_index)
end

---@param ship_index number
function _G.HarborDockShow(ship_index)
    require("harbor").dock:show(ship_index)
end

---comment
---@return table
local function get_active_highlight()
    local mode = vim.fn.mode()
    local mode_map = {
        n = "normal",
        i = "insert",
        v = "visual",
        V = "visual",
        [""] = "visual", -- Visual block
        c = "command",
        R = "replace",
        t = "terminal",
    }

    return {
        default = "lualine_a_" .. (mode_map[mode] or "normal"),
        active = "lualine_b_" .. (mode_map[mode] or "normal"),
        accent = "lualine_c_" .. (mode_map[mode] or "normal"),
        sep = "lualine_a_inactive",
    }
end

local T = utils.T(function()
    return get_active_highlight().default
end)

local function get_git_status(ship)
    local git_status = vim.fn.system("git status --porcelain " .. ship.value)
    local prefix = ""
    if (#git_status > 0 and (#git_status < (#ship:format_name() + 7))) then
        local split = string.match(git_status, "%S+")

        prefix = split and ("(" .. split .. ") ") or ""
    end

    return prefix
end

---@param name string
---@return string
local function get_diagnostic(name)
    local prefix = ""
    local buf = name and buffer:get(name) or nil
    if buf == nil then return "" end
    local bufnr = buf.number
    if bufnr ~= -1 then
        local diagnostics = vim.diagnostic.get(bufnr)
        local severity = 0

        for _, diag in ipairs(diagnostics) do
            severity = tonumber(diag.severity) > severity and tonumber(diag.severity) or severity
        end

        if severity ~= nil then
            if severity == vim.diagnostic.severity.ERROR then prefix = " " end
            if severity == vim.diagnostic.severity.WARN then prefix = " " end
            if severity == vim.diagnostic.severity.INFO then prefix = " " end
            if severity == vim.diagnostic.severity.HINT then prefix = " " end
        end
    end

    return prefix
end

---@param fleet Fleet
---@param ship Ship
---@param is_active boolean
---@param opt {}
---@return string
local function pretty_name(fleet, ship, is_active, opt)
    opt = opt or {}
    local hl = get_active_highlight()
    local name = get_diagnostic(ship.value) .. (ship.value and ship:format_name() or "x") .. " "
    name = string.upper(name)
    if ship.value then
        local func = ship.current_list == "bay" and "HarborBayShow" or "HarborDockShow"
        name = string.format(
            "%%%d@v:lua." .. func .. "@%s%%T",
            fleet:get_ship_index(ship.value),
            name
        )
    end

    if is_active then
        name = T({ active_icon .. " " .. name, hl.active })
    end

    return (name)
end

---@param name string
---@param fleet Fleet
---@param opt {}
---@return string
local function get_fleet(name, fleet, opt)
    local hl = get_active_highlight()
    local line = T({ " [" .. name .. "] ", hl.accent })

    opt = opt or {}
    local curr_buf = buffer:get_current()
    local ships = fleet:get()
    for i = 1, #ships, 1 do
        ---@cast ships {}
        local ship = ships[i]
        local is_active = ship.value and curr_buf.name == ship.value
        local is_last = fleet.previous_index and fleet.previous_index == i
        line = line .. " "

        if is_last then
            line = line .. "[●] "
        end

        if opt.show_index then
            line = line .. " [" .. i .. "] "
        end

        local ship_name = pretty_name(fleet, ship, is_active, opt)
        if i > fleet.length then
            if show_history ~= true then
                break
            end
            ship_name = T({ " " .. ship_name, hl.sep })
        end

        line = line .. ship_name .. (i ~= #ships and " | " or "")
    end

    return T({ line, hl.active })
end

function harbor_lualine:setup()
    local ext = function()
        local hl = get_active_highlight(true)
        local harbor = require("harbor")
        local bay_fleet = get_fleet("BAY", harbor.bay, { invert = false, show_history = false })
        local dock_fleet = get_fleet("DOCK", harbor.dock, { show_index = true, invert = false })
        return T({ bay_fleet }, { " " }, { " ||| ", hl.sep }, { " " }, { dock_fleet })
    end

    return ext
end

return harbor_lualine
