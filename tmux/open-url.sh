#!/usr/bin/env bash
set -euo pipefail

url="${1:-}"

# tmux can hand us surrounding punctuation when it extracts a plain-text URL.
# Strip common wrappers/trailing sentence punctuation before opening.
url="$(printf '%s' "$url" | sed -E "s/^[][[:space:]<({[\"'\`]+//; s/[][[:space:]>)}\"'\`.,;:!?]+$//")"

case "$url" in
    http://*|https://*|mailto:*|file://*|ssh://*|git://*) ;;
    www.*) url="https://$url" ;;
    *) exit 0 ;;
esac

if command -v open >/dev/null 2>&1; then
    exec open "$url"
elif command -v xdg-open >/dev/null 2>&1; then
    exec xdg-open "$url"
fi
