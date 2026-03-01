# Antigravity

Antigravity editor configuration. Shares a nearly identical setup with the VSCode config but with a leaner footprint -- no Code Runner, no Copilot settings, and no Jupyter configuration.

## Dependencies

- [Antigravity](https://antigravity.dev/) -- the editor itself
- [Vim extension](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim) -- Vim keybindings
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
- **Python language server**: Default
- **Telemetry**: Fully disabled
- **Extension recommendations**: Ignored

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

## Differences from VSCode Config

- No Code Runner extension or executor map
- No GitHub Copilot settings
- No Jupyter widget configuration
- No inline suggest setting
- Adds `editor.lineHeight: 20`
- Adds `json.schemaDownload.enable: true`
- Adds `python.languageServer: "Default"`

## Installation

```sh
ln -s ~/dotfiles/antigravity/User/settings.json ~/Library/Application\ Support/antigravity/User/settings.json
```
