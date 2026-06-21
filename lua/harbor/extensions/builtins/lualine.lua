local esper = require("esper")
local Extension = require("harbor.extensions.extension")
local buffer = require("harbor.infra.buffers")
local utils = require("harbor.utils")
local harbor_lualine = Extension:new("lualine")
harbor_lualine.__index = harbor_lualine

local active_icon = ""

---@param ship_index number
function _G.HarborBayShow(ship_index)
    require("harbor").fleets.bay:show(ship_index)
end

---@param ship_index number
function _G.HarborDockShow(ship_index)
    require("harbor").fleets.dock:show(ship_index)
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
    if nil == buf then return "" end
    local bufnr = buf.number
    if -1 ~= bufnr then
        local diagnostics = vim.diagnostic.get(bufnr)
        local severity = 0

        for _, diag in ipairs(diagnostics) do
            severity = tonumber(diag.severity) > severity and tonumber(diag.severity) or severity
        end

        if nil ~= severity then
            if vim.diagnostic.severity.ERROR == severity then prefix = " " end
            if vim.diagnostic.severity.WARN == severity then prefix = " " end
            if vim.diagnostic.severity.INFO == severity then prefix = " " end
            if vim.diagnostic.severity.HINT == severity then prefix = " " end
        end

        if true == vim.bo[bufnr].modified then
            prefix = "● " .. prefix
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
            line = line .. " "
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

local Div = esper.Div
local Icon = esper.Icon
local omap = esper.omap
local harbor = require("harbor")

function FleetName(name)
    return Div { name }
        :style { bg = "black", color = "white", bold = true }
        :layout { padding = 1, border = 1, border_style = "bracket", corner = "mediumshade" }
end

function Fleet(fleet)
    local curr_buf = buffer:get_current()

    return Div { omap(harbor.fleets[fleet]:get()):for_each(function(ship)
            if ship == harbor.fleets.bay.EMPTY then return Icon("times") end
            local is_active = ship.value and curr_buf.name == ship.value

            return Div {
                    is_active and Icon "react",
                    ship.format_name and ship:format_name() or "Ship"
                }
                :layout { border = is_active and 1 or 0, padding = 1, corner = "angleup" }
        end)
        }:style { bg = "cyan", color = "black" }
        :layout { gap = 2 }
end

function TabLine()
    return Div {
        FleetName "BAY",
        Fleet "bay",
        FleetName "DOCK",
        Fleet "dock",
    }:style { bg = "cyan" }
end

function harbor_lualine:setup()
    vim.keymap.set("n", "<leader>r", function() esper.DevTool.open() end)
    local ext = function()
        local hl = get_active_highlight(true)
        local harbor = require("harbor")
        local bay_fleet = get_fleet("BAY", harbor.fleets.bay, { invert = false, show_history = false })
        local dock_fleet = get_fleet("DOCK", harbor.fleets.dock, { show_index = true, invert = false })
        return T({ bay_fleet }, { " " }, { " ||| ", hl.sep }, { " " }, { dock_fleet })
        -- return "%#ErrorMsg#hello%#Normal#"
        -- return vim.fn.escape(TabLine():render(), "%")
        -- return TabLine():render()
        -- local ok, str = pcall(function() return TabLine():render() end)
        -- print(str)
        -- return str
    end

    return ext
end

return harbor_lualine
