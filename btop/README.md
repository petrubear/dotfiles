# btop

Terminal-based system monitor with Dracula theme and braille graph rendering.

## Dependencies

- `btop` -- install via `brew install btop`

## Configuration

### Display

| Setting | Value |
|---------|-------|
| Theme | `dracula` (from `themes/dracula.theme`) |
| Theme background | Enabled |
| Truecolor | Enabled |
| Graph symbol | `braille` (highest resolution) |
| Rounded corners | Enabled |
| Terminal sync | Enabled |
| Shown boxes | `cpu mem net proc` |
| Update interval | 2000 ms |
| Clock format | `%X` (time) |

### CPU

| Setting | Value |
|---------|-------|
| Show uptime | Enabled |
| Show CPU watts | Enabled |
| Show CPU frequency | Enabled |
| Check temperature | Enabled |
| Show core temp | Enabled |
| Temperature scale | Celsius |
| Invert lower graph | Enabled |

### Memory and Disks

| Setting | Value |
|---------|-------|
| Memory graphs | Enabled |
| Show swap | Enabled |
| Show disks | Enabled |
| Show IO stats | Enabled |
| Only physical disks | Enabled |

### Network

| Setting | Value |
|---------|-------|
| Auto rescaling | Enabled |
| Sync download/upload | Enabled |

### Processes

| Setting | Value |
|---------|-------|
| Sorting | By memory |
| Process colors | Enabled |
| Process gradient | Enabled |
| Show CPU graphs | Enabled |
| Memory as bytes | Enabled |
| Vim keys | Disabled |

### Battery

| Setting | Value |
|---------|-------|
| Show battery | Enabled |
| Show battery watts | Enabled |

### Presets

Three layout presets are configured:

1. `cpu:1:default,proc:0:default` -- CPU and processes
2. `cpu:0:default,mem:0:default,net:0:default` -- CPU, memory, and network
3. `cpu:0:block,net:0:tty` -- CPU (block graph) and network (tty graph)
