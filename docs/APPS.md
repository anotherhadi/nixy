# Apps and services

*non-exhaustive lists*

## Laptop

The laptop configuration is used by an Omen 16 laptop w/ nvidia and an amd gpu running NixOS.
The configurations files can be found in the `hosts/laptop` directory.

| Category                                | Name           |
|-----------------------------------------|----------------|
| WM                                      | Hyprland       |
|                                         | hyprlock       |
|                                         | hyprpaper      |
|                                         | hypridle       |
|                                         | wlogout        |
| Bar                                     | waybar         |
| Terminal                                | kitty          |
| Shell                                   | zsh            |
|                                         | tmux           |
|                                         | starship       |
|                                         | bat            |
|                                         | eza            |
|                                         | zoxide         |
|                                         | fzf            |
| Editor                                  | neovim(nixvim) |
| File manager                            | lf             |
|                                         | thunar         |
| Browser                                 | qutebrowser    |
| Music                                   | spicetify      |
| Notifications                           | dunst          |
| Launcher                                | wofi           |
| DM                                      | tuigreet       |
| Secrets                                 | sops-nix       |
| Misc                                    | lazygit        |
|                                         | neofetch       |
|                                         | cava           |
| See [hosts/laptop](../hosts/laptop/)... |                |

## Server

The server configuration is used by a home server running NixOS.
The configurations files can be found in the `hosts/server` directory.
I mainly use it for self-hosting websites and services such as Nextcloud, Vaultwarden, ...
I exposed some services to the internet using a reverse proxy (Nginx) and cloudflare-dyndns, others are accessed through a tailscale network

### Apps

- Nextcloud
- Vaultwarden
- Adguard Home
- Unifi Controler
- Uptime Kuma
- "Jackflix"
  - Jellyfin, Transmission, *arr
- See [hosts/server](../hosts/server/)...
