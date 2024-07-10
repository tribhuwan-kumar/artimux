#!/usr/bin/env bash
#<------------------------------------------Battery widget----------------------------------------->
RESET="#[fg=#8a8cab,bg=default,noblink]"
SHOW_BATTERY=$(tmux show-option -gv @Artimux_show_battery)
if [ "$SHOW_BATTERY" != "true" ]; then
    exit 0
fi

format_bat() {
    local CAPACITY=$1
    local STATUS=$2

    if [ "$STATUS" == "Charging" ]; then
        if [ "$CAPACITY" -lt 15 ]; then
            echo "❬ 󰢜 $CAPACITY% "
        elif [ "$CAPACITY" -lt 25 ]; then
            echo "❬ 󰂆 $CAPACITY% "
        elif [ "$CAPACITY" -lt 50 ]; then
            echo "❬ 󰂈 $CAPACITY% "
        elif [ "$CAPACITY" -lt 75 ]; then
            echo "❬ 󰢞 $CAPACITY% "
        elif [ "$CAPACITY" -lt 90 ]; then
            echo "❬ 󰂋 $CAPACITY% "
        elif [ "$CAPACITY" -lt 100 ]; then
            echo "❬ 󰂅 $CAPACITY% "
        fi
    else
        if [ "$CAPACITY" -lt 16 ]; then
            echo "❬ #[fg=##ff073f,blink]󱃍 $CAPACITY%$RESET "
        elif [ "$CAPACITY" -lt 25 ]; then
            echo "❬ 󰁻 $CAPACITY% "
        elif [ "$CAPACITY" -lt 50 ]; then
            echo "❬ 󰁽 $CAPACITY% "
        elif [ "$CAPACITY" -lt 75 ]; then
            echo "❬ 󰂀 $CAPACITY% "
        elif [ "$CAPACITY" -lt 90 ]; then
            echo "❬ 󰂂 $CAPACITY% "
        elif [ "$CAPACITY" -lt 100 ]; then
            echo "❬ 󰁹 $CAPACITY% "
        fi
    fi
}

battery_status() {
    BATTERIES=$(ls /sys/class/power_supply | grep BAT)
    for BATTERY in $BATTERIES; do
        BAT_PATH=/sys/class/power_supply/$BATTERY
        STATUS=$(cat "$BAT_PATH/status")
        CAPACITY=$(cat "$BAT_PATH/capacity")
    done
}

battery_status

WIN_WIDTH=$(tmux display -p '#{window_width}')
if [ "$WIN_WIDTH" -lt 131 ]; then
    echo -ne ""
else
    format_bat "$CAPACITY" "$STATUS"
fi
