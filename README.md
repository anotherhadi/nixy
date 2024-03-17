# Nixy

This is my dotfiles repo. It's a work in progress, and I'm still learning how to use nix.

# Images

![neofetch](https://image.nostr.build/c208c164ae04e4c58e01adb9fab584b163a565155865833851275f89c9270b7a.jpg)
![qutebrowser](https://image.nostr.build/8cc32d981e6be256bdc37a2571c31bb76d7c3335ce7c76fa6eca89a03019bfc9.jpg)
![spotify](https://image.nostr.build/76b18bcbcdf1d911a2dbdff7bfac6652044d45602a3dce9d9c53feb295d13245.jpg)
![wofi](https://image.nostr.build/90d69ffe6251c17e25b0fb44abadaeb0dfe6db8210d935fca14bf8b00be49fa6.jpg)

# Apps

| Category       | Software      |
|----------------|---------------|
| WM             | Hyprland      |
|                | - hyprlock    |
|                | - hyprpaper   |
|                | - hypridle    |
|                | - wlogout     |
| File manager   | - lf          |
|                | - thunar      |
| Terminal       | kitty         |
| Shell          | zsh           |
|                | - starship    |
|                | - bat         |
|                | - eza         |
|                | - zoxide      |
|                | - fzf         |
| Editor         | nixvim        |
| Browser        | qutebrowser   |
| Music          | spicetify     |
| Bar            | waybar        |
| Notifications  | dunst         |
| Launcher       | wofi          |
| DM             | tuigreet      |
| Secrets        | sops-nix      |

# Themes & Colors

Themes and colors are managed by the `home/variable/theme` folder.

# Scripts

## Nix/NixOs shortcuts

- `nixy-edit`
- `nixy-rebuild`
- `nixy-update`
- `nixy-gc` # garbage collection
- `nixy-cb` # clean boot menu

## Brightness control

- `brightness-up`
- `brightness-down`
- `brightness-change <up/down> <increment>`

## Sound control

- `sound-up`
- `sound-down`
- `sound-toggle`
- `sound-output`
- `sound-change <up/down/mute> <increment>`

## Caffeine

Caffeine is a simple script that toggles hypridle (disable suspend & screenlock).

- `caffeine` # Toggle caffeine
- `caffeine-status` # Return active/inactive

## Night-Shift

Blue light filter, using wlsunset

- `night-shift-on`
- `night-shift-off`

# Installation

```sh
git clone https://github.com/anotherhadi/nixy ~/.config/nixos
```

- Every things that you *must* change got a "CHANGEME" comment. You can search for it with ripgrep: `rg "CHANGEME"`
- Every things that you *must* remove got a "REMOVE" comment. You can search for it with ripgrep: `rg "REMOVE"` (Secrets, own stuff..)
- Change the `nixos/configuration.nix` file to match your system
- Copy your `hardware-configuration.nix` file to the `nixos` folder

```sh
sudo nixos-rebuild switch --flake ~/.config/nixos#nixy
```

# TODOLIST

- [ ] Variable user & homeDir
- [ ] Custom GTK based on the colorscheme
- [ ] Obsidian.nvim on every markdown file
- [ ] Caffeine & Night-Shift replace notif
- [ ] Make hyprcursor working
