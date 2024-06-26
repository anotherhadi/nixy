
**Nixy** is a **Hyprland** NixOS configuration with **home-manager**, **secrets**, and **custom theming** all in one place.
It's a simple way to manage your system configuration and dotfiles.

## Table of Content

{md_table_of_content}

## Gallery

![catppuccin1](docs/src/catppuccin/1.png)
![catppuccin2](docs/src/catppuccin/2.png)
![catppuccin3](docs/src/catppuccin/3.png)

## Architecture

- 🏠 `home` are the dotfiles and configuration files for the users
  - 'programs' is a collection of apps configured with home-manager
  - 'scripts' is a folder full of bash scripts (see [SCRIPTS.md](docs/SCRIPTS.md))
  - 'system' is some desktop environment like configuration
  - 'wallpapers' are... wallpapers
- 💻 `hosts` are the system configuration files
  - 'laptop' is my configuration for my laptop with Nvidia
  - 'server' is for my homeserver (w/nextcloud, nginx, vaultwarden, ... look `hosts/server`)
  - 'guest' is a *template* that you can copy and modify for *your own system*
  - 'themes' contains all the *themes* available *(see [THEMES.md](docs/THEMES.md))*
  - 'modules' are some nix modules that you can import (Nvidia, prime, fonts, ...)

## Installation

```sh
git clone https://github.com/anotherhadi/nixy ~/.config/nixos
```

- Copy the `hosts/guest` folder, rename it to your system name, and change the variables inside the `variables.nix` file
- Add your `hardware-configuration.nix` to your new host's folder
- Add your 'nixosConfigurations' inside `flake.nix` (You can edit the "yourhostname" one and change the lines containing '# CHANGEME')

> [!NOTE]
> When you add new files, don't forget to run `git add .` to add them to the git repository

```sh
sudo nixos-rebuild switch --flake ~/.config/nixos#yourhostname
```

## Documentation

- [THEMES.md](docs/THEMES.md): How themes work and how to create your own
- [APPS.md](docs/APPS.md): Which apps are installed
- [SCRIPTS.md](docs/SCRIPTS.md): Scripts that are available
- [TODO.md](docs/TODO.md): What's next (feel free to contribute)
- [CONTRIBUTING.md](docs/CONTRIBUTING.md): How to contribute
- [LICENSE](LICENSE): MIT Licensey
