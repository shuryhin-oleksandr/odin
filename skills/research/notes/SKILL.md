---
name: notes
description: Summarize a source (article, doc, talk) into a markdown notes file. Use when the user asks to take notes on, summarize, or distill a source for later.
---

<!-- TODO: refine instructions -->

1. Read the source end to end before writing anything.
2. Build the file path: `<folder>/<Name of source>, <Author>.md`.
   - If the user named a path, use it.
   - Otherwise, default to an existing notes folder in the current project (e.g. `research/notes/`), or `notes/` at the project root if there is none.
3. Call the AskUserQuestion tool to confirm the full file path. Do not write the file until the user answers.
4. Write the summary to the confirmed path, using the template below.

## Template

```markdown
# <Title> — <Author>

Source: <URL or path to the original>, published <date>.

## <Section header from the source>
- <Main thought>
- <Main thought>

## Conclusion
- <Main takeaway>
```

## Rules
- Use one header for each section of the source, in the source's order.
- Put the main thoughts under each header as short bullet points in your own words.
<!-- TODO: add more rules -->
