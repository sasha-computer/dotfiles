# Start Study Session

Begin a study session with a reference file from your Obsidian vault.

**User input:** $ARGUMENTS (optional - filename or topic)

## Instructions

1. **If argument provided:**
   - Search `~/Documents/2026/References/` for matching file
   - If exact match, read it
   - If no match, list available files and ask user to pick

2. **If no argument:**
   - List files in `~/Documents/2026/References/`
   - Ask: "What would you like to study today?"

3. **Once file is selected:**
   - Read the file (or relevant section if PDF is large)
   - Offer: "Ready to study **[filename]**. I can:
     - Explain concepts as you read
     - Quiz you on the material
     - Just answer questions as they come up

     What would you like?"

4. **During the session:**
   - Track concepts discussed for later flashcard extraction
   - After substantial Q&A (3+ exchanges), offer to extract flashcards

5. **Flashcard extraction:**
   - Follow the `/learnings` command logic for extracting cards from conversation
   - Or use `/flashcards` logic if generating from specific text/topic
   - See `~/.claude/skills/study-session/flashcard-guide.md` for card generation rules
   - Always read `~/.claude/context/spaced-repetition.md` before generating cards

6. **At session end:**
   - Offer flashcard extraction if not already done
   - Offer to log session to daily journal
   - See `~/.claude/skills/study-session/journal-format.md` for entry format:
     `- Studied [[filename]] - [topic], added N cards on [topics]`

## Related Commands & Skills

- `/learnings` - Extract flashcards from conversation history
- `/flashcards` - Generate flashcards from text, file, or topic
- `~/.claude/skills/study-session/` - Full skill with:
  - `SKILL.md` - Main skill instructions
  - `flashcard-guide.md` - Card generation rules
  - `journal-format.md` - Daily note format

## Key Paths

- References: `~/Documents/2026/References/`
- Cards: `~/Documents/2026/Cards/`
- Daily Journal: `~/Documents/2026/Journal/Daily/`
- SR Guide: `~/.claude/context/spaced-repetition.md`
