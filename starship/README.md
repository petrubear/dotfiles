# Starship

Cross-shell prompt configuration with a custom Dracula color palette and Powerline-style connected segments.

## Dependencies

- `starship` (`brew install starship`)
- A Nerd Font for icons (Monolisa Nerd Font recommended)

## Segment Order

```
OS icon > username > directory > git branch/status > language versions > conda > time > cmd_duration
```

The prompt is single-line (`line_break` is disabled). Segments are connected using Powerline-style foreground/background color transitions.

## Dracula Palette

| Color | Hex |
|-------|-----|
| pink | `#ff79c6` |
| red | `#ff5555` |
| yellow | `#f1fa8c` |
| green | `#50fa7b` |
| blue | `#644ac9` |
| purple | `#bd93f9` |
| cyan | `#8be9fd` |
| comment | `#6272a4` |
| base | `#1e1e2e` |
| mantle | `#181825` |
| crust | `#11111b` |

## Language Detection

Each language module displays a Nerd Font icon and version when a project of that type is detected:

| Language | Icon |
|----------|------|
| Node.js | `` |
| C | ` ` |
| Rust | `` |
| Go | `` |
| PHP | `` |
| Java | ` ` |
| Kotlin | `` |
| Haskell | `` |
| Python | `` (also shows virtualenv name) |
| Docker | `` |

## Directory

- Truncated to 3 segments with `…/` as the truncation symbol
- Icon substitutions for Documents, Downloads, Music, Pictures, Developer

## Vi Mode Indicators

| Symbol | Mode |
|--------|------|
| `>` (green) | Normal / Insert (success) |
| `>` (red) | Normal / Insert (error) |
| `<` (green) | Command |
| `<` (purple) | Replace |
| `<` (yellow) | Visual |

## Other Segments

- **Time**: 12-hour format with AM/PM, clock icon, shown on comment background
- **Cmd duration**: Shows milliseconds, desktop notification after 45 seconds
- **Conda**: Always shown (including base environment), bee icon
- **Git branch**: Branch icon with branch name on pink background
- **Git status**: Ahead/behind and status indicators on pink background
- **OS**: Auto-detected OS icon (macOS, Linux distros, Windows) on purple background
- **Username**: Always shown on purple background
