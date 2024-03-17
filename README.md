# Nixy

This is my dotfiles repo. It's a work in progress, and I'm still learning how to use nix.

## Images

![neofetch](https://image.nostr.build/c208c164ae04e4c58e01adb9fab584b163a565155865833851275f89c9270b7a.jpg)
![qutebrowser](https://image.nostr.build/8cc32d981e6be256bdc37a2571c31bb76d7c3335ce7c76fa6eca89a03019bfc9.jpg)
![spotify](https://image.nostr.build/76b18bcbcdf1d911a2dbdff7bfac6652044d45602a3dce9d9c53feb295d13245.jpg)
![wofi](https://image.nostr.build/90d69ffe6251c17e25b0fb44abadaeb0dfe6db8210d935fca14bf8b00be49fa6.jpg)

## Apps

<details>
<summary>Click to expand</summary>

| Category       | Software      |
|----------------|---------------|
| WM             | Hyprland      |
|                | hyprlock      |
|                | hyprpaper     |
|                | hypridle      |
|                | wlogout       |
| Bar            | waybar        |
| Terminal       | kitty         |
| Shell          | zsh           |
|                | starship      |
|                | bat           |
|                | eza           |
|                | zoxide        |
|                | fzf           |
| Editor         | nixvim        |
| File manager   | lf            |
|                | thunar        |
| Browser        | qutebrowser   |
| Music          | spicetify     |
| Notifications  | dunst         |
| Launcher       | wofi          |
| DM             | tuigreet      |
| Secrets        | sops-nix      |

</details>

## Themes & Colors

Themes and colors are managed by the `home/variable/theme` folder.

## Scripts

### Nix/NixOs shortcuts

<details>
<summary>Click to expand</summary>

- `nixy-edit`
- `nixy-rebuild`
- `nixy-update`
- `nixy-gc` # garbage collection
- `nixy-cb` # clean boot menu

</details>

### Brightness control

<details>
<summary>Click to expand</summary>

- `brightness-up`
- `brightness-down`
- `brightness-change <up/down> <increment>`

</details>

### Sound control

<details>
<summary>Click to expand</summary>

- `sound-up`
- `sound-down`
- `sound-toggle`
- `sound-output`
- `sound-change <up/down/mute> <increment>`

</details>

### Caffeine

<details>
<summary>Click to expand</summary>

Caffeine is a simple script that toggles hypridle (disable suspend & screenlock).

- `caffeine` # Toggle caffeine
- `caffeine-status` # Return active/inactive

</details>

### Night-Shift

<details>
<summary>Click to expand</summary>

Blue light filter, using wlsunset

- `night-shift-on`
- `night-shift-off`

</details>

## Installation

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

## TODOLIST

<details>
<summary>Click to expand</summary>

- [ ] Variable user & homeDir
- [ ] Custom GTK based on the colorscheme
- [ ] Obsidian.nvim on every markdown file
- [ ] Caffeine & Night-Shift replace notif
- [ ] Make hyprcursor working

</details>
