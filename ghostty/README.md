# Ghostty

Primary terminal emulator configuration. Uses Dracula Pro theme and Monolisa Nerd Font.

## Dependencies

- Ghostty (`brew install --cask ghostty`)
- Monolisa Nerd Font (paid font, must be installed manually)
- Dracula Pro theme file at `themes/pro` (paid theme)

## Settings

| Setting | Value |
|---------|-------|
| Theme | Dracula Pro (loaded from `themes/pro`) |
| Font family | Monolisa Nerd Font |
| Font size | 16 |
| Font style | Medium (regular), Bold, Medium Italic, Bold Italic |
| Font features | `+calt`, `+liga`, `+dlig` (ligatures enabled) |
| Font thicken | Enabled |
| Window | Maximized on launch |
| Titlebar | Hidden (`macos-titlebar-style = hidden`) |
| Padding | 10px on all sides |
| Window save state | Never |
| Shell integration | Auto-detect with cursor, sudo, title features |
| Cursor | Block with blinking |
| Copy on select | Disabled |
| Close confirmation | Disabled |
| Quit behavior | Quit after last window closed |
| Mouse | Hidden while typing |
| macOS Option as Alt | Disabled |

## Keybindings

| Keybind | Action |
|---------|--------|
| `Cmd+T` | New tab |
| `Cmd+W` | Close surface |
| `Cmd+N` | New window |
| `Cmd+Shift+[` | Previous tab |
| `Cmd+Shift+]` | Next tab |
| `Cmd+,` | Go to top split |
| `Shift+Enter` | Send `\x1b\r` (escape + return) |

## Theme Files

- `themes/pro` -- Dracula Pro (active)
- `themes/van-helsing` -- Van Helsing variant (available, commented out)
