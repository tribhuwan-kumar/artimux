#!/usr/bin/env bash
#<------------------------------TYM widget for ARTITMUX------------------------------------>
MPV_SOCKET_PATH="/tmp/mpvsocket"
CURRENT_PANE_PID=$(tmux display-message -p '#{pane_pid}')
TYM_PID=$(ps aux | grep "/usr/local/bin/tym" | grep -v grep | awk '{print $2}' | tail -n 1)
CURRENT_PANE_TYMID=$(pgrep -P $CURRENT_PANE_PID | xargs -n 1 pstree -p | grep -oP 'bash\(\K\d+(?=\))' | tail -n 1)

# Rename current window
if [ -n "$TYM_PID" ] && [ -n "$CURRENT_PANE_TYMID" ] && [ "$CURRENT_PANE_TYMID" == "$TYM_PID" ]; then
    tmux rename-window " ƬƳ𐒄 ℓινє.."
fi

# MPV socket activation check
mpv_socket_active() {
    nc -U -z -w1 "$MPV_SOCKET_PATH" >/dev/null 2>&1
    return $?
}

# Get media info
echo_info() {
    if mpv_socket_active; then
        MEDIA_TITLE=$(echo '{ "command": ["get_property", "media-title"] }' | socat - /tmp/mpvsocket | jq -r '.data')
        PLAY_STATE=$(echo '{ "command": ["get_property", "pause"] }' | socat - /tmp/mpvsocket | jq -r '.data')
        LOOP_STATUS=$(echo '{ "command": ["get_property", "loop"] }' | socat - /tmp/mpvsocket | jq -r '.data')
    else
        exit 0
    fi
}

echo_info

# Echo media info in tmux status bar
WIN_WIDTH=$(tmux display -p '#{window_width}')

if [ "$WIN_WIDTH" -lt 151 ]; then
    echo -ne ""
else
    if [ "$PLAY_STATE" == "false" ]; then
        if [ "$LOOP_STATUS" == "inf" ]; then
            echo -e " ❬ 󰛤  󰽰 $(echo "$MEDIA_TITLE" | sed 's/[^a-zA-Z0-9 ]//g' | awk '{print $1,$2,$3}').."
        else
            echo -e " ❬ 󰽰 $(echo "$MEDIA_TITLE" | sed 's/[^a-zA-Z0-9 ]//g' | awk '{print $1,$2,$3}').."
        fi
    else
        if [ "$LOOP_STATUS" == "inf" ]; then
            echo -e " ❬ 󰛤   $(echo "$MEDIA_TITLE" | sed 's/[^a-zA-Z0-9 ]//g' | awk '{print $1,$2,$3}').."
        else
            echo -e " ❬  $(echo "$MEDIA_TITLE" | sed 's/[^a-zA-Z0-9 ]//g' | awk '{print $1,$2,$3}').."
        fi
    fi
fi

