# Intercept brew install commands and route them through mise for declarative package management.
function brew --description "Wrap brew install to use mise bootstrap packages"
    if test "$argv[1]" != install
        command brew $argv
        return
    end

    set --local is_cask false
    set --local packages

    for arg in $argv[2..-1]
        switch $arg
            case --cask
                set is_cask true
            case --formula
                set is_cask false
            case '--*'
                continue
            case '*'
                set --append packages $arg
        end
    end

    if test (count $packages) -eq 0
        printf '%s\n' "brew: no packages specified" >&2
        return 1
    end

    for pkg in $packages
        if test $is_cask = true
            mise bootstrap packages use -g "brew-cask:$pkg"
        else
            mise bootstrap packages use -g "brew:$pkg"
        end
    end
end
