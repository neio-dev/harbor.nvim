local Ship = require("harbor.domain.ship")
local utils = require("harbor.utils")

---@class SessionManager
local SessionManager = {}
SessionManager.__index = SessionManager

---@param harbor Harbor
---@return SessionManager
function SessionManager:new(harbor)
    local instance = setmetatable({
        sessions = {},
        path = vim.fn.getcwd(),
        dir = vim.fn.stdpath("data") .. "/harbor",
    }, self)
    instance.harbor = harbor

    local session_data = instance:get_session_data()
    if session_data ~= nil then
        for key, value in pairs(session_data) do
            if key ~= "name" and key ~= "last_session" then
                table.insert(instance.sessions, { key, value.name })
            end
        end
    end

    instance.current_session = session_data and (session_data["last_session"] ~= nil and session_data["last_session"]) or utils.uid()

    return instance
end

---@param fleet_data SavedData
---@param list_name PossibleList
---@return (Ship|Empty)[]
function SessionManager:parse_fleet(fleet_data, list_name)
    local parsed_fleet_data = {}

    local fleet_opts = self.harbor.config.opts[list_name]
    for i = 1, fleet_opts.history or fleet_opts.length, 1 do
        local iterated_ship = fleet_data[list_name][i]
        local ship = (iterated_ship == nil or iterated_ship.value == nil) and (EMPTY) or
            (Ship:new(iterated_ship.value, iterated_ship.position, list_name))

        table.insert(
            parsed_fleet_data,
            ship
        )
    end

    return parsed_fleet_data
end

function SessionManager:load()
    local data = self:get_session_data()
    if not data or not data[self.current_session] then
        return
    end

    data = data[self.current_session]

    if data.bay then
        self.harbor.bay.ships = self:parse_fleet(data, "bay")
    end

    if data.dock then
        self.harbor.dock.ships = self:parse_fleet(data, "dock")
    end
end

---@return SavedData?
function SessionManager:get_session_data()
    local filepath = self:get_session_path()
    if vim.fn.filereadable(filepath) == 0 then return nil end

    local lines = vim.fn.readfile(filepath)
    if lines == nil then return nil end

    local json_string = table.concat(lines, "\n")
    local data = vim.fn.json_decode(json_string)

    return data
end

---@param name? string
function SessionManager:save(name)
    local json = vim.fn.json_encode
    local filepath = self:get_session_path()
    local current_session_data = { dock = self.harbor.dock:get(), bay = self.harbor.bay:get() }
    local prev_data = self:get_session_data() or {}
    local new_data = prev_data["last_session"] and prev_data or {}

    new_data[self.current_session] = current_session_data
    new_data["last_session"] = self.current_session

    if new_data[self.current_session] and not new_data[self.current_session].name then
        local prev_name = prev_data[self.current_session] and prev_data[self.current_session].name or nil
        new_data[self.current_session].name = name or prev_name or "default"
    end

    vim.fn.mkdir(self.dir, "p")
    vim.fn.writefile({ json(new_data) }, filepath)
end

---@return string
function SessionManager:get_session_path()
    return self.dir .. "/" .. utils.fnv1a(self.path) .. ".json"
end

return SessionManager
