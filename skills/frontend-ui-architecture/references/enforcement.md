# Enforcing the dependency rules

Conventions erode without tooling. Pick the option that matches the project's structure. Adding a lint package is an installation step — give the user the install command instead of running it.

## Option A: `import/no-restricted-paths` (eslint-plugin-import)

Used by Bulletproof React. Adjust feature names and folders to the project.

```js
// eslint.config.mjs (flat config) — rule excerpt
'import/no-restricted-paths': ['error', {
  zones: [
    // features don't import each other (one zone per feature)
    { target: './src/features/cart', from: './src/features', except: ['./cart'] },
    { target: './src/features/invoices', from: './src/features', except: ['./invoices'] },

    // one direction: shared → features → app
    { target: './src/features', from: './src/app' },
    {
      target: ['./src/components', './src/hooks', './src/lib', './src/types', './src/utils', './src/config'],
      from: ['./src/features', './src/app'],
    },
  ],
}],
```

Install (for the user to run): `npm i -D eslint-plugin-import` (or `eslint-plugin-import-x`).

## Option B: eslint-plugin-boundaries

Declarative element types (`app`, `feature`, `shared`) with allow/deny rules between them; better error messages and supports "feature may only import another feature's public file". See https://github.com/javierbrea/eslint-plugin-boundaries for the config syntax of the installed version.

## Option C: Feature-Sliced Design projects

Use the FSD linter `steiger` (https://github.com/feature-sliced/steiger), which knows layer and slice rules.

## Next.js server/client safety

Not a lint rule, but the same idea: `import 'server-only'` at the top of DAL, services and `lib/db.ts` makes the build fail if client code imports them.

## Also useful

- `no-restricted-imports` to ban DB/ORM packages outside `features/*/server/**` and `lib/db.ts`.
- `react-hooks` rules (`rules-of-hooks`) catch non-hook functions misnamed `useX` only partially — review manually.
