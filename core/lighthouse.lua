local utils = require("harbor.utils")
local input = require("harbor.infra.input")

local MAP = { "n", "e", "i", "o" }

---@class Lighthouse
local Lighthouse = {}
Lighthouse.__index = Lighthouse

---@param harbor Harbor
---@return Lighthouse
function Lighthouse:new(harbor)
    ---@class Lighthouse
    local instance = setmetatable({}, self)
    instance.harbor = harbor

    return instance
end

---@class SplitOpts
---@field buf? integer
---@field win? integer
---@field split_vertically? boolean

---@param opts SplitOpts
---@return { win: integer, buf: integer }
local function create_split(opts)
    local win

    if type(opts.win) == "number" then
        -- first input: just use existing window
        ---@type integer
        win = opts.win
        vim.api.nvim_set_current_win(win)
    else
        -- make sure the current window is where you want the split relative to
        -- then split
        local split_direction = opts.split_vertically and "vertical rightbelow vsplit" or "rightbelow split"
        vim.cmd(split_direction)
        -- immediately after splitting, the new window is current
        win = vim.api.nvim_get_current_win()
    end

    -- set the correct buffer in this window
    local buf = opts.buf or vim.api.nvim_create_buf(true, true)
    vim.api.nvim_win_set_buf(win, buf)

    return { win = win, buf = buf }
end

function Lighthouse:input()
    local session_name = "harbor_temp_session.vim"
    vim.cmd("mksession! /tmp/" .. session_name)
    local cur = vim.api.nvim_get_current_win()

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if win ~= cur then
            vim.api.nvim_win_close(win, false) -- false = don't force if unsaved buffers
        end
    end
    self.initial_win = cur
    self.lighthouse_ships = {}

    local open_wins = {}

    local centered_input = input.centered_input(
        "Lighthouse position",
        function(input, full_input, prompt_win)
            if input == "__backspace" then
                -- close last split
                if #open_wins > 0 then
                    vim.api.nvim_win_close(open_wins[#open_wins], false)
                    table.remove(open_wins, #open_wins)
                end
                return
            end

            -- handle new input
            self:handle_input_win(input,
                self.initial_win,
                open_wins,
                function()
                    vim.api.nvim_set_current_win(prompt_win)
                end
            )
        end,
        nil,
        function()
            vim.cmd("silent! source /tmp/" .. session_name)
        end
    )

    self.prompt_win = centered_input
end

--- handle input in the lighthouse system
---@param input string
---@param forced_win integer
---@param open_wins integer[]
---@param open_callback? fun(): nil
function Lighthouse:handle_input_win(input, forced_win, open_wins, open_callback)
    local index = utils.table.get_index(MAP, string.lower(input))
    local ship = self.harbor.dock:get(index or 1)
    if not ship then return end

    local new_win = create_split({
        split_vertically = string.lower(input) == input,
        buf = ship:get_buf(),
        win = #open_wins == 0 and forced_win or nil, -- only first input
    })

    table.insert(open_wins, new_win.win)

    -- return focus to prompt window if needed
    if open_callback then open_callback() end
end

return Lighthouse
