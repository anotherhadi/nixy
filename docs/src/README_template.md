
# Nixy

**Nixy** is a NixOS configuration with home-manager, secrets and custom theming all in one place.
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
  - 'server' is for my nixos server
  - 'guest' is a *template* that you can copy and modify for *your own system*
  - 'themes' contains all the *themes* available (see [THEMES.md](docs/THEMES.md))
  - 'shared' are some nix modules that you can import (nvidia, prime, fonts, ...)
- 🤫 `secrets` are the secrets files encrypted with sops

## Installation

```sh
git clone https://github.com/anotherhadi/nixy ~/.config/nixos
```

- Change the username in the flake.nix file
- import the guest configuration instead of the `hosts/laptop` one
- import your hardware-configuration.nix into the `hosts/guest` folder

```sh
sudo nixos-rebuild switch --flake ~/.config/nixos#nixy
```

## Documentation

- [THEMES.md](docs/THEMES.md): How themes work and how to create your own
- [APPS.md](docs/APPS.md): Which apps are installed
- [SCRIPTS.md](docs/SCRIPTS.md): Scripts that are available
- [TODO.md](docs/TODO.md): What's next (feel free to contribute)
- [CONTRIBUTING.md](docs/CONTRIBUTING.md): How to contribute
- [LICENSE](LICENSE): MIT License
