set fish_greeting

set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_NO_INSTALL_CLEANUP 1
set -gx HOMEBREW_NO_ENV_HINTS 1

set -gx EDITOR nvim

fish_add_path ~/.bun/bin 2>/dev/null

if status is-interactive
    alias cdd 'cd ~/dotfiles'
    alias docs 'cd ~/Documents/'
    alias oc opencode

    alias gb 'git branch -a'
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

    alias grep rg

    alias v nvim
    alias vf 'nvim ~/.config/fish/config.fish'
    alias vg 'nvim ~/.config/ghostty/config.ghostty'
    alias vb 'nvim ~/dotfiles/Brewfile.laptop'
end
