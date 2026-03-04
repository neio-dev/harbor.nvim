local Ship = require("harbor.domain.ship")
local test_buffer_adapter = require("harbor.adapters.test_buffer_adapter")
local test_window_adapter = require("harbor.adapters.test_window_adapter")

-- Ship.buffer_adapter = test_buffer_adapter
-- Ship.win_adapter = test_window_adapter

describe("Ship:new", function()
    it("initializes with defaults", function()
        local ship = Ship:new("foo.txt")

        assert.are.equal("foo.txt", ship.value)
    end)

    it("throws on required empty args", function()
        local status, err = pcall(Ship.new)

        assert.are.equal(ERROR_TYPES.ShipError, err.type)
    end)
end)

describe("Ship:format_name", function()
    it("returns only the filename", function()
        local ship = Ship:new("test/dir/foo.txt")

        assert.are.equal("foo.txt", ship:format_name())
    end)
end)

describe("Ship:get_buf", function()
    before_each(function()
        Ship.buffer_adapter.buffers = {}
        Ship.buffer_adapter.loaded_buffers = {}
    end)

    it("returns existing buf", function()
        local ship = Ship:new("test/dir/foo.txt")
        local buf = Ship.buffer_adapter.add(ship.value)

        assert.are.equal(buf, ship:get_buf())
    end)

    it("does not duplicate buf", function()
        local ship = Ship:new("so.txt")
        local buf = Ship.buffer_adapter.add(ship.value)
        assert.are.equal(buf, ship:get_buf())
        assert.are.equal(buf, ship:get_buf())
    end)

    it("creates and load a buf", function()
        local ship = Ship:new("/foso.txt")

        assert.are_not.equal(-1, ship:get_buf())
        assert.are.equal(1, Ship.buffer_adapter.is_loaded(ship:get_buf()))
    end)
end)

describe("Ship:save_cursor", function()
    it("save current cursor", function()
        local ship = Ship:new("/foso.txt")

        ship:save_cursor()

        assert.are.equal(
            Ship.win_adapter.get_cursor()[1],
            ship.position.row)

        assert.are.equal(
            Ship.win_adapter.get_cursor()[2],
            ship.position.col)
    end)
end)
