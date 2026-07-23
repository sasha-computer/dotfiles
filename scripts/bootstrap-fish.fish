#!/usr/bin/env fish

if not type -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish --output /tmp/fisher_installer.fish
    source /tmp/fisher_installer.fish
    fisher install jorgebucaran/fisher
    rm -f /tmp/fisher_installer.fish
end

fisher update
