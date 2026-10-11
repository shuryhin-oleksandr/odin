---
name: lib-comparison
description: Compare libraries using GitHub stars, download counts, and deprecation status. Use when the user asks to compare libraries, packages, or frameworks, or to pick between several of them.
---

For each library being compared, gather these from live sources. Never fill them in from memory.

- **GitHub stars:** Get the current star count from the repo page or `https://api.github.com/repos/<owner>/<repo>` (`stargazers_count`).
- **Downloads:** Get the count for a stated period from the ecosystem's registry and name the period. Use the same period for every library.
  - npm: `https://api.npmjs.org/downloads/point/last-month/<package>`
  - PyPI: `https://pypistats.org/api/packages/<package>/recent` (`last_month`)
  - crates.io: `https://crates.io/api/v1/crates/<crate>` (`recent_downloads`, 90 days)
  - Other ecosystems: use the official registry's stats.
- **Deprecation / maintenance:** Check for each of these and report what you find:
  - A deprecation flag on the registry (npm `deprecated` field, PyPI "Inactive" classifier, yanked releases).
  - An archived GitHub repo (`archived: true`).
  - A deprecation notice or a pointer to a successor in the README.
  - The date of the last release and the last commit.

Present the results as a table with one row per library and columns for Stars, Downloads (period), Last release, and Status (Active / Deprecated / Archived / Stale). Then list each source URL you fetched. If you can't get a number, write "n/a" rather than guessing.

Flag any library that's deprecated or archived, and name its successor if it has one. Finish with a short recommendation.
