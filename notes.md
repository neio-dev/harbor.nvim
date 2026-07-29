# Todo
---
- [x] add fleet type (set/append)
- [-] save sessions
    - [ ] better save logic (on set on remove)
- [x] connect bay to dock
- [x] prevent add to same list 
- [x] fix nvim present in bay
- [x] cursor position
- [ ] outside history vs visible
- [ ] differentiate name
- [x] ease input process
- [x] fix cycle when last is x
- [x] add a currentlist accessor
- [ ] add previous index toggle on repeating shortcut
- [ ] [SPLIT] handle splits
- [-] lighthouse
- [ ] add config
- [-] [lualine] highlight diagnostic and git status
    - [x] add lsp diag
    - [.] add git status [TO FIX]
- [-] [telescope] add telescope extension
- [x] cycle first position for "append"
- [x] if cycle not current list, select list, else cycle
- [x] restructure project 
- [ ] pin panel - eg pin a buffer into a sidepanel independant of current buffer switching, can focus panel, close it, remove it
---

## Bugs
---
- [x] cycle goes back to first index after 2nd index
- [x] error when no file present on first load for current pwd (just check if file before loading)
- [x] [SPLIT] when opening a new file it opens the file in bay section and normal
- [x] when moving from bay to dock, bay entry stays
- [x] in prepend should always prepend on set
- [x] fix empty name on load
- [x] fix cycle when empty in middle
---

