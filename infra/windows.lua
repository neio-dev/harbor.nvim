local M = {}
M.__index = M

---@class WinData
---@field win number 
---@field buf number 

---@class Win
---@field win number 
---@field buf number 
---@field win_config vim.api.keyset.win_config 

---@param title string
---@param win_config vim.api.keyset.win_config
---@return { win: number, buf: number } 
local function create_win(title, win_config)
    local current_win = vim.schedule(function() vim.api.nvim_get_current_win() end)

    -- Create a scratch buffer
    local buf = vim.api.nvim_create_buf(false, true)
    local ns = vim.api.nvim_create_namespace("harbor_input_prompt")

    vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, {
        virt_lines = { { { title, "Comment" } } },
        virt_lines_above = true,
    })

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "",
    })

    -- Open the floating window
    local win = vim.api.nvim_open_win(buf, true, win_config)
    return { win = win, buf = buf }
end

---@param title string
---@param win_config vim.api.keyset.win_config
---@return Win
function M:new(title, win_config)
    local instance = setmetatable({}, self)
    local nvim_win = create_win(title, win_config)

    instance.win = nvim_win.win
    instance.buf = nvim_win.buf
    instance.win_config = win_config

    return instance
end

---@return integer
function M:open()
    self.win = vim.api.nvim_open_win(
        self.buf,
        true,
        self.win_config
    )

    return self.win
end

function M:focus()
    if self.win then
        vim.api.nvim_set_current_win(self.win)
    end
end

return M
