#!/usr/bin/env bash
# Installs odin into user-scope ~/.claude: imports CLAUDE.md and symlinks skills.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
IMPORT_LINE="@$REPO_DIR/CLAUDE.md"

mkdir -p "$CLAUDE_DIR/skills"

# CLAUDE.md
touch "$CLAUDE_DIR/CLAUDE.md"
if grep -qxF "$IMPORT_LINE" "$CLAUDE_DIR/CLAUDE.md"; then
  echo "CLAUDE.md already linked - $IMPORT_LINE"
else
  echo "$IMPORT_LINE" >> "$CLAUDE_DIR/CLAUDE.md"
  echo "CLAUDE.md linked - $IMPORT_LINE"
fi

# Skills
for skill in "$REPO_DIR"/skills/*/; do
  skill="${skill%/}"
  ln -sfn "$skill" "$CLAUDE_DIR/skills/"
  echo "skill linked - $(basename "$skill")"
done
