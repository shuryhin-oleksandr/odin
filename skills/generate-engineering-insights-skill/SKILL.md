---
name: generate-engineering-insights-skill
description: Generate the engineering-insights skill (per-module LEARNINGS.md capture loop) for the current project, using the lesson prompt, slides and research bundled with this skill.
disable-model-invocation: true
---

# Generate the engineering-insights skill

## Inputs

Read all three files from this skill's directory in full, start to end, before doing anything else:

1. [prompt-refined.md](prompt-refined.md) — the task. It is a sequence of messages separated by `_______`; treat every block as a requirement of this single run. Follow-up questions in it (e.g. how the sources were used) are answered in the final report.
2. [slides.md](slides.md) — the lesson slides with the recommendations to apply.
3. [engineering-insights-research.md](engineering-insights-research.md) — the research; visit the websites it links to, as prompt-refined.md requires.
