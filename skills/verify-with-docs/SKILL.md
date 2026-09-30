---
name: verify-with-docs
description: Verify library/API claims against current docs with citations. Use only when the prompt contains the uppercase keyword "API".
---

Before stating anything about a library, check it in the official docs for the version in the project's lockfile.

- Verify every claim, including every library call in code you write, not just the ones you're unsure of.
- Link each claim to the page it came from. Only cite URLs you actually fetched; never construct one.
- Mark anything you couldn't confirm as **Unverified**, and say why.
