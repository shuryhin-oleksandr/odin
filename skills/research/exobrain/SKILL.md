---
name: exobrain
description: Search the personal knowledge base in ~/.exobrain and turn what it says into recommendations for the current question or task. Use only when the prompt contains the uppercase keyword "EXO".
---

1. Write the query. Take it from the prompt. If the prompt has no question besides the keyword, use this session's work: both what is already done and what is left.
2. Send the query to the `exobrain-retriever` agent. Do not read `~/.exobrain` yourself.
3. Judge each returned passage against this session's work. Cover work already done too: a practice that was skipped (no plan, no tests, no review) is a finding, not a reason to leave it out. Say what to do now to make up for it.
4. If the retriever returns no passages, or none apply, say so in one line.

Write each recommendation as one block, most important first. Copy the source line and quotes from the retriever as they are:

```
[<source title>](<URL>) — `<note file path>`, <heading>
> "<quote>"
> "<up to 3 quotes>"

**Recommendation:** <what to do in this task and why>
```

Recommend only what the passages support. Don't make code changes; show the recommendations to the user and wait.
