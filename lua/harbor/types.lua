---@class Harbor
---@field dock Dock
---@field bay Bay
---@field lighthouse Lighthouse
---@field extensions {[string]: Extension}
---@field active_ship? Ship|Empty

---@class CursorPosition
---@field col number
---@field row number

---@alias PossibleList "dock"|"bay"

---@class Ship
---@field value string
---@field position CursorPosition 
---@field current_list PossibleList 
---@field open_once boolean 

---@class Fleet
---@field name string
---@field ships {[string]: Ship}
---@field resolve? RESOLVE.replace|RESOLVE.prepend
---@field harbor Harbor
---@field previous_index? number
---@field length number
---@field history_length number

---@class Bay: Fleet

---@class Dock: Fleet

---@class SavedData
---@field dock Ship[]
---@field bay Ship[]

---@class SessionManager
---@field sessions {}
---@field path string
---@field dir string
---@field harbor Harbor
---@field current_session string

---@class Lighthouse

---@alias ExtensionName "telescope"|"lualine"

return {}
