#!/usr/bin/env bash

# script to rename the tmux window based on the pid
pane_pids=$(tmux list-panes -F '#{pane_pid}')

for pid in $pane_pids; do
    ssh_cmd=$(pstree -p $pid | grep -o 'ssh([0-9]\+)' | head -n1)
    if [ -n "$ssh_cmd" ]; then
        ssh_pid=$(echo "$ssh_cmd" | grep -o '[0-9]\+')
        ssh_args=$(ps -p $ssh_pid -o args=)
        ssh_target=$(echo "$ssh_args" | awk '{for(i=2;i<=NF;i++) if ($i !~ /^-/) {print $i; exit}}')
        tmux rename-window "$ssh_target"
        break
	else
		tmux rename-window "$(basename "$(tmux display-message -p '#{pane_current_path}')")"
		break
    fi
done
