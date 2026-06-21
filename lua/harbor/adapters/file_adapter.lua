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

---@param name string
---@return string
M.get_stdpath = function(name)
    return vim.fn.stdpath(name)
end

---@return string
M.get_cwd = function()
    return vim.fn.getcwd()
end

return M
