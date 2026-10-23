# Work laptop
{
  aspects,
  inputs,
  ...
}: {
  flake.nixosConfigurations.h-work = inputs.nixpkgs.lib.nixosSystem {
    modules = with aspects; [
      base # common, secrets, theme, hjem, nix, users... (see modules/bundles.nix)

      # Host values (modules/hosts/common.nix)
      {
        networking.hostName = "h-work";
        nixy = {
          username = "hadrien";
          git = {
            name = "Hadi";
            email = "112569860+anotherhadi@users.noreply.github.com";
          };
        };
      }

      inputs.disko.nixosModules.disko

      # System
      impermanence
      audio
      fonts
      systemd-boot
      vulnix
      usbguard # Rules in ./_configuration.nix

      # Desktop
      tuigreet
      autologin # Skip first TUIGreet login, use LUKS password to unlock the keyring
      gui # sway, desktop, helium, gui apps

      # Programs
      tui # shell, git, nvim, cybersecurity... (see modules/bundles.nix)

      # Host-specific (plain NixOS modules, "_" keeps import-tree away)
      ./_disko.nix
      ./_configuration.nix
    ];
  };
}
