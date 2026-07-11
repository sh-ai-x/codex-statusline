#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

config="$tmp/config.toml"
printf '%s\n' 'model = "gpt-5.5"' '' '[tui]' 'animations = false' > "$config"

CODEX_CONFIG_FILE="$config" "$root/install.sh" >/dev/null
grep -q '"git-branch"' "$config"
grep -q 'animations = false' "$config"

CODEX_CONFIG_FILE="$config" "$root/install.sh" >/dev/null
[[ "$(grep -c '^status_line = ' "$config")" == 1 ]]

CODEX_CONFIG_FILE="$config" "$root/uninstall.sh" >/dev/null
! grep -q '^status_line = ' "$config"
grep -q 'animations = false' "$config"
grep -q 'model = "gpt-5.5"' "$config"

echo "All tests passed."
