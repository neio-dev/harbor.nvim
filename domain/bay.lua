local Fleet = require("harbor.domain.fleet")
local buffer = require("harbor.infra.buffers")

---@class Bay
---@field split_id? number
local Bay = setmetatable({}, { __index = Fleet })
Bay.__index = Bay

---@param harbor Harbor
---@return Bay
function Bay:new(harbor)
    ---@class Bay
    local instance = Fleet.new(self, harbor, "bay", harbor.config.opts.bay.length, RESOLVE.prepend,
        harbor.config.opts.bay.history)
    instance.split_id = nil
    return instance
end

---@param ship Ship|Empty
---@param index? number
function Bay:set(ship, index)
    -- vim.cmd("vsplit")
    -- self:show_split()
    local set_data = Fleet.set(self, ship, index)
end

function Bay:show_split()
    local saved_split_id = self.split_id
    local current_win_id = vim.api.nvim_get_current_win()
    local current_buf_nr = buffer:get_current().number

    if saved_split_id == nil or vim.api.nvim_win_is_valid(saved_split_id) == false then
        if saved_split_id == nil then
            local last_buffer = vim.fn.bufnr("#")
            if last_buffer ~= -1 then
                vim.api.nvim_set_current_buf(last_buffer)
            else
                vim.cmd("enew")
                vim.bo.buftype = "nofile"
                vim.bo.bufhidden = "hide"
                vim.bo.swapfile = false
            end
        end
        vim.cmd("topleft vsplit")
        vim.cmd("vertical resize 60")

        local win_id = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win_id, current_buf_nr)
        self.split_id = win_id
    elseif current_win_id ~= saved_split_id then
        vim.api.nvim_set_current_win(saved_split_id)
    end
end

function Bay:close_split()
    if self.split_id ~= nil and vim.api.nvim_win_is_valid(self.split_id) then
        vim.api.nvim_win_close(self.split_id, false)
    end
end

---@param index number
function Bay:show(index)
    -- vim.cmd("vsplit")
    -- self:show_split()
    Fleet.show(self, index)
end

return Bay
