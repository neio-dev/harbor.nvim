local Fleet               = require "harbor.domain.fleet"
local Ship                = require "harbor.domain.ship"
local harbor              = require "harbor"
local test_window_adapter = require "harbor.adapters.test_window_adapter"
local test_buffer_adapter = require "harbor.adapters.test_buffer_adapter"

Fleet.buffer_adapter      = test_buffer_adapter
Ship.buffer_adapter       = test_buffer_adapter
Ship.win_adapter          = test_window_adapter

harbor:setup({})
describe("Fleet:new", function()
    it("initializes with defaults", function()
        local test_fleet = Fleet:new(nil, "test")
    end)

    it("throws on required empty args", function()
        local status, err = pcall(Fleet.new)

        assert.are.equal(ERROR_TYPES.FleetError, err.type)
    end)
end)

describe("Fleet:get", function()
    it("returns corresponding ship", function()
        local fleet = Fleet:new(harbor, "test", 4)
        local ship = Ship:new("test.txt", { row = 0, col = 0 })

        fleet:set(ship)

        assert.are.equal(
            ship,
            fleet:get(1)
        )
    end)
end)

describe("Fleet:set", function()
    ---@type Fleet
    local fleet

    before_each(function()
        fleet = Fleet:new(harbor, "test", 4)
    end)

    it("populate next index", function()
        local ship = Ship:new("test.txt", { row = 0, col = 0 })
        local second_ship = Ship:new("test.lua", { row = 0, col = 0 })

        fleet:set(ship)
        fleet:set(second_ship)

        assert.are.equal(
            second_ship,
            fleet:get(2)
        )
    end)

    it("add current buf", function()
        local buf = fleet.buffer_adapter.add("test.txt")
        print(buf)
        fleet.buffer_adapter.set_current(buf)
        fleet:set()
        assert.are.same("test.txt", fleet:get(1).value)
    end)
end)

describe("Fleet:cycle", function()
    ---@type Fleet
    local fleet

    ---@type Ship[]
    local ships

    before_each(function()
        ships = {
            Ship:new("test.txt", { row = 0, col = 0 }),
            Ship:new("test2.txt", { row = 0, col = 0 }),
            Ship:new("test3.txt", { row = 0, col = 0 }),
            Ship:new("test4.txt", { row = 0, col = 0 }),
        }

        fleet = Fleet:new(harbor, "test", 4)

        for _, each_ship in ipairs(ships) do
            fleet:set(each_ship)
        end
    end)

    it("cycle forwards", function()
        fleet:show(2)
        fleet:cycle(false)

        assert.are.same(ships[3].value, harbor.active_ship.value)
    end)

    it("cycle backwards", function()
        fleet:show(2)
        fleet:cycle(true)

        assert.are.same(ships[1].value, harbor.active_ship.value)
    end)

    it("loop to start", function()
        fleet:show(4)
        fleet:cycle(false)

        assert.are.same(ships[1].value, harbor.active_ship.value)
    end)

    it("loop to end", function()
        fleet:show(1)
        fleet:cycle(true)

        assert.are.same(ships[#ships].value, harbor.active_ship.value)
    end)

    it("jump forwards over empty ships", function()
        fleet:show(1)
        fleet:remove(2)
        fleet:remove(3)
        fleet:cycle(false)

        assert.are.same(ships[#ships].value, harbor.active_ship.value)
    end)

    it("jump backwards over empty ships", function()
        fleet:show(4)
        fleet:remove(2)
        fleet:remove(3)
        fleet:cycle(true)

        assert.are.same(ships[1].value, harbor.active_ship.value)
    end)

    it("loop to start and jump forwards over empty ships", function()
        fleet:show(4)
        fleet:remove(1)
        fleet:cycle(false)

        assert.are.same(ships[2].value, harbor.active_ship.value)
    end)

    it("loop to end and jump backwards over empty ships", function()
        fleet:show(1)
        fleet:remove(4)
        fleet:cycle(true)

        assert.are.same(ships[3].value, harbor.active_ship.value)
    end)
end)

describe("Fleet:show", function()

end)
