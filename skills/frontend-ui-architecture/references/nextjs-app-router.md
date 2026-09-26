# Next.js App Router — architecture

Applies on top of SKILL.md. Only placement and boundaries; caching/streaming performance is out of scope.

## Contents
1. Role of `app/`
2. Structure
3. Server vs client placement
4. Data access: pick one model
5. Reads, mutations, endpoints
6. Server Actions
7. Auth placement
8. Route folders: private folders, groups, slots
9. Review checklist

## 1. Role of `app/`

`app/` is routing and composition. A `page.tsx`/`layout.tsx` reads `params`/`searchParams`, calls a feature's data function, and composes feature components. Business rules, SQL, and non-trivial transformations don't live in route files.

Next.js itself is unopinionated about project layout; two layouts are both legitimate:
- **Colocate in routes** — route-specific code in `app/**/_components`, `_lib` (private folders, not routable).
- **Features outside `app/`** — reusable code in `src/features/*`, routes import from there.

Default: combine them. Code used by one route → private folder next to the route. Code used by 2+ routes or holding business logic → `src/features/<f>`. Follow whatever the project already does.

## 2. Structure

```
src/
  app/
    (marketing)/page.tsx
    (app)/
      layout.tsx                  # shell only, no auth decisions
      invoices/
        page.tsx                  # thin: getInvoicesDTO() → <InvoiceTable/>
        [id]/
          page.tsx
          _components/            # UI for this route only
        @modal/(.)[id]/page.tsx   # intercepted route as modal
    api/webhooks/stripe/route.ts  # public endpoint
    providers.tsx                 # 'use client' providers
  features/
    invoices/
      components/
        invoice-table.tsx         # Server Component
        invoice-form.tsx          # 'use client' + useActionState
      server/
        invoices.dal.ts           # 'server-only': session check, queries, returns DTOs
        invoices.service.ts       # 'server-only': business operations with I/O
      actions.ts                  # 'use server': thin
      domain/                     # pure rules, usable on server and client
      schemas.ts                  # zod, shared by form, action, service
      constants.ts
  lib/
    db.ts                         # 'server-only'
    auth.ts                       # verifySession()
  components/ui/
proxy.ts                          # (middleware.ts before Next 16) optimistic redirects only
```

Keep server-only and client-safe code in separate files within a feature (`server/` vs `components/`, `domain/`), so a client component can never pull in a DB import through a shared module.

## 3. Server vs client placement

- **Server Component by default.** Add `'use client'` only at the entry of an interactive subtree — the leaf that needs state, effects, event handlers or browser APIs. Everything it imports joins the client bundle, so don't put the directive on pages or layouts.
- **Pass server content into client wrappers via `children`/slot props** rather than importing server components into client files. The component that writes the JSX (owner), not the one that renders it (parent), decides where it runs.
- **Props crossing server → client must be serializable and minimal.** Pass the fields the client needs, not a whole `User` or DB row. Functions can't cross, except Server Actions; name such props `action` or `…Action` (the Next TS plugin allows these).
- **Providers** (theme, QueryClient, feature context) are a separate `'use client'` component taking `children`, rendered in a layout as deep as possible.
- **Third-party components without `'use client'`** → wrap in your own one-line client file.
- **Compound components** (`Menu.Item`) break across the boundary — static members become undefined when a Server Component imports a client module. Export parts as named exports if Server Components use them.
- Mark server-only modules with `import 'server-only'` (DB, secrets, DAL) and browser-only ones with `import 'client-only'` so misuse fails at build.
- Built-in HTML covers some interactivity without client JS: `<form action={serverAction}>`, `<details>`.

## 4. Data access: pick one model

Per Next.js docs and Sebastian Markbåge's security post, choose **one** and don't mix — exceptions then stand out in review:

| Model | When | Where code lives |
|---|---|---|
| **External HTTP API** | existing backend (any language), separate team | `features/<f>/api/` fetchers called from Server Components with forwarded cookies; treat as zero-trust |
| **Data Access Layer (DAL)** | new full-stack Next.js projects | `features/<f>/server/*.dal.ts` + `lib/db.ts`, all `server-only` |
| Component-level queries | prototypes only | SQL inside Server Components — avoid in real projects |

