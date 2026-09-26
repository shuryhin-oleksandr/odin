---
name: frontend-ui-architecture
description: Frontend UI architecture and code organization for React and Next.js (App Router) — where components, hooks, constants, utils/helpers, types, API calls, state and business logic should live, how to split components, folder structure (feature-based, colocation, Bulletproof React, Feature-Sliced Design), import boundaries, server vs client placement, Server Actions and Data Access Layer. Use this skill whenever you create, move, split or review React/Next.js code and have to decide which file or folder something belongs in, when the user asks how to structure a frontend project or feature, where to put logic, whether to extract a component/hook/util, or asks to refactor a messy React codebase — even if they don't say "architecture". Not for performance tuning, styling or accessibility.
metadata:
  version: 1.0.0
---

# Frontend UI Architecture (React + Next.js)

Answers one question: **where does this code go, and how is it split?** The goal is a codebase where a newcomer can guess a file's location, features can change or be deleted without ripple effects, and business rules are testable without React.

Out of scope: rendering performance, memoization, bundle size, styling, accessibility. Don't restate those here.

## How to apply this skill

1. **Read the project's existing conventions first.** Look at the `src/` tree, `tsconfig` path aliases, ESLint import rules, and a couple of existing features. If the project already follows a consistent scheme (Feature-Sliced Design, Bulletproof React, its own), keep following it — consistency within a codebase beats any ideal from this skill. Use the rules below to decide placement *within* that scheme and to fill gaps it doesn't cover. Name mapping for common schemes:

   | This skill | Bulletproof React | Feature-Sliced Design |
   |---|---|---|
   | `features/<name>/` | `features/<name>/` | `features/`, `entities/`, `widgets/` slices |
   | `features/<name>/domain/` | `features/<name>/utils` | slice `model/` segment |
   | `features/<name>/api/` | `features/<name>/api/` | slice `api/` segment |
   | `features/<name>/constants.ts` | feature `utils`/`config` | slice `config/` segment |
   | shared `components/ui`, `utils`, `lib` | `components`, `utils`, `lib` | `shared/ui`, `shared/lib`, `shared/api` |
   | `app/` | `app/` | `app/` + `pages/` layers |

2. **Don't restructure code nobody asked you to touch.** Place *new* code correctly, and when you notice existing violations, mention them with a suggested move instead of silently moving files.
3. **Next.js App Router project** (`next` in `package.json` and an `app/` directory with `layout.tsx`)? Also read [references/nextjs-app-router.md](references/nextjs-app-router.md) — server/client boundary, Server Actions, Data Access Layer, route folders.
4. **Hard or ambiguous case** (a component two features need, logic that looks like both a hook and a util, a growing Server Action)? See worked code in [references/patterns.md](references/patterns.md).
5. **Setting up or tightening a project** — enforce the import rules with lint: [references/enforcement.md](references/enforcement.md).
6. When you make a placement decision the user might question, state the rule in one line ("put in `features/cart/domain` — pure business rule, no React") so they can push back.

## Default structure

For new projects, or new areas of a project without its own convention:

```
src/
  app/                  # entry: routing, providers, layouts, page composition. No business logic.
  features/
    <feature>/          # one business capability: cart, invoices, auth…
      components/       # UI of this feature
      hooks/            # hooks of this feature (glue between React and domain/api)
      api/              # requests, query/queryOptions factories, request/response types
      domain/           # pure business rules + domain types. No React, no I/O.
      constants.ts
      types.ts
      utils.ts          # feature-specific helpers
  components/
    ui/                 # design-system primitives (Button, Dialog, Input) — no domain knowledge
                        # + shared composite components used by 2+ features
  hooks/                # generic hooks used by 2+ features (useDebounce, useMediaQuery)
  lib/                  # preconfigured third-party clients: api-client, query-client, db, analytics
  utils/                # generic pure functions, domain-agnostic (formatDate, clamp)
  config/               # env parsing, app-wide constants, feature flags
  types/                # only types shared across features
```

Create a subfolder only when it has content — a feature with one component and one hook doesn't need six empty folders. Keep nesting to 3–4 levels.

## Dependency rules

