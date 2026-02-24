local M = {}

M.table = require("harbor.utils.table")
M.input = require("harbor.utils.input")

---highlight text
---@param get_base fun(): nil
---@return function
M.T = function(get_base)
    return function(...)
        local base = get_base()
        local output = {}

        for _, part in ipairs({ ... }) do
            output[#output + 1] = "%#" .. (part[2] or base) .. "#" .. part[1] .. "%#" .. base .. "#"
        end

        return table.concat(output, "")
    end
end

---@param str string
---@return integer
M.fnv1a = function(str)
    local hash = 2166136261
    for i = 1, #str do
        hash = bit.bxor(hash, str:byte(i))
        hash = (hash * 16777619) % 4294967296
    end
    return hash
end

---@return string
M.uid = function()
    math.randomseed(os.clock())
    local template = "xxxxxxxxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxx"
    return string.gsub(
        template,
        "[xy]",
        function(c)
            local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
            return string.format("%x", v)
        end
    )
end

return M
