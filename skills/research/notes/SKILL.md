---
name: notes
description: Summarize a source (article, doc, talk) into a folder with a notes file, an action points file, and (when applicable) a file on applying it to the AI harness. Use when the user asks to take notes on, summarize, or distill a source for later.
---

<!-- TODO: refine instructions -->

1. Read the source end to end before writing anything.
2. Build the folder path: `<parent>/<Name of source>, <Author>/`.
   - If the user named a path, use it.
   - Otherwise, default to an existing notes folder in the current project (e.g. `research/notes/`), or `notes/` at the project root if there is none.
3. Call the AskUserQuestion tool to confirm the full folder path. Do not write any file until the user answers.
4. Write `Notes.md` in that folder, using the notes template below.
5. Write `Actions.md` in that folder, using the actions template below.
6. Decide whether the source suggests anything for the AI harness (agents, skills, hooks, tools, rules files).
   - If it does, write `Harness.md` in that folder, using the AI harness template below.
   - If it doesn't, do not write the file. Tell the user the source has no AI harness applications.

## Notes template

```markdown
# <Title> — <Author>

Source: <URL or path to the original>, published <date>.

## <Section header from the source>
- <Main thought>
- <Main thought>

## Conclusion
- <Main takeaway>
```

## Actions template

```markdown
# Actions — <Title>, <Author>

- When <condition>, I will <action>.
- When <condition>, I will <action>.
```

## AI harness template

```markdown
# AI Harness — <Title>, <Author>

## <Skills | Hooks | Agents | Tools | Rules (CLAUDE.md)>
- <Concrete thing to build or configure, and what it does>.
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd><☝️ | ✏️ | ❔> From §<source section>, §<another source section></dd></dl>
- <Concrete thing to build or configure, and what it does>.
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd><☝️ | ✏️ | ❔> From §<source section></dd></dl>
```

## Rules
- Use one header for each section of the source, in the source's order.
- Put the main thoughts under each header as short bullet points in your own words.
- In `Harness.md`, include only the categories that have items, and make each item concrete enough to build.
- In `Harness.md`, put each item's source on the line right after it, in the `<dl>` line exactly as in the template. Do not leave a blank line between items.
- In `Harness.md`, start each source line with one emoji showing how closely the item follows the source:
  - ☝️ — the author recommends it directly.
  - ✏️ — the author's idea, but the mechanism (skill, hook, agent, rule) is your choice.
  - ❔ — your extrapolation; the source does not say it.
<!-- TODO: add more rules -->
