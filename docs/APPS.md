# Apps and services

*non-exhaustive list*

## Laptop

| Category       | Name          |
|----------------|---------------|
| WM             | Hyprland      |
|                | hyprlock      |
|                | hyprpaper     |
|                | hypridle      |
|                | wlogout       |
| Bar            | waybar        |
| Terminal       | kitty         |
| Shell          | zsh           |
|                | tmux          |
|                | starship      |
|                | bat           |
|                | eza           |
|                | zoxide        |
|                | fzf           |
| Editor         | neovim(nixvim)|
| File manager   | lf            |
|                | thunar        |
| Browser        | qutebrowser   |
| Music          | spicetify     |
| Notifications  | dunst         |
| Launcher       | wofi          |
| DM             | tuigreet      |
| Secrets        | sops-nix      |
| Misc           | lazygit       |
|                | neofetch      |
|                | cava          |
|                | ...           |

## Server

The server configuration is used by a home server running NixOS.
The configurations files can be found in the `hosts/server` directory.
I mainly use it for self hosting services like Nextcloud, Vaultwarden, ... and for hosting websites.
I exposed some services to the internet using a reverse proxy (Nginx) and cloudflare dns. (Also configured cloudflare-dyndns)

### Apps

- Nextcloud
- Vaultwarden
- Adguard Home
- Unifi Controler
- Uptime Kuma
- "Jackflix"
  - Jellyfin, Transmission, *arr
- ...
