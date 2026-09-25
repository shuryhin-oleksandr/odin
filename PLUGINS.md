## Installation

Import this repo's `CLAUDE.md` into your user-scope `~/.claude/CLAUDE.md` (run from the repo root):

```bash
echo "@$PWD/CLAUDE.md" >> ~/.claude/CLAUDE.md
```

To uninstall, delete that line.

## Plugins

### Postman

Official Claude Postman integration, searchable via the Marketplace plugin.

```bash
claude plugin install postman@claude-plugins-official
```

### Postgres

PostgreSQL database integration — example from the Claude [docs](https://code.claude.com/docs/en/mcp#example-query-your-postgresql-database).

```bash
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub \
--dsn "postgresql://user:pass@host:5432/db_name"
```

Executed per-project, so MCP works with specific project DB.

### Sentry

Official Sentry error monitoring integration, searchable via the Marketplace plugin.

```bash
claude plugin install sentry@claude-plugins-official
```

### Playwright

Official Playwright browser automation integration, searchable via the Marketplace plugin.

```bash
claude plugin install playwright@claude-plugins-official
```

Set playwright cache folder location and size to Claude settings `~/.claude/settings.json` (Optional).
This will prevent playwright from polluting workspace folder with it's cache files, from cache folder to grow infinitely.
```json
{
  "env": {
    "PLAYWRIGHT_MCP_OUTPUT_DIR": "<playwright_cache_folder_path>",  # like "/Users/alex/Library/Caches/playwright-mcp"
    "PLAYWRIGHT_MCP_OUTPUT_MAX_SIZE": "<playwright_cache_folder_max_size_in_bytes>"  # like "52428800"
  }
}
```

### Python

```bash
brew install pyright
claude plugin install pyright-lsp@claude-plugins-official
```

### TypeScript

```bash
claude plugin install typescript-lsp@claude-plugins-official
```
