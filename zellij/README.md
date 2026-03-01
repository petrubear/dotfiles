# Zellij

Terminal multiplexer with fully custom keybindings (`clear-defaults=true`) and Dracula theme. All default keybinds are cleared and replaced with a custom configuration across 8+ keybind modes.

## Dependencies

- `zellij` -- install via `brew install zellij`

## Configuration

| Setting | Value |
|---------|-------|
| Theme | `dracula` |
| Startup tips | Disabled |
| Web client font | `monospace` |
| Default keybinds | Cleared (`clear-defaults=true`) |

## Keybindings

### Mode Switching (Global)

These binds are available in all modes except `locked`:

| Keybind | Action |
|---------|--------|
| `Ctrl g` | Switch to locked mode |
| `Ctrl p` | Switch to pane mode |
| `Ctrl t` | Switch to tab mode |
| `Ctrl n` | Switch to resize mode |
| `Ctrl h` | Switch to move mode |
| `Ctrl o` | Switch to session mode |
| `Ctrl s` | Switch to scroll mode |
| `Ctrl b` | Switch to tmux mode |
| `Ctrl q` | Quit zellij |
| `Esc` | Switch to normal mode |
| `Enter` | Switch to normal mode |

### Global Binds (All Modes Except Locked)

| Keybind | Action |
|---------|--------|
| `Alt h` / `Alt Left` | Move focus or tab left |
| `Alt j` / `Alt Down` | Move focus down |
| `Alt k` / `Alt Up` | Move focus up |
| `Alt l` / `Alt Right` | Move focus or tab right |
| `Alt n` | New pane |
| `Alt f` | Toggle floating panes |
| `Alt [` | Previous swap layout |
| `Alt ]` | Next swap layout |
| `Alt +` / `Alt =` | Resize increase |
| `Alt -` | Resize decrease |
| `Alt i` | Move tab left |
| `Alt o` | Move tab right |
| `Alt p` | Toggle pane in group |
| `Alt Shift p` | Toggle group marking |

### Locked Mode

| Keybind | Action |
|---------|--------|
| `Ctrl g` | Switch to normal mode |

### Pane Mode (`Ctrl p`)

| Keybind | Action |
|---------|--------|
| `h` / `Left` | Move focus left |
| `j` / `Down` | Move focus down |
| `k` / `Up` | Move focus up |
| `l` / `Right` | Move focus right |
| `n` | New pane |
| `d` | New pane down |
| `r` | New pane right |
| `s` | New stacked pane |
| `x` | Close focused pane |
| `f` | Toggle fullscreen |
| `w` | Toggle floating panes |
| `z` | Toggle pane frames |
| `e` | Toggle pane embed or floating |
| `i` | Toggle pane pinned |
| `c` | Rename pane |
| `p` | Switch focus |
| `Ctrl p` | Back to normal mode |

### Tab Mode (`Ctrl t`)

| Keybind | Action |
|---------|--------|
| `h` / `Left` / `k` / `Up` | Previous tab |
| `j` / `Down` / `l` / `Right` | Next tab |
| `1`-`9` | Go to tab by number |
| `n` | New tab |
| `x` | Close tab |
| `r` | Rename tab |
| `s` | Toggle sync tab |
| `b` | Break pane to new tab |
| `[` | Break pane left |
| `]` | Break pane right |
| `Tab` | Toggle between last two tabs |
| `Ctrl t` | Back to normal mode |

### Resize Mode (`Ctrl n`)

| Keybind | Action |
|---------|--------|
| `h` / `Left` | Increase left |
| `j` / `Down` | Increase down |
| `k` / `Up` | Increase up |
| `l` / `Right` | Increase right |
| `H` | Decrease left |
| `J` | Decrease down |
| `K` | Decrease up |
| `L` | Decrease right |
| `+` / `=` | Increase |
| `-` | Decrease |
| `Ctrl n` | Back to normal mode |

### Move Mode (`Ctrl h`)

| Keybind | Action |
|---------|--------|
| `h` / `Left` | Move pane left |
| `j` / `Down` | Move pane down |
| `k` / `Up` | Move pane up |
| `l` / `Right` | Move pane right |
| `n` / `Tab` | Move pane (next position) |
| `p` | Move pane backwards |
| `Ctrl h` | Back to normal mode |

### Scroll Mode (`Ctrl s`)

| Keybind | Action |
|---------|--------|
| `j` / `Down` | Scroll down |
| `k` / `Up` | Scroll up |
| `h` / `Left` / `Ctrl b` / `PageUp` | Page scroll up |
| `l` / `Right` / `Ctrl f` / `PageDown` | Page scroll down |
| `d` | Half page scroll down |
| `u` | Half page scroll up |
| `e` | Edit scrollback in editor |
| `s` | Enter search mode |
| `Ctrl c` | Scroll to bottom and return to normal |
| `Ctrl s` | Back to normal mode |

### Search Mode (via Scroll `s`)

| Keybind | Action |
|---------|--------|
| `n` | Search down (next match) |
| `p` | Search up (previous match) |
| `c` | Toggle case sensitivity |
| `w` | Toggle wrap |
| `o` | Toggle whole word |

### Session Mode (`Ctrl o`)

| Keybind | Action |
|---------|--------|
| `w` | Session manager |
| `c` | Configuration |
| `p` | Plugin manager |
| `a` | About |
| `s` | Share |
| `d` | Detach |
| `Ctrl o` | Back to normal mode |

### Tmux Compatibility Mode (`Ctrl b`)

Provides tmux-like keybindings for muscle memory:

| Keybind | Action |
|---------|--------|
| `"` | Split pane down (horizontal) |
| `%` | Split pane right (vertical) |
| `h` / `Left` | Move focus left |
| `j` / `Down` | Move focus down |
| `k` / `Up` | Move focus up |
| `l` / `Right` | Move focus right |
| `c` | New tab |
| `n` | Next tab |
| `p` | Previous tab |
| `x` | Close focused pane |
| `z` | Toggle fullscreen |
| `o` | Focus next pane |
| `d` | Detach |
| `,` | Rename tab |
| `[` | Enter scroll mode |
| `Space` | Next swap layout |
| `Ctrl b` | Send raw `Ctrl b` to terminal |

### Rename Modes

| Keybind | Context | Action |
|---------|---------|--------|
| `Esc` | Rename tab | Undo rename, back to tab mode |
| `Esc` | Rename pane | Undo rename, back to pane mode |
| `Ctrl c` | Either rename mode | Back to normal mode |

## Plugins

| Plugin | Location | Purpose |
|--------|----------|---------|
| `about` | `zellij:about` | About screen |
| `compact-bar` | `zellij:compact-bar` | Compact status bar |
| `configuration` | `zellij:configuration` | Configuration UI |
| `filepicker` | `zellij:strider` | File picker (cwd: `/`) |
| `plugin-manager` | `zellij:plugin-manager` | Plugin management |
| `session-manager` | `zellij:session-manager` | Session management |
| `status-bar` | `zellij:status-bar` | Status bar |
| `strider` | `zellij:strider` | File explorer |
| `tab-bar` | `zellij:tab-bar` | Tab bar |
| `welcome-screen` | `zellij:session-manager` | Welcome screen |
