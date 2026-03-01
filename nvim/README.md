# Neovim

Primary editor configuration using Lazy.nvim as the plugin manager. Leader key is `Space`. Colorscheme is Dracula Pro (paid, locally installed). Lazy.nvim auto-bootstraps by cloning itself on first run. The `lazy-lock.json` lockfile is gitignored to always run the latest plugin versions.

## Dependencies

- `neovim` (install via `brew install neovim`)
- Dracula Pro theme must be manually installed to `~/.local/share/nvim/site/pack/themes/start/dracula_pro`
- A Nerd Font (Monolisa Nerd Font recommended)
- `ripgrep` for Telescope live grep (`brew install ripgrep`)
- `make` for telescope-fzf-native and LuaSnip jsregexp builds

## Structure

```
nvim/
├── init.lua                  # Entry point: loads core, lazy, lsp
└── lua/edison/
    ├── core/
    │   ├── init.lua          # Loads options + keymaps
    │   ├── options.lua       # Editor settings
    │   └── keymaps.lua       # Global keymaps
    ├── lazy.lua              # Lazy.nvim bootstrap + setup
    ├── lsp.lua               # LspAttach keymaps + diagnostic signs
    └── plugins/
        ├── init.lua          # plenary, vim-tmux-navigator
        ├── alpha.lua          ... (and 27 more plugin specs)
        └── lsp/
            ├── lsp.lua       # cmp-nvim-lsp capabilities
            └── mason.lua     # LSP server + tool installer
```

## Plugins

| Plugin | Author | Purpose |
|--------|--------|---------|
| lazy.nvim | folke | Plugin manager (auto-bootstraps) |
| dracula_pro | Dracula | Active colorscheme (paid, local dir) |
| dracula.nvim | Mofiqul | Fallback colorscheme (disabled) |
| nvim-tree.lua | nvim-tree | File explorer (width 50, relative numbers) |
| telescope.nvim | nvim-telescope | Fuzzy finder (branch 0.1.x) |
| telescope-fzf-native.nvim | nvim-telescope | FZF sorter for Telescope |
| nvim-treesitter | nvim-treesitter | Syntax highlighting and parsing |
| nvim-cmp | hrsh7th | Autocompletion engine |
| cmp-nvim-lsp | hrsh7th | LSP completion source |
| cmp-buffer | hrsh7th | Buffer text completion source |
| cmp-path | hrsh7th | File path completion source |
| LuaSnip | L3MON4D3 | Snippet engine |
| cmp_luasnip | saadparwaiz1 | Snippet completion source |
| friendly-snippets | rafamadriz | VSCode-style snippet collection |
| lspkind.nvim | onsails | VSCode-like pictograms in completion menu |
| mason.nvim | williamboman | LSP/tool installer UI |
| mason-lspconfig.nvim | williamboman | Bridge between Mason and lspconfig |
| mason-tool-installer.nvim | WhoIsSethDaniel | Auto-install formatters, linters, DAP adapters |
| nvim-lspconfig | neovim | LSP configuration |
| nvim-lsp-file-operations | antosha417 | File operation support for LSP |
| lazydev.nvim | folke | Lua dev environment for Neovim config |
| conform.nvim | stevearc | Code formatting (format-on-save) |
| nvim-lint | mfussenegger | Async linting |
| lualine.nvim | nvim-lualine | Status line (Dracula theme, powerline separators) |
| bufferline.nvim | akinsho | Tab bar (tabs mode, auto-hide) |
| gitsigns.nvim | lewis6991 | Git gutter signs, hunk actions |
| flash.nvim | folke | Motion/jump navigation |
| trouble.nvim | folke | Diagnostics list and quickfix |
| todo-comments.nvim | folke | Highlight and search TODO comments |
| which-key.nvim | folke | Keymap hints popup (1500ms delay) |
| noice.nvim | folke | UI for messages, cmdline, popupmenu |
| nvim-notify | rcarriga | Notification UI (Dracula background) |
| nui.nvim | MunifTanjim | UI component library |
| dressing.nvim | stevearc | Improved vim.ui.select/input |
| nvim-autopairs | windwp | Auto-close brackets (Treesitter-aware) |
| nvim-surround | kylechui | Surround text objects |
| rainbow-delimiters.nvim | HiPhish | Colored bracket pairs (Dracula colors) |
| indent-blankline.nvim | lukas-reineke | Indent guides (char: `┊`) |
| vim-highlightedyank | machakann | Highlight yanked text (500ms) |
| nvim-material-icon | DaikyXendo | Material file type icons |
| plenary.nvim | nvim-lua | Lua utility library |
| vim-tmux-navigator | christoomey | Tmux/split window navigation |
| nvim-jdtls | mfussenegger | Java LSP (Eclipse JDTLS) |
| nvim-dap | mfussenegger | Debug Adapter Protocol client |
| nvim-dap-ui | rcarriga | DAP UI (scopes, stacks, watches, breakpoints) |
| nvim-dap-virtual-text | theHamsta | Inline variable values while debugging |
| telescope-dap.nvim | nvim-telescope | Telescope integration for DAP |
| nvim-nio | nvim-neotest | Async IO library (DAP dependency) |
| avante.nvim | yetone | AI assistant (OpenRouter provider, Qwen model) |

