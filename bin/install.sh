#!/usr/bin/env bash
# Installs odin into user-scope ~/.claude: imports CLAUDE.md and symlinks skills.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
IMPORT_LINE="@$REPO_DIR/CLAUDE.md"
COMMENT_LINE="<!-- Managed by odin bin/install.sh, do not edit or delete by hand. Run bin/uninstall.sh to remove. -->"

mkdir -p "$CLAUDE_DIR/skills"

# CLAUDE.md
touch "$CLAUDE_DIR/CLAUDE.md"
if grep -qxF "$IMPORT_LINE" "$CLAUDE_DIR/CLAUDE.md"; then
  # Ensure the managed comment sits right above the import line
  tmp="$(mktemp)"
  awk -v c="$COMMENT_LINE" -v i="$IMPORT_LINE" '$0 == c { next } $0 == i { print c } { print }' "$CLAUDE_DIR/CLAUDE.md" > "$tmp"
  cat "$tmp" > "$CLAUDE_DIR/CLAUDE.md"
  rm "$tmp"
  echo "CLAUDE.md already linked - $IMPORT_LINE"
else
  printf '%s\n%s\n' "$COMMENT_LINE" "$IMPORT_LINE" >> "$CLAUDE_DIR/CLAUDE.md"
  echo "CLAUDE.md linked - $IMPORT_LINE"
fi

# Skills
echo
echo "SKILLS"
for skill in "$REPO_DIR"/skills/*/; do
  [ -d "$skill" ] || continue # no skills: unmatched glob stays literal
  skill="${skill%/}"
  name="$(basename "$skill")"
  link="$CLAUDE_DIR/skills/$name"
  if [ -L "$link" ] && [ "$(readlink "$link")" = "$skill" ]; then
    echo "  $name - linked"
  elif [ -L "$link" ]; then
    echo "  $name - clash, not linked (link points to $(readlink "$link"))"
  elif [ -e "$link" ]; then
    echo "  $name - clash, not linked ($link exists and is not a link)"
  else
    ln -s "$skill" "$link"
    echo "  $name - ✨ installed"
  fi
done
