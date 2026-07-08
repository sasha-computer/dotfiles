set fish_greeting

set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_NO_INSTALL_CLEANUP 1
set -gx HOMEBREW_NO_ENV_HINTS 1

set -gx EDITOR nvim

if status is-interactive
    alias cdd 'cd ~/Developer/'
    alias docs 'cd ~/Documents/'
    alias oc opencode

    alias gl 'git log --oneline'
    alias gcm 'git commit -m'
    alias gaa 'git add .'
    alias gs 'git status'
    alias gf 'git fetch'
    alias gfp 'git fetch --prune'
    alias gpl 'git pull'
    alias gp 'git push'
    alias gc 'git checkout'
    alias gcb 'git checkout -b'
    alias gcl 'git clone'
    alias grv 'git remote -v'

    alias v nvim
    alias vf 'chezmoi edit ~/.config/fish/config.fish'
    alias vg 'chezmoi edit ~/.config/ghostty/config.ghostty'
end
