local Extension = require("harbor.extensions.extension")
local harbor_telescope = Extension:new("telescope")
harbor_telescope.__index = harbor_telescope

local function get_ships(fleet)
    local harbor = require("harbor")
    local new_table = {}
    local ships = harbor[fleet or "dock"].ships

    for index, value in ipairs(ships) do
        if not value.format_name then break end
        table.insert(new_table, { value:format_name(), "" .. index })
    end

    return new_table
end

local function get_sessions()
    local new_table = {}
    local harbor = require("harbor")

    new_table = harbor.sessions.sessions
    return new_table
end

function harbor_telescope:setup(harbor)
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local actions = require "telescope.actions"
    local actions_state = require "telescope.actions.state"
    local config = require("telescope.config").values

    local show_dock = function(opts)
        opts = opts or {}
        pickers.new(opts, {
            prompt_title = "Harbor Dock",
            finder = finders.new_table {
                results = get_ships(),
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry[1],
                        ordinal = entry[2]
                    }
                end,
            },
            sorter = config.generic_sorter(opts),

            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = actions_state.get_selected_entry()
                    harbor.dock:show(selection.index)
                end)
                return true
            end,
        }):find()
    end

    local show_bay = function(opts)
        opts = opts or {}
        pickers.new(opts, {
            prompt_title = "Harbor Bay",
            finder = finders.new_table {
                results = get_ships("bay"),
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry[1],
                        ordinal = entry[2]
                    }
                end,
            },
            sorter = config.generic_sorter(opts),

            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = actions_state.get_selected_entry()
                    harbor.bay:show(selection.index)
                end)
                return true
            end,
        }):find()
    end

    local show_sessions = function(opts)
        opts = opts or {}
        pickers.new(opts, {
            prompt_title = "Harbor Sessions",
            finder = finders.new_table {
                results = get_sessions(),
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry[2] .. " (" .. entry[1] .. ")",
                        ordinal = entry[2]
                    }
                end,
            },
            finder = finders.new_dynamic({
                fn = function(prompt)
                    local sessions = get_sessions(prompt)

                    print(vim.inspect(sessions))
                    if vim.tbl_isempty(sessions) then
                        return {
                            {
                                value = "__create__",
                                display = "Create session…",
                                ordinal = "Create session",
                                is_create = true,
                            },
                        }
                    end

                    return sessions
                end,
                entry_maker = function(entry)
                    print("entry maker", vim.inspect(entry))
                    if entry.is_create then
                        return entry[2]
                    end

                    return {
                        value = entry,
                        display = entry[2],
                        ordinal = entry[2],
                    }
                end,
            }),
            sorter = config.generic_sorter(opts),

            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = actions_state.get_selected_entry()
                    harbor.bay:show(selection.index)
                end)
                return true
            end,
        }):find()
    end

    vim.keymap.set("n", "<leader>hh", function()
        show_dock(require("telescope.themes").get_dropdown {})
    end)

    vim.keymap.set("n", "<leader>hb", function()
        show_bay(require("telescope.themes").get_dropdown {})
    end)

    vim.keymap.set("n", "<leader>hs", function()
        show_sessions(require("telescope.themes").get_dropdown {})
    end)
end

return harbor_telescope
