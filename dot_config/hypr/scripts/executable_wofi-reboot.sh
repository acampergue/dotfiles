#!/bin/bash -x
CHOICE=$(echo -e "reboot\nshutdown\nlogout\ncancel" | wofi --dmenu --width 200 --height 120 --prompt "Power Menu:")

case "$CHOICE" in
reboot)
  systemctl reboot
  ;;
shutdown)
  systemctl poweroff
  ;;
logout)
  loginctl terminate-user ""
  ;;
*)
  # Cancel or close: do nothing
  ;;
esac
