local harness = require("plenary.test_harness")

harness.test_directory(".", {
    minimal_init = "lua/harbor/lua/tests/minimal.lua",
    helper = { "lua/harbor/lua/tests/spec_helper.lua" }
})
