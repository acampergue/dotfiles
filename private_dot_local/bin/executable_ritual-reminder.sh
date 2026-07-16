#!/bin/sh
# Reminder for the daily-rituals Claude skills (/morgen, /feierabend).
# Pings only if the ritual has not run today (marker written by the skill).
ritual="$1" # morgen | feierabend
marker="$HOME/.claude/rituals/last-$ritual"
[ "$(cat "$marker" 2>/dev/null)" = "$(date +%F)" ] && exit 0

msg="Zeit für /$ritual?"
notify-send -u normal "Claude daily-rituals" "$msg" 2>/dev/null && exit 0

# No notification daemon (e.g. bare sway): fall back to sway's nagbar.
# systemd user services don't inherit the session env — derive the sockets.
uid=$(id -u)
export SWAYSOCK="${SWAYSOCK:-$(ls /run/user/$uid/sway-ipc.* 2>/dev/null | head -1)}"
if [ -z "$WAYLAND_DISPLAY" ]; then
    WAYLAND_DISPLAY=$(basename "$(ls /run/user/$uid/wayland-? 2>/dev/null | head -1)")
    export WAYLAND_DISPLAY
fi
exec swaynag -t warning -m "Claude daily-rituals: $msg"
