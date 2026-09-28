## Overview

- [Installation](docs/INSTALLATION.md)
- [Plugins](docs/PLUGINS.md)

## Repository layout

- `skills/<name>/` — the skill itself (`SKILL.md` + files it reads at runtime). Symlinked by `install.sh`.
- `skill-sources/<name>/` — what the skill was generated from (prompts, notes, links, changelog). Not installed.
- `.claude/skills/<name>/` — skills used only while working in this repo. Not installed.
- `docs/` — installation and plugin guides.
