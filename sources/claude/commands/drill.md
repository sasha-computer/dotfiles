# Drill Flashcards

Start a hashcards drill session and assist with card edits.

**User input:** $ARGUMENTS

## Instructions

1. **Start hashcards in background:**
   ```bash
   hashcards drill ~/Documents/2026/Cards
   ```
   Run this as a background process so the user can drill in their browser.

2. **Handle errors:**
   - If hashcards errors on a specific card (parsing error, invalid format, etc.), read the problematic deck file
   - Read `~/.claude/context/spaced-repetition.md` for the rules
   - Fix the card according to SR best practices
   - Restart the drill process

3. **Assist with edits:**
   - The user will drill cards in their browser and send messages about cards they want to edit
   - When user describes a card to edit, search the deck files in `~/Documents/2026/Cards/` to find it
   - Use the SR principles when suggesting improvements:
     - Atomic (one concept per card)
     - Two-way questions (term→definition and definition→term)
     - Brief answers (answerable in seconds)
     - Include memorable hooks (etymologies, mnemonics, factoids)
   - Use AskUserQuestion to confirm changes before applying

4. **Common edit requests:**
   - "This card is too hard" → Break into smaller atomic cards
   - "The answer is wrong" → Fix the answer
   - "I keep getting this wrong" → Add a mnemonic or rephrase
   - "This is a duplicate" → Delete one of them
   - "Add a reverse" → Create the opposite direction card
