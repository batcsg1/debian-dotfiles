#!/usr/bin/env bash
# Gives every installed Steam game its own app entry, so it can be pinned to
# nwg-dock-hyprland. Games run through Steam get the window class
# steam_app_<id>, and the dock only matches a window to an app whose .desktop
# file has that exact name. Run again after installing a game.
steam=$(readlink -f "$HOME/.steam/steam")
apps=${XDG_DATA_HOME:-$HOME/.local/share}/applications
icons=${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor
mkdir -p "$apps"

# every Steam library folder, the default one included
libraries=$(sed -n 's/^\s*"path"\s*"\(.*\)"/\1/p' "$steam/steamapps/libraryfolders.vdf")

while read -r lib; do
  for manifest in "$lib"/steamapps/appmanifest_*.acf; do
    [ -f "$manifest" ] || continue
    id=$(sed -n 's/^\s*"appid"\s*"\(.*\)"/\1/p' "$manifest")
    name=$(sed -n 's/^\s*"name"\s*"\(.*\)"/\1/p' "$manifest")
    # Steam's own tools aren't games
    case $name in Proton* | "Steam Linux Runtime"* | Steamworks*) continue ;; esac

    icon=steam
    ls "$icons"/*/apps/"steam_icon_$id.png" > /dev/null 2>&1 && icon=steam_icon_$id

    # A shortcut Steam made already shows the game in wofi; hide this one there
    # so it isn't listed twice (the dock still uses it)
    hidden=false
    grep -l "steam://rungameid/$id\$" "$apps"/*.desktop 2> /dev/null \
      | grep -qv "/steam_app_$id.desktop\$" && hidden=true

    cat > "$apps/steam_app_$id.desktop" << EOF
[Desktop Entry]
Name=$name
Comment=Play this game on Steam
Exec=steam steam://rungameid/$id
Icon=$icon
Terminal=false
Type=Application
Categories=Game;
NoDisplay=$hidden
EOF
    echo "steam_app_$id  $name"
  done
done <<< "$libraries"
