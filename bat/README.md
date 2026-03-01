# bat

A `cat` replacement with syntax highlighting, configured to use the Dracula theme.

## Dependencies

- `bat` -- install via `brew install bat`

## Configuration

Single-line config file:

```
--theme="Dracula"
```

This sets the Dracula color scheme for all syntax-highlighted output. The bat theme integrates with `less` via the `LESSOPEN` environment variable configured in the zsh config.
