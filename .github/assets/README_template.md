<div align="center">
    <img alt="nixy logo" src="https://raw.githubusercontent.com/anotherhadi/nixy/main/.github/assets/logo.png" width="120px" />
</div>

<br>

# Nixy

<br>
<div align="center">
    <a href="https://github.com/anotherhadi/nixy/stargazers">
        <img src="https://img.shields.io/github/stars/anotherhadi/nixy?color={primarycolor}&labelColor={backgroundcolor}&style=for-the-badge&logo=starship&logoColor={primarycolor}">
    </a>
    <a href="https://github.com/anotherhadi/nixy/">
        <img src="https://img.shields.io/github/repo-size/anotherhadi/nixy?color={primarycolor}&labelColor={backgroundcolor}&style=for-the-badge&logo=github&logoColor={primarycolor}">
    </a>
    <a href="https://nixos.org">
        <img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&labelColor={backgroundcolor}&logo=NixOS&logoColor={primarycolor}&color={primarycolor}">
    </a>
    <a href="https://github.com/anotherhadi/nixy/blob/main/LICENSE">
        <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&colorA={backgroundcolor}&colorB={primarycolor}&logo=unlicense&logoColor={primarycolor}"/>
    </a>
</div>
<br>

**Nixy simplifies and unifies** the Hyprland ecosystem with a modular, easily
customizable setup. It provides a structured way to manage your system
configuration and dotfiles with minimal effort. It includes _home-manager_,
_secrets_, and _custom theming_ all in one place.

**Features:**

- 💻 Hyprland-centric: Preconfigured Hyprland ecosystem (Hyprlock, Hyprpanel,
  etc.)
- 🎨 Consistent Theming: Base16 & Stylix-powered themes
- ⌨️ Vim-like Everywhere: Unified keybindings (Hyprland, nvim, vimium, etc.)

## Table of Content

{md_table_of_content}

## Gallery

![Nixy helper, peaclock](.github/assets/nixy/1.png)
![Qutebrowser, pipes, shell](.github/assets/nixy/2.png)
![nvim, lazygit](.github/assets/nixy/3.png)
![spotify, cava](.github/assets/nixy/4.png)

## Architecture

### 🏠 /home (User-level configuration)

Contains **dotfiles and settings** that apply to your user environment.

**Subfolders:**

- `programs` is a collection of apps configured with home-manager
- `scripts` is a folder full of bash scripts (see [SCRIPTS.md](docs/SCRIPTS.md))
- `system` is some "desktop environment" configuration

### 🐧 /nixos

Those are the system-level configurations. (audio, bluetooth, gpu, bootloader,
...)

### 🎨 /themes

This folder contains all system themes. Mainly
[stylix](https://stylix.danth.me/) configurations. Check out the available
themes and learn how to create your own in [THEMES.md](docs/THEMES.md)

### 💻 /hosts

This directory contains host-specific configurations. Each host includes:

- `configuration.nix` for system-wide settings
- `home.nix` for user-level configuration
- `variables.nix` for global variables
- `secrets/` for sensitive data

### 🖥️ /server-modules

This folder contains server-related nixos modules. (bitwarden, nextcloud, ...)

## Installation

1. [Fork](https://github.com/anotherhadi/nixy/fork) this repo and clone it to
   your system:

```sh
git clone https://github.com/anotherhadi/nixy ~/.config/nixos
```

2. Copy the `hosts/laptop` folder, rename it to match your system’s hostname,
   and update `variables.nix` with your machine’s settings.
3. Copy your `hardware-configuration.nix` into your new host's folder to ensure
   proper hardware support.
4. Register your new host in `flake.nix` by adding it under nixosConfigurations.

> [!IMPORTANT]
> `# CHANGEME` comments are placed throughout the config to
> indicate necessary modifications. Use the following command to quickly locate
> them:
>
> ```sh
> rg "CHANGEME" ~/.config/nixos
> ```

> [!TIP]
> When you add new files, don't forget to run `git add .` to add them to the git
> repository

5. Build the system

```sh
sudo nixos-rebuild switch --flake ~/.config/nixos#yourhostname
```

## Documentation

- [SERVER](docs/SERVER.md): Check out the server documentation
- [THEMES](docs/THEMES.md): How themes work and how to create your own
- [SCRIPTS](docs/SCRIPTS.md): A list of available scripts and their usage
- [KEYBINDINGS-HYPRLAND](docs/KEYBINDINGS-HYPRLAND.md): Keybindings available in
  Hyprland
- [WALLPAPERS](https://github.com/anotherhadi/awesome-wallpapers): An awesome
  collection of wallpapers

- [CONTRIBUTING](docs/CONTRIBUTING.md): How to contribute
- [LICENSE](LICENSE): MIT License
