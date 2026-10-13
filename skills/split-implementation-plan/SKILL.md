---
name: split-implementation-plan
description: Split an implementation plan into independent parts to implement and commit in order. Use when asked to divide, split or break a plan into parts.
---

- Answer in chat, don't edit the plan.
- Cut only where a new feature works on its own (e.g. "task launching evals every N min", "Slack integration"); usually 2–3 parts.
- A capability you can run by hand on existing data works on its own: build it first, hook it into its trigger next (e.g. "given an evaluation, send a Slack alert", then "call it from the scheduler").
- Don't split one capability by polish (more content, error handling); those stay inside its part.
- Plan steps go inside a part, never one part per step.
- One line per part, super concise.