DAL rules:
- Only the DAL imports the DB client and reads secret `process.env` values.
- Each DAL function checks the session/permissions itself (`verifySession()` wrapped in `React.cache`) — callers can't forget.
- Returns **DTOs**: only the fields the UI needs, already filtered by permission.
- Wrap per-request reads in `React.cache` so a layout and a page can both call `getCurrentUser()` without prop drilling.

## 5. Reads, mutations, endpoints

| Need | Use | Not |
|---|---|---|
| Read data for rendering | Server Component calling DAL/fetcher | Server Action (they run sequentially); your own `/api` route from a Server Component |
| Stream data into a client component | pass an un-awaited promise as prop, read with `use()` under `<Suspense>` | fetching again in `useEffect` |
| Client-driven data (polling, infinite scroll, offline, depends on browser state) | TanStack Query/SWR in a client component, optionally prefetched on the server + `HydrationBoundary` | copying server props into state |
| Mutation from the UI | Server Action | Route Handler |
| Public HTTP endpoint (webhook, OAuth callback, RSS, file, external clients) | Route Handler `route.ts` | Server Action |
| Pre-route redirect by cookie | `proxy.ts` | DB queries in proxy |

Fetch data in the component that needs it (identical `fetch` calls are deduped, DB calls via `cache`) rather than fetching everything in the page and drilling down. Keep a `preload()` helper next to the component that consumes the data.

Use the `searchParams` prop when params drive data loading; use `useSearchParams` when they only drive client-side filtering.

## 6. Server Actions

A Server Action is a **public POST endpoint**, whatever file it's defined in.

- Put them in a `'use server'` file per feature (`features/<f>/actions.ts`); inline actions in components only for trivial cases.
- Keep them thin: **authenticate → validate input (zod) → call DAL/service → revalidate (`revalidatePath`/`updateTag`) → return minimal result.** Business logic lives in the service/domain, where it's testable without Next.js internals.
- Accept **IDs plus the change**, not whole objects; load ownership and current data server-side. Schema validation checks shape, not permission.
- Return only what the UI needs (`{ ok: true }`, field errors), never raw DB records.
- Forms: action signature `(prevState, formData)` with `useActionState` in a client form component; `useFormStatus` in a submit button; extra args via `action.bind(null, id)`.
- Don't use actions for reads.

## 7. Auth placement

- Real checks live in the **DAL** (and are repeated inside every Server Action and Route Handler).
- **Not in layouts**: layouts don't re-render on navigation and don't stop nested segments or actions from running. `return null` in a layout is not protection.
- `proxy.ts` does optimistic cookie-based redirects only — no DB calls, never the only line of defense.
- Client components can't import the DAL; a server parent fetches and passes a narrow DTO (or context value) down.
- Role-based UI: a server leaf component calls `verifySession()` and returns `null` if not allowed — plus the matching action re-checks.

## 8. Route folders

- `_components`, `_lib` — private, non-routable; route-specific code.
- `(group)` — organize by section/team/layout (`(marketing)`, `(app)`, `(auth)`) without affecting URLs; enables different layouts or multiple root layouts.
- `@slot` + `(.)segment` — parallel and intercepting routes for modals/side panels that have their own URL, instead of global modal state.
- `[param]` folders are user input — validate `params`/`searchParams` before use.
- `loading.tsx`, `error.tsx`, `not-found.tsx` live beside the segment they cover.
- Use generated `PageProps<'/route'>` / `LayoutProps<'/route'>` types.
- FSD projects: keep Next's `app/` at the root, rename FSD layers to `_app`/`_pages` in `src/`, and let route files only re-export (`export { InvoicesPage as default } from '@/_pages/invoices'`).

## 9. Review checklist

- DB client or secret env imported outside the DAL / `server-only` modules
- `'use client'` on a page, layout or large subtree
- client component props typed as full domain/DB objects, tokens, private fields
- Server Action without its own auth/authorization check, or taking a whole object
- Server Action containing business logic or used for reading
- Server Component fetching from the app's own `/api/*`
- auth decided in a layout
- DB work in `proxy.ts`
- mixing HTTP-API and DAL models without a reason
- mutations performed during render (e.g. logout via `searchParams`)