## LSP Servers (Mason)

Automatically installed via `mason-lspconfig`:

- `eslint` -- JavaScript/TypeScript linting
- `gradle_ls` -- Gradle build files
- `jdtls` -- Java (Eclipse JDT Language Server)
- `lua_ls` -- Lua
- `marksman` -- Markdown
- `pyright` -- Python
- `yamlls` -- YAML

## Formatters and Linters (Mason)

Automatically installed via `mason-tool-installer`:

| Tool | Type | Languages |
|------|------|-----------|
| prettier | Formatter | JS, TS, JSX, TSX, CSS, HTML, JSON, YAML, Markdown, GraphQL, Liquid |
| stylua | Formatter | Lua |
| black | Formatter | Python |
| isort | Formatter | Python (import sorting) |
| eslint_d | Linter | JavaScript/TypeScript |
| pylint | Linter | Python |
| shellcheck | Linter | Shell scripts |
| java-debug-adapter | DAP | Java debugging |
| java-test | DAP | Java test runner |

## Treesitter Parsers

Automatically installed: bash, css, dockerfile, gitignore, graphql, html, java, javascript, json, kotlin, lua, markdown, markdown_inline, prisma, python, query, tsx, typescript, vim, vimdoc, yaml. Zsh files use the bash parser.

## Keybindings

### General (keymaps.lua)

| Keybind | Action | Mode |
|---------|--------|------|
| `jk` | Exit insert mode | Insert |
| `<leader>nh` | Clear search highlights | Normal |
| `<leader>+` | Increment number | Normal |
| `<leader>-` | Decrement number | Normal |

### Window Management

| Keybind | Action | Mode |
|---------|--------|------|
| `<leader>sv` | Split window vertically | Normal |
| `<leader>sh` | Split window horizontally | Normal |
| `<leader>se` | Make splits equal size | Normal |
| `<leader>sx` | Close current split | Normal |

### Tab Management

| Keybind | Action | Mode |
|---------|--------|------|
| `<leader>to` | Open new tab | Normal |
| `<leader>tx` | Close current tab | Normal |
| `<leader>tn` | Go to next tab | Normal |
| `<leader>tp` | Go to previous tab | Normal |
| `<leader>tf` | Open current buffer in new tab | Normal |

### LSP (keymaps.lua -- global)

| Keybind | Action | Mode |
|---------|--------|------|
| `<leader>gg` | Hover documentation | Normal |
| `<leader>gd` | Go to definition | Normal |
| `<leader>gD` | Go to declaration | Normal |
| `<leader>gi` | Go to implementation | Normal |
| `<leader>gt` | Go to type definition | Normal |
| `<leader>gr` | Show references | Normal |
| `<leader>gs` | Signature help | Normal |
| `<leader>rr` | Rename symbol | Normal |
| `<leader>gf` | Format file | Normal, Visual |
| `<leader>ga` | Code action | Normal |
| `<leader>gl` | Open float diagnostic | Normal |
| `<leader>gp` | Go to previous diagnostic | Normal |
| `<leader>gn` | Go to next diagnostic | Normal |
| `<leader>tr` | Document symbols | Normal |
| `<C-Space>` | Trigger completion | Insert |

### LSP (lsp.lua -- buffer-local on LspAttach)

| Keybind | Action | Mode |
|---------|--------|------|
| `gR` | Show LSP references (Telescope) | Normal |
| `gD` | Go to declaration | Normal |
| `gd` | Go to definition | Normal |
| `gi` | Show LSP implementations (Telescope) | Normal |
| `gt` | Show LSP type definitions (Telescope) | Normal |
| `<leader>ca` | Code action | Normal, Visual |
| `<leader>rn` | Smart rename | Normal |
| `<leader>D` | Show buffer diagnostics (Telescope) | Normal |
| `<leader>d` | Show line diagnostics | Normal |
| `[d` | Go to previous diagnostic | Normal |
| `]d` | Go to next diagnostic | Normal |
| `K` | Show documentation for cursor | Normal |
| `<leader>rs` | Restart LSP | Normal |

### Java-Specific (keymaps.lua)

| Keybind | Action | Mode |
|---------|--------|------|
| `<leader>go` | Organize imports (jdtls) | Normal |
| `<leader>gu` | Update project config (jdtls) | Normal |
| `<leader>tc` | Test class (jdtls) | Normal |
| `<leader>tm` | Test nearest method (jdtls) | Normal |

