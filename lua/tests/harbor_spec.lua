require("tests.spec_helper")
local Ship = require("harbor.domain.ship")
local Fleet = require("harbor.domain.fleet")
local Harbor = require("harbor.core.harbor")

local harbor

describe("Harbor:get_current_list", function()
    before_each(function ()
        harbor = Harbor:new()

        harbor:setup {}
    end)

    it("returns current fleet", function()
        local fleet = Fleet:new(harbor, "test", 4)
        harbor:attach_fleet(fleet)
        local ship = Ship:new("foo.txt")
        fleet:set(ship)

        assert.are.equal(fleet.name, harbor:get_current_list().name)
    end)
end)

describe("Harbor:attach_fleet", function ()
    before_each(function ()
        harbor = Harbor:new()

        harbor:setup {}
    end)

    it("add fleet to harbor instance", function ()
        local fleet = Fleet:new(harbor, "test", 4)
        harbor:attach_fleet(fleet)

        assert.is.truthy(harbor.fleets[fleet.name])
    end)
end)

describe("Harbor:setup", function ()
end)
