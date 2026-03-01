# Fish

Secondary shell with a minimal configuration. Mirrors zsh aliases for consistency when switching between shells.

## Dependencies

- `fish` (`brew install fish`)
- `starship` (`brew install starship`)
- `zoxide` (`brew install zoxide`)
- `eza` (`brew install eza`)
- `kubecolor` (`brew install kubecolor`)
- `tspin` (`brew install tailspin`)
- `neovim` (`brew install neovim`)

## Structure

```
fish/
├── config.fish       # Entry point: zoxide, starship, aliases
├── aliases.fish      # Alias definitions
├── conf.d/           # Auto-loaded config fragments
├── completions/      # Custom completions (empty)
└── functions/
    └── jarscan.fish  # JAR file scanning function
```

## Aliases

| Alias | Expands To | Purpose |
|-------|-----------|---------|
| `vi` | `nvim` | Use Neovim |
| `vim` | `nvim` | Use Neovim |
| `nano` | `nvim` | Use Neovim |
| `ls` | `eza --icons` | Modern ls with icons |
| `list` | `eza -bghl --git --icons --color=automatic` | Detailed listing with git info |
| `fp` | `ps aux \| grep` | Find process |
| `ant` | `ant -logger ...AnsiColorLogger` | Colored Ant output |
| `ct` | `pygmentize -O style=borland` | Syntax highlighting |
| `kubectl` | `kubecolor` | Colored kubectl |
| `tail` | `tspin` | Modern tail with highlighting |
| `j` | `z` (zoxide) | Smart directory jump |

## Initialization

The `config.fish` initializes two tools in interactive mode:

1. `zoxide init fish | source` -- smart directory jumping
2. `starship init fish | source` -- cross-shell prompt

Aliases are then sourced from `~/.config/fish/aliases.fish`.
