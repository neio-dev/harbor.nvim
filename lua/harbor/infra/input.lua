local Win = require("harbor.infra.windows")

local M = {}

---@param win integer
---@param callback fun(string?): nil
M.handle_user_input = function(win, callback)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local input = lines[1]
    vim.cmd("stopinsert")
    vim.api.nvim_win_close(win, true)
    vim.schedule(function()
        if (callback ~= nil) then
            callback(input)
        end
    end)
end

---@param prompt string
---@param on_input fun(char: string, input: string, win: number): nil
---@param callback fun(): nil
---@param on_cancel fun(win: number): nil
---@return table
M.centered_input = function(prompt, on_input, callback, on_cancel)
    local width = math.floor(vim.o.columns * 0.5)
    local height = 1
    local row = math.floor((vim.o.lines - height) / 2) - 1
    local col = math.floor((vim.o.columns - width) / 2)

    local win_instance = Win:new(
        prompt,
        {
            style = "minimal",
            relative = "editor",
            width = width,
            height = height,
            row = row + 1,
            col = col,
            border = "rounded",
        }
    )

    -- Open the floating window
    local win = win_instance:open()
    local last_width = 0
    vim.api.nvim_create_autocmd({ "TextChangedI" }, {
        buffer = win_instance.buf,
        callback = function(args)
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            local input = lines[1]
            --print("TextChangedI", input)
            local char = string.sub(input, #input, #input)
            --print("TextChangedI", char)
            if #input <= last_width or (last_width and #lines == 0) then
                char = "__backspace"
            end
            if on_input and #input > 0 then
                vim.schedule(function()
                    on_input(char, input, win)
                end)
            end
            last_width = #input
        end,
    })
    -- Move cursor to the end of prompt
    vim.api.nvim_win_set_cursor(win, { 1, 0 }) -- start of line
    -- Enable insert mode to accept input
    vim.cmd("startinsert")

    vim.keymap.set('i', '<CR>', function()
        M.handle_user_input(win, callback)
    end, { buffer = win_instance.buf, noremap = true, silent = true })

    vim.keymap.set('i', '<Esc>', function()
        vim.cmd("stopinsert")
        vim.api.nvim_win_close(win, true)
        vim.schedule(function()
            if on_cancel ~= nil then on_cancel(win) end
        end)
    end, { buffer = win_instance.buf, noremap = true, silent = true })

    return win_instance
end

return M
