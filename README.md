```
.___.__  .______  .______  ._______ ._______  .______  
:   |  \ :      \ : __   \ : __   / : .___  \ : __   \ 
|   :   ||   .   ||  \____||  |>  \ | :   |  ||  \____|
|   .   ||   :   ||   :  \ |  |>   \|     :  ||   :  \ 
|___|   ||___|   ||   |___\|_______/ \_. ___/ |   |___\
    |___|    |___||___|                :/     |___|    
                                       :               
```

# harbor.nvim

One of the features I couldn’t find in other similar plugins was a temporary file list. I often jump back to a few files (1–3) repeatedly, but not enough to pin them.

Harbor handles this with the bay fleet:
- Every time you open a file, it’s added to the fleet (docs, examples, references).
- You still have a separate list for pinned files, the main files for your current feature.

## Quickly switch between recent and pinned files

https://github.com/user-attachments/assets/9727e920-4d9b-4ec0-902a-147f129a0781

> **Note: This project is in active development.** Core features are operational, but some areas are still being refined.

## Features

- **Pin files with a shortcut** - Keep important files one keystroke away
- **Cycle through recent files** - Quickly jump between the last files you opened

### WIP/Upcoming
Splits:
- Better navigation for basic split
- Lighthouse, builtin split manager

## Installation

### lazy.nvim

```lua
{
  "neio-dev/harbor.nvim",
  opts = {},
}
```

## Quick Start

You can use default keymaps by calling `harbor:set_default_keybinds()` in `setup()`.

## Plugin Configuration

```lua
require("harbor").setup({
    -- load builtin extensions
    extensions = { "lualine", "telescope" },
    -- show fleet history, eg if your bay length is 3 and history is 5, it will show you the history stack too
    show_history = false,
    bay = {
        -- length of the fleet
        length = 3,
        -- length of last files tracked
        history_length = 5,
    },
    dock = {
        -- length of the fleet
        length = 4,
    },
})
```

## Default Keymaps

### Navigating through fleets

| Key | Action |
|-----|--------|
| `<C-n>` | Switch to #1 position in Dock |
| `<C-e>` | Switch to #2 position in Dock |
| `<C-i>` | Switch to #3 position in Dock |
| `<C-o>` | Switch to #4 position in Dock |
| `<C-h>` | Cycle forward in Fleet |
| `<C-j>` | Cycle backward in Fleet |
| `<leader><C-n>` | Switch to #1 position in Fleet |
| `<leader><C-e>` | Switch to #2 position in Fleet |
| `<leader><C-i>` | Switch to #3 position in Fleet |


### Edit fleet
Opening any file that are not in any fleet will add it to the Bay fleet.

| Key | Action |
|-----|--------|
| `<leader>a` | Add current buf to the Docker fleet. If no space, input 1 to Dock length to replace |
| `<leader><leader>x` | Remove current ship from current fleet. If in dock, it will move the ship to the Bay fleet |


## Commands

| Command | Description |
|---------|-------------|
| `:HrbSessionPath` | Print current session path |
| `:HrbLighthouse` | Show Lighthouse input |
| `:HrbDock` | Print Dock list |
| `:HrbLoad` | Load harbor sessions |
| `:HrbSave` | Save harbor sessions |
| `:HrbAdd` | Add current buffer to dock |
| `:HrbRemove` | Remove current buffer to dock |
| `:HrbShow` | Show ship in dock at position of argument, e.g. :HrbShow 2 will display the 2 docked ship |


## License

MIT

