# frontend-ui-architecture — links

**Version:** 1.0.0 (source of truth: `metadata.version` in SKILL.md)

Skill for Claude Code: frontend UI architecture and code organization for React and Next.js (App Router). It answers "where does this code go and how is it split": components, hooks, constants, utils/helpers, types, API calls, state, business logic, import boundaries, server vs client placement.

Deliberately **not** covered: performance, memoization, bundle size, styling, accessibility. For React/Next.js performance see Vercel's `react-best-practices` skill (link below).

The skill is model-invoked: Claude loads it automatically when deciding where code belongs, structuring a feature, or reviewing/refactoring React code.

## Files

Skill (installed): [`skills/frontend-ui-architecture/`](../../skills/frontend-ui-architecture/)

| File | Purpose |
|---|---|
| [SKILL.md](../../skills/frontend-ui-architecture/SKILL.md) | Core rules for any React project: default structure, dependency direction, colocation, placement table, component splitting, hooks vs utils vs domain, state, imports, review checklist |
| [references/nextjs-app-router.md](../../skills/frontend-ui-architecture/references/nextjs-app-router.md) | Next.js App Router: role of `app/`, server/client boundary, data-access models, Server Actions, Route Handlers, auth placement, route folders |
| [references/patterns.md](../../skills/frontend-ui-architecture/references/patterns.md) | Worked code for tricky placement cases |
| [references/enforcement.md](../../skills/frontend-ui-architecture/references/enforcement.md) | ESLint rules to enforce the dependency direction |

Skill sources (this folder, not installed):

| File | Purpose |
|---|---|
| [prompt.md](prompt.md) | Original requests that produced this skill |
| [notes.md](notes.md) | Takeaways per source (UA), contradictions, corner cases |
| [links.md](links.md) | This file: all links, changelog |

## Changelog

- **1.0.0** (2026-09-26) — initial version: React core rules + Next.js App Router reference, patterns, lint enforcement.

## Sources

All sources used to build the skill. Detailed takeaways for each are in [notes.md](notes.md).

### Official documentation — React

