# Kiro IDE

Kiro IDE (AWS) editor settings. Follows the same VSCode-style `settings.json` format with Vim keybindings, Dracula Pro theme, and Kiro-specific agent configuration.

## Dependencies

- [Kiro IDE](https://kiro.dev/) -- AWS AI-powered IDE
- Vim extension -- Vim keybindings (bundled or marketplace)
- [Dracula Pro theme](https://draculatheme.com/pro) -- paid color theme
- [Material Icon Theme](https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme) -- file/folder icons
- [Monolisa font](https://www.monolisa.dev/) -- editor font (15px); Monolisa Nerd Font for terminal (14px)

## Editor Settings

- **Font**: Monolisa, 15px, with ligatures and font variations enabled
- **Terminal font**: Monolisa Nerd Font, 14px, with ligatures
- **Line numbers**: Relative
- **Line height**: 20
- **Minimap**: Disabled
- **Activity bar**: Top position
- **Accessibility support**: Off
- **JSON schema download**: Enabled

## Kiro-Specific Settings

- **Agent autonomy**: `Supervised` -- requires approval before executing actions
- **Trusted Maven commands**: `mvn clean compile`, `mvn test`, `mvn compile -q`

## Telemetry

All telemetry is disabled:

- `telemetry.dataSharingAndPromptLogging.contentCollectionForServiceImprovement`: false
- `telemetry.dataSharingAndPromptLogging.usageAnalyticsAndPerformanceMetrics`: false
- `telemetry.feedback.enabled`: false

## Keybindings

Leader key: `Space`

| Keybind | Action | Mode |
|---------|--------|------|
| `<leader>ee` | Toggle sidebar visibility | Normal |
| `<leader>ef` | Show active file in explorer | Normal |
| `<leader>er` | Refresh file explorer | Normal |
| `<leader>zz` | Toggle Zen mode | Normal |
| `Ctrl-h` | Focus left editor group | Normal |
| `Ctrl-j` | Focus below editor group | Normal |
| `Ctrl-k` | Focus above editor group | Normal |
| `Ctrl-l` | Focus right editor group | Normal |

### Vim Plugin Settings

- **Easymotion**: Enabled
- **Highlighted yank**: Enabled
- **Search highlight** (`hlsearch`): Enabled
- **System clipboard**: Enabled
- **Handled keys**: `Ctrl-d` (true), `Ctrl-s` (false), `Ctrl-z` (false)

## Installation

```sh
ln -s ~/dotfiles/kiro/User/settings.json ~/Library/Application\ Support/Kiro/User/settings.json
```
