#!/usr/bin/env bash
set -euo pipefail

# If first arg is "rtorrent" or starts with "-", run rtorrent inside tmux.
# rtorrent auto-discovers config at:
#   $HOME/.rtorrent.rc
#   $HOME/.config/rtorrent/rtorrent.rc
#   /etc/rtorrent/rtorrent.rc
if [ "${1:-}" = "rtorrent" ] || [ "${1:0:1}" = "-" ]; then
    if [ "$1" = "rtorrent" ]; then shift; fi

    SESSION="rtorrent"

    # Ensure required directories exist (best-effort — HOME may be read-only)
    mkdir -p "$HOME/.session" "$HOME/download" 2>/dev/null || true

    # Start rtorrent inside a named tmux session so it can be attached/detached
    # without interrupting the process (e.g. via: kubectl exec -it <pod> -- tmux attach -t rtorrent)
    # SHELL must be set explicitly — the rtorrent system user has /sbin/nologin in /etc/passwd,
    # which tmux would otherwise use as its default-shell.
    SHELL=/bin/sh tmux new-session -d -s "$SESSION" "rtorrent $*"

    # Forward SIGTERM/SIGINT to rtorrent for graceful shutdown
    trap 'pkill -TERM -x rtorrent 2>/dev/null || true' TERM INT

    # Block until the tmux session ends (rtorrent exited)
    while tmux has-session -t "$SESSION" 2>/dev/null; do
        sleep 1
    done

    exit 0
fi

# Otherwise exec whatever was passed (allows `docker exec` flexibility)
exec "$@"
