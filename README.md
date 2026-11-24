# dotfiles — ROG Mech

Hyprland desktop on Debian, themed after `hypr/wallpapers/rog_mech.jpg`:
a mechanical ROG eye behind a dark chain-link mesh, glowing red, with a
single bolt of electric blue.

## Palette

| Role      | Hex       | Where it comes from            |
|-----------|-----------|--------------------------------|
| crust     | `#06090d` | darkest shadows                |
| base      | `#0b1015` | blue-black backdrop            |
| surface0  | `#161d26` | mesh in shadow                 |
| surface1  | `#222b36` | mesh                           |
| surface2  | `#343a45` | gunmetal plating               |
| overlay   | `#555c68` | steel edges                    |
| steel     | `#8794a6` | brushed metal                  |
| subtext   | `#a9b6c6` | lit mesh highlights            |
| text      | `#d6dde6` | chrome                         |
| chrome    | `#eef2f6` | specular highlights            |
| red       | `#ff2233` | ROG glow                       |
| red_hi    | `#ff5566` | glow bloom                     |
| red_mid   | `#c41a28` | glow falloff                   |
| red_deep  | `#6b0a12` | red reflections on the floor   |
| red_bg    | `#24090e` | red-tinted shadow              |
| volt      | `#b8d4ff` | lightning                      |
| volt_dim  | `#6f93c4` | lightning falloff              |

Red is the only loud colour; volt is used sparingly (links, git branch,
download speed, urgent states). Corners are square everywhere to match the
angular mech.

The palette is repeated in each tool's native format:

- `kitty/theme.conf`
- `waybar/colors.css`, `wofi/colors.css` and `nwg-dock-hyprland/colors.css` (GTK `@define-color`, keep in sync)
- `starship/starship.toml` (`[palettes.rog_mech]`)
- `starship/proxmox.toml` (same prompt in Proxmox orange for the Proxmox host; copy to `/root/.config/starship.toml` there)
- `btop/themes/rog-mech.theme`
- `hypr/hyprland.lua` (`colors` table), `hypr/hyprlock.conf` (variables)
- `fastfetch/config.jsonc`, `mako/config`
- `nvim/lua/plugins/colorscheme.lua` (LazyVim + tokyonight, `rog` table)
- `vscode/rog-mech-theme/` (local extension, linked into `~/.vscode/extensions`; select "ROG Mech")
- `openrgb/rog-mech.sh` (sets motherboard RGB and saves `openrgb/rog-mech.orp`, loaded at Hyprland startup)
- `tty-clock/rog-mech.sh` (wrapper with the clock's flags; tty-clock has no config file and inherits kitty's ANSI colours. SUPER + C opens it floating)
- `gtk/` (GTK 2/3/4 settings, copied by `install.sh`; UI and hyprlock font JetBrainsMono Nerd Font)
- `pipes/rog-mech.sh` (pipes.sh wrapper, Debian package `pipes-sh`; installed as `pipes`; ROG red, steel and volt pipes from kitty's ANSI colours)
- `cool-retro-term/rog-mech.json` (profile; `rog-mech.sh` stores it in cool-retro-term's database and opens it, bound to SUPER + ALT + T. Flat screen on purpose: curvature draws a fixed grey bezel)
- `nwg-dock-hyprland/style.css` (dock; `launch.sh` starts one at the bottom of every monitor at Hyprland startup. Not packaged for Debian 13, build it from [source](https://github.com/nwg-piotr/nwg-dock-hyprland))
  `hypr/scripts/steam-apps.sh` gives each installed Steam game its own `steam_app_<id>.desktop` so it can be pinned; rerun after installing a game

## Install

```sh
./install.sh   # symlinks each directory into ~/.config, backing up what's there
```

## Keybinds (SUPER)

| Key            | Action                        |
|----------------|-------------------------------|
| T / F / B / M  | terminal / yazi / browser / launcher |
| ALT + T        | cool-retro-term               |
| C              | tty-clock (floating, ESC or DELETE closes) |
| ALT + P        | pipes (fullscreen, any key closes) |
| SHIFT + M      | power menu                    |
| ALT + S        | region screenshot             |
| L              | lock                          |
| Q              | save session (hyprflow)       |
| X              | exit Hyprland                 |
| S / R          | shutdown / reboot (immediate) |
| SHIFT + P / R  | shutdown / reboot (confirm)   |
| V / P / J      | float / pseudo / toggle split |
| DELETE         | close window                  |
| SHIFT + Q      | close every window            |
