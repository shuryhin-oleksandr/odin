# My LLM Coding Workflow Going Into 2026 — Addy Osmani

Source: https://addyosmani.com/blog/ai-coding-workflow/, published January 4, 2026.

## Start with a clear plan (specs before code)
- Brainstorm a spec with the AI first, and let it ask clarifying questions until requirements and edge cases are settled.
- Write the spec down: requirements, architecture, data models, testing strategy.
- Hand the spec to a reasoning model to produce a step-by-step plan, and iterate on the plan until it holds together.
- Planning up front aligns you and the AI and saves wasted cycles.

## Break work into small, iterative chunks
- Do one small task at a time and test it before moving on.
- Big, all-in-one prompts produce inconsistent, duplicated code that is hard to untangle.
- Small steps are easier to understand and to course-correct.
- Fits naturally with test-driven development.

## Provide extensive context and guidance
- Give the model the relevant code, constraints, known pitfalls and preferred approaches.
- For new or niche APIs, pull in official docs (docs tools or paste them).
- Context-bundling tools can pack the relevant parts of the codebase into one file.
- Keep context to what matters, and say explicitly what is out of scope.
- Skills (packaged reusable instructions) make repeated procedures more consistent than ad-hoc prompts.
- Models follow instructions literally, so detailed prompts reduce hallucinations.

## Choose the right model (and use multiple when needed)
- Models differ in strengths and "personality"; match the model to the task.
- When one model is stuck, try the same prompt on another, or run two side by side.
- Use the strongest tier when quality matters.

## Leverage AI coding across the lifecycle
- CLI agents read files, run tests and fix issues directly in the repo.
- Async cloud agents work in the background and open PRs.
- Agents speed up mechanical work but still need guidance, e.g. the spec/plan in context.
- Supervise agents; don't let them build whole features unattended.
- Many parallel agents are mentally taxing; one main agent plus a reviewer is the usual setup.

## Keep a human in the loop: verify, test, and review everything
- Treat AI output like code from an overconfident junior: read it, run it, test it.
- Plan tests for each step, have the agent run the suite and fix failures.
- Good tests are the agent's safety net; without them it may claim work is done when it isn't.
- Review manually, and optionally have a second model critique the first.
- Browser-debugging tools give agents runtime data: DOM, console logs, network traces.
- You stay accountable — understand the code before shipping it.

## Commit often and use version control as a safety net
- Commit after every small task or successful AI edit so bad changes are easy to roll back.
- Git history helps brief the AI on recent changes and find bugs (e.g. bisect).
- Small, well-described commits make review and debugging easier.
- Use branches or worktrees to isolate AI experiments and parallel work.
- Never commit code you can't explain.

## Customize the AI's behavior with rules and examples
- Keep project conventions and process preferences in rules files (CLAUDE.md, GEMINI.md).
- Set style expectations through custom instructions or system prompts.
- Show examples from the codebase so the model copies the existing pattern.
- Add honesty instructions: ask for clarification instead of inventing answers; add short comments explaining fixes.

## Embrace testing and automation as force multipliers
- Run CI on every commit/PR: tests, linting, formatting.
- Feed test failures and linter output back to the AI so it fixes its own work.
- Code-review bots add feedback that can become refactoring prompts.
- The AI does best in an environment that catches mistakes automatically — you have to build that environment.

## Continuously learn and adapt
- AI tools expose you to new languages, frameworks and techniques.
- AI amplifies good fundamentals, and amplifies confusion when fundamentals are weak.
- Ask the AI to explain its code and reasoning; use it as a research assistant to compare options.
- Code without AI now and then to keep core skills sharp.

## Conclusion
- This is AI-augmented engineering, not AI-automated engineering.
- Classic practices — design first, tests, version control, standards — matter more when AI writes much of the code.
- The human engineer stays the director of the work.
