#!/usr/bin/env bash
# Uninstalls odin from user-scope ~/.claude: removes the CLAUDE.md import and skill symlinks.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
IMPORT_LINE="@$REPO_DIR/CLAUDE.md"
COMMENT_LINE="<!-- Managed by odin bin/install.sh, do not edit or delete by hand. Run bin/uninstall.sh to remove. -->"

# CLAUDE.md
if [ -f "$CLAUDE_DIR/CLAUDE.md" ] && grep -qxF "$IMPORT_LINE" "$CLAUDE_DIR/CLAUDE.md"; then
  tmp="$(mktemp)"
  grep -vxF -e "$IMPORT_LINE" -e "$COMMENT_LINE" "$CLAUDE_DIR/CLAUDE.md" > "$tmp" || true
  cat "$tmp" > "$CLAUDE_DIR/CLAUDE.md"
  rm "$tmp"
  echo "CLAUDE.md unlinked - $IMPORT_LINE"
else
  echo "CLAUDE.md not linked - $IMPORT_LINE"
fi

# Remove broken skill symlinks
for link in "$CLAUDE_DIR"/skills/*; do
  if [ -L "$link" ] && [ ! -e "$link" ]; then
    rm "$link"
    echo "skill broken link removed - $(basename "$link")"
  fi
done

# Skills: remove only symlinks that point into this repo
for link in "$CLAUDE_DIR"/skills/*; do
  [ -L "$link" ] || continue
  case "$(readlink "$link")" in
    "$REPO_DIR"/skills/*)
      rm "$link"
      echo "skill unlinked - $(basename "$link")"
      ;;
  esac
done
