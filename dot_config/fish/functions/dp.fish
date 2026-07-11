function dp --description 'stage, commit progress, push dotfile changes'
    cd ~/src/github.com/sasha-computer/dotfiles
    git add -A
    set changed (git diff --cached --name-only)
    if test (count $changed) -eq 0
        echo (set_color green)"No changes found, working tree clean"(set_color normal)
    else
        echo (set_color yellow)"Changes in:"(set_color normal)
        for file in $changed
            echo "  $file"
        end
        echo (set_color blue)"Committing and pushing..."(set_color normal)
        git commit -m "progress" && git push
    end
end
