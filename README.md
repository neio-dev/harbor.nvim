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

One of the killer feature I couldn't get in other similar plugins was a temporary list.
I often found myself coming back to 1 to 3 files, but not coming back enough to pin them.

Harbor handle that with the bay fleet:
- Everytime you open a new file, it will be added to the fleet (doc, example, references for a function)
- You still have a separate list of pinned files (main files of your current feature)

## Review pull requests and merge requests without leaving Neovim

https://github.com/user-attachments/assets/e805a264-edf7-47ab-ab4d-5a2361826131

> **Note: This project is in active development.** Core features are operational, but some areas are still being refined.

## Features

- **Pin frequent file with a shortcut** — auto-detects provider from git remote
- **Browse last 3 opened files** — auto-detects provider from git remote

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

