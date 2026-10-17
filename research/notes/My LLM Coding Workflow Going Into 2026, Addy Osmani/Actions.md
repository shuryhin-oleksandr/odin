# Actions — My LLM Coding Workflow Going Into 2026, Addy Osmani

- When I start a new feature, I will brainstorm a spec with the AI (letting it ask clarifying questions) and turn it into a written step-by-step plan before any code.
- When I implement a plan, I will give the AI one small step at a time and test that step before moving on.
- When I prompt for a task, I will include the relevant code, constraints, pitfalls and what is out of scope.
- When I use a new or niche library, I will pull its current docs into the context.
- When a model gets stuck on a problem, I will retry the same prompt on a different model.
- When the AI finishes a step, I will read, run and test the code before accepting it, as if a junior wrote it.
- When a change matters, I will have a second model review the first model's output.
- When a small task or AI edit works, I will commit it right away with a clear message.
- When I try a risky AI experiment or run agents in parallel, I will use a separate branch or git worktree.
- When I can't explain a piece of AI-written code, I will not commit it until I can.
- When I notice the AI repeating a mistake or ignoring a convention, I will add a rule to CLAUDE.md.
- When tests or the linter fail, I will feed the exact output back to the AI to fix.
- When I set up a project, I will make sure CI runs tests, linting and formatting on every commit/PR.
- When the AI writes something I don't fully understand, I will ask it to explain the code and its reasoning.
- Every so often, I will solve a task without AI to keep my core skills sharp.
