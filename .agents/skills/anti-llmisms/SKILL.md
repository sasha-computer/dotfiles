---
name: anti-llmisms
description: >
  Strip LLM-style writing from text. Removes em-dash spam, banned vocabulary,
  negation definitions, significance puffery, -ing tails, ad language, rule-of-three
  stacks, synonym-hopping, outline conclusions, and chatbot leakage.
  Use when user says "anti-llm", "de-llm", "remove llmisms", "fix llm style",
  or invokes /anti-llmisms. Apply to markdown, prose, comments, docs.
---

# Anti-LLMisms

- **BANNED: negative parallelism (contrastive reframe).** Never define by negation. Say what something IS, not what it is not. The pattern: dismiss/reject X, then assert Y. Applies even without the word "not". Covers:
  - Obvious: "it's not X, it's Y" / "not X, but Y" / "not just X, but also Y" / "no X, no Y, just Z" / "forget X, focus on Y" / "less X, more Y" / "X is dead, Y is the future" / "you don't need X, you need Y" / "the question is not X, it's Y"
  - Sneaky: "while X may seem..." / "sure, X..." / "at first glance, X..." / "most people think X..." / "X gets all the attention, but Y..." — if it pivots to Y, rewrite
  - Sneaky pivot words (fine alone, banned in reframe): but, yet, actually, really, instead, rather, ultimately, in reality, the truth is, what matters is
  - Across sentences: "Most teams think they have a hiring problem. They have a standards problem." → rewrite as direct claim
  - Fix: delete the rejected half, rewrite the positive claim as a direct sentence
  - Allowed: factual corrections ("Tuesday, not Thursday"), legal/technical distinctions, dates, numbers, names
- **Banned words:** additionally, align with, boasts, bolstered, crucial, delve, emphasizing, enduring, enhance, fostering, garner, highlight, interplay, intricate, key (adj), landscape (abstract), meticulous, pivotal, robust, showcase, tapestry, testament, underscore, valuable, vibrant
- **Use plain verbs:** is/has not serves as/boasts/features, shows not highlights, important not crucial/pivotal, complex not intricate, careful not meticulous, proof not testament
- **No significance puffery:** stands as, is a testament, vital role, setting the stage for, indelible mark, deeply rooted, evolving landscape, focal point
- **No -ing tails:** "...highlighting/underscoring/reflecting/contributing to/enhancing..." at sentence ends. Cut them.
- **No ad language:** nestled, vibrant, rich, renowned, groundbreaking, diverse array, in the heart of, commitment to
- **No rule-of-three stacks** — one or two adjectives, not three
- **No synonym-hopping** — repetition is human, don't cycle through synonyms
- **No outline conclusions** — "Despite its X, faces challenges... Future Outlook..."
- **No em dash spam** — use commas/parentheses; if you must, no spaces around them
- **No emoji as formatting, no thematic breaks before headings, no title-case headings**
- **No chatbot leakage:** "I hope this helps", "Certainly!", "let me know", "here is a", "worth noting", "In summary", "as of my last knowledge update"
- **No vague attribution:** "Experts argue", "Industry reports", "several sources" (when you mean one)
- **Prefer:** concrete facts over vague praise, short over verbose, direct over hedged, specific over generic
