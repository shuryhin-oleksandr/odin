#!/usr/bin/env bash
# Removes broken skill symlinks in ~/.claude/skills that point into this repo (e.g. deleted or renamed skills).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

removed=0
for link in "$CLAUDE_DIR"/skills/*; do
  [ -L "$link" ] || continue
  [ -e "$link" ] && continue
  case "$(readlink "$link")" in
    "$REPO_DIR"/skills/*)
      rm "$link"
      echo "skill broken link removed - $(basename "$link")"
      removed=$((removed + 1))
      ;;
  esac
done

[ "$removed" -eq 0 ] && echo "No broken symlinks found"
exit 0
