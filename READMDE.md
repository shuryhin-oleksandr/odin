## Installation

Scripts can be run from any directory.

### Install

```bash
./bin/install.sh
```

- Links odin `CLAUDE.md` into your user-scope `~/.claude/CLAUDE.md` by adding an `@<repo>/CLAUDE.md` import line (skipped if already present).
- Symlinks each skill into your user-scope `~/.claude/skills/`, so it is available in every project and stays in sync with this repo.

Re-run it after adding new skills.

### Uninstall

```bash
./bin/uninstall.sh
```

- Removes the `CLAUDE.md` import line, keeping the rest of `~/.claude/CLAUDE.md` intact.
- Removes broken symlinks in `~/.claude/skills/`.
- Removes skill symlinks pointing into this repo. Other skills are left untouched.

### Clean symlinks

```bash
./bin/clean_symlinks.sh
```

Removes broken skill symlinks pointing into this repo, e.g. after a skill was deleted or renamed.

### Repository layout

- `skills/<name>/` — the skill itself (`SKILL.md` + files it reads at runtime). Symlinked by `install.sh`.
- `skill-sources/<name>/` — what the skill was generated from (prompts, notes, links, changelog). Not installed.

### Available skills

- `/generate-engineering-insights-skill`: generates the `engineering-insights` skill for the current project. Run it from the target project.
- `frontend-ui-architecture`: React / Next.js App Router architecture and code organization (where components, hooks, constants, utils and business logic live). Loaded automatically when relevant; sources it was generated from: [skill-sources/frontend-ui-architecture](skill-sources/frontend-ui-architecture/links.md).

## Plugins

Plugins installation instructions are [here](PLUGINS.md).
