#!/usr/bin/env bash
#<------------------------------Time widget for ARTITMUX------------------------------------>

SHOW_TIME=$(tmux show-option -gv @Artimux_show_time)
if [ "$SHOW_TIME" != "true" ]; then
    exit 0
fi

WIDTH=$(tmux display -p '#{window_width}')
TIME_FORMAT=$(tmux show-option -gv @Artimux_time_format 2>/dev/null)

if [ "$WIDTH" -lt 131 ]; then
    echo -ne ""
else
    if [ "$TIME_FORMAT" == "24HR" ]; then
        TIME=$(date '+❬ %H:%M')
        echo " $TIME"
    elif [ "$TIME_FORMAT" == "12HR" ]; then
        TIME=$(date '+❬ %I:%M %p')
        echo " $TIME"
    fi
fi
