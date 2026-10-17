#!/usr/bin/env bash
# Uninstalls odin from user scope: ~/.claude (CLAUDE.md import + skill symlinks) and Codex (~/.codex/AGENTS.md symlink + skill symlinks in ~/.agents/skills).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
CODEX_DIR="$HOME/.codex"
CODEX_SKILLS_DIR="$HOME/.agents/skills"
IMPORT_LINE="@$REPO_DIR/CLAUDE.md"
COMMENT_LINE="<!-- Managed by odin bin/install.sh, do not edit or delete by hand. Run bin/uninstall.sh to remove. -->"

# Red dot in a terminal, plain dot when output is piped or redirected
if [ -t 1 ]; then
  REMOVED_MARK=$'\033[31m●\033[0m'
else
  REMOVED_MARK="●"
fi

# Removes symlink $2 if it points to $1. $3 is the label printed in the report.
unlink_path() {
  local source="$1" link="$2" label="$3"
  if [ -L "$link" ] && [ "$(readlink "$link")" = "$source" ]; then
    rm "$link"
    echo "  ${REMOVED_MARK} $label - removed"
  elif [ -L "$link" ]; then
    echo "  $label - clash, not removed (link points to $(readlink "$link"))"
  elif [ -e "$link" ]; then
    echo "  $label - clash, not removed ($link exists and is not a link)"
  else
    echo "  $label - not linked"
  fi
}

# Removes every symlink in the given skills directory that points into this repo, including broken ones.
unlink_skills() {
  local skills_dir="$1" removed_count=0
  for link in "$skills_dir"/*; do
    [ -L "$link" ] || continue # also skips the literal pattern when the directory is empty or missing
    local link_target
    link_target="$(readlink "$link")"
    case "$link_target" in
      "$REPO_DIR"/skills/*)
        rm "$link"
        echo "    ${REMOVED_MARK} ${link_target#"$REPO_DIR/skills/"} - removed" # e.g. research/notes
        removed_count=$((removed_count + 1))
        ;;
    esac
  done
  if [ "$removed_count" -eq 0 ]; then
    echo "    no odin skills linked"
  fi
}

echo "CLAUDE"

# CLAUDE.md
if [ -f "$CLAUDE_DIR/CLAUDE.md" ] && grep -qxF "$IMPORT_LINE" "$CLAUDE_DIR/CLAUDE.md"; then
  tmp="$(mktemp)"
  grep -vxF -e "$IMPORT_LINE" -e "$COMMENT_LINE" "$CLAUDE_DIR/CLAUDE.md" > "$tmp" || true
  cat "$tmp" > "$CLAUDE_DIR/CLAUDE.md"
  rm "$tmp"
  echo "  CLAUDE.md unlinked - $IMPORT_LINE"
else
  echo "  CLAUDE.md not linked - $IMPORT_LINE"
fi

echo "  skills ($CLAUDE_DIR/skills):"
unlink_skills "$CLAUDE_DIR/skills"

echo
echo "CODEX"
unlink_path "$REPO_DIR/CLAUDE.md" "$CODEX_DIR/AGENTS.md" "AGENTS.md"

echo "  skills ($CODEX_SKILLS_DIR):"
unlink_skills "$CODEX_SKILLS_DIR"
