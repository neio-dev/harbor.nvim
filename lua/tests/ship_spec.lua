local Ship = require("harbor.domain.ship")

describe("Ship:new", function()
    it("initializes with defaults", function()
        local ship = Ship:new("foo.txt")

        assert.are.equal("foo.txt", ship.value)
    end)
end)
