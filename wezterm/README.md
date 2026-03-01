# WezTerm

Alternative terminal emulator with a modular Lua configuration. The entry point (`wezterm.lua`) composes separate modules using the `apply_to_config(config)` pattern.

## Dependencies

- WezTerm (https://wezfurlong.org/wezterm/)
- Monolisa Nerd Font (paid font, must be installed manually)
- A `colors.lua` module providing the Dracula Pro color palette (not included in this repo)

## Structure

```
wezterm/
├── wezterm.lua     # Entry point — composes ui.lua + perf.lua
├── ui.lua          # Appearance: font, colors, window, tab bar
├── perf.lua        # Performance: scrollback, GPU, animations
└── keybinds.lua    # Tmux-style keybindings (DISABLED in entry point)
```

Each module exports `{ apply_to_config = function(config) ... end }`. The entry point creates an empty config table and passes it through each active module.

## Active Modules

### ui.lua -- Appearance

| Setting | Value |
|---------|-------|
| Color scheme | Dracula Pro |
| Font | Monolisa Nerd Font, 16px |
| Font features | `calt=1`, `liga=1`, `dlig=1` (ligatures) |
| Tab bar | Hidden when only one tab |
| Window decorations | Resize only (no titlebar) |
| Window padding | Left/Right 20px, Top 30px, Bottom 10px |
| Close confirmation | Never prompt |
| Quit behavior | Quit when all windows closed |
| Startup | Maximized |
| macOS fullscreen | Native fullscreen disabled |

### perf.lua -- Performance

| Setting | Value |
|---------|-------|
| Scrollback | 100,000 lines |
| Scroll bar | Enabled |
| Animation FPS | 1 (effectively disabled) |
| Frontend | WebGPU |
| GPU preference | High performance |

## Disabled Module: keybinds.lua

The keybinds module is commented out in `wezterm.lua` but preserved for reference. It defines tmux-style bindings with `Ctrl-a` as the leader key.

### Keybindings (reference only, currently disabled)

| Keybind | Action |
|---------|--------|
| `Leader + "` | Split vertical |
| `Leader + %` | Split horizontal |
| `Leader + s` | Split vertical (alias) |
| `Leader + v` | Split horizontal (alias) |
| `Leader + h/j/k/l` | Navigate panes (vim-style) |
| `Leader + H/J/K/L` | Resize panes by 5 |
| `Leader + Arrow keys` | Navigate panes |
| `Leader + 1-9` | Switch to tab by number |
| `Leader + c` | New tab |
| `Leader + o` / `Leader + z` | Toggle pane zoom |
| `Leader + d` / `Leader + x` | Close pane |
| `Leader + &` | Close tab |
| `Leader + Ctrl-a` | Send raw `Ctrl-b` |
