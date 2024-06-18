[//]: # (Title: Nixy)  
[//]: # (Description: Nixy is a Hyprland NixOS configuration with home-manager, secrets and custom theming all in one place. It's a simple way to manage your system configuration and dotfiles.)  
[//]: # (Author: Hadi)  
[//]: # (Date: 06/18/24)

<div align="center">
    <img src="https://image.nostr.build/70ebe2b5183879d8c0ffa682cd0089e030ad01909678b242ed86449517eac3a5.png" width="100px" />
</div>

<br><br>

<div align="center">
    <a href="https://github.com/anotherhadi/nixy">
        <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=Version&message=2.0.0&colorA=040409&colorB=a158ff&logo=githubactions&logoColor=a158ff&"/>
    </a>
    <a href="https://github.com/anotherhadi/nixy/stargazers">
        <img src="https://img.shields.io/github/stars/anotherhadi/nixy?color=a158ff&labelColor=040409&style=for-the-badge&logo=starship&logoColor=a158ff">
    </a>
    <a href="https://github.com/anotherhadi/nixy/">
        <img src="https://img.shields.io/github/repo-size/anotherhadi/nixy?color=a158ff&labelColor=040409&style=for-the-badge&logo=github&logoColor=a158ff">
    </a>
    <a href="https://nixos.org">
        <img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&labelColor=040409&logo=NixOS&logoColor=a158ff&color=a158ff">
    </a>
    <a href="https://github.com/anotherhadi/nixy/blob/main/LICENSE">
        <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&colorA=040409&colorB=a158ff&logo=unlicense&logoColor=a158ff&"/>
    </a>
</div>

<br><br>

<div align="center">
    <img src="https://image.nostr.build/aaf8cf0f3b9784c817f8cf328f19222db2e1886dfb89ae97de83ffa101d437b4.png" width="600px" />
</div>

# Nixy

**Nixy** is a Hyprland NixOS configuration with home-manager, secrets and custom theming all in one place.
It's a simple way to manage your system configuration and dotfiles.

## Table of Content

- [Nixy](#nixy)
  - [Table of Content](#table-of-content)
  - [Gallery](#gallery)
  - [Architecture](#architecture)
  - [Installation](#installation)
  - [Documentation](#documentation)

## Gallery

![catppuccin1](docs/src/catppuccin/1.png)
![catppuccin2](docs/src/catppuccin/2.png)
![catppuccin3](docs/src/catppuccin/3.png)

## Architecture

- 🏠 `home` are the dotfiles and configuration files for the user
- 💻 `hosts` are the system configuration files
  - 'laptop' is my own configuration for my laptop with nvidia
  - 'server' is for my nixos server (w/nextcloud, nginx, vaultwarden, ... look `hosts/modules/server`)
  - 'guest' is a *template* that you can copy and modify for *your own system*
  - 'themes' contains all the *themes* available (see [THEMES.md](docs/THEMES.md))
  - 'modules' are some nix modules that you can import (nvidia, prime, fonts, ...)
- 🤫 `secrets` are the secrets files encrypted with sops-nix

## Installation

```sh
git clone https://github.com/anotherhadi/nixy ~/.config/nixos
```

- Copy the `hosts/guest` folder, rename it to your system name and change the variables inside the `variables.nix` file
- Add your `hardware-configuration.nix` to your new hosts folder
- Add your 'nixosConfigurations' inside `flake.nix` (You can edit the "yourhostname" one and change the lines containing '# CHANGEME')

```sh
sudo nixos-rebuild switch --flake ~/.config/nixos#yourhostname
```

## Documentation

- [THEMES.md](docs/THEMES.md): How themes work and how to create your own
- [APPS.md](docs/APPS.md): Which apps are installed
- [SCRIPTS.md](docs/SCRIPTS.md): Scripts that are available
- [TODO.md](docs/TODO.md): What's next (feel free to contribute)
- [CONTRIBUTING.md](docs/CONTRIBUTING.md): How to contribute
- [LICENSE](LICENSE): MIT License
