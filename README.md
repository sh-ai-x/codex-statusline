# codex-statusline

A one-command status line setup for the Codex CLI, inspired by
[`sh-ai-x/claude-statusline`](https://github.com/sh-ai-x/claude-statusline).

It configures Codex's native TUI status line with:

```text
gpt-5.5 high · codex-statusline · ~/dev/codex-statusline · main · Context 82% left · 5h 16% · weekly 12% · fast
```

- model and reasoning effort
- project root and current directory
- Git branch
- context remaining
- context window size
- total, input, and output token counts
- five-hour and weekly usage limits
- Codex CLI version
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
  "project-root",
  "current-dir",
  "git-branch",
  "context-remaining",
  "context-window-size",
  "used-tokens",
  "total-input-tokens",
  "total-output-tokens",
  "five-hour-limit",
  "weekly-limit",
  "codex-version",
  "fast-mode",
]
status_line_use_colors = true
```

Unlike Claude Code, Codex does not currently support a command-backed status
line that reads session JSON from stdin. Consequently, arbitrary formatting,
custom progress bars, Git dirty state, and multiple output lines are not
available. The native status line is a single ordered row; adding `\n` or a
second `status_line` value does not create a second row. This project therefore
enables the additional native metrics that Codex exposes, while keeping the
configuration fast and reliable. If Codex adds a command-backed or multi-line
status line in a future release, it can be adopted here without changing the
installer interface.

The additional items require a recent Codex CLI. If an older CLI reports an
unknown status-line item, remove the newer items or run `/statusline` to choose
only the fields supported by that version.

## License

MIT
