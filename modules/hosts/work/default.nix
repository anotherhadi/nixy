# Work laptop
{
  aspects,
  inputs,
  ...
}: {
  flake.nixosConfigurations.h-work = inputs.nixpkgs.lib.nixosSystem {
    modules = with aspects; [
      base

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
      usbguard # Rules in ./_configuration.nix

      # Desktop
      tuigreet
      autologin # Skip first TUIGreet login, use LUKS password to unlock the keyring
      gui # sway, desktop, helium, gui apps

      # Programs
      tui # shell, git, nvim, cybersecurity...

      # Host-specific
      ./_disko.nix
      ./_configuration.nix
    ];
  };
}
