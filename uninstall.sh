#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
CONFIG_FILE="${CODEX_CONFIG_FILE:-$CODEX_HOME/config.toml}"

[[ -f "$CONFIG_FILE" ]] || {
  echo "Nothing to uninstall: $CONFIG_FILE does not exist."
  exit 0
}

backup="${CONFIG_FILE}.bak.$(date +%Y%m%d%H%M%S)"
cp "$CONFIG_FILE" "$backup"

python3 - "$CONFIG_FILE" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text()
tui = re.search(r'(?ms)^\[tui\]\s*\n(.*?)(?=^\[|\Z)', text)
if tui:
    body = tui.group(1)
    body = re.sub(r'(?ms)^status_line\s*=\s*\[.*?^\]\s*\n?', '', body)
    body = re.sub(r'(?m)^status_line_use_colors\s*=.*\n?', '', body)
    replacement = '[tui]\n' + body.rstrip() + '\n\n' if body.strip() else ''
    text = text[:tui.start()] + replacement + text[tui.end():].lstrip('\n')
path.write_text(text.rstrip() + ('\n' if text.strip() else ''))
PY

echo "Codex status line settings removed from $CONFIG_FILE"
echo "Backup: $backup"
