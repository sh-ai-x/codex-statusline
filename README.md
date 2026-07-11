# codex-statusline

A one-command status line setup for the Codex CLI, inspired by
[`sh-ai-x/claude-statusline`](https://github.com/sh-ai-x/claude-statusline).

It configures Codex's native TUI status line with:

```text
gpt-5.5 high · codex-statusline · main · Context 82% left · 5h 16% · weekly 12% · fast
```

- model and reasoning effort
- current directory
- Git branch
- context remaining
- five-hour and weekly usage limits
- fast mode
- theme-aware colors

## Install

Requirements: Codex CLI, Python 3, and Git.

```bash
git clone https://github.com/sh-ai-x/codex-statusline.git
cd codex-statusline
./install.sh
```

Restart Codex after installation. You can also use `/statusline` inside the Codex
TUI to adjust the selected fields interactively.

The installer updates `~/.codex/config.toml` (or `$CODEX_HOME/config.toml`) and
creates a timestamped backup first. To target another config file:

```bash
CODEX_CONFIG_FILE=/path/to/config.toml ./install.sh
```

## Uninstall

```bash
./uninstall.sh
```

Uninstall removes only the two settings managed by this project and preserves
other values in `[tui]`.

## How it works

Codex currently supports an ordered list of native status line items:

```toml
[tui]
status_line = [
  "model-with-reasoning",
  "current-dir",
  "git-branch",
  "context-remaining",
  "five-hour-limit",
  "weekly-limit",
  "fast-mode",
]
status_line_use_colors = true
```

Unlike Claude Code, Codex does not currently support a command-backed status
line that reads session JSON from stdin. Consequently, arbitrary formatting,
custom progress bars, Git dirty state, and multiple output lines are not
available. This project uses the supported native configuration so it remains
fast and reliable.

## License

MIT
