# Tmux

Terminal multiplexer configuration with `Ctrl-a` as the prefix key. Uses Catppuccin Mocha theme with a custom Dracula-style background color. Status bar is positioned at the top.

## Dependencies

- `tmux` (`brew install tmux`)
- TPM (Tmux Plugin Manager) -- must be installed manually:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

After installing TPM, open tmux and press `prefix + I` to install plugins.

## Plugins

| Plugin | Author | Purpose |
|--------|--------|---------|
| tpm | tmux-plugins | Plugin manager |
| tmux-sensible | tmux-plugins | Sensible default settings |
| tmux-yank | tmux-plugins | Clipboard integration (mouse yank disabled) |
| tmux-resurrect | tmux-plugins | Session persistence across restarts |
| catppuccin/tmux | catppuccin | Theme (Mocha flavor) |

Note: `tmux-battery` is present but commented out.

## Settings

| Setting | Value |
|---------|-------|
| Prefix | `Ctrl-a` (default `Ctrl-b` is unbound) |
| Mode keys | vi |
| Mouse | Enabled |
| Base index | 1 (windows start at 1) |
| History limit | 1,000,000 lines |
| Escape time | 0 (no delay) |
| Renumber windows | On close |
| Clipboard | System clipboard enabled |
| Status position | Top |
| Detach on destroy | Off (stay in tmux when session closes) |
| Pane borders | Single line |
| Extended keys | CSI-u format (Ghostty compatible) |

## Theme

- **Flavor**: Catppuccin Mocha
- **Background**: `#22212C` (Dracula-inspired)
- **Window status**: Rounded style
- **Status right**: Application name, directory, session, date/time
- **Status left**: Empty

## Keybindings

| Keybind | Action |
|---------|--------|
| `prefix + r` | Reload config |
| `prefix + "` | Split pane vertically (inherits path) |
| `prefix + %` | Split pane horizontally (inherits path) |
| `prefix + c` | New window (inherits path) |
| `prefix + h` | Select pane left |
| `prefix + j` | Select pane down |
| `prefix + k` | Select pane up |
| `prefix + l` | Select pane right |
| `prefix + I` | Install plugins (with notification) |
| `prefix + U` | Update plugins (with notification) |
| `prefix + u` | Clean plugins (with notification) |
| `Ctrl-k` | Clear screen and history (no prefix) |
| `M-@` | Send `@` (Logitech keyboard fix) |
| `M-\` | Send `\` (Logitech keyboard fix) |
| `M-\|` | Send `\|` (Logitech keyboard fix) |

### Copy Mode

- Mouse drag selects and copies to `pbcopy` but stays in copy mode
- Mouse yank via tmux-yank is disabled (`@yank_with_mouse off`)
