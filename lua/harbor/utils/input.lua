local M = {}

---@param on_input fun(input_char: string, full_input: string): nil
---@param on_submit fun(full_input: string): nil
---@param on_cancel fun(): nil
---@param length number
---@return boolean?
M.smart_input = function(on_input, on_submit, on_cancel, length)
    local full_input = ""
    local function to_input()
        local input = vim.fn.getchar()
        ---@cast input number
        local input_char = vim.fn.nr2char(input)

        if input == 13 then goto break_input end
        if input == 27 then
            if on_cancel ~= nil then on_cancel() end
            return nil
        end

        full_input = full_input .. input_char
        if on_input ~= nil then
            on_input(input_char, full_input)
        end
        if length ~= nil and length == #full_input then
            goto break_input
        end

        --vim.schedule(function() to_input() end)

        ::break_input::
        return true
    end

    local success = to_input()

    if success and on_submit ~= nil then
        on_submit(full_input)
    end
end

return M
