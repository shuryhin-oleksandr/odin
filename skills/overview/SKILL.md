---
name: overview
description: Open the response with a short overview of the answer plus its word count. Use when the prompt contains the uppercase keyword "OVW" (optionally with a word limit, like "OVW50" or "OVW 50"), or when the user explicitly asks for an overview.
---

Before the full answer, write a one-line overview of it:

- Word limit: if the keyword has a number after it (`OVW50` or `OVW 50`), stay at or under that many words. Otherwise stay under 30 words.
- Summarize the answer, not the question.
- End with the exact word count in parentheses, nothing else: `(22)`.
- Start the line with a bold `**Overview:**` label (not counted in the word count). No blockquote, heading, or code formatting.

Then answer normally.

If the whole message is just the keyword (`OVW`, `OVW50`, `OVW 50`), there is no new question. Write only the overview line, summarizing your previous response. Do not repeat or rewrite that response's body.

Example:

**Overview:** Use a skill for reusable instructions; type the slash command for reliability, and add a hook only if keywords must work mid-sentence. (22)
