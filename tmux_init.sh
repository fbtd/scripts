#!/usr/bin/env bash

DEFAULT_WINDOW=1
SESSION_NAME="main"
CONFIG_FOLDER="$HOME/.config/tmux_init"
DELAY=0.2

say() {
    printf 'tmux_init: %s\n' "$1"
}

err() {
    say "$1" >&2
    exit 1
}

generate_command () {
    config_path="$CONFIG_FOLDER/$1"
    [[ ! -h $config_path ]] && echo -n "bash -i" && return 0
    source_cmd=""
    if [[ -f $config_path/.tmux.sh ]]; then
        source_cmd="&& . .tmux.sh"
    fi
    cd_cmd="cd "$(readlink $config_path)
    echo -n "bash -i -c \"$cd_cmd $source_cmd && exec bash\""
}

which tmux >/dev/null || err "tmux not found"
[ -v TMUX ] && err "do not nest tmux sessions!"


tmux list-sessions || tmux start-server
tmux list-sessions | grep "^$SESSION_NAME" && err "session already running"

tmux new-session -x $COLUMNS -y $LINES -d -n 1 -s $SESSION_NAME "$(generate_command 0)"
sleep $DELAY
tmux new-window -n 1 -t $SESSION_NAME -e C=$COLUMNS "$(generate_command 1)"
sleep $DELAY
tmux new-window -n 2 -t $SESSION_NAME "$(generate_command 2)"
sleep $DELAY
tmux new-window -n 3 -t $SESSION_NAME "$(generate_command 3)"
sleep $DELAY
tmux new-window -n 4 -t $SESSION_NAME "$(generate_command 4)"
sleep $DELAY
tmux new-window -n 5 -t $SESSION_NAME "$(generate_command 5)"
sleep $DELAY
tmux new-window -n 6 -t $SESSION_NAME "$(generate_command 6)"
sleep $DELAY

tmux attach -t $SESSION_NAME:$DEFAULT_WINDOW
