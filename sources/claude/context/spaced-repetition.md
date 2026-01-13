# Spaced Repetition Best Practices

Distilled from [Effective Spaced Repetition](https://borretti.me/article/effective-spaced-repetition) by Fernando Borretti.

## Core Principles

### 1. Understand First
Master concepts before memorizing. Don't create cards for material you don't understand yet.

### 2. Make Cards Atomic
Each card should test ONE piece of knowledge. Cards should be "like chemical bonds, linking individual atoms of knowledge."

Bad: "List all 6 noble gases" (too much)
Good: "Is Helium a noble gas?" + separate cards for each

### 3. Write Two-Way Questions
For term/definition pairs, always create both directions:
- Term → Definition: "What is X?"
- Definition → Term: "What do you call Y?"

### 4. Ask Multiple Ways
Approach the same knowledge from different angles:
- Formal definition
- Informal explanation
- Example recognition
- Counter-examples

### 5. Keep Answers Brief
If you can't answer in a few seconds, the card is too complex. Break it down.

### 6. Use Hierarchies
For categories and classifications:
- Top-down: "What are the subtypes of X?"
- Bottom-up: "What is Y a kind of?"

## When Generating Cards

1. Extract key concepts, definitions, and distinctions
2. Create atomic Q/A pairs
3. Include reverse cards where applicable
4. Prefer concrete examples over abstract definitions
5. Avoid yes/no questions when possible (prefer "What/How/Why")

## Output Format (Hashcards)

### Question-Answer Cards
```
Q: Question text
A: Answer text
```
Both Q and A can span multiple lines for longer content.

### Cloze Deletion Cards
```
C: Text with [deletion] that gets hidden.
```
Multiple deletions in one card create sibling cards (one per gap):
```
C: An [agonist] is a ligand that [activates] a receptor.
```
This generates two cards: one hiding "agonist", one hiding "activates".

**When to use cloze:** Great for fill-in-the-blank style learning, definitions with key terms, or sentence completion. Use Q/A for more complex questions.

### LaTeX Math (if needed)
- Inline: `$E = mc^2$`
- Display: `$$\sum_{i=1}^{n} i$$`

Write to: `~/Documents/2026/Cards/<deck-name>.md`
