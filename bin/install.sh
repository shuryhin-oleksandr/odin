#!/usr/bin/env bash
# Installs odin into user scope: ~/.claude (CLAUDE.md import + skill and agent symlinks) and Codex (~/.codex/AGENTS.md symlink + skill symlinks in ~/.agents/skills).
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
LINKED_MARK="○" # hollow dot in the normal text colour

# Symlinks $1 to $2 unless $2 already exists. $3 is the label printed in the report, $4 the report line indent (default 2 spaces).
link_path() {
  local source="$1" link="$2" label="$3" indent="${4:-  }"
  if [ -L "$link" ] && [ "$(readlink "$link")" = "$source" ]; then
    echo "${indent}${LINKED_MARK} $label - linked"
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
# A skill is any folder with a SKILL.md, at any depth, so skills can be grouped in subfolders (skills/research/notes).
# Links stay flat (<skills_dir>/notes), because agents only look one level deep.
link_skills() {
  local skills_dir="$1"
  mkdir -p "$skills_dir"
  while IFS= read -r skill_file; do
    local skill="${skill_file%/SKILL.md}"
    local skill_path_in_repo="${skill#"$REPO_DIR/skills/"}" # e.g. research/notes, shown in the report
    link_path "$skill" "$skills_dir/$(basename "$skill")" "$skill_path_in_repo" "    "
  done < <(find "$REPO_DIR/skills" -name SKILL.md -not -path '*/.*' | sort)
}

# Symlinks every repo agent (agents/<name>.md) into the given agents directory.
link_agents() {
  local agents_dir="$1"
  mkdir -p "$agents_dir"
  while IFS= read -r agent_file; do
    link_path "$agent_file" "$agents_dir/$(basename "$agent_file")" "$(basename "$agent_file")" "    "
  done < <(find "$REPO_DIR/agents" -maxdepth 1 -name '*.md' 2>/dev/null | sort)
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
  echo "  ${LINKED_MARK} CLAUDE.md already linked - $IMPORT_LINE"
else
  printf '%s\n%s\n' "$COMMENT_LINE" "$IMPORT_LINE" >> "$CLAUDE_DIR/CLAUDE.md"
  echo "  CLAUDE.md linked - $IMPORT_LINE"
fi

echo "  skills ($CLAUDE_DIR/skills):"
link_skills "$CLAUDE_DIR/skills"

echo "  agents ($CLAUDE_DIR/agents):"
link_agents "$CLAUDE_DIR/agents"

# Codex has no @import in AGENTS.md, so the whole file is a symlink to the repo CLAUDE.md
echo
echo "CODEX"
mkdir -p "$CODEX_DIR"
link_path "$REPO_DIR/CLAUDE.md" "$CODEX_DIR/AGENTS.md" "AGENTS.md"

echo "  skills ($CODEX_SKILLS_DIR):"
link_skills "$CODEX_SKILLS_DIR"
