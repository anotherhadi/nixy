<h1 align="center">
   <img src="https://image.nostr.build/70ebe2b5183879d8c0ffa682cd0089e030ad01909678b242ed86449517eac3a5.png" width="100px" />
   <br>
      Nixy
   <br>
    <img src="https://image.nostr.build/aaf8cf0f3b9784c817f8cf328f19222db2e1886dfb89ae97de83ffa101d437b4.png" width="600px" /> <br>
   <div align="center">

   <div align="center">
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

{md_table_of_content}

## Gallery

![neofetch](https://image.nostr.build/c208c164ae04e4c58e01adb9fab584b163a565155865833851275f89c9270b7a.jpg)
![qutebrowser](https://image.nostr.build/8cc32d981e6be256bdc37a2571c31bb76d7c3335ce7c76fa6eca89a03019bfc9.jpg)
![spotify](https://image.nostr.build/76b18bcbcdf1d911a2dbdff7bfac6652044d45602a3dce9d9c53feb295d13245.jpg)
![wofi](https://image.nostr.build/90d69ffe6251c17e25b0fb44abadaeb0dfe6db8210d935fca14bf8b00be49fa6.jpg)

## Architecture

- `home` are the dotfiles and configuration files for the user
- `hosts` are the system configuration files
  - `laptop` is mine
  - `guest` is a template for you
  - `themes` contains all the themes available (you can create your own)
  - `shared` are some nix files that you can import (nvidia, prime, fonts, ...)
- `secrets` are the secrets files encrypted with sops

## Installation/build

```sh
git clone https://github.com/anotherhadi/nixy ~/.config/nixos
```

- Change the username in the flake.nix file
- import the guest configuration instead of the `hosts/laptop` one
- import your hardware-configuration.nix into the `hosts/guest` folder

```sh
sudo nixos-rebuild switch --flake ~/.config/nixos#nixy
```

## Contribute

Feel free to contribute to this project by opening an issue or a pull request.
