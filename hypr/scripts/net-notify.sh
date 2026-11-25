#!/usr/bin/env bash
# Notifies (through mako) when the internet drops and when it comes back.
# Asks NetworkManager for a fresh connectivity check every 15s: link loss shows
# up at once, but a connection that stays up without internet would otherwise
# only be noticed at NetworkManager's next scheduled check, minutes later.
online=true
id=0

while :; do
  state=$(nmcli networking connectivity check 2>/dev/null)
  if [ "$state" = full ] && ! $online; then
    online=true
    # replace the "disconnected" card, which stays up until the connection returns
    notify-send -a Network -i network-transmit-receive -r "$id" \
      "Back online" "Internet connection restored"
  elif [ "$state" != full ] && $online; then
    online=false
    case $state in
      portal) why="Connected, but a login page (captive portal) is blocking the internet" ;;
      limited) why="Connected to the network, but it has no internet access" ;;
      *) why="No network connection" ;;
    esac
    id=$(notify-send -a Network -i network-offline -u critical -p "Internet disconnected" "$why")
  fi
  sleep 15
done
