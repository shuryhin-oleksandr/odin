---
name: best-practice
description: Verify best-practice recommendations against authoritative, current sources with citations. Use only when the prompt contains the uppercase keyword "BP".
---

Before recommending a practice, check it against authoritative sources: official guides (for the version the project uses), standards and security guidance (RFCs, W3C, OWASP), well-known style guides, and writing by the tool's maintainers or recognized experts. Not Q&A sites or anonymous blog posts.

- Verify every recommendation you make, and the main design choices in code you write.
- Link each recommendation to the page it came from, noting its author and date. Only cite URLs you actually fetched; never construct one.
- Where authoritative sources disagree, or a practice is convention rather than guidance, say so and show both sides.
- Check the practice fits the project (scale, stack, constraints). If it doesn't, say so rather than recommending it anyway.
- Mark anything you couldn't confirm as **Unverified**, and say why.
