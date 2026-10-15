# Work laptop
{
  aspects,
  inputs,
  ...
}: {
  flake.nixosConfigurations.h-work = inputs.nixpkgs.lib.nixosSystem {
    modules = with aspects; [
      common
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

      inputs.sops-nix.nixosModules.sops
      inputs.disko.nixosModules.disko

      # System
      impermanence
      audio
      fonts
      theme
      hjem
      nix
      systemd-boot
      users
      networking
      locale
      cli-base
      kernel-hardening
      vulnix

      # Desktop
      tuigreet
      autologin # Skip first TUIGreet login, use LUKS password to unlock the keyring
      gui # hyprland, desktop, helium, gui-apps

      # Programs
      tui # shell, git, nvim, cybersecurity... (see modules/bundles.nix)

      # Host-specific (plain NixOS modules, "_" keeps import-tree away)
      ./_disko.nix
      ./_configuration.nix
    ];
  };
}
