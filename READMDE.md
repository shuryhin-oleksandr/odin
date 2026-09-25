## Installation

Run all commands from the repo root.

### CLAUDE.md

Import odin `CLAUDE.md` into your user-scope `~/.claude/CLAUDE.md`:

```bash
echo "@$PWD/CLAUDE.md" >> ~/.claude/CLAUDE.md
```

To uninstall, delete that line.

### Skills

Symlink each skill into your user-scope `~/.claude/skills/`, so it is available in every project and stays in sync with this repo:

```bash
mkdir -p ~/.claude/skills
for skill in "$PWD"/skills/*/; do ln -sfn "${skill%/}" ~/.claude/skills/; done
```

To uninstall a skill, delete its symlink, e.g. `rm ~/.claude/skills/generate-engineering-insights-skill`.

Available skills:

- `/generate-engineering-insights-skill`: generates the `engineering-insights` skill for the current project. Run it from the target project.

### Plugins

Plugins installation instructions are [here](PLUGINS.md).
