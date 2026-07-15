function nnw-export --description 'Export NetNewsWire OPML to dotfiles'
    set -l src ~/Library/Application\ Support/NetNewsWire/Accounts/OnMyMac/Subscriptions.opml
    set -l dest ~/dotfiles/dot_config/netnewswire/Subscriptions.opml
    if test -f $src
        mkdir -p (dirname $dest)
        cp $src $dest
        echo "OPML exported. Run: dp"
    else
        echo "No NetNewsWire OPML found at $src"
    end
end
