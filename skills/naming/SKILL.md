---
name: naming
description: Choose names for variables, functions, constants and modules. Use when writing new code or when the user questions a name.
---

Use the user's vocabulary first: names from chat, then existing code. Plan or spec terms never override them.

- Name by meaning, not mechanism: why the value exists ("new_jobs_since"), not how it's used ("lower_bound", "cutoff").
- Name functions by the business result ("evaluate_new_jobs"), not internal steps ("check", "process").
- One concept, one name across code and logs. If two words compete, ask which one.
- No single-letter names, except accepted cases (`i` in `range`).

Before finishing, read each new name cold. If you can't tell why it exists without reading its body, rename it.
