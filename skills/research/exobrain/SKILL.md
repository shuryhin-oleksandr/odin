---
name: exobrain
description: Search the personal knowledge base in ~/.exobrain and turn what it says into recommendations for the current question or task. Use only when the prompt contains the uppercase keyword "EXO".
---

1. Take the query from the prompt. If the prompt has no question besides the keyword, use the current task as the query.
2. Read the Markdown files in `~/.exobrain`.
3. Find the passages relevant to the query by meaning, not only by exact words.
4. Turn them into concrete recommendations for this query and task, most important first.
5. If nothing is relevant, say so in one line.

Write each recommendation as one block:

```
[<source title>](<URL from the note's "Source:" line>) — `<note file path>`, <heading>
> "<relevant phrase from the note>"
> "<up to 3 phrases, quoted exactly>"

**Recommendation:** <what to do in this task and why>
```

Recommend only what the notes support. Don't make code changes; show the recommendations to the user and wait.
