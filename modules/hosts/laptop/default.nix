# Laptop (HP Omen 16)
{
  aspects,
  inputs,
  ...
}: {
  flake.nixosConfigurations.h-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = with aspects; [
      base # common, secrets, theme, hjem, nix, users... (see modules/bundles.nix)

      # Host values (modules/hosts/common.nix)
      {
        networking.hostName = "h-laptop";
        nixy = {
          username = "hadi";
          git = {
            name = "Hadi";
            email = "112569860+anotherhadi@users.noreply.github.com";
          };
        };
      }

      inputs.nixos-hardware.nixosModules.omen-16-n0005ne
      inputs.disko.nixosModules.disko

      # System
      impermanence
      nvidia # CHANGEME: Remove this line if you don't have an Nvidia GPU
      audio
      bluetooth
      fonts
      lanzaboote # CHANGEME: Replace with systemd-boot if you don't want to setup secure boot
      usbguard # Rules in ./_configuration.nix

      # Desktop
      tuigreet
      autologin # Skip first TUIGreet login, use LUKS password to unlock the keyring
      gui # hyprland, desktop, helium, gui-apps

      # Programs
      tui # shell, git, nvim, cybersecurity... (see modules/bundles.nix)
      git-signing # CHANGEME: Change the key or remove this line
      steam
      ollama

      # Host-specific (plain NixOS modules, "_" keeps import-tree away)
      ./_disko.nix
      ./_configuration.nix
    ];
  };
}
