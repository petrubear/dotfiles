local ui = require("ui")
local perf = require("perf")
-- local kb = require("keybinds")
local config = {}
ui.apply_to_config(config)
-- kb.apply_to_config(config)
perf.apply_to_config(config)

return config
