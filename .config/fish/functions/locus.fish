# Start the Locus learning chat app in a detached tmux session.
function locus --description 'Start Locus in a detached tmux session'
    argparse --name=locus --max-args=0 h/help s/stop a/attach -- $argv
    or return

    if set --query _flag_help
        printf '%s\n' \
            'Usage: locus [OPTIONS]' \
            '' \
            'Start the Locus app in a detached tmux session running npm run serve.' \
            'If a session already exists, report its status.' \
            '' \
            'Options:' \
            '  -a, --attach  Attach to the running tmux session' \
            '  -s, --stop    Stop the Locus tmux session' \
            '  -h, --help    Show this help message'
        return
    end

    set --local session_name locus
    set --local project_dir ~/Developer/locus

    if not command --search --quiet tmux
        echo (set_color red)"locus: tmux is not installed"(set_color normal) >&2
        return 1
    end

    if tmux has-session -t $session_name 2>/dev/null
        if set --query _flag_stop
            tmux kill-session -t $session_name
            echo (set_color green)"locus: session stopped"(set_color normal)
            return
        end
        if set --query _flag_attach
            tmux attach-session -t $session_name
            return
        end
        echo (set_color yellow)"locus: already running (session: $session_name)"(set_color normal)
        echo "  Attach with: locus --attach"
        echo "  Stop with:   locus --stop"
        return
    end

    if set --query _flag_stop
        echo (set_color yellow)"locus: no running session to stop"(set_color normal)
        return
    end
    if set --query _flag_attach
        echo (set_color red)"locus: no running session to attach to"(set_color normal) >&2
        return 1
    end

    if not test -d $project_dir
        echo (set_color red)"locus: project directory not found at $project_dir"(set_color normal) >&2
        return 1
    end

    tmux new-session -d -s $session_name -c $project_dir 'npm run serve'
    echo (set_color green)"locus: started in detached tmux session ($session_name)"(set_color normal)
    echo "  Attach with: locus --attach"
    echo "  Stop with:   locus --stop"
end
