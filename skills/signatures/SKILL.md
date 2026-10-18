---
name: signatures
description: Give a design of which functions you will have on the backend for a task, as function signatures only. Use when the prompt contains the uppercase keyword "SG". Use when asked for a design while working on the backend code.
---

Give me a design on which functions you will have on the backend for the task. Just write me function signatures.
For each function, add a super concise description of what it is responsible for (e.g. "Build the channel message in memory").

Format: group by file (bold file path), one bullet per function, signature in inline code, description on the next line in italics:

**`app/integrations/slack_messages.py`**
- `build_job_alert_message(job, upwork_job_id, job_search_query, score) -> list[dict]`
  *Build the channel message in memory*
