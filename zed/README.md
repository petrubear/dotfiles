# Zed

Zed editor configuration with Vim mode, Dracula Pro theme, and Neovim-style keybindings.

## Dependencies

- [Zed](https://zed.dev/) -- the editor itself
- [Dracula Pro theme](https://draculatheme.com/pro) -- paid color theme (custom theme file at `themes/dracula_pro.json`)
- [Material Icon Theme](https://zed.dev/extensions/material-icon-theme) -- file/folder icons
- [Monolisa font](https://www.monolisa.dev/) -- buffer font (15px); MonoLisa Nerd Font for terminal (14px)

## Editor Settings

- **Base keymap**: JetBrains
- **Vim mode**: Enabled
- **Buffer font**: MonoLisa, 15px
- **UI font size**: 16px
- **Terminal font**: MonoLisa Nerd Font, 14px
- **Line numbers**: Relative (with auto-toggle via `toggle_relative_line_numbers`)
- **Gutter line numbers**: Enabled
- **Minimap**: Never shown
- **Edit predictions**: Shown
- **Smart case find**: Enabled
- **Icon theme**: Material Icon Theme
- **Theme**: Dracula Pro (dark), Dracula Pro Alucard (light), follows system mode
- **Telemetry**: Diagnostics and metrics both disabled

## Keybindings

Defined in `keymap.json`. Leader key is `Space` (used in Vim normal/visual modes).

### Workspace

| Keybind | Action | Context |
|---------|--------|---------|
| `Shift Shift` | Toggle file finder | Workspace |
| `Space e e` | Toggle left dock (file explorer) | Workspace |
| `Space a a` | Toggle right dock (AI panel) | Workspace |

### General (Vim Normal)

| Keybind | Action |
|---------|--------|
| `Space n h` | Select all search matches (clear highlights) |

### Window / Split Management (Vim Normal)

| Keybind | Action |
|---------|--------|
| `Space s v` | Split right (vertical) |
| `Space s h` | Split down (horizontal) |
| `Space s x` | Close current split |

### Tab Management (Vim Normal)

| Keybind | Action |
|---------|--------|
| `Space t o` | New file (open tab) |
| `Space t x` | Close current tab |
| `Space t n` | Next tab |

### LSP (Vim Normal)

| Keybind | Action |
|---------|--------|
| `Space g d` | Go to definition |
| `Space g D` | Go to declaration |
| `Space g i` | Go to implementation |
| `Space g t` | Go to type definition |
| `Space g r` | Find all references |
| `Space g g` | Hover documentation |
| `Space g f` | Format file |
| `Space g a` | Toggle code actions |
| `Space g l` | Line diagnostic (hover) |
| `Space r r` | Rename symbol |
| `Space r n` | Rename symbol (alternate) |
| `Space c a` | Toggle code actions (alternate) |
| `Space D` | Deploy diagnostics panel |
| `Space d` | Line diagnostic (hover) |
| `Space t r` | Toggle outline (document symbols) |
| `Space m p` | Format file (alternate) |
| `Space r s` | Restart language server |

### LSP (Vim Visual)

| Keybind | Action |
|---------|--------|
| `Space g f` | Format selection |
| `Space c a` | Code action on selection |
| `Space m p` | Format selection (alternate) |

### Search / Telescope Equivalents (Vim Normal)

| Keybind | Action |
|---------|--------|
| `Space f f` | Find files (fuzzy finder) |
| `Space f r` | Find recent files |
| `Space f s` | Live grep (search in project) |
| `Space f c` | Find string under cursor |

### File Explorer (Vim Normal)

| Keybind | Action |
|---------|--------|
| `Space e c` | Collapse all entries in project panel |

### Diagnostics (Vim Normal)

| Keybind | Action |
|---------|--------|
| `Space x w` | Workspace diagnostics |
| `Space x d` | Document diagnostics |

### Insert Mode

| Keybind | Action |
|---------|--------|
| `Ctrl-Space` | Trigger completion manually |

## Files

| File | Purpose |
|------|---------|
| `settings.json` | Editor configuration (theme, font, vim, telemetry) |
| `keymap.json` | Custom keybindings (Neovim-style leader maps) |
| `themes/dracula_pro.json` | Custom Dracula Pro theme definition |

## Installation

Symlink to the Zed config directory:

```sh
ln -s ~/dotfiles/zed/settings.json ~/.config/zed/settings.json
ln -s ~/dotfiles/zed/keymap.json ~/.config/zed/keymap.json
mkdir -p ~/.config/zed/themes
ln -s ~/dotfiles/zed/themes/dracula_pro.json ~/.config/zed/themes/dracula_pro.json
```
