## Overview

- [Installation](docs/INSTALLATION.md)
- [Plugins](docs/PLUGINS.md)

## Skills

- **notes** — Summarizes a source into `Notes.md`, `Actions.md` and, when relevant, `Harness.md` with AI-setup changes.
- **notes-prompt** — The original prompt behind `notes`, kept verbatim for comparison. Runs only by hand.
- **split-implementation-plan** — Splits an implementation plan into two or three independently working parts to build and commit in order.

### Steering

- **overview** (`OVW`, `OVW50`) — Opens the answer with a one-line overview and word count. Sent alone, it summarizes the previous response.
- **best-practice** (`BP`) — Checks key recommendations against authoritative sources, cites each one, and marks unconfirmed ones as Unverified.
- **signatures** (`SG`) — Plans the backend as function signatures grouped by file, each with a one-line responsibility. No implementation.
- **verify-with-docs** (`VRF`) — Checks every library or API claim against official docs for the locked version, citing each source.
- **flow** (`FL`) — Explains a flow step by step, very briefly, without changing code.

### Coding

- **naming** — Chooses names by meaning, using the user's own words and existing code, with one name per concept.
- **react-code-review** — React review points: graceful error handling, responsive layouts, react-hook-form with Zod, SWR or TanStack Query.
- **lib-comparison** — Compares libraries by live GitHub stars, downloads and deprecation status in a table, then recommends one.

## Repository layout

- `skills/<name>/` — the skill itself (`SKILL.md` + files it reads at runtime). Symlinked by `install.sh`.
- `docs/` — installation and plugin guides.
