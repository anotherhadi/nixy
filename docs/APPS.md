# Apps and services

*non-exhaustive lists*

## Laptop

The laptop configuration is used by an Omen 16 laptop w/ nvidia and an amd gpu running NixOS.
The configurations files can be found in the `hosts/laptop` directory.

| Category                                | Name           |
| --------------------------------------- | -------------- |
| WM                                      | Hyprland       |
|                                         | hyprlock       |
|                                         | hyprpaper      |
|                                         | hypridle       |
|                                         | hyprcursor     |
|                                         | wlogout        |
| Bar                                     | hyprpanel      |
| Terminal                                | kitty          |
| Shell                                   | zsh            |
|                                         | tmux           |
|                                         | starship       |
|                                         | bat            |
|                                         | eza            |
|                                         | zoxide         |
|                                         | fzf            |
| Editor                                  | neovim(nixvim) |
| File manager                            | thunar         |
| Browser                                 | qutebrowser    |
| Music                                   | spicetify      |
| Launcher                                | wofi           |
| DM                                      | tuigreet       |
| Secrets                                 | sops-nix       |
| See [hosts/laptop](../hosts/laptop/)... |                |

## Server

The server configuration is used by a home server running NixOS.
The configurations files can be found in the `hosts/server` directory.
I mainly use it for self-hosting websites and services such as Nextcloud, Vaultwarden, jellyfin, ...
I exposed some services to the internet using a reverse proxy (Nginx) and cloudflare-dyndns, others are accessed through a tailscale network
