local Config = require("harbor.core.config")

describe("Config:load", function()
    ---@class Config
    local config

    before_each(function()
        config = Config:new()
    end)

    it("merge with default config", function()
        config:load({
            bay = {
                length = 3,
            },
            test = 5,
        })

        assert.are.equal(5, config.opts.test)
        assert.are.equal(3, config.opts.bay.length)
    end)

    it("does not erase default config properties in table", function()
        local default_config = config.opts

        config:load({
            bay = {
                length = 3,
            },
        })

        assert.are.equal(default_config.bay.history, config.opts.bay.history)
    end)
end)
