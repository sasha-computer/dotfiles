# Bootstrap to GitHub Repo

Turn an idea file OR existing project into a GitHub repo with issues, ready for automated implementation. Input: $ARGUMENTS

## Instructions

### 1. Determine Mode

Check if we're in an existing project (mid-project lift) or starting from an idea:

**Mid-Project Lift Mode** (when inside a project directory in `~/Developer/`):
- Current directory is in `~/Developer/` but has no GitHub remote
- OR user explicitly asks to bootstrap "this repo" or "this project"
- Skip to Step 2b

**Idea Mode** (traditional flow):
- Use `$ARGUMENTS` to find idea file in `~/Ideas/`
- Continue with Step 2a

### 2a. Parse the Idea File (Idea Mode)

If `$ARGUMENTS` is provided, look for a matching file in `~/Ideas/`:
- Try exact match: `~/Ideas/$ARGUMENTS.md`
- Try with `.md` extension if not provided
- If no match, list available ideas and ask user to pick one

If no argument given, list all `.md` files in `~/Ideas/` (excluding `_TEMPLATE.md`) and ask user to select.

Read the selected idea file and extract:
- **Title**: From the H1 header
- **Description**: From "What is it?" section (this becomes the repo description)
- **Features**: From "Key features" section (these become issues)
- **Notes**: Additional context for issue creation

### 2b. Parse Existing Project (Mid-Project Lift Mode)

Read the project's `CLAUDE.md` and/or `README.md` to understand:
- **Title**: From directory name or H1 header
- **Description**: From project overview section
- **Features**: From documented features, TODOs, or ask user for planned work
- **Current State**: What's already implemented vs what needs issues

If the project lacks clear feature documentation, ask the user what issues they want created.

### 3. Generate Repo Name

For **Idea Mode**: Generate a three-word repo name:
- Pick three random, unrelated English words
- Format as `word-word-word` (kebab-case)
- Words should be memorable and slightly whimsical
- Examples: `atrocious-hug-otter`, `velvet-piano-dust`, `quantum-pickle-dance`

For **Mid-Project Lift Mode**: Use the existing directory name, or ask if user wants a different name.

Show the user the name and repo description. Ask for confirmation before proceeding.

### 4. Create/Connect GitHub Repo

**Idea Mode**:
```bash
gh repo create <name> --private --description "<description>"
cd ~/Developer
gh repo clone <name>
cd <name>
```

**Mid-Project Lift Mode** (existing directory with git):
```bash
gh repo create <name> --private --description "<description>" --source=. --remote=origin --push
```

**Mid-Project Lift Mode** (no git yet):
```bash
git init
gh repo create <name> --private --description "<description>" --source=. --remote=origin --push
```

### 5. Create Atomic Issues

For each feature/task identified, create GitHub issues:
- Break down features into the smallest actionable units
- Each issue should be completable in a single focused session
- Use clear, imperative titles (e.g., "Add hash comparison for files")
- Issue body should include:
  - Brief context
  - Acceptance criteria (what "done" looks like)
  - Any relevant notes

Use `gh issue create --title "..." --body "..."` for each issue.

### 6. Add ralph-wiggum Script

Copy the automation script to the repo:

```bash
cp ~/Ideas/ralph-wiggum ./ralph-wiggum
chmod +x ralph-wiggum
git add ralph-wiggum
git commit -m "Add ralph-wiggum automation script

I'm helping!"
git push
```

### 7. Update Source (if applicable)

**Idea Mode**: Update the original idea file:
- Change Status from "Draft" to "In Progress"
- Add a "## Repo" section at the end with:
  - Link to the GitHub repo
  - The repo name for reference

**Mid-Project Lift Mode**: No idea file to update, but optionally add repo URL to CLAUDE.md if not present.

### 8. Summary

Print a summary:
- Repo URL
- Number of issues created
- Remind user they can run `./ralph-wiggum` to start automated implementation
