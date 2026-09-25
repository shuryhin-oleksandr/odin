#!/usr/bin/env bash
# Link this repo's CLAUDE.md into the user-scope Claude Code config via an @import line.
# Usage: bin/install.sh
set -euo pipefail

# 1. Define the Claude home folder (CLAUDE_CONFIG_DIR, else ~/.claude); stop if it does not exist.
CLAUDE_HOME="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
if [[ ! -d "$CLAUDE_HOME" ]]; then
  echo "error: Claude home folder not found: $CLAUDE_HOME" >&2
  exit 1
fi

# 2. Define the user CLAUDE.md; create it if it is missing.
USER_CLAUDE_MD="$CLAUDE_HOME/CLAUDE.md"
if [[ ! -f "$USER_CLAUDE_MD" ]]; then
  touch "$USER_CLAUDE_MD"
  echo "created: $USER_CLAUDE_MD"
fi

# 3. Identify the repo root (the parent of this script's bin/ folder).
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 4. Identify the repo CLAUDE.md; stop if it is missing.
REPO_CLAUDE_MD="$REPO_DIR/CLAUDE.md"
if [[ ! -f "$REPO_CLAUDE_MD" ]]; then
  echo "error: repo CLAUDE.md not found: $REPO_CLAUDE_MD" >&2
  exit 1
fi

# 5. Check whether the user CLAUDE.md already imports the repo CLAUDE.md; stop if it does.
IMPORT_LINE="@$REPO_CLAUDE_MD"
if grep -Fqx "$IMPORT_LINE" "$USER_CLAUDE_MD"; then
  echo "already imported: $IMPORT_LINE"
  exit 0
fi

# 6. Append the import with a note that it is managed by the odin project.
# Start on a new line if the file does not end with one.
if [[ -s "$USER_CLAUDE_MD" && -n "$(tail -c 1 "$USER_CLAUDE_MD")" ]]; then
  echo >> "$USER_CLAUDE_MD"
fi
{
  echo "<!-- Managed by the odin project ($REPO_DIR/bin/install.sh). Do not edit by hand. -->"
  echo "$IMPORT_LINE"
} >> "$USER_CLAUDE_MD"
echo "added import to $USER_CLAUDE_MD: $IMPORT_LINE"
