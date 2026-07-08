function dp --description 'chezmoi: add, commit progress, push'
    chezmoi git -- add -A
    if chezmoi git -- diff --cached --quiet
        echo "Nothing to commit, working tree clean"
    else
        chezmoi git -- commit -m "progress"
        chezmoi git -- push
    end
end
