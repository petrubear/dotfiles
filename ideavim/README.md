# IdeaVim

Vim emulation plugin configuration for JetBrains IDEs (IntelliJ IDEA, WebStorm, etc.).

## Dependencies

- A JetBrains IDE with the [IdeaVim plugin](https://plugins.jetbrains.com/plugin/164-ideavim) installed

## Configuration

| Setting | Value |
|---------|-------|
| Leader key | `Space` |
| Line numbers | Relative |
| Scroll offset | 5 lines |
| Search | Incremental, smart case, highlight, wrap |
| IdeaJoin | Enabled (smart line joining) |
| Idea status icon | Enabled |
| Idea refactor mode | `select` |
| Select mode | mouse, key, cmd, ideaselection |
| Key model | startsel, continueselect, stopselect |
| Match pairs | `()`, `{}`, `[]`, `<>`, `/* */` |

### Auto Line Number Toggle

An `augroup` automatically switches between relative numbers (normal mode) and absolute numbers (insert mode).

## Plugins

| Plugin | Purpose |
|--------|---------|
| `easymotion` | Quick word/character jumping |
| `multiple-cursors` | Multi-cursor editing |
| `commentary` | Toggle comments (`gc`) |
| `sneak` | Two-character motion search |
| `highlightedyank` | Highlight yanked text (1000 ms duration) |

## Keybindings

### EasyMotion

| Keybind | Action | Mode |
|---------|--------|------|
| `<Leader><Leader>w` | Jump to word forward | Normal, Visual |
| `<Leader><Leader>b` | Jump to word backward | Normal, Visual |

### Clipboard

| Keybind | Action | Mode |
|---------|--------|------|
| `<Leader>y` | Yank to primary selection (`"*`) | Normal, Visual |
| `<Leader>p` | Paste from primary selection (`"*`) | Normal, Visual |
| `<Leader>Y` | Yank to system clipboard (`"+`) | Normal, Visual |
| `<Leader>P` | Paste from system clipboard (`"+`) | Normal, Visual |

### Project Explorer

| Keybind | Action | Mode |
|---------|--------|------|
| `<Leader>ee` | Activate project tool window | Normal |
| `<Leader>ef` | Select current file in project view | Normal |
| `<Leader>ec` | Collapse all tool windows | Normal |
| `<Leader>er` | Synchronize/refresh project | Normal |

### Other

| Keybind | Action | Mode |
|---------|--------|------|
| `Q` | Format text (remapped from `gq`) | Normal, Visual |
