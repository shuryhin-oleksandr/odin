# Actions — My LLM Coding Workflow Going Into 2026, Addy Osmani

- When I start a new feature, I will brainstorm a `spec.md` with the AI (letting it ask questions) and turn it into a step-by-step plan before writing code.
- When I hand work to an agent, I will give it one plan step at a time, not the whole feature.
- When I prompt for a change, I will include the relevant code, constraints, known pitfalls, and what to avoid.
- When I use a niche or recently changed library, I will pull its current docs into context (Context7).
- When I repeat the same prompt more than a couple of times, I will turn it into a skill.
- When a model gets stuck on a problem, I will try the same prompt on a different model.
- When an agent finishes a step, I will read, run, and test the code before accepting it.
- When I start a project or feature without tests, I will add tests first so the agent has a safety net.
- When a step passes its tests, I will commit it right away with a clear message.
- When I try a risky AI experiment or run parallel sessions, I will do it on a separate branch or git worktree.
- When the AI repeats the same mistake or ignores a convention, I will add a rule or example to `CLAUDE.md`.
- When CI or the linter fails, I will feed the output straight back to the agent to fix.
- When I'm about to ship AI-written code I don't fully understand, I will ask the AI to explain it until I do.
- When I've relied on AI for a while, I will do a task without it to keep my fundamentals sharp.
