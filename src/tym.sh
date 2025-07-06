#!/usr/bin/env bash
#<------------------------------Shell application for streaming Youtube Music in CLI (TYM)------------------------------------>
# author : @tribhuwan-kumar
# email : trashbhuwan@proton.me
#<------------------------------------------------------------------------------------------>

# Print usage
function print_usage() {
  cat <<EOF
󰋼 See the github page https://github.com/tribhuwan-kumar/Artimux for usage.
EOF
exit
}

# Define parse
HELP=false
REPEAT=false
SHUFFLE=false

QUERY=""
NUM_RESULTS=1
MUSIC_DIR="$HOME/Music/tym"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -h|--help)
            HELP=true
            shift
            ;;
        -r|--repeat)
            REPEAT=true
            shift
            ;;
        -s|--shuffle)
            SHUFFLE=true
            shift
            ;;
        --)
            shift
            break
            ;;
        -*|--*)
            print_usage
            ;;
        *)
            QUERY="$QUERY $1"
            shift
            ;;
    esac
done


# Check tym directory
if [ ! -d "$MUSIC_DIR" ]; then
    mkdir -p "$MUSIC_DIR"
fi

# Check dependencies
if ! command -v jq &> /dev/null; then
    error "jq was not found, please install it!!"
elif ! command -v mpv &> /dev/null; then
    error "mpv was not found, please install it!!"
elif ! command -v yt-dlp &> /dev/null; then
    error "youtube-dl was not found, please install it!!"
elif ! command -v nc &> /dev/null; then
    error "openbsd-netcat was not found, please install it!!"
elif ! command -v atomicparsley &> /dev/null; then
    error "atomicparsley was not found, please install it!!"
fi

# Play
function play() {
    mpv --input-ipc-server=/tmp/mpvsocket --no-video --msg-level=all=no "$1"
    wait $!
}

# Play in loop
function play_loop() {
    mpv --input-ipc-server=/tmp/mpvsocket --no-video --msg-level=all=no --loop "$1"
    wait $!
}

# Play shuffle playlist
function shuffle_playlist() {
    local -a SONGS=("$MUSIC_DIR"/*)
    local PLAYLIST_PATH="/tmp/playlist.m3u"

    find "$MUSIC_DIR" -type f | shuf > "$PLAYLIST_PATH"

    if [ ! -s "$PLAYLIST_PATH" ]; then
        echo " Playlist is empty"
        exit 1
    fi

    script -q -c "mpv --playlist=\"$PLAYLIST_PATH\" --input-ipc-server=/tmp/mpvsocket --no-video --term-playing-msg='󰽰 \${media-title}' --msg-level=all=info" /dev/null | grep '󰽰'
}

# Shuffle playlist
if [ "$SHUFFLE" = true ]; then
    shuffle_playlist
    exit 0
fi

# Help message
if [ "$HELP" = true ]; then
    print_usage
fi

# Handle empty query
if [ -z "$QUERY" ]; then
    echo "❬  ƬƳ𐒄 ℓινє.."
    exit 0
fi

# Existing song search command, maybe its weird but it works 🥴, I poluted the grep, I'm sorry
read -ra SPLIT_QUERY <<< "${QUERY:1}"
EXISTING_SONG=$(find "$MUSIC_DIR" -type f | grep -i -E ".*${SPLIT_QUERY[0]}.*${SPLIT_QUERY[1]}.*${SPLIT_QUERY[2]}.*${SPLIT_QUERY[3]}.*${SPLIT_QUERY[4]}.*${SPLIT_QUERY[5]}.*" | head -n 1)
SONG_TITLE=$(basename "$EXISTING_SONG")

# Playing conditions
if [ -n "$EXISTING_SONG" ]; then
    echo "󰽰 $SONG_TITLE"

    if [ "$REPEAT" = true ]; then
        play_loop "$EXISTING_SONG"
        exit 0
    else
        play "$EXISTING_SONG"
        exit 0
    fi
else
    # Fetch query
    echo "󰥖 ${QUERY:1}"
    RESULTS=$(yt-dlp --default-search "ytsearch" -j "ytsearch$NUM_RESULTS:${QUERY:1}" --match-filters "duration>80")
    URLS=$(echo "$RESULTS" | jq -r '.webpage_url')
    TITLES=$(echo "$RESULTS" | jq -r '.fulltitle')

    # Download
    echo "󰦗 ${QUERY:1}"
    yt-dlp -o "$MUSIC_DIR/${QUERY:1}.%(ext)s" --extract-audio --audio-format mp3 --audio-quality 320K --embed-thumbnail --add-metadata "$URLS" >/dev/null 2>&1
    DOWNLOADING_PID=$!
    wait $DOWNLOADING_PID

    if [ -f "$MUSIC_DIR/${QUERY:1}.mp3" ]; then
        echo "󱑤 ${QUERY:1}"
    else
        echo " ${QUERY:1}"
        exit 1
    fi

    SONG_PATH="$MUSIC_DIR/${QUERY:1}.mp3"
    if [ "$REPEAT" = true ]; then
        echo "󰽰 ${QUERY:1}"
        play_loop "$SONG_PATH"
        exit 0
    fi
    echo -e "󰽰 ${QUERY:1}..."
    play "$SONG_PATH"
fi

