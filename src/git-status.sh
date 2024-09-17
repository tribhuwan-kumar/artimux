#!/usr/bin/env bash
#<-------------------------Git, branch name & pull indicator for ARTITMUX-------------------------------------->
cd "$1" || exit 1
RESET="#[fg=#8a8cab,bg=default,nobold]"
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    exit 0
fi

SYNC_STATUS=$(git fetch --atomic origin --negotiation-tip=HEAD & git status -uno)
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

if [[ $SYNC_STATUS =~ "Your branch is up to date" ]]; then
    echo " #[fg=#89b482,bold]󱍸  $BRANCH$RESET "

elif [[ $SYNC_STATUS =~ "Your branch is ahead of" ]]; then
    echo " #[fg=#e0af68,bold]󰵵  $BRANCH$RESET "

elif [[ $SYNC_STATUS =~ "Your branch is behind" ]]; then
    echo " #[fg=#f7768e,bold]󰁭  $BRANCH$RESET "

else
    echo " #[fg=#8a8cab,bold]󰕚  $BRANCH$RESET "
fi

sleep 900
