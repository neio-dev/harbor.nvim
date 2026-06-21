require("tests.spec_helper")
local Sessions = require("harbor.infra.sessions")
local Ship = require("harbor.domain.ship")
local Harbor = require("harbor.core.harbor")
local utils = require("harbor.utils")

local harbor
local sessions

describe("SessionManager:new", function()
    it("", function()

    end)
end)

describe("SessionManager:parse_fleet", function()
    it("returns every ", function()

    end)
end)

describe("SessionManager:load", function()
    it("", function()

    end)
end)

describe("SessionManager:get_session_data", function()
    before_each(function()
    end)

    it("returns current session data", function()
    end)
end)

describe("SessionManager:save", function()
    before_each(function()
        harbor = Harbor:new()
        harbor:setup {}
        sessions = Sessions:new(harbor)
    end)

    it("saves current harbor state", function()
        harbor.fleets.bay:set(Ship:new("test.txt"), 1)
        harbor.fleets.dock:set(Ship:new("test2.txt"), 2)
        harbor.fleets.dock:set(Ship:new("test3.txt"), 3)
        harbor.fleets.dock:set(Ship:new("test4.txt"), 4)
        harbor.fleets.bay:set(Ship:new("test5.txt"))
        harbor.fleets.bay:set(Ship:new("test6.txt"))
        harbor.fleets.bay:set(Ship:new("test7.txt"))

        sessions:save()
        print(vim.inspect(sessions:get_session_data()))
    end)
end)

describe("SessionManager:get_session_path", function()
    it("", function()

    end)
end)
