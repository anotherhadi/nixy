<h1 align="center">
   <img src="https://image.nostr.build/70ebe2b5183879d8c0ffa682cd0089e030ad01909678b242ed86449517eac3a5.png" width="100px" />
   <br>
      Nixy
   <br>
      <img src="https://image.nostr.build/aaf8cf0f3b9784c817f8cf328f19222db2e1886dfb89ae97de83ffa101d437b4.png" width="600px" /> <br>
   <div align="center">

   <div align="center">
      <p></p>
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
      <br>
   </div>
</h1>

**Nixy** is a NixOS configuration with home-manager, secrets and custom theming all in one place.
It's a simple way to manage your system configuration and dotfiles.

## Table of Contents

- [Gallery](#gallery)
- [Architechture](#architechture)
- [Settings, Themes and colors](#settings-themes-and-colors)
- [Scripts](#scripts)
  - [Nix/NixOs shortcuts](#nixnixos-shortcuts)
  - [Brightness control](#brightness-control)
  - [Sound control](#sound-control)
  - [Caffeine](#caffeine)
  - [Night-Shift](#night-shift)
  - [Nerdfont FZF](#nerdfont-fzf)
  - [Compress/Extract](#compressextract)
- [Installation/build](#installationbuild)

## Gallery

![neofetch](https://image.nostr.build/c208c164ae04e4c58e01adb9fab584b163a565155865833851275f89c9270b7a.jpg)
![qutebrowser](https://image.nostr.build/8cc32d981e6be256bdc37a2571c31bb76d7c3335ce7c76fa6eca89a03019bfc9.jpg)
![spotify](https://image.nostr.build/76b18bcbcdf1d911a2dbdff7bfac6652044d45602a3dce9d9c53feb295d13245.jpg)
![wofi](https://image.nostr.build/90d69ffe6251c17e25b0fb44abadaeb0dfe6db8210d935fca14bf8b00be49fa6.jpg)

## Architechture

- `home` are the dotfiles and configuration files for the user
- `hosts` are the system configuration files
  - `laptop` is mine
  - `guest` is a template for you
  - `themes` contains all the themes available (you can create your own)
  - `shared` are some nix files that you can import (nvidia, prime, fonts, ...)
- `secrets` are the secrets files encrypted with sops

<details>
<summary>Click to show installed apps</summary>

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

</details>

## Settings, Themes and colors

In your hosts configuration, you should add a `variables.nix` file to manage your settings, including:

- user information
- timezone and locale
- keyboard layout
- the theme: will be used in programs and for GTK and QT themes
- ... (check the `hosts/guest/variables.nix` file for more information)

PS: To apply the theme to duckduckgo, follow the instructions in `$HOME/.duckduckgo-colorscheme.js`.

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

### Nerdfont FZF

<details>
<summary>Click to expand</summary>

Nerdfont fzf is a quick way to search for nerdfont icons locally.
It will copy the selected icon to the clipboard.

- `nerdfont-fzf`

</details>

### Compress/Extract

<details>
<summary>Click to expand</summary>

Some shortcut to compress and extract files.

- `compress` ...
- `extract` ...

</details>

## Installation/build

```sh
git clone https://github.com/anotherhadi/nixy ~/.config/nixos
```

*let me cook this*
- Change the username in the flake.nix file
- import your hardware-configuration.nix into the `hosts/guest` folder

```sh
sudo nixos-rebuild switch --flake ~/.config/nixos#nixy
```

## Contribute

Feel free to contribute to this project by opening an issue or a pull request.