Imports flow one way: **shared (`components`, `hooks`, `lib`, `utils`, `config`, `types`) → `features` → `app`**.

- Shared code never imports from features or app. If a "shared" util needs a feature type, it isn't shared — it belongs to the feature.
- **Features don't import from each other.** When two features must meet, compose them one level up (in `app/`/a page) via props, `children` or slots, or move the common piece down into shared. This is what keeps a feature deletable.
- Within a feature: `components → hooks → api/domain`; `domain` imports nothing from React or `api`.

Why: one-directional dependencies are what make the structure predictable; a single cross-feature import quickly turns the tree into a flat namespace where everything depends on everything.

## Colocation and promotion

Place code as close as possible to where it's used, and move it outward only when a second real consumer appears:

`inside the component file → component's folder → feature folder → shared folder`

- A helper or constant used by one component lives in that component's file (above the component).
- A hook used by one component stays in that component's file or folder; only reusable hooks go to `hooks/`.
- Promote on the **second actual** use, not an anticipated one. When a shared thing drops back to one consumer, move it back.
- Tests, stories and styles sit next to the file they cover (`cart-summary.tsx`, `cart-summary.test.tsx`).

Why: a central `utils/` or `constants.ts` that everything dumps into rots — nobody knows what's still used. "Duplication is far cheaper than the wrong abstraction" (Sandi Metz); prefer a little duplication until the right abstraction is obvious.

## Where does X go?

| Thing | Location | Reasoning |
|---|---|---|
| Design-system primitive (Button, Modal) | `components/ui/` | no domain knowledge, used everywhere |
| Component used by one feature | `features/<f>/components/` | feature owns it |
| Component used by 2+ features | `components/` (shared) or composed in `app/` | features can't import each other |
| Component used by one route/page only | next to the route (Next.js: `app/.../_components/`) | colocation |
| Hook calling other hooks, one feature | `features/<f>/hooks/` | glue between React and feature logic |
| Generic hook (no domain) | `hooks/` | reusable anywhere |
| Business rule (pricing, eligibility, status transitions, validation logic) | `features/<f>/domain/` as pure functions | testable without React, reused by UI, hooks, server |
| Pure helper, one component | same file, above the component | colocation |
| Pure helper, feature-specific | `features/<f>/utils.ts` | domain knowledge stays in the feature |
| Pure helper, domain-agnostic, 2+ features | `utils/` | truly generic |
| Configured third-party client (axios/fetch wrapper, QueryClient, db, Sentry) | `lib/` | one configured instance |
| API request functions, query keys/options | `features/<f>/api/` | keys and fetchers colocated per feature |
| Validation schemas (zod) | `features/<f>/` (`schemas.ts` or in `domain/`) | shared by form, action and service |
| Constant used by one component | same file, module scope | colocation |
| Feature constants (statuses, limits, labels) | `features/<f>/constants.ts` | owned by the feature |
| App-wide constants (routes, breakpoints), env | `config/` | single source; env parsed once |
| Types for one feature | `features/<f>/types.ts` (API DTO types in `api/`) | keep API shape separate from domain/UI types |
| Types shared across features | `types/` | only when really shared |
| Global client state (theme, session UI) | `app/` providers or `stores/` | only truly app-wide |
| Feature client state | `features/<f>/` store or hook | owned by the feature |

## Splitting components

- **One responsibility per component.** Extract a subcomponent when a part of the JSX has its own loop, conditional branch, or state, or when the component mixes unrelated concerns. Line count alone is not a reason.
- **Split when there's real pain** — state that's hard to follow, a part you need to reuse or test on its own, merge conflicts — not pre-emptively. Premature splitting adds prop drilling and indirection.
- **Never define components or `renderX()` functions inside another component.** Make them real components (same file is fine if private).
- **Don't split into `containers/` vs `components/`.** Dan Abramov retired that pattern: hooks give the same separation of stateful logic without an artificial folder split.
- **Composition over configuration.** When a component grows boolean props (`showHeader`, `isCompact`, `withActions`), switch to `children`, slot props (`actions={<…/>}`), or compound components (`<Card><Card.Header/>…</Card>`).
- **Narrow props.** Pass the fields the component needs, not the whole domain object "just in case".
- **One exported component per file.** Small private helpers/subcomponents in the same file are fine.
- **Naming:** follow the project. Default for new projects: kebab-case files (`invoice-table.tsx`), PascalCase components, `use`-prefixed hooks.

