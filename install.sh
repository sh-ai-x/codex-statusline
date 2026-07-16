#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
CONFIG_FILE="${CODEX_CONFIG_FILE:-$CODEX_HOME/config.toml}"

command -v codex >/dev/null 2>&1 || {
  echo "error: codex CLI is not installed or not in PATH" >&2
  exit 1
}
command -v python3 >/dev/null 2>&1 || {
  echo "error: python3 is required" >&2
  exit 1
}

mkdir -p "$(dirname "$CONFIG_FILE")"
touch "$CONFIG_FILE"

backup="${CONFIG_FILE}.bak.$(date +%Y%m%d%H%M%S)"
cp "$CONFIG_FILE" "$backup"

python3 - "$CONFIG_FILE" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text()
items = '''status_line = [
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
status_line_use_colors = true'''

tui = re.search(r'(?ms)^\[tui\]\s*\n(.*?)(?=^\[|\Z)', text)
if tui:
    body = tui.group(1)
    body = re.sub(r'(?ms)^status_line\s*=\s*\[.*?^\]\s*\n?', '', body)
    body = re.sub(r'(?m)^status_line_use_colors\s*=.*\n?', '', body)
    replacement = '[tui]\n' + body.rstrip() + ('\n' if body.strip() else '') + items + '\n\n'
    text = text[:tui.start()] + replacement + text[tui.end():].lstrip('\n')
else:
    text = text.rstrip() + ('\n\n' if text.strip() else '') + '[tui]\n' + items + '\n'

path.write_text(text)
PY

if ! python3 -c 'import sys, tomllib; tomllib.load(open(sys.argv[1], "rb"))' "$CONFIG_FILE"; then
  cp "$backup" "$CONFIG_FILE"
  echo "error: generated invalid TOML; restored $backup" >&2
  exit 1
fi

echo "Codex status line installed in $CONFIG_FILE"
echo "Backup: $backup"
echo "Restart Codex, or run /statusline in an active TUI session."
