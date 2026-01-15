fish_add_path ~/.local/bin

set fish_greeting
set -gx SSH_AUTH_SOCK ~/.1password/agent.sock

alias ll="ls -l"
alias gl="git log --oneline"
alias gcm="git commit -m"
alias gaa="git add ."
alias gs="git status"
alias gfp="git fetch --prune"
alias gpl="git pull"
alias gp="git push"
alias cdd="cd ~/Developer/"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gcl="git clone"
alias cc="claude --allow-dangerously-skip-permissions"
alias z.="zeditor ."
alias cfg="cd ~/Dotfiles/ && cc"

function get-ralph
    if test -z "$argv[1]"
        echo "Usage: get-ralph <project-name>"
        return 1
    end
    gh repo create $argv[1] -p neutronmoderator/ralph-wiggum --private --clone
end


# Hashcards drill in tmux (stays running when you switch terminals)
function drill
    if test "$argv[1]" = "stop"
        tmux kill-session -t drill 2>/dev/null && echo "Drill session stopped" || echo "No drill session running"
    else if test "$argv[1]" = "attach"
        tmux attach -t drill 2>/dev/null || echo "No drill session running"
    else if tmux has-session -t drill 2>/dev/null
        echo "Drill session already running at http://localhost:8000"
        echo "Use 'drill stop' to stop it, or 'drill attach' to view the tmux session"
    else
        tmux new-session -d -s drill "hashcards drill $HOME/Documents/2026/Cards $argv"
        echo "Drill started at http://localhost:8000"
        echo "Use 'drill stop' to stop, 'drill attach' to view session"
    end
end