### Debugging (DAP)

| Keybind | Action | Mode |
|---------|--------|------|
| `<leader>bb` | Toggle breakpoint | Normal |
| `<leader>bc` | Set conditional breakpoint | Normal |
| `<leader>bl` | Set log point | Normal |
| `<leader>br` | Clear all breakpoints | Normal |
| `<leader>ba` | List breakpoints (Telescope) | Normal |
| `<leader>dc` | Continue | Normal |
| `<leader>dj` | Step over | Normal |
| `<leader>dk` | Step into | Normal |
| `<leader>do` | Step out | Normal |
| `<leader>dd` | Disconnect and close DAP UI | Normal |
| `<leader>dt` | Terminate and close DAP UI | Normal |
| `<leader>dr` | Toggle REPL | Normal |
| `<leader>dl` | Run last | Normal |
| `<leader>di` | Hover variable info | Normal |
| `<leader>d?` | Scopes (centered float) | Normal |
| `<leader>df` | DAP frames (Telescope) | Normal |
| `<leader>dh` | DAP commands (Telescope) | Normal |
| `<leader>de` | Diagnostics errors (Telescope) | Normal |

### Flash (Motion/Jump)

| Keybind | Action | Mode |
|---------|--------|------|
| `s` | Flash jump | Normal, Visual, Operator |
| `S` | Flash Treesitter | Normal, Visual, Operator |
| `r` | Remote Flash | Operator |
| `R` | Treesitter Search | Operator, Visual |
| `<C-s>` | Toggle Flash Search | Command |
| `<Leader><Leader>w` | Flash jump | Normal |
| `<Leader><Leader>b` | Flash jump | Normal |

### File Explorer (nvim-tree)

| Keybind | Action | Mode |
|---------|--------|------|
| `<leader>ee` | Toggle file explorer | Normal |
| `<leader>ef` | Find current file in explorer | Normal |
| `<leader>ec` | Collapse file explorer | Normal |
| `<leader>er` | Refresh file explorer | Normal |

### Telescope (Fuzzy Finder)

| Keybind | Action | Mode |
|---------|--------|------|
| `<leader>ff` | Find files | Normal |
| `<leader>fr` | Find recent files | Normal |
| `<leader>fs` | Live grep (find string) | Normal |
| `<leader>fc` | Find string under cursor | Normal |
| `<leader>ft` | Find TODOs | Normal |
| `<leader>fk` | Find keymaps | Normal |
| `<C-k>` / `<C-j>` | Navigate results up/down | Telescope Insert |
| `<C-q>` | Send to quickfix + Trouble | Telescope Insert |
| `<C-t>` | Open in Trouble | Telescope Insert |

### Gitsigns

| Keybind | Action | Mode |
|---------|--------|------|
| `]h` / `[h` | Next/previous hunk | Normal |
| `<leader>hs` | Stage hunk | Normal, Visual |
| `<leader>hr` | Reset hunk | Normal, Visual |
| `<leader>hS` | Stage buffer | Normal |
| `<leader>hR` | Reset buffer | Normal |
| `<leader>hu` | Undo stage hunk | Normal |
| `<leader>hp` | Preview hunk | Normal |
| `<leader>hb` | Blame line | Normal |
| `<leader>hB` | Toggle line blame | Normal |
| `<leader>hd` | Diff this | Normal |
| `<leader>hD` | Diff this ~ | Normal |
| `ih` | Select hunk (text object) | Operator, Visual |

### Trouble (Diagnostics)

| Keybind | Action | Mode |
|---------|--------|------|
| `<leader>xw` | Workspace diagnostics | Normal |
| `<leader>xd` | Document diagnostics | Normal |
| `<leader>xq` | Quickfix list | Normal |
| `<leader>xl` | Location list | Normal |
| `<leader>xt` | TODOs in Trouble | Normal |

### Formatting and Linting

| Keybind | Action | Mode |
|---------|--------|------|
| `<leader>mp` | Format file or range | Normal, Visual |
| `<leader>l` | Trigger linting | Normal |

### Treesitter Incremental Selection

| Keybind | Action | Mode |
|---------|--------|------|
| `<C-space>` | Init/increment selection | Normal |
| `<BS>` | Decrement selection | Normal |

### Which-Key

| Keybind | Action | Mode |
|---------|--------|------|
| `<leader>?` | Show buffer local keymaps | Normal |

## Editor Options

- Relative line numbers, 2-space indentation (spaces, not tabs)
- Smart case search, incremental search with highlights
- System clipboard (`unnamedplus`), cursorline enabled
- Persistent undo, no swap/backup files
- Split below and right, dark background, true colors
- Update time 250ms, timeout 300ms
- Incremental command preview in split
