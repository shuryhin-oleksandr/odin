#!/usr/bin/env bash
# Installs odin into user scope: ~/.claude (CLAUDE.md import + skill symlinks) and Codex (~/.codex/AGENTS.md symlink + skill symlinks in ~/.agents/skills).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
CODEX_DIR="$HOME/.codex"
CODEX_SKILLS_DIR="$HOME/.agents/skills"
IMPORT_LINE="@$REPO_DIR/CLAUDE.md"
COMMENT_LINE="<!-- Managed by odin bin/install.sh, do not edit or delete by hand. Run bin/uninstall.sh to remove. -->"

# Green dot in a terminal, plain dot when output is piped or redirected
if [ -t 1 ]; then
  INSTALLED_MARK=$'\033[32m●\033[0m'
else
  INSTALLED_MARK="●"
fi

# Symlinks $1 to $2 unless $2 already exists. $3 is the label printed in the report, $4 the report line indent (default 2 spaces).
link_path() {
  local source="$1" link="$2" label="$3" indent="${4:-  }"
  if [ -L "$link" ] && [ "$(readlink "$link")" = "$source" ]; then
    echo "$indent$label - linked"
  elif [ -L "$link" ]; then
    echo "$indent$label - clash, not linked (link points to $(readlink "$link"))"
  elif [ -e "$link" ]; then
    echo "$indent$label - clash, not linked ($link exists and is not a link)"
  else
    ln -s "$source" "$link"
    echo "${indent}${INSTALLED_MARK} $label - installed"
  fi
}

# Symlinks every repo skill into the given skills directory.
link_skills() {
  local skills_dir="$1"
  mkdir -p "$skills_dir"
  for skill in "$REPO_DIR"/skills/*/; do
    [ -d "$skill" ] || continue # no skills: unmatched glob stays literal
    skill="${skill%/}"
    link_path "$skill" "$skills_dir/$(basename "$skill")" "$(basename "$skill")" "    "
  done
}

echo "CLAUDE"

# CLAUDE.md
mkdir -p "$CLAUDE_DIR"
touch "$CLAUDE_DIR/CLAUDE.md"
if grep -qxF "$IMPORT_LINE" "$CLAUDE_DIR/CLAUDE.md"; then
  # Ensure the managed comment sits right above the import line
  tmp="$(mktemp)"
  awk -v c="$COMMENT_LINE" -v i="$IMPORT_LINE" '$0 == c { next } $0 == i { print c } { print }' "$CLAUDE_DIR/CLAUDE.md" > "$tmp"
  cat "$tmp" > "$CLAUDE_DIR/CLAUDE.md"
  rm "$tmp"
  echo "  CLAUDE.md already linked - $IMPORT_LINE"
else
  printf '%s\n%s\n' "$COMMENT_LINE" "$IMPORT_LINE" >> "$CLAUDE_DIR/CLAUDE.md"
  echo "  CLAUDE.md linked - $IMPORT_LINE"
fi

echo "  skills ($CLAUDE_DIR/skills):"
link_skills "$CLAUDE_DIR/skills"

# Codex has no @import in AGENTS.md, so the whole file is a symlink to the repo CLAUDE.md
echo
echo "CODEX"
mkdir -p "$CODEX_DIR"
link_path "$REPO_DIR/CLAUDE.md" "$CODEX_DIR/AGENTS.md" "AGENTS.md"

echo "  skills ($CODEX_SKILLS_DIR):"
link_skills "$CODEX_SKILLS_DIR"
