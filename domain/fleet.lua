local Ship = require("harbor.domain.ship")
local buffer = require("harbor.infra.buffers")
local ui = require("harbor.ui")
local utils = require("harbor.utils")

-- Used in place of nil to keep table functions usable
-- e.g. nil will stop a for loop at nil index
---@class Empty
EMPTY = {}

---@enum RESOLVE
RESOLVE = {
    replace = "replace", -- replace: Replace an existing ship
    prepend = "prepend", -- prepend: Add the ship to beginning of fleet
}

---@class Fleet
local Fleet = {
}

Fleet.__index = Fleet

---@param harbor Harbor
---@param name string
---@param length number
---@param resolve RESOLVE RESOLVE.replace
---@param history_length? number 10
---@return Fleet
function Fleet.new(self, harbor, name, length, resolve, history_length)
    local instance = setmetatable({
        name = name,
        ships = {},
        resolve = resolve or RESOLVE.replace,
        previous_index = nil,
        length = length,
        history_length = history_length or 10,
    }, self)

    instance.harbor = harbor

    for i = 1, instance.history_length do
        instance.ships[i] = EMPTY
    end

    return instance
end

---@param index? integer
---@return Ship[]|Ship?
function Fleet:get(index)
    if index then
        return self.ships[index] or nil
    end

    return self.ships
end

---input the user for ship index
---@private
---@param length number
---@return number?
function Fleet:input_index(length)
    local return_index = nil
    utils.input.smart_input(
        function(input)
            local index = tonumber(input)
            if index and index >= 1 and index <= length and index == math.floor(index) then
                return_index = index
            else
            end
        end,
        nil,
        nil,
        1)
    return return_index
end

---@param ship? Ship|Empty
---@param index? number
---@return {ship: Ship|Empty|nil, previous_ship: Ship|Empty|nil}
function Fleet:set(ship, index)
    local previous_ship = nil
    local idx = index or (self.resolve == RESOLVE.replace and self:get_next_empty_idx() or nil)
    if ship == nil then
        local curr_buf = buffer:get_current()

        ship = Ship:new(curr_buf.name, curr_buf.cursor)
    end

    ship.current_list = self.name
    if (idx == nil or idx > self.length) then
        if self.resolve == RESOLVE.replace then
            idx = self:input_index(#self.ships)
            if idx == nil then return { ship = nil, previous_ship = nil } end
            previous_ship = self.ships[idx or 1]
            local previous_idx = self:get_ship_index(ship.value)
            if previous_idx ~= nil then
                local inverted_ship = self.ships[idx]
                self.ships[previous_idx] = inverted_ship or EMPTY
            end
        elseif self.resolve == RESOLVE.prepend then
            idx = 1
            for i = #self.ships - 1, 1, -1 do
                self.ships[i + 1] = self.ships[i]
            end
        end
    end

    self.ships[idx or 1] = ship
    self.harbor.active_ship = ship
    self.harbor.sessions:save()
    self.harbor.emitter:emit("FLEET_ADD", { fleet = self, ship = ship})

    return { ship = ship, previous_ship = previous_ship }
end

---@param target? number|string|Ship
---@return { index: number, previous_ship: Ship }
function Fleet:remove(target)
    local index = nil

    if target == nil then
        local curr_name = buffer:get_current().name
        index = self:get_ship_index(curr_name)
    elseif type(target) == "number" then
        index = target
    elseif type(target) == "string" then
        index = self:get_ship_index(target)
    elseif getmetatable(target) == Ship then
        index = self:get_ship_index(target.value)
    end

    if index == nil then
        error(ui.icons.error .. " Invalid target for removal: must be either index, path string, or Ship containing .value")
    end

    local previous_ship = self.ships[index]

    if self.resolve == RESOLVE.replace then
        self:set(EMPTY, index)
    elseif self.resolve == RESOLVE.prepend then
        for i = index + 1, #self.ships do
            self.ships[i - 1] = self.ships[i]
        end

        self.ships[#self.ships] = EMPTY
    end


    self.harbor.emitter:emit("FLEET_REMOVE", { fleet = self, index, previous_ship})

    return { previous_ship = previous_ship, index = index }
end

---@private
---@param target_path string
function Fleet:find_and_focus_win(target_path)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_path = vim.api.nvim_buf_get_name(buf)

        if buf_path == target_path then
            vim.api.nvim_set_current_win(win)
        end
    end
end

---@param index number
---@param new_win? boolean
function Fleet:show(index, new_win)
    if self.harbor.active_ship ~= nil then
        self.harbor.active_ship:update_cursor()
        self.harbor.sessions:save()
    end

    ---@type Ship
    local ship = self.ships[tonumber(index)]
    if ship == EMPTY or ship == nil then
        return
    end

    local bufnr = ship:get_buf()
    if new_win ~= true then
        self:find_and_focus_win(ship.value)
    end
    if bufnr ~= -1 then
        vim.api.nvim_set_current_buf(bufnr)
    else
        vim.schedule(function()
            --vim.schedule(function() vim.cmd("edit " .. path) end)
            bufnr = vim.fn.bufadd(ship.value)
            vim.fn.bufload(bufnr)
            vim.api.nvim_set_current_buf(bufnr)
            --vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { ship.position.row, ship.position.col })
        end)
    end

    self.harbor.active_ship = ship
end

---@param name? string|{}
---@return number?
function Fleet:get_ship_index(name)
    local found_index = nil

    for index, ship in ipairs(self.ships) do
        if type(name) == "string" and ship.value == name then
            found_index = index
            break
        end
    end

    return found_index
end

---@private
---@return number?
function Fleet:get_next_empty_idx()
    local found_index = nil

    for i, v in ipairs(self.ships) do
        if v == EMPTY then
            found_index = i
            break
        end
    end

    return found_index
end

---@param starting_index number
---@param direction number?
---@return number?
function Fleet:get_next_populated_idx(starting_index, direction)
    local _direction = direction ~= nil and direction or 1
    local limit = _direction < 0 and 1 or self.length

    local found_index = nil
    for i = starting_index + _direction, limit, _direction do
        if self.ships[i].value then
            found_index = i
            break
        end
    end

    if found_index == nil then
        local start = _direction < 0 and self.length or 1
        local limit = _direction < 0 and 1 or starting_index - 1
        for i = start, limit, _direction do
            if self.ships[i].value then
                found_index = i
                break
            end
        end
    end

    return found_index
end

---@param reverse boolean
function Fleet:cycle(reverse)
    local curr_buf = buffer:get_current()
    local direction = reverse and -1 or 1
    local curr_index = self:get_ship_index(curr_buf.name) or (self.previous_index and self.previous_index - direction)
    local next_index = self:get_next_populated_idx(curr_index or 0, direction)

    if self.resolve == RESOLVE.prepend then
        if curr_index ~= nil or not self.ships[1].value then
            local first_ship = self.ships[1]

            for i = 2, #self.ships do
                -- self.ships[i - 1] = self.ships[i]
            end

            -- self.ships[#self.ships] = first_ship
        end
        -- next_index = 1
    end

    if next_index ~= nil then
        self:show(next_index)
        self.previous_index = next_index
    end
end

return Fleet
