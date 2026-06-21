local M = {}

---@param path string
---@return boolean
M.file_exists = function(path)
    return vim.fn.filereadable(path) == 1
end

---@generic T
---@param path string
---@return T
M.read_file = function(path)
    return vim.fn.readfile(path)
end

return M
