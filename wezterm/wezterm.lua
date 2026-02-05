local ui = require("ui")
local kb = require("keybinds")
local config = {}
ui.apply_to_config(config)
kb.apply_to_config(config)

return config