- [Thinking in React](https://react.dev/learn/thinking-in-react) — component hierarchy by single responsibility, minimal state, where state lives.
- [Reusing Logic with Custom Hooks](https://react.dev/learn/reusing-logic-with-custom-hooks) — hook vs plain function, naming by purpose, no lifecycle hooks, logic not state.
- [You Might Not Need an Effect](https://react.dev/learn/you-might-not-need-an-effect) — derive during render, event logic in handlers.
- [File Structure FAQ (legacy docs)](https://legacy.reactjs.org/docs/faq-structure.html) — by feature vs by type, limit nesting, don't overthink.

### Official documentation — Next.js

- [Project structure and organization](https://nextjs.org/docs/app/getting-started/project-structure) — colocation, private folders, route groups, organization strategies.
- [Layouts and Pages](https://nextjs.org/docs/app/getting-started/layouts-and-pages) — page vs layout roles, `searchParams` vs `useSearchParams`, route prop types.
- [Server and Client Components](https://nextjs.org/docs/app/getting-started/server-and-client-components) — when to use which, `'use client'` at leaves, interleaving, providers, `server-only`.
- [The Server and Client Boundary](https://nextjs.org/docs/app/guides/server-and-client-boundary) — module graphs, what crosses the boundary, owner vs parent, compound components caveat.
- [Fetching Data](https://nextjs.org/docs/app/getting-started/fetching-data) — fetch where needed, `React.cache`, promises + `use()`, colocated preload.
- [Server Actions and Mutations](https://nextjs.org/docs/app/guides/server-actions) — actions as public endpoints, IDs not objects, sequential dispatch.
- [Forms](https://nextjs.org/docs/app/guides/forms) — Server Actions with zod, `useActionState`, `useFormStatus`, `bind`.
- [Backend for Frontend](https://nextjs.org/docs/app/guides/backend-for-frontend) — Route Handlers vs Server Components vs Server Actions, `proxy`.
- [Data Security](https://nextjs.org/docs/app/guides/data-security) — Data Access Layer, DTOs, one data-fetching model, thin actions.
- [Authentication](https://nextjs.org/docs/app/guides/authentication) — `verifySession` in DAL, no auth checks in layouts, optimistic proxy checks.
- [How to Think About Security in Next.js — Sebastian Markbåge](https://nextjs.org/blog/security-nextjs-server-components-actions) — three data-handling models, DAL, minimal client props.
- [vercel/next-learn](https://github.com/vercel/next-learn) — official course code (`app/lib`, `app/ui` layout).

### Other official guides

- [Redux Style Guide](https://redux.js.org/style-guide/) — feature folders, logic in reducers, minimal state, local vs global.
- [TanStack Query — Advanced SSR](https://tanstack.com/query/latest/docs/framework/react/guides/advanced-ssr) — prefetch on server + hydrate in client components.
- [shadcn/ui](https://ui.shadcn.com/docs) — owned, composable `components/ui` layer.

### Architectures and templates

- [Bulletproof React — project structure](https://github.com/alan2207/bulletproof-react/blob/master/docs/project-structure.md) — feature folders, no cross-feature imports, unidirectional flow, no barrels, lint enforcement.
- [Feature-Sliced Design — overview](https://feature-sliced.design/docs/get-started/overview) — layers, slices, segments, import rule.
- [Feature-Sliced Design — with Next.js](https://feature-sliced.design/docs/guides/tech/with-nextjs) — combining FSD with App Router.
- [Modularizing React Applications with Established UI Patterns — Juntao Qiu (martinfowler.com)](https://martinfowler.com/articles/modularizing-react-apps.html) — view / hooks / domain / data layers, strategy pattern.
- [Client-Side Architecture — Khalil Stemmler](https://khalilstemmler.com/articles/client-side-architecture/introduction/) — presentation, UI logic, model, infrastructure layers.
- [Next.js App Router Project Structure — MakerKit](https://makerkit.dev/blog/tutorials/nextjs-app-router-project-structure) — `_components`/`_lib`, thin actions, services, schemas.
- [Vercel agent-skills](https://github.com/vercel-labs/agent-skills) — `react-best-practices` (performance, out of scope here) and `composition-patterns`.

### Authoritative blogs

- [Colocation — Kent C. Dodds](https://kentcdodds.com/blog/colocation)
- [State Colocation will make your React app faster — Kent C. Dodds](https://kentcdodds.com/blog/state-colocation-will-make-your-react-app-faster)
- [Application State Management with React — Kent C. Dodds](https://kentcdodds.com/blog/application-state-management-with-react)
- [When to break up a component into multiple components — Kent C. Dodds](https://kentcdodds.com/blog/when-to-break-up-a-component-into-multiple-components)
- [AHA Programming — Kent C. Dodds](https://kentcdodds.com/blog/aha-programming)
- [The Wrong Abstraction — Sandi Metz](https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction)
- [Presentational and Container Components (2019 update) — Dan Abramov](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0)
- [The Two Reacts — Dan Abramov](https://overreacted.io/the-two-reacts/)
- [React Folder Structure — Robin Wieruch](https://www.robinwieruch.de/react-folder-structure/)
- [Delightful React File/Directory Structure — Josh W. Comeau](https://www.joshwcomeau.com/react/file-structure/)
- [Tao of React — Alex Kondov](https://alexkondov.com/tao-of-react/)
- [Practical React Query — TkDodo](https://tkdodo.eu/blog/practical-react-query)
- [Effective React Query Keys — TkDodo](https://tkdodo.eu/blog/effective-react-query-keys)
- [The Query Options API — TkDodo](https://tkdodo.eu/blog/the-query-options-api)
- [You Might Not Need React Query — TkDodo](https://tkdodo.eu/blog/you-might-not-need-react-query)
- [Please Stop Using Barrel Files — TkDodo](https://tkdodo.eu/blog/please-stop-using-barrel-files)
- [Hooks Pattern — patterns.dev](https://www.patterns.dev/react/hooks-pattern/)
- [Compound Pattern — patterns.dev](https://www.patterns.dev/react/compound-pattern/)
- [Container/Presentational Pattern — patterns.dev](https://www.patterns.dev/react/presentational-container-pattern/)
- [Airbnb React/JSX Style Guide](https://github.com/airbnb/javascript/tree/master/react)

### Tooling

- [eslint-plugin-boundaries](https://github.com/javierbrea/eslint-plugin-boundaries)
- [steiger — FSD linter](https://github.com/feature-sliced/steiger)

### Community

- [Архитектура фронтенд-приложений на React (Нам не нужен FSD) — Doubletapp, Habr](https://habr.com/ru/companies/doubletapp/articles/870236/)
- [Архитектура front-end приложений — обзор, Habr](https://habr.com/ru/articles/726354/)
- [Как я добился чистой архитектуры на фронтенде, Habr](https://habr.com/ru/articles/770560/)
- [Чистая архитектура фронтенд приложений. Часть вторая, Habr](https://habr.com/ru/articles/870710/)
- [Mastering Feature-Sliced Design: lessons from real projects — dev.to](https://dev.to/arjunsanthosh/mastering-feature-sliced-design-lessons-from-real-projects-2ida)
- [Feature-Sliced Design vs Clean Architecture — dev.to](https://dev.to/skorphil/feature-sliced-design-vs-clean-architecture-3m5k)
- [The Next.js 15 App Router Project Structure That Scales — dev.to](https://dev.to/krunal_groovy/the-nextjs-15-app-router-project-structure-that-scales-with-examples-47ha)
- [How To Structure React Projects From Beginner To Advanced — Web Dev Simplified](https://blog.webdevsimplified.com/2022-07/react-folder-structure/)

### Books

- Martin Fowler — *Refactoring* (2nd ed.)
- Robert C. Martin — *Clean Architecture*
- John Ousterhout — *A Philosophy of Software Design*
- Lydia Hallie, Addy Osmani — *Learning Patterns* ([patterns.dev](https://www.patterns.dev/))
