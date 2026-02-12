#!/usr/bin/env bash
set -euo pipefail

# If first arg is "rtorrent" or starts with "-", run rtorrent
# rtorrent auto-discovers config at:
#   $HOME/.rtorrent.rc
#   $HOME/.config/rtorrent/rtorrent.rc
#   /etc/rtorrent/rtorrent.rc
if [ "${1:-}" = "rtorrent" ] || [ "${1:0:1}" = "-" ]; then
    if [ "$1" = "rtorrent" ]; then shift; fi
    exec rtorrent "$@"
fi

# Otherwise exec whatever was passed (allows `docker exec` flexibility)
exec "$@"
