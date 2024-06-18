[//]: # (Title: Nixy)  
[//]: # (Description: Nixy is a NixOS configuration with home-manager, secrets and custom theming all in one place. It's a simple way to manage your system configuration and dotfiles.)  
[//]: # (Author: Hadi)  
[//]: # (Date: 06/17/24)

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

**Nixy** is a NixOS configuration with home-manager, secrets and custom theming all in one place.
It's a simple way to manage your system configuration and dotfiles.

## Table of Content

- [Nixy](#nixy)
  - [Table of Content](#table-of-content)
  - [Gallery](#gallery)
  - [Architecture](#architecture)
  - [Installation](#installation)
  - [Documentation](#documentation)

## Gallery

![nixy1](docs/src/nixy/1.png)
![nixy2](docs/src/nixy/2.png)
![nixy3](docs/src/nixy/3.png)

## Architecture

- 🏠 `home` are the dotfiles and configuration files for the user
- 💻 `hosts` are the system configuration files
  - `laptop` is mine
  - `guest` is a template that you can copy and modify for your own system
  - `themes` contains all the themes available (see [THEMES.md](docs/THEMES.md))
  - `modules` are some nix files that you can import (nvidia, prime, fonts, ...)
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
