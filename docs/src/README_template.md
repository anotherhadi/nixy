
# Nixy

**Nixy** is a Hyprland NixOS configuration with home-manager, secrets and custom theming all in one place.
It's a simple way to manage your system configuration and dotfiles.

## Table of Content

{md_table_of_content}

## Gallery

![nixy1](docs/src/nixy/1.png)
![nixy2](docs/src/nixy/2.png)
![nixy3](docs/src/nixy/3.png)

## Architecture

- 🏠 `home` are the dotfiles and configuration files for the user
- 💻 `hosts` are the system configuration files
  - 'laptop' is my own configuration for my laptop with nvidia
  - 'server' is for my nixos server (w/nextcloud, nginx, vaultwarden, ... look `hosts/modules/server`)
  - 'guest' is a *template* that you can copy and modify for *your own system*
  - 'themes' contains all the *themes* available (see [THEMES.md](docs/THEMES.md))
  - 'modules' are some nix modules that you can import (nvidia, prime, fonts, ...)
- 🤫 `secrets` are the secrets files encrypted with sops

## Installation

```sh
git clone https://github.com/anotherhadi/nixy ~/.config/nixos
```

- Copy the `hosts/guest` folder, rename it to your system name and change the variables inside the `variables.nix` file
- Add your `hardware-configuration.nix` to your new hosts folder
- Add your 'nixosConfigurations' inside `flake.nix` (You can edit the "yourhostname" one and change the lines containing #CHANGEME)

```sh
sudo nixos-rebuild switch --flake ~/.config/nixos#your_hostname
```

## Documentation

- [THEMES.md](docs/THEMES.md): How themes work and how to create your own
- [APPS.md](docs/APPS.md): Which apps are installed
- [SCRIPTS.md](docs/SCRIPTS.md): Scripts that are available
- [TODO.md](docs/TODO.md): What's next (feel free to contribute)
- [CONTRIBUTING.md](docs/CONTRIBUTING.md): How to contribute
- [LICENSE](LICENSE): MIT License
