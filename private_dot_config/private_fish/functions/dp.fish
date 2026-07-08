function dp --description 'chezmoi: re-add, commit progress, push'
    echo (set_color blue)"Refreshing Brewfile..."(set_color normal)
    brew bundle dump --global --force --quiet
    echo (set_color blue)"Finding dotfile changes..."(set_color normal)
    chezmoi re-add --quiet
    chezmoi git -- add -A
    set changed (chezmoi git -- diff --cached --name-only)
    if test (count $changed) -eq 0
        echo (set_color green)"No changes found, working tree clean"(set_color normal)
    else
        echo (set_color yellow)"Changes in:"(set_color normal)
        for file in $changed
            echo "  $file"
        end
        echo (set_color blue)"Committing and pushing..."(set_color normal)
        chezmoi git -- commit -m "progress"
        chezmoi git -- push
    end
end
