---
name: notes
description: Summarize a source (article, doc, talk) into a markdown notes file. Use when the user asks to take notes on, summarize, or distill a source for later.
---

<!-- TODO: refine instructions -->

1. Read the full source before writing anything.
2. Write the summary to a file named `<Article name>, <Author>.md`, using the template below.
   - If the user named a location, save it there.
   - Otherwise, propose a folder and wait for the user to approve it before writing. Default proposal:
     - an existing notes folder in the current project (e.g. `research/notes/`), if there is one;
     - otherwise `notes/` at the project root.

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