## Hooks, utils and domain logic

Rule from react.dev: **a function is a hook only if it calls other hooks.** Otherwise it's a plain function and must not be named `useX`.

- **Hooks** are thin glue: read state/context/queries, call domain functions, return what the component needs. Name them by purpose (`useCartTotal`, `useInvoiceFilters`), not lifecycle (`useMount`, `useEffectOnce`). Custom hooks share *logic*, not *state* — each call is independent; to share state, lift it or use context/store.
- **Domain functions** hold business rules as pure functions over plain data: `calculateTotal(items, discount)`, `canCancelOrder(order, now)`. No React, no fetch. This is where most "business logic" should end up.
- **Utils** are generic, domain-free pure functions. If a util knows about invoices, it's a feature helper, not a util.
- **Event-driven logic belongs in event handlers**, not in `useEffect`. Effects are for synchronizing with external systems.
- **Derived data is computed during render**, not stored in state and synced with effects.

Layering (Fowler / Qiu, "Modularizing React Applications"):

```
View (components, JSX only)
  → Hooks / handlers (React glue, UI state)
    → Domain (pure business rules, types)
    → Data (api client, query factories; Next.js: DAL / server services)
```

When the same `if (country === 'X')`-style branching appears in several components, move it into the domain layer (a lookup or a strategy object) so one place changes when rules change.

## State placement

Pick the first rung that works:

1. **Derive it** from props/other state — not state at all.
2. **Local** `useState`/`useReducer` in the component that uses it.
3. **Lift** to the closest common parent of the consumers.
4. **Composition** (`children`/slots) to avoid drilling through intermediate components.
5. **Context** for concerns many distant components read (theme, current user, feature-scoped state). Provider as low in the tree as possible.
6. **Store** (Zustand/Redux) for genuinely global, frequently updated client state.

Separately:
- **Server data is a cache, not state.** Keep it in the data layer (TanStack Query/SWR, or Server Components in Next.js). Don't copy query results into `useState`.
- **URL state** for anything shareable or back-button-relevant: filters, tabs, pagination.
- **Form drafts** stay local to the form; submit to the server/store at the end.

## Data access (plain React / SPA)

- Components don't call `fetch` directly. Requests live in `features/<f>/api/` using the shared client from `lib/`.
- One query-key / `queryOptions` factory per feature, colocated with its fetchers; components use it via `useQuery(invoiceQueries.list(filters))` or a feature hook.
- Map API DTOs to the shape the UI needs at the data-layer boundary, so backend field renames don't ripple through components.

## Imports

- **No barrel `index.ts` files inside application code** — import files directly (`@/features/cart/components/cart-summary`). Barrels cause circular imports, pull in unrelated modules and don't actually hide internals. Exception: an FSD project where slice `index.ts` is the convention, or a published package's entry point.
- Use the path alias (`@/…`) for anything outside the current feature; relative imports within a feature.

## Review checklist

When reviewing or writing frontend code, flag:
- business rules computed inline in JSX or duplicated across components → `domain/`
- `fetch`/axios calls inside components → `api/`
- a feature importing another feature → compose in `app/` or move down to shared
- shared `utils`/`components` importing from a feature
- `useX` functions that call no hooks; lifecycle-wrapper hooks
- `useEffect` used to derive data or react to user events
- server data copied into local state
- components defined inside components; `containers/` folders
- boolean-prop explosion where composition fits
- a new top-level `constants.ts`/`utils.ts` entry used by one feature
- new barrel files
- Next.js: see the checklist in [references/nextjs-app-router.md](references/nextjs-app-router.md)

## Reference files

- [references/nextjs-app-router.md](references/nextjs-app-router.md) — Next.js App Router: `app/` role, server/client boundary, data access, Server Actions, Route Handlers, auth placement, route folders.
- [references/patterns.md](references/patterns.md) — worked code for the tricky cases.
- [references/enforcement.md](references/enforcement.md) — ESLint rules that enforce the dependency direction.
