#!/usr/bin/env bash
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# title      Artimux												  +
# repository https://github.com/tribhuwan-kumar/Artimux				  +
# author     Lógico                                                   +
# email      hi@logico.com.ar                                         +
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

RESET="#[fg=brightwhite,bg=default,nobold,noitalics,nounderscore,nodim]"
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Status bars length
tmux set -g status-left-length 80
tmux set -g status-right-length 150

# Highlight colors
tmux set -g mode-style "fg=#090909,bg=#a9b1d6"
tmux set -g status-style "bg=default"
tmux set -g message-style "fg=#a9b1d6"
tmux set -g pane-border-style "fg=#a9b1d6"
tmux set -g message-command-style "fg=#a9b1d6,bg=default"
tmux set -g pane-active-border-style "fg=#a9b1d6"

# Vars
SCRIPTS_PATH="$CURRENT_DIR/src"
TMUX_VARS="$(tmux show -g)"
PANE_BASE="$(echo "$TMUX_VARS" | grep pane-base-index | cut -d" " -f2 | bc)"

# Styles
default_window_id_style="none"
default_pane_id_style="hsquare"
default_zoom_id_style="dsquare"

window_id_style="$(echo "$TMUX_VARS" | grep '@tokyo-night-tmux_window_id_style' | cut -d" " -f2)"
pane_id_style="$(echo "$TMUX_VARS" | grep '@tokyo-night-tmux_pane_id_style' | cut -d" " -f2)"
zoom_id_style="$(echo "$TMUX_VARS" | grep '@tokyo-night-tmux_zoom_id_style' | cut -d" " -f2)"
window_id_style="${window_id_style:-$default_window_id_style}"
pane_id_style="${pane_id_style:-$default_pane_id_style}"
zoom_id_style="${zoom_id_style:-$default_zoom_id_style}"

battery="#($SCRIPTS_PATH/battery.sh)"
tym="#($SCRIPTS_PATH/tym-widget.sh)"
netspeed="#($SCRIPTS_PATH/netspeed.sh)"
time="#($SCRIPTS_PATH/time-widget.sh)"
cmus_status="#($SCRIPTS_PATH/music-tmux-statusbar.sh)"
git_status="#($SCRIPTS_PATH/git-status.sh #{pane_current_path})"
window_number="#($SCRIPTS_PATH/custom-number.sh #I $window_id_style)"
custom_pane="#($SCRIPTS_PATH/custom-number.sh #P $pane_id_style)"
zoom_number="#($SCRIPTS_PATH/custom-number.sh #P $zoom_id_style)"

#+--- Bars LEFT ---+
# Session name
tmux set -g status-left "#[fg=#bbc0c8,bold] #{?client_prefix,󰠠 ,#[dim]󰤂 }#[fg=#bbc0c8,bold,nodim]#S $RESET"

#+--- Windows ---+
# Focus
tmux set -g window-status-separator ""
tmux set -g window-status-current-format "#[fg=#44dfaf]  #[fg=#c0caf5]$window_number #[bold,nodim]#W#[nobold,dim]#{?window_zoomed_flag, $zoom_number, $custom_pane} #{?window_last_flag,,} "
# Unfocused
tmux set -g window-status-format "#[fg=#c0caf5,none,dim]  $window_number #W#[nobold,dim]#{?window_zoomed_flag, $zoom_number, $custom_pane}#[fg=#e5a340] #{?window_last_flag,󰁯 ,} "

#+--- Bars RIGHT ---+
tmux set -g status-right "$git_status#[fg=#8a8cab]$battery#[fg=#8a8cab]$netspeed$time$tym$cmus_status"
