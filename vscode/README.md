# VSCode

Visual Studio Code editor configuration with Vim keybindings, Dracula Pro theme, and Code Runner support for 40+ languages.

## Dependencies

- [VSCode](https://code.visualstudio.com/) -- the editor itself
- [Vim extension](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim) -- `vim.leader`, `vim.easymotion`, etc. settings require this
- [Dracula Pro theme](https://draculatheme.com/pro) -- paid theme (`workbench.colorTheme`)
- [Material Icon Theme](https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme) -- file icon theme
- [Code Runner](https://marketplace.visualstudio.com/items?itemName=formulahpp.vscode-code-runner) -- run code snippets in 40+ languages
- [Monolisa font](https://www.monolisa.dev/) -- editor font (15px); Monolisa Nerd Font for terminal (14px)

## Extensions Referenced

| Extension | Purpose |
|-----------|---------|
| Vim | Vi keybindings with easymotion, highlighted yank, system clipboard |
| Code Runner | Execute code in-editor for C, C++, Java, Python, Go, Rust, JS, TS, and 30+ more |
| Dracula Pro | Dark color theme |
| Material Icon Theme | File/folder icons |
| GitHub Copilot | Explicitly disabled globally (all file types set to `false` except plaintext) |

## Editor Settings

- **Font**: Monolisa, 15px, with ligatures and font variations enabled
- **Terminal font**: Monolisa Nerd Font, 14px, with ligatures
- **Line numbers**: Relative
- **Minimap**: Disabled
- **Activity bar**: Top position
- **Accessibility support**: Off
- **Inline suggestions**: Enabled
- **Telemetry**: Fully disabled (feedback and telemetry level both off)
- **Python interpreter**: `python3`

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
- **Cursor style**: Block in normal mode
- **Handled keys**: `Ctrl-d` (true), `Ctrl-s` (false, passed to VSCode), `Ctrl-z` (false, passed to VSCode)

## Code Runner

Custom executor map configured for the following languages: AHK, AppleScript, AutoIt, Batch, C, C++, Clojure, CoffeeScript, Crystal, C#, D, Dart, Fortran (4 variants), F#, Go, Groovy, Haskell, Haxe, Java, JavaScript, Julia, Kit, Less, Lisp, Lua, Nim, Objective-C, OCaml, Pascal, Perl, Perl6, PHP, PowerShell, Python, R, Racket, Ruby, Rust, Sass, Scala, Scheme, SCSS, Shell, SML, Swift, TypeScript, V, VBScript, Zig.

AppInsights telemetry for Code Runner is disabled.

## Installation

Symlink to the VSCode config directory:

```sh
ln -s ~/dotfiles/vscode/User/settings.json ~/Library/Application\ Support/Code/User/settings.json
```
