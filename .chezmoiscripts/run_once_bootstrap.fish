#!/usr/bin/env fish

# LazyVim
if not test -d "$HOME/.config/nvim"
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim/.git"
end

# Fisher
if not type -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher install jorgebucaran/fisher
end

# Fisher plugins (idempotent — skips already-installed)
fisher install jorgebucaran/hydro jethrokuan/z nickeb96/puffer-fish mattmc3/magic-enter.fish
