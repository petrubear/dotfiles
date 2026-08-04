-- PetruTerm keybinds configuration
-- petruterm-config-version: 3
-- Leader key: Ctrl+F, 1000ms timeout.
-- After pressing Ctrl+F, press the bound key within the timeout window.
--
-- System keybinds that remain hardcoded (not configurable here):
--   Cmd+C / Cmd+V   — copy / paste (clipboard)
--   Cmd+Q           — quit
--   Cmd+K           — clear screen and scrollback
--   Cmd+F           — open / close text search (Enter=next, Shift+Enter=prev, Esc=close)
--   Cmd+1-9         — switch to tab N
--   Ctrl+Space      — toggle inline AI block
--   F12             — toggle debug HUD

local petruterm = require("petruterm")
local module    = {}

function module.apply_to_config(config)
  config.leader   = { key = "f", mods = "CTRL", timeout_ms = 1000 }
  config.keyboard = { option_as_meta = false }

  config.keys = {
    -- ── Overlays ──────────────────────────────────────────────────────────
    { mods = "LEADER", key = "o",  action = petruterm.action.CommandPalette },

    -- ── AI controls ────────────────────────────────────────────────────────
    -- leader+A   : focus AI panel / return focus to terminal
    { mods = "LEADER", key = "A",  action = petruterm.action.FocusAiPanel },
    -- leader+a+a : toggle AI panel open / close
    -- leader+a+e : Explain last output
    -- leader+a+f : Fix last error
    -- leader+a+z : Undo last write
    -- (These are handled as hardcoded sub-leader sequences, not config entries.)

    -- ── Tabs (tmux-style) ─────────────────────────────────────────────────
    { mods = "LEADER", key = "c",  action = petruterm.action.NewTab },
    { mods = "LEADER", key = "&",  action = petruterm.action.CloseTab },
    { mods = "LEADER", key = "n",  action = petruterm.action.NextTab },
    { mods = "LEADER", key = "b",  action = petruterm.action.PrevTab },
    { mods = "LEADER", key = ",",  action = petruterm.action.RenameTab },

    -- ── Pane splits (tmux-style) ───────────────────────────────────────────
    { mods = "LEADER", key = "%",  action = petruterm.action.SplitHorizontal },
    { mods = "LEADER", key = '"',  action = petruterm.action.SplitVertical },
    { mods = "LEADER", key = "x",  action = petruterm.action.ClosePane },

    -- ── Pane focus (vim-style) ─────────────────────────────────────────────
    { mods = "LEADER", key = "h",  action = petruterm.action.FocusPaneLeft },
    { mods = "LEADER", key = "j",  action = petruterm.action.FocusPaneDown },
    { mods = "LEADER", key = "k",  action = petruterm.action.FocusPaneUp },
    { mods = "LEADER", key = "l",  action = petruterm.action.FocusPaneRight },
  }
end

return module
