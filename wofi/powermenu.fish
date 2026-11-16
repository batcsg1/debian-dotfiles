#!/usr/bin/env fish

# wofi resolves @import against its working directory, so start it from here.
cd (dirname (status filename))

set entries "󰐥 Shutdown" " Reboot" " Suspend" "󰩈 Exit Hyprland"

set selected (string join \n $entries | wofi --dmenu --conf ~/.config/wofi/powermenu-config --style ~/.config/wofi/powermenu-style.css --prompt "Menu")

switch "$selected"
    case "󰐥 Shutdown"
        systemctl poweroff
    case " Reboot"
        systemctl reboot
    case " Suspend"
        systemctl suspend
    case "󰩈 Exit Hyprland"
        hyprctl dispatch exit
end
