# My LLM Coding Workflow Going Into 2026 — Addy Osmani

Source: https://addyosmani.com/blog/ai-coding-workflow/, published January 4, 2026.

## 1. Start with a clear plan (specs before code)
- Skip the vague first prompt. Brainstorm with the AI and let it ask questions until requirements and edge cases are clear.
- Write the result into a `spec.md`: requirements, architecture, data models, testing strategy.
- Have a reasoning model turn the spec into a step-by-step plan, and refine the plan before any code is written.
- A "waterfall in 15 minutes": it feels slow, but it keeps the human and the AI aligned.

## 2. Break work into small, iterative chunks
- Work one step or ticket at a time ("implement Step 1 from the plan").
- Big, all-at-once requests produce confused output, duplicated logic, and code that doesn't fit together.
- Keep a "prompt plan" file so tools can work through tasks in order.
- Small loops limit how bad a mistake can get and make correcting course quick. They pair well with TDD.

## 3. Provide extensive context and guidance
- Give the model the code to change, the constraints, known pitfalls, and the approach you prefer.
- For niche or new APIs, pull in docs or READMEs (e.g. Context7).
- Bundle relevant code into one file with tools like gitingest or repo2txt, but only include what's needed.
- Skills turn prompting you repeat into reusable packaged procedures.
- LLMs take instructions literally, so be detailed and say explicitly what to avoid.

## 4. Choose the right model (and use multiple when needed)
- Models behave differently. If one is stuck, try the same prompt on another.
- Use the strongest tier when quality matters.
- Running two models side by side can show different approaches to the same problem.
- The author mostly uses Gemini (he works at Google) and switches when needed.

## 5. Leverage AI coding across the lifecycle
- CLI agents (Claude Code, Codex CLI, Gemini CLI) work in the repo: read files, run tests, do multi-step fixes.
- Async agents (Jules, Copilot Agent) work in cloud VMs in the background and open PRs.
- Orchestrators like Conductor run several agents in parallel, but the author finds that mentally draining.
- Supervise agents: hand them the plan or to-do list and watch each step.
- Usually one main agent, plus a second one for reviews.

## 6. Keep a human in the loop: verify, test, and review
- Treat AI output like a junior developer's work: read it, run it, test it.
- Build testing into the plan, and have agents run the suite and debug failures.
- A good test suite is the agent's safety net. Without it, agents may claim success when the code is broken.
- Review code yourself, and sometimes have a second model critique the first one's output.
- Chrome DevTools MCP lets the agent inspect DOM, console, network, and performance while debugging.
- A rushed AI-built project ended up inconsistent and needed a painful refactor.
- Ship only code you understand. You stay accountable.

## 7. Commit often and use version control as a safety net
- Commit small and often, after each task or successful edit, as save points.
- Reverting a failed AI experiment is then easy.
- Git history helps brief the AI on recent changes. LLMs read diffs well and can drive `git bisect`.
- Small, well-described commits make it easy to find which change caused a bug.
- Use branches or worktrees to isolate experiments and run parallel sessions on one repo.
- Rule: finish task, run tests, commit.

## 8. Customize the AI's behavior with rules and examples
- Keep a rules file (`CLAUDE.md`, `GEMINI.md`) with process rules, conventions, and preferences.
- Describe coding style and lint expectations in custom instructions or system prompts.
- Show inline examples of the pattern you want. LLMs are good at imitating.
- Add anti-hallucination rules: ask for clarification when context is missing; add short reasoning comments on bug fixes.
- Tuning the AI is like onboarding a new hire.

## 9. Embrace testing and automation as force multipliers
- Keep solid CI: automated tests, enforced style checks, staging deploys where possible.
- Feed CI failures and linter output back to the AI so it can fix them.
- Agents that won't call a task done until tests pass are a useful constraint.
- Review bots (e.g. CodeRabbit) give feedback you can turn into refactoring prompts.
- Plans for 2026: stronger quality gates, more tests and monitoring, maybe AI-on-AI review.
- Automation only helps if it exists. Without tests or checks, AI bugs slip through.

## 10. Continuously learn and adapt
- AI exposes you to new languages and techniques. Asking it to explain its code is a learning tool.
- AI amplifies strong fundamentals, and amplifies weak ones into confusion.
- Working at a higher level of abstraction demands more rigor in planning and architecture.
- Code without AI now and then to keep basic skills sharp.

## Conclusion
- Classic engineering discipline (design first, tests, version control, standards) is what makes AI collaboration work.
- It's AI-augmented engineering, not AI-automated engineering.
- AI is a strong force multiplier, but the human engineer stays the director.
