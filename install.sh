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

for dir in btop fastfetch hypr kitty mako waybar wofi; do
  link "$repo/$dir" "$config/$dir"
done
link "$repo/starship/starship.toml" "$config/starship.toml"
