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
            tunnelId = "a1dfa315-7fc3-4a65-8c02-8387932c35c3";
            networkInterface = "enp3s0";
          };
        };
      }

      # System
      systemd-boot
      amd-graphics

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
