#!/usr/bin/env bash
# Symlink every config in this repo into ~/.config.
# Anything already there is moved aside to <name>.bak-<timestamp> first.
set -euo pipefail

repo=$(cd "$(dirname "$0")" && pwd)
config=${XDG_CONFIG_HOME:-$HOME/.config}
stamp=$(date +%Y%m%d-%H%M%S)

link() {
  local src=$1 dst=$2
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok      $dst"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak-$stamp"
    echo "backup  $dst -> $dst.bak-$stamp"
  fi
  ln -s "$src" "$dst"
  echo "link    $dst -> $src"
}

for dir in btop fastfetch hypr kitty mako nvim tty-clock waybar wofi; do
  link "$repo/$dir" "$config/$dir"
done
link "$repo/starship/starship.toml" "$config/starship.toml"

# VS Code loads unpacked extensions straight from ~/.vscode/extensions.
mkdir -p "$HOME/.vscode/extensions"
link "$repo/vscode/rog-mech-theme" "$HOME/.vscode/extensions/batcsg1.rog-mech-theme-0.1.0"

# OpenRGB rewrites its own folder, so the profile is copied rather than linked.
# Regenerate it with openrgb/rog-mech.sh.
mkdir -p "$config/OpenRGB"
if [ ! -e "$config/OpenRGB/rog-mech.orp" ]; then
  cp "$repo/openrgb/rog-mech.orp" "$config/OpenRGB/"
  echo "copy    $config/OpenRGB/rog-mech.orp"
fi
