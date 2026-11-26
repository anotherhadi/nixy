{
  aspects,
  inputs,
  ...
}: {
  flake.nixosConfigurations.jack = inputs.nixpkgs.lib.nixosSystem {
    modules = with aspects; [
      base

      {
        networking.hostName = "jack";
        nixy = {
          username = "hadi";
          git = {
            name = "Hadi";
            email = "112569860+anotherhadi@users.noreply.github.com";
          };
          server = {
            domain = "hadi.icu";
            networkInterface = "enp3s0";
          };
        };
      }

      # System
      systemd-boot
      amd-graphics
      netbird

      # Services
      homelab # see modules/bundles.nix

      # Programs
      tui # shell, git, nvim, cybersecurity...
      git-signing # CHANGEME: Change the key or remove this line

      # Host-specific
      ./_configuration.nix
    ];
  };
}
