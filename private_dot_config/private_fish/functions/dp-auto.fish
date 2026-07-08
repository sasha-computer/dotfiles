function dp-auto --description 'chezmoi: silent auto-backup for launchd'
    echo (date)" - Refreshing Brewfile..."
    brew bundle dump --global --force --quiet 2>/dev/null
    chezmoi re-add 2>/dev/null
    chezmoi git -- add -A
    set changed (chezmoi git -- diff --cached --name-only)
    if test (count $changed) -eq 0
        echo (date)" - No changes, working tree clean"
    else
        echo (date)" - Changes in: $changed"
        chezmoi git -- commit -m "progress"
        chezmoi git -- push
        echo (date)" - Pushed to origin/main"
    end
end
