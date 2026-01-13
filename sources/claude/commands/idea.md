# Capture New Idea

The user wants to capture a new project idea. Their input: $ARGUMENTS

## Instructions

1. Parse the user's input to extract:
   - **Idea name**: Create a short, kebab-case filename (e.g., "telegram-bot-for-downloads" from "Telegram bot for downloads")
   - **Description**: The core concept they described
   - **Why/Value**: Any mentioned benefits or problems it solves

2. Read the template from `~/Ideas/_TEMPLATE.md`

3. Create a new file at `~/Ideas/<idea-name>.md` using the template structure:
   - Set the title to the idea name
   - Set Status to "Draft"
   - Fill in "What is it?" with their description
   - Fill in "Why build it?" if they mentioned benefits
   - Leave other sections with placeholder text if not provided

4. Confirm to the user:
   - The file was created
   - Show the path
   - Briefly summarize what was captured

If the user's input is vague or missing, ask clarifying questions before creating the file.
