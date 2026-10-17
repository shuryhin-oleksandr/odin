# AI Harness — My LLM Coding Workflow Going Into 2026, Addy Osmani

## Skills
- `spec` skill: interviews me with clarifying questions about a feature, then writes `SPEC.md` (requirements, architecture, data models, testing strategy).
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd>✏️ From §Start with a clear plan</dd></dl>
- `plan-from-spec` skill: reads `SPEC.md` and produces a numbered plan of small steps, each with its own test to write and a "done" check.
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd>✏️ From §Start with a clear plan, §Break work into small, iterative chunks</dd></dl>
- `explain-diff` skill: walks through the current diff and explains what each change does and why, so I can confirm I understand it before committing.
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd>❔ From §Commit often, §Continuously learn and adapt</dd></dl>

## Agents
- `reviewer` subagent (ideally on a different model): reviews the main agent's diff for bugs, duplication, and convention violations, read-only.
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd>☝️ From §Keep a human in the loop, §Leverage AI coding across the lifecycle</dd></dl>
- Run parallel/experimental agent work in a git worktree (`isolation: "worktree"`) so it can't touch the main checkout.
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd>☝️ From §Commit often</dd></dl>

## Hooks
- PostToolUse hook on Edit/Write: run the linter and formatter on the changed file and return errors to the agent so it fixes them itself.
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd>✏️ From §Embrace testing and automation</dd></dl>
- Stop hook: run the test suite before the agent may finish; if tests fail, block and feed the failure output back. Stops the agent from declaring "done" without passing tests.
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd>✏️ From §Keep a human in the loop</dd></dl>

## Tools
- Context7 MCP (already set up) for current library docs on new or niche APIs.
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd>☝️ From §Provide extensive context and guidance</dd></dl>
- Browser DevTools MCP (e.g. Chrome DevTools MCP) so the agent can read DOM, console logs and network traces while debugging frontend work.
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd>☝️ From §Keep a human in the loop</dd></dl>

## Rules (CLAUDE.md)
- "If a requirement is unclear, ask me instead of guessing. Never invent APIs or file paths."
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd>☝️ From §Customize the AI's behavior</dd></dl>
- "Work one plan step at a time; stop after each step so I can test and commit."
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd>❔ From §Break work into small, iterative chunks</dd></dl>
- "When fixing a bug, add a short comment explaining the fix."
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd>☝️ From §Customize the AI's behavior</dd></dl>
- "Follow existing patterns: before writing new code, find a similar example in the codebase and match it."
  <dl style="margin: 0 0 0.75em 0; opacity: 0.45; filter: grayscale(1)"><dd>✏️ From §Customize the AI's behavior</dd></dl>